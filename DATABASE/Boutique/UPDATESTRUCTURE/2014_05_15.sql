-- Добавить у проводок тип документа
DO $$ 
    BEGIN

      IF NOT (EXISTS(SELECT c.relname 
                       FROM pg_catalog.pg_class AS c 
                  LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
                      WHERE c.relkind = 'i' AND n.nspname NOT IN ('pg_catalog', 'pg_toast')
                        AND c.relname = lower('idx_ObjectHistoryString_ValueData_DescId_ObjectHistoryId'))) THEN
             CREATE INDEX idx_ObjectHistoryString_ValueData_DescId_ObjectHistoryId ON ObjectHistoryString (ValueData, DescId, ObjectHistoryId);
      END IF;
      IF NOT (EXISTS(SELECT c.relname 
                       FROM pg_catalog.pg_class AS c 
                  LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
                      WHERE c.relkind = 'i' AND n.nspname NOT IN ('pg_catalog', 'pg_toast')
                        AND c.relname = lower('idx_ObjectString_ValueData_DescId_ObjectId'))) THEN
             CREATE INDEX idx_ObjectString_ValueData_DescId_ObjectId ON ObjectString (ValueData, DescId, ObjectId);
      END IF;

    END;
$$;