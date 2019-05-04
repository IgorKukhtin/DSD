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
  CashSessionId     TVarChar    NOT NULL,
  ObjectId          INTEGER     NOT NULL, -- Товар
  Price             TFloat      NOT NULL, -- цена
  Remains           TFloat      NOT NULL, -- Остаток
  MCSValue          TFloat      NULL,     -- неснижаемый товарный остаток
  Reserved          TFloat      NULL,     -- в резерве
  MinExpirationDate TDateTime   NULL,     -- Срок годн. ост.
  MCSValueOld       TFloat      NULL,     -- НТЗ - значение которое вернется по окончании периода
  StartDateMCSAuto  TDateTime   NULL,     -- дата нач. периода
  EndDateMCSAuto    TDateTime   NULL,     -- дата оконч. периода
  isMCSAuto         Boolean     NULL,     -- Режим - НТЗ выставил фармацевт на период
  isMCSNotRecalcOld Boolean     NULL,     -- Спецконтроль кода - значение которое вернется по окончании периода
  AccommodationId   Integer     NULL,     -- Размещение товара
--  ALTeR TABLE CashSessionSnapShot ADD
  PartionDateKind   Integer     NULL,     -- Типы срок/не срок
  CONSTRAINT PK_CashSessionSnapShot PRIMARY KEY(CashSessionId,ObjectId)
);

ALTER TABLE CashSessionSnapShot
  OWNER TO postgres;

CREATE INDEX idx_CashSessionSnapShot ON CashSessionSnapShot(CashSessionId);
CREATE INDEX idx_CashSessionSnapShot_ObjectId ON CashSessionSnapShot(ObjectId);

-- CREATE INDEX idx_CashSessionSnapShot_ObjectId_CashSessionId ON CashSessionSnapShot(ObjectId, CashSessionId);
-- CREATE INDEX idx_CashSessionSnapShot_CashSessionId_ObjectId ON CashSessionSnapShot(CashSessionId, ObjectId);

/*-------------------------------------------------------------------------------*/



/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Воробкало А.А.   Фелонюк И.В.   Шаблий О.В.
20.04.2019                                                                         * PartionDateKind                 
22.08.2018                                                                         *
09.06.2017                                                           *
10.09.2015                                           *
*/
