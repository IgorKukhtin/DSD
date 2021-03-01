/*
  Создание 
    - таблицы Object_PartionGoods (oбъекты)
    - связей
    - индексов
*/
-- drop TABLE Object_PartionGoods

/*-------------------------------------------------------------------------------*/

CREATE TABLE Object_PartionGoods(
   MovementItemId      Integer NOT NULL PRIMARY KEY, 
   MovementId          Integer NOT NULL,
   MovementDescId      Integer NOT NULL, -- Вид документа: Приход или Производство-комплектация
   FromId              Integer ,         -- Поставщик или Подразделение (место сборки)
   UnitId              Integer ,         -- Подразделение (куда приход)
   OperDate            TDateTime,        -- Дата
   ObjectId            Integer NOT NULL,         -- Комплектующие или Лодка
   Amount              TFloat  NOT NULL, -- Кол-во Приход
   EKPrice	       TFloat  NOT NULL, -- Цена вх. без НДС
   CountForPrice       TFloat  NOT NULL DEFAULT 1, -- для Цены вх. без НДС
   EmpfPrice	       TFloat  NOT NULL, -- Цена рекоменд. без НДС
   OperPriceList       TFloat  NOT NULL, -- Цена по прайсу без НДС
   GoodsGroupId        Integer,
   GoodsTagId          Integer,
   GoodsTypeId         Integer, 
   GoodsSizeId         Integer, 
   ProdColorId         Integer, 
   MeasureId           Integer,
   TaxKindId           Integer NOT NULL, 
   TaxValue            TFloat  NOT NULL, 
   isErased            Boolean NOT NULL DEFAULT FALSE,
   isArc               Boolean NOT NULL DEFAULT FALSE
  );
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE INDEX idx_Object_PartionGoods_MovementItemId ON Object_PartionGoods (MovementItemId);
CREATE INDEX idx_Object_PartionGoods_MovementId	    ON Object_PartionGoods (MovementId);
CREATE INDEX idx_Object_PartionGoods_MovementDescId ON Object_PartionGoods (MovementDescId);
CREATE INDEX idx_Object_PartionGoods_FromId   ON Object_PartionGoods (FromId);
CREATE INDEX idx_Object_PartionGoods_UnitId   ON Object_PartionGoods (UnitId);
CREATE INDEX idx_Object_PartionGoods_ObjectId ON Object_PartionGoods (ObjectId);

/*-------------------------------------------------------------------------------
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
01.03.21                                         *
*/
