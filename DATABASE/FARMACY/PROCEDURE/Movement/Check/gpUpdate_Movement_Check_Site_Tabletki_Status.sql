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
   DECLARE vbStatusId Integer;
   DECLARE vbBookingStatus TVarChar;
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
    
    SELECT StatusId, COALESCE(MovementString_BookingStatus.ValueData, '')
    INTO vbStatusId, vbBookingStatus
    FROM Movement
         LEFT JOIN MovementString AS MovementString_BookingStatus
                                  ON MovementString_BookingStatus.MovementId = Movement.Id
                                 AND MovementString_BookingStatus.DescId = zc_MovementString_BookingStatus()
    WHERE Id = inMovementId;

        -- ��������� ������ ������
    IF vbBookingStatus <> inBookingStatus
    THEN 
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_BookingStatus(), inMovementId, inBookingStatus);
    END IF; 
    
    IF inBookingStatus = '7.0'
    THEN
      -- ������� ��������
      IF vbStatusId = zc_Enum_Status_UnComplete()
      THEN
        PERFORM gpSetErased_Movement_Check (inMovementId:= inMovementId, inSession:= inSession);
      END IF;
    ELSE

      IF inBookingStatus = '2.0'
      THEN
        PERFORM gpUpdate_Movement_Check_ConfirmedKindSite (inMovementId := inMovementId, inSession := inSession);
      END IF;

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