/*
  �������� 
    - ������� MI_Incoming (o������)
    - ������
    - ��������
*/

-- DROP TABLE MI_Incoming

/*-------------------------------------------------------------------------------*/

CREATE TABLE MI_Incoming(
   Id                  BIGSERIAL NOT NULL PRIMARY KEY, 
   MovementId          Integer   NOT NULL,
   GoodsId             Integer   NOT NULL,
   GoodsKindId	       Integer   NOT NULL,
   GoodsTypeKindId     Integer   NOT NULL,
   sku_id              TVarChar  NOT NULL, -- sku_id
   sku_code            TVarChar  NOT NULL, -- sku_code
   Amount              TFloat    NOT NULL,
   RealWeight          TFloat    NOT NULL,
   PartionDate         TDateTime NOT NULL,
   isErased            Boolean   NOT NULL
   );
/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */

/*-------------------------------------------------------------------------------*/
/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
              ������� �.�.   ������ �.�.   ���������� �.�.
 22.08.19                                       *
*/




