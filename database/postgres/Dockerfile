FROM postgres:17

# Copy custom entrypoint that will run SQL files on every container start
COPY run-init-scripts.sh /usr/local/bin/run-init-scripts.sh
RUN chmod +x /usr/local/bin/run-init-scripts.sh

ENTRYPOINT ["/usr/local/bin/run-init-scripts.sh"]
CMD ["postgres"]
