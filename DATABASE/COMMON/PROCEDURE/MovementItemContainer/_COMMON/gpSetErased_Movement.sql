-- Function: gpSetErased_Movement (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSetErased_Movement (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement(
    IN inMovementId Integer               , -- ���� ������� <��������>
--    IN inIsChild    Boolean  DEFAULT TRUE , -- ���� �� � ����� ��������� ����������� ��������� !!!�� � ���� ������ �� ������� FALSE!!!
    IN inSession    TVarChar DEFAULT ''     -- ������� ������������
)                              
  RETURNS void
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_SetErased_Movement());
     vbUserId:=2; -- CAST (inSession AS Integer);


     -- �������� - ���� <Master> ��������, �� <������>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

     -- �������� - ���� ���� <Child> ��������, �� <������>
     PERFORM lfCheck_Movement_ChildStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);
/*
     -- ������� ����������� ���������
     PERFORM lpSetErased_Movement (inMovementId := Movement.Id
                                 , inUserId     := vbUserId)
     FROM Movement
     WHERE ParentId = inMovementId;
*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSetErased_Movement (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.10.13                                        * del ������� ����������� ���������
 12.10.13                                        * add lfCheck_Movement_ParentStatus and lfCheck_Movement_ChildStatus
 06.10.13                                        *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement (inMovementId:= 55, inIsChild := TRUE, inSession:= '2')
