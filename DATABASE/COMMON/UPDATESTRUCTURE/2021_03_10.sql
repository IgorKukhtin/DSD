DO $$ 
    BEGIN
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name ILIKE 'SoldTable' AND Column_Name ILIKE 'PaidKindId_bonus')) THEN
            ALTER TABLE SoldTable ADD COLUMN PaidKindId_bonus Integer;
            UPDATE SoldTable SET PaidKindId_bonus = 0;
            ALTER TABLE SoldTable ALTER COLUMN PaidKindId_bonus SET NOT NULL;
        END IF;

    END;
$$;


