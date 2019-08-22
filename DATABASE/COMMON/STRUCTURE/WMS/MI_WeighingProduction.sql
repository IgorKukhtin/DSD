/*
  �������� 
    - ������� MI_WeighingProduction (o������)
    - ������
    - ��������
*/

-- DROP TABLE MI_WeighingProduction

/*-------------------------------------------------------------------------------*/

CREATE TABLE MI_WeighingProduction(
   Id                  BIGSERIAL NOT NULL PRIMARY KEY, 
   MovementId          Integer   NOT NULL,
   ParentId            Integer       NULL,
   GoodsTypeKindId     Integer   NOT NULL,
   BarCodeBoxId        Integer   NOT NULL,
   LineCode            Integer   NOT NULL,
   Amount              TFloat    NOT NULL,
   RealWeight          TFloat    NOT NULL,
   InsertDate          TDateTime NOT NULL,
   UpdateDate          TDateTime     NULL,
   WmsCode             TVarChar  NOT NULL, -- 13-�����. �/� ��� ���
   sku_id              TVarChar  NOT NULL, -- sku_id
   sku_code            TVarChar  NOT NULL, -- sku_code
   PartionDate         TDateTime NOT NULL,
   isErased            Boolean   NOT NULL
   );
/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */

--CREATE INDEX idx_MI_WeighingProduction_Id	 ON MI_WeighingProduction (Id);
--CREATE INDEX idx_MI_WeighingProduction_OperDate ON MI_WeighingProduction (OperDate);
--CREATE INDEX idx_MI_WeighingProduction_MovementId  ON MI_WeighingProduction (MovementId);

/*-------------------------------------------------------------------------------*/
/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   ������� �.�.    
22.05.19                                            *
*/




