-- Function: gpUnComplete_Movement_ChoiceCell (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_ChoiceCell (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_ChoiceCell(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_ChoiceCell());

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
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
-- SELECT * FROM gpUnComplete_Movement_ChoiceCell (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
