DO $$ 
    BEGIN
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name ILIKE ('errors') AND Column_Name ILIKE ('step'))) THEN
            ALTER TABLE _replica.errors ADD COLUMN Step Integer;
        END IF;

    END;



$$;