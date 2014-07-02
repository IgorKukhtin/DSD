/*
  Создание 
    - таблицы LoadMovementItem (промежуточная таблица загрузки)
    - связей
    - индексов
*/

-- Table: Movement

-- DROP TABLE LoadMovement;

/*-------------------------------------------------------------------------------*/
CREATE TABLE LoadMovementItem
(
  Id             serial    NOT NULL PRIMARY KEY,
  GoodsCode      TVarChar, -- Код товара поставщика
  GoodsName	 TVarChar, -- Наименование товара поставщика
  GoodsId        Integer,  -- Товары
  LoadMovementId Integer,  -- Ссылка на документ LoadMovement
  Amount         TFloat,   -- Количество
  PackageAmount  TFloat,   -- Количество в упаковке
  Price          TFloat,   -- Цена
  Summ           TFloat,   -- Сумма
  ExpirationDate TDateTime,-- Срок годности
  CONSTRAINT fk_LoadMovementItem_LoadMovementId FOREIGN KEY (LoadMovementId)  REFERENCES LoadMovement (id),
  CONSTRAINT fk_LoadMovementItem_GoodsId        FOREIGN KEY (GoodsId)         REFERENCES Object (id))
WITH (
  OIDS=FALSE
);

ALTER TABLE LoadMovementItem
  OWNER TO postgres;
 
CREATE INDEX idx_LoadMovementItem_LoadMovementId ON LoadMovementItem(LoadMovementId);
CREATE INDEX idx_LoadMovementItem_GoodsId        ON LoadMovementItem(GoodsId); 


/*-------------------------------------------------------------------------------*/



/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
*/
