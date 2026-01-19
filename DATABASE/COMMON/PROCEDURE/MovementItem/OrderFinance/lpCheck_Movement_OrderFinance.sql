-- Function: lpCheck_Movement_OrderFinance()

DROP FUNCTION IF EXISTS lpCheck_Movement_OrderFinance (Integer, Integer);

CREATE OR REPLACE FUNCTION lpCheck_Movement_OrderFinance(
    IN inMovementId       Integer   ,
    IN inUserId           Integer     -- пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbOrderFinanceId Integer;
   DECLARE vbSum_1 TFloat;
   DECLARE vbSum_2 TFloat;
   DECLARE vbSum_3 TFloat;
   DECLARE vbSum_1_sum TFloat;
   DECLARE vbSum_2_sum TFloat;
   DECLARE vbSum_3_sum TFloat;
BEGIN

     -- нашли
     vbOrderFinanceId := (SELECT MovementLinkObject.ObjectId AS Id
                          FROM MovementLinkObject
                          WHERE MovementLinkObject.MovementId = inMovementId
                            AND MovementLinkObject.DescId = zc_MovementLinkObject_OrderFinance()
                         );

     -- если Заполнение дата предварительный план = ДА
     IF EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId  = vbOrderFinanceId AND OB.DescId = zc_ObjectBoolean_OrderFinance_OperDate() AND OB.ValueData = TRUE)
     THEN
         RETURN;
     END IF;


     -- нашли
     SELECT COALESCE (MovementFloat_TotalSumm_1.ValueData, 0)
          , COALESCE (MovementFloat_TotalSumm_2.ValueData, 0)
          , COALESCE (MovementFloat_TotalSumm_3.ValueData, 0)
            INTO vbSum_1, vbSum_2, vbSum_3
     FROM Movement
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm_1
                                    ON MovementFloat_TotalSumm_1.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm_1.DescId = zc_MovementFloat_TotalSumm_1()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm_2
                                    ON MovementFloat_TotalSumm_2.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm_2.DescId = zc_MovementFloat_TotalSumm_2()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm_3
                                    ON MovementFloat_TotalSumm_3.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm_3.DescId = zc_MovementFloat_TotalSumm_3()
     WHERE Movement.Id = inMovementId
    ;

     -- Результат - после InsertUpdate
     SELECT tmpMI.Sum_1_sum, tmpMI.Sum_2_sum, tmpMI.Sum_3_sum
            INTO vbSum_1_sum, vbSum_2_sum, vbSum_3_sum
     FROM (WITH -- УП-Статья или Группа или ...
                tmpOrderFinanceProperty AS (SELECT DISTINCT
                                                   -- УП - Статья или Группа или ...
                                                   OL_OrderFinanceProperty_Object.ChildObjectId               AS ObjectId
                                                   -- № п/п группы
                                                 , ObjectFloat_Group.ValueData                                AS NumGroup

                                            FROM ObjectLink AS OL_OrderFinanceProperty_OrderFinance
                                                 INNER JOIN Object ON Object.Id       = OL_OrderFinanceProperty_OrderFinance.ObjectId
                                                                  -- не удален
                                                                  AND Object.isErased = FALSE
                                                 -- УП - Статья или Группа или ...
                                                 INNER JOIN ObjectLink AS OL_OrderFinanceProperty_Object
                                                                       ON OL_OrderFinanceProperty_Object.ObjectId      = OL_OrderFinanceProperty_OrderFinance.ObjectId
                                                                      AND OL_OrderFinanceProperty_Object.DescId        = zc_ObjectLink_OrderFinanceProperty_Object()
                                                                      AND OL_OrderFinanceProperty_Object.ChildObjectId > 0

                                                 -- № п/п группы
                                                 LEFT JOIN ObjectFloat AS ObjectFloat_Group
                                                                       ON ObjectFloat_Group.ObjectId = OL_OrderFinanceProperty_OrderFinance.ObjectId
                                                                      AND ObjectFloat_Group.DescId   = zc_ObjectFloat_OrderFinanceProperty_Group()
                                            WHERE OL_OrderFinanceProperty_OrderFinance.ChildObjectId = vbOrderFinanceId
                                              AND OL_OrderFinanceProperty_OrderFinance.DescId        = zc_ObjectLink_OrderFinanceProperty_OrderFinance()
                                           )
                   -- разворачивается по УП-статьям + № группы
                 , tmpInfoMoney_OrderF AS (SELECT DISTINCT
                                                  Object_InfoMoney_View.InfoMoneyId
                                                , tmpOrderFinanceProperty.NumGroup
                                           FROM Object_InfoMoney_View
                                                INNER JOIN tmpOrderFinanceProperty ON (tmpOrderFinanceProperty.ObjectId = Object_InfoMoney_View.InfoMoneyId
                                                                                    OR tmpOrderFinanceProperty.ObjectId = Object_InfoMoney_View.InfoMoneyDestinationId
                                                                                    OR tmpOrderFinanceProperty.ObjectId = Object_InfoMoney_View.InfoMoneyGroupId
                                                                                      )
                                           )
                 -- MI
               , tmpMI AS (SELECT MovementItem.*
                                , MILinkObject_Contract.ObjectId AS ContractId
                           FROM MovementItem
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                                 ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                          )
               -- св-ва
             , tmpMovementItemFloat AS (SELECT *
                                        FROM MovementItemFloat
                                        WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                          AND MovementItemFloat.DescId IN (zc_MIFloat_AmountPlan_1()
                                                                         , zc_MIFloat_AmountPlan_2()
                                                                         , zc_MIFloat_AmountPlan_3()
                                                                         , zc_MIFloat_AmountPlan_4()
                                                                         , zc_MIFloat_AmountPlan_5()
                                                                         )
                                       )
           -- Результат
           SELECT SUM (CASE WHEN tmpInfoMoney_OrderF.NumGroup = 1
                                 THEN COALESCE (MIFloat_AmountPlan_1.ValueData, 0) + COALESCE (MIFloat_AmountPlan_2.ValueData, 0) + COALESCE (MIFloat_AmountPlan_3.ValueData, 0) + COALESCE (MIFloat_AmountPlan_4.ValueData, 0) + COALESCE (MIFloat_AmountPlan_5.ValueData, 0)
                            ELSE 0
                       END) AS Sum_1_sum
                , SUM (CASE WHEN tmpInfoMoney_OrderF.NumGroup = 2
                                 THEN COALESCE (MIFloat_AmountPlan_1.ValueData, 0) + COALESCE (MIFloat_AmountPlan_2.ValueData, 0) + COALESCE (MIFloat_AmountPlan_3.ValueData, 0) + COALESCE (MIFloat_AmountPlan_4.ValueData, 0) + COALESCE (MIFloat_AmountPlan_5.ValueData, 0)
                            ELSE 0
                       END) AS Sum_2_sum
                , SUM (CASE WHEN COALESCE (tmpInfoMoney_OrderF.NumGroup, 0) NOT IN (1, 2)
                                 THEN COALESCE (MIFloat_AmountPlan_1.ValueData, 0) + COALESCE (MIFloat_AmountPlan_2.ValueData, 0) + COALESCE (MIFloat_AmountPlan_3.ValueData, 0) + COALESCE (MIFloat_AmountPlan_4.ValueData, 0) + COALESCE (MIFloat_AmountPlan_5.ValueData, 0)
                            ELSE 0
                       END) AS Sum_3_sum

           FROM tmpMI AS MovementItem
                LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_1
                                               ON MIFloat_AmountPlan_1.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPlan_1.DescId = zc_MIFloat_AmountPlan_1()
                LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_2
                                               ON MIFloat_AmountPlan_2.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPlan_2.DescId = zc_MIFloat_AmountPlan_2()
                LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_3
                                               ON MIFloat_AmountPlan_3.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPlan_3.DescId = zc_MIFloat_AmountPlan_3()
                LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_4
                                               ON MIFloat_AmountPlan_4.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPlan_4.DescId = zc_MIFloat_AmountPlan_4()
                LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_5
                                               ON MIFloat_AmountPlan_5.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPlan_5.DescId = zc_MIFloat_AmountPlan_5()
                -- УП - Статья или Группа или ...
                LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                     ON ObjectLink_Contract_InfoMoney.ObjectId = MovementItem.ContractId
                                    AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                -- УП-статья + № группы
                LEFT JOIN tmpInfoMoney_OrderF ON tmpInfoMoney_OrderF.InfoMoneyId = ObjectLink_Contract_InfoMoney.ChildObjectId
          ) AS tmpMI
          ;


     -- Проверка-1
     IF vbSum_1_sum > vbSum_1
     THEN
         RAISE EXCEPTION 'Ошибка.Для группы УП = <Говядина>%введена сумма план по дням = <%>.%Не может быть больше согласованной суммы = <%>.'
                        , CHR (13)
                        , zfConvert_FloatToString (vbSum_1_sum)
                        , CHR (13)
                        , zfConvert_FloatToString (vbSum_1)
                         ;
     END IF;

     -- Проверка-2
     IF vbSum_2_sum > vbSum_2
     THEN
         RAISE EXCEPTION 'Ошибка.Для группы УП = Для <Живой вес>%введена сумма план по дням = <%>.%Не может быть больше согласованной суммы = <%>.'
                        , CHR (13)
                        , zfConvert_FloatToString (vbSum_2_sum)
                        , CHR (13)
                        , zfConvert_FloatToString (vbSum_2)
                         ;
     END IF;

     -- Проверка-3
     IF vbSum_3_sum > vbSum_3
     THEN
         RAISE EXCEPTION 'Ошибка.Для группы УП = <Прочее мясное сырье>%введена сумма план по дням = <%>.%Не может быть больше согласованной суммы = <%>.'
                        , CHR (13)
                        , zfConvert_FloatToString (vbSum_3_sum)
                        , CHR (13)
                        , zfConvert_FloatToString (vbSum_3)
                         ;
     END IF;

     IF inUserId = 5 AND 1=0
     THEN
          RAISE EXCEPTION 'Ошибка.<%>.<%>.<%>.%<%>.<%>.<%>'
                        , zfConvert_FloatToString (vbSum_1_sum)
                        , zfConvert_FloatToString (vbSum_2_sum)
                        , zfConvert_FloatToString (vbSum_3_sum)
                        , CHR (13)
                        , zfConvert_FloatToString (vbSum_1)
                        , zfConvert_FloatToString (vbSum_2)
                        , zfConvert_FloatToString (vbSum_3)
                         ;
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.12.25                                        *
*/

-- тест
--