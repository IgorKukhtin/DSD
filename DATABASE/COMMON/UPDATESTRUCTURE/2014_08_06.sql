DO $$ 
    BEGIN
        -- !!!Container!!!
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('Container') AND Column_Name = lower('KeyValue'))) THEN
            ALTER TABLE Container ADD COLUMN KeyValue TVarChar;
            UPDATE Container SET KeyValue = '';
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('Container') AND Column_Name = lower('MasterKeyValue'))) THEN
            ALTER TABLE Container ADD COLUMN MasterKeyValue BigInt;
            UPDATE Container SET MasterKeyValue = 0;
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('Container') AND Column_Name = lower('ChildKeyValue'))) THEN
            ALTER TABLE Container ADD COLUMN ChildKeyValue BigInt;
            UPDATE Container SET ChildKeyValue = 0;
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
        END IF;

        /*IF NOT (EXISTS(SELECT c.relname 
                         FROM pg_catalog.pg_class AS c 
                    LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
                        WHERE c.relkind = 'i' AND n.nspname NOT IN ('pg_catalog', 'pg_toast')
                          AND c.relname = lower('idx_ContainerObjectCost_KeyValue'))) THEN
               CREATE INDEX idx_ContainerObjectCost_KeyValue ON ContainerObjectCost (KeyValue);
        END IF;*/
        IF NOT (EXISTS(SELECT c.relname 
                         FROM pg_catalog.pg_class AS c 
                    LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
                        WHERE c.relkind = 'i' AND n.nspname NOT IN ('pg_catalog', 'pg_toast')
                          AND c.relname = lower('idx_ContainerObjectCost_MasterKeyValue_ChildKeyValue'))) THEN
               CREATE INDEX idx_ContainerObjectCost_MasterKeyValue_ChildKeyValue ON ContainerObjectCost (MasterKeyValue,ChildKeyValue);
        END IF;



        -- !!!ChildReportContainerLink!!!
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('ChildReportContainerLink') AND Column_Name = lower('KeyValue'))) THEN
            ALTER TABLE ChildReportContainerLink ADD COLUMN KeyValue TVarChar;
            UPDATE ChildReportContainerLink SET KeyValue = '';
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('ChildReportContainerLink') AND Column_Name = lower('MasterKeyValue'))) THEN
            ALTER TABLE ChildReportContainerLink ADD COLUMN MasterKeyValue BigInt;
            UPDATE ChildReportContainerLink SET MasterKeyValue = 0;
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('ChildReportContainerLink') AND Column_Name = lower('ChildKeyValue'))) THEN
            ALTER TABLE ChildReportContainerLink ADD COLUMN ChildKeyValue BigInt;
            UPDATE ChildReportContainerLink SET ChildKeyValue = 0;
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