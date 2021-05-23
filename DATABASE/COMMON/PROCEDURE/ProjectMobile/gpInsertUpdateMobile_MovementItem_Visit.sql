-- Function: gpInsertUpdateMobile_MovementItem_Visit()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_MovementItem_Visit (TVarChar, TVarChar, TBlob, TVarChar, TVarChar, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_MovementItem_Visit (TVarChar, TVarChar, TBlob, TVarChar, TVarChar, TDateTime, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdateMobile_MovementItem_Visit (TVarChar, TVarChar, TBlob, TVarChar, TVarChar, TFloat, TFloat, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_MovementItem_Visit (TVarChar, TVarChar, TBlob, TVarChar, TVarChar, TFloat, TFloat, TVarChar, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_MovementItem_Visit(
    IN inGUID         TVarChar  , -- ���������� ���������� ������������� ��� ������������� � ���������� ������������
    IN inMovementGUID TVarChar  , -- ���������� ���������� ������������� ���������
    IN inPhoto        TBlob     , -- ����, ���������� �����
    IN inPhotoName    TVarChar  , -- ����, ��� �����
    IN inComment      TVarChar  , -- ���������� � ����
    IN inGPSN         TFloat    , -- GPS ���������� ���� (������)
    IN inGPSE         TFloat    , -- GPS ���������� ���� (�������)
    IN inAddressByGPS TVarChar  , -- �����, ������������ �� GPS
    IN inInsertDate   TDateTime , -- ����/����� �������� ��������
    IN inIsErased     Boolean   , -- ��������� �� �������
    IN inSession      TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbPhotoMobileId Integer;
   DECLARE vbStatusId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- testm
      IF vbUserId = 1123966 -- testm
      THEN
          RAISE EXCEPTION '������.��� ����.';
      END IF;


      -- �������� Id ��������� �� GUID
      SELECT MovementString_GUID.MovementId
           , Movement_Visit.StatusId
      INTO vbMovementId
         , vbStatusId
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_Visit
                         ON Movement_Visit.Id = MovementString_GUID.MovementId
                        AND Movement_Visit.DescId = zc_Movement_Visit()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID()
        AND MovementString_GUID.ValueData = inMovementGUID;

      IF COALESCE (vbMovementId, 0) = 0
      THEN
           RAISE EXCEPTION '������. �� �������� ����� ���������.';
      END IF;

      -- �������� Id ������ ��������� �� GUID
      SELECT MIString_GUID.MovementItemId
      INTO vbId
      FROM MovementItemString AS MIString_GUID
           JOIN MovementItem AS MovementItem_Visit
                             ON MovementItem_Visit.Id = MIString_GUID.MovementItemId
                            AND MovementItem_Visit.DescId = zc_MI_Master()
                            AND MovementItem_Visit.MovementId = vbMovementId
      WHERE MIString_GUID.DescId = zc_MIString_GUID()
        AND MIString_GUID.ValueData = inGUID;

      IF COALESCE (vbId, 0) <> 0
      THEN
           -- ������� ������������ ������� PhotoMobile �� ObjectCode
           SELECT Object_PhotoMobile.Id
           INTO vbPhotoMobileId
           FROM Object AS Object_PhotoMobile
           WHERE Object_PhotoMobile.DescId = zc_Object_PhotoMobile()
             AND Object_PhotoMobile.ObjectCode = vbId;
      END IF;

      IF COALESCE (vbPhotoMobileId, 0) = 0
      THEN
           -- ��������� ����� ������� PhotoMobile
           vbPhotoMobileId:= lpInsertUpdate_Object (0, zc_Object_PhotoMobile(), 0, TRIM (inPhotoName));
      END IF;

      IF vbStatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_Erased())
      THEN -- ���� ����� �������� ��� ������, �� �����������
           PERFORM gpUnComplete_Movement_Visit (inMovementId:= vbMovementId, inSession:= inSession);
      END IF;

      vbId:= lpInsertUpdate_MovementItem_Visit (ioId:= vbId
                                              , inMovementId:= vbMovementId
                                              , inPhotoMobileId:= vbPhotoMobileId
                                              , inComment:= inComment
                                              , inUserId:= vbUserId
                                               );

      -- ��������� �������� <���������� ���������� �������������>
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GUID(), vbId, inGUID);

      -- ��������� ������� ����
      PERFORM lpInsertUpdate_Object_PhotoMobile (vbPhotoMobileId, vbId, TRIM (inPhotoName), inPhoto, vbUserId);

      -- ��������� �������� <GPS ���������� ���� (������)>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_GPSN(), vbId, inGPSN);

      -- ��������� �������� <GPS ���������� ���� (�������)>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_GPSE(), vbId, inGPSE);

      -- ��������� �������� <�����, ������������ �� GPS>
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_AddressByGPS(), vbId, inAddressByGPS);

      -- ��������� �������� <����/����� ��������>
      PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_InsertMobile(), vbId, inInsertDate);

      IF inIsErased
      THEN
           PERFORM gpMovementItem_Visit_SetErased (vbId, inSession);
      ELSE
           PERFORM gpMovementItem_Visit_SetUnErased (vbId, inSession);
      END IF;

      -- �������� �����
      PERFORM gpComplete_Movement_Visit (inMovementId:= vbMovementId, inSession:= inSession);

      -- ��������� �������� <����/����� ���������� � ���������� ����������>
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_UpdateMobile(), vbMovementId, CURRENT_TIMESTAMP);

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
-- SELECT * FROM gpInsertUpdateMobile_MovementItem_Visit (inGUID:= '{29F0D6D3-006A-4D30-8B30-CECCD7D883C6}', inMovementGUID:= '{2F3BD890-0022-45F7-A1E2-9324BC312C76}', inPhoto:= NULL, inPhotoName:= 'NoPhoto', inComment:= 'simple test', inGPSN:= 56, inGPSE:= 57, inAddressByGPS:= '�. ������, ��. �������, 15', inInsertDate:= CURRENT_TIMESTAMP, inIsErased:= false, inSession:= zfCalc_UserAdmin())
