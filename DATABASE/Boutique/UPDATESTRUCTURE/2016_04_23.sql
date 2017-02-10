DO $$ 
    BEGIN
        -- !!!MovementItemContainer!!!
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('MovementItemContainer') AND Column_Name = lower('AccountId_Analyzer'))) THEN
            ALTER TABLE MovementItemContainer ADD COLUMN AccountId_Analyzer Integer;

            /*
            UPDATE MovementItemContainer SET AccountId_Analyzer = Container.ObjectId
            FROM Container
            WHERE MovementItemContainer.ContainerId_Analyzer = Container.Id
              AND MovementItemContainer.DescId = zc_MIContainer_Summ()
              AND MovementItemContainer.AccountId_Analyzer IS NULL
              AND MovementItemContainer.OperDate BETWEEN '01.01.2014' AND '01.01.2016'
           ;*/

        END IF;
    END;
$$;
