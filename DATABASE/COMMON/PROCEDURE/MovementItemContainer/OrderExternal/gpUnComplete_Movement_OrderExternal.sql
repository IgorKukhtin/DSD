-- Function: gpUnComplete_Movement_OrderExternal (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_OrderExternal (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUnComplete_Movement_OrderExternal (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_OrderExternal(
    IN inMovementId        Integer               , -- ���� ���������
   OUT outPrinted          Boolean               ,
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������

)
RETURNS Boolean
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbDescId_From Integer;
BEGIN
     --�� ����� ��������� �������� ��� ��������� <�� ����>
     vbDescId_From := (SELECT Object.DescId
                       FROM MovementLinkObject AS MLO
                           LEFT JOIN Object ON Object.Id = MLO.ObjectId
                       WHERE MLO.MovementId = inMovementId 
                         AND MLO.DescId = zc_MovementLinkObject_From());

     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, CASE WHEN vbDescId_From = zc_Object_Unit() THEN zc_Enum_Process_UnComplete_OrderExternalUnit() ELSE zc_Enum_Process_UnComplete_OrderExternal() END);


     -- ������ ������ ��������� + ��������� ��������
     outPrinted := lpUnComplete_Movement_OrderExternal (inMovementId := inMovementId, inUserId := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.09.21         *
 21.04.17                                        *
 06.06.14                                                       *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_OrderExternal (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())