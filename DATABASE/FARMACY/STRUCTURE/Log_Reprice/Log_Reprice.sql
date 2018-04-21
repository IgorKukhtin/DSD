/*
  �������� 
    - ������� Log_Reprice (������������� ������� )
    - ������
    - ��������
*/

-- DROP TABLE Log_Reprice;

/*-------------------------------------------------------------------------------*/
CREATE TABLE Log_Reprice
(
  Id            serial    NOT NULL PRIMARY KEY,
  InsertDate	TDateTime, -- ����/����� 
  StartDate	TDateTime, -- ����/����� 
  EndDate	TDateTime, -- ����/�����
  MovementId	Integer  , -- 
  UserId	Integer  , -- 
  TextValue	TVarChar   -- 
  
 )
;

ALTER TABLE Log_Reprice
  OWNER TO postgres;
 
CREATE INDEX idx_Log_Reprice_InsertDate ON Log_Reprice (InsertDate); 
CREATE INDEX idx_Log_Reprice_UserId_InsertDate ON Log_Reprice (UserId,InsertDate); 


/*-------------------------------------------------------------------------------*/



/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   
*/
