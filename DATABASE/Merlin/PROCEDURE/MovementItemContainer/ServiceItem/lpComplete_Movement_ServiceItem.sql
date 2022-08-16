DROP FUNCTION IF EXISTS lpComplete_Movement_ServiceItem (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ServiceItem(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbId_mi_check Integer;
BEGIN

    -- ������� ��������� �������
    --PERFORM lpComplete_Movement_ServiceItem_CreateTemp();


     -- �����
     vbId_mi_check:= (WITH tmpMI AS (SELECT Movement.OperDate, MovementItem.ObjectId AS UnitId, MILinkObject_InfoMoney.ObjectId AS InfoMoneyId
                                     FROM Movement
                                          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                                 AND MovementItem.isErased   = FALSE
                                          INNER JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                            ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                           AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
                                     WHERE Movement.Id = inMovementId
                                    )
                      SELECT MovementItem.Id
                      FROM tmpMI
                           INNER JOIN Movement ON Movement.OperDate = tmpMI.OperDate
                                              AND Movement.DescId = zc_Movement_ServiceItem()
                                              AND Movement.Id <> inMovementId
                                              AND Movement.StatusId = zc_Enum_Status_Complete()
                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = FALSE
                                                  AND MovementItem.ObjectId   = tmpMI.UnitId
                           INNER JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
                                                            AND MILinkObject_InfoMoney.ObjectId       = tmpMI.InfoMoneyId
                     );

     -- ��������
     IF vbId_mi_check > 0
     THEN   
         RAISE EXCEPTION '������.����� ������� <%> <%> �� <%> ��� ����������.������������ ���������.'
                       , lfGet_Object_ValueData ((SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.Id = vbId_mi_check))
                       , lfGet_Object_ValueData ((SELECT MILO.ObjectId FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbId_mi_check AND MILO.DescId = zc_MILinkObject_InfoMoney()))
                       , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                        ; 
     END IF;


    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_ServiceItem()
                               , inUserId     := inUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.06.22         *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_ServiceItem (inMovementId:= 40980, inUserId := zfCalc_UserAdmin() :: Integer);
