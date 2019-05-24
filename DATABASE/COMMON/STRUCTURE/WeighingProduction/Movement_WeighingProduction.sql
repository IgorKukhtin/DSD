/*
  �������� 
    - ������� Movement_WeighingProduction (o������)
    - ������
    - ��������
*/
--drop TABLE Movement_WeighingProduction

/*-------------------------------------------------------------------------------*/

CREATE TABLE Movement_WeighingProduction(
   Id                  Integer  NOT NULL PRIMARY KEY, 
   InvNumber           TVarChar NOT NULL,
   OperDate            TDateTime,
   StatusId            Integer ,
   FromId              Integer ,
   ToId                Integer ,
   GoodsId             Integer ,
   GoodsKindId	       Integer ,
   MovementDescId      Integer ,
   MovementDescNumber  Integer ,
   PlaceNumber         Integer ,
   UserId              Integer ,
   StartWeighing       TDateTime ,
   EndWeighing         TDateTime
   );
/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */

--CREATE INDEX idx_Movement_WeighingProduction_Id	  ON Movement_WeighingProduction (Id);
--CREATE INDEX idx_Movement_WeighingProduction_OperDate  ON Movement_WeighingProduction (OperDate);
--CREATE INDEX idx_Movement_WeighingProduction_FromId   ON Movement_WeighingProduction (FromId);
--CREATE INDEX idx_Movement_WeighingProduction_ToId    ON Movement_WeighingProduction (ToId);

/*-------------------------------------------------------------------------------*/
/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   ������� �.�.    
22.05.19                                            *
*/




