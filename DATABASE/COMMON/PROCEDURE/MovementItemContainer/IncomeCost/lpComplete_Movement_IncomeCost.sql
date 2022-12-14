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
   DECLARE vbMovementId_to         Integer;
   DECLARE vbOperDate_to           TDateTime;

   DECLARE vbUnitId                Integer;
   DECLARE vbJuridicalId_Basis     Integer;
   DECLARE vbAccountDirectionId    Integer;
   
   DECLARE vbPartionMovementId     Integer;
BEGIN
     -- нашли документ из которого надо взять сумму "затрат"
     vbMovementId_from:= (SELECT MovementFloat.ValueData :: Integer FROM MovementFloat WHERE MovementFloat.MovementId = inMovementId AND MovementFloat.DescId = zc_MovementFloat_MovementId());
     vbMovementDescId_from:= (SELECT Movement.DescId FROM Movement WHERE Movement.Id = vbMovementId_from);

     -- нашли документ, для товаров которого добавляется сумма "затрат" - !!!но они сформируются в inMovementId!!!
     vbMovementId_to:= (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = inMovementId);
     vbOperDate_to:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_to);
     --
     SELECT MovementLinkObject_To.ObjectId                   AS UnitId
          , ObjectLink_UnitTo_Juridical.ChildObjectId        AS JuridicalId_Basis
          , ObjectLink_UnitTo_AccountDirection.ChildObjectId AS AccountDirectionId_To
            INTO vbUnitId, vbJuridicalId_Basis, vbAccountDirectionId
     FROM MovementLinkObject AS MovementLinkObject_To
          LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Juridical
                               ON ObjectLink_UnitTo_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_UnitTo_Juridical.DescId   = zc_ObjectLink_Unit_Juridical()
          LEFT JOIN ObjectLink AS ObjectLink_UnitTo_AccountDirection
                               ON ObjectLink_UnitTo_AccountDirection.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_UnitTo_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
     WHERE MovementLinkObject_To.MovementId = vbMovementId_to
       AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
     ;

     -- Проверка
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = vbMovementId_to AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> должен быть в статусе <%>.'
                       , (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = vbMovementId_to)
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_to)
                       , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_to))
                       , lfGet_Object_ValueData_sh (zc_Enum_Status_Complete())
                         ;
     END IF;


     -- Перепроведение, что б "затраты" оказались во ВСЕХ "Расходы будущих периодов"
     IF vbMovementDescId_from = zc_Movement_TransportService() -- AND 1=0
        AND EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = vbMovementId_from AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         PERFORM gpReComplete_Movement_TransportService (vbMovementId_from, lfGet_User_Session (inUserId));
         --
         DROP TABLE _tmpItem;

     ELSEIF vbMovementDescId_from = zc_Movement_Transport() -- AND 1=0
        AND EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = vbMovementId_from AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         PERFORM gpReComplete_Movement_Transport (vbMovementId_from, NULL, lfGet_User_Session (inUserId));
         --
         DROP TABLE _tmpItem_Transport;

     END IF;
     
     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_IncomeCost_CreateTemp();

     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;



     -- определили сумму "затрат" - хотя они в БАЛАНСЕ как Расходы будущих периодов
     INSERT INTO _tmpItem_From (ContainerId, AccountId, InfoMoneyId, OperSumm)
        -- Расходы будущих периодов
        WITH tmpAccount AS (SELECT * FROM Object_Account_View WHERE Object_Account_View.AccountGroupId = zc_Enum_AccountGroup_50000())
        SELECT MIContainer.ContainerId, MIContainer.AccountId, CLO_InfoMoney.ObjectId AS InfoMoneyId, SUM (MIContainer.Amount) AS Amount
        FROM MovementItemContainer AS MIContainer
             INNER JOIN tmpAccount ON tmpAccount.AccountId = MIContainer.AccountId
             LEFT JOIN ContainerLinkObject AS CLO_InfoMoney ON CLO_InfoMoney.ContainerId = MIContainer.ContainerId AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
        WHERE MIContainer.MovementId = vbMovementId_from
          AND MIContainer.DescId     = zc_MIContainer_Summ()
        GROUP BY MIContainer.ContainerId, MIContainer.AccountId, CLO_InfoMoney.ObjectId
        ;
     -- определили документы в которые надо распределить "затрат"
     INSERT INTO _tmpItem_To (MovementId_cost, MovementId_in, ContainerId, AccountId, InfoMoneyId, OperCount, OperSumm, OperSumm_calc)
        -- Расходы будущих периодов
        SELECT Movement.Id AS MovementId_cost, Movement_Income.Id AS MovementId_in
               -- проводки в документе From
             , _tmpItem_From.ContainerId, _tmpItem_From.AccountId, _tmpItem_From.InfoMoneyId
               -- ВЕС
             , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                              THEN MovementItem.Amount * COALESCE (ObjectFloat_Weight.ValueData, 0)
                         ELSE MovementItem.Amount
                    END) AS OperCount
             , 0 /*MovementFloat_TotalSumm.ValueData*/ AS OperSumm
             , 0 AS OperSumm_calc
        FROM MovementFloat
             INNER JOIN Movement ON Movement.Id = MovementFloat.MovementId
                             -- AND (Movement.StatusId = zc_Enum_Status_Complete()
                                AND (Movement.StatusId <> zc_Enum_Status_Erased()
                                  OR Movement.Id       = inMovementId)
             INNER JOIN Movement AS Movement_Income ON Movement_Income.Id       = Movement.ParentId
                                                   AND Movement_Income.DescId   = zc_Movement_Income()
                                                   AND Movement_Income.StatusId = zc_Enum_Status_Complete()
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement_Income.Id
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
             INNER JOIN MovementItemFloat AS MIF_Price
                                          ON MIF_Price.MovementItemId = MovementItem.Id
                                         AND MIF_Price.DescId         = zc_MIFloat_Price()
                                         AND MIF_Price.ValueData      <> 0
             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                   ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                  AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             /*LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                     ON MovementFloat_TotalSumm.MovementId = Movement_Income.Id
                                    AND MovementFloat_TotalSumm.DescId     = zc_MovementFloat_TotalSumm()*/
             CROSS JOIN _tmpItem_From
        WHERE MovementFloat.ValueData = vbMovementId_from
          AND MovementFloat.DescId    = zc_MovementFloat_MovementId()
        GROUP BY Movement.Id, Movement_Income.Id, _tmpItem_From.ContainerId, _tmpItem_From.AccountId, _tmpItem_From.InfoMoneyId
        ;

     -- распределение "затрат"
     UPDATE _tmpItem_To SET OperSumm_calc = tmp.OperSumm_calc
     FROM (WITH tmpItem_To_summ AS (SELECT _tmpItem_To.ContainerId, SUM (_tmpItem_To.OperCount) AS OperCount FROM _tmpItem_To GROUP BY _tmpItem_To.ContainerId)
                       , tmpRes AS (SELECT _tmpItem_To.MovementId_cost
                                         , _tmpItem_To.ContainerId
                                         , CAST (_tmpItem_From.OperSumm * _tmpItem_To.OperCount / tmpItem_To_summ.OperCount AS Numeric(16, 2)) AS OperSumm_calc
                                           -- № п/п
                                         , ROW_NUMBER() OVER (PARTITION BY _tmpItem_To.ContainerId ORDER BY _tmpItem_To.OperCount DESC) AS Ord
                                    FROM _tmpItem_To
                                         INNER JOIN tmpItem_To_summ ON tmpItem_To_summ.ContainerId = _tmpItem_To.ContainerId
                                                                   AND tmpItem_To_summ.OperCount   <> 0
                                         INNER JOIN _tmpItem_From   ON _tmpItem_From.ContainerId   = _tmpItem_To.ContainerId
                                   )
                       , tmpDiff AS (SELECT tmpRes_summ.ContainerId
                                          , tmpRes_summ.OperSumm_calc - _tmpItem_From.OperSumm AS OperSumm_diff
                                    FROM (SELECT tmpRes.ContainerId, SUM (tmpRes.OperSumm_calc) AS OperSumm_calc FROM tmpRes GROUP BY tmpRes.ContainerId
                                         ) AS tmpRes_summ
                                         INNER JOIN _tmpItem_From ON _tmpItem_From.ContainerId = tmpRes_summ.ContainerId
                                    WHERE _tmpItem_From.OperSumm <> tmpRes_summ.OperSumm_calc
                                   )
           -- Результат
           SELECT tmpRes.MovementId_cost, tmpRes.ContainerId, tmpRes.OperSumm_calc - COALESCE (tmpdiff.OperSumm_diff, 0) As OperSumm_calc
           FROM tmpRes
                LEFT JOIN tmpDiff ON tmpDiff.ContainerId = tmpRes.ContainerId
                                 AND                   1 = tmpRes.Ord
          ) AS tmp
     WHERE tmp.MovementId_cost = _tmpItem_To.MovementId_cost
       AND tmp.ContainerId     = _tmpItem_To.ContainerId
    ;

     -- сохранили распределение "затрат" - !!!Во ВСЕ zc_Movement_IncomeCost, куда они распределяются!!!
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountCost(), tmp.MovementId_cost, tmp.OperSumm_calc)
     FROM (SELECT _tmpItem_To.MovementId_cost, SUM (_tmpItem_To.OperSumm_calc) AS OperSumm_calc FROM _tmpItem_To GROUP BY _tmpItem_To.MovementId_cost) AS tmp
    ;


     -- проводки только для !!!ОДНОГО!!! zc_Movement_IncomeCost = inMovementId
        WITH -- товары Из прихода, к которым добавляется сумма "затрат"
             tmpMIContainer_all AS (SELECT MIContainer.*
                                    FROM MovementItemContainer AS MIContainer
                                    WHERE MIContainer.MovementId = vbMovementId_to
                                   )
            , tmpMIContainer AS (SELECT tmpMIContainer_Count.MovementItemId
                                      , tmpMIContainer_Count.ContainerId
                                      , tmpMIContainer_Count.ObjectId_Analyzer    AS GoodsId
                                      , tmpMIContainer_Count.ObjectIntId_Analyzer AS GoodsKindId
                                      , tmpMIContainer_Count.Amount               AS OperCount
                                      , tmpMIContainer_Summ.OperSumm              AS OperSumm
                                 FROM tmpMIContainer_all AS tmpMIContainer_Count
                                      LEFT JOIN (SELECT tmpMIContainer_all.MovementItemId, SUM (tmpMIContainer_all.Amount) AS OperSumm FROM tmpMIContainer_all WHERE tmpMIContainer_all.DescId = zc_MIContainer_Summ() AND tmpMIContainer_all.Amount > 0 GROUP BY tmpMIContainer_all.MovementItemId
                                                ) AS tmpMIContainer_Summ
                                                  ON tmpMIContainer_Summ.MovementItemId = tmpMIContainer_Count.MovementItemId
                                      INNER JOIN MovementItemFloat AS MIF_Price
                                                                   ON MIF_Price.MovementItemId = tmpMIContainer_Count.MovementItemId
                                                                  AND MIF_Price.DescId         = zc_MIFloat_Price()
                                                                  AND MIF_Price.ValueData      <> 0
                                 WHERE tmpMIContainer_Count.DescId = zc_MIContainer_Count()
                                   AND tmpMIContainer_Count.Amount > 0
                                )
             -- распределение "затрат"
           , tmpItem_To_summ AS (SELECT SUM (tmpMIContainer.OperCount) AS OperCount FROM tmpMIContainer)
                    , tmpRes AS (SELECT tmpMIContainer.*
                                      , _tmpItem_To.ContainerId AS ContainerId_Detail
                                      , _tmpItem_To.InfoMoneyId AS InfoMoneyId_Detail
                                      , CAST (_tmpItem_To.OperSumm_calc * tmpMIContainer.OperCount / tmpItem_To_summ.OperCount AS Numeric(16, 2)) AS OperSumm_calc
                                        -- № п/п
                                      , ROW_NUMBER() OVER (PARTITION BY _tmpItem_To.ContainerId ORDER BY tmpMIContainer.OperCount DESC) AS Ord
                                 FROM tmpMIContainer
                                      INNER JOIN tmpItem_To_summ ON tmpItem_To_summ.OperCount   <> 0
                                      INNER JOIN _tmpItem_To     ON _tmpItem_To.MovementId_cost = inMovementId
                                )
                       , tmpDiff AS (SELECT tmpRes_summ.ContainerId_Detail
                                          , tmpRes_summ.OperSumm_calc - _tmpItem_To.OperSumm_calc AS OperSumm_diff
                                    FROM (SELECT tmpRes.ContainerId_Detail, SUM (tmpRes.OperSumm_calc) AS OperSumm_calc FROM tmpRes GROUP BY tmpRes.ContainerId_Detail
                                         ) AS tmpRes_summ
                                         INNER JOIN _tmpItem_To ON _tmpItem_To.ContainerId = tmpRes_summ.ContainerId_Detail
                                    WHERE _tmpItem_To.OperSumm_calc <> tmpRes_summ.OperSumm_calc
                                   )
     INSERT INTO _tmpItem (MovementItemId, ContainerId_Goods, ContainerId_summ
                         , GoodsId, GoodsKindId
                         , OperCount, OperSumm, OperSumm_calc
                         , AccountId, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId, InfoMoneyId_Detail, ContainerId_Detail
                         , isPartionCount, isPartionSumm
                         , PartionGoodsId
                          )
           -- Результат
           SELECT tmpRes.MovementItemId
                , tmpRes.ContainerId                                         AS ContainerId_Goods
                , 0                                                          AS ContainerId_summ
                , tmpRes.GoodsId                                             AS GoodsId
                , tmpRes.GoodsKindId                                         AS GoodsKindId
                , tmpRes.OperCount                                           AS OperCount
                , tmpRes.OperSumm                                            AS OperSumm
                , tmpRes.OperSumm_calc - COALESCE (tmpdiff.OperSumm_diff, 0) AS OperSumm_calc
                , 0                                                          AS AccountId
                , View_InfoMoney.InfoMoneyGroupId                            AS InfoMoneyGroupId
                , View_InfoMoney.InfoMoneyDestinationId                      AS InfoMoneyDestinationId
                , View_InfoMoney.InfoMoneyId                                 AS InfoMoneyId
                , tmpRes.InfoMoneyId_Detail                                  AS InfoMoneyId_Detail
                , tmpRes.ContainerId_Detail                                  AS ContainerId_Detail
                , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE)     AS isPartionCount
                , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)      AS isPartionSumm
                , CLO_PartionGoods.ObjectId                                  As PartionGoodsId
           FROM tmpRes
                LEFT JOIN tmpDiff ON tmpDiff.ContainerId_Detail = tmpRes.ContainerId_Detail
                                 AND                          1 = tmpRes.Ord
                LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                              ON CLO_PartionGoods.ContainerId = tmpRes.ContainerId
                                             AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                     ON ObjectLink_Goods_InfoMoney.ObjectId = tmpRes.GoodsId
                                    AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionCount
                                        ON ObjectBoolean_PartionCount.ObjectId = tmpRes.GoodsId
                                       AND ObjectBoolean_PartionCount.DescId   = zc_ObjectBoolean_Goods_PartionCount()
                LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionSumm
                                        ON ObjectBoolean_PartionSumm.ObjectId  = tmpRes.GoodsId
                                       AND ObjectBoolean_PartionSumm.DescId    = zc_ObjectBoolean_Goods_PartionSumm()
          ;

     -- 1.3.1. определяется Счет(справочника) для проводок по суммовому учету
     UPDATE _tmpItem SET AccountId = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы
                                             , inAccountDirectionId     := vbAccountDirectionId
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT DISTINCT _tmpItem.InfoMoneyDestinationId FROM _tmpItem) AS _tmpItem_group
          ) AS _tmpItem_byAccount
     WHERE _tmpItem.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId
     ;

     -- 1.3.2. определяется ContainerId_Summ для проводок по суммовому учету + формируется Аналитика <элемент с/с>
     UPDATE _tmpItem SET ContainerId_Summ = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate_to
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
                                                                              , inAssetId                := NULL
                                                                               );


     -- 2.1.
     vbPartionMovementId:= lpInsertFind_Object_PartionMovement (inMovementId:= vbMovementId_from, inPaymentDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_from));

     -- 2.2. формируются Проводки для суммового учета : (c/c остаток) + !!!есть MovementItemId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, zc_Movement_IncomeCost(), inMovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Summ
            , _tmpItem.AccountId                      AS AccountId                -- счет есть всегда
            , 0                                       AS AnalyzerId               -- нет аналитики, т.е. деление Поставщик, Заготовитель, Покупатель, Талоны пока не надо
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer        -- Товар
            , vbUnitId                                AS WhereObjectId_Analyzer   -- Подраделение или...
            , _tmpItem.ContainerId_Detail             AS ContainerId_Analyzer     -- Контейнер - по долгам поставщика
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer     -- вид товара
            , vbPartionMovementId                     AS ObjectExtId_Analyzer     -- Поставщик или...
            , _tmpItem.ContainerId_Goods              AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                       AS ParentId
            , _tmpItem.OperSumm_calc                  AS Amount
            , vbOperDate_to                           AS OperDate                 -- т.е. по "Дате склад"
            , TRUE                                    AS isActive
       FROM _tmpItem
      ;


     -- 2.3. формируются Проводки - Прибыль будущих периодов
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, AccountId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive
                                        )
       SELECT 0, zc_MIContainer_Summ() AS DescId, zc_Movement_IncomeCost(), inMovementId, _tmpItem.MovementItemId
            , _tmpItem_To.ContainerId
            , _tmpItem_To.AccountId                   AS AccountId              -- прибыль текущего периода
            , 0                                       AS AnalyzerId             -- не нужен
            , vbPartionMovementId                     AS ObjectId_Analyzer      -- !!!PartionMovementId!!!
            , vbUnitId                                AS WhereObjectId_Analyzer -- 
            , _tmpItem.ContainerId_Summ               AS ContainerId_Analyzer   -- !!!добавлен!!!
            , _tmpItem.AccountId                      AS AccountId_Analyzer     -- !!!добавлен!!!
            , _tmpItem.GoodsId                        AS ObjectIntId_Analyzer   -- Товар
            , 0                                       AS ObjectExtId_Analyzer   -- Подраделение (ОПиУ), а могло быть UnitId_Route
            , 0                                       AS ParentId
            , -1 * _tmpItem.OperSumm_calc
            , vbOperDate_to
            , FALSE                                   AS isActive               -- !!!Расход из Прибыль будущих периодов!!!
       FROM _tmpItem
            INNER JOIN _tmpItem_To ON _tmpItem_To.ContainerId     = _tmpItem.ContainerId_Detail
                                  AND _tmpItem_To.MovementId_cost = inMovementId
      ;

     -- сохранили <Итого сумма затрат по документу (с учетом НДС)>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummSpending()
                                         , vbMovementId_to
                                         , COALESCE ((SELECT SUM (tmp.OperSumm)
                                                      FROM (SELECT SUM (_tmpItem.OperSumm_calc) AS OperSumm FROM _tmpItem
                                                           UNION
                                                            SELECT SUM (COALESCE (MovementFloat.ValueData, 0)) AS OperSumm
                                                            FROM Movement
                                                                 LEFT JOIN MovementFloat ON MovementFloat.MovementId = Movement.Id
                                                                                        AND MovementFloat.DescId     = zc_MovementFloat_AmountCost()
                                                            WHERE Movement.ParentId = vbMovementId_to
                                                              AND Movement.DescId   = zc_Movement_IncomeCost()
                                                              AND Movement.StatusId = zc_Enum_Status_Complete()
                                                           ) AS tmp
                                                     ), 0)
                                          );


     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_IncomeCost()
                                , inUserId     := inUserId
                                 );


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
