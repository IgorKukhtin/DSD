-- Function: lpComplete_Movement_IncomeCost ()

DROP FUNCTION IF EXISTS lpComplete_Movement_IncomeCost  (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_IncomeCost(
    IN inMovementId        Integer               , -- ключ Документа
    IN inUserId            Integer                 -- Пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId_from       Integer;
   DECLARE vbMovementDescId_from   Integer;
   DECLARE vbMovementId_income     Integer;

   DECLARE vbJuridicalId_Basis       Integer; -- значение пока НЕ определяется
   DECLARE vbBusinessId              Integer; -- значение пока НЕ определяется
BEGIN
     -- нашли документ из которого надо взять сумму "затрат"
     vbMovementId_from:= (SELECT MovementFloat.ValueData :: Integer FROM MovementFloat WHERE MovementFloat.MovementId = inMovementId AND MovementFloat.DescId = zc_MovementFloat_MovementId());
     vbMovementDescId_from:= (SELECT Movement.DescId FROM Movement WHERE Movement.Id = vbMovementId_from);



     -- Перепроведение, что б "затраты" оказались во ВСЕХ "Расходы будущих периодов"
     IF vbMovementDescId_from = zc_Movement_Invoice() AND 1=0
     THEN
         PERFORM gpReComplete_Movement_Invoice (vbMovementId_from, inUserId :: TVarChar);
         --
         DROP TABLE _tmpItem;
     END IF;


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_IncomeCost_CreateTemp();


     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;


     -- определили сумму "затрат" по документу MovementId_from
     INSERT INTO _tmpMovement_from (MovementId_from, InfoMoneyId, OperSumm)
        -- Расходы будущих периодов
        SELECT Movement_Master.Id     AS MovementId_from -- Документ Счет
             , MLO_InfoMoney.ObjectId AS InfoMoneyId     -- Документ Счет
               -- без НДС
             , CASE WHEN Movement_Master.StatusId = zc_Enum_Status_Complete() THEN -1 * zfCalc_Summ_NoVAT (MovementFloat_Amount_Master.ValueData, MovementFloat_VATPercent.ValueData) ELSE 0 END AS OperSumm

        FROM -- Документ Счет
             Movement AS Movement_Master
             LEFT JOIN MovementLinkObject AS MLO_InfoMoney
                                          ON MLO_InfoMoney.MovementId = Movement_Master.Id
                                         AND MLO_InfoMoney.DescId     = zc_MovementLinkObject_InfoMoney()
             -- Сумма по счету
             LEFT JOIN MovementFloat AS MovementFloat_Amount_Master
                                     ON MovementFloat_Amount_Master.MovementId = Movement_Master.Id
                                    AND MovementFloat_Amount_Master.DescId     = zc_MovementFloat_Amount()
             LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                     ON MovementFloat_VATPercent.MovementId = Movement_Master.Id
                                    AND MovementFloat_VATPercent.DescId     = zc_MovementFloat_VATPercent()
        WHERE Movement_Master.Id = vbMovementId_from
       ;

     -- определили документы в которые надо распределить "затраты"
     INSERT INTO _tmpMovement_to (MovementId_cost, MovementId_from, MovementId_to, InfoMoneyId_from, OperSumm, OperSumm_calc)
        -- Расходы будущих периодов
        SELECT Movement_cost.Id                   AS MovementId_cost
             , _tmpMovement_from.MovementId_from  AS MovementId_from
             , Movement_cost.ParentId             AS MovementId_to
               --
             , _tmpMovement_from.InfoMoneyId      AS InfoMoneyId_from
              -- сумма без НДС со Скидкой
             , SUM (zfCalc_SummIn (MovementItem.Amount, Object_PartionGoods.EKPrice, Object_PartionGoods.CountForPrice)) AS OperSumm
               -- распределим позже
             , 0 AS OperSumm_calc
        FROM MovementFloat
             INNER JOIN Movement AS Movement_cost
                                 ON Movement_cost.Id        = MovementFloat.MovementId
                             -- AND (Movement_cost.StatusId = zc_Enum_Status_Complete()
                                AND (Movement_cost.StatusId <> zc_Enum_Status_Erased()
                                  OR Movement_cost.Id       = inMovementId
                                    )
             INNER JOIN Movement AS Movement_Income ON Movement_Income.Id       = Movement_cost.ParentId
                                                   AND Movement_Income.DescId   = zc_Movement_Income()
                                                   AND Movement_Income.StatusId <> zc_Enum_Status_Erased()
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement_Income.Id
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
             LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.Id
             CROSS JOIN _tmpMovement_from
        WHERE MovementFloat.ValueData = vbMovementId_from
          AND MovementFloat.DescId    = zc_MovementFloat_MovementId()
        GROUP BY Movement_cost.Id
               , _tmpMovement_from.MovementId_from
               , Movement_cost.ParentId
               , _tmpMovement_from.InfoMoneyId
        ;

     -- Проверка
     IF EXISTS (SELECT 1 FROM _tmpMovement_to LEFT JOIN Movement ON Movement.Id = _tmpMovement_to.MovementId_to WHERE COALESCE (Movement.StatusId, 0) <> zc_Enum_Status_Complete())
     THEN
         RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> должен быть в статусе <%>.'
                       , (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = (SELECT _tmpMovement_to.MovementId_to FROM _tmpMovement_to LEFT JOIN Movement ON Movement.Id = _tmpMovement_to.MovementId_to WHERE COALESCE (Movement.StatusId, 0) <> zc_Enum_Status_Complete() LIMIT 1))
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = (SELECT _tmpMovement_to.MovementId_to FROM _tmpMovement_to LEFT JOIN Movement ON Movement.Id = _tmpMovement_to.MovementId_to WHERE COALESCE (Movement.StatusId, 0) <> zc_Enum_Status_Complete() LIMIT 1))
                       , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = (SELECT _tmpMovement_to.MovementId_to FROM _tmpMovement_to LEFT JOIN Movement ON Movement.Id = _tmpMovement_to.MovementId_to WHERE COALESCE (Movement.StatusId, 0) <> zc_Enum_Status_Complete() LIMIT 1)))
                       , lfGet_Object_ValueData_sh (zc_Enum_Status_Complete())
                         ;
     END IF;

     -- распределение "затрат"
     UPDATE _tmpMovement_to SET OperSumm_calc = tmp.OperSumm_calc
     FROM (WITH -- сумма итого по элементам получателя
                tmpItem_To_summ AS (SELECT _tmpMovement_to.MovementId_from, SUM (_tmpMovement_to.OperSumm) AS OperSumm FROM _tmpMovement_to GROUP BY _tmpMovement_to.MovementId_from)
                         -- распределение
                       , tmpRes AS (SELECT _tmpMovement_to.MovementId_from
                                         , _tmpMovement_to.MovementId_to
                                           -- распределение
                                         , CAST (_tmpMovement_from.OperSumm * _tmpMovement_to.OperSumm / tmpItem_To_summ.OperSumm AS Numeric(16, 2)) AS OperSumm_calc
                                           -- № п/п
                                         , ROW_NUMBER() OVER (PARTITION BY _tmpMovement_to.MovementId_from ORDER BY _tmpMovement_to.OperSumm DESC) AS Ord
                                    FROM _tmpMovement_to
                                         INNER JOIN tmpItem_To_summ ON tmpItem_To_summ.MovementId_from = _tmpMovement_to.MovementId_from
                                                                   AND tmpItem_To_summ.OperSumm        <> 0
                                         -- сумма которая распределяется
                                         INNER JOIN _tmpMovement_from   ON _tmpMovement_from.MovementId_from = _tmpMovement_to.MovementId_from
                                   )
                       , tmpDiff AS (SELECT tmpRes_summ.MovementId_from
                                          , tmpRes_summ.OperSumm_calc - _tmpMovement_from.OperSumm AS OperSumm_diff
                                    FROM -- итого после распределения
                                         (SELECT tmpRes.MovementId_from, SUM (tmpRes.OperSumm_calc) AS OperSumm_calc FROM tmpRes GROUP BY tmpRes.MovementId_from
                                         ) AS tmpRes_summ
                                         INNER JOIN _tmpMovement_from ON _tmpMovement_from.MovementId_from = tmpRes_summ.MovementId_from
                                    WHERE _tmpMovement_from.OperSumm <> tmpRes_summ.OperSumm_calc
                                   )
           -- Результат
           SELECT tmpRes.MovementId_from, tmpRes.MovementId_to, tmpRes.OperSumm_calc - COALESCE (tmpdiff.OperSumm_diff, 0) As OperSumm_calc
           FROM tmpRes
                LEFT JOIN tmpDiff ON tmpDiff.MovementId_from = tmpRes.MovementId_from
                                 AND                   1     = tmpRes.Ord
          ) AS tmp
     WHERE tmp.MovementId_from = _tmpMovement_to.MovementId_from
       AND tmp.MovementId_to   = _tmpMovement_to.MovementId_to
    ;

     --- !!!Вычитаем !!!Предыдущие затраты в док прихода
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummCost(), _tmpMovement_to.MovementId_to
                                         , COALESCE (MovementFloat_TotalSummCost.ValueData, 0)
                                         - COALESCE (MovementFloat_AmountCost.ValueData, 0)
                                          )
     FROM _tmpMovement_to
          JOIN Movement ON Movement.Id       = _tmpMovement_to.MovementId_cost
                       AND Movement.StatusId = zc_Enum_Status_Complete()
          LEFT JOIN MovementFloat AS MovementFloat_AmountCost
                                  ON MovementFloat_AmountCost.MovementId = _tmpMovement_to.MovementId_cost
                                 AND MovementFloat_AmountCost.DescId     = zc_MovementFloat_AmountCost()
          LEFT JOIN MovementFloat AS MovementFloat_TotalSummCost
                                  ON MovementFloat_TotalSummCost.MovementId = _tmpMovement_to.MovementId_to
                                 AND MovementFloat_TotalSummCost.DescId     = zc_MovementFloat_TotalSummCost()
     ;
     -- распровели
     PERFORM lpUnComplete_Movement (inMovementId := _tmpMovement_to.MovementId_cost
                                  , inUserId     := inUserId
                                   )
     FROM _tmpMovement_to
   --WHERE _tmpMovement_to.MovementId_cost <> inMovementId
    ;

     -- сохранили новую сумму "затрат"
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountCost(), _tmpMovement_to.MovementId_cost, _tmpMovement_to.OperSumm_calc)
     FROM _tmpMovement_to;

     -- обновили дату
     UPDATE Movement SET OperDate = Movement_Income.OperDate
     FROM _tmpMovement_to
          JOIN Movement AS Movement_Income ON Movement_Income.Id = _tmpMovement_to.MovementId_to
     WHERE Movement.Id = _tmpMovement_to.MovementId_cost;



     -- проводки для !!!ВСЕХ!!! zc_Movement_IncomeCost
        WITH -- товары Из прихода, к которым добавляется сумма "затрат"
             tmpMIContainer_all AS (SELECT MIContainer.*
                                    FROM MovementItemContainer AS MIContainer
                                    WHERE MIContainer.MovementId IN (SELECT _tmpMovement_to.MovementId_to FROM _tmpMovement_to)
                                   )
            , tmpMIContainer AS (SELECT tmpMIContainer_Count.MovementId            AS MovementId_to
                                      , tmpMIContainer_Count.MovementItemId
                                      , tmpMIContainer_Count.ContainerId           AS ContainerId_Goods
                                      , tmpMIContainer_Count.ObjectId_Analyzer     AS GoodsId
                                      , tmpMIContainer_Count.PartionId             AS PartionId
                                      , tmpMIContainer_Summ.ContainerId            AS ContainerId_Summ
                                      , tmpMIContainer_Count.Amount                AS Amount
                                      , COALESCE (tmpMIContainer_Summ.OperSumm, 0) AS OperSumm
                                 FROM tmpMIContainer_all AS tmpMIContainer_Count
                                      LEFT JOIN (SELECT tmpMIContainer_all.MovementItemId, tmpMIContainer_all.ContainerId, SUM (tmpMIContainer_all.Amount) AS OperSumm FROM tmpMIContainer_all WHERE tmpMIContainer_all.DescId = zc_MIContainer_Summ() AND tmpMIContainer_all.Amount > 0 GROUP BY tmpMIContainer_all.MovementItemId, tmpMIContainer_all.ContainerId
                                                ) AS tmpMIContainer_Summ
                                                  ON tmpMIContainer_Summ.MovementItemId = tmpMIContainer_Count.MovementItemId
                                 WHERE tmpMIContainer_Count.DescId = zc_MIContainer_Count()
                                   AND tmpMIContainer_Count.Amount > 0
                                )
           , -- сумма итого по элементам получателя
             tmpItem_To_summ AS (SELECT tmpMIContainer.MovementId_to, SUM (tmpMIContainer.OperSumm) AS OperSumm FROM tmpMIContainer GROUP BY tmpMIContainer.MovementId_to)
                      -- распределение "затрат"
                    , tmpRes AS (SELECT tmpMIContainer.*
                                        -- распределение
                                      , CAST (_tmpMovement_to.OperSumm_calc * tmpMIContainer.OperSumm / tmpItem_To_summ.OperSumm AS Numeric(16, 2)) AS OperSumm_calc
                                        -- № п/п
                                      , ROW_NUMBER() OVER (PARTITION BY tmpMIContainer.MovementId_to ORDER BY tmpMIContainer.OperSumm DESC) AS Ord
                                 FROM tmpMIContainer
                                      INNER JOIN tmpItem_To_summ ON tmpItem_To_summ.MovementId_to = tmpMIContainer.MovementId_to
                                      -- сумма которая распределяется
                                      INNER JOIN _tmpMovement_to     ON _tmpMovement_to.MovementId_to = tmpMIContainer.MovementId_to
                                )
                       , tmpDiff AS (SELECT tmpRes_summ.MovementId_to
                                          , tmpRes_summ.OperSumm_calc - _tmpMovement_to.OperSumm_calc AS OperSumm_diff
                                     FROM -- итого после распределения
                                          (SELECT tmpRes.MovementId_to, SUM (tmpRes.OperSumm_calc) AS OperSumm_calc FROM tmpRes GROUP BY tmpRes.MovementId_to
                                          ) AS tmpRes_summ
                                          INNER JOIN _tmpMovement_to ON _tmpMovement_to.MovementId_to = tmpRes_summ.MovementId_to
                                     WHERE _tmpMovement_to.OperSumm_calc <> tmpRes_summ.OperSumm_calc
                                    )
     INSERT INTO _tmpItem (MovementId_cost, MovementId_from, MovementId_to
                         , MovementItemId
                         , ContainerId_Goods, ContainerId_summ
                         , GoodsId, PartionId
                         , Amount, OperSumm, OperSumm_calc
                         , AccountId_50101, ContainerId_50101
                         , PartnerId, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                          )
           -- Результат
           SELECT _tmpMovement_to.MovementId_cost
                , _tmpMovement_to.MovementId_from
                , _tmpMovement_to.MovementId_to
                , tmpRes.MovementItemId
                , tmpRes.ContainerId_Goods                                   AS ContainerId_Goods
                , tmpRes.ContainerId_summ                                    AS ContainerId_summ
                , tmpRes.GoodsId                                             AS GoodsId
                , tmpRes.PartionId                                           AS PartionId
                , tmpRes.Amount                                              AS Amount
                , tmpRes.OperSumm                                            AS OperSumm
                , tmpRes.OperSumm_calc - COALESCE (tmpdiff.OperSumm_diff, 0) AS OperSumm_calc
                , 0                                                          AS AccountId_50101
                , 0                                                          AS ContainerId_50101
                , MLO_Object.ObjectId                                        AS PartnerId
                , View_InfoMoney.InfoMoneyGroupId                            AS InfoMoneyGroupId
                , View_InfoMoney.InfoMoneyDestinationId                      AS InfoMoneyDestinationId
                , View_InfoMoney.InfoMoneyId                                 AS InfoMoneyId
           FROM tmpRes
                LEFT JOIN tmpDiff ON tmpDiff.MovementId_to = tmpRes.MovementId_to
                                 AND                     1 = tmpRes.Ord
                LEFT JOIN _tmpMovement_to ON _tmpMovement_to.MovementId_to = tmpRes.MovementId_to
                LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = _tmpMovement_to.InfoMoneyId_from
                LEFT JOIN MovementLinkObject AS MLO_Object
                                             ON MLO_Object.MovementId = _tmpMovement_to.MovementId_from
                                            AND MLO_Object.DescId     = zc_MovementLinkObject_Object()
          ;

     --
     UPDATE _tmpItem SET AccountId_50101 = tmp.AccountId
     FROM (WITH tmp AS (SELECT DISTINCT _tmpItem.InfoMoneyDestinationId FROM _tmpItem)
                SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_50000()    -- Расходы будущих периодов
                                                  , inAccountDirectionId     := zc_Enum_AccountDirection_50100() --
                                                  , inInfoMoneyDestinationId := tmp.InfoMoneyDestinationId
                                                  , inInfoMoneyId            := NULL
                                                  , inUserId                 := inUserId
                                                   ) AS AccountId
                     , tmp.InfoMoneyDestinationId
                FROM tmp
           ) AS tmp
     WHERE _tmpItem.InfoMoneyDestinationId = tmp.InfoMoneyDestinationId
    ;
     --
     UPDATE _tmpItem SET ContainerId_50101 = tmp.ContainerId
     FROM (WITH tmp AS (SELECT DISTINCT _tmpItem.AccountId_50101, _tmpItem.InfoMoneyId, _tmpItem.PartnerId FROM _tmpItem)
                SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                             , inParentId          := NULL
                                             , inObjectId          := tmp.AccountId_50101
                                             , inPartionId         := NULL
                                             , inIsReserve         := FALSE
                                             , inJuridicalId_basis := vbJuridicalId_Basis
                                             , inBusinessId        := vbBusinessId
                                             , inDescId_1          := zc_ContainerLinkObject_InfoMoney()
                                             , inObjectId_1        := tmp.InfoMoneyId
                                             , inDescId_2          := zc_ContainerLinkObject_Partner()
                                             , inObjectId_2        := tmp.PartnerId
                                              ) AS ContainerId
                     , tmp.AccountId_50101
                FROM tmp
           ) AS tmp
     WHERE _tmpItem.AccountId_50101 = tmp.AccountId_50101
    ;

     -- 2.1. формируются Проводки для суммового учета : (c/c остаток) + !!!есть MovementItemId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerExtId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       SELECT 0, zc_MIContainer_Summ() AS DescId, zc_Movement_IncomeCost() AS MovementDescId
            , _tmpItem.MovementId_cost, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Summ               AS ContainerId
            , 0                                       AS ParentId
            , Container.ObjectId                      AS AccountId              -- Счет есть всегда
            , 0                                       AS AnalyzerId             -- нет аналитики
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , _tmpItem.PartionId                      AS PartionId              -- Партия
            , Container.WhereObjectId                 AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem.AccountId_50101                AS AccountId_Analyzer     -- Счет - корреспонденет
            , _tmpItem.ContainerId_50101              AS ContainerExtId_Analyzer-- Контейнер - корреспонденет
            , _tmpItem.PartnerId                      AS ObjectExtId_Analyzer
            , 1 * _tmpItem.OperSumm_calc              AS Amount
            , Movement.OperDate                       AS OperDate               -- "Дата документа"
            , TRUE                                    AS isActive
       FROM _tmpItem
            JOIN Container ON Container.Id = _tmpItem.ContainerId_Summ
            JOIN Movement  ON Movement.Id  = _tmpItem.MovementId_cost
      ;

     -- 2.2. формируются Проводки - Расходы будущих периодов
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ObjectIntId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       SELECT 0, zc_MIContainer_Summ() AS DescId, zc_Movement_IncomeCost() AS MovementDescId
            , _tmpItem.MovementId_cost, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_50101              AS ContainerId
            , 0                                       AS ParentId
            , _tmpItem.AccountId_50101                AS AccountId              -- Счет есть всегда
            , 0                                       AS AnalyzerId             -- нет аналитики
            , _tmpItem.PartnerId                      AS ObjectId_Analyzer      --
            , 0                                       AS PartionId              -- Партия
            , 0                                       AS WhereObjectId_Analyzer -- Место учета
            , Container.ObjectId                      AS AccountId_Analyzer     -- Счет - корреспонденет
            , _tmpItem.ContainerId_Summ               AS ContainerId_Analyzer   -- Контейнер - корреспонденет
            , _tmpItem.GoodsId                        AS ObjectIntId_Analyzer
            , -1 * _tmpItem.OperSumm_calc             AS Amount
            , Movement.OperDate                       AS OperDate               -- "Дата документа"
            , FALSE                                   AS isActive
       FROM _tmpItem
            JOIN Container ON Container.Id = _tmpItem.ContainerId_Summ
            JOIN Movement  ON Movement.Id  = _tmpItem.MovementId_cost
      ;

     -- дописали - Цену Затрат
     UPDATE Object_PartionGoods SET CostPrice = CASE WHEN _tmpItem.Amount <> 0 THEN _tmpItem.OperSumm_calc / _tmpItem.Amount ELSE _tmpItem.OperSumm_calc END
     FROM _tmpItem
     WHERE Object_PartionGoods.MovementItemId = _tmpItem.MovementItemId;

     --- !!!Добавляем сформированные затраты в док Приход
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummCost(), _tmpMovement_to.MovementId_to
                                         , COALESCE (MovementFloat_TotalSummCost.ValueData, 0)
                                         + COALESCE (_tmpMovement_to.OperSumm_calc, 0)
                                          )
     FROM _tmpMovement_to
          LEFT JOIN MovementFloat AS MovementFloat_TotalSummCost
                                  ON MovementFloat_TotalSummCost.MovementId = _tmpMovement_to.MovementId_to
                                 AND MovementFloat_TotalSummCost.DescId     = zc_MovementFloat_TotalSummCost()
     ;

     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := _tmpMovement_to.MovementId_cost
                                , inDescId     := zc_Movement_IncomeCost()
                                , inUserId     := inUserId
                                 )
     FROM _tmpMovement_to;


     -- RAISE EXCEPTION 'OK';

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.01.19                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_IncomeCost ()
