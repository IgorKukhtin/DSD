/*
  Создание 
    - таблицы wms_MI_Incoming
    - связей
    - индексов
*/

-- DROP TABLE wms_MI_Incoming

/*-------------------------------------------------------------------------------*/

CREATE TABLE wms_MI_Incoming(
   Id                  BIGSERIAL NOT NULL PRIMARY KEY, 
   OperDate            TDateTime NOT NULL,
   StatusId            Integer   NOT NULL,
   StatusId_wms        Integer       NULL,
   GoodsId             Integer   NOT NULL,
   GoodsKindId	       Integer   NOT NULL,
   GoodsTypeKindId     Integer   NOT NULL,
   sku_id              TVarChar  NOT NULL, -- sku_id
   sku_code            TVarChar  NOT NULL, -- sku_code
   Amount              TFloat    NOT NULL,
   RealWeight          TFloat    NOT NULL,
   PartionDate         TDateTime NOT NULL,
   InsertDate          TDateTime NOT NULL,
   UpdateDate          TDateTime     NULL
   );
/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */
CREATE INDEX idx_wms_MI_Incoming_Id                ON wms_MI_Incoming (Id);
CREATE INDEX idx_wms_MI_Incoming_OperDate          ON wms_MI_Incoming (OperDate);
CREATE INDEX idx_wms_MI_Incoming_OperDate_StatusId ON wms_MI_Incoming (OperDate, StatusId);

/*-------------------------------------------------------------------------------*/
/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.08.19                                       *
*/




