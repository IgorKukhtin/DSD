-- Function: gpInsertUpdateMobile_MovementItem_Visit()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_MovementItem_Visit (TVarChar, TVarChar, TBlob, TVarChar, TVarChar, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_MovementItem_Visit (TVarChar, TVarChar, TBlob, TVarChar, TVarChar, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_MovementItem_Visit(
    IN inGUID         TVarChar  , -- ���������� ���������� ������������� ��� ������������� � ���������� ������������
    IN inMovementGUID TVarChar  , -- ���������� ���������� ������������� ���������
    IN inPhoto        TBlob     , -- ����, ���������� �����
    IN inPhotoName    TVarChar  , -- ����, ��� �����
    IN inComment      TVarChar  , -- ���������� � ����
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
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- �������� Id ��������� �� GUID
      SELECT MovementString_GUID.MovementId 
      INTO vbMovementId 
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

      -- ��������� �������� <����/����� ��������>
      PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_InsertMobile(), vbId, inInsertDate);

      IF inIsErased
      THEN
           PERFORM gpMovementItem_Visit_SetErased (vbId, inSession);
      ELSE
           PERFORM gpMovementItem_Visit_SetUnErased (vbId, inSession);
      END IF; 

      RETURN vbId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 04.04.17                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdateMobile_MovementItem_Visit (inGUID:= '{29F0D6D3-006A-4D30-8B30-CECCD7D883C6}', inMovementGUID:= '{2F3BD890-0022-45F7-A1E2-9324BC312C76}', inPhoto:= NULL, inPhotoName:= 'NoPhoto', inComment:= 'simple test', inInsertDate:= CURRENT_TIMESTAMP, inIsErased:= false, inSession:= zfCalc_UserAdmin())
