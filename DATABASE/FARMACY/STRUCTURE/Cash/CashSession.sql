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
  LastConnect    TDateTime, -- Дата документа
  UserId         Integer,   -- Сотрудник 
  StartUpdate    TDateTime -- Дата начала обновления
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
  CashSessionId       TVarChar    NOT NULL,
  ObjectId            INTEGER     NOT NULL, -- Товар
  NDSKindId           Integer     NOT NULL, -- Типы НДС
  DiscountExternalID  Integer     NOT NULL, -- Товар для проекта (дисконтные карты)
  PartionDateKindId   Integer     NOT NULL, -- Типы срок/не срок
  DivisionPartiesID   Integer     NOT NULL, -- Разделение партий в кассе для продажи
  Price               TFloat      NOT NULL, -- цена
  Remains             TFloat      NOT NULL, -- Остаток
  MCSValue            TFloat      NULL,     -- неснижаемый товарный остаток
  Reserved            TFloat      NULL,     -- в резерве
  DeferredSend        TFloat      NULL,     -- в отложенных перемещениях
  DeferredTR          TFloat      NULL,     -- в отложенных технических переучетах
  MinExpirationDate   TDateTime   NULL,     -- Срок годн. ост.
  MCSValueOld         TFloat      NULL,     -- НТЗ - значение которое вернется по окончании периода
  StartDateMCSAuto    TDateTime   NULL,     -- дата нач. периода
  EndDateMCSAuto      TDateTime   NULL,     -- дата оконч. периода
  isMCSAuto           Boolean     NULL,     -- Режим - НТЗ выставил фармацевт на период
  isMCSNotRecalcOld   Boolean     NULL,     -- Спецконтроль кода - значение которое вернется по окончании периода
  AccommodationId     Integer     NULL,     -- Размещение товара
  PartionDateDiscount TFloat      NULL,     -- Скидка на партионный товар
  PriceWithVAT        TFloat      NULL,     -- Цена последней закупки
  CONSTRAINT PK_CashSessionSnapShot PRIMARY KEY(CashSessionId,ObjectId,PartionDateKindId)
);

ALTER TABLE CashSessionSnapShot
  OWNER TO postgres;

CREATE INDEX idx_CashSessionSnapShot ON CashSessionSnapShot(CashSessionId);
CREATE INDEX idx_CashSessionSnapShot_ObjectId ON CashSessionSnapShot(ObjectId);

-- CREATE INDEX idx_CashSessionSnapShot_ObjectId_CashSessionId ON CashSessionSnapShot(ObjectId, CashSessionId);
-- CREATE INDEX idx_CashSessionSnapShot_CashSessionId_ObjectId ON CashSessionSnapShot(CashSessionId, ObjectId);
-- ALTER TABLE CashSessionSnapShot ADD DeferredTR          TFloat      NULL

/*-------------------------------------------------------------------------------*/



/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Воробкало А.А.   Фелонюк И.В.   Шаблий О.В.
14.08.2020                                                                         * DivisionPartiesID
19.06.2020                                                                         * DiscountExternalID
13.05.2019                                                                         * PartionDateKindId
22.08.2018                                                                         *
09.06.2017                                                           *
10.09.2015                                           *
*/
