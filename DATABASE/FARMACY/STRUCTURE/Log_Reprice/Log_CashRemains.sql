/*
  �������� 
    - ������� Log_CashRemains (������������� ������� )
    - ������
    - ��������
*/

-- DROP TABLE Log_CashRemains;

/*-------------------------------------------------------------------------------*/
CREATE TABLE Log_CashRemains
(
  Id                serial    NOT NULL PRIMARY KEY,
  
  CashSessionId     TVarChar, 
  DateStart         TDateTime, 
  FullRemains       Boolean, 
  UserId            Integer, 
  UnitId            Integer, 
  RetailId          Integer,
  OldProgram        Boolean, 
  OldServise        Boolean
 )
;

ALTER TABLE Log_CashRemains
  OWNER TO postgres;
 


/*-------------------------------------------------------------------------------*/



/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   ������ �.�.
  20.10.18                                         *
  
                 
select CashSessionId, DateStart, FullRemains,
       OUser.objectcode, OUser.valuedata,
       OUnit.objectcode, OUnit.valuedata
from Log_CashRemains
     inner join Object As OUser on OUser.id = Log_CashRemains.UserId
     inner join Object As OUnit on OUnit.id = Log_CashRemains.UnitId
                 
*/
