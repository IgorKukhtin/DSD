-- Function: gpSetErased_Movement_ChoiceCell (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_ChoiceCell (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_ChoiceCell(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_ChoiceCell());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.08.24         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_ChoiceCell (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
