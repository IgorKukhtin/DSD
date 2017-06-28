-- Function: gpSetStatusMobile_Movement

DROP FUNCTION IF EXISTS gpSetStatusMobile_Movement ();

CREATE OR REPLACE FUNCTION gpSetStatusMobile_Movement (
    IN inMovementGUID TVarChar , -- ���������� ������������� ���������
    IN inStatusId     Integer  , -- ����� ������ ���������
    IN inSession      TVarChar   -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbId Integer;
  DECLARE vbDescId Integer;
  DECLARE vbDescCode TVarChar;
  DECLARE vbDescName TVarChar;
  DECLARE vbStatusId Integer;
  DECLARE vbPrinted Boolean;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...);
      vbUserId:= lpGetUserBySession (inSession);
      
      -- ����������� �������������� ��������� �� ����������� ����������� ��������������
      SELECT MovementString_GUID.MovementId 
           , Movement.DescId
           , Movement.StatusId
      INTO vbId 
         , vbDescId
         , vbStatusId
      FROM MovementString AS MovementString_GUID
           JOIN Movement ON Movement.Id = MovementString_GUID.MovementId
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inMovementGUID;

      IF COALESCE (vbId, 0) <> 0
      THEN
           IF vbDescId NOT IN (zc_Movement_OrderExternal(), zc_Movement_ReturnIn(), zc_Movement_StoreReal())
           THEN
                SELECT Code, ItemName INTO vbDescCode, vbDescName FROM MovementDesc WHERE Id = vbDescId;

                RAISE EXCEPTION '��� ��������� % (%) ������ �������� �� ��������������', vbDescCode, vbDescName;
           END IF;

           IF vbStatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_Erased())
           THEN 
                IF vbDescId = zc_Movement_OrderExternal()
                THEN -- ���� ������ ���������, �� �����������
                     SELECT outPrinted INTO vbPrinted FROM lpUnComplete_Movement_OrderExternal (inMovementId:= vbId, inUserId:= vbUserId);
                ELSIF vbDescId = zc_Movement_ReturnIn()
                THEN -- ����������� ��������
                     PERFORM lpUnComplete_Movement (inMovementId:= vbId, inUserId:= vbUserId);
                ELSIF vbDescId = zc_Movement_StoreReal()
                THEN -- ���� ����������� ������� ��������, �� �����������    
                     PERFORM gpUnComplete_Movement_StoreReal (inMovementId:= vbId, inSession:= inSession);
                END IF;
           END IF;
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.
 27.06.17                                                       *
*/

-- ����
-- SELECT * FROM gpSetStatusMobile_Movement (inMovementGUID:= '{A539F063-B6B2-4089-8741-B40014ED51D7}', inStatusId:= zc_Enum_Status_Erased(), inSession:= zfCalc_UserAdmin())
