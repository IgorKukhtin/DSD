DO $$ 
    BEGIN
        -- 1
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name ILIKE ('table_update_data') AND Column_Name ILIKE ('ParentId'))) THEN
            ALTER TABLE _replica.table_update_data ADD COLUMN ParentId BigInt;
        END IF;

        -- 2
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name ILIKE ('table_update_data') AND Column_Name ILIKE ('MovementId'))) THEN
            ALTER TABLE _replica.table_update_data ADD COLUMN MovementId BigInt;
        END IF;

        -- 3
        IF NOT (EXISTS(SELECT c.relname 
                       FROM pg_catalog.pg_class AS c 
                            LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
                       WHERE c.relkind = 'i' AND n.nspname NOT IN ('pg_catalog', 'pg_toast')
                         AND c.relname ILIKE ('idx_table_update_data_transaction_id')))
        THEN
            CREATE INDEX idx_table_update_data_transaction_id ON _replica.table_update_data (transaction_id); 
        END IF;

    END;
$$;