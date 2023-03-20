-- Function: gpComplete_Movement_Sale(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpComplete_Movement_Sale (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Sale (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Sale(
    IN inMovementId        Integer               , -- ���� ���������
    IN inIsLastComplete    Boolean  DEFAULT FALSE, -- ��� ��������� ���������� ����� ������� �/� (��� ������� �������� !!!�� ��������������!!!)
    IN inIsRecalcPrice     Boolean  DEFAULT TRUE , -- �������� ��� �� ������ ��� ����� ��� ����������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Sale());


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Sale_CreateTemp();
--
if vbUserId IN (9459, 5) AND 1=0 THEN
     -- �������� ��������
     PERFORM lpComplete_Movement_Sale22 (inMovementId     := inMovementId
                                       , inUserId         := vbUserId
                                       , inIsLastComplete := inIsLastComplete
                                       , inIsRecalcPrice  := inIsRecalcPrice
                                        );
ELSE
     -- �������� ��������
     PERFORM lpComplete_Movement_Sale (inMovementId     := inMovementId
                                     , inUserId         := vbUserId
                                     , inIsLastComplete := inIsLastComplete
                                     , inIsRecalcPrice  := inIsRecalcPrice
                                      );
END IF;

if vbUserId = 5 AND 1=0
then
    RAISE EXCEPTION '������.Test - ok';
end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 30.11.14                                        * add lpComplete_Movement_Sale_CreateTemp
 17.08.14                                        * add MovementDescId
 22.07.14                                        * add ...Price
 05.05.14                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Sale (inMovementId:= 122175, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
