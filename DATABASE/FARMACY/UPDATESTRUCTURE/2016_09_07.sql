DO $$ 
    BEGIN
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('CashSessionSnapShot') AND Column_Name = lower('MinExpirationDate'))) THEN
            ALTER TABLE CashSessionSnapShot ADD COLUMN MinExpirationDate TDateTime;
        END IF;
        
    END;
$$;