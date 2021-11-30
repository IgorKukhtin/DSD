-- DROP TABLE AccommodationLincGoods;
-- DROP TABLE AccommodationLincGoodsLog;

-------------------------------------------------------------------------------
CREATE TABLE AccommodationLincGoods
(
  AccommodationId   Integer     NOT NULL, -- ���������� ������
  UnitId            Integer     NOT NULL, -- ��� �������������
  GoodsId           Integer     NOT NULL, -- ��� �����������

  UserUpdateId      Integer,              -- ������������ (�������������)
  DateUpdate        TDateTime,            -- ���� �������������
  isErased          Boolean Not Null Default False,   -- ������� ������

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

  OperDate          TDateTime,            -- ���� �������������
  UserId            Integer,              -- ������������ (�������������)
  
  UnitId            Integer     NOT NULL, -- ��� �������������
  GoodsId           Integer     NOT NULL, -- ��� �����������
  AccommodationId   Integer     NOT NULL, -- ���������� ������

  isErased          Boolean     Not Null, -- ������� ������

  CONSTRAINT PK_AccommodationLincGoodsLog PRIMARY KEY(Id)
);

ALTER TABLE AccommodationLincGoodsLog
  OWNER TO postgres;

CREATE INDEX idx_AccommodationLincGoodsLog_UnitId_GoodsId_DateUpdate ON public.AccommodationLincGoodsLog
  USING btree (UnitId, GoodsId, OperDate);
  
-------------------------------------------------------------------------------

/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ������ �.�.
22.08.2018         *
*/
