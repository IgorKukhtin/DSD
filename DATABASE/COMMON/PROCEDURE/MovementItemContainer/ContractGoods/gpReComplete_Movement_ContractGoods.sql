-- Function: gpReComplete_Movement_ContractGoods(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_ContractGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_ContractGoods(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ContractGoods());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_ContractGoods())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;

     -- �������� ��������
     PERFORM gpComplete_Movement_ContractGoods (inMovementId     := inMovementId
                                              , inSession        := inSession
                                               );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.06.21         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpReComplete_Movement_ContractGoods (inMovementId:= 122175, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
