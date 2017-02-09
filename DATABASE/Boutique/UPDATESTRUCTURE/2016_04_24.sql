DO $$ 
    BEGIN
        -- !!!PeriodClose!!!
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('PeriodClose') AND Column_Name = lower('Name'))) THEN
            ALTER TABLE PeriodClose ADD COLUMN Name TVarChar;
            ALTER TABLE PeriodClose ADD COLUMN Code Integer;
            ALTER TABLE PeriodClose ADD COLUMN DescId Integer;
            ALTER TABLE PeriodClose ADD COLUMN DescId_excl Integer;
            ALTER TABLE PeriodClose ADD COLUMN BranchId Integer;
            ALTER TABLE PeriodClose ADD COLUMN PaidKindId Integer;
            ALTER TABLE PeriodClose ADD COLUMN UserId_excl Integer;
            ALTER TABLE PeriodClose ADD COLUMN CloseDate_excl TDateTime;
            ALTER TABLE PeriodClose ADD COLUMN OperDate TDateTime;
        END IF;
    END;
$$;
