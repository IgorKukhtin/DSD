-- Function: lpComplete_Movement_IncomeCost ()

DROP FUNCTION IF EXISTS lpComplete_Movement_IncomeCost  (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_IncomeCost(
    IN inMovementId        Integer               , -- ���� ���������
    IN inUserId            Integer                 -- ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId_from Integer;
BEGIN
     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;


     -- ����� �������� �� �������� ���� ����� ����� "������"
     vbMovementId_from:= (SELECT MovementFloat.ValueData :: Integer FROM MovementFloat WHERE MovementFloat.MovementId = inMovementId AND MovementFloat.DescId = zc_MovementFloat_MovementId());

     -- ���������� ����� "������"
     INSERT INTO _tmpItem_From (InfoMoneyId, OperSumm)
        -- ������� ������� ��������
        WITH tmpAccount AS (SELECT * FROM Object_Account_View WHERE Object_Account_View.AccountGroupId = zc_Enum_AccountGroup_50000())
        SELECT CLO_InfoMoney.ObjectId, SUM (MIContainer.Amount) AS Amount
        FROM MovementItemContainer AS MIContainer
             INNER JOIN tmpAccount ON tmpAccount.AccountId = MIContainer.AccountId
             LEFT JOIN ContainerLinkObject AS CLO_InfoMoney ON CLO_InfoMoney.ContainerId = MIContainer.ContainerId AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
        WHERE MIContainer.MovementId = vbMovementId_from
          AND MIContainer.DescId     = zc_MIContainer_Summ()
        GROUP BY CLO_InfoMoney.ObjectId
        ;
     -- ���������� ��������� � ������� ���� ������������ "������"
     INSERT INTO _tmpItem_To (MovementId_cost, MovementId_in, InfoMoneyId, OperSumm, OperSumm_calc)
        -- ������� ������� ��������
        SELECT Movement.Id AS MovementId_cost, Movement_Income.Id AS MovementId_in, _tmpItem_From.InfoMoneyId, MovementFloat_TotalSumm.ValueData AS OperSumm, 0 AS OperSumm_calc
        FROM MovementFloat
             INNER JOIN Movement ON Movement.Id = MovementFloat.MovementId
                                AND (Movement.StatusId = zc_Enum_Status_Complete()
                                  OR Movement.Id       = inMovementId)
             INNER JOIN Movement AS Movement_Income ON Movement_Income.Id       = Movement.ParentId
                                                   AND Movement_Income.DescId   = zc_Movement_Income()
                                                   AND Movement_Income.StatusId = zc_Enum_Status_Complete()
             LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                     ON MovementFloat_TotalSumm.MovementId = Movement_Income.Id
                                    AND MovementFloat_TotalSumm.DescId     = zc_MovementFloat_TotalSumm()
             CROSS JOIN _tmpItem_From
        WHERE MovementFloat.ValueData = vbMovementId_from
          AND MovementFloat.DescId    = zc_MovementFloat_MovementId()
        ;

     -- ������������� "������"
     UPDATE _tmpItem_To SET OperSumm_calc = tmp.OperSumm_calc
     FROM (WITH tmpItem_To_summ AS (SELECT _tmpItem_To.InfoMoneyId, SUM (_tmpItem_To.OperSumm) AS OperSumm FROM _tmpItem_To GROUP BY _tmpItem_To.InfoMoneyId)
                       , tmpRes AS (SELECT _tmpItem_To.MovementId_cost
                                         , _tmpItem_To.InfoMoneyId
                                         , CAST (_tmpItem_From.OperSumm * _tmpItem_To.OperSumm / tmpItem_To_summ.OperSumm AS Numeric(16, 2)) AS OperSumm_calc
                                           -- � �/�
                                         , ROW_NUMBER() OVER (PARTITION BY _tmpItem_To.InfoMoneyId ORDER BY _tmpItem_To.OperSumm DESC) AS Ord
                                    FROM _tmpItem_To
                                         INNER JOIN tmpItem_To_summ ON tmpItem_To_summ.InfoMoneyId = _tmpItem_To.InfoMoneyId
                                                                   AND tmpItem_To_summ.OperSumm    <> 0
                                         INNER JOIN _tmpItem_From   ON _tmpItem_From.InfoMoneyId    = _tmpItem_To.InfoMoneyId
                                   )
                       , tmpDiff AS (SELECT tmpRes_summ.InfoMoneyId
                                          , tmpRes_summ.OperSumm_calc - _tmpItem_From.OperSumm AS OperSumm_diff
                                    FROM (SELECT tmpRes.InfoMoneyId, SUM (tmpRes.OperSumm_calc) AS OperSumm_calc FROM tmpRes GROUP BY tmpRes.InfoMoneyId
                                         ) AS tmpRes_summ
                                         INNER JOIN _tmpItem_From ON _tmpItem_From.InfoMoneyId = tmpRes_summ.InfoMoneyId
                                    WHERE _tmpItem_From.OperSumm <> tmpRes_summ.OperSumm_calc
                                   )
           SELECT tmpRes.MovementId_cost, tmpRes.InfoMoneyId, tmpRes.OperSumm_calc - COALESCE (tmpdiff.OperSumm_diff, 0) As OperSumm_calc
           FROM tmpRes
                LEFT JOIN tmpDiff ON tmpDiff.InfoMoneyId = tmpRes.InfoMoneyId
                                 AND                   1 = tmpRes.Ord
          ) AS tmp
     WHERE tmp.MovementId_cost = _tmpItem_To.MovementId_cost
       AND tmp.InfoMoneyId     = _tmpItem_To.InfoMoneyId
    ;

     -- ��������� ������������� "������"
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountCost(), tmp.MovementId_cost, tmp.OperSumm_calc)
     FROM (SELECT _tmpItem_To.MovementId_cost, SUM (_tmpItem_To.OperSumm_calc) AS OperSumm_calc FROM _tmpItem_To GROUP BY _tmpItem_To.MovementId_cost) AS tmp
    ;



     -- 5.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_IncomeCost()
                                , inUserId     := inUserId
                                 );

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.01.19                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_IncomeCost ()
