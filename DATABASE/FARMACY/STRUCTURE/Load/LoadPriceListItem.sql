/*
  Создание 
    - таблицы LoadPriceListItem (промежуточная таблица загрузки)
    - связей
    - индексов
*/

-- Table: Movement

-- DROP TABLE LoadPriceListItem;

/*-------------------------------------------------------------------------------*/
CREATE TABLE LoadPriceListItem
(
  Id              serial        NOT NULL PRIMARY KEY,
  GoodsCode       TVarChar , -- Код товара поставщика
  GoodsName	  TVarChar , -- Наименование товара поставщика
  GoodsNDS	  TVarChar, -- НДС товара
  GoodsId         Integer  , -- Товары
  LoadPriceListId Integer  , -- Ссылка на прайс-лист
  Price           TFloat   , -- Цена
  ExpirationDate  TDateTime, -- Срок годности
  CONSTRAINT fk_LoadPriceListItem_LoadMovementId FOREIGN KEY (LoadPriceListId)  REFERENCES LoadPriceList (id),
  CONSTRAINT fk_LoadPriceListItem_GoodsId        FOREIGN KEY (GoodsId)          REFERENCES Object (id))
WITH (
  OIDS=FALSE
);

ALTER TABLE LoadPriceListItem
  OWNER TO postgres;
 
CREATE INDEX idx_LoadPriceListItem_LoadPriceListId ON LoadPriceListItem(LoadPriceListId);
CREATE INDEX idx_LoadPriceListItem_GoodsId         ON LoadPriceListItem(GoodsId); 


/*-------------------------------------------------------------------------------*/



/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
*/
