-- Function: gpComplete_Movement_Recalc_commerc (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS lpComplete_Movement_Recalc_commerc (Integer, Integer, Integer);
DROP FUNCTION IF EXISTS gpComplete_Movement_Recalc_commerc (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Recalc_commerc(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMovementDescId    Integer  , --
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbPriceListId Integer;
   DECLARE vbPartnerId   Integer;
   DECLARE vbRouteTtId   Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbContractId  Integer;
   DECLARE vbPaidKindId  Integer;
   DECLARE vbOperDatePartner TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- 
     IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Detail())
     THEN
         RETURN;
     END IF;


     -- нашли
     vbOperDatePartner:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner());
     -- нашли
     vbContractId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract());
     -- нашли
     vbPaidKindId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PaidKind());
     -- нашли
     vbPartnerId:= CASE WHEN inMovementDescId = zc_Movement_ReturnIn()
                             THEN (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                        WHEN inMovementDescId = zc_Movement_Sale()
                             THEN (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                   END;
     -- нашли
     vbJuridicalId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId AND OL.DescId = zc_ObjectLink_Partner_Juridical());
     -- нашли
     vbRouteTtId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId AND OL.DescId = zc_ObjectLink_Partner_RouteTT());


     -- только для ReturnIn
     IF inMovementDescId = zc_Movement_ReturnIn()
     THEN
         vbPriceListId:= (SELECT Object_PriceList.Id AS PriceListId
                          FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := vbContractId
                                                                    , inPartnerId      := vbPartnerId
                                                                    , inMovementDescId := zc_Movement_ReturnIn()
                                                                    , inOperDate_order := NULL
                                                                    , inOperDatePartner:= vbOperDatePartner
                                                                    , inDayPrior_PriceReturn:= 0
                                                                    , inIsPrior        := FALSE -- !!!отказались от старых цен!!!
                                                                    , inOperDatePartner_order:= NULL
                                                        ) AS tmp
                               LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = tmp.PriceListId
                          LIMIT 1
                         );
         -- сохранили связь с <PriceList>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), inMovementId, vbPriceListId);

     END IF;
     
     -- сохранили связь с <RouteTT>
     IF vbRouteTtId > 0
     THEN
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_RouteTT(), inMovementId, vbRouteTtId);
     END IF;
     

     --IF inUserId = 5
     IF 1 = 1
     THEN

     -- Бонусы
     CREATE TEMP TABLE _tmpBonus (-- Договор (условие бонуса)
                                  ContractId_bonus Integer
                                  -- Договор(начисление)
                                , ContractId Integer
                                  -- Вид Условия договора - Только % бонуса за отгрузку-возврат
                                , ContractConditionKindId Integer
                                  -- Вид бонуса
                                , BonusKindId Integer
                                  -- Форма оплаты (Договор начисление)
                                , PaidKindId Integer
                                  -- Форма оплаты
                                , InfoMoneyId Integer
                                  -- % бонуса
                                , BonusValue TFloat
                                 ) ON COMMIT DROP;

        -- Бонусы
        WITH -- ВСЕ Договора
             tmpContract_full AS (SELECT View_Contract.*
                                  FROM Object_Contract_View AS View_Contract
                                  WHERE View_Contract.JuridicalId = vbJuridicalId
                                 -- and View_Contract.ContractId IN (603080, 603073)
                                  )
         , tmpContract_all AS (SELECT *
                               FROM tmpContract_full
                               -- !!!отключил, теперь только через условие!!!
                               -- WHERE tmpContract_full.PaidKindId = inPaidKindId OR COALESCE (inPaidKindId, 0)  = 0
                              )
           -- все Договора - не закрытые или для Базы
         , tmpContract_find AS (SELECT View_Contract.*
                                FROM tmpContract_full AS View_Contract
                                WHERE View_Contract.isErased = FALSE
                                  AND (View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                    OR View_Contract.InfoMoneyId IN (zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                    )
                                      )
                               )

      -- Условия Договора на Дату
    , tmpContractCondition_all AS (SELECT Object_ContractCondition_View.ContractId
                                          -- Id Условия договора
                                        , Object_ContractCondition_View.ContractConditionId
                                          -- Вид Условия договора
                                        , Object_ContractCondition_View.ContractConditionKindId

                                          -- Форма оплаты - в какой надо взять Базу
                                        , CASE WHEN View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                                 OR View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21502() -- Маркетинг + Бонусы за мясное сырье
                                                 OR View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21512() -- Маркетинг + Маркетинговый бюджет
                                                    -- по !!!Условию!!! или по Договору
                                                    THEN COALESCE (Object_ContractCondition_View.PaidKindId_Condition, Object_ContractCondition_View.PaidKindId)
                                               -- по Договору
                                               ELSE Object_ContractCondition_View.PaidKindId
                                          END AS PaidKindId_byBase

                                          -- Форма оплаты - в какой надо начислить БОНУСЫ
                                        , CASE WHEN View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                                 OR View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21502() -- Маркетинг + Бонусы за мясное сырье
                                                 OR View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21512() -- Маркетинг + Маркетинговый бюджет
                                                    -- по Договору
                                                    THEN Object_ContractCondition_View.PaidKindId
                                               -- !!!по Условию!!!
                                               WHEN Object_ContractCondition_View.PaidKindId_Condition > 0
                                                    THEN Object_ContractCondition_View.PaidKindId_Condition
                                               -- по Договору
                                               ELSE Object_ContractCondition_View.PaidKindId
                                          END AS PaidKindId_calc

                                          -- Значение - % бонуса
                                        , Object_ContractCondition_View.Value

                                   FROM Object_ContractCondition_View
                                        LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = Object_ContractCondition_View.InfoMoneyId
                                   WHERE Object_ContractCondition_View.ContractConditionKindId IN (-- Только % бонуса за отгрузку-возврат
                                                                                                   zc_Enum_ContractConditionKind_BonusPercentSaleReturn()
                                                                                                 , zc_Enum_ContractConditionKind_BonusPercentSale()
                                                                                                 , 0
                                                                                                  )
                                     AND Object_ContractCondition_View.Value <> 0
                                   --AND inStartDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                                     AND vbOperDatePartner   BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                                   --AND (vbUserId <> 5 OR View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21512())
                                )
          -- Условия Договора на Дату
        , tmpContractCondition AS (SELECT tmpContractCondition_all.ContractId
                                          -- Id Условия договора
                                        , tmpContractCondition_all.ContractConditionId
                                          -- Вид Условия договора
                                        , tmpContractCondition_all.ContractConditionKindId
                                          -- Форма оплаты - в какой надо взять Базу
                                        , tmpContractCondition_all.PaidKindId_byBase
                                          -- Форма оплаты - в какой надо начислить БОНУСЫ
                                        , tmpContractCondition_all.PaidKindId_calc
                                          -- Значение - % бонуса
                                        , tmpContractCondition_all.Value
                                   FROM tmpContractCondition_all
                                   -- здесь ограничение по ФО
                                   WHERE tmpContractCondition_all.PaidKindId_byBase = vbPaidKindId
                                  )
           -- zc_Object_ContractPartner - т.е. БАЗУ берем только по этим точкам - если они установлены, иначе по всем
         , tmpContractPartner_all AS
                        (SELECT tmpContract_full.ContractId AS ContractId
                              , tmpContract_full.JuridicalId
                              , COALESCE (ObjectLink_ContractPartner_Partner.ChildObjectId,ObjectLink_Partner_Juridical.ObjectId) AS PartnerId
                                -- Форма оплаты - в какой надо взять Базу
                              , tmpContractCondition.PaidKindId_byBase
                                -- Форма оплаты - в какой надо начислить БОНУСЫ
                              , tmpContractCondition.PaidKindId_calc
                              
                              -- если нужно считать по условиям - для НАЛ
                              --, CASE WHEN tmpContractCondition.PaidKindId_calc = zc_Enum_PaidKind_SecondForm() THEN tmpContractCondition.ContractConditionId ELSE 0 END AS ContractConditionId
                                 --07,01,2022 - для БН тоже огр. по выбранным контрагентам
                              , tmpContractCondition.ContractConditionId -- Id Условия договора
                         FROM tmpContract_full

                                  INNER JOIN tmpContractCondition
                                          ON tmpContractCondition.ContractId = tmpContract_full.ContractId
                                         AND tmpContractCondition.ContractConditionKindId IN (zc_Enum_ContractConditionKind_BonusPercentSaleReturn()
                                                                                            , zc_Enum_ContractConditionKind_BonusPercentSale()
                                                                                             )
                                  -- Контрагенты в Договоре
                                  LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Contract
                                                       ON ObjectLink_ContractPartner_Contract.ChildObjectId = tmpContractCondition.ContractId
                                                      AND ObjectLink_ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()
                                                      -- временно?
                                                      AND (tmpContract_full.ContractId <> 887538 -- (8556) 402Р СІЛЬПО-ФУД ТОВ
                                                      --OR inPaidKindID = zc_Enum_PaidKind_SecondForm()
                                                        OR 1 = 1
                                                          )

                                  LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Partner
                                                       ON ObjectLink_ContractPartner_Partner.ObjectId = ObjectLink_ContractPartner_Contract.ObjectId
                                                      AND ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()

                                   -- Юр лицо в Договоре
                                  LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                       ON ObjectLink_Contract_Juridical.ObjectId = tmpContract_full.ContractId --ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Partner_Juridical.ChildObjectId      --  AS JuridicalId-- ObjectLink_Contract_Juridical.ObjectId = Object_Contract_InvNumber_View.ContractId
                                                      AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                                      -- если такиех нет, берем ВСЕХ контрагентов
                                                      AND ObjectLink_ContractPartner_Partner.ChildObjectId IS NULL
                                  -- ВСЕ Контрагенты
                                  LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                       ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Contract_Juridical.ChildObjectId
                                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                     --!!!WHERE tmpContract_full.PaidKindId = inPaidKindId
                         )
           -- Для нал еще zc_Object_ContractConditionPartner - если выбраны то бонусы только на них считаем
              -- 07.01.2020 - для БН аналогично как и НАЛ
         , tmpCCPartner AS (SELECT tmp.ContractId
                                 , tmp.ContractConditionId
                                 , tmp.JuridicalId
                                 , tmp.PaidKindId_byBase
                                 , tmp.PaidKindId_calc
                                 , ObjectLink_ContractConditionPartner_Partner.ChildObjectId AS PartnerId
                            FROM (SELECT DISTINCT tmpContractPartner_all.ContractId, tmpContractPartner_all.ContractConditionId, tmpContractPartner_all.JuridicalId, tmpContractPartner_all.PaidKindId_byBase, tmpContractPartner_all.PaidKindId_calc
                                  FROM tmpContractPartner_all
                                 ) AS tmp
                                 LEFT JOIN ObjectLink AS ObjectLink_ContractConditionPartner_ContractCondition
                                                      ON ObjectLink_ContractConditionPartner_ContractCondition.ChildObjectId = tmp.ContractConditionId
                                                     AND ObjectLink_ContractConditionPartner_ContractCondition.DescId        = zc_ObjectLink_ContractConditionPartner_ContractCondition()
                                 INNER JOIN ObjectLink AS ObjectLink_ContractConditionPartner_Partner
                                                       ON ObjectLink_ContractConditionPartner_Partner.ObjectId = ObjectLink_ContractConditionPartner_ContractCondition.ObjectId
                                                      AND ObjectLink_ContractConditionPartner_Partner.DescId   = zc_ObjectLink_ContractConditionPartner_Partner()
                           )
     
           -- объединяеем Контрагентов
         , tmpContractPartner AS (-- условия договора + zc_Object_ContractConditionPartner
                                  SELECT tmpContractPartner_all.ContractId
                                       , tmpContractPartner_all.JuridicalId
                                       , tmpContractPartner_all.PartnerId
                                       , tmpContractPartner_all.PaidKindId_byBase
                                       , tmpContractPartner_all.PaidKindId_calc
                                         -- значение только для НАЛ
                                       , tmpContractPartner_all.ContractConditionId
                              
                                  FROM tmpContractPartner_all
                                       INNER JOIN tmpCCPartner ON tmpCCPartner.ContractConditionId = tmpContractPartner_all.ContractConditionId
                                                              AND tmpCCPartner.PartnerId           = tmpContractPartner_all.PartnerId
                                --WHERE COALESCE ((SELECT COUNT(*) FROM tmpCCPartner),0) <> 0

                                 UNION
                                  -- если нет в zc_Object_ContractConditionPartner - берем ВСЕХ
                                  SELECT tmpContractPartner_all.ContractId
                                       , tmpContractPartner_all.JuridicalId
                                       , tmpContractPartner_all.PartnerId
                                       , tmpContractPartner_all.PaidKindId_byBase
                                       , tmpContractPartner_all.PaidKindId_calc
                                         -- значение только для НАЛ
                                       , tmpContractPartner_all.ContractConditionId
                                  FROM tmpContractPartner_all
                                       LEFT JOIN tmpCCPartner ON tmpCCPartner.ContractConditionId = tmpContractPartner_all.ContractConditionId
                                                             AND tmpCCPartner.PartnerId           = tmpContractPartner_all.PartnerId
                                --WHERE COALESCE ((SELECT COUNT(*) FROM tmpCCPartner),0) = 0
                                  WHERE tmpCCPartner.PartnerId IS NULL
                                    -- т.е. для "других" условий
                                    AND tmpContractPartner_all.ContractConditionId NOT IN (SELECT DISTINCT tmpCCPartner.ContractConditionId FROM tmpCCPartner)

                                 UNION
                                  -- если вдруг в zc_Object_ContractConditionPartner есть контрагенты, которых нет в договоре
                                  SELECT tmpCCPartner.ContractId
                                       , tmpCCPartner.JuridicalId
                                       , tmpCCPartner.PartnerId
                                       , tmpCCPartner.PaidKindId_byBase
                                       , tmpCCPartner.PaidKindId_calc
                                         -- если нужно считать по условиям - для НАЛ
                                       --, CASE WHEN tmpCCPartner.PaidKindId_calc = zc_Enum_PaidKind_SecondForm() THEN tmpCCPartner.ContractConditionId ELSE 0 END AS ContractConditionId
                                       , tmpCCPartner.ContractConditionId
                                  FROM tmpCCPartner
                                       LEFT JOIN tmpContractPartner_all ON tmpContractPartner_all.ContractConditionId = tmpCCPartner.ContractConditionId
                                                                        AND tmpContractPartner_all.PartnerId           = tmpCCPartner.PartnerId
                                  WHERE tmpContractPartner_all.PartnerId IS NULL
                                  --AND COALESCE ((SELECT COUNT(*) FROM tmpCCPartner),0) <> 0
                                 )
      
         -- список договоров, у которых есть условие по "Бонусам"
       , tmpContractConditionKind AS (SELECT -- условие договора
                                             tmpContractCondition.ContractConditionKindId AS ContractConditionKindId
                                           , View_Contract.JuridicalId
                                           , View_Contract.InvNumber             AS InvNumber_master
                                           , View_Contract.ContractTagId         AS ContractTagId_master
                                           , View_Contract.ContractTagName       AS ContractTagName_master
                                           , View_Contract.ContractStateKindCode AS ContractStateKindCode_master
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

                                             -- статья из условия - ограничение при поиске маркет-договор начисления
                                           , COALESCE (ObjectLink_ContractCondition_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_Condition
                                             -- Форма оплаты - в какой надо взять Базу
                                           , tmpContractCondition.PaidKindId_byBase
                                             -- Форма оплаты - в какой надо начислить БОНУСЫ
                                           , tmpContractCondition.PaidKindId_calc
                                             -- вид бонуса
                                           , ObjectLink_ContractCondition_BonusKind.ChildObjectId    AS BonusKindId
                                           , COALESCE (tmpContractCondition.Value, 0)                AS Value
                                           , COALESCE (ObjectFloat_PercentRetBonus.ValueData,0)      AS PercentRetBonus
                                           , COALESCE (Object_Comment.ValueData, '')                 AS Comment

                                           -- !!!прописано - где брать "базу" или маркет-договор начисления!!!
                                           --, ObjectLink_ContractCondition_ContractSend.ChildObjectId AS ContractId_send
                                             -- !!!прописано - где брать маркет-договор начисления!!!
                                           , CASE WHEN ObjectLink_Contract_InfoMoney_send.ChildObjectId IN (zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                                          , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                                                           )
                                                   AND View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                                                                    , zc_Enum_InfoMoney_21502() -- Маркетинг + Бонусы за мясное сырье
                                                                                    , zc_Enum_InfoMoney_21512() -- Маркетинг + Маркетинговый бюджет
                                                                                     )
                                                  THEN 0
                                                  ELSE ObjectLink_ContractCondition_ContractSend.ChildObjectId
                                             END AS ContractId_send

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

                                             -- если нужно считать по условиям - для НАЛ
                                           --, CASE WHEN tmpContractCondition.PaidKindId_calc = zc_Enum_PaidKind_SecondForm() THEN tmpContractCondition.ContractConditionId ELSE 0 END AS ContractConditionId
                                           , tmpContractCondition.ContractConditionId

                                      FROM tmpContractCondition
                                           -- а это сам договор, в котором бонусное условие
                                           INNER JOIN tmpContract_find AS View_Contract ON View_Contract.ContractId = tmpContractCondition.ContractId
                                                                                     --AND View_Contract.PaidKindId = inPaidKindId
                                           LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract.InfoMoneyId

                                           LEFT JOIN Object AS Object_Comment ON Object_Comment.Id = tmpContractCondition.ContractConditionId
                                           -- % возврата план
                                           LEFT JOIN ObjectFloat AS ObjectFloat_PercentRetBonus
                                                                 ON ObjectFloat_PercentRetBonus.ObjectId = tmpContractCondition.ContractConditionId
                                                                AND ObjectFloat_PercentRetBonus.DescId   = zc_ObjectFloat_ContractCondition_PercentRetBonus()

                                           -- !!!прописано - где брать "базу" или маркет-договор начисления!!!
                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractSend
                                                                ON ObjectLink_ContractCondition_ContractSend.ObjectId = tmpContractCondition.ContractConditionId
                                                               AND ObjectLink_ContractCondition_ContractSend.DescId = zc_ObjectLink_ContractCondition_ContractSend()
                                           -- для ContractId_send
                                           LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney_send
                                                                ON ObjectLink_Contract_InfoMoney_send.ObjectId = ObjectLink_ContractCondition_ContractSend.ChildObjectId
                                                               AND ObjectLink_Contract_InfoMoney_send.DescId   = zc_ObjectLink_Contract_InfoMoney()
                                           -- Вид бонуса
                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                                                                ON ObjectLink_ContractCondition_BonusKind.ObjectId = tmpContractCondition.ContractConditionId
                                                               AND ObjectLink_ContractCondition_BonusKind.DescId   = zc_ObjectLink_ContractCondition_BonusKind()
                                           -- УП статья в условии договора
                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_InfoMoney
                                                                ON ObjectLink_ContractCondition_InfoMoney.ObjectId = tmpContractCondition.ContractConditionId
                                                               AND ObjectLink_ContractCondition_InfoMoney.DescId   = zc_ObjectLink_ContractCondition_InfoMoney()
                                      -- только такие уловия
                                      WHERE tmpContractCondition.ContractConditionKindId IN (zc_Enum_ContractConditionKind_BonusPercentSaleReturn()
                                                                                           , zc_Enum_ContractConditionKind_BonusPercentSale()
                                                                                            )
                                     )

      -- для договоров (если !!!заполнены уп-статьи для условий!!!) надо найти бонусный договор (по 4-м ключам + пусто в "Типы условий договоров")
      -- т.е. условие есть в базовых, но надо подставить "маркет-договор" и начисления провести на него
     , tmpContractBonus AS (SELECT DISTINCT
                                  tmpContract_find.ContractId_master
                                , tmpContract_find.ContractId_find
                                , View_Contract_InvNumber_find.InfoMoneyId AS InfoMoneyId_find
                                , View_Contract_InvNumber_find.InvNumber   AS InvNumber_find
                                  -- условия
                                , tmpContract_find.ContractConditionId
                           FROM (-- базовые договора в которых "бонусное" условие + ContractId_send
                                 SELECT DISTINCT
                                        tmpContractConditionKind.ContractId_master AS ContractId_master
                                        --
                                      , tmpContractConditionKind.ContractId_send   AS ContractId_find
                                        --
                                      , tmpContractConditionKind.ContractConditionId

                                 FROM tmpContractConditionKind
                                      LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney_send
                                                           ON ObjectLink_Contract_InfoMoney_send.ObjectId = tmpContractConditionKind.ContractId_send
                                                          AND ObjectLink_Contract_InfoMoney_send.DescId   = zc_ObjectLink_Contract_InfoMoney()
                                 -- !!!прописано - где брать "маркет-договор"!!!
                                 WHERE tmpContractConditionKind.ContractId_send > 0

                                UNION
                                 -- остальные базовые договора для которых находим "маркет-договор"
                                 SELECT tmpContractConditionKind.ContractId_master
                                      , MAX (COALESCE (View_Contract_find_tag.ContractId, View_Contract_find.ContractId)) AS ContractId_find
                                      , tmpContractConditionKind.ContractConditionId
                                 FROM tmpContractConditionKind
                                      -- все другие ContractCondition с этим видом бонуса
                                      INNER JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                                                            ON ObjectLink_ContractCondition_BonusKind.ChildObjectId = tmpContractConditionKind.BonusKindId
                                                           AND ObjectLink_ContractCondition_BonusKind.DescId        = zc_ObjectLink_ContractCondition_BonusKind()
                                      -- условие договора НЕ удален
                                      INNER JOIN tmpContractCondition ON tmpContractCondition.ContractConditionId = ObjectLink_ContractCondition_BonusKind.ObjectId
                                                                      -- с этим процентом
                                                                      AND tmpContractCondition.Value = tmpContractConditionKind.Value
                                      -- ПОИСК 1 - по 3 - м условиям, главное - ContractTagId_master
                                      LEFT JOIN tmpContract_all AS View_Contract_find_tag
                                                                ON View_Contract_find_tag.JuridicalId   = tmpContractConditionKind.JuridicalId
                                                               AND View_Contract_find_tag.InfoMoneyId   = tmpContractConditionKind.InfoMoneyId_Condition
                                                               AND View_Contract_find_tag.ContractTagId = tmpContractConditionKind.ContractTagId_master
                                                               AND tmpContractConditionKind.ContractId_send IS NULL
                                                               -- как-то работало и без этого условия
                                                               AND View_Contract_find_tag.ContractId    = tmpContractCondition.ContractId

                                      -- ПОИСК 2 - по 3 - м условиям - любой, т.е. в нем будет другой ContractTagId_master
                                      LEFT JOIN tmpContract_all AS View_Contract_find
                                                                ON View_Contract_find.JuridicalId = tmpContractConditionKind.JuridicalId
                                                               AND View_Contract_find.InfoMoneyId = tmpContractConditionKind.InfoMoneyId_Condition
                                                               AND View_Contract_find.ContractId  = tmpContractCondition.ContractId
                                                               AND View_Contract_find_tag.ContractId        IS NULL
                                                               AND tmpContractConditionKind.ContractId_send IS NULL
                                 WHERE -- есть статья в условии договора
                                       tmpContractConditionKind.InfoMoneyId_Condition <> 0
                                       -- !!!НЕТ самого условия договора!!!
                                   AND COALESCE (tmpContractCondition.ContractConditionKindId, 0) = 0
                                       -- !!!НЕ прописано - где брать "маркет-договор"!!!
                                   AND tmpContractConditionKind.ContractId_send IS NULL
                                       -- !!!НЕ прописано - где брать "базу"!!!
                                   AND tmpContractConditionKind.ContractId_baza IS NULL

                                 GROUP BY tmpContractConditionKind.ContractId_master, tmpContractConditionKind.ContractConditionId
                                ) AS tmpContract_find
                                LEFT JOIN tmpContract_all AS View_Contract_InvNumber_find ON View_Contract_InvNumber_find.ContractId = tmpContract_find.ContractId_find
                           WHERE tmpContract_find.ContractId_find <> 0
                          )

      -- для всех юр лиц, у кого есть "Бонусы" формируется список всех других договоров (по ним будем делать расчет "базы")
    , tmpContract AS (SELECT tmpContractConditionKind.JuridicalId
                           , tmpContractConditionKind.InvNumber_master
                           , tmpContractConditionKind.InvNumber_master  AS InvNumber_child
                           , tmpContractConditionKind.ContractId_master
                           , tmpContractConditionKind.ContractId_master AS ContractId_child
                           , tmpContractConditionKind.ContractTagName_master       AS ContractTagName_child
                           , tmpContractConditionKind.ContractStateKindCode_master AS ContractStateKindCode_child
                           , tmpContractConditionKind.InfoMoneyId_master
                           , tmpContractConditionKind.InfoMoneyId_child
                           , tmpContractConditionKind.InfoMoneyId_Condition
                             -- Форма оплаты - в какой надо взять Базу
                           , tmpContractConditionKind.PaidKindId_byBase
                             -- Форма оплаты - в какой надо начислить БОНУСЫ
                           , tmpContractConditionKind.PaidKindId_calc
                             --
                           , tmpContractConditionKind.ContractConditionKindId
                           , tmpContractConditionKind.BonusKindId
                           , tmpContractConditionKind.Value
                           , tmpContractConditionKind.PercentRetBonus
                           , tmpContractConditionKind.Comment
                           , tmpContractConditionKind.ContractConditionId
                      FROM tmpContractConditionKind
                      -- это будут не бонусные договора (но в них есть бонусы)
                      WHERE tmpContractConditionKind.InfoMoneyId_master = tmpContractConditionKind.InfoMoneyId_child

                    UNION ALL
                      SELECT tmpContractConditionKind.JuridicalId
                           , tmpContractConditionKind.InvNumber_master
                             -- замена
                           , View_Contract_child.InvNumber             AS InvNumber_child
                             --
                           , tmpContractConditionKind.ContractId_master
                             -- замена
                           , View_Contract_child.ContractId            AS ContractId_child
                             -- замена
                           , View_Contract_child.ContractTagName       AS ContractTagName_child
                             -- замена
                           , View_Contract_child.ContractStateKindCode AS ContractStateKindCode_child
                             --
                           , tmpContractConditionKind.InfoMoneyId_master
                           , tmpContractConditionKind.InfoMoneyId_child
                             --
                           , tmpContractConditionKind.InfoMoneyId_Condition
                             -- Форма оплаты - в какой надо взять Базу
                           , tmpContractConditionKind.PaidKindId_byBase
                             -- Форма оплаты - в какой надо начислить БОНУСЫ
                           , tmpContractConditionKind.PaidKindId_calc
                             --
                           , tmpContractConditionKind.ContractConditionKindId
                           , tmpContractConditionKind.BonusKindId
                           , tmpContractConditionKind.Value
                           , tmpContractConditionKind.PercentRetBonus
                           , tmpContractConditionKind.Comment
                           , tmpContractConditionKind.ContractConditionId
                      FROM tmpContractConditionKind
                           LEFT JOIN tmpContract_full AS View_Contract_child ON View_Contract_child.ContractId = tmpContractConditionKind.ContractId_baza
                      WHERE tmpContractConditionKind.InfoMoneyId_master <> tmpContractConditionKind.InfoMoneyId_child
                        -- в бонусном договоре точно указано где взять базу
                        AND tmpContractConditionKind.ContractId_baza > 0

                    UNION ALL
                      SELECT tmpContractConditionKind.JuridicalId
                           , tmpContractConditionKind.InvNumber_master
                           , View_Contract_child.InvNumber             AS InvNumber_child
                           , tmpContractConditionKind.ContractId_master
                           , View_Contract_child.ContractId            AS ContractId_child
                           , View_Contract_child.ContractTagName       AS ContractTagName_child
                           , View_Contract_child.ContractStateKindCode AS ContractStateKindCode_child
                           , tmpContractConditionKind.InfoMoneyId_master
                           , tmpContractConditionKind.InfoMoneyId_child
                           , tmpContractConditionKind.InfoMoneyId_Condition
                             -- Форма оплаты - в какой надо взять Базу
                           , tmpContractConditionKind.PaidKindId_byBase
                             -- Форма оплаты - в какой надо начислить БОНУСЫ
                           , tmpContractConditionKind.PaidKindId_calc
                             --
                           , tmpContractConditionKind.ContractConditionKindId
                           , tmpContractConditionKind.BonusKindId
                           , tmpContractConditionKind.Value
                           , tmpContractConditionKind.PercentRetBonus
                           , tmpContractConditionKind.Comment
                           , tmpContractConditionKind.ContractConditionId
                      FROM tmpContractConditionKind
                           INNER JOIN tmpContract_full AS View_Contract_child
                                                       ON View_Contract_child.JuridicalId = tmpContractConditionKind.JuridicalId
                                                      AND View_Contract_child.InfoMoneyId = tmpContractConditionKind.InfoMoneyId_child
                      -- это будут бонусные договора
                      WHERE tmpContractConditionKind.InfoMoneyId_master <> tmpContractConditionKind.InfoMoneyId_child
                        -- НЕ указано где взять базу
                        AND tmpContractConditionKind.ContractId_baza = 0
                     )

     INSERT INTO _tmpBonus (ContractId_bonus, ContractId, ContractConditionKindId, BonusKindId, PaidKindId, InfoMoneyId, BonusValue)
        SELECT
              -- Договор (условие бонуса)
              tmpContract.ContractId_master AS ContractId_bonus
              -- Договор(начисление)
            , CASE WHEN tmpContract.InfoMoneyId_Condition <> 0 AND tmpContractBonus.ContractId_find > 0
                        THEN tmpContractBonus.ContractId_find
                   ELSE tmpContract.ContractId_master
              END AS ContractId
              -- Вид Условия договора - Только % бонуса за отгрузку-возврат
            , tmpContract.ContractConditionKindID AS ContractConditionKindId
              -- Вид бонуса
            , tmpContract.BonusKindId AS BonusKindId
              -- Форма оплаты (Договор начисление)
            , tmpContract.PaidKindId_calc AS PaidKindId
              -- 
            , CASE WHEN tmpContract.InfoMoneyId_Condition = zc_Enum_InfoMoney_21512() -- Маркетинг + Маркетинговый бюджет
                        THEN tmpContract.InfoMoneyId_Condition
                   WHEN tmpContract.InfoMoneyId_Condition <> 0 AND tmpContractBonus.ContractId_find > 0
                        THEN tmpContractBonus.InfoMoneyId_find
                   WHEN tmpContract.InfoMoneyId_master = zc_Enum_InfoMoney_30101() -- Готовая продукция
                        THEN zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                   WHEN tmpContract.InfoMoneyId_master = zc_Enum_InfoMoney_30201() -- Мясное сырье
                        THEN zc_Enum_InfoMoney_21502() -- Маркетинг + Бонусы за мясное сырье
                   ELSE tmpContract.InfoMoneyId_master
              END AS InfoMoneyId
              -- % бонуса
            , tmpContract.Value AS BonusValue

        FROM tmpContract
             LEFT JOIN tmpContractBonus ON tmpContractBonus.ContractId_master = tmpContract.ContractId_master
                                       -- еще условие
                                       AND tmpContractBonus.ContractConditionId = tmpContract.ContractConditionId
        WHERE tmpContract.ContractId_child      = vbContractId
          AND tmpContract.PaidKindId_byBase     = vbPaidKindId
       --AND tmpContractGroup.InfoMoneyId_child = 
       ;


     -- сохранили свойство <Договор(начисление)>
     PERFORM lpInsertUpdate_MovementItem_Sale_Detail (ioId                      := 0 :: Integer
                                                    , inMovementId              := inMovementId
                                                    , inContractId_bonus        := _tmpBonus.ContractId_bonus
                                                    , inContractId              := _tmpBonus.ContractId
                                                    , inContractConditionKindId := _tmpBonus.ContractConditionKindId
                                                    , inBonusKindId             := _tmpBonus.BonusKindId
                                                    , inPaidKindId              := _tmpBonus.PaidKindId
                                                    , inInfoMoneyId             := _tmpBonus.InfoMoneyId
                                                    , inBonusValue              := _tmpBonus.BonusValue
                                                    , inUserId                  := vbUserId
                                                     )
     FROM _tmpBonus
    ;

     END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.26                                        *
*/

-- тест
-- SELECT * FROM gpComplete_Movement_Recalc_commerc (inMovementId:= 34407362, inMovementDescId:= zc_Movement_ReturnIn(), inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpComplete_Movement_Recalc_commerc (inMovementId:= 34334385, inMovementDescId:= zc_Movement_Sale(), inSession:= zfCalc_UserAdmin())
