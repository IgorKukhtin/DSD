DO $$ 
    BEGIN
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = 'Movement' And Column_Name = 'AccessKeyId')) THEN
            ALTER TABLE Movement ADD COLUMN AccessKeyId integer;
        END IF;
    END;
$$;