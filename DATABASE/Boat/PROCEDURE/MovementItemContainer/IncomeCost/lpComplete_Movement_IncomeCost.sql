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
BEGIN
     -- нашли документ из которого надо взять сумму "затрат"
     vbMovementId_from:= (SELECT MovementFloat.ValueData :: Integer FROM MovementFloat WHERE MovementFloat.MovementId = inMovementId AND MovementFloat.DescId = zc_MovementFloat_MovementId());
     vbMovementDescId_from:= (SELECT Movement.DescId FROM Movement WHERE Movement.Id = vbMovementId_from);

     -- нашли документ, для товаров которого добавляется сумма "затрат" - !!!но они сформируются в inMovementId!!!
     vbMovementId_to:= (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = inMovementId);
     vbOperDate_to:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_to);
     -- еще параметры документа Приход
     SELECT MovementLinkObject_To.ObjectId                   AS UnitId
        --, ObjectLink_UnitTo_Juridical.ChildObjectId        AS JuridicalId_Basis
            -- Аналитики счетов - направления - !!!ВРЕМЕННО - zc_Enum_AccountDirection_10100!!! Запасы + Склады
          , COALESCE (ObjectLink_UnitTo_AccountDirection.ChildObjectId, zc_Enum_InfoMoney_10101()) AS AccountDirectionId_To
            INTO vbUnitId, vbAccountDirectionId
     FROM MovementLinkObject AS MovementLinkObject_To
        /*LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Juridical
                               ON ObjectLink_UnitTo_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_UnitTo_Juridical.DescId   = zc_ObjectLink_Unit_Juridical()*/
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
     INSERT INTO _tmpItem_From (MovementId_from, InfoMoneyId, OperSumm)
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

     -- определили документы в которые надо распределить "затрат"
     INSERT INTO _tmpItem_To (MovementId_cost, MovementId_from, MovementId_to, InfoMoneyId, OperSumm, OperSumm_calc)
        -- Расходы будущих периодов
        SELECT Movement_cost.Id               AS MovementId_cost
             , _tmpItem_From.MovementId_from  AS MovementId_from
             , Movement_cost.ParentId         AS MovementId_to
               -- 
             , _tmpItem_From.InfoMoneyId
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
                                                   AND Movement_Income.StatusId = zc_Enum_Status_Complete()
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement_Income.Id
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
             LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.Id
             CROSS JOIN _tmpItem_From
        WHERE MovementFloat.ValueData = vbMovementId_from
          AND MovementFloat.DescId    = zc_MovementFloat_MovementId()
        GROUP BY Movement_cost.Id
               , _tmpItem_From.MovementId_from
               , Movement_cost.ParentId
               , _tmpItem_From.InfoMoneyId
        ;

     -- распределение "затрат"
     UPDATE _tmpItem_To SET OperSumm_calc = tmp.OperSumm_calc
     FROM (WITH -- сумма итого по элементам получателя
                tmpItem_To_summ AS (SELECT _tmpItem_To.MovementId_from, SUM (_tmpItem_To.OperSumm) AS OperSumm FROM _tmpItem_To GROUP BY _tmpItem_To.MovementId_from)
                       , tmpRes AS (SELECT _tmpItem_To.MovementId_from
                                         , _tmpItem_To.MovementId_to
                                           -- распределение
                                         , CAST (_tmpItem_From.OperSumm * _tmpItem_To.OperSumm / tmpItem_To_summ.OperSumm AS Numeric(16, 2)) AS OperSumm_calc
                                           -- № п/п
                                         , ROW_NUMBER() OVER (PARTITION BY _tmpItem_To.MovementId_from ORDER BY _tmpItem_To.OperSumm DESC) AS Ord
                                    FROM _tmpItem_To
                                         INNER JOIN tmpItem_To_summ ON tmpItem_To_summ.MovementId_from = _tmpItem_To.MovementId_from
                                                                   AND tmpItem_To_summ.OperSumm        <> 0
                                         -- сумма которая распределяется
                                         INNER JOIN _tmpItem_From   ON _tmpItem_From.MovementId_from = _tmpItem_To.MovementId_from
                                   )
                       , tmpDiff AS (SELECT tmpRes_summ.MovementId_from
                                          , tmpRes_summ.OperSumm_calc - _tmpItem_From.OperSumm AS OperSumm_diff
                                    FROM -- итого после распределения
                                         (SELECT tmpRes.MovementId_from, SUM (tmpRes.OperSumm_calc) AS OperSumm_calc FROM tmpRes GROUP BY tmpRes.MovementId_from
                                         ) AS tmpRes_summ
                                         INNER JOIN _tmpItem_From ON _tmpItem_From.MovementId_from = tmpRes_summ.MovementId_from
                                    WHERE _tmpItem_From.OperSumm <> tmpRes_summ.OperSumm_calc
                                   )
           -- Результат
           SELECT tmpRes.MovementId_from, tmpRes.MovementId_to, tmpRes.OperSumm_calc - COALESCE (tmpdiff.OperSumm_diff, 0) As OperSumm_calc
           FROM tmpRes
                LEFT JOIN tmpDiff ON tmpDiff.MovementId_from = tmpRes.MovementId_from
                                 AND                   1     = tmpRes.Ord
          ) AS tmp
     WHERE tmp.MovementId_from = _tmpItem_To.MovementId_from
       AND tmp.MovementId_to   = _tmpItem_To.MovementId_to
    ;

     -- сохранили новую сумму "затрат"
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountCost(), _tmpItem_To.MovementId_cost, OperSumm_calc)
     FROM _tmpItem_To;



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
