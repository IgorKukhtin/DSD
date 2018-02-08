/*
  Создание 
    - таблицы Object_PartionGoods (oбъекты)
    - связей
    - индексов
*/
--drop TABLE Object_PartionGoods

/*-------------------------------------------------------------------------------*/

CREATE TABLE Object_PartionGoods(
   MovementItemId      Integer NOT NULL PRIMARY KEY, 
   MovementId          Integer NOT NULL,
   SybaseId            Integer ,
   JuridicalId         Integer ,
   PartnerId           Integer ,
   UnitId              Integer ,
   OperDate            TDateTime,
   GoodsId             Integer ,
   GoodsItemId         Integer ,
   CurrencyId          Integer ,
   Amount              TFloat  NOT NULL,
   OperPrice	       TFloat  NOT NULL,
   CountForPrice       TFloat  NOT NULL DEFAULT 1,
   PriceSale           TFloat  NOT NULL,
   -- DiscountPeriod      TFloat  NOT NULL,
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
CREATE INDEX idx_Object_PartionGoods_MovementItemId ON Object_PartionGoods (MovementItemId);
CREATE INDEX idx_Object_PartionGoods_MovementId	 ON Object_PartionGoods (MovementId);
CREATE INDEX idx_Object_PartionGoods_GoodsId_PartnerId ON Object_PartionGoods (GoodsId, PartnerId);
CREATE INDEX idx_Object_PartionGoods_MovementItemId_GoodsId ON Object_PartionGoods (MovementItemId, GoodsId);
CREATE INDEX idx_Object_PartionGoods_PartnerId  ON Object_PartionGoods (PartnerId);
CREATE INDEX idx_Object_PartionGoods_BrandId    ON Object_PartionGoods (BrandId);
CREATE INDEX idx_Object_PartionGoods_PeriodYear ON Object_PartionGoods (PeriodYear);

/*-------------------------------------------------------------------------------*/
/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В. Полятыкин А.А.       Фелонюк И.В.    
10.05.17                                                               * add CountForPrice
24.04.17                                           *  add  JuridicalId
15.03.17                                           *

*/




