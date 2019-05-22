/*
  �������� 
    - ������� MI_WeighingProduction (o������)
    - ������
    - ��������
*/
--drop TABLE MI_WeighingProduction

/*-------------------------------------------------------------------------------*/

CREATE TABLE MI_WeighingProduction(
   Id                  Integer  NOT NULL PRIMARY KEY, 
   MovementId          Integer  NOT NULL,
   ParentId            Integer ,
   GoodsTypeKindId     Integer ,
   BarCodeBoxId        Integer ,
   WmsCode             TVarChar,
   LineCode            Integer ,
   DateInsert          TDateTime,
   DateUpdate          TDateTime,
   IsErased            Boolean
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




