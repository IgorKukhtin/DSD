-- Function: gpSetErased_Movement_ProfitLossService (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_ProfitLossService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_ProfitLossService(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= PERFORM lpCheckRight(inSession, zc_Enum_Process_SetErased_ProfitLossService());
     vbUserId:=2;


     -- �������� - ���� <Master> ��������, �� <������>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

     -- �������� - ���� ���� <Child> ��������, �� <������>
     PERFORM lfCheck_Movement_ChildStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.02.14				                                            *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_ProfitLossService (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
