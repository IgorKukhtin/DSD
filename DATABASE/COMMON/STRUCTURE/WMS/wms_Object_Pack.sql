/*
  Создание 
    - таблицы wms_Object_Pack
    - связей
    - индексов
*/

-- DROP TABLE wms_Object_Pack

/*-------------------------------------------------------------------------------*/

CREATE TABLE wms_Object_Pack(
   Id                  SERIAL    NOT NULL PRIMARY KEY, 
   GoodsPropertyBoxId  Integer   NOT NULL,
   GoodsTypeKindId     Integer   NOT NULL,
   GoodsId             Integer   NOT NULL,
   GoodsKindId	       Integer   NOT NULL,
   ctn_type            TVarChar  NOT NULL, -- Тип упаковки: единичная упаковка OR коробочная упаковка
   InsertDate          TDateTime NOT NULL,
   UpdateDate          TDateTime     NULL
   );
/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */
CREATE INDEX idx_wms_Object_Pack_Id ON wms_Object_Pack (Id);
CREATE UNIQUE INDEX idx_wms_Object_Pack_GoodsPropertyBoxId_GoodsTypeKindId_ctn_type ON wms_Object_Pack (GoodsPropertyBoxId, GoodsTypeKindId, ctn_type);

/*-------------------------------------------------------------------------------*/
/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.11.19                                       *
*/
