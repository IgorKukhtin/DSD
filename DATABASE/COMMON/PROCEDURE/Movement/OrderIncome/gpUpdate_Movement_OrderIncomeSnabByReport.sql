-- Function: gpUpdate_Movement_OrderIncomeSnabByReport()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderIncomeSnabByReport (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderIncomeSnabByReport(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inOperDateStart       TDateTime , -- 
    IN inOperDateEnd         TDateTime , -- 
   OUT outDayCount           Integer   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderIncome());


     -- ��������� �������� <���. ���� ��� ������ �������� = 4 ������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), inId, inOperDateStart);
     -- ��������� �������� <������. ���� ��� ������ �������� = 4 ������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), inId, inOperDateEnd);

     -- ��������� �������� <�� ������� ���� ������� ����. ����� �� �����>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DayCount(), inId, 30);
     
     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

     -- ������� - ������ �������� = 4 ������
     outDayCount:= DATE_PART ('DAY', inOperDateEnd - inOperDateStart) + 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.04.17         *
*/

-- ����
-- 