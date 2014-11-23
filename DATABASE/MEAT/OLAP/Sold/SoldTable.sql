/*
  Создание 
    - таблицы SoldTable (таблица продаж)
    - связей
    - индексов
*/


-- DROP TABLE SoldTable;

/*-------------------------------------------------------------------------------*/
CREATE TABLE SoldTable
(

   JuridicalId Integer
 , PartnerId Integer
 , ContractId Integer 
 , InfoMoneyId Integer
 , BranchId Integer

 , GoodsId Integer
 , GoodsKindId Integer
 , OperDate TDateTime
 , InvNumber TVarChar
                           
 , Sale_Summ             TFloat  
 , Sale_Amount_Weight    TFloat  
 , Sale_Amount_Sh        TFloat  

 , Return_Summ           TFloat  
 , Return_Amount_Weight  TFloat  
 , Return_Amount_Sh      TFloat  

 , Sale_AmountPartner_Weight     TFloat  
 , Sale_AmountPartner_Sh         TFloat  
 , Return_AmountPartner_Weight   TFloat  
 , Return_AmountPartner_Sh       TFloat  
)
WITH (
  OIDS=FALSE
);

ALTER TABLE SoldTable
  OWNER TO postgres;

/*                                  Индексы                                      */

CREATE INDEX idx_SoldTable_OperDate ON SoldTable(OperDate);
CREATE INDEX idx_SoldTable_JuridicalId ON SoldTable(JuridicalId);
CREATE INDEX idx_SoldTable_PartnerId ON SoldTable(PartnerId);
CREATE INDEX idx_SoldTable_ContractId ON SoldTable(ContractId);
CREATE INDEX idx_SoldTable_InfoMoneyId ON SoldTable(InfoMoneyId);
CREATE INDEX idx_SoldTable_BranchId ON SoldTable(BranchId);
CREATE INDEX idx_SoldTable_GoodsId ON SoldTable(GoodsId);
CREATE INDEX idx_SoldTable_GoodsKindId ON SoldTable(GoodsKindId);


/*-------------------------------------------------------------------------------*/



/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
*/
