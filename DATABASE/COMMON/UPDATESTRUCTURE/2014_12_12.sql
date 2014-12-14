DO $$ 
    BEGIN
        -- !!!ReportContainerLink!!!
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('ReportContainerLink') AND Column_Name = lower('ChildContainerId')))
        OR NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('ReportContainerLink') AND Column_Name = lower('ChildAccountId')))
        THEN

            ALTER TABLE ReportContainerLink ADD COLUMN ChildContainerId Integer;
            ALTER TABLE ReportContainerLink ADD COLUMN ChildAccountId Integer;
            
            UPDATE ReportContainerLink SET ChildContainerId = ReportContainerLink2.ContainerId
                                         , ChildAccountId = ReportContainerLink2.AccountId
            FROM ReportContainerLink AS ReportContainerLink2
            WHERE ReportContainerLink2.ReportContainerId = ReportContainerLink.ReportContainerId
              AND ReportContainerLink2.AccountKindId <> ReportContainerLink.AccountKindId;


            ALTER TABLE ReportContainerLink ALTER COLUMN ChildContainerId SET NOT NULL;
            ALTER TABLE ReportContainerLink ALTER COLUMN ChildAccountId SET NOT NULL;
        END IF;

    END;
$$;