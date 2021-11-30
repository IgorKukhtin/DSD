-- DROP TABLE AccommodationLincGoods;
-- DROP TABLE AccommodationLincGoodsLog;

-------------------------------------------------------------------------------
CREATE TABLE AccommodationLincGoods
(
  AccommodationId   Integer     NOT NULL, -- Размещение товара
  UnitId            Integer     NOT NULL, -- Код подразделения
  GoodsId           Integer     NOT NULL, -- Код медикамента

  UserUpdateId      Integer,              -- Пользователь (корректировка)
  DateUpdate        TDateTime,            -- Дата корректировки
  isErased          Boolean Not Null Default False,   -- Признак удален

  CONSTRAINT PK_AccommodationLincGoods PRIMARY KEY(AccommodationId, UnitId, GoodsId)
);

ALTER TABLE AccommodationLincGoods
  OWNER TO postgres;

CREATE INDEX idx_AccommodationLincGoods_UnitId_GoodsId_Id ON public.AccommodationLincGoods
  USING btree (UnitId, GoodsId, AccommodationId);
  
-------------------------------------------------------------------------------

CREATE TABLE AccommodationLincGoodsLog
(
  Id                Serial,               -- ID

  OperDate          TDateTime,            -- Дата корректировки
  UserId            Integer,              -- Пользователь (корректировка)
  
  UnitId            Integer     NOT NULL, -- Код подразделения
  GoodsId           Integer     NOT NULL, -- Код медикамента
  AccommodationId   Integer     NOT NULL, -- Размещение товара

  isErased          Boolean     Not Null, -- Признак удален

  CONSTRAINT PK_AccommodationLincGoodsLog PRIMARY KEY(Id)
);

ALTER TABLE AccommodationLincGoodsLog
  OWNER TO postgres;

CREATE INDEX idx_AccommodationLincGoodsLog_UnitId_GoodsId_DateUpdate ON public.AccommodationLincGoodsLog
  USING btree (UnitId, GoodsId, OperDate);
  
-------------------------------------------------------------------------------

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Шаблий О.В.
22.08.2018         *
*/
