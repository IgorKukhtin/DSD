/*
  Создание 
    - таблицы wms_Movement_WeighingProduction
    - связей
    - индексов
*/

-- DROP TABLE wms_Movement_WeighingProduction
-- DELETE FROM wms_Movement_WeighingProduction

/*-------------------------------------------------------------------------------*/

CREATE TABLE wms_Movement_WeighingProduction(
   Id                  BIGSERIAL NOT NULL PRIMARY KEY, 
   InvNumber           TVarChar  NOT NULL,
   OperDate            TDateTime NOT NULL,
   StatusId            Integer   NOT NULL,
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
   GoodsId_link_sh     Integer       NULL, -- ***Товар (из категории "Штучный")
   GoodsKindId_link_sh Integer       NULL, -- ***Вид товара (из категории "Штучный")
   MovementDescId      Integer   NOT NULL,
   MovementDescNumber  Integer   NOT NULL,
   PlaceNumber         Integer   NOT NULL,
   UserId              Integer   NOT NULL,
   StartWeighing       TDateTime NOT NULL,
   EndWeighing         TDateTime     NULL
   );
/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */
CREATE INDEX idx_wms_Movement_WeighingProduction_Id	           ON wms_Movement_WeighingProduction (Id);
CREATE INDEX idx_wms_Movement_WeighingProduction_OperDate          ON wms_Movement_WeighingProduction (OperDate);
CREATE INDEX idx_wms_Movement_WeighingProduction_OperDate_StatusId ON wms_Movement_WeighingProduction (OperDate, StatusId);

/*-------------------------------------------------------------------------------*/
/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.19                                       *
 22.05.19         *
*/




