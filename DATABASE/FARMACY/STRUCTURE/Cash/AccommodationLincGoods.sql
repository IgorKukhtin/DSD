-- DROP TABLE AccommodationLincGoods;

-------------------------------------------------------------------------------
CREATE TABLE AccommodationLincGoods
(
  AccommodationId   Integer     NOT NULL, -- ���������� ������
  UnitId            Integer     NOT NULL, -- ��� �������������
  GoodsId           Integer     NOT NULL, -- ��� �����������
  CONSTRAINT PK_AccommodationLincGoods PRIMARY KEY(AccommodationId, UnitId, GoodsId)
);

ALTER TABLE AccommodationLincGoods
  OWNER TO postgres;

CREATE INDEX idx_AccommodationLincGoods_UnitId_GoodsId_Id ON public.AccommodationLincGoods
  USING btree (UnitId, GoodsId, AccommodationId);
  
-------------------------------------------------------------------------------



/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ������ �.�.
22.08.2018         *
*/

