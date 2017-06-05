/*
  Создание 
    - таблицы LoadGoodsBarCodeItem (промежуточная таблица загрузки)
    - связей
    - индексов
*/

-- Table: LoadGoodsBarCodeItem

-- DROP TABLE LoadGoodsBarCodeItem;

/*-------------------------------------------------------------------------------*/
CREATE TABLE LoadGoodsBarCodeItem
(
  Id                 serial NOT NULL,
  LoadGoodsBarCodeId Integer NOT NULL,
  GoodsJuridicalId   Integer,
  JuridicalId        Integer,
  UserId             Integer,
  OperDate           TDateTime,
  GoodsCode          TVarChar,  -- Код товара поставщика
  BarCode            TVarChar,  -- Штрих-код
  JuridicalName      TVarChar,  -- Поставщик
  CONSTRAINT pk_LoadGoodsBarCodeItem PRIMARY KEY (Id),
  CONSTRAINT fk_LoadGoodsBarCodeItem_LoadGoodsBarCodeId FOREIGN KEY (LoadGoodsBarCodeId) REFERENCES LoadGoodsBarCode (Id)
);

CREATE UNIQUE INDEX idx_LoadGoodsBarCodeItem_Unique ON LoadGoodsBarCodeItem (LoadGoodsBarCodeId, JuridicalId);


/*-------------------------------------------------------------------------------*/


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.  Ярошенко Р.Ф.
 05.06.17                                          * 
*/
