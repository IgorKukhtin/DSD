/*
  Создание 
    - таблицы Movement_WeighingProduction
    - связей
    - индексов
*/

-- DROP TABLE Movement_WeighingProduction

/*-------------------------------------------------------------------------------*/

CREATE TABLE Movement_WeighingProduction(
   Id                  BIGSERIAL NOT NULL PRIMARY KEY, 
   InvNumber           TVarChar  NOT NULL,
   OperDate            TDateTime NOT NULL,
   StatusId            Integer   NOT NULL,
   StatusId_wms        Integer       NULL,
   FromId              Integer   NOT NULL,
   ToId                Integer   NOT NULL,
   GoodsTypeKindId_1   Integer   NOT NULL,
   GoodsTypeKindId_2   Integer   NOT NULL,
   GoodsTypeKindId_3   Integer   NOT NULL,
   BarCodeBoxId_1      Integer   NOT NULL,
   BarCodeBoxId_2      Integer   NOT NULL,
   BarCodeBoxId_3      Integer   NOT NULL,
   GoodsId             Integer   NOT NULL,
   GoodsKindId	       Integer   NOT NULL,
   MovementDescId      Integer   NOT NULL,
   MovementDescNumber  Integer   NOT NULL,
   PlaceNumber         Integer   NOT NULL,
   UserId              Integer   NOT NULL,
   StartWeighing       TDateTime NOT NULL,
   EndWeighing         TDateTime     NULL
   );
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

--CREATE INDEX idx_Movement_WeighingProduction_Id	  ON Movement_WeighingProduction (Id);
--CREATE INDEX idx_Movement_WeighingProduction_OperDate  ON Movement_WeighingProduction (OperDate);
--CREATE INDEX idx_Movement_WeighingProduction_FromId   ON Movement_WeighingProduction (FromId);
--CREATE INDEX idx_Movement_WeighingProduction_ToId    ON Movement_WeighingProduction (ToId);

/*-------------------------------------------------------------------------------*/
/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Фелонюк И.В.    
22.05.19                                            *
*/




