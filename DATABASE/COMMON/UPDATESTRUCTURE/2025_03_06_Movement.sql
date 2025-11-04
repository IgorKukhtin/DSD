DO $$ 
    BEGIN
        -- !!!
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name ILIKE 'Movement' AND Column_Name ILIKE 'StatusId_next')) THEN
            ALTER TABLE Movement ADD COLUMN StatusId_next Integer;
        END IF;
        -- !!!
    END;
$$;
