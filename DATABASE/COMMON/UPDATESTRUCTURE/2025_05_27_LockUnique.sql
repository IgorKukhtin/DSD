DO $$ 
    BEGIN
        -- !!!PeriodClose!!!
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('LockUnique') AND Column_Name ILIKE 'Comment')) THEN
            ALTER TABLE LockUnique ADD COLUMN Comment TVarChar;
        END IF;
    END;
$$;
