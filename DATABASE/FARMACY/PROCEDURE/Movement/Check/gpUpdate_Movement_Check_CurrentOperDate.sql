-- Function: gpUpdate_Movement_Check_CurrentOperDate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_CurrentOperDate (Integer, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_CurrentOperDate(
    IN inMovementId        Integer   , -- ���� ������� <�������� ���>
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbInvNumber TVarChar;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpGetUserBySession (inSession);
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Check_OperDate());

    IF COALESCE(inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;
    
    SELECT Movement.InvNumber
    INTO vbInvNumber
    FROM Movement
    WHERE Movement.Id =  inMovementId;    

    -- ��������� <��������>
    inMovementId := lpInsertUpdate_Movement (inMovementId, zc_Movement_Check(), vbInvNumber, CURRENT_TIMESTAMP, NULL);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.03.20                                                        *
*/
-- ����
-- SELECT * FROM gpUpdate_Movement_Check_CurrentOperDate (inId := 0, inOperDate := NULL::TDateTime, inInvNumber:= '12345'::TVarChar, inSession := '3'::TVarChar); 
