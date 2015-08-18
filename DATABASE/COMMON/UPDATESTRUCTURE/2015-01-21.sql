-- Добавить 
DO $$ 
    BEGIN

      IF NOT (EXISTS(SELECT c.relname 
                       FROM pg_catalog.pg_class AS c 
                  LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
                      WHERE c.relkind = 'i' AND n.nspname NOT IN ('pg_catalog', 'pg_toast')
                        AND c.relname = lower('idx_Object_ObjectCode_DescId'))) THEN
             CREATE INDEX idx_Object_ObjectCode_DescId ON Object (ObjectCode, DescId);
      END IF;
    END;
$$;