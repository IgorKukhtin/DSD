-- Function: gpSetMobileErased_Movement_OrderExternal

DROP FUNCTION IF EXISTS gpSetMobileErased_Movement_OrderExternal (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSetMobileErased_Movement_OrderExternal (
    IN inMovementGUID TVarChar , -- ���������� ���������� ������������� ���������
    IN inSession      TVarChar   -- ������ ������������
)
RETURNS VOID
AS $BODY$
  DECLARE vbUserId Integer;
  DECLARE vbId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...);
      vbUserId:= lpGetUserBySession (inSession);
      
      -- ����������� �������������� ��������� �� ����������� ����������� ��������������
      SELECT MovementString_GUID.MovementId 
      INTO vbId 
      FROM MovementString AS MovementString_GUID
           JOIN Movement ON Movement.Id = MovementString_GUID.MovementId
                        AND Movement.DescId = zc_Movement_OrderExternal()
                        AND Movement.StatusId = zc_Enum_Status_UnComplete()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inMovementGUID;

      IF COALESCE (vbId, 0) <> 0
      THEN
           PERFORM lpSetErased_Movement (inMovementId:= vbId, inUserId:= vbUserId);
      END IF;

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.
 19.09.17                                                       *
*/

-- ����
-- SELECT * FROM gpSetMobileErased_Movement_OrderExternal (inMovementGUID:= '{A539F063-B6B2-4089-8741-B40014ED51D7}', inSession:= zfCalc_UserAdmin())
