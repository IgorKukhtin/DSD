-- 
DO $$ 
    BEGIN
     
      IF 1=1 or NOT (EXISTS(Select table_name From INFORMATION_SCHEMA.tables Where Table_Name = lower ('_CashOperation'))) THEN
         CREATE TABLE _CashOperation
         (
          ID             Integer NOT NULL,
          CashID         Integer NOT NULL,
          OperDate       TDateTime NOT NULL,
          ClientID       Integer NOT NULL,
          SpendingID     Integer NOT NULL,
          OperSumm       TFloat NOT NULL,
          DocumentID     Integer NOT NULL,
          Remark         TVarChar NOT NULL,
          isPlat         Integer NOT NULL,
          PlatNumber     Integer NOT NULL,
          ContragentSumm TFloat NOT NULL,
          CONSTRAINT pk_CashOperation PRIMARY KEY (Id)
         );
         ALTER TABLE _CashOperation OWNER TO postgres;

         -- и еще индекс
         CREATE UNIQUE INDEX idx_CashOperation_Id ON _CashOperation (Id);
         CREATE INDEX idx_CashOperation_OperDate ON _CashOperation (OperDate);

      END IF;


      IF 1=1 or NOT (EXISTS(Select table_name From INFORMATION_SCHEMA.tables Where Table_Name = lower ('_Bill'))) THEN
         CREATE TABLE _Bill
         (
          ID             Integer NOT NULL,
          BillDate       TDateTime NOT NULL,
          BillNumber     TVarChar NOT NULL,
          BillKind       Integer NOT NULL,
          BillSumm       TFloat NOT NULL,
          FromId         Integer NOT NULL,
          ToId           Integer NOT NULL,
          isNDS          Integer NOT NULL,
          Nds            TFloat NOT NULL,
          isBlocking     Integer NOT NULL,
          isDistribution Integer ,
          ParentId       Integer ,
          isMark         Integer ,
          IncomeCheck    Integer ,
          ReturnTypeId   Integer ,
          ContragentSumm TFloat ,
          RepriceClosed  Integer ,
          ClientDate     TDateTime,
          ClientNumber   TVarChar ,
          ManagerId      Integer ,
          CONSTRAINT pk_Bill PRIMARY KEY (Id)
         );
         ALTER TABLE _Bill OWNER TO postgres;

         -- и еще индекс
         CREATE UNIQUE INDEX idx_Bill_Id ON _Bill (Id);
         CREATE INDEX idx_Bill_BillDate ON _Bill (BillDate);

      END IF;

    END;
$$;

-- DROP TABLE _CashOperation;
-- DROP TABLE _Bill;
/*
 ALTER TABLE _CashOperation RENAME CONSTRAINT pk_CashOperation TO pk_CashOperation_asb;
 ALTER TABLE _CashOperation RENAME TO _CashOperation_asb;
 ALTER TABLE _Bill RENAME CONSTRAINT pk_Bill TO pk_Bill_asb;
 ALTER TABLE _Bill RENAME TO _Bill_asb;
 ALTER INDEX idx_CashOperation_Id RENAME TO idx_CashOperation_Id_asb;
 ALTER INDEX idx_CashOperation_OperDate RENAME TO idx_CashOperation_OperDate_asb;
 ALTER INDEX idx_Bill_Id RENAME TO idx_Bill_Id_asb;
 ALTER INDEX idx_Bill_BillDate RENAME TO idx_Bill_BillDate_asb;
*/
