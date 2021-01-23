DO $$ 
    BEGIN
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name ILIKE ('clients') AND Column_Name ILIKE ('last_id_ddl'))) THEN
            ALTER TABLE _replica.clients ADD COLUMN Last_id_ddl BigInt;
        END IF;
        
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name ILIKE ('clients') AND Column_Name ILIKE ('digit_for_increment'))) THEN
            ALTER TABLE _replica.clients ADD COLUMN digit_for_increment Integer;
        END IF;
    END;
$$;