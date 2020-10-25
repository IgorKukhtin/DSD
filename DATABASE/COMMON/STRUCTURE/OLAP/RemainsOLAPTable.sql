/*
  Создание 
    - таблицы RemainsOLAPTable (таблица остатков + движение)
    - связей
    - индексов
*/

-- DROP TABLE RemainsOLAPTable;

/*-------------------------------------------------------------------------------*/
CREATE TABLE RemainsOLAPTable
(
   Id                  BIGSERIAL NOT NULL PRIMARY KEY 
 , OperDate            TDateTime

 , UnitId              Integer
 , GoodsId             Integer
 , GoodsKindId         Integer
 
 , AmountStart               TFloat
 , AmountEnd                 TFloat -- ***

 , AmountIncome    TFloat
 , AmountReturnOut TFloat

 , AmountSendIn  TFloat
 , AmountSendOut TFloat

 , AmountSendOnPriceIn        TFloat
 , AmountSendOnPriceOut       TFloat
 , AmountSendOnPriceOut_10900 TFloat

 , AmountSendOnPrice_10500   TFloat
 , AmountSendOnPrice_40200   TFloat

 , AmountSale           TFloat
 , AmountSale_10500     TFloat
 , AmountSale_40208     TFloat
 , AmountSaleReal       TFloat
 , AmountSaleReal_10500 TFloat
 , AmountSaleReal_40208 TFloat

 , AmountReturnIn           TFloat
 , AmountReturnIn_40208     TFloat
 , AmountReturnInReal       TFloat
 , AmountReturnInReal_40208 TFloat

 , AmountLoss      TFloat
 , AmountInventory TFloat

 , AmountProductionIn  TFloat
 , AmountProductionOut TFloat
  )
WITH (
  OIDS=FALSE
);

ALTER TABLE RemainsOLAPTable
  OWNER TO postgres;
GRANT ALL ON ALL TABLES IN SCHEMA public TO project;


--                                  Индексы
CREATE INDEX idx_RemainsOLAPTable_OperDate ON RemainsOLAPTable (OperDate);
CREATE INDEX idx_RemainsOLAPTable_UnitId ON RemainsOLAPTable (UnitId);


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.08.19                                        * all
*/
