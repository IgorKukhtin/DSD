DO $$ 
    BEGIN
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('Object') AND Column_Name = lower('AccessKeyId'))) THEN
            ALTER TABLE Object ADD COLUMN AccessKeyId integer;
        END IF;
    END;
$$;