/*
  Создание 
    - таблицы LoadGoodsBarCode (промежуточная таблица загрузки)
    - связей
    - индексов
*/

-- Table: LoadGoodsBarCode

-- DROP TABLE LoadGoodsBarCode;

/*-------------------------------------------------------------------------------*/
CREATE TABLE LoadGoodsBarCode
(
  Id               serial NOT NULL,
  GoodsId          Integer,
  GoodsMainId      Integer,
  GoodsBarCodeId   Integer,
  GoodsJuridicalId Integer,
  JuridicalId      Integer,
  Code             Integer,   -- Наш Код товара
  Name             TVarChar,  -- Название товара
  ProducerName     TVarChar,  -- Производитель
  GoodsCode        TVarChar,  -- Код товара поставщика
  BarCode          TVarChar,  -- Штрих-код
  JuridicalName    TVarChar,  -- Поставщик
  ErrorText        TVarChar,
  CONSTRAINT pk_LoadGoodsBarCode PRIMARY KEY (Id)
);

CREATE UNIQUE INDEX idx_LoadGoodsBarCode_Code ON LoadGoodsBarCode (Code);

/*-------------------------------------------------------------------------------*/



/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.  Ярошенко Р.Ф.
 05.06.17                                          * 
*/
