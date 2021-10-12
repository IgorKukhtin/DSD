-- Function: gpInsertUpdateMobile_Movement_RouteMember()

-- DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_RouteMember (TVarChar, TVarChar, TDateTime, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_RouteMember (TVarChar, TVarChar, TDateTime, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Movement_RouteMember (
    IN inGUID         TVarChar  , -- ���������� ���������� ������������� ��� ������������� � ���������� ������������
    IN inInvNumber    TVarChar  , -- ����� ���������
    IN inInsertDate   TDateTime , -- ����/����� ��������
    IN inGPSN         TFloat    , -- GPS ���������� �������� (������)
    IN inGPSE         TFloat    , -- GPS ���������� �������� (�������)
    IN inAddressByGPS TVarChar  , -- �����, ������������ �� GPS
    IN inSession      TVarChar    -- ������ ������������
)
RETURNS Integer 
AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbisInsert Boolean;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);


      -- testm
      IF vbUserId = 1123966 -- testm
      THEN
          RAISE EXCEPTION '������.��� ����.';
      END IF;
      
      -- ������
      IF COALESCE (inInsertDate, zc_DateStart()) <= zc_DateStart()
      THEN
          inInsertDate:= CURRENT_DATE;
      END IF;

-- �������� �.�.
-- IF inGUID = '?13' AND vbUserId = 1156045 THEN RETURN 0; END IF;
--  IF vbUserId = 1156045 THEN RETURN 0; END IF;
-- testm
--  IF vbUserId = 1123966 THEN RETURN 0; END IF;
 


      -- ����� Id ��������� �� GUID
      SELECT MovementString_GUID.MovementId 
           , Movement_RouteMember.StatusId
      INTO vbId 
         , vbStatusId
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_RouteMember
                         ON Movement_RouteMember.Id = MovementString_GUID.MovementId
                        AND Movement_RouteMember.DescId = zc_Movement_RouteMember()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inGUID;


      -- ���������� ������� ��������/�������������
      vbisInsert:= (COALESCE (vbId, 0) = 0);

      IF (vbisInsert = FALSE) AND (vbStatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_Erased()))
      THEN 
           -- ���� ������� ��������� ������ ��������, �� �����������
           PERFORM gpUnComplete_Movement_RouteMember (inMovementId:= vbId, inSession:= inSession);
      END IF;


      -- ���������
      vbId:= lpInsertUpdate_Movement_RouteMember (ioId        := vbId
                                                , inInvNumber := (zfConvert_StringToNumber (inInvNumber) + lfGet_User_BillNumberMobile (vbUserId)) :: TVarChar
                                                , inOperDate  := DATE_TRUNC ('day', inInsertDate)
                                                , inGPSN      := inGPSN
                                                , inGPSE      := inGPSE
                                                , inUserId    := vbUserId
                                                 );

      -- ��������� �������� <����/����� �������� �� ��������� ����������>
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_InsertMobile(), vbId, inInsertDate);

      -- ��������� �������� <���������� ���������� �������������>
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_GUID(), vbId, inGUID);

      -- ��������� �������� <�����, ������������ �� GPS>
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_AddressByGPS(), vbId, inAddressByGPS);

      -- �������� ������� ��������� ������
      PERFORM gpComplete_Movement_RouteMember (inMovementId:= vbId, inSession:= inSession);

      IF vbisInsert = FALSE
      THEN
          -- ��������� �������� < ����/����� ����� ����������� �������� � ��� ���� >
          PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_UpdateMobile(), vbId, CURRENT_TIMESTAMP);
      END IF;

      RETURN vbId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 26.06.17                                                        * AddressByGPS
 04.04.17                                                        *                                          
*/

-- ����
-- SELECT * FROM gpInsertUpdateMobile_Movement_RouteMember (inGUID:= '{94774140-0FF6-4DC3-910C-5805989B6FC4}', inInvNumber:= '-9', inInsertDate:= CURRENT_TIMESTAMP, inGPSN:= 56, inGPSE:= 56, inAddressByGPS:= '�. �������, ��. �������������, 7', inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpInsertUpdateMobile_Movement_RouteMember (inGUID:= '?13', inInvNumber:= '57710', inInsertDate:= '04.03.1518 14:43:59', inGPSN:= 47.8988, inGPSE:= 33.3982, inAddressByGPS:= '', inSession:= '1156045');

