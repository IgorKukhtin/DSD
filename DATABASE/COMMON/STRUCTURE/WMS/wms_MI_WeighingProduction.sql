/*
  Создание 
    - таблицы wms_MI_WeighingProduction (oбъекты)
    - связей
    - индексов
*/

-- DROP TABLE wms_MI_WeighingProduction
-- DELETE FROM wms_MI_WeighingProduction

/*-------------------------------------------------------------------------------*/

CREATE TABLE wms_MI_WeighingProduction(
   Id                  BIGSERIAL NOT NULL PRIMARY KEY, 
   MovementId          Integer   NOT NULL,
   ParentId            Integer       NULL,
   GoodsTypeKindId     Integer   NOT NULL,
   BarCodeBoxId        Integer   NOT NULL,
   LineCode            Integer   NOT NULL,
   Amount              TFloat    NOT NULL,
   RealWeight          TFloat    NOT NULL,
   InsertDate          TDateTime NOT NULL,
   UpdateDate          TDateTime     NULL,
   WmsCode             TVarChar  NOT NULL, -- 13-значн. Ш/К для ВМС
   sku_id              TVarChar  NOT NULL, -- sku_id
   sku_code            TVarChar  NOT NULL, -- sku_code
   PartionDate         TDateTime NOT NULL,
   StatusId_wms        Integer       NULL,
   isErased            Boolean   NOT NULL
   );
/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */
CREATE INDEX idx_wms_MI_WeighingProduction_Id	        ON wms_MI_WeighingProduction (Id);
CREATE INDEX idx_wms_MI_WeighingProduction_ParentId     ON wms_MI_WeighingProduction (ParentId);
CREATE INDEX idx_wms_MI_WeighingProduction_MovementId   ON wms_MI_WeighingProduction (MovementId);
CREATE INDEX idx_wms_MI_WeighingProduction_MovementId_StatusId_wms ON wms_MI_WeighingProduction (MovementId, StatusId_wms);

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




