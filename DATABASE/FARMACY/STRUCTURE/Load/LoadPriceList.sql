/*
  Создание 
    - таблицы LoadPriceList (промежуточная таблица загрузки)
    - связей
    - индексов
*/

-- Table: Movement

-- DROP TABLE LoadPriceList;

/*-------------------------------------------------------------------------------*/
CREATE TABLE LoadPriceList
(
  Id            serial    NOT NULL PRIMARY KEY,
  OperDate	TDateTime, -- Дата документа
  JuridicalId	Integer , -- Юридические лица
  ContractId	Integer , -- Договор
  isAllGoodsConcat Boolean, -- Все ли товары имеют связь
  NDSinPrice    Boolean, -- Цена с НДС?
  isMoved       Boolean, -- Перенесли ли в прайс-листы
  CONSTRAINT fk_LoadMovement_JuridicalId FOREIGN KEY (JuridicalId)    REFERENCES Object (id))
WITH (
  OIDS=FALSE
);

ALTER TABLE LoadPriceList
  OWNER TO postgres;
 
CREATE INDEX idx_LoadPriceList_JuridicalId ON LoadPriceList(JuridicalId); 


/*-------------------------------------------------------------------------------*/



/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
*/
