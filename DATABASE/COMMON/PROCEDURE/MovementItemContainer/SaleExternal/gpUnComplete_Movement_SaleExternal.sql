-- Function: gpUnComplete_Movement_SaleExternal (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_SaleExternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_SaleExternal(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_SaleExternal());

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.11.20         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_SaleExternal (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
