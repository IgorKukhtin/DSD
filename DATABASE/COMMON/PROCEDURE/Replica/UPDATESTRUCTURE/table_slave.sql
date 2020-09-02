DO $$ 
    BEGIN
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name ILIKE ('table_slave') AND Column_Name ILIKE ('start_id'))) THEN
            ALTER TABLE _replica.table_slave ADD COLUMN start_id BigInt;
        END IF;

    END;

$$;