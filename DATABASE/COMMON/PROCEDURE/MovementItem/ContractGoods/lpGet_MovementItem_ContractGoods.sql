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
             , ValuePrice TFloat
             , JuridicalId Integer, JuridicalName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , CurrencyId Integer, CurrencyValue TFloat, ParValue TFloat
              )
AS
$BODY$
  DECLARE vbCurrency        TFloat;
  DECLARE vbParValue        TFloat;
BEGIN

       -- Выбираем данные
       RETURN QUERY
         WITH tmpCurrencyList AS (SELECT MILinkObject_Currency.ObjectId AS CurrencyId
                                       , MovementItem.ObjectId          AS CurrencyId_value
                                       , MovementItem.Amount            AS CurrencyValue
                                       , MIFloat_ParValue.ValueData     AS ParValue
                                  FROM Movement
                                       LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                             AND MovementItem.DescId     = zc_MI_Master()
                                                             AND MovementItem.isErased   = FALSE
                                       LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                                   ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                                  AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                                        ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                                       AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                                  WHERE Movement.OperDate = inOperDate - INTERVAL '1 DAY'
                                    AND Movement.DescId   = zc_Movement_CurrencyList()
                                    AND Movement.StatusId = zc_Enum_Status_Complete()
                                 )
              -- 
            , tmpData AS (SELECT Movement.Id                                    AS MovementId
                               , Movement.InvNumber                             AS InvNumber
                               , Movement.OperDate                              AS OperDate
                               , MLO_Contract.ObjectId                          AS ContractId
                               , ObjectLink_Contract_Juridical.ChildObjectId    AS JuridicalId
                               , MLO_Currency.ObjectId                          AS CurrencyId
                                                                                
                               , MovementItem.Id                                AS MovementItemId
                               , MovementItem.ObjectId                          AS GoodsId
                               , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                               , COALESCE (MIF_Price.ValueData, 0)              AS ValuePrice
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

                          WHERE Movement.OperDate BETWEEN DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '12 MONTH') AND inOperDate
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
              , (tmpData.ValuePrice / CASE WHEN COALESCE (tmpData.CurrencyId, 0) IN (0, zc_Enum_Currency_Basis()) THEN 1
                                           WHEN tmpCurrencyList.CurrencyValue > 0 AND tmpCurrencyList.ParValue > 0 THEN tmpCurrencyList.CurrencyValue / tmpCurrencyList.ParValue
                                           WHEN tmpCurrencyList.CurrencyValue > 0 THEN tmpCurrencyList.CurrencyValue
                                           ELSE 1
                                      END) :: TFloat AS ValuePrice
              , tmpData.JuridicalId
              , Object_Juridical.ValueData AS JuridicalName
              , Object_Contract_InvNumber_View.ContractId   AS ContractId
              , Object_Contract_InvNumber_View.ContractCode AS ContractCode
              , Object_Contract_InvNumber_View.InvNumber    AS ContractName
              , tmpData.CurrencyId
              , tmpCurrencyList.CurrencyValue :: TFloat
              , tmpCurrencyList.ParValue      :: TFloat
         FROM tmpData
              LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
              LEFT JOIN Object_Contract_InvNumber_View ON Object_Contract_InvNumber_View.ContractId = tmpData.ContractId
              LEFT JOIN tmpCurrencyList ON tmpCurrencyList.CurrencyId = tmpData.CurrencyId
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
-- SELECT * FROM lpGet_MovementItem_ContractGoods (inOperDate:= CURRENT_TIMESTAMP, inJuridicalId:=0, inPartnerId:= 0, inContractId:= 992313, inGoodsId:= 0, inUserId:= 1)
