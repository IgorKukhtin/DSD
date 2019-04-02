-- Function: gpGetMobile_Movement_CountItems

DROP FUNCTION IF EXISTS gpGetMobile_Movement_CountItems (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGetMobile_Movement_CountItems (
    IN inMovementGUID TVarChar , -- ���������� ������������� ���������
   OUT outItemsCount  Integer  , -- ���-�� ������� � ���������
    IN inSession      TVarChar   -- ������ ������������
)
RETURNS Integer
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbId Integer;
  DECLARE vbDescId Integer;
  DECLARE vbDescCode TVarChar;
  DECLARE vbDescName TVarChar;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...);
      vbUserId:= lpGetUserBySession (inSession);
      
      -- ����������� �������������� ��������� �� ����������� ����������� ��������������
      SELECT MovementString_GUID.MovementId 
           , Movement.DescId
             INTO vbId 
                , vbDescId
      FROM MovementString AS MovementString_GUID
           JOIN Movement ON Movement.Id = MovementString_GUID.MovementId
                        AND Movement.DescId <> zc_Movement_RouteMember()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inMovementGUID;

      IF COALESCE (vbId, 0) <> 0
      THEN
           IF vbDescId NOT IN (zc_Movement_OrderExternal(), zc_Movement_ReturnIn(), zc_Movement_StoreReal(), zc_Movement_RouteMember())
           THEN
                SELECT Code, ItemName INTO vbDescCode, vbDescName FROM MovementDesc WHERE Id = vbDescId;

                RAISE EXCEPTION '��� ��������� % (%) ������ �������� �� ��������������', vbDescCode, vbDescName;
           END IF;

           outItemsCount:= (SELECT COUNT (Id) FROM MovementItem WHERE MovementId = vbId AND DescId = zc_MI_Master() AND Amount <> 0 AND isErased = FALSE);
      ELSE
           outItemsCount:= 0;
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.
 16.06.17                                                       *
*/

-- ����
-- SELECT * FROM gpGetMobile_Movement_CountItems (inMovementGUID:= '{A539F063-B6B2-4089-8741-B40014ED51D7}', inSession:= zfCalc_UserAdmin())
