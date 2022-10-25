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

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_Sale())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Sale_CreateTemp();

if vbUserId IN (5) AND 1=0 THEN
     -- �������� ��������
     PERFORM lpComplete_Movement_Sale2222 (inMovementId     := inMovementId
                                     , inUserId         := vbUserId
                                     , inIsLastComplete := inIsLastComplete);
else
     -- �������� ��������
     PERFORM lpComplete_Movement_Sale (inMovementId     := inMovementId
                                     , inUserId         := vbUserId
                                     , inIsLastComplete := inIsLastComplete);
end if;

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
