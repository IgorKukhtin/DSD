/*
  Создание 
    - таблицы CashSession (Сессия кассового места)
    - связей
    - индексов
*/


-- DROP TABLE CashSession;

/*-------------------------------------------------------------------------------*/
CREATE TABLE CashSession
(
  Id             TVarChar    NOT NULL PRIMARY KEY,
  LastConnect    TDateTime -- Дата документа
);

ALTER TABLE CashSession
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/

/*
  Создание 
    - таблицы CashSessionSnapShot (состояние остатков цен и пр. для Сессии кассового места)
    - связей
    - индексов
*/


-- DROP TABLE CashSessionSnapShot;

/*-------------------------------------------------------------------------------*/
CREATE TABLE CashSessionSnapShot
(
  CashSessionId   TVarChar    NOT NULL,
  ObjectId        INTEGER     NOT NULL, -- Товар
  Price           TFloat      NOT NULL, -- цена
  Remains         TFloat      NOT NULL, -- Остаток
  MCSValue        TFloat      NULL,     -- неснижаемый товарный остаток
  Reserved        TFloat      NULL,     -- в резерве
  CONSTRAINT PK_CashSessionSnapShot PRIMARY KEY(CashSessionId,ObjectId)
);

ALTER TABLE CashSessionSnapShot
  OWNER TO postgres;

CREATE INDEX idx_CashSessionSnapShot ON CashSessionSnapShot(CashSessionId);
CREATE INDEX idx_CashSessionSnapShot_ObjectId ON CashSessionSnapShot(ObjectId);
/*-------------------------------------------------------------------------------*/



/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Воробкало А.А.
10.09.2015                                           *
*/
