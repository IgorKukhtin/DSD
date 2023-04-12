-- Function: gpSetErased_Movement_GoodsSP408_1303 (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_GoodsSP408_1303 (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_GoodsSP408_1303(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_GoodsSP_1303());

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
 11.04.23                                                       *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_GoodsSP408_1303 (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
