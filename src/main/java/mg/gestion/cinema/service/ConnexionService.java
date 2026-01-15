package mg.gestion.cinema.service;

import java.sql.Connection;
import java.sql.SQLException;

import org.springframework.stereotype.Service;

import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import mg.gestion.cinema.utils.ConnexionManager;
import mg.gestion.cinema.utils.ManagedConnection;


@Service
public class ConnexionService {
    private ConnexionManager manager;

    @PostConstruct
    public void init(){
        String url = "jdbc:postgresql://localhost:5432/gestion_cinema";
        String username = "postgres";
        String password = "admin";
        manager = ConnexionManager.getInstance(url, username, password);
    }

    public Connection getConnection() throws SQLException {
        return manager.getConnection();
    }

    public ManagedConnection getManagedConnection() throws SQLException {
        return new ManagedConnection(getConnection(), manager);
    }

    public void executeInTransaction(TransactionCallback callback) throws Exception {
        try (ManagedConnection managed = getManagedConnection()) {
            Connection conn = managed.getConnection();
            try {
                conn.setAutoCommit(false);
                callback.execute(conn);
                conn.commit();
            } catch (Exception e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }
    public <T> T executeInTransaction(TransactionCallbackWithResult<T> callback) throws Exception {
        try (ManagedConnection managed = getManagedConnection()) {
            Connection conn = managed.getConnection();
            try {
                conn.setAutoCommit(false);
                T result = callback.execute(conn);
                conn.commit();
                return result;
            } catch (Exception e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public boolean releaseConnection(Connection connection) {
        return manager.releaseConnection(connection);
    }

    @PreDestroy
    public void cleanup() {
        try {
            manager.shutdown();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public int getAvailableConnections() {
        return manager.getAvailableConnectionsCount();
    }


    public int getUsedConnections() {
        return manager.getUsedConnectionsCount();
    }


    public int getTotalConnections() {
        return manager.getTotalConnections();
    }
}


