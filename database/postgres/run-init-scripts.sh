#!/bin/bash
set -euo pipefail

PGDATA="${PGDATA:-/var/lib/postgresql/data}"
REINIT="${REINIT_DB_ON_START:-true}"

# If configured, wipe PGDATA to force a full reinitialisation on every container start
if [ "${REINIT}" = "true" ] || [ "${REINIT}" = "1" ]; then
  echo "Reinitialising PostgreSQL data directory (${PGDATA}) on container start..."
  if [ -d "${PGDATA}" ]; then
    echo "Removing contents of ${PGDATA} ..."
    rm -rf "${PGDATA}"/* || true
    rm -rf "${PGDATA}"/.[!.]* 2>/dev/null || true
  fi
  SKIPPED_MANUAL_INIT=1
else
  SKIPPED_MANUAL_INIT=0
fi

# Start Postgres (using the official entrypoint) in background
# /docker-entrypoint.sh postgres &
/usr/local/bin/docker-entrypoint.sh postgres &

# wait for Postgres to accept connections
until psql -v ON_ERROR_STOP=1 -U "${POSTGRES_USER:-postgres}" -d "${POSTGRES_DB:-postgres}" -c '\q' >/dev/null 2>&1; do
  echo "Waiting for Postgres to be ready..."
  sleep 1
done

# If we reinitialised PGDATA then the official entrypoint already executed the scripts during init;
# run manual execution only when we did NOT force reinit (keeps behavior of applying scripts on every start).
if [ "${SKIPPED_MANUAL_INIT}" -eq 0 ]; then
  if compgen -G "/docker-entrypoint-initdb.d/*" > /dev/null; then
    echo "Executing scripts in /docker-entrypoint-initdb.d ..."
    for f in /docker-entrypoint-initdb.d/*; do
      case "${f}" in
        *.sh)
          echo "Running shell script: ${f}";
          . "${f}" ;;
        *.sql)
          echo "Running SQL file: ${f}";
          psql -v ON_ERROR_STOP=1 -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" -f "${f}" ;;
        *.sql.gz)
          echo "Running gzipped SQL file: ${f}";
          gunzip -c "${f}" | psql -v ON_ERROR_STOP=1 -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" ;;
        *)
          echo "Ignoring ${f}" ;;
      esac
    done
  else
    echo "No initialization scripts found in /docker-entrypoint-initdb.d"
  fi
else
  echo "Initialization handled by official entrypoint after PGDATA reinit — skipping manual script execution."
fi

# Keep container running by waiting on child processes (Postgres)
wait
