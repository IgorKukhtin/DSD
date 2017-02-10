DO $$ 
    BEGIN

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('Sale1C') AND Column_Name = lower('BranchId'))) THEN
            ALTER TABLE Sale1C ADD COLUMN BranchId Integer;
            UPDATE Sale1C SET BranchId = zfGetBranchFromUnitId (Sale1C.UnitId);
            ALTER TABLE Sale1C ALTER COLUMN BranchId SET NOT NULL;
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('Sale1C') AND Column_Name = lower('BranchId_Link'))) THEN
            ALTER TABLE Sale1C ADD COLUMN BranchId_Link Integer;
            UPDATE Sale1C SET BranchId_Link = zfGetBranchLinkFromBranchPaidKind (BranchId, zfGetPaidKindFrom1CType(Sale1C.VidDoc));
            ALTER TABLE Sale1C ALTER COLUMN BranchId_Link SET NOT NULL;
        END IF;
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('Sale1C') AND Column_Name = lower('PaidKindId'))) THEN
            ALTER TABLE Sale1C ADD COLUMN PaidKindId Integer;
            UPDATE Sale1C SET PaidKindId = zfGetPaidKindFrom1CType (Sale1C.VidDoc);
            ALTER TABLE Sale1C ALTER COLUMN PaidKindId SET NOT NULL;
        END IF;


        IF NOT (EXISTS(SELECT c.relname 
                         FROM pg_catalog.pg_class AS c 
                    LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
                        WHERE c.relkind = 'i' AND n.nspname NOT IN ('pg_catalog', 'pg_toast')
                          AND c.relname = lower('idx_Sale1C_OperDate_BranchId'))) THEN
               CREATE INDEX idx_Sale1C_OperDate_BranchId ON Sale1C (OperDate,BranchId);
        END IF;

        IF NOT (EXISTS(SELECT c.relname 
                         FROM pg_catalog.pg_class AS c 
                    LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
                        WHERE c.relkind = 'i' AND n.nspname NOT IN ('pg_catalog', 'pg_toast')
                          AND c.relname = lower('idx_Sale1C_OperDate_BranchId_Link'))) THEN
               CREATE INDEX idx_Sale1C_OperDate_BranchId_Link ON Sale1C (OperDate,BranchId_Link);
        END IF;

    END;
$$;
