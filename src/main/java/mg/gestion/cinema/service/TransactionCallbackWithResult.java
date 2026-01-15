package mg.gestion.cinema.service;

import java.sql.Connection;


@FunctionalInterface
public interface TransactionCallbackWithResult<T> {
        T execute(Connection connection) throws Exception;

}
