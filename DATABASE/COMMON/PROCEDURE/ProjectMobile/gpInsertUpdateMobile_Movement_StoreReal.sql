-- Function: gpInsertUpdateMobile_Movement_StoreReal()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_StoreReal (TVarChar, TVarChar, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_StoreReal (TVarChar, TVarChar, TDateTime, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_StoreReal (TVarChar, TVarChar, TDateTime, Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Movement_StoreReal (
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
           JOIN Movement AS Movement_StoreReal
                         ON Movement_StoreReal.Id = MovementString_GUID.MovementId
                        AND Movement_StoreReal.DescId = zc_Movement_StoreReal()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inGUID;

      vbId:= lpInsertUpdate_Movement_StoreReal (ioId:= vbId
                                              , inInvNumber:= inInvNumber
                                              , inOperDate:= inOperDate
                                              , inUserId:= vbUserId
                                              , inPartnerId:= inPartnerId
                                              , inGUID:= inGUID
                                              , inComment:= inComment 
                                               );

      -- ��������� �������� <����/����� �������� �� ��������� ����������>
      PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_InsertMobile(), vbId, inInsertDate);

      RETURN vbId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 16.02.17                                                        *                                          
*/

-- ����
-- SELECT * FROM gpInsertUpdateMobile_Movement_StoreReal (inGUID:= '{678E6742-8182-4FF4-8882-D1DFF49D6C62}', inInvNumber:= '-3', inOperDate:= CURRENT_DATE, inPartnerId:= 17819, inComment:= '�� � ������ ������� :)', inInsertDate:= CURRENT_TIMESTAMP, inSession:= zfCalc_UserAdmin());
