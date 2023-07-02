-- Function: gpUpdate_Movement_Check_SetOffsetVIP()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_SetOffsetVIP (Integer, Boolean, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_SetOffsetVIP(
    IN inMovementId        Integer   , -- ���� ������� <�������� ���>
    IN inisOffsetVIP       Boolean   , -- ����� �����
    IN inDateOffsetVIP     TDateTime , -- ���� ����� �����
   OUT outisOffsetVIP      Boolean   , -- 
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

    outisOffsetVIP := NOT inisOffsetVIP;
    
    -- ��������� ������� <����� �����>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_OffsetVIP(), inMovementId, outisOffsetVIP);

    -- ��������� ������� <���� ����� �����>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OffsetVIP(), inMovementId, inDateOffsetVIP);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.10.21                                                       *
*/

-- ����
-- select * from gpUpdate_Movement_Check_SetOffsetVIP(inMovementId := 32589738 , inisOffsetVIP := 'False' , inDateOffsetVIP := ('02.07.2023')::TDateTime ,  inSession := '3');

