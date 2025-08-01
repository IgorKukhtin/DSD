-- Function: gpSetErased_Movement_ProductionSeparate (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_ProductionSeparate (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_ProductionSeparate(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     IF zfConvert_StringToNumber (inSession) < 0
     THEN
         vbUserId:= lpGetUserBySession ((-1 * zfConvert_StringToNumber (inSession)) :: TVarChar);
     ELSE
         vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_ProductionSeparate());
     END IF;

     -- �������� - ���� <Master> ��������, �� <������>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

     -- �������� - ���� ���� <Child> ��������, �� <������>
     PERFORM lfCheck_Movement_ChildStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 31.05.14                                                       *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_ProductionSeparate (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
