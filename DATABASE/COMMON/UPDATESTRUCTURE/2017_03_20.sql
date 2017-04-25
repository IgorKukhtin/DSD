DO $$ 
    BEGIN
      DROP INDEX IF EXISTS idx_MovementItemString_DescId_ValueData;
      IF NOT (EXISTS(SELECT c.relname 
                       FROM pg_catalog.pg_class AS c 
                  LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
                      WHERE c.relkind = 'i' AND n.nspname NOT IN ('pg_catalog', 'pg_toast')
                        AND c.relname = lower('idx_MovementItemString_DescId_ValueData'))) THEN
             CREATE INDEX idx_MovementItemString_DescId_ValueData ON MovementItemString (ValueData, DescId);
      END IF;
    END;
$$;
