-- Function: gpSetErased_Movement_BankSecondNum (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_BankSecondNum (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_BankSecondNum(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_BankSecondNum());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.03.24         * 
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_BankSecondNum (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
