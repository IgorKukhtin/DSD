-- Function: gpUnComplete_Movement_CurrencyList (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_CurrencyList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_CurrencyList(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_CurrencyList());

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.11.14                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_CurrencyList (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())