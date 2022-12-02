DO $$ 
    BEGIN
        -- !!!
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name ILIKE 'RemainsOLAPTable' AND Column_Name ILIKE 'SummStart')) THEN
            ALTER TABLE RemainsOLAPTable ADD COLUMN SummStart TFloat;
        END IF;
        -- !!!
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name ILIKE 'RemainsOLAPTable' AND Column_Name ILIKE 'SummEnd')) THEN
            ALTER TABLE RemainsOLAPTable ADD COLUMN SummEnd TFloat;
        END IF;

    END;
$$;
