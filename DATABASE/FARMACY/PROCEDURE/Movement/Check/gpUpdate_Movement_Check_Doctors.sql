-- Function: gpUpdate_Movement_Check_Doctors()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_Doctors (Integer, Boolean, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_Doctors(
    IN inMovementId        Integer   , -- ���� ������� <�������� ���>
    IN inisDoctors         Boolean   , -- 
   OUT outisDoctors        Boolean   , -- 
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);

    IF 3 <> inSession::Integer AND 375661 <> inSession::Integer AND 4183126 <> inSession::Integer AND
      8001630 <> inSession::Integer AND 9560329 <> inSession::Integer
    THEN
      RAISE EXCEPTION '��������� �������� <�����.> ��� ���������.';
    END IF;

    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;

    outisDoctors := NOT inisDoctors;
    
    -- ��������� ������� <���������>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Doctors(), inMovementId, outisDoctors);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 04.08.21                                                       *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_Check_Doctors (inId:= 0, inSMS:= TRUE, inSession:= zfCalc_UserAdmin());
