-- Function: gpUpdateMobile_Movement_ReturnIn_Auto

DROP FUNCTION IF EXISTS gpUpdateMobile_Movement_ReturnIn_Auto (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMobile_Movement_ReturnIn_Auto (
    IN inMovementGUID TVarChar , -- ���������� ������������� ���������
    IN inSession      TVarChar   -- ������ ������������
)
RETURNS TBlob
AS $BODY$
  DECLARE vbUserId Integer;
  DECLARE vbId Integer;
  DECLARE vbStatusId Integer;
  DECLARE vbMessageText Text:= '';
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...);
      vbUserId:= lpGetUserBySession (inSession);
      
      -- ����������� �������������� ��������� �� ����������� ����������� ��������������
      SELECT MovementString_GUID.MovementId 
           , Movement.StatusId 
      INTO vbId 
         , vbStatusId
      FROM MovementString AS MovementString_GUID
           JOIN Movement ON Movement.Id = MovementString_GUID.MovementId
                        AND Movement.DescId = zc_Movement_ReturnIn() 
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inMovementGUID;

      -- �������� �� ����������� ��������
      IF vbStatusId = zc_Enum_Status_Complete() 
      THEN
           RAISE EXCEPTION '������� ��� ��������, �������� ��� ������������.';
      END IF;

      IF COALESCE (vbId, 0) <> 0
      THEN
           IF vbStatusId <> zc_Enum_Status_UnComplete() 
           THEN 
                -- ������� ����������� ��������
                PERFORM lpUnComplete_Movement (inMovementId:= vbId, inUserId:= vbUserId);
           END IF;

           -- ��������� �������������� �������� ����� - zc_MI_Child
           vbMessageText:= lpUpdate_Movement_ReturnIn_Auto (inStartDateSale := NULL
                                                          , inEndDateSale   := NULL
                                                          , inMovementId    := vbId
                                                          , inUserId        := vbUserId
                                                           );

           -- �������
           PERFORM lpSetErased_Movement (inMovementId := vbId, inUserId:= vbUserId);

      END IF;

      RETURN vbMessageText::TBlob;

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 21.08.17                                                        *
*/

-- ����
-- SELECT gpUpdateMobile_Movement_ReturnIn_Auto (inMovementGUID:= '{D2399D25-513D-4F68-A1ED-FCD21C63A0B7}', inSession:= zfCalc_UserAdmin());
