-- Function: lpGet_MovementItem_ContractGoods()

DROP FUNCTION IF EXISTS lpGet_MovementItem_ContractGoods (TDateTime, Integer, Integer);
DROP FUNCTION IF EXISTS lpGet_MovementItem_ContractGoods (TDateTime, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpGet_MovementItem_ContractGoods(
    IN inOperDate           TDateTime , -- Дата действия
    IN inJuridicalId        Integer   , --
    IN inPartnerId          Integer   , --
    IN inContractId         Integer   , --
    IN inGoodsId            Integer   , --
    IN inUserId             Integer     --
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime, isPriceWithVAT Boolean, isMultWithVAT Boolean
             , MovementItemId Integer, GoodsId Integer, GoodsCode Integer, GoodsKindId Integer

               -- Цена из спецификации в грн - с учетом курса и округления
             , ValuePrice TFloat
               -- цена БЕЗ НДС
             , ValuePrice_notVat TFloat
               -- цена с НДС
             , ValuePrice_addVat TFloat

               -- цена Спецификации - оригинал (в валюте)
             , ValuePrice_orig     TFloat
               -- Цена в ГРН - по курсу, если без НДС+кратность или без округлений
             , ValuePrice_GRN      TFloat

               -- Кол-во знаков для округления
             , RoundPrice TFloat
               -- % Скидки для цены
             , ChangePercent_price TFloat
               -- Разрешенный % отклонение для цены
             , DiffPrice TFloat
               -- Коэфф перевода из кол-ва поставщика
             , CountForAmount TFloat

               -- миним расчетная цена в грн - с учетом курса и округления
             , ValuePrice_from TFloat
               -- макс расчетная цена в грн - с учетом курса и округления
             , ValuePrice_to TFloat

               -- миним расчетная цена
             , ValuePrice_from_notVat TFloat
               -- макс расчетная цена
             , ValuePrice_to_notVat TFloat

               -- миним расчетная цена
             , ValuePrice_from_addVat TFloat
               -- макс расчетная цена
             , ValuePrice_to_addVat TFloat

               --
             , JuridicalId Integer, JuridicalName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , CurrencyId Integer, CurrencyName TVarChar
             , CurrencyValue TFloat, ParValue TFloat
              )
AS
$BODY$
  DECLARE vbCurrency        TFloat;
  DECLARE vbParValue        TFloat;
BEGIN

    -- RAISE EXCEPTION 'Ошибка.<%>   <%>    <%>    <%>', inJuridicalId, inPartnerId, inContractId, inGoodsId;

       -- Выбираем данные
       RETURN QUERY
         WITH -- Курсы валют для расчетов
              tmpCurrencyList_all AS (SELECT Movement.OperDate
                                           , Movement.Id AS MovementId
                                             -- Категория сайт
                                           , COALESCE (MLO_SiteTag.ObjectId, 0) AS SiteTagId
                                      FROM Movement
                                           LEFT JOIN MovementLinkObject AS MLO_SiteTag
                                                                        ON MLO_SiteTag.MovementId = Movement.Id
                                                                       AND MLO_SiteTag.DescId     = zc_MovementLinkObject_SiteTag()
                                      WHERE Movement.DescId   = zc_Movement_CurrencyList()
                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                                        -- на один день раньше
                                        AND Movement.OperDate < inOperDate
                                     )
            , tmpCurrencyMI AS (SELECT * FROM MovementItem WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpCurrencyList_all.MovementId FROM tmpCurrencyList_all))
            , tmpCurrencyList AS (SELECT tmpCurrencyList_all.OperDate
                                       , MILinkObject_Currency.ObjectId AS CurrencyId
                                       , MovementItem.ObjectId          AS CurrencyId_value
                                       , MovementItem.Amount            AS CurrencyValue
                                       , MIFloat_ParValue.ValueData     AS ParValue
                                       , MILinkObject_PaidKind.ObjectId AS PaidKindId
                                         -- Категория сайт
                                       , tmpCurrencyList_all.SiteTagId
                                         -- № п/п
                                       , ROW_NUMBER() OVER (PARTITION BY MILinkObject_Currency.ObjectId, MILinkObject_PaidKind.ObjectId, tmpCurrencyList_all.SiteTagId ORDER BY tmpCurrencyList_all.OperDate DESC) AS Ord
                                  FROM tmpCurrencyList_all
                                       LEFT JOIN tmpCurrencyMI AS MovementItem ON MovementItem.MovementId = tmpCurrencyList_all.MovementId
                                                             AND MovementItem.DescId     = zc_MI_Master()
                                                             AND MovementItem.isErased   = FALSE
                                       LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                                   ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                                  AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                                        ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                                       AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                                       LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                                        ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                                       AND MILinkObject_PaidKind.DescId         = zc_MILinkObject_PaidKind()

                                  WHERE tmpCurrencyList_all.OperDate < inOperDate
                                 )
              --
            , tmpData AS (SELECT Movement.Id                                    AS MovementId
                               , Movement.InvNumber                             AS InvNumber
                               , Movement.OperDate                              AS OperDate
                               , CASE WHEN inUserId=5 AND 1=0
                                           THEN FALSE
                                      ELSE COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE)
                                 END AS isPriceWithVAT

                               , COALESCE (MovementBoolean_MultWithVAT.ValueData, FALSE)  AS isMultWithVAT
                               , MLO_Contract.ObjectId                          AS ContractId
                               , ObjectLink_Contract_Juridical.ChildObjectId    AS JuridicalId
                               , MLO_Currency.ObjectId                          AS CurrencyId
                               , ObjectLink_Contract_PaidKind.ChildObjectId     AS PaidKindId
                                 -- Категория сайт
                               , COALESCE (MLO_SiteTag.ObjectId, 0)             AS SiteTagId

                               , MovementItem.Id                                AS MovementItemId
                               , MovementItem.ObjectId                          AS GoodsId
                               , Object_Goods.ObjectCode                        AS GoodsCode
                               , Object_Goods.ValueData                         AS GoodsName
                               , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId

                                 -- Цена в ГРН - по курсу
                               , CASE
                                      -- если нужна Кратность
                                      WHEN MovementBoolean_MultWithVAT.ValueData = TRUE
                                       -- + без НДС
                                       AND COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE) = FALSE
                                           -- кратно 5
                                           THEN ROUND (COALESCE (MIF_Price.ValueData, 0) / CASE WHEN MIF_CountForPrice.ValueData > 0 THEN MIF_CountForPrice.ValueData ELSE 1 END
                                                       -- % Скидки
                                                     * (1 + COALESCE (MIF_ChangePercent.ValueData, 0) / 100)
                                                       -- Курс
                                                     * CASE WHEN COALESCE (MLO_Currency.ObjectId, 0) IN (0, zc_Enum_Currency_Basis()) THEN 1
                                                            WHEN tmpCurrencyList.CurrencyValue > 0 AND tmpCurrencyList.ParValue > 0 THEN tmpCurrencyList.CurrencyValue / tmpCurrencyList.ParValue
                                                            WHEN tmpCurrencyList.CurrencyValue > 0 THEN tmpCurrencyList.CurrencyValue
                                                            ELSE 0
                                                       END / 5 * 100
                                                      ) * 5 / 100

                                      -- если только перевести по курсу - НЕТ округлений
                                      ELSE COALESCE (MIF_Price.ValueData, 0) / CASE WHEN MIF_CountForPrice.ValueData > 0 THEN MIF_CountForPrice.ValueData ELSE 1 END
                                           -- % Скидки
                                         * (1 + COALESCE (MIF_ChangePercent.ValueData, 0) / 100)
                                           -- Курс
                                         * CASE WHEN COALESCE (MLO_Currency.ObjectId, 0) IN (0, zc_Enum_Currency_Basis()) THEN 1
                                                WHEN tmpCurrencyList.CurrencyValue > 0 AND tmpCurrencyList.ParValue > 0 THEN tmpCurrencyList.CurrencyValue / tmpCurrencyList.ParValue
                                                WHEN tmpCurrencyList.CurrencyValue > 0 THEN tmpCurrencyList.CurrencyValue
                                                ELSE 0
                                           END
                                 END AS ValuePrice_GRN

                                 -- ???Цена без НДС???
                               , CASE WHEN COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE) = FALSE
                                           THEN COALESCE (MIF_Price.ValueData, 0) / CASE WHEN MIF_CountForPrice.ValueData > 0 THEN MIF_CountForPrice.ValueData ELSE 1 END
                                      -- если только перевести по курсу - НЕТ округлений
                                      ELSE CAST (COALESCE (MIF_Price.ValueData, 0) / 1.2 / CASE WHEN MIF_CountForPrice.ValueData > 0 THEN MIF_CountForPrice.ValueData ELSE 1 END AS NUMERIC (16, 4))
                                 END AS ValuePrice_orig_notVat

                                 --
                               , COALESCE (MIF_Price.ValueData, 0)              AS ValuePrice_orig
                               , COALESCE (MIF_CountForPrice.ValueData, 0)      AS CountForPrice

                                 -- % Скидки для цены
                               , COALESCE (MIF_ChangePercent.ValueData, 0)      AS ChangePercent_price

                                 -- Коэфф перевода из кол-ва поставщика
                               , CASE WHEN MIF_CountForAmount.ValueData > 0 THEN MIF_CountForAmount.ValueData ELSE 1 END AS CountForAmount
                                 -- Разрешенный % отклонение для цены
                               , COALESCE (MFloat_DiffPrice.ValueData, 0)       AS DiffPrice
                                 -- Кол-во знаков для округления
                               , CASE WHEN inUserId=5 AND 1=0
                                           THEN 4
                                      ELSE COALESCE (MFloat_RoundPrice.ValueData, 0)
                                 END AS RoundPrice
                                 --
                               , tmpCurrencyList.CurrencyValue
                               , tmpCurrencyList.ParValue
                                 -- № п/п
                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC, Movement.Id DESC) AS Ord
                          FROM Movement

                               INNER JOIN MovementLinkObject AS MLO_Contract
                                                             ON MLO_Contract.MovementId = Movement.Id
                                                            AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                                                            AND (MLO_Contract.ObjectId  = inContractId OR COALESCE (inContractId, 0) = 0)
                               LEFT JOIN MovementLinkObject AS MLO_SiteTag
                                                            ON MLO_SiteTag.MovementId = Movement.Id
                                                           AND MLO_SiteTag.DescId     = zc_MovementLinkObject_SiteTag()

                               LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                         ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                                        AND MovementBoolean_PriceWithVAT.DescId     = zc_MovementBoolean_PriceWithVAT()
                               LEFT JOIN MovementBoolean AS MovementBoolean_MultWithVAT
                                                         ON MovementBoolean_MultWithVAT.MovementId = Movement.Id
                                                        AND MovementBoolean_MultWithVAT.DescId     = zc_MovementBoolean_MultWithVAT()
                               LEFT JOIN MovementLinkObject AS MLO_Currency
                                                            ON MLO_Currency.MovementId = Movement.Id
                                                           AND MLO_Currency.DescId     = zc_MovementLinkObject_Currency()
                               LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                    ON ObjectLink_Contract_Juridical.ObjectId = MLO_Contract.ObjectId
                                                   AND ObjectLink_Contract_Juridical.DescId   = zc_ObjectLink_Contract_Juridical()
                               LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                                    ON ObjectLink_Contract_PaidKind.ObjectId = MLO_Contract.ObjectId
                                                   AND ObjectLink_Contract_PaidKind.DescId   = zc_ObjectLink_Contract_PaidKind()
                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                                                      AND (MovementItem.ObjectId  = inGoodsId OR COALESCE (inGoodsId, 0) = 0)

                               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                               LEFT JOIN MovementItemFloat AS MIF_Price
                                                           ON MIF_Price.MovementItemId = MovementItem.Id
                                                          AND MIF_Price.DescId         = zc_MIFloat_Price()
                               LEFT JOIN MovementItemFloat AS MIF_CountForPrice
                                                           ON MIF_CountForPrice.MovementItemId = MovementItem.Id
                                                          AND MIF_CountForPrice.DescId         = zc_MIFloat_CountForPrice()

                               -- % Скидки
                               LEFT JOIN MovementItemFloat AS MIF_ChangePercent
                                                           ON MIF_ChangePercent.MovementItemId = MovementItem.Id
                                                          AND MIF_ChangePercent.DescId         = zc_MIFloat_ChangePercent()

                               -- Коэфф перевода из кол-ва поставщика
                               LEFT JOIN MovementItemFloat AS MIF_CountForAmount
                                                           ON MIF_CountForAmount.MovementItemId = MovementItem.Id
                                                          AND MIF_CountForAmount.DescId         = zc_MIFloat_CountForAmount()
                               -- Разрешенный % отклонение для цены
                               LEFT JOIN MovementFloat AS MFloat_DiffPrice
                                                       ON MFloat_DiffPrice.MovementId = Movement.Id
                                                      AND MFloat_DiffPrice.DescId     = zc_MovementFloat_DiffPrice()
                               -- Кол-во знаков для округления
                               LEFT JOIN MovementFloat AS MFloat_RoundPrice
                                                       ON MFloat_RoundPrice.MovementId = Movement.Id
                                                      AND MFloat_RoundPrice.DescId     = zc_MovementFloat_RoundPrice()

                               LEFT JOIN tmpCurrencyList ON tmpCurrencyList.CurrencyId = MLO_Currency.ObjectId
                                                        AND tmpCurrencyList.PaidKindId = ObjectLink_Contract_PaidKind.ChildObjectId
                                                        AND tmpCurrencyList.SiteTagId  = COALESCE (MLO_SiteTag.ObjectId, 0)
                                                        AND tmpCurrencyList.Ord        = 1

                          WHERE Movement.OperDate BETWEEN DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '36 MONTH') AND inOperDate
                            AND Movement.DescId    = zc_Movement_ContractGoods()
                            AND Movement.StatusId  = zc_Enum_Status_Complete()
                            AND (ObjectLink_Contract_Juridical.ChildObjectId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                         )
         -- Результат
         SELECT tmpData.MovementId
              , tmpData.InvNumber
              , tmpData.OperDate
              , tmpData.isPriceWithVAT
              , tmpData.isMultWithVAT
              , tmpData.MovementItemId
              , tmpData.GoodsId
              , tmpData.GoodsCode
              , tmpData.GoodsKindId

                -- Цена из спецификации
              , CASE WHEN tmpData.isPriceWithVAT = FALSE
                          THEN tmpData.ValuePrice_notVat
                     WHEN tmpData.isPriceWithVAT = TRUE
                          THEN tmpData.ValuePrice_addVat
                     ELSE tmpData.ValuePrice
                END :: TFloat
                -- цена БЕЗ НДС / 1.2
              , tmpData.ValuePrice_notVat :: TFloat AS ValuePrice_notVat
                -- цена с НДС * 1.2
              , tmpData.ValuePrice_addVat :: TFloat AS ValuePrice_addVat

                -- Цена из спецификации - оригинал (в валюте)
              , tmpData.ValuePrice_orig :: TFloat
                -- Цена в ГРН - по курсу, если без НДС+кратность или без округлений
              , tmpData.ValuePrice_GRN  :: TFloat

               -- Кол-во знаков для округления
              , tmpData.RoundPrice          :: TFloat
               -- % Скидки для цены
              , tmpData.ChangePercent_price :: TFloat
                -- Разрешенный % отклонение для цены
              , tmpData.DiffPrice           :: TFloat
                -- Коэфф перевода из кол-ва поставщика
              , tmpData.CountForAmount      :: TFloat

                -- Цена из спецификации - от
              , (CASE WHEN tmpData.isPriceWithVAT = FALSE
                          THEN tmpData.ValuePrice_notVat
                     WHEN tmpData.isPriceWithVAT = TRUE
                          THEN tmpData.ValuePrice_addVat
                     ELSE tmpData.ValuePrice
                 END * (1 - tmpData.DiffPrice / 100)) :: TFloat
                -- Цена из спецификации - до
              , (CASE WHEN tmpData.isPriceWithVAT = FALSE
                          THEN tmpData.ValuePrice_notVat
                     WHEN tmpData.isPriceWithVAT = TRUE
                          THEN tmpData.ValuePrice_addVat
                     ELSE tmpData.ValuePrice
                 END * (1 + tmpData.DiffPrice / 100)) :: TFloat

                -- БЕЗ НДС миним расчетная цена
              , (tmpData.ValuePrice_notVat * (1 - tmpData.DiffPrice / 100)) :: TFloat AS ValuePrice_from_notVat
                -- БЕЗ НДС макс расчетная цена
              , (tmpData.ValuePrice_notVat * (1 + tmpData.DiffPrice / 100)) :: TFloat AS ValuePrice_to_notVat

                -- с НДС миним расчетная цена
              , (tmpData.ValuePrice_addVat * (1 - tmpData.DiffPrice / 100)) :: TFloat AS ValuePrice_from_addVat
                -- с НДС макс расчетная цена
              , (tmpData.ValuePrice_addVat * (1 + tmpData.DiffPrice / 100)) :: TFloat AS ValuePrice_to_addVat

              , tmpData.JuridicalId                         AS JuridicalId
              , Object_Juridical.ValueData                  AS JuridicalName
              , tmpData.ContractId                          AS ContractId
              , Object_Contract_InvNumber_View.ContractCode AS ContractCode
              , Object_Contract_InvNumber_View.InvNumber    AS ContractName
              , tmpData.PaidKindId                          AS PaidKindId
              , Object_PaidKind.ValueData                   AS PaidKindName
              , tmpData.CurrencyId                          AS CurrencyId
              , Object_Currency.ValueData                   AS CurrencyName
              , tmpData.CurrencyValue
              , tmpData.ParValue


         FROM  (SELECT tmpData.MovementId
                     , tmpData.InvNumber
                     , tmpData.OperDate
                     , tmpData.isPriceWithVAT
                     , tmpData.isMultWithVAT
                     , tmpData.MovementItemId
                     , tmpData.GoodsId
                     , tmpData.GoodsCode
                     , tmpData.GoodsKindId

                       -- Цена в ГРН - по курсу, если без НДС+кратность или без округлений
                     , tmpData.ValuePrice_GRN
                     , tmpData.ValuePrice_orig  AS ValuePrice_orig

                     , tmpData.RoundPrice
                     , tmpData.ChangePercent_price
                     , tmpData.DiffPrice
                     , tmpData.CountForAmount

                       -- Цена из спецификации - в ГРН + округление (за счет курса)
                     , tmpData.ValuePrice

                       -- цена БЕЗ НДС / 1.2
                     , CASE WHEN tmpData.isPriceWithVAT = FALSE AND COALESCE (tmpData.CurrencyId, 0) IN (0, zc_Enum_Currency_Basis())
                                 -- уже без НДС, ничего не делаем
                                 THEN tmpData.ValuePrice

                            -- уже без НДС
                            WHEN tmpData.isPriceWithVAT = FALSE
                                 THEN tmpData.ValuePrice

                            -- считаем без НДС + кратность
                            WHEN tmpData.RoundPrice = 0 AND tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 1) * 5 / 1

                            WHEN tmpData.RoundPrice = 1 AND tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 10) * 5 / 10

                            WHEN tmpData.RoundPrice = 2 AND tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 100) * 5 / 100

                            WHEN tmpData.RoundPrice = 3 AND tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 1000) * 5 / 1000

                            WHEN tmpData.RoundPrice = 4 AND tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 10000) * 5 / 10000

                            -- иначе 2 ЗНАКА + кратность
                            WHEN tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 100) * 5 / 100

                            -- считаем без НДС + округление
                            WHEN tmpData.RoundPrice = 1
                                 THEN CAST (tmpData.ValuePrice / 1.2 AS NUMERIC (16, 1))
                            WHEN tmpData.RoundPrice = 2 OR tmpData.RoundPrice = 0
                                 THEN CAST (tmpData.ValuePrice / 1.2 AS NUMERIC (16, 2))
                            WHEN tmpData.RoundPrice = 3
                                 THEN CAST (tmpData.ValuePrice / 1.2 AS NUMERIC (16, 3))
                            WHEN tmpData.RoundPrice = 4
                                 THEN CAST (tmpData.ValuePrice / 1.2 AS NUMERIC (16, 4))

                            -- иначе 2 ЗНАКА
                            ELSE CAST (tmpData.ValuePrice / 1.2 AS NUMERIC (16, 2))

                       END :: TFloat AS ValuePrice_notVat

                       -- цена с НДС * 1.2
                     , CASE WHEN tmpData.isPriceWithVAT = TRUE AND COALESCE (tmpData.CurrencyId, 0) IN (0, zc_Enum_Currency_Basis())
                                 -- уже с НДС, ничего не делаем
                                 THEN tmpData.ValuePrice

                            -- считаем без НДС + кратность + с НДС
                            WHEN tmpData.RoundPrice = 0 AND tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 1) * 5 / 1 * 1.2

                            -- считаем без НДС + кратность + с НДС
                            WHEN tmpData.RoundPrice = 1 AND tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 10) * 5 / 10 * 1.2

                            -- считаем без НДС + кратность + с НДС
                            WHEN tmpData.RoundPrice = 2 AND tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 100) * 5 / 100 * 1.2

                            -- считаем без НДС + кратность + с НДС
                            WHEN tmpData.RoundPrice = 3 AND tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 1000) * 5 / 1000 * 1.2

                            -- считаем без НДС + кратность + с НДС
                            WHEN tmpData.RoundPrice = 4 AND tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 10000) * 5 / 10000 * 1.2

                            -- иначе без НДС 2 ЗНАКА + кратность + с НДС
                            WHEN tmpData.isMultWithVAT = TRUE
                                 THEN ROUND (tmpData.ValuePrice / 1.2 / 5 * 100) * 5 / 100 * 1.2

                            -- уже с НДС
                            WHEN tmpData.isPriceWithVAT = TRUE
                                 THEN tmpData.ValuePrice

                            -- считаем с НДС + округление
                            WHEN tmpData.RoundPrice = 1
                                 THEN CAST (tmpData.ValuePrice * 1.2 AS NUMERIC (16, 1))
                            WHEN tmpData.RoundPrice = 2 OR tmpData.RoundPrice = 0
                                 THEN CAST (tmpData.ValuePrice * 1.2 AS NUMERIC (16, 2))
                            WHEN tmpData.RoundPrice = 3
                                 THEN CAST (tmpData.ValuePrice * 1.2 AS NUMERIC (16, 3))
                            WHEN tmpData.RoundPrice = 4
                                 THEN CAST (tmpData.ValuePrice * 1.2 AS NUMERIC (16, 4))

                            ELSE CAST (tmpData.ValuePrice * 1.2 AS NUMERIC (16, 2))

                       END :: TFloat AS ValuePrice_addVat

                     , tmpData.JuridicalId
                     , tmpData.ContractId
                     , tmpData.PaidKindId
                     , tmpData.CurrencyId
                     , tmpData.CurrencyValue
                     , tmpData.ParValue

                FROM
               (SELECT tmpData.MovementId
                     , tmpData.InvNumber
                     , tmpData.OperDate
                     , tmpData.isPriceWithVAT
                     , tmpData.isMultWithVAT
                     , tmpData.MovementItemId
                     , tmpData.GoodsId
                     , tmpData.GoodsCode
                     , tmpData.GoodsKindId
                       -- Цена в ГРН - по курсу, если без НДС+кратность или без округлений
                     , tmpData.ValuePrice_GRN

                       -- Цена из спецификации - в ГРН + округление (за счет курса)
                     , (CASE WHEN COALESCE (tmpData.CurrencyId, 0) IN (0, zc_Enum_Currency_Basis())
                                  -- без округления
                                  THEN tmpData.ValuePrice_GRN

                             -- если кратность
                             WHEN tmpData.isMultWithVAT = TRUE
                                  -- без округления
                                  THEN tmpData.ValuePrice_GRN

                             WHEN tmpData.RoundPrice = 1
                                  -- округление
                                  THEN CAST (tmpData.ValuePrice_GRN AS NUMERIC (16, 1))
                             WHEN tmpData.RoundPrice = 2 OR tmpData.RoundPrice = 0
                                  -- округление
                                  THEN CAST (tmpData.ValuePrice_GRN AS NUMERIC (16, 2))
                             WHEN tmpData.RoundPrice = 3
                                  -- округление
                                  THEN CAST (tmpData.ValuePrice_GRN AS NUMERIC (16, 3))
                             WHEN tmpData.RoundPrice = 4
                                  -- округление
                                  THEN CAST (tmpData.ValuePrice_GRN AS NUMERIC (16, 4))

                             -- округление
                             ELSE CAST (tmpData.ValuePrice_GRN AS NUMERIC (16, 2))

                        END) AS ValuePrice


                     , tmpData.ValuePrice_orig  AS ValuePrice_orig

                     , tmpData.RoundPrice
                     , tmpData.ChangePercent_price
                     , tmpData.DiffPrice
                     , tmpData.CountForAmount

                     , tmpData.JuridicalId
                     , tmpData.ContractId
                     , tmpData.PaidKindId
                     , tmpData.CurrencyId
                     , tmpData.CurrencyValue
                     , tmpData.ParValue

                FROM tmpData

                WHERE tmpData.Ord = 1
               ) AS tmpData

               ) AS tmpData

               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
               LEFT JOIN Object_Contract_InvNumber_View ON Object_Contract_InvNumber_View.ContractId = tmpData.ContractId
               LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpData.PaidKindId
               LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = tmpData.CurrencyId
              ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.04.22                                        *
*/

-- тест
-- SELECT * FROM lpGet_MovementItem_ContractGoods (inOperDate:= '22.11.2024', inJuridicalId:=0, inPartnerId:= 0, inContractId:= 10485535, inGoodsId:= 0, inUserId:= 5)
