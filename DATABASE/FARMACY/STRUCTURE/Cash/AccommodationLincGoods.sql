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


-------------------------------------------------------------------------------



/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ������ �.�.
22.08.2018         *
*/
