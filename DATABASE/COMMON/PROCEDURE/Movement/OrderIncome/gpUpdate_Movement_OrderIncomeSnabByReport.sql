-- Function: gpUpdate_Movement_OrderIncomeSnabByReport()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderIncomeSnabByReport (Integer, TDateTime, TDateTime, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderIncomeSnabByReport (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderIncomeSnabByReport(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inOperDateStart       TDateTime , -- 
    IN inOperDateEnd         TDateTime , -- 
   OUT outDayCount           Integer   , -- ���� ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsInsert Boolean;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderIncome());


     --outDayCount:= (DATE_PART ('DAY', DATE_TRUNC ('DAY', inOperDateEnd) - DATE_TRUNC ('MONTH', inOperDateStart)) + 1) :: Integer;
     outDayCount:= (DATE_PART('day', (inOperDateEnd - inOperDateStart)) + 2) :: Integer;

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), inId, inOperDateStart);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), inId, inOperDateEnd);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DayCount(), inId, outDayCount);
     
     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

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