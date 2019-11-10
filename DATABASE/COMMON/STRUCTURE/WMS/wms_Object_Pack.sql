/*
  �������� 
    - ������� wms_Object_Pack
    - ������
    - ��������
*/

-- DROP TABLE wms_Object_Pack

/*-------------------------------------------------------------------------------*/

CREATE TABLE wms_Object_Pack(
   Id                  SERIAL    NOT NULL PRIMARY KEY, 
   GoodsPropertyBoxId  Integer   NOT NULL,
   GoodsTypeKindId     Integer   NOT NULL,
   GoodsId             Integer   NOT NULL,
   GoodsKindId	       Integer   NOT NULL,
   ctn_type            TVarChar  NOT NULL, -- ��� ��������: ��������� �������� OR ���������� ��������
   InsertDate          TDateTime NOT NULL,
   UpdateDate          TDateTime     NULL
   );
/*-------------------------------------------------------------------------------*/
/*                                  �������                                      */
CREATE INDEX idx_wms_Object_Pack_Id ON wms_Object_Pack (Id);
CREATE UNIQUE INDEX idx_wms_Object_Pack_GoodsPropertyBoxId_GoodsTypeKindId_ctn_type ON wms_Object_Pack (GoodsPropertyBoxId, GoodsTypeKindId, ctn_type);

/*-------------------------------------------------------------------------------*/
/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
              ������� �.�.   ������ �.�.   ���������� �.�.
 05.11.19                                       *
*/
