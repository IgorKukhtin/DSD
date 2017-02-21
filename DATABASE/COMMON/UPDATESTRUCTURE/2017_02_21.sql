DO $$ 
    BEGIN
      IF NOT (EXISTS(SELECT c.relname 
                       FROM pg_catalog.pg_class AS c 
                  LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
                      WHERE c.relkind = 'i' AND n.nspname NOT IN ('pg_catalog', 'pg_toast')
                        AND c.relname = lower('idx_ObjectProtocol_ObjectId_OperDate'))) THEN
             CREATE INDEX idx_ObjectProtocol_ObjectId_OperDate ON ObjectProtocol (ObjectId, OperDate);
      END IF;
    END;
$$;
