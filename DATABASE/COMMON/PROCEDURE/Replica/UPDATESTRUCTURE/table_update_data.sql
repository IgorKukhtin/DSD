DO $$ 
    BEGIN
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name ILIKE ('table_update_data') AND Column_Name ILIKE ('ParentId'))) THEN
            ALTER TABLE _replica.table_update_data ADD COLUMN ParentId BigInt;
        END IF;

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name ILIKE ('table_update_data') AND Column_Name ILIKE ('MovementId'))) THEN
            ALTER TABLE _replica.table_update_data ADD COLUMN MovementId BigInt;
        END IF;
    END;
$$;