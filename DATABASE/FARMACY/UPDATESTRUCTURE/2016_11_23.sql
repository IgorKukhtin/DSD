DO $$ 
    BEGIN
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('CashSession') AND Column_Name = lower('UserId'))) THEN
            ALTER TABLE CashSession ADD COLUMN UserId Integer;
        END IF;
        
    END;
$$;