-- Function: gpUpdate_Movement_Check_DateCompensation()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_DateCompensation(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_DateCompensation(
    IN inMovementId          Integer   , -- ���� ������� <��������>
 INOUT ioDateCompensation    TDateTime , -- ���� �����������
    IN inSummChangePercent   TFloat    , -- ������� �����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TDateTime AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;

  IF COALESCE(inSummChangePercent, 0) = 0
  THEN
    ioDateCompensation := NULL;
    RETURN;
  END IF;

  IF COALESCE(inMovementId, 0) = 0
  THEN
      RAISE EXCEPTION '�������� �� �������.';
  END IF;
          
  --������ ������� ���� �����������
  Perform lpInsertUpdate_MovementDate(zc_MovementDate_Compensation(), inMovementId, ioDateCompensation);
  
  -- ��������� ��������
  PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ������ �.�.
 15.04.21                                                                    *
*/

-- ����