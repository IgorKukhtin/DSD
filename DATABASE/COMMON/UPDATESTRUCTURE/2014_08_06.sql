DO $$ 
    BEGIN
        -- !!!Container!!!
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('Container') AND Column_Name = lower('KeyValue'))) THEN
            ALTER TABLE Container ADD COLUMN KeyValue TVarChar;
            UPDATE Container SET KeyValue = '';
            ALTER TABLE Container ALTER COLUMN KeyValue SET NOT NULL;
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('Container') AND Column_Name = lower('MasterKeyValue'))) THEN
            ALTER TABLE Container ADD COLUMN MasterKeyValue BigInt;
            UPDATE Container SET MasterKeyValue = 0;
            ALTER TABLE Container ALTER COLUMN MasterKeyValue SET NOT NULL;
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('Container') AND Column_Name = lower('ChildKeyValue'))) THEN
            ALTER TABLE Container ADD COLUMN ChildKeyValue BigInt;
            UPDATE Container SET ChildKeyValue = 0;
            ALTER TABLE Container ALTER COLUMN ChildKeyValue SET NOT NULL;
        END IF;
        
        /*IF NOT (EXISTS(SELECT c.relname 
                         FROM pg_catalog.pg_class AS c 
                    LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
                        WHERE c.relkind = 'i' AND n.nspname NOT IN ('pg_catalog', 'pg_toast')
                          AND c.relname = lower('idx_Container_KeyValue'))) THEN
               CREATE INDEX idx_Container_KeyValue ON Container (KeyValue);
        END IF;*/
        IF NOT (EXISTS(SELECT c.relname 
                         FROM pg_catalog.pg_class AS c 
                    LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
                        WHERE c.relkind = 'i' AND n.nspname NOT IN ('pg_catalog', 'pg_toast')
                          AND c.relname = lower('idx_Container_MasterKeyValue_ChildKeyValue'))) THEN
               CREATE INDEX idx_Container_MasterKeyValue_ChildKeyValue ON Container (MasterKeyValue,ChildKeyValue);
        END IF;
        
        
        -- !!!HistoryCost !!!
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('HistoryCost') AND Column_Name = lower('ContainerId'))) THEN
            ALTER TABLE HistoryCost ADD COLUMN ContainerId Integer;
            UPDATE HistoryCost SET ContainerId = ContainerObjectCost.ContainerId FROM ContainerObjectCost WHERE ContainerObjectCost.ObjectCostId = HistoryCost.ObjectCostId;

            DELETE FROM HistoryCost WHERE ContainerId IS NULL;
            ALTER TABLE HistoryCost ALTER COLUMN ContainerId SET NOT NULL;

            DROP INDEX idx_HistoryCost_ObjectCostId_StartDate_EndDate;
            CREATE UNIQUE INDEX idx_HistoryCost_ContainerId_StartDate_EndDate ON HistoryCost(ContainerId, StartDate, EndDate);

            ALTER TABLE HistoryCost DROP COLUMN ObjectCostId;
            ALTER TABLE HistoryCost ADD CONSTRAINT fk_HistoryCost_ContainerId FOREIGN KEY(ContainerId) REFERENCES Container(Id);

        END IF;

        /*
        -- !!!ContainerObjectCost!!!
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('ContainerObjectCost') AND Column_Name = lower('KeyValue'))) THEN
            ALTER TABLE ContainerObjectCost ADD COLUMN KeyValue TVarChar;
            UPDATE ContainerObjectCost SET KeyValue = '';
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('ContainerObjectCost') AND Column_Name = lower('MasterKeyValue'))) THEN
            ALTER TABLE ContainerObjectCost ADD COLUMN MasterKeyValue BigInt;
            UPDATE ContainerObjectCost SET MasterKeyValue = 0;
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('ContainerObjectCost') AND Column_Name = lower('ChildKeyValue'))) THEN
            ALTER TABLE ContainerObjectCost ADD COLUMN ChildKeyValue BigInt;
            UPDATE ContainerObjectCost SET ChildKeyValue = 0;
        END IF;*/

        /*IF NOT (EXISTS(SELECT c.relname 
                         FROM pg_catalog.pg_class AS c 
                    LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
                        WHERE c.relkind = 'i' AND n.nspname NOT IN ('pg_catalog', 'pg_toast')
                          AND c.relname = lower('idx_ContainerObjectCost_KeyValue'))) THEN
               CREATE INDEX idx_ContainerObjectCost_KeyValue ON ContainerObjectCost (KeyValue);
        END IF;
        IF NOT (EXISTS(SELECT c.relname 
                         FROM pg_catalog.pg_class AS c 
                    LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
                        WHERE c.relkind = 'i' AND n.nspname NOT IN ('pg_catalog', 'pg_toast')
                          AND c.relname = lower('idx_ContainerObjectCost_MasterKeyValue_ChildKeyValue'))) THEN
               CREATE INDEX idx_ContainerObjectCost_MasterKeyValue_ChildKeyValue ON ContainerObjectCost (MasterKeyValue,ChildKeyValue);
        END IF;*/
        

        -- !!!ReportContainerLink!!!
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('ReportContainerLink') AND Column_Name = lower('KeyValue'))) THEN
            ALTER TABLE ReportContainerLink ADD COLUMN KeyValue TVarChar;
            UPDATE ReportContainerLink SET KeyValue = '';
            ALTER TABLE ReportContainerLink ALTER COLUMN KeyValue SET NOT NULL;
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('ReportContainerLink') AND Column_Name = lower('MasterKeyValue'))) THEN
            ALTER TABLE ReportContainerLink ADD COLUMN MasterKeyValue BigInt;
            UPDATE ReportContainerLink SET MasterKeyValue = 0;
            ALTER TABLE ReportContainerLink ALTER COLUMN MasterKeyValue SET NOT NULL;
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('ReportContainerLink') AND Column_Name = lower('ChildKeyValue'))) THEN
            ALTER TABLE ReportContainerLink ADD COLUMN ChildKeyValue BigInt;
            UPDATE ReportContainerLink SET ChildKeyValue = 0;
           ALTER TABLE ReportContainerLink ALTER COLUMN ChildKeyValue SET NOT NULL;
        END IF;


        IF NOT (EXISTS(SELECT c.relname
                         FROM pg_catalog.pg_class AS c 
                    LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
                        WHERE c.relkind = 'i' AND n.nspname NOT IN ('pg_catalog', 'pg_toast')
                          AND c.relname = lower('idx_ReportContainerLink_MasterKeyValue_ChildKeyValue'))) THEN
               CREATE INDEX idx_ReportContainerLink_MasterKeyValue_ChildKeyValue ON ReportContainerLink (MasterKeyValue,ChildKeyValue);
        END IF;
   


        -- !!!ChildReportContainerLink!!!
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('ChildReportContainerLink') AND Column_Name = lower('KeyValue'))) THEN
            ALTER TABLE ChildReportContainerLink ADD COLUMN KeyValue TVarChar;
            UPDATE ChildReportContainerLink SET KeyValue = '';
            ALTER TABLE ChildReportContainerLink ALTER COLUMN KeyValue SET NOT NULL;
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('ChildReportContainerLink') AND Column_Name = lower('MasterKeyValue'))) THEN
            ALTER TABLE ChildReportContainerLink ADD COLUMN MasterKeyValue BigInt;
            UPDATE ChildReportContainerLink SET MasterKeyValue = 0;
            ALTER TABLE ChildReportContainerLink ALTER COLUMN MasterKeyValue SET NOT NULL;
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('ChildReportContainerLink') AND Column_Name = lower('ChildKeyValue'))) THEN
            ALTER TABLE ChildReportContainerLink ADD COLUMN ChildKeyValue BigInt;
            UPDATE ChildReportContainerLink SET ChildKeyValue = 0;
            ALTER TABLE ChildReportContainerLink ALTER COLUMN ChildKeyValue SET NOT NULL;
        END IF;

        /*IF NOT (EXISTS(SELECT c.relname 
                         FROM pg_catalog.pg_class AS c 
                    LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
                        WHERE c.relkind = 'i' AND n.nspname NOT IN ('pg_catalog', 'pg_toast')
                          AND c.relname = lower('idx_ChildReportContainerLink_KeyValue'))) THEN
               CREATE INDEX idx_ChildReportContainerLink_KeyValue ON ChildReportContainerLink (KeyValue);
        END IF;*/
        IF NOT (EXISTS(SELECT c.relname 
                         FROM pg_catalog.pg_class AS c 
                    LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
                        WHERE c.relkind = 'i' AND n.nspname NOT IN ('pg_catalog', 'pg_toast')
                          AND c.relname = lower('idx_ChildReportContainerLink_MasterKeyValue_ChildKeyValue'))) THEN
               CREATE INDEX idx_ChildReportContainerLink_MasterKeyValue_ChildKeyValue ON ChildReportContainerLink (MasterKeyValue,ChildKeyValue);
        END IF;


    END;
$$;