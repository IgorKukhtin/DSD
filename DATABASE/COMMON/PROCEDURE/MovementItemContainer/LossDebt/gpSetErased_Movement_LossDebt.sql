-- Function: gpSetErased_Movement_LossDebt (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_LossDebt (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_LossDebt(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_LossDebt());

     IF inMovementId = 123096 -- � 15 �� 31.12.2013
     OR inMovementId = 19270690 -- � 259 �� 28.02.2021
     THEN
         RAISE EXCEPTION '������.�������� �� ����� ���� ������.';
     END IF;

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 30.01.14         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_LossDebt (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
