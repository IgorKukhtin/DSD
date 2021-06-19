-- Function: gpUpdate_MovementItem_EmployeeSchedule_PayrollType()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_EmployeeSchedule_PayrollType(INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_EmployeeSchedule_PayrollType(
    IN inId                  Integer   , -- ���� ������� <������� ��������� �������>
    IN inDay                 Integer   , -- ����
    IN inPayrollTypeID       Integer   , -- ��� ���
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbServiceExit Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

    -- �������� ���� ������������ �� ����� ���������
    IF vbUserId NOT IN (3, 758920, 4183126, 9383066, 8037524)
    THEN
      RAISE EXCEPTION '��������� <������ ������ �����������> ��� ���������.';
    END IF;

    IF COALESCE (inId, 0) = 0 
    THEN
        RAISE EXCEPTION '������. ������ �� ��������.';
    END IF;
    
    IF inPayrollTypeID < 0
    THEN
      vbServiceExit := True;
      inPayrollTypeID := 0;
    ELSE
      vbServiceExit := False;    
    END IF;
    
    -- ���������
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PayrollType(), inId, inPayrollTypeID);    
     -- ��������� �������� <��������� �����>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_ServiceExit(), inId, vbServiceExit);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
24.09.19                                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_MovementItem_EmployeeSchedule_PayrollType (, inSession:= '2')

