-- Function: lpComplete_Movement_IncomeCost ()

DROP FUNCTION IF EXISTS lpComplete_Movement_IncomeCost  (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_IncomeCost(
    IN inMovementId        Integer               , -- ключ Документа
    IN inUserId            Integer                 -- Пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId_from     Integer;
   DECLARE vbMovementDescId_from Integer;
   DECLARE vbMovementId_to       Integer;
   DECLARE vbOperDate_to         TDateTime;
BEGIN
     -- нашли документ из которого надо взять сумму "затрат"
     vbMovementId_from:= (SELECT MovementFloat.ValueData :: Integer FROM MovementFloat WHERE MovementFloat.MovementId = inMovementId AND MovementFloat.DescId = zc_MovementFloat_MovementId());
     vbMovementDescId_from:= (SELECT Movement.DescId FROM Movement WHERE Movement.Id = vbMovementId_from);

     -- нашли документ, для товаров которого добавляется сумма "затрат" - !!!но они сформируются в inMovementId!!!
     vbMovementId_to:= (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = inMovementId);
     vbOperDate_to:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbOperDate_to);


     -- Перепроведение, что б "затраты" оказались во ВСЕХ "Расходы будущих периодов"
     IF vbMovementDescId_from = zc_Movement_TransportService() -- AND 1=0
     THEN
         PERFORM gpReComplete_Movement_TransportService (inMovementId, inUserId :: TVarChar);
         --
         DROP TABLE _tmpItem;

     ELSEIF vbMovementDescId_from = zc_Movement_Transport() -- AND 1=0
     THEN
         PERFORM gpReComplete_Movement_Transport (inMovementId, NULL, inUserId :: TVarChar);
         --
         DROP TABLE _tmpItem;

     END IF;
     
     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_IncomeCost_CreateTemp();


     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;



     -- определили сумму "затрат" - хотя они в БАЛАНСЕ как Расходы будущих периодов
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
     INSERT INTO _tmpItem_To (MovementId_cost, MovementId_in, InfoMoneyId, OperCount, OperSumm, OperSumm_calc)
        -- Расходы будущих периодов
        SELECT Movement.Id AS MovementId_cost, Movement_Income.Id AS MovementId_in, _tmpItem_From.InfoMoneyId
               -- ВЕС
             , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                              THEN MovementItem.Amount * COALESCE (ObjectFloat_Weight.ValueData, 0)
                         ELSE MovementItem.Amount
                    END) AS OperCount
             , 0 /*MovementFloat_TotalSumm.ValueData*/ AS OperSumm
             , 0 AS OperSumm_calc
        FROM MovementFloat
             INNER JOIN Movement ON Movement.Id = MovementFloat.MovementId
                                AND (Movement.StatusId = zc_Enum_Status_Complete()
                                  OR Movement.Id       = inMovementId)
             INNER JOIN Movement AS Movement_Income ON Movement_Income.Id       = Movement.ParentId
                                                   AND Movement_Income.DescId   = zc_Movement_Income()
                                                   AND Movement_Income.StatusId = zc_Enum_Status_Complete()
             INNER JOIN MovementItem ON MovementItem.Id       = Movement_Income.MovementId
                                    AND MovementItem.DescId   = zc_MI_Master()
                                    AND MovementItem.isErased = FALSE
             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                   ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                  AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                                  AND tmpMI.DescId = zc_MI_Master()
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             /*LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                     ON MovementFloat_TotalSumm.MovementId = Movement_Income.Id
                                    AND MovementFloat_TotalSumm.DescId     = zc_MovementFloat_TotalSumm()*/
             CROSS JOIN _tmpItem_From
        WHERE MovementFloat.ValueData = vbMovementId_from
          AND MovementFloat.DescId    = zc_MovementFloat_MovementId()
        GROUP BY Movement.Id, Movement_Income.Id, _tmpItem_From.InfoMoneyId
        ;

     -- распределение "затрат"
     UPDATE _tmpItem_To SET OperSumm_calc = tmp.OperSumm_calc
     FROM (WITH tmpItem_To_summ AS (SELECT _tmpItem_To.InfoMoneyId, SUM (_tmpItem_To.OperCount) AS OperCount FROM _tmpItem_To GROUP BY _tmpItem_To.InfoMoneyId)
                       , tmpRes AS (SELECT _tmpItem_To.MovementId_cost
                                         , _tmpItem_To.InfoMoneyId
                                         , CAST (_tmpItem_From.OperSumm * _tmpItem_To.OperCount / tmpItem_To_summ.OperCount AS Numeric(16, 2)) AS OperSumm_calc
                                           -- № п/п
                                         , ROW_NUMBER() OVER (PARTITION BY _tmpItem_To.InfoMoneyId ORDER BY _tmpItem_To.OperCount DESC) AS Ord
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
           -- Результат
           SELECT tmpRes.MovementId_cost, tmpRes.InfoMoneyId, tmpRes.OperSumm_calc - COALESCE (tmpdiff.OperSumm_diff, 0) As OperSumm_calc
           FROM tmpRes
                LEFT JOIN tmpDiff ON tmpDiff.InfoMoneyId = tmpRes.InfoMoneyId
                                 AND                   1 = tmpRes.Ord
          ) AS tmp
     WHERE tmp.MovementId_cost = _tmpItem_To.MovementId_cost
       AND tmp.InfoMoneyId     = _tmpItem_To.InfoMoneyId
    ;

     -- сохранили распределение "затрат" - !!!Во ВСЕ zc_Movement_IncomeCost, куда они распределяются!!!
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountCost(), tmp.MovementId_cost, tmp.OperSumm_calc)
     FROM (SELECT _tmpItem_To.MovementId_cost, SUM (_tmpItem_To.OperSumm_calc) AS OperSumm_calc FROM _tmpItem_To GROUP BY _tmpItem_To.MovementId_cost) AS tmp
    ;


     -- проводки только для !!!ОДНОГО!!! zc_Movement_IncomeCost = inMovementId
     INSERT INTO _tmpItem (MovementItemId, ContainerId_Goods, ContainerId_summ, AccountId, Amount, OperSumm, OperSumm_calc, InfoMoneyId)
        WITH -- товары Из прихода, к которым добавляется сумма "затрат"
             tmpMIContainer_all AS (SELECT MIContainer.*
                                    FROM MovementItemContainer AS MIContainer
                                    WHERE MIContainer.MovementId = vbMovementId_to
                                   )
            , tmpMIContainer AS (SELECT tmpMIContainer_Count.MovementItemId
                                      , tmpMIContainer_Count.ContainerId
                                      , tmpMIContainer_Count.Amount
                                      , tmpMIContainer_Summ.OperSumm
                                 FROM tmpMIContainer AS tmpMIContainer_Count
                                      LEFT JOIN (SELECT tmpMIContainer.MovementItemId SUM (tmpMIContainer.Amount) AS OperSumm FROM tmpMIContainer WHERE tmpMIContainer.DescId = zc_MIContainer_Summ() AND tmpMIContainer.Amount > 0 GROUP BY tmpMIContainer.MovementItemId
                                                ) AS tmpMIContainer_Summ
                                                  ON tmpMIContainer_Summ.MovementItemId = tmpMIContainer.MovementItemId
                                 WHERE tmpMIContainer_Count.DescId = zc_MIContainer_Count()
                                   AND tmpMIContainer_Count.Amount > 0
                                )
             -- распределение "затрат"
           , tmpItem_To_summ AS (SELECT SUM (tmpMIContainer.Amount) AS Amount FROM tmpMIContainer)
                    , tmpRes AS (SELECT tmpMIContainer.*
                                      , _tmpItem_To.InfoMoneyId
                                      , CAST (_tmpItem_To.OperSumm_calc * tmpMIContainer.Amount / tmpItem_To_summ.Amount AS Numeric(16, 2)) AS OperSumm_calc
                                        -- № п/п
                                      , ROW_NUMBER() OVER (PARTITION BY _tmpItem_To.InfoMoneyId ORDER BY tmpMIContainer.Amount DESC) AS Ord
                                 FROM tmpMIContainer
                                      INNER JOIN tmpItem_To_summ ON tmpItem_To_summ.Amount    <> 0
                                      INNER JOIN _tmpItem_To     ON _tmpItem_To.MovementId_cost = inMovementId
                                )
                       , tmpDiff AS (SELECT tmpRes_summ.InfoMoneyId
                                          , tmpRes_summ.OperSumm_calc - _tmpItem_To.OperSumm_calc AS OperSumm_diff
                                    FROM (SELECT tmpRes.InfoMoneyId, SUM (tmpRes.OperSumm_calc) AS OperSumm_calc FROM tmpRes GROUP BY tmpRes.InfoMoneyId
                                         ) AS tmpRes_summ
                                         INNER JOIN _tmpItem_To ON _tmpItem_To.InfoMoneyId = tmpRes_summ.InfoMoneyId
                                    WHERE _tmpItem_To.OperSumm_calc <> tmpRes_summ.OperSumm_calc
                                   )
           -- Результат
           SELECT tmpRes.MovementItemId
                , tmpRes.ContainerId AS ContainerId_Goods
                , 0                  AS ContainerId_summ
                , 0                  AS AccountId
                , tmpRes.Amount
                , tmpRes.OperSumm
                , tmpRes.OperSumm_calc - COALESCE (tmpdiff.OperSumm_diff, 0) As OperSumm_calc
                , tmpRes.InfoMoneyId
           FROM tmpRes
                LEFT JOIN tmpDiff ON tmpDiff.InfoMoneyId = tmpRes.InfoMoneyId
                                 AND                   1 = tmpRes.Ord
          ;

     -- 1.3.2. определяется ContainerId_Summ для проводок по суммовому учету + формируется Аналитика <элемент с/с>
     UPDATE _tmpItem SET ContainerId_Summ = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                              , inUnitId                 := vbUnitId
                                                                              , inCarId                  := NULL
                                                                              , inMemberId               := NULL
                                                                              , inBranchId               := NULL -- эта аналитика нужна для филиала
                                                                              , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                              , inBusinessId             := NULL
                                                                              , inAccountId              := _tmpItem.AccountId
                                                                              , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                              , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                              , inInfoMoneyId_Detail     := _tmpItem.InfoMoneyId_Detail
                                                                              , inContainerId_Goods      := _tmpItem.ContainerId_Goods
                                                                              , inGoodsId                := _tmpItem.GoodsId
                                                                              , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                              , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                              , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                              , inAssetId                := _tmpItem.AssetId
                                                                               )
     ;



     -- заменили дату, т.к. в затратах она соответствует дате документа к которому добавляются затраты
     UPDATE Movement SET OperDate = vbOperDate_to WHERE Movement.Id = inMovementId AND OperDate <> vbOperDate_to;


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
