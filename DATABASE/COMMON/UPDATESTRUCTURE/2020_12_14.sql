DO $$ 
    BEGIN

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name ILIKE 'SoldTable' AND Column_Name ILIKE 'ContractConditionKindId')) THEN
            ALTER TABLE SoldTable ADD COLUMN ContractConditionKindId Integer;
            UPDATE SoldTable SET ContractConditionKindId = 0;
        END IF;

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name ILIKE 'SoldTable' AND Column_Name ILIKE 'BonusKindId')) THEN
            ALTER TABLE SoldTable ADD COLUMN BonusKindId Integer;
            UPDATE SoldTable SET BonusKindId = 0;
        END IF;

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name ILIKE 'SoldTable' AND Column_Name ILIKE 'BonusTax')) THEN
            ALTER TABLE SoldTable ADD COLUMN BonusTax TFloat;
            UPDATE SoldTable SET BonusTax = 0;
        END IF;

    END;
$$;


