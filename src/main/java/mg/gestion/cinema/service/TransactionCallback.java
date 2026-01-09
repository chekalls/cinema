package mg.gestion.cinema.service;

import java.sql.Connection;

@FunctionalInterface
public interface TransactionCallback {
    void execute(Connection connection) throws Exception;
}