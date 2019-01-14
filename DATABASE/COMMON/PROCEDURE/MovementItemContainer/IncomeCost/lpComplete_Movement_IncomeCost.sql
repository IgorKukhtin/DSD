-- Function: lpComplete_Movement_IncomeCost ()

DROP FUNCTION IF EXISTS lpComplete_Movement_IncomeCost  (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_IncomeCost(
    IN inMovementId        Integer               , -- ключ Документа
    IN inUserId            Integer                 -- Пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId_from Integer;
BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- нашли документ из которого надо взять сумму "затрат"
     vbMovementId_from:= (SELECT MovementFloat.ValueData :: Integer FROM MovementFloat WHERE MovementFloat.MovementId = inMovementId AND MovementFloat.DescId = zc_MovementFloat_MovementId());

     -- определили сумму "затрат"
     INSERT INTO _tmpItem_From (InfoMoneyId, OperSumm)
        -- Расходы будущих периодов
        WITH tmpAccount AS (SELECT * FROM Object_Account_View WHERE Object_Account_View.AccountGroupId = zc_Enum_AccountGroup_50000())
        SELECT CLO_InfoMoney.ObjectId, SUM (MIContainer.Amount) AS Amount
        FROM MovementItemContainer AS MIContainer
             INNER JOIN tmpAccount ON tmpAccount.AccountId = MIContainer.AccountId
             LEFT JOIN ContainerLinkObject AS CLO_InfoMoney ON CLO_InfoMoney.ContainerId = MIContainer.ContainerId AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
        WHERE MIContainer.MovementId = vbMovementId_from
          AND MIContainer.DescId     = zc_MIContainer_Summ()
        GROUP BY CLO_InfoMoney.ObjectId
        ;
     -- определили документы в которые надо распределить "затрат"
     INSERT INTO _tmpItem_To (MovementId, InfoMoneyId, OperSumm, OperSumm_calc)
        -- Расходы будущих периодов
        SELECT MovementFloat.MovementId, _tmpItem_From.InfoMoneyId, MovementFloat_TotalSumm.ValueData AS OperSumm, 0 AS OperSumm_calc
        FROM MovementFloat
             INNER JOIN Movement ON Movement.Id       = MovementFloat.MovementId
                                AND Movement.DescId   = zc_Movement_Income()
                                AND Movement.StatusId = zc_Enum_Status_Complete()
             LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                     ON MovementFloat_TotalSumm.MovementId = MovementFloat.MovementId
                                    AND MovementFloat_TotalSumm.DescId     = zc_MovementFloat_TotalSumm()
             CROSS JOIN _tmpItem_From
        WHERE MovementFloat.ValueData = vbMovementId_from
          AND MovementFloat.DescId    = zc_MovementFloat_MovementId()
        ;

     -- распределение "затрат"
     UPDATE _tmpItem_To SET OperSumm_calc = tmp.OperSumm_calc
     FROM (WITH tmpItem_To_summ AS (SELECT _tmpItem_To.InfoMoneyId, SUM (_tmpItem_To.OperSumm) AS OperSumm FROM _tmpItem_To GROUP BY _tmpItem_To.InfoMoneyId)
                       , tmpRes AS (SELECT _tmpItem_To.MovementId
                                         , _tmpItem_To.InfoMoneyId
                                         , _tmpItem_From.OperSumm * _tmpItem_To.OperSumm / tmpItem_To_summ.OperSumm AS OperSumm_calc
                                           -- № п/п
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
           SELECT tmpRes.MovementId, tmpRes.InfoMoneyId, tmpRes.OperSumm_calc - COALESCE (tmpdiff.OperSumm_diff, 0) As OperSumm_calc
           FROM tmpRes
                LEFT JOIN tmpDiff ON tmpDiff.InfoMoneyId = tmpRes.InfoMoneyId
                                 AND                   1 = tmpRes.Ord
          ) AS tmp
     WHERE tmp.MovementId  = _tmpItem_To.MovementId
       AND tmp.InfoMoneyId = _tmpItem_To.InfoMoneyId
    ;

     -- сохранили распределение "затрат"
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementId(), ioId, inMovementId)
     FROM _tmpItem_To
     UPDATE _tmpItem_To SET OperSumm_calc = tmp.OperSumm_calc
     FROM (WITH tmpItem_To_summ AS (SELECT _tmpItem_To.InfoMoneyId, SUM (_tmpItem_To.OperSumm) AS OperSumm FROM _tmpItem_To GROUP BY _tmpItem_To.InfoMoneyId)
                       , tmpRes AS (SELECT _tmpItem_To.MovementId
                                         , _tmpItem_To.InfoMoneyId
                                         , _tmpItem_From.OperSumm * _tmpItem_To.OperSumm / tmpItem_To_summ.OperSumm AS OperSumm_calc
                                           -- № п/п
                                         , ROW_NUMBER() OVER (PARTITION BY _tmpItem_To.InfoMoneyId ORDER BY _tmpItem_To.OperSumm DESC) AS Ord
                                    FROM _tmpItem_To
                                         INNER JOIN tmpItem_To_summ ON tmpItem_To_summ.InfoMoneyId = _tmpItem_To.InfoMoneyId
                                         INNER JOIN _tmpItem_From   ON _tmpItem_From.InfoMoneyId    = _tmpItem_To.InfoMoneyId
                                   )
                       , tmpDiff AS (SELECT tmpRes_summ.InfoMoneyId
                                          , _tmpItem_From.OperSumm - tmpRes_summ.OperSumm_calc AS OperSumm_diff
                                    FROM (SELECT tmpRes.InfoMoneyId, SUM (tmpRes.OperSumm_calc) AS OperSumm_calc FROM tmpRes GROUP BY tmpRes.InfoMoneyId
                                         ) AS tmpRes_summ
                                         INNER JOIN _tmpItem_From ON _tmpItem_From.InfoMoneyId = tmpRes_summ.InfoMoneyId
                                    WHERE _tmpItem_From.OperSumm <> tmpRes_summ.OperSumm_calc
                                   )
           SELECT tmpRes.MovementId, tmpRes.InfoMoneyId, tmpRes.OperSumm_calc - COALESCE (tmpdiff.OperSumm_diff, 0) As OperSumm_calc
           FROM tmpRes
                LEFT JOIN tmpDiff ON tmpDiff.InfoMoneyId = tmpRes.InfoMoneyId
                                 AND                   1 = tmpRes.Ord
          ) AS tmp
     WHERE tmp.MovementId  = _tmpItem_To.MovementId
       AND tmp.InfoMoneyId = _tmpItem_To.InfoMoneyId
    ;




     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_IncomeCost()
                                , inUserId     := inUserId
                                 );

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.01.19                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_IncomeCost ()
