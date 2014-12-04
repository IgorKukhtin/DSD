-- Function: gpReComplete_Movement_Sale(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_Sale (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_Sale(
    IN inMovementId        Integer               , -- ���� ���������
    IN inIsLastComplete    Boolean  DEFAULT FALSE, -- ��� ��������� ���������� ����� ������� �/� (��� ������� �������� !!!�� ��������������!!!)
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Sale());

     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Sale_CreateTemp();

     -- �������� ��������
     PERFORM lpComplete_Movement_Sale (inMovementId     := inMovementId
                                     , inUserId         := vbUserId
                                     , inIsLastComplete := inIsLastComplete);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.11.14                                        * add lpComplete_Movement_Sale_CreateTemp
 27.11.14                                                       *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpReComplete_Movement_Sale (inMovementId:= 122175, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
