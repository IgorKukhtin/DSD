-- Function: lpUpdate_Movement_Cash_CarNull()

DROP FUNCTION IF EXISTS lpUpdate_Movement_Cash_CarNull (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_Cash_CarNull(
    IN inId                    Integer   , -- ���� ������� <������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inUserId                Integer     -- ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbStatusId Integer;
BEGIN

     -- ��������, !!!������ ���� ��� �� �������� �� ���������!!!
     IF ( COALESCE (inMovementId, 0) = 0 OR COALESCE (inId, 0) = 0)
     THEN
        RETURN;
     END IF;


     vbStatusId := (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);

     --���� �������� �������� �����������
     IF vbStatusId = zc_Enum_Status_Complete()
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := inUserId);
     END IF;
     
      -- �������� ����
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Car(), inId, NULL);

     -- ���� �������� ��� �������� - ��������
     IF vbStatusId = zc_Enum_Status_Complete()
     THEN
         -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
         PERFORM lpComplete_Movement_Finance_CreateTemp();

         -- �������� ��������
         PERFORM lpComplete_Movement_Cash (inMovementId := inMovementId
                                         , inUserId     := inUserId
                                          ); 
     END IF;
     
     
     -- ��������� ��������
     --PERFORM lpInsert_MovementItemProtocol (inId, inUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.10.22         *
*/

-- ����
--


/*   --��������� ��������� ����

SELECT Movement.*, Object_InfoMoney.*
    --, lpUpdate_Movement_Cash_CarNull (inMovementId:= Movement.Id, inId:= MovementItem.Id, inUserId = zfCalc_UserAdmin()::Integer)
FROM Movement
    INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                           AND MovementItem.DescId = zc_MI_Master()
                           AND MovementItem.isErased = False
    INNER JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                      ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                     AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                     AND MILinkObject_InfoMoney.ObjectId <> zc_Enum_InfoMoney_20401()
    INNER JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = MILinkObject_InfoMoney.ObjectId

    INNER JOIN MovementItemLinkObject AS MILinkObject_Car
                                      ON MILinkObject_Car.MovementItemId = MovementItem.Id
                                     AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
                                     AND MILinkObject_Car.ObjectId > 0
WHERE Movement.DescId = zc_Movement_Cash()
 AND Movement.StatusId = zc_Enum_Status_Complete()
 AND Movement.OperDate BETWEEN  '01.08.2022' AND '01.11.2022'

*/




 /* --������� ������ �� ���������� ����� , ��� ������ ����     
 
SELECT DISTINCT
       Min (Movement.OperDate)  AS OperDate_min
     , Max (Movement.OperDate)  AS OperDate_max
     , MILinkObject_InfoMoney.ObjectId AS InfoMoneyId
     , Object_InfoMoney.ValueDAta      AS InfoMoneyName
FROM Movement
     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                            AND MovementItem.DescId = zc_MI_Master()
                            AND MovementItem.isErased = False
     INNER JOIN MovementItemLinkObject AS MILinkObject_Car
                                ON MILinkObject_Car.MovementItemId = MovementItem.Id
                               AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
                               AND MILinkObject_Car.ObjectId > 0
     INNER JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                       ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                      AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
     LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = MILinkObject_InfoMoney.ObjectId

WHERE Movement.DescId = zc_Movement_Cash()
 AND Movement.StatusId = zc_Enum_Status_Complete()
and Movement.OperDate BETWEEN  '01.10.2022' AND '01.11.2022'
group by MILinkObject_InfoMoney.ObjectId 
       , Object_InfoMoney.VAlueData    


*/