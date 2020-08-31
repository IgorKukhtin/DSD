-- Function: gpUpdate_Movement_Check_Site_Tabletki_Status() 

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_Site_Tabletki_Status (Integer, TVarChar, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_Site_Tabletki_Status(
    IN inMovementId        Integer   , -- ���� ������� <�������� ���>
    IN inBookingStatus     TVarChar  , -- ������ ������
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    IF inSession = zfCalc_UserAdmin()
    THEN
      inSession = zfCalc_UserSite();
    END IF;

    vbUserId := lpGetUserBySession (inSession);

    IF COALESCE(inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;
    
        -- ��������� ������ ������
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_BookingStatus(), inMovementId, inBookingStatus);
    
    IF inBookingStatus = '7.0'
    THEN
      -- ������� ��������
      PERFORM gpSetErased_Movement_Check (inMovementId:= inMovementId, inSession:= inSession);
    ELSE
      -- ��������� ��������
      PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.08.20                                                       *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_Check_Site_Tabletki_Status (inId:= 0, inBookingStatus:= '', inSession:= zfCalc_UserAdmin());
