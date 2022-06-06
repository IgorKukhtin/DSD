/*
  �������� 
    - ������� EmployeeWorkLog 
    - ������
    - ��������
*/

-- DROP TABLE EmployeeWorkLog;

-------------------------------------------------------------------------------
CREATE TABLE EmployeeWorkLog
(
  Id                serial    NOT NULL PRIMARY KEY,
  
  CashSessionId     TVarChar,   -- ������ ��������� �����
  CashRegister      TVarChar,   -- ���������� �����
  IP                TVarChar,   -- ������� IP �����

  UserId            Integer,    -- ������������
  UnitId            Integer,    -- �������������
  RetailId          Integer,    -- ����

  DateLogIn         TDateTime,  -- ���� � ����� �����
  DateZReport       TDateTime,  -- ���� � ����� ���������� Z ������
  DateLogOut        TDateTime,  -- ���� � ����� ������

  OldProgram        Boolean,    -- ���� ������ ������
  OldServise        Boolean     -- �� �������� ������
 )
;

ALTER TABLE EmployeeWorkLog
  OWNER TO postgres;
 
-- ALTER TABLE EmployeeWorkLog ADD COLUMN IP                TVarChar

-------------------------------------------------------------------------------



/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   ������ �.�.
  13.01.19                                         *
  
                 
select CashSessionId, CashRegister, DateLogIn, DateZReport, DateLogOut,
       OUser.objectcode, OUser.valuedata,
       OUnit.objectcode, OUnit.valuedata
from EmployeeWorkLog
     inner join Object As OUser on OUser.id = EmployeeWorkLog.UserId
     inner join Object As OUnit on OUnit.id = EmployeeWorkLog.UnitId
LIMIT 10
                 
*/