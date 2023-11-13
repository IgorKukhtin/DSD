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
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime
             , MovementItemId Integer, GoodsId Integer, GoodsKindId Integer

               -- цена расчетная в грн - с учетом курса и округления
             , ValuePrice TFloat
               -- миним расчетная цена в грн - с учетом курса и округления
             , ValuePrice_from TFloat
               -- макс расчетная цена в грн - с учетом курса и округления
             , ValuePrice_to TFloat
               -- цена Спецификации в CurrencyId
             , ValuePrice_orig TFloat
               -- Коэфф перевода из кол-ва поставщика
             , CountForAmount TFloat
               -- Разрешенный % отклонение для цены
             , DiffPrice TFloat
               -- Кол-во знаков для округления
             , RoundPrice TFloat
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
                                      FROM Movement
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
                                         -- № п/п
                                       , ROW_NUMBER() OVER (PARTITION BY MILinkObject_Currency.ObjectId, MILinkObject_PaidKind.ObjectId ORDER BY tmpCurrencyList_all.OperDate DESC) AS Ord
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
                               , MLO_Contract.ObjectId                          AS ContractId
                               , ObjectLink_Contract_Juridical.ChildObjectId    AS JuridicalId
                               , MLO_Currency.ObjectId                          AS CurrencyId
                               , ObjectLink_Contract_PaidKind.ChildObjectId     AS PaidKindId

                               , MovementItem.Id                                AS MovementItemId
                               , MovementItem.ObjectId                          AS GoodsId
                               , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                                 --
                               , COALESCE (MIF_Price.ValueData, 0)  * CASE WHEN COALESCE (MLO_Currency.ObjectId, 0) IN (0, zc_Enum_Currency_Basis()) THEN 1
                                                                           WHEN tmpCurrencyList.CurrencyValue > 0 AND tmpCurrencyList.ParValue > 0 THEN tmpCurrencyList.CurrencyValue / tmpCurrencyList.ParValue
                                                                           WHEN tmpCurrencyList.CurrencyValue > 0 THEN tmpCurrencyList.CurrencyValue
                                                                           ELSE 0
                                                                      END       AS ValuePrice
                                 --
                               , COALESCE (MIF_Price.ValueData, 0)              AS ValuePrice_orig
                                 -- Коэфф перевода из кол-ва поставщика
                               , CASE WHEN MIF_CountForAmount.ValueData > 0 THEN MIF_CountForAmount.ValueData ELSE 1 END AS CountForAmount
                                 -- Разрешенный % отклонение для цены
                               , COALESCE (MFloat_DiffPrice.ValueData, 0)       AS DiffPrice
                               -- Кол-во знаков для округления
                               , COALESCE (MFloat_RoundPrice.ValueData, 0)      AS RoundPrice
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
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                               LEFT JOIN MovementItemFloat AS MIF_Price
                                                           ON MIF_Price.MovementItemId = MovementItem.Id
                                                          AND MIF_Price.DescId         = zc_MIFloat_Price()
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
                                                        AND tmpCurrencyList.Ord        = 1

                          WHERE Movement.OperDate BETWEEN DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '24 MONTH') AND inOperDate
                            AND Movement.DescId    = zc_Movement_ContractGoods()
                            AND Movement.StatusId  = zc_Enum_Status_Complete()
                            AND (ObjectLink_Contract_Juridical.ChildObjectId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                         )
         -- Результат
         SELECT tmpData.MovementId
              , tmpData.InvNumber
              , tmpData.OperDate
              , tmpData.MovementItemId
              , tmpData.GoodsId
              , tmpData.GoodsKindId
              , (CASE WHEN COALESCE (tmpData.CurrencyId, 0) IN (0, zc_Enum_Currency_Basis())
                           THEN tmpData.ValuePrice
                      WHEN tmpData.RoundPrice = 1
                           THEN CAST (tmpData.ValuePrice AS NUMERIC (16, 1))
                      WHEN tmpData.RoundPrice = 2 OR tmpData.RoundPrice = 0
                           THEN CAST (tmpData.ValuePrice AS NUMERIC (16, 2))
                      WHEN tmpData.RoundPrice = 3
                           THEN CAST (tmpData.ValuePrice AS NUMERIC (16, 3))
                      ELSE CAST (tmpData.ValuePrice AS NUMERIC (16, 4))
                 END) :: TFloat AS ValuePrice
                 
              , ((1 - tmpData.DiffPrice :: TFloat / 100)
               * CASE WHEN COALESCE (tmpData.CurrencyId, 0) IN (0, zc_Enum_Currency_Basis())
                           THEN tmpData.ValuePrice
                      WHEN tmpData.RoundPrice = 1
                           THEN CAST (tmpData.ValuePrice AS NUMERIC (16, 1))
                      WHEN tmpData.RoundPrice = 2 OR tmpData.RoundPrice = 0
                           THEN CAST (tmpData.ValuePrice AS NUMERIC (16, 2))
                      WHEN tmpData.RoundPrice = 3
                           THEN CAST (tmpData.ValuePrice AS NUMERIC (16, 3))
                      ELSE CAST (tmpData.ValuePrice AS NUMERIC (16, 4))
                 END) :: TFloat AS ValuePrice_from
              , ((1 + tmpData.DiffPrice :: TFloat / 100)
               * CASE WHEN COALESCE (tmpData.CurrencyId, 0) IN (0, zc_Enum_Currency_Basis())
                           THEN tmpData.ValuePrice
                      WHEN tmpData.RoundPrice = 1
                           THEN CAST (tmpData.ValuePrice AS NUMERIC (16, 1))
                      WHEN tmpData.RoundPrice = 2 OR tmpData.RoundPrice = 0
                           THEN CAST (tmpData.ValuePrice AS NUMERIC (16, 2))
                      WHEN tmpData.RoundPrice = 3
                           THEN CAST (tmpData.ValuePrice AS NUMERIC (16, 3))
                      ELSE CAST (tmpData.ValuePrice AS NUMERIC (16, 4))
                 END) :: TFloat AS ValuePrice_to

              , tmpData.ValuePrice_orig :: TFloat AS ValuePrice_orig

              , tmpData.CountForAmount  :: TFloat AS CountForAmount
              , tmpData.DiffPrice       :: TFloat AS DiffPrice
              , tmpData.RoundPrice      :: TFloat AS RoundPrice

              , tmpData.JuridicalId
              , Object_Juridical.ValueData AS JuridicalName
              , Object_Contract_InvNumber_View.ContractId   AS ContractId
              , Object_Contract_InvNumber_View.ContractCode AS ContractCode
              , Object_Contract_InvNumber_View.InvNumber    AS ContractName
              , tmpData.PaidKindId :: Integer AS PaidKindId
              , Object_PaidKind.ValueData     AS PaidKindName
              , tmpData.CurrencyId :: Integer AS CurrencyId
              , Object_Currency.ValueData     AS CurrencyName
              , tmpData.CurrencyValue :: TFloat
              , tmpData.ParValue      :: TFloat
         FROM tmpData
              LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
              LEFT JOIN Object_Contract_InvNumber_View ON Object_Contract_InvNumber_View.ContractId = tmpData.ContractId
              LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpData.PaidKindId
              LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = tmpData.CurrencyId
         WHERE tmpData.Ord = 1
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
-- SELECT * FROM lpGet_MovementItem_ContractGoods (inOperDate:= CURRENT_DATE, inJuridicalId:=0, inPartnerId:= 0, inContractId:= 6523523, inGoodsId:= 0, inUserId:= 5)
