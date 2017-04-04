-- Function: gpInsertUpdateMobile_Movement_Visit()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_Visit (TVarChar, TVarChar, TDateTime, Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Movement_Visit (
    IN inGUID       TVarChar  , -- ���������� ���������� ������������� ��� ������������� � ���������� ������������
    IN inInvNumber  TVarChar  , -- ����� ���������
    IN inOperDate   TDateTime , -- ���� ���������
    IN inPartnerId  Integer   , -- ����������
    IN inComment    TVarChar  , -- ����������
    IN inInsertDate TDateTime , -- ����/����� ��������
    IN inSession    TVarChar    -- ������ ������������
)
RETURNS Integer 
AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbUserId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- �������� Id ��������� �� GUID
      SELECT MovementString_GUID.MovementId 
      INTO vbId 
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_Visit
                         ON Movement_Visit.Id = MovementString_GUID.MovementId
                        AND Movement_Visit.DescId = zc_Movement_Visit()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inGUID;

      vbId:= lpInsertUpdate_Movement_Visit (ioId:= vbId
                                          , inInvNumber:= inInvNumber
                                          , inOperDate:= inOperDate
                                          , inPartnerId:= inPartnerId
                                          , inComment:= inComment 
                                          , inUserId:= vbUserId
                                           );

      -- ��������� �������� <����/����� �������� �� ��������� ����������>
      PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_InsertMobile(), vbId, inInsertDate);

      -- ��������� �������� <���������� ���������� �������������>
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_GUID(), vbId, inGUID);

      RETURN vbId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 03.04.17                                                        *                                          
*/

-- ����
-- SELECT * FROM gpInsertUpdateMobile_Movement_Visit (inGUID:= '{2F3BD890-0022-45F7-A1E2-9324BC312C76}', inInvNumber:= '-7', inOperDate:= CURRENT_DATE, inPartnerId:= 17819, inComment:= '�� � ������ ������� :)', inInsertDate:= CURRENT_TIMESTAMP, inSession:= zfCalc_UserAdmin());
