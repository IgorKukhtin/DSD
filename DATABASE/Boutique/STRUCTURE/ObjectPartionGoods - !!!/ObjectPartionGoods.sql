/*
  Создание 
    - таблицы Object_PartionGoods (oбъекты)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE Object_PartionGoods(
   MovementItemId      Integer NOT NULL PRIMARY KEY, 
   MovementId          Integer NOT NULL,
   SybaseId            Integer ,
   PartnerId           Integer ,
   UnitId              Integer ,
   OperDate            TDateTime,
   GoodsId             Integer ,
   GoodsItemId         Integer ,
   CurrencyId          Integer ,
   Amount              TFloat  NOT NULL,
   OperPrice	       TFloat  NOT NULL,
   PriceSale           TFloat  NOT NULL,
   BrandId             Integer ,
   PeriodId            Integer ,
   PeriodYear          Integer NOT NULL,
   FabrikaId           Integer ,
   GoodsGroupId        Integer ,
   MeasureId           Integer ,
   CompositionId       Integer ,
   GoodsInfoId         Integer ,
   LineFabricaId       Integer ,
   LabelId             Integer ,
   CompositionGroupId  Integer ,
   GoodsSizeId         Integer ,
   IsErased            Boolean NOT NULL DEFAULT FALSE,
   isArc               Boolean NOT NULL DEFAULT FALSE

   /* Связь с таблицей <ObjectDesc> - класс объекта */
 
   );
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE INDEX idx_Object_PartionGoods_MovementItemId ON Object_PartionGoods(MovementItemId);
CREATE INDEX idx_Object_PartionGoods_MovementId	 ON Object_PartionGoods(MovementId);



/*-------------------------------------------------------------------------------*/
/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В. Полятыкин А.А.
15.03.17                                           *

*/




