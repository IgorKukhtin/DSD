-- Function: gpSetErased_Movement_ContractGoods (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_ContractGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_ContractGoods(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_ContractGoods());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.06.21         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_ContractGoods (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
