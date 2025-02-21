-- Function: gpInsertUpdate_MI_Promo_PriceCalc()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Promo_PriceCalc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Promo_PriceCalc(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMonthPromo TDateTime;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
   DECLARE vbOperDate_Condition TDateTime;

   DECLARE vbContractCondition TFloat;
   DECLARE vbContractId_str TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Promo());


     -- Проверили - Ви товара
     IF EXISTS (SELECT 1
                FROM MovementItem
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                     INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                           ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                          AND ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                         , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                         , zc_Enum_InfoMoney_30102() -- Тушенка
                                                                                          )
                                          AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
                  AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = 0
               )
     THEN
         RAISE EXCEPTION 'Ошибка.Необходимо заполнить колонку вид товара.';
     END IF;


     -- пересчет всех контрагентов
   --PERFORM lpUpdate_Movement_Promo_Auto (inMovementId:= inMovementId, inUserId:= vbUserId);

     -- нашли - на какую дату берем условие
     vbOperDate_Condition := (SELECT MovementDate_StartSale.ValueData
                              FROM MovementDate AS MovementDate_StartSale
                              WHERE MovementDate_StartSale.MovementId  = inMovementId
                                AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                             );

     -- расчет цен за предыдущий месяц от проведения акции



     -- рассчитываем бонус сети - НОВАЯ СХЕМА
     vbContractCondition := (
   --vbContractId_str := (
             WITH -- все контрагенты Акции
                  tmpPromoPartner_all AS (SELECT tmp.PartnerId
                                               , tmp.ContractId
                                          FROM lpSelect_Movement_PromoPartner_Detail (inMovementId:= inMovementId) AS tmp
                                         )
                      -- все юр.лица Акции + если заполнен договор
                    , tmpPromoPartner AS (SELECT DISTINCT
                                                 ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                               , tmpPromoPartner_all.ContractId
                                          FROM tmpPromoPartner_all
                                               INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                     ON ObjectLink_Partner_Juridical.ObjectId = tmpPromoPartner_all.PartnerId
                                                                    AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                         )
                         -- список юр.лиц
                       , tmpJuridical AS (SELECT DISTINCT tmpPromoPartner.JuridicalId FROM tmpPromoPartner)
                     -- все договора - ТОЛЬКО БН
                   , tmpContract_full AS (SELECT View_Contract.*
                                          FROM Object_Contract_View AS View_Contract
                                          WHERE View_Contract.JuridicalId IN (SELECT tmpJuridical.JuridicalId FROM tmpJuridical)
                                            AND View_Contract.PaidKindId = zc_Enum_PaidKind_FirstForm()
                                         )
                      -- все договора
                    , tmpContract_all AS (SELECT * FROM tmpContract_full)
                     -- все договора - не закрытые, для условий
                   , tmpContract_find AS (SELECT View_Contract.*
                                          FROM tmpContract_full AS View_Contract
                                          WHERE View_Contract.isErased = FALSE
                                            AND (View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                              OR View_Contract.InfoMoneyId IN (zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                             , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                              )
                                                )
                                         )
          -- Условия договора на Дату
        , tmpContractCondition AS (SELECT Object_ContractCondition_View.ContractId
                                        , Object_ContractCondition_View.ContractConditionId
                                        , Object_ContractCondition_View.ContractConditionKindId
                                        , Object_ContractCondition_View.Value
                                   FROM Object_ContractCondition_View
                                   WHERE Object_ContractCondition_View.ContractConditionKindId IN (zc_Enum_ContractConditionKind_BonusPercentAccount()
                                                                                                 , zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt()
                                                                                                 , zc_Enum_ContractConditionKind_BonusPercentSaleReturn()
                                                                                                 , zc_Enum_ContractConditionKind_BonusPercentSale()
                                                                                                  )
                                     AND Object_ContractCondition_View.Value <> 0
                                     AND vbOperDate_Condition BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                                )
         -- список договоров, у которых есть условие по "Бонусам"
       , tmpContractConditionKind AS (SELECT -- условие договора
                                             tmpContractCondition.ContractConditionKindId
                                           , View_Contract.JuridicalId
                                             -- договор, в котором бонусное условие
                                           , View_Contract.ContractId            AS ContractId_master
                                             -- статья из договора
                                           , View_InfoMoney.InfoMoneyId AS InfoMoneyId_master
                                             -- статья по которой будет поиск Базы
                                           , CASE WHEN View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                                    OR View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21512() -- Маркетинг + Маркетинговый бюджет
                                                       THEN zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                  WHEN View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21502() -- Маркетинг + Бонусы за мясное сырье
                                                       THEN zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                  -- !!!для других статей - любая база!!!
                                                  WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21500()) -- Маркетинг
                                                       THEN 0
                                                  -- !!!если это База - тогда и другую базу подтянем!!!
                                                  WHEN View_InfoMoney.InfoMoneyGroupId NOT IN (zc_Enum_InfoMoneyGroup_30000()) -- Доходы
                                                       THEN 0
                                                  ELSE COALESCE (View_InfoMoney.InfoMoneyId, 0)
                                             END AS InfoMoneyId_child

                                             -- !!!прописано - где брать "базу"!!!
                                           , CASE WHEN ObjectLink_Contract_InfoMoney_send.ChildObjectId IN (zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                                          , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                                                           )
                                                   AND View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                                                                    , zc_Enum_InfoMoney_21502() -- Маркетинг + Бонусы за мясное сырье
                                                                                    , zc_Enum_InfoMoney_21512() -- Маркетинг + Маркетинговый бюджет
                                                                                     )
                                                  THEN ObjectLink_ContractCondition_ContractSend.ChildObjectId
                                                  ELSE 0
                                             END AS ContractId_baza

                                      FROM tmpContractCondition
                                           -- а это сам договор, в котором бонусное условие
                                           INNER JOIN tmpContract_find AS View_Contract ON View_Contract.ContractId = tmpContractCondition.ContractId
                                           LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract.InfoMoneyId

                                           -- !!!прописано - где брать "базу" или маркет-договор начисления!!!
                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractSend
                                                                ON ObjectLink_ContractCondition_ContractSend.ObjectId = tmpContractCondition.ContractConditionId
                                                               AND ObjectLink_ContractCondition_ContractSend.DescId = zc_ObjectLink_ContractCondition_ContractSend()
                                           -- для ContractId_send
                                           LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney_send
                                                                ON ObjectLink_Contract_InfoMoney_send.ObjectId = ObjectLink_ContractCondition_ContractSend.ChildObjectId
                                                               AND ObjectLink_Contract_InfoMoney_send.DescId   = zc_ObjectLink_Contract_InfoMoney()
                                      -- Значение - %
                                      WHERE tmpContractCondition.Value <> 0
                                     )
      -- для всех юр лиц, у кого есть "Бонусы" формируется список всех других договоров (по ним будем делать расчет "базы")
    , tmpContract AS (SELECT tmpContractConditionKind.JuridicalId
                           , tmpContractConditionKind.ContractId_master
                           , tmpContractConditionKind.ContractId_master AS ContractId_child
                      FROM tmpContractConditionKind
                      -- это будут не бонусные договора (но в них есть бонусы)
                      WHERE tmpContractConditionKind.InfoMoneyId_master = tmpContractConditionKind.InfoMoneyId_child

                     UNION ALL
                      SELECT tmpContractConditionKind.JuridicalId
                           , tmpContractConditionKind.ContractId_master
                           , View_Contract_child.ContractId             AS ContractId_child
                      FROM tmpContractConditionKind
                           LEFT JOIN tmpContract_full AS View_Contract_child ON View_Contract_child.ContractId = tmpContractConditionKind.ContractId_baza
                      WHERE tmpContractConditionKind.InfoMoneyId_master <> tmpContractConditionKind.InfoMoneyId_child
                        -- в бонусном договоре точно указано где взять базу
                        AND tmpContractConditionKind.ContractId_baza > 0

                     UNION ALL
                      SELECT tmpContractConditionKind.JuridicalId
                           , tmpContractConditionKind.ContractId_master
                           , View_Contract_child.ContractId             AS ContractId_child
                      FROM tmpContractConditionKind
                           INNER JOIN tmpContract_full AS View_Contract_child
                                                       ON View_Contract_child.JuridicalId = tmpContractConditionKind.JuridicalId
                                                      AND View_Contract_child.InfoMoneyId = tmpContractConditionKind.InfoMoneyId_child
                      -- это будут бонусные договора
                      WHERE tmpContractConditionKind.InfoMoneyId_master <> tmpContractConditionKind.InfoMoneyId_child
                        -- НЕ указано где взять базу
                        AND tmpContractConditionKind.ContractId_baza = 0
                     )
      -- группируем договора
    , tmpContractGroup AS (SELECT DISTINCT
                                  tmpContract.ContractId_master
                                , tmpContract.ContractId_child
                           FROM tmpContract
                                -- если был установлен Договор
                                INNER JOIN tmpPromoPartner ON tmpPromoPartner.ContractId = tmpContract.ContractId_child
                          UNION
                           SELECT DISTINCT
                                  tmpContract.ContractId_master
                                , tmpContract.ContractId_child
                           FROM tmpContract
                                -- все Юр Лица, если НЕ был установлен Договор
                                INNER JOIN tmpPromoPartner ON tmpPromoPartner.JuridicalId = tmpContract.JuridicalId
                                                          AND tmpPromoPartner.ContractId  = 0
                          )
       -- список договоров
     , tmpContractList AS (SELECT DISTINCT
                                  tmpContractGroup.ContractId_master AS ContractId
                           FROM tmpContractGroup
                          UNION
                           SELECT DISTINCT
                                  tmpContractGroup.ContractId_child  AS ContractId
                           FROM tmpContractGroup
                          )
    , tmpMI AS (SELECT MovementItem.*
                FROM MovementItem
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
               )
  -- Товары в договорах(Спецификация)
, tmpContractGoods_all AS (SELECT DISTINCT
                                  tmpContractList.ContractId
                           FROM tmpContractList
                                INNER JOIN ObjectLink AS ObjectLink_ContractGoods_Contract
                                                      ON ObjectLink_ContractGoods_Contract.ChildObjectId = tmpContractList.ContractId
                                                     AND ObjectLink_ContractGoods_Contract.DescId        = zc_ObjectLink_ContractGoods_Contract()
                                INNER JOIN Object AS Object_ContractGoods ON Object_ContractGoods.Id       = ObjectLink_ContractGoods_Contract.ObjectId
                                                                         AND Object_ContractGoods.isErased = FALSE
                                INNER JOIN ObjectLink AS ObjectLink_ContractGoods_Goods
                                                      ON ObjectLink_ContractGoods_Goods.ObjectId = ObjectLink_ContractGoods_Contract.ObjectId
                                                     AND ObjectLink_ContractGoods_Goods.DescId   = zc_ObjectLink_ContractGoods_Goods()
                                INNER JOIN tmpMI ON tmpMI.ObjectId = ObjectLink_ContractGoods_Goods.ChildObjectId
                          )
      -- договора(Спецификации) + договора(без Спецификации), если надо
    , tmpContractGoods AS (SELECT DISTINCT
                                  tmpContractList.ContractId
                           FROM tmpContractList
                                LEFT JOIN ObjectLink AS ObjectLink_ContractGoods_Contract
                                                     ON ObjectLink_ContractGoods_Contract.ChildObjectId = tmpContractList.ContractId
                                                    AND ObjectLink_ContractGoods_Contract.DescId        = zc_ObjectLink_ContractGoods_Contract()
                                LEFT JOIN Object AS Object_ContractGoods ON Object_ContractGoods.Id       = ObjectLink_ContractGoods_Contract.ObjectId
                                                                        AND Object_ContractGoods.isErased = FALSE
                                LEFT JOIN ObjectLink AS ObjectLink_ContractGoods_Goods
                                                     ON ObjectLink_ContractGoods_Goods.ObjectId = Object_ContractGoods.Id
                                                    AND ObjectLink_ContractGoods_Goods.DescId   = zc_ObjectLink_ContractGoods_Goods()
                                LEFT JOIN tmpMI ON tmpMI.ObjectId = ObjectLink_ContractGoods_Goods.ChildObjectId
                                LEFT JOIN tmpContractGoods_all ON 1=1
                           -- берем договора, у которых нет ограничений по товарам
                           WHERE tmpMI.ObjectId IS NULL
                             -- если не нашли среди тех где есть ограничение по товарам
                             AND tmpContractGoods_all.ContractId IS NULL
                          UNION
                           -- если нашли среди тех где есть ограничение по товарам
                           SELECT tmpContractGoods_all.ContractId
                           FROM tmpContractGoods_all
                          )
    , tmpContract_res AS (SELECT DISTINCT
                                 tmpContractGroup.ContractId_master
                             --, tmpContractGroup.ContractId_child
                           FROM tmpContractGroup
                                INNER JOIN tmpContractGoods ON tmpContractGoods.ContractId = tmpContractGroup.ContractId_master
                                                            OR tmpContractGoods.ContractId = tmpContractGroup.ContractId_child
                          )
       -- Результат
       SELECT MAX (tmp.Value) AS ContractCondition
       --SELECT STRING_AGG (tmp.ContractId_master :: TVarChar, ';')  AS ContractId_str
       FROM (SELECT tmpContract_res.ContractId_master
                  , SUM (COALESCE (tmpContractCondition.Value, 0)) AS Value

             FROM tmpContract_res
                 INNER JOIN Object_Contract_InvNumber_View ON Object_Contract_InvNumber_View.ContractId          = tmpContract_res.ContractId_master
                                                          AND Object_Contract_InvNumber_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                                          AND Object_Contract_InvNumber_View.isErased            = FALSE
                                                          -- Готовая продукция OR  Маркетинг + Бонусы за продукцию + Маркетинговый бюджет
                                                          --AND Object_Contract_InvNumber_View.InfoMoneyId       IN (zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_21501(), zc_Enum_InfoMoney_21512())

                 LEFT JOIN tmpContractCondition ON tmpContractCondition.ContractId = tmpContract_res.ContractId_master

                 LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                                      ON ObjectLink_ContractCondition_BonusKind.ObjectId = tmpContractCondition.ContractConditionId
                                     AND ObjectLink_ContractCondition_BonusKind.DescId   = zc_ObjectLink_ContractCondition_BonusKind()
                 INNER JOIN Object AS Object_BonusKind
                                   ON Object_BonusKind.Id = ObjectLink_ContractCondition_BonusKind.ChildObjectId
                                --AND Object_BonusKind.Id = 81959   ---Бонус

             GROUP BY tmpContract_res.ContractId_master
            ) AS tmp
       );


     -- рассчитываем бонус сети - СТАРАЯ СХЕМА
     IF COALESCE (vbContractCondition, 0) = 0
     THEN
         vbContractCondition := (-- Условия договора на Дату
                                 WITH tmpContractCondition AS (SELECT Object_ContractCondition_View.ContractId
                                                                    , Object_ContractCondition_View.ContractConditionId
                                                                    , Object_ContractCondition_View.ContractConditionKindId
                                                                    , Object_ContractCondition_View.Value
                                                               FROM Object_ContractCondition_View
                                                               WHERE Object_ContractCondition_View.ContractConditionKindId IN (zc_Enum_ContractConditionKind_BonusPercentAccount()
                                                                                                                             , zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt()
                                                                                                                             , zc_Enum_ContractConditionKind_BonusPercentSaleReturn()
                                                                                                                             , zc_Enum_ContractConditionKind_BonusPercentSale()
                                                                                                                              )
                                                                 AND Object_ContractCondition_View.Value <> 0
                                                                 AND vbOperDate_Condition BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                                                            )
                                 -- результат
                                 SELECT MAX (tmp.Value) AS ContractCondition
                                 FROM (SELECT COALESCE (MovementLinkObject_Contract.ObjectId, ObjectLink_Contract_Juridical.ObjectId) AS ContractId
                                            , SUM (COALESCE (ObjectFloat_Value.ValueData, 0)) AS Value

                                       FROM Movement AS Movement_Promo
                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                        ON MovementLinkObject_Contract.MovementId = Movement_Promo.Id
                                                                       AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                                        ON MovementLinkObject_Partner.MovementId = Movement_Promo.Id
                                                                       AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                                                       AND MovementLinkObject_Contract.ObjectId IS NULL

                                           LEFT OUTER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                      ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_Partner.ObjectId
                                                                     AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                                           LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                                ON ObjectLink_Contract_Juridical.ChildObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_Partner.ObjectId)
                                                               AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()

                                           INNER JOIN Object_Contract_InvNumber_View ON Object_Contract_InvNumber_View.ContractId          = COALESCE (MovementLinkObject_Contract.ObjectId, ObjectLink_Contract_Juridical.ObjectId)
                                                                                    AND Object_Contract_InvNumber_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                                                                    AND Object_Contract_InvNumber_View.isErased            = FALSE
                                                                                    -- Готовая продукция OR  Маркетинг + Бонусы за продукцию + Маркетинговый бюджет
                                                                                  AND Object_Contract_InvNumber_View.InfoMoneyId         IN (zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_21501(), zc_Enum_InfoMoney_21512())

                                           INNER JOIN tmpContractCondition ON tmpContractCondition.ContractId = COALESCE (MovementLinkObject_Contract.ObjectId, ObjectLink_Contract_Juridical.ObjectId)
                                                                        --AND tmpContractCondition.isErased = FALSE
                                                                        /*AND tmpContractCondition.ContractConditionKindId IN (zc_Enum_ContractConditionKind_BonusPercentAccount()
                                                                                                                             , zc_Enum_ContractConditionKind_BonusPercentSaleReturn()
                                                                                                                             , zc_Enum_ContractConditionKind_BonusPercentSale()
                                                                                                                              )*/

                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                                                                ON ObjectLink_ContractCondition_BonusKind.ObjectId = tmpContractCondition.ContractConditionId
                                                               AND ObjectLink_ContractCondition_BonusKind.DescId = zc_ObjectLink_ContractCondition_BonusKind()
                                           INNER JOIN Object AS Object_BonusKind
                                                             ON Object_BonusKind.Id = ObjectLink_ContractCondition_BonusKind.ChildObjectId
                                                          --AND Object_BonusKind.Id = 81959   ---Бонус

                                           INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                                  ON ObjectFloat_Value.ObjectId = tmpContractCondition.ContractConditionId
                                                                 AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()

                                       WHERE Movement_Promo.DescId = zc_Movement_PromoPartner()
                                         AND Movement_Promo.StatusId <> zc_Enum_Status_Erased()
                                         AND Movement_Promo.ParentId = inMovementId  ---Ссылка на основной документ <Акции> (zc_Movement_Promo)
                                       GROUP BY COALESCE (MovementLinkObject_Contract.ObjectId, ObjectLink_Contract_Juridical.ObjectId)
                                       ) AS tmp
                                 );
     END IF;

     --
     IF COALESCE (vbContractCondition,0) <> 0
     THEN
        -- сохраняем
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContractCondition(), MovementItem.Id, vbContractCondition)
        FROM MovementItem
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId = zc_MI_Master()
          AND MovementItem.isErased = FALSE
       ;
     END IF;


    IF (1=0 AND vbUserId = 5) OR EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
       AND vbUserId <> 5 AND vbUserId <> 6604558 -- Голота К.О.
    THEN
        RAISE EXCEPTION 'Ошибка.Документ в статусе <%>. Проверка: <%> <%>.'
          , lfGet_Object_ValueData_sh (zc_Enum_Status_Complete())
          , (SELECT DISTINCT MIF.ValueData
             FROM MovementItem
                  LEFT JOIN MovementItemFloat AS MIF
                                              ON MIF.MovementItemId = MovementItem.Id
                                             AND MIF.DescId         = zc_MIFloat_ContractCondition()
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId = zc_MI_Master()
               AND MovementItem.isErased = FALSE
          -- ORDER BY MovementItem.Id LIMIT 1
            )
          , vbContractCondition
--          , vbContractId_str
            ;
    END IF;



     -- дальше считаем с/с

     -- нашли месяц
     vbMonthPromo := (SELECT CASE /*WHEN MovementDate_Insert.ValueData >= '01.04.2022'
                                       THEN DATE_TRUNC ('MONTH', MovementDate_Insert.ValueData)*/
                                  WHEN EXTRACT (DAY FROM MovementDate_Insert.ValueData) BETWEEN 1 AND 10
                                       THEN DATE_TRUNC ('MONTH', (MovementDate_Insert.ValueData - INTERVAL '1 MONTH'))
                                  WHEN EXTRACT (DAY FROM MovementDate_Insert.ValueData) BETWEEN 11 AND 31
                                       THEN DATE_TRUNC ('MONTH', MovementDate_Insert.ValueData)
                                  ELSE DATE_TRUNC ('MONTH', MovementDate_Month.ValueData)
                        END :: TDateTime
                      FROM Movement
                           LEFT JOIN MovementDate AS MovementDate_Insert
                                                  ON MovementDate_Insert.MovementId = Movement.Id
                                                 AND MovementDate_Insert.DescId     = zc_MovementDate_Insert()
                           LEFT JOIN MovementDate AS MovementDate_Month
                                                  ON MovementDate_Month.MovementId = Movement.Id
                                                 AND MovementDate_Month.DescId = zc_MovementDate_Month()
                      WHERE Movement.Id = inMovementId
                     );

     -- расчет цен за предыдущий месяц от проведения акции
     vbEndDate   := CASE WHEN inMovementId = 30449524 THEN '31.01.2025' :: TDateTime ELSE (vbMonthPromo - INTERVAL '1 DAY') :: TDateTime END;
     vbStartDate := DATE_TRUNC ('MONTH', vbEndDate) :: TDateTime;


     -- сохранили расчет с/с за какой месяц
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_ServiceDate(), inMovementId, vbStartDate);


     CREATE TEMP TABLE _tmpData (ReceiptId Integer, GoodsId Integer, GoodsKindId Integer
                               , Price3_cost_real TFloat, Price3_cost TFloat, PriceSale TFloat, Price_cost TFloat, Price_cost_tax TFloat
                               , Price3_cost_all_real TFloat, Price3_cost_all TFloat, PriceSale_all TFloat, Price_cost_all TFloat, Price_cost_tax_all TFloat
                               , Price1_plan TFloat, ReceiptId_plan Integer
                               , OperCount_sale TFloat, SummIn_sale TFloat
                               , Ord Integer
                                ) ON COMMIT DROP;
     WITH tmpAnalyzer AS (SELECT AnalyzerId, isSale, isCost, isSumm, FALSE AS isLoss
                          FROM Constant_ProfitLoss_AnalyzerId_View
                          WHERE DescId = zc_Object_AnalyzerId()
                         )

        , tmpMI AS (SELECT DISTINCT
                           MovementItem.ObjectId AS GoodsId
                         , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                    FROM MovementItem
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                          ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                   )
        , tmpGoods AS (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI)

          -- ВСЕ рецептуры
        , tmpChildReceiptTable AS (SELECT lpSelect.ReceiptId_from, lpSelect.ReceiptId, lpSelect.GoodsId_in, lpSelect.GoodsKindId_in, lpSelect.Amount_in
                                        , lpSelect.ReceiptChildId, lpSelect.GoodsId_out, lpSelect.GoodsKindId_out, lpSelect.Amount_out, lpSelect.isStart, lpSelect.isCost
                                        , COALESCE(PriceList3.Price, PriceList3_test.Price, 0) AS Price3
                                   FROM lpSelect_Object_ReceiptChildDetail () AS lpSelect
                                        -- 46 - ПРАЙС - ФАКТ калькуляции без бонусов
                                        LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3 ON PriceList3.PriceListId = 18885
                                                                                                AND PriceList3.GoodsId     = lpSelect.GoodsId_out
                                                                                                AND vbEndDate >= PriceList3.StartDate AND vbEndDate < PriceList3.EndDate
                                        -- 46 - ПРАЙС - ФАКТ калькуляции без бонусов
                                        LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3_test ON PriceList3_test.PriceListId = 18885
                                                                                                     AND PriceList3_test.GoodsId     = lpSelect.GoodsId_out
                                                                                                     AND CURRENT_DATE >= PriceList3_test.StartDate AND CURRENT_DATE < PriceList3_test.EndDate
                                                                                                     AND vbUserId = 5
                                  )

        , tmpReceipt AS (SELECT tmpGoods.GoodsId, COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) AS  GoodsKindId
                              , MAX (ObjectLink_Receipt_Goods.ObjectId) AS ReceiptId
                         FROM tmpGoods
                              INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                    ON ObjectLink_Receipt_Goods.ChildObjectId = tmpGoods.GoodsId
                                                   AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                              INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                                 AND Object_Receipt.isErased = FALSE
                              INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                       ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                                      AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                      AND ObjectBoolean_Main.ValueData = TRUE
                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                   ON ObjectLink_Receipt_GoodsKind.ObjectId = Object_Receipt.Id
                                                  AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                         GROUP BY tmpGoods.GoodsId, COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0)
                        )

          -- факт цена продажи
        , tmpMIContainer AS (SELECT tmpContainer.GoodsId
                                  , tmpContainer.GoodsKindId
                                  , SUM (tmpContainer.OperCountPartner)  AS OperCount_sale
                                  , SUM (tmpContainer.SummInPartner)     AS SummIn_sale
                             FROM
                                 (SELECT MIContainer.ObjectId_Analyzer       AS GoodsId
                                       , CASE WHEN COALESCE (MIContainer.ObjectIntId_analyzer, 0) = 0 THEN zc_GoodsKind_Basis() ELSE MIContainer.ObjectIntId_analyzer END AS GoodsKindId
                                         -- 1.1. Кол-во, без AnalyzerId
                                       , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = FALSE AND tmpAnalyzer.isLoss = FALSE THEN -1 * MIContainer.Amount
                                                   WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = FALSE AND tmpAnalyzer.isLoss = FALSE THEN  1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS OperCount
                                       , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10400()     THEN -1 * MIContainer.Amount
                                                   WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_10800() THEN  1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS OperCountPartner
                                         -- 1.2. Себестоимость, без AnalyzerId
                                       , SUM (CASE WHEN tmpAnalyzer.isSale = TRUE  AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = TRUE AND tmpAnalyzer.isLoss = FALSE
                                                    -- AND COALESCE (tmpAnalyzer.AnalyzerId, 0) NOT IN (zc_Enum_AnalyzerId_SaleSumm_10500(), zc_Enum_AnalyzerId_SaleSumm_40200())
                                                        THEN -1 * MIContainer.Amount
                                                   WHEN tmpAnalyzer.isSale = FALSE AND tmpAnalyzer.isSumm = TRUE AND tmpAnalyzer.isCost = TRUE AND tmpAnalyzer.isLoss = FALSE
                                                    -- AND COALESCE (tmpAnalyzer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_ReturnInSumm_40200()
                                                        THEN  1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS SummIn
                                       , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10400()
                                                        THEN -1 * MIContainer.Amount
                                                   WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_10800()
                                                        THEN  1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS SummInPartner

                                         -- 2.1. Кол-во - Скидка за вес
                                       , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_10500() THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS OperCount_Change
                                         -- 2.2. Себестоимость - Скидка за вес
                                       , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() THEN -1 * MIContainer.Amount
                                                   ELSE 0
                                              END) AS SummIn_Change

                                         -- 3.1. Кол-во Разница в весе
                                       , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleCount_40200()     THEN 1 * MIContainer.Amount  -- !!! Не меняется знак, т.к. надо показать +/-!!!
                                                   WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInCount_40200() THEN 1 * MIContainer.Amount -- !!! для возврата со знаком - наоборот, т.к. приход!!!
                                                   ELSE 0
                                              END) AS OperCount_40200
                                         -- 3.2. Себестоимость - Разница в весе
                                       , SUM (CASE WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200()     THEN 1 * MIContainer.Amount -- !!! Не меняется знак, т.к. надо показать +/-!!!
                                                   WHEN tmpAnalyzer.AnalyzerId = zc_Enum_AnalyzerId_ReturnInSumm_40200() THEN 1 * MIContainer.Amount -- !!! для возврата со знаком - наоборот, т.к. приход!!!
                                                   ELSE 0
                                              END) AS SummIn_40200

                                  FROM tmpAnalyzer
                                       INNER JOIN MovementItemContainer AS MIContainer
                                                                        ON MIContainer.AnalyzerId = tmpAnalyzer.AnalyzerId
                                                                       AND MIContainer.OperDate BETWEEN vbStartDate AND vbEndDate--inStartDate AND inEndDate
                                       INNER JOIN tmpGoods ON tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                                  WHERE MIContainer.MovementDescId = zc_Movement_Sale()
                                  GROUP BY MIContainer.ObjectId_Analyzer
                                         , MIContainer.ObjectIntId_analyzer
                                  ) AS tmpContainer
                             GROUP BY tmpContainer.GoodsId
                                    , tmpContainer.GoodsKindId
                             )
          -- Сумма затрат из рецептуры
      /*, tmpReceiptCost AS (SELECT tmp.ReceiptId
                                  , tmpMI.GoodsId
                                  , tmpMI.GoodsKindId
                                    --
                                  , MAX (tmp.GoodsId_isCost) AS GoodsId_isCost
                                  , 0 AS OperCount_sale
                                  , 0 AS SummIn_sale
                                  , SUM (tmp.Summ3_cost) AS Summ3_cost
                             FROM (SELECT tmpChildReceiptTable.ReceiptId
                                        , MAX (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.GoodsId_out ELSE 0 END) AS GoodsId_isCost
                                        , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price3 ELSE 0 END) AS Summ3_cost
                                          --
                                        , SUM (tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price3) AS Summ3
                                   FROM tmpChildReceiptTable
                                   WHERE tmpChildReceiptTable.ReceiptId_from = 0
                                   GROUP BY  tmpChildReceiptTable.ReceiptId
                                  ) AS tmp
                                  LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                       ON ObjectLink_Receipt_Goods.ObjectId = tmp.ReceiptId
                                                      AND ObjectLink_Receipt_Goods.DescId   = zc_ObjectLink_Receipt_Goods()
                                  LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                       ON ObjectLink_Receipt_GoodsKind.ObjectId = tmp.ReceiptId
                                                      AND ObjectLink_Receipt_GoodsKind.DescId   = zc_ObjectLink_Receipt_GoodsKind()
                                  -- факт цена продажи
                                  INNER JOIN (SELECT tmpMIContainer.GoodsId, tmpMIContainer.GoodsKindId
                                              FROM tmpMIContainer
                                              WHERE tmpMIContainer.OperCount_sale <> 0
                                              GROUP BY tmpMIContainer.GoodsId, tmpMIContainer.GoodsKindId
                                             ) AS tmpMI ON tmpMI.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                                       AND tmpMI.GoodsKindId = COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0)
                             GROUP BY tmp.ReceiptId
                                    , tmpMI.GoodsId
                                    , tmpMI.GoodsKindId
                             )*/

        , tmpAll AS (-- факт цена продажи
                     SELECT COALESCE (tmpReceipt.ReceiptId, 0) AS ReceiptId
                          , tmpMIContainer.GoodsId
                          , tmpMIContainer.GoodsKindId
                            --
                          , SUM (tmpMIContainer.OperCount_sale)         AS OperCount_sale
                          , SUM (tmpMIContainer.SummIn_sale)            AS SummIn_sale
                          , 0 AS Summ3_cost
                     FROM tmpMIContainer
                          LEFT JOIN tmpReceipt ON tmpReceipt.GoodsId     = tmpMIContainer.GoodsId
                                              AND tmpReceipt.GoodsKindId = tmpMIContainer.GoodsKindId
                     GROUP BY COALESCE (tmpReceipt.ReceiptId, 0)
                            , tmpMIContainer.GoodsId
                            , tmpMIContainer.GoodsKindId

                    UNION ALL
                     -- Сумма затрат из рецептуры - только если были Продажи
                     SELECT tmp.ReceiptId
                          , tmpMI.GoodsId
                          , tmpMI.GoodsKindId
                            --
                          , 0 AS OperCount_sale
                          , 0 AS SummIn_sale
                          , SUM (tmp.Summ3_cost) AS Summ3_cost
                     FROM (SELECT tmpChildReceiptTable.ReceiptId
                                , MAX (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.GoodsId_out ELSE 0 END) AS GoodsId_isCost
                                , SUM (CASE WHEN tmpChildReceiptTable.isCost = TRUE THEN tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price3 ELSE 0 END) AS Summ3_cost
                           FROM tmpChildReceiptTable
                           WHERE tmpChildReceiptTable.ReceiptId_from = 0
                           GROUP BY tmpChildReceiptTable.ReceiptId
                          ) AS tmp
                          LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                               ON ObjectLink_Receipt_Goods.ObjectId = tmp.ReceiptId
                                              AND ObjectLink_Receipt_Goods.DescId   = zc_ObjectLink_Receipt_Goods()
                          LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                               ON ObjectLink_Receipt_GoodsKind.ObjectId = tmp.ReceiptId
                                              AND ObjectLink_Receipt_GoodsKind.DescId   = zc_ObjectLink_Receipt_GoodsKind()
                          -- факт цена продажи
                          INNER JOIN (SELECT tmpMIContainer.GoodsId, tmpMIContainer.GoodsKindId
                                      FROM tmpMIContainer
                                      -- только если были Продажи
                                      WHERE tmpMIContainer.OperCount_sale <> 0
                                      GROUP BY tmpMIContainer.GoodsId, tmpMIContainer.GoodsKindId
                                     ) AS tmpMI ON tmpMI.GoodsId     = ObjectLink_Receipt_Goods.ChildObjectId
                                               AND tmpMI.GoodsKindId = COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0)
                     GROUP BY tmp.ReceiptId
                            , tmpMI.GoodsId
                            , tmpMI.GoodsKindId

                    UNION ALL
                     -- факт список из Акции
                     SELECT DISTINCT
                            tmpReceipt.ReceiptId
                          , tmpMI.GoodsId
                          , tmpMI.GoodsKindId
                            --
                          , 0 AS OperCount_sale
                          , 0 AS SummIn_sale
                          , 0 AS Summ3_cost
                     FROM tmpMI
                          LEFT JOIN tmpReceipt ON tmpReceipt.GoodsId     = tmpMI.GoodsId
                                              AND tmpReceipt.GoodsKindId = tmpMI.GoodsKindId
                     -- если установлен GoodsKind
                     WHERE tmpMI.GoodsKindId > 0
                    )

          -- цена с/с  план - новая схема по прайсу 47-ПРАЙС - ПЛАН калькуляции (СЫРЬЕ)
        , tmpPrice1_plan AS (SELECT tmpReceipt.GoodsId, tmpReceipt.GoodsKindId, tmpReceipt.ReceiptId
                                  , SUM (CASE WHEN ObjectFloatReceipt_Value.ValueData > 0
                                                  THEN CAST (_calcChildReceiptTable.Amount_out * COALESCE (PriceList1_gk.Price, PriceList1.Price, 0) / ObjectFloatReceipt_Value.ValueData -- _calcChildReceiptTable.Amount_in
                                                             AS NUMERIC (16,2))
                                                  ELSE 0
                                         END) AS Price_47
                             FROM tmpReceipt

                                  INNER JOIN ObjectFloat AS ObjectFloatReceipt_Value
                                                         ON ObjectFloatReceipt_Value.ObjectId = tmpReceipt.ReceiptId
                                                        AND ObjectFloatReceipt_Value.DescId = zc_ObjectFloat_Receipt_Value()

                                  INNER JOIN tmpChildReceiptTable AS _calcChildReceiptTable
                                                                  ON _calcChildReceiptTable.ReceiptId = tmpReceipt.ReceiptId
                                                                   -- без затрат
                                                                   AND _calcChildReceiptTable.isCost = FALSE
                                                                   -- без этого
                                                                   AND _calcChildReceiptTable.ReceiptId_from = 0

                                  /*INNER JOIN _calcChildReceiptTable ON _calcChildReceiptTable.ReceiptId = tmpReceipt.ReceiptId
                                                                   -- без затрат
                                                                   AND _calcChildReceiptTable.isCost = FALSE
                                                                   -- без этого
                                                                   AND _calcChildReceiptTable.ReceiptId_from = 0*/

                                  LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList1_gk ON PriceList1_gk.PriceListId = 18886 -- inPriceListId_1
                                                                                             AND PriceList1_gk.GoodsId     = _calcChildReceiptTable.GoodsId_out
                                                                                             AND PriceList1_gk.GoodsKindId = _calcChildReceiptTable.GoodsKindId_out
                                                                                             AND CURRENT_DATE >= PriceList1_gk.StartDate AND CURRENT_DATE < PriceList1_gk.EndDate

                                  LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList1 ON PriceList1.PriceListId = 18886 -- inPriceListId_1
                                                                                          AND PriceList1.GoodsId     = _calcChildReceiptTable.GoodsId_out
                                                                                          AND PriceList1.GoodsKindId = 0
                                                                                          AND CURRENT_DATE >= PriceList1.StartDate AND CURRENT_DATE < PriceList1.EndDate
                                                                                          AND PriceList1_gk.GoodsId IS NULL

                             GROUP BY tmpReceipt.GoodsId, tmpReceipt.GoodsKindId, tmpReceipt.ReceiptId
                            )

       INSERT INTO _tmpData (ReceiptId, GoodsId, GoodsKindId
                           , Price3_cost_real, Price3_cost, PriceSale, Price_cost, Price_cost_tax
                           , Price3_cost_all_real, Price3_cost_all, PriceSale_all, Price_cost_all, Price_cost_tax_all
                           , Price1_plan, ReceiptId_plan
                           , OperCount_sale, SummIn_sale
                           , Ord
                            )
       SELECT tmp.ReceiptId
            , tmp.GoodsId
            , tmp.GoodsKindId

              -- 1.0. цена затраты - старая схема - от затрат в рецептуре
            , tmp.Price3_cost AS Price3_cost_real

              -- 1.1. цена затраты - старая схема - от затрат в рецептуре
            , tmp.Price3_cost
              -- + ПРАЙС-ПЛАН РАСХОДЫ НА ТРУД
            + COALESCE (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Goods_Weight.ValueData <> 0
                                 -- для шт пересчитываем цену из кг
                                  THEN ObjectFloat_Goods_Weight.ValueData * PriceList3.Price
                             ELSE PriceList3.Price
                        END
                      , 0)

              -- 1.2. цена с/с
            , CASE WHEN tmp.OperCount_sale <> 0 THEN CAST (tmp.SummIn_sale / tmp.OperCount_sale AS NUMERIC (16, 2)) ELSE 0 END AS PriceSale

              -- 1.3. цена с/с
            , COALESCE (tmp.Price3_cost,0)
              -- + затраты - старая схема
            + COALESCE (CASE WHEN tmp.OperCount_sale <> 0 THEN CAST ( tmp.SummIn_sale / tmp.OperCount_sale AS NUMERIC (16, 2)) ELSE 0 END,0)
              -- + ПРАЙС-ПЛАН РАСХОДЫ НА ТРУД
            + COALESCE (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Goods_Weight.ValueData <> 0
                                  -- для шт пересчитываем цену из кг
                                  THEN ObjectFloat_Goods_Weight.ValueData * PriceList3.Price
                             ELSE PriceList3.Price
                        END
                      , 0)
              AS Price_cost

              -- 1.41. цена затраты - новая схема - от факт с/с
            , CASE WHEN tmp.OperCount_sale <> 0 THEN CAST (tmp.SummIn_sale / tmp.OperCount_sale AS NUMERIC (16, 2)) ELSE 0 END
            * CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30102() THEN 0.3 ELSE 0.5 END
              AS Price_cost_tax



              -- 2.0. цена затраты - старая схема - от затрат в рецептуре
            , tmp_all.Price3_cost AS Price3_cost_all_real

              -- 2.1. цена затраты - старая схема - от затрат в рецептуре
            , tmp_all.Price3_cost
              -- + ПРАЙС-ПЛАН РАСХОДЫ НА ТРУД
            + COALESCE (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Goods_Weight.ValueData <> 0
                                  -- для шт пересчитываем цену из кг
                                  THEN ObjectFloat_Goods_Weight.ValueData * PriceList3.Price
                             ELSE PriceList3.Price
                        END
                      , 0)
              AS Price3_cost_all

              -- 2.2. цена с/с
            , CASE WHEN tmp_all.OperCount_sale <> 0 THEN CAST (tmp_all.SummIn_sale / tmp_all.OperCount_sale AS NUMERIC (16, 2)) ELSE 0 END AS PriceSale_all
              -- 2.3. цена с/с
            , COALESCE (tmp_all.Price3_cost,0)
              -- + затраты - старая схема
            + COALESCE (CASE WHEN tmp_all.OperCount_sale <> 0 THEN CAST ( tmp_all.SummIn_sale / tmp_all.OperCount_sale AS NUMERIC (16, 2)) ELSE 0 END,0)
              -- + ПРАЙС-ПЛАН РАСХОДЫ НА ТРУД
            + COALESCE (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Goods_Weight.ValueData <> 0
                                  -- для шт пересчитываем цену из кг
                                  THEN ObjectFloat_Goods_Weight.ValueData * PriceList3.Price
                             ELSE PriceList3.Price
                        END
                      , 0)
              AS Price_cost_all

              -- 2.4. цена затраты - новая схема - от факт с/с
            , CASE WHEN tmp_all.OperCount_sale <> 0 THEN CAST (tmp_all.SummIn_sale / tmp_all.OperCount_sale AS NUMERIC (16, 2)) ELSE 0 END
            * CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30102() THEN 0.3 ELSE 0.5 END
              AS Price_cost_tax_all


             -- 3. цена с/с  план - новая схема по прайсу 47-ПРАЙС - ПЛАН калькуляции (СЫРЬЕ)
            , tmpPrice1_plan.Price_47  AS Price1_plan
            , tmpPrice1_plan.ReceiptId AS ReceiptId_plan

            , tmp.OperCount_sale
            , tmp.SummIn_sale

              -- № п/п
            , ROW_NUMBER() OVER (PARTITION BY tmp.GoodsId) AS Ord

       FROM (SELECT MAX (tmpAll.ReceiptId) AS ReceiptId
                  , tmpAll.GoodsId
                  , tmpAll.GoodsKindId
                  , SUM (tmpAll.OperCount_sale) AS OperCount_sale
                  , SUM (tmpAll.SummIn_sale)    AS SummIn_sale
                --, SUM (tmpAll.Summ3_cost)     AS Summ3_cost
                  , MAX (CASE WHEN ObjectFloat_Value.ValueData <> 0 THEN CAST (tmpAll.Summ3_cost / ObjectFloat_Value.ValueData AS NUMERIC (16, 2)) ELSE 0 END) AS Price3_cost
             FROM tmpAll
                   LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                         ON ObjectFloat_Value.ObjectId = tmpAll.ReceiptId
                                        AND ObjectFloat_Value.DescId   = zc_ObjectFloat_Receipt_Value()
             GROUP BY tmpAll.GoodsId
                    , tmpAll.GoodsKindId
            ) AS tmp
             LEFT JOIN (SELECT tmpAll.GoodsId
                             , SUM (tmpAll.OperCount_sale) AS OperCount_sale
                             , SUM (tmpAll.SummIn_sale)    AS SummIn_sale
                           --, SUM (tmpAll.Summ3_cost)     AS Summ3_cost
                             , MAX (CASE WHEN ObjectFloat_Value.ValueData <> 0 THEN CAST (tmpAll.Summ3_cost / ObjectFloat_Value.ValueData AS NUMERIC (16, 2)) ELSE 0 END) AS Price3_cost
                        FROM tmpAll
                              LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                    ON ObjectFloat_Value.ObjectId = tmpAll.ReceiptId
                                                   AND ObjectFloat_Value.DescId   = zc_ObjectFloat_Receipt_Value()
                        GROUP BY tmpAll.GoodsId
                       ) AS tmp_all
                         ON tmp_all.GoodsId = tmp.GoodsId
             --
             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ObjectId = tmp.GoodsId
                                 AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = tmp.GoodsId
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                      ON ObjectFloat_Goods_Weight.ObjectId = tmp.GoodsId
                                     AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()

          -- 1497 - ПРАЙС-ПЛАН РАСХОДЫ НА ТРУД
          LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3 ON PriceList3.PriceListId = 11812271
                                                                  AND PriceList3.GoodsId     = tmp.GoodsId
                                                                  AND PriceList3.GoodsKindId = tmp.GoodsKindId
                                                                --AND vbEndDate >= PriceList3.StartDate AND vbEndDate < PriceList3.EndDate
                                                                  AND CASE WHEN vbEndDate < '01.01.2025' THEN '01.01.2025' ELSE vbEndDate END >= PriceList3.StartDate
                                                                  AND CASE WHEN vbEndDate < '01.01.2025' THEN '01.01.2025' ELSE vbEndDate END < PriceList3.EndDate
                                                                  -- убрали ТРУД
                                                                  AND 1=0

          -- цена с/с  план - новая схема по прайсу 47-ПРАЙС - ПЛАН калькуляции (СЫРЬЕ)
          LEFT JOIN tmpPrice1_plan ON tmpPrice1_plan.GoodsId     = tmp.GoodsId
                                  AND tmpPrice1_plan.GoodsKindId = tmp.GoodsKindId
      ;

/*  IF vbUserId IN (5)

    THEN
        RAISE EXCEPTION 'Проверка. <%>   <%>   <%>'
        , (select max (_tmpData.Price3_cost) from _tmpData)
        , (select max (_tmpData.Price3_cost_all) from _tmpData)
        , (select distinct (_tmpData.ReceiptId) from _tmpData)

        ;
end if;*/

        -- сохраняем полученную с/с
      --PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn2(), MovementItem.Id, COALESCE (_tmpData.Price_cost,0) ::TFloat ) -- факт
      --      , lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn1(), MovementItem.Id, (CAST (COALESCE (_tmpData.Price_cost,0) * 1.1 AS NUMERIC (16, 2))) ::TFloat) -- план   = факт + 10 %

     PERFORM -- факт = факт с/с + затраты
             lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn2(), MovementItem.Id
                                             , -- затраты - !!!НОВАЯ СХЕМА - 50% от с/с!!!
                                               -- COALESCE (_tmpData_all.Price_cost_tax_all, _tmpData.Price_cost_tax, 0)

                                               -- затраты - !!!СТАРАЯ СХЕМА - товар "расходы..."!!!
                                               CASE WHEN _tmpData.PriceSale > 0
                                                         THEN COALESCE (_tmpData.Price3_cost, 0)
                                                    ELSE COALESCE (_tmpData_all.Price3_cost_all, 0)
                                               END

                                               -- факт с/с
                                             + CASE WHEN _tmpData.PriceSale > 0
                                                         THEN _tmpData.PriceSale
                                                    ELSE COALESCE (_tmpData_all.PriceSale_all, 0)
                                               END
                                              )
             -- план  = план ИЛИ факт с/с * 110 % + затраты
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn1(), MovementItem.Id
                                             , -- затраты - !!!НОВАЯ СХЕМА - 50% от с/с!!!
                                               --COALESCE (_tmpData_all.Price_cost_tax_all, _tmpData.Price_cost_tax, 0)

case when vbUserId = 5 AND 1=0 then COALESCE (_tmpData.Price1_plan, 0)
else
                                               -- затраты - !!!СТАРАЯ СХЕМА - товар "расходы..."!!!
                                               CASE WHEN _tmpData.PriceSale > 0
                                                         THEN COALESCE (_tmpData.Price3_cost, 0)
                                                    ELSE COALESCE (_tmpData_all.Price3_cost_all, 0)
                                               END

                                               -- план с/с - Новая схема
                                             + CASE WHEN _tmpData.Price1_plan > 0 /*AND vbUserId = 5*/ THEN _tmpData.Price1_plan

                                                    ELSE -- факт с/с * 110 %
                                                         CAST (1.1 * CASE WHEN _tmpData.PriceSale > 0
                                                                              THEN _tmpData.PriceSale
                                                                          ELSE COALESCE (_tmpData_all.PriceSale_all, 0)
                                                                     END
                                                               AS NUMERIC (16, 2))
                                               END
end
                                              )

             -- !!!затраты - новая схема - 50% от с/с!!!
         --, lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePrice(), MovementItem.Id, COALESCE (_tmpData_all.Price_cost_tax_all, _tmpData.Price_cost_tax, 0))

             -- !!!затраты - новая схема - товар "расходы..."!!!
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePrice(), MovementItem.Id, COALESCE (_tmpData_all.Price3_cost_all, _tmpData.Price3_cost, 0))

     FROM MovementItem
          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                          AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()

          -- цены с учетом GoodsKindId
          LEFT JOIN _tmpData ON _tmpData.GoodsId     = MovementItem.ObjectId
                            AND _tmpData.GoodsKindId = MILinkObject_GoodsKind.ObjectId
                            -- AND _tmpData.PriceSale > 0
                            AND MILinkObject_GoodsKind.ObjectId > 0
          -- цены БЕЗ учета GoodsKindId
          LEFT JOIN _tmpData AS _tmpData_all
                             ON _tmpData_all.GoodsId = MovementItem.ObjectId
                            AND _tmpData_all.Ord     = 1
                            -- если не нашли с учетом GoodsKindId
                            -- AND _tmpData.GoodsId     IS NULL
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Master()
       AND MovementItem.isErased = FALSE
    ;


       -- сохранили протокол
       PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
       FROM MovementItem
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId = zc_MI_Master()
         AND MovementItem.isErased = FALSE
        ;


    IF vbUserId IN (5) -- Голота К.О. , 6604558
       -- AND vbUserId <> 5
       AND 1=1
    THEN
        RAISE EXCEPTION 'Проверка.% условие %: <%>  % факт: <%> % план: <%> % затраты(новая схема): <%> % период расчет с/с: <%>  -  <%>  % цена с/с: <%> % цена затраты(старая схема): <%> % цена прайс_1497: <%> % цена с/с + затраты(старая схема): <%> % виды упак.: <%> % Продажи: <%> % Средняя с/с: <%> % План с/с = <%>% Рецептура для план с/с = <%>'
            -- 1.0. условие %
          , CHR (13)
          , '%'
          , (SELECT DISTINCT zfConvert_FloatToString (MIF.ValueData)
             FROM MovementItem
                  LEFT JOIN MovementItemFloat AS MIF
                                              ON MIF.MovementItemId = MovementItem.Id
                                             AND MIF.DescId         = zc_MIFloat_ContractCondition()
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId = zc_MI_Master()
               AND MovementItem.isErased = FALSE
             --ORDER BY MovementItem.Id LIMIT 1
            )
            -- 1.1.  факт c/c - с учетом затрат
          , CHR (13)
          , (SELECT STRING_AGG (DISTINCT zfConvert_FloatToString (MIF.ValueData), ' ; ')
             FROM (SELECT MIF.ValueData
                   FROM MovementItem
                        LEFT JOIN MovementItemFloat AS MIF
                                                    ON MIF.MovementItemId = MovementItem.Id
                                                   AND MIF.DescId         = zc_MIFloat_PriceIn2()
                        LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                         ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                        AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId = zc_MI_Master()
                     AND MovementItem.isErased = FALSE
                   ORDER BY MovementItem.ObjectId, MILO_GoodsKind.ObjectId, MovementItem.Id
                   --LIMIT 1
                  ) AS MIF
            )
            -- 1.2. план c/c - с учетом затрат
          , CHR (13)
          , (SELECT STRING_AGG (DISTINCT zfConvert_FloatToString (MIF.ValueData), ' ; ')
             FROM (SELECT MIF.ValueData
                   FROM MovementItem
                        LEFT JOIN MovementItemFloat AS MIF
                                                    ON MIF.MovementItemId = MovementItem.Id
                                                   AND MIF.DescId         = zc_MIFloat_PriceIn1()
                        LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                         ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                        AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId = zc_MI_Master()
                     AND MovementItem.isErased = FALSE
                   ORDER BY MovementItem.ObjectId, MILO_GoodsKind.ObjectId, MovementItem.Id
                   --LIMIT 1
                  ) AS MIF
            )
            -- 1.3. затраты - новая схема - не используется
          , CHR (13)
          , /*(SELECT STRING_AGG (DISTINCT zfConvert_FloatToString (MIF.ValueData), ' ; ')
             FROM (SELECT MIF.ValueData
                   FROM MovementItem
                        LEFT JOIN MovementItemFloat AS MIF
                                                    ON MIF.MovementItemId = MovementItem.Id
                                                   AND MIF.DescId         = zc_MIFloat_ChangePrice()
                        LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                         ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                        AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId = zc_MI_Master()
                     AND MovementItem.isErased = FALSE
                   ORDER BY MovementItem.ObjectId, MILO_GoodsKind.ObjectId, MovementItem.Id
                   --LIMIT 1
                  ) AS MIF
            )*/
            (WITH tmpMI AS (SELECT DISTINCT MovementItem.ObjectId AS GoodsId, MILO_GoodsKind.ObjectId AS GoodsKindId
                            FROM MovementItem
                                 INNER JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                   ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                                  AND MILO_GoodsKind.ObjectId       > 0
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId = zc_MI_Master()
                              AND MovementItem.isErased = FALSE
                           )
             SELECT STRING_AGG (DISTINCT zfConvert_FloatToString (Value), ' ; ')
             FROM
                  (SELECT _tmpData.GoodsId, _tmpData.GoodsKindId, _tmpData.Price_cost_tax AS Value
                   FROM _tmpData
                        INNER JOIN tmpMI ON tmpMI.GoodsId     = _tmpData.GoodsId
                                        AND tmpMI.GoodsKindId = _tmpData.GoodsKindId
                                        AND _tmpData.PriceSale > 0
                  UNION
                   SELECT DISTINCT _tmpData.GoodsId, _tmpData_find.GoodsKindId, _tmpData_find.Price_cost_tax_all AS Value
                   FROM tmpMI
                        LEFT JOIN _tmpData ON _tmpData.GoodsId      = tmpMI.GoodsId
                                          AND _tmpData.GoodsKindId  = tmpMI.GoodsKindId
                                          AND _tmpData.PriceSale    > 0
                                          AND tmpMI.GoodsKindId     > 0
                        LEFT JOIN _tmpData AS _tmpData_find ON _tmpData_find.GoodsId = tmpMI.GoodsId
                   WHERE _tmpData.GoodsId IS NULL
                   ORDER BY 1, 2
                  ) AS _tmpData
           )

            -- 2.
          , CHR (13)
          , zfConvert_DateToString (vbStartDate)
          , zfConvert_DateToString (vbEndDate)

             -- 3.1. цена с/с
          , CHR (13)
          , (WITH tmpMI AS (SELECT DISTINCT MovementItem.ObjectId AS GoodsId, MILO_GoodsKind.ObjectId AS GoodsKindId
                            FROM MovementItem
                                 INNER JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                   ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                                  AND MILO_GoodsKind.ObjectId       > 0
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId = zc_MI_Master()
                              AND MovementItem.isErased = FALSE
                           )
             -- 3.1. цена с/с
             SELECT STRING_AGG (DISTINCT zfConvert_FloatToString (Value), ' ; ')
             FROM (SELECT _tmpData.GoodsId, _tmpData.GoodsKindId, _tmpData.PriceSale AS Value
                   FROM _tmpData
                        INNER JOIN tmpMI ON tmpMI.GoodsId     = _tmpData.GoodsId
                                        AND tmpMI.GoodsKindId = _tmpData.GoodsKindId
                                        AND _tmpData.PriceSale > 0
                  UNION
                   SELECT DISTINCT _tmpData_find.GoodsId, _tmpData_find.GoodsKindId, _tmpData_find.PriceSale_all AS Value
                   FROM tmpMI
                        LEFT JOIN _tmpData ON _tmpData.GoodsId      = tmpMI.GoodsId
                                          AND _tmpData.GoodsKindId  = tmpMI.GoodsKindId
                                          AND _tmpData.PriceSale    > 0
                                          AND tmpMI.GoodsKindId     > 0
                        LEFT JOIN _tmpData AS _tmpData_find ON _tmpData_find.GoodsId = tmpMI.GoodsId
                   WHERE _tmpData.GoodsId IS NULL
                   ORDER BY 1, 2
                  ) AS _tmpData
            )

            -- 3.2.1. цена затраты(старая схема)
          , CHR (13)
          , (WITH tmpMI AS (SELECT DISTINCT MovementItem.ObjectId AS GoodsId, MILO_GoodsKind.ObjectId AS GoodsKindId
                            FROM MovementItem
                                 INNER JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                   ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                                  AND MILO_GoodsKind.ObjectId       > 0
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId = zc_MI_Master()
                              AND MovementItem.isErased = FALSE
                           )
             -- 3.2.1. цена затраты(старая схема)
             SELECT STRING_AGG (DISTINCT zfConvert_FloatToString (Value) || ' (' || _tmpData.GoodsKindName || ')', ' ; ')
             FROM (SELECT _tmpData.GoodsId, _tmpData.GoodsKindId, _tmpData.Price3_cost_real AS Value, COALESCE (Object_GoodsKind.ValueData, '') AS GoodsKindName
                   FROM _tmpData
                        INNER JOIN tmpMI ON tmpMI.GoodsId     = _tmpData.GoodsId
                                        AND tmpMI.GoodsKindId = _tmpData.GoodsKindId
                                        AND _tmpData.PriceSale > 0
                        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = _tmpData.GoodsKindId

                  UNION
                   SELECT DISTINCT _tmpData_find.GoodsId, _tmpData_find.GoodsKindId, _tmpData_find.Price3_cost_all_real AS Value, COALESCE (Object_GoodsKind.ValueData, '') AS GoodsKindName
                   FROM tmpMI
                        LEFT JOIN _tmpData ON _tmpData.GoodsId      = tmpMI.GoodsId
                                          AND _tmpData.GoodsKindId  = tmpMI.GoodsKindId
                                          AND _tmpData.PriceSale    > 0
                                          AND tmpMI.GoodsKindId     > 0
                        LEFT JOIN _tmpData AS _tmpData_find ON _tmpData_find.GoodsId = tmpMI.GoodsId
                        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = _tmpData_find.GoodsKindId
                   WHERE _tmpData.GoodsId IS NULL
                   ORDER BY 1, 2
                  ) AS _tmpData
            )

             -- 3.2.2. плюс суммы с ПРАЙС-ПЛАН РАСХОДЫ НА ТРУД
          , CHR (13)
          , (SELECT STRING_AGG (DISTINCT zfConvert_FloatToString (Value) || ' (' || _tmpData.GoodsKindName || ')', ' ; ')
             FROM (SELECT _tmpData.GoodsId, _tmpData.GoodsKindId, COALESCE (Object_GoodsKind.ValueData, '') AS GoodsKindName
                        , COALESCE (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Goods_Weight.ValueData <> 0
                                              THEN ObjectFloat_Goods_Weight.ValueData * PriceList3.Price
                                         ELSE PriceList3.Price
                                    END
                                  , 0) AS Value
                   FROM _tmpData
                        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = _tmpData.GoodsKindId
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                             ON ObjectLink_Goods_Measure.ObjectId = _tmpData.GoodsId
                                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                        LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                                    ON ObjectFloat_Goods_Weight.ObjectId = _tmpData.GoodsId
                                                   AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                        -- 1497 - ПРАЙС-ПЛАН РАСХОДЫ НА ТРУД
                        LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3 ON PriceList3.PriceListId = 11812271
                                                                                AND PriceList3.GoodsId     = _tmpData.GoodsId
                                                                                AND PriceList3.GoodsKindId = _tmpData.GoodsKindId
                                                                              --AND vbEndDate >= PriceList3.StartDate AND vbEndDate < PriceList3.EndDate
                                                                                AND CASE WHEN vbEndDate < '01.01.2025' THEN '01.01.2025' ELSE vbEndDate END >= PriceList3.StartDate
                                                                                AND CASE WHEN vbEndDate < '01.01.2025' THEN '01.01.2025' ELSE vbEndDate END < PriceList3.EndDate
                                                                                -- убрали ТРУД
                                                                                AND 1=0
                   ORDER BY 1, 2
                  ) AS _tmpData
            )

             -- 3.3. цена с/с + затраты(старая схема)
          , CHR (13)
          , (WITH tmpMI AS (SELECT DISTINCT MovementItem.ObjectId AS GoodsId, MILO_GoodsKind.ObjectId AS GoodsKindId
                            FROM MovementItem
                                 INNER JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                   ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                                  AND MILO_GoodsKind.ObjectId       > 0
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId = zc_MI_Master()
                              AND MovementItem.isErased = FALSE
                           )
             -- 3.3. цена с/с + затраты(старая схема)
             SELECT STRING_AGG (DISTINCT zfConvert_FloatToString (Value) || ' (' || _tmpData.GoodsKindName || ')', ' ; ')
             FROM (SELECT _tmpData.GoodsId, _tmpData.GoodsKindId, _tmpData.Price_cost AS Value, COALESCE (Object_GoodsKind.ValueData, '') AS GoodsKindName
                   FROM _tmpData
                        INNER JOIN tmpMI ON tmpMI.GoodsId     = _tmpData.GoodsId
                                        AND tmpMI.GoodsKindId = _tmpData.GoodsKindId
                                        AND _tmpData.PriceSale > 0
                        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = _tmpData.GoodsKindId
                  UNION
                   SELECT DISTINCT _tmpData_find.GoodsId, _tmpData_find.GoodsKindId, _tmpData_find.Price_cost_all AS Value, COALESCE (Object_GoodsKind.ValueData, '') AS GoodsKindName
                   FROM tmpMI
                        LEFT JOIN _tmpData ON _tmpData.GoodsId      = tmpMI.GoodsId
                                          AND _tmpData.GoodsKindId  = tmpMI.GoodsKindId
                                          AND _tmpData.PriceSale    > 0
                                          AND tmpMI.GoodsKindId     > 0
                        LEFT JOIN _tmpData AS _tmpData_find ON _tmpData_find.GoodsId = tmpMI.GoodsId
                        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = _tmpData_find.GoodsKindId
                   WHERE _tmpData.GoodsId IS NULL
                   ORDER BY 1, 2
                  ) AS _tmpData
            )

            -- 3.4. виды упак
          , CHR (13)
          , (WITH tmpMI AS (SELECT DISTINCT MovementItem.ObjectId AS GoodsId, MILO_GoodsKind.ObjectId AS GoodsKindId
                            FROM MovementItem
                                 INNER JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                   ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                                  AND MILO_GoodsKind.ObjectId       > 0
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId = zc_MI_Master()
                              AND MovementItem.isErased = FALSE
                           )
             -- 3.4. виды упак
             SELECT STRING_AGG (DISTINCT lfGet_Object_ValueData_sh (GoodsKindId), ' ; ')
             FROM (SELECT _tmpData.GoodsId, _tmpData.GoodsKindId
                   FROM _tmpData
                        INNER JOIN tmpMI ON tmpMI.GoodsId      = _tmpData.GoodsId
                                        AND tmpMI.GoodsKindId  = _tmpData.GoodsKindId
                  UNION
                   SELECT DISTINCT _tmpData_find.GoodsId, _tmpData_find.GoodsKindId
                   FROM tmpMI
                        LEFT JOIN _tmpData ON _tmpData.GoodsId      = tmpMI.GoodsId
                                          AND _tmpData.GoodsKindId  = tmpMI.GoodsKindId
                                          AND tmpMI.GoodsKindId     > 0
                        LEFT JOIN _tmpData AS _tmpData_find ON _tmpData_find.GoodsId = tmpMI.GoodsId
                   WHERE _tmpData.GoodsId IS NULL
                   ORDER BY 1, 2
                  ) AS _tmpData
            )

            -- 3.5. Продажи
          , CHR (13)
          , (WITH tmpMI AS (SELECT DISTINCT MovementItem.ObjectId AS GoodsId, MILO_GoodsKind.ObjectId AS GoodsKindId
                            FROM MovementItem
                                 INNER JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                   ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                                  AND MILO_GoodsKind.ObjectId       > 0
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId = zc_MI_Master()
                              AND MovementItem.isErased = FALSE
                           )
             -- 3.5. Продажи
             SELECT STRING_AGG (DISTINCT zfConvert_FloatToString (SummIn_sale) || ' / ' || zfConvert_FloatToString (OperCount_sale) || ' (' || _tmpData.GoodsKindName || ')', ' ; ')
             FROM (SELECT _tmpData.GoodsId, _tmpData.GoodsKindId, _tmpData.SummIn_sale, _tmpData.OperCount_sale, COALESCE (Object_GoodsKind.ValueData, '') AS GoodsKindName
                   FROM _tmpData
                        INNER JOIN tmpMI ON tmpMI.GoodsId      = _tmpData.GoodsId
                                        AND tmpMI.GoodsKindId  = _tmpData.GoodsKindId
                                        AND _tmpData.PriceSale > 0
                        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = _tmpData.GoodsKindId

                  UNION
                   SELECT DISTINCT _tmpData_find.GoodsId, _tmpData_find.GoodsKindId, _tmpData_find.SummIn_sale, _tmpData_find.OperCount_sale, COALESCE (Object_GoodsKind.ValueData, '') AS GoodsKindName
                   FROM tmpMI
                        LEFT JOIN _tmpData ON _tmpData.GoodsId      = tmpMI.GoodsId
                                          AND _tmpData.GoodsKindId  = tmpMI.GoodsKindId
                                          AND _tmpData.PriceSale    > 0
                                          AND tmpMI.GoodsKindId     > 0
                        LEFT JOIN _tmpData AS _tmpData_find ON _tmpData_find.GoodsId = tmpMI.GoodsId
                        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = _tmpData_find.GoodsKindId

                   WHERE _tmpData.GoodsId IS NULL
                   ORDER BY 1, 2
                  ) AS _tmpData
            )

            -- 3.6. Средняя с/с
          , CHR (13)
          , (WITH tmpMI AS (SELECT DISTINCT MovementItem.ObjectId AS GoodsId, MILO_GoodsKind.ObjectId AS GoodsKindId
                            FROM MovementItem
                                 INNER JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                   ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                                  AND MILO_GoodsKind.ObjectId       > 0
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId = zc_MI_Master()
                              AND MovementItem.isErased = FALSE
                           )
             -- 3.6. Средняя с/с
             SELECT STRING_AGG (DISTINCT zfConvert_FloatToString (CASE WHEN OperCount_sale > 0 THEN SummIn_sale / OperCount_sale ELSE 0 END), ' ; ')
             FROM (SELECT _tmpData.GoodsId, SUM (_tmpData.SummIn_sale) AS SummIn_sale, SUM (_tmpData.OperCount_sale) AS OperCount_sale
                   FROM _tmpData
                   GROUP BY _tmpData.GoodsId
                   ORDER BY 1
                  ) AS _tmpData
            )

            -- План с/с - новая схема
          , CHR (13)
          , (SELECT STRING_AGG (DISTINCT zfConvert_FloatToString (_tmpData.Price1_plan) || ' (' || _tmpData.GoodsKindName || ')', ' ; ')
             FROM (SELECT _tmpData.*, COALESCE (Object_GoodsKind.ValueData, '') AS GoodsKindName
                   FROM _tmpData
                        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = _tmpData.GoodsKindId
                   ORDER BY _tmpData.GoodsId, _tmpData.GoodsKindId
                  ) AS _tmpData
            )

          , CHR (13)
            -- Рецептура для план с/с
          , (SELECT STRING_AGG (DISTINCT _tmpData.ReceiptCode_str || ' (' || COALESCE (_tmpData.ReceiptId_plan, 0) :: TVarChar || ')' || ' (' || _tmpData.GoodsKindName || ')', ' ; ')
             FROM (SELECT _tmpData.*, COALESCE (ObjectString_Code.ValueData, '') AS ReceiptCode_str, COALESCE (Object_GoodsKind.ValueData, '') AS GoodsKindName
                   FROM _tmpData
                        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = _tmpData.GoodsKindId
                        LEFT JOIN ObjectString AS ObjectString_Code
                                               ON ObjectString_Code.ObjectId = _tmpData.ReceiptId_plan
                                              AND ObjectString_Code.DescId   = zc_ObjectString_Receipt_Code()
                   ORDER BY _tmpData.GoodsId, _tmpData.GoodsKindId
                  ) AS _tmpData
            )
          ;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.09.20         *
*/

/*
--
-- 1
--

 select distinct
                   zfCalc_ReceiptChild_GroupNumber (inGoodsId                := _calcChildReceiptTable.GoodsId_out
                                                   , inGoodsKindId            := _calcChildReceiptTable.GoodsKindId_out
                                                   , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                   , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                   , inIsWeightMain           := ObjectBoolean_WeightMain.ValueData
                                                   , inIsTaxExit              := ObjectBoolean_TaxExit.ValueData
                                                    ) AS GroupNumber
-- , Summ1 / ObjectFloatReceipt_Value.ValueData
, Price1 * Amount_out / Amount_in, Price1 * Amount_out / Amount_in_calc
, Object.* , *
-- select  sum (Price1)
from _calcChildReceiptTable

            LEFT JOIN ObjectFloat AS ObjectFloatReceipt_Value
                                  ON ObjectFloatReceipt_Value.ObjectId = _calcChildReceiptTable.ReceiptId
                                 AND ObjectFloatReceipt_Value.DescId = zc_ObjectFloat_Receipt_Value()

                  LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                       ON ObjectLink_Goods_InfoMoney.ObjectId = _calcChildReceiptTable.GoodsId_out
                                      AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                  LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = CASE WHEN _calcChildReceiptTable.GoodsId_out = zc_Goods_WorkIce() THEN zc_Enum_InfoMoney_10105() ELSE ObjectLink_Goods_InfoMoney.ChildObjectId END
                  LEFT JOIN ObjectBoolean AS ObjectBoolean_WeightMain
                                          ON ObjectBoolean_WeightMain.ObjectId = _calcChildReceiptTable.ReceiptChildId
                                         AND ObjectBoolean_WeightMain.DescId = zc_ObjectBoolean_ReceiptChild_WeightMain()
                  LEFT JOIN ObjectBoolean AS ObjectBoolean_TaxExit
                                          ON ObjectBoolean_TaxExit.ObjectId = _calcChildReceiptTable.ReceiptChildId
                                         AND ObjectBoolean_TaxExit.DescId = zc_ObjectBoolean_ReceiptChild_TaxExit()


                 INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                       ON ObjectLink_Receipt_Goods.ObjectId = _calcChildReceiptTable .ReceiptId
                                      AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                                      --AND ObjectLink_Receipt_Goods.ChildObjectId = 2894

                 INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                       ON ObjectLink_Receipt_GoodsKind.ObjectId = _calcChildReceiptTable .ReceiptId
                                      AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                                      --AND ObjectLink_Receipt_GoodsKind.ChildObjectId = 8344

          inner JOIN ObjectBoolean AS ObjectBoolean_Main
                                  ON ObjectBoolean_Main.ObjectId = _calcChildReceiptTable .ReceiptId
                                 AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
and ObjectBoolean_Main.ValueData = true

          inner JOIN Object on Object.Id = _calcChildReceiptTable .GoodsId_out


 where isCost = false
   AND _calcChildReceiptTable.ReceiptId = 123

   and 1 = zfCalc_ReceiptChild_GroupNumber (inGoodsId                := _calcChildReceiptTable.GoodsId_out
                                                   , inGoodsKindId            := _calcChildReceiptTable.GoodsKindId_out
                                                   , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                   , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                   , inIsWeightMain           := ObjectBoolean_WeightMain.ValueData
                                                   , inIsTaxExit              := ObjectBoolean_TaxExit.ValueData
                                                    )


-- select * from gpUpdate_MI_ProductionUnion_isWeightMain(inMovementItemId := 312169125 , inisWeightMain := 'False' ,  inSession := '343013');
-- select * from gpSelect_MovementItem_PromoGoods(inMovementId := 30273381 , inIsErased := 'False' ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');
-- order by _calcChildReceiptTable .ReceiptId

-- select * from Object where Id = 18886
-- select * from Movement where Id = 30065853


--
-- 2
--

with tmpChildReceiptTable AS (SELECT lpSelect.ReceiptId_from, lpSelect.ReceiptId, lpSelect.GoodsId_in, lpSelect.GoodsKindId_in, lpSelect.Amount_in
                                        , lpSelect.ReceiptChildId, lpSelect.GoodsId_out, lpSelect.GoodsKindId_out, lpSelect.Amount_out, lpSelect.isStart, lpSelect.isCost
                                        , COALESCE(PriceList3.Price, PriceList3_test.Price, 0) AS Price3
                                   FROM lpSelect_Object_ReceiptChildDetail () AS lpSelect
                                        -- 46 - ПРАЙС - ФАКТ калькуляции без бонусов
                                        LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3 ON PriceList3.PriceListId = 18885
                                                                                                AND PriceList3.GoodsId     = lpSelect.GoodsId_out
                                                                                                AND CURRENT_DATE >= PriceList3.StartDate AND CURRENT_DATE < PriceList3.EndDate
                                        -- 46 - ПРАЙС - ФАКТ калькуляции без бонусов
                                        LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3_test ON PriceList3_test.PriceListId = 18885
                                                                                                     AND PriceList3_test.GoodsId     = lpSelect.GoodsId_out
                                                                                                     AND CURRENT_DATE >= PriceList3_test.StartDate AND CURRENT_DATE < PriceList3_test.EndDate
                                                                                                    -- AND vbUserId = 5


where lpSelect.ReceiptId = 6482080
and lpSelect.isCost = false

  )

        , tmpReceipt AS (SELECT tmpGoods.GoodsId, COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) AS  GoodsKindId
                              , MAX (ObjectLink_Receipt_Goods.ObjectId) AS ReceiptId
                         FROM (select distinct ObjectLink_Receipt_Goods.ChildObjectId as GoodsId from tmpChildReceiptTable
                              INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                    ON ObjectLink_Receipt_Goods.ObjectId = tmpChildReceiptTable.ReceiptId
                                                   AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
) as tmpGoods
                              INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                    ON ObjectLink_Receipt_Goods.ChildObjectId = tmpGoods.GoodsId
                                                   AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                              INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                                 AND Object_Receipt.isErased = FALSE
                              INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                       ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                                      AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                      AND ObjectBoolean_Main.ValueData = TRUE
                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                   ON ObjectLink_Receipt_GoodsKind.ObjectId = Object_Receipt.Id
                                                  AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                         GROUP BY tmpGoods.GoodsId, COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0)
                        )

        , tmpPrice1_plan AS (SELECT tmpReceipt.GoodsId, tmpReceipt.GoodsKindId, tmpReceipt.ReceiptId
                                  , SUM (CASE WHEN ObjectFloatReceipt_Value.ValueData > 0
                                                  THEN CAST (_calcChildReceiptTable.Amount_out * COALESCE (PriceList1_gk.Price, PriceList1.Price, 0) / ObjectFloatReceipt_Value.ValueData -- _calcChildReceiptTable.Amount_in
                                                             AS NUMERIC (16,2))
                                                  ELSE 0
                                         END) AS Price_47
--                                  , _calcChildReceiptTable.GoodsId_out
--                                  , _calcChildReceiptTable.GoodsKindId_out
--, ObjectFloatReceipt_Value.ValueData
--, _calcChildReceiptTable.Amount_out
--, COALESCE (PriceList1_gk.Price, PriceList1.Price, 0)
--, _calcChildReceiptTable.Amount_in
--, _calcChildReceiptTable.ReceiptId_from, _calcChildReceiptTable.ReceiptId, _calcChildReceiptTable.GoodsId_in
                             FROM tmpReceipt

                                  --INNER JOIN _calcChildReceiptTable ON _calcChildReceiptTable.ReceiptId = tmpReceipt.ReceiptId
                                  INNER JOIN tmpChildReceiptTable AS _calcChildReceiptTable
                                                                  ON _calcChildReceiptTable.ReceiptId = tmpReceipt.ReceiptId
                                                                   -- без затрат
                                                                   AND _calcChildReceiptTable.isCost = FALSE
                                                                   -- без этого
                                                                   AND _calcChildReceiptTable.ReceiptId_from = 0


                                  LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList1_gk ON PriceList1_gk.PriceListId = 18886 -- inPriceListId_1
                                                                                             AND PriceList1_gk.GoodsId     = _calcChildReceiptTable.GoodsId_out
                                                                                             AND PriceList1_gk.GoodsKindId = _calcChildReceiptTable.GoodsKindId_out
                                                                                             AND CURRENT_DATE >= PriceList1_gk.StartDate AND CURRENT_DATE < PriceList1_gk.EndDate

                                  LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList1 ON PriceList1.PriceListId = 18886 -- inPriceListId_1
                                                                                          AND PriceList1.GoodsId     = _calcChildReceiptTable.GoodsId_out
                                                                                          AND PriceList1.GoodsKindId = 0
                                                                                          AND CURRENT_DATE >= PriceList1.StartDate AND CURRENT_DATE < PriceList1.EndDate
                                                                                          AND PriceList1_gk.GoodsId IS NULL

            LEFT JOIN ObjectFloat AS ObjectFloatReceipt_Value
                                  ON ObjectFloatReceipt_Value.ObjectId = tmpReceipt.ReceiptId
                                 AND ObjectFloatReceipt_Value.DescId = zc_ObjectFloat_Receipt_Value()
-- where lpSelect.ReceiptId_from

                             GROUP BY tmpReceipt.GoodsId, tmpReceipt.GoodsKindId, tmpReceipt.ReceiptId
                              --    , _calcChildReceiptTable.GoodsId_out
                                --  , _calcChildReceiptTable.GoodsKindId_out
                            )

select *
from tmpPrice1_plan
-- left join Object on Object.Id = GoodsId_out
--left join Object as Object_2 on Object_2.Id = GoodsId_in
-- order by GoodsId_out

*/
-- тест
--
-- select * from gpInsertUpdate_MI_Promo_PriceCalc(inMovementId := 30440557,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');
