-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MI_ReturnIn_Child (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_MI_ReturnIn_Child(
    IN inId             Integer  , -- ключ
    IN inMovementId     Integer  , --
    IN inSession        TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , CurrencyValue_USD TFloat, ParValue_USD TFloat
             , CurrencyValue_EUR TFloat, ParValue_EUR TFloat
             , AmountGRN      TFloat
             , AmountUSD      TFloat
             , AmountEUR      TFloat
             , AmountCard     TFloat
             , Amount         TFloat
             , AmountRemains  TFloat
             , AmountChange   TFloat
             , isPayTotal     Boolean
             , isGRN          Boolean
             , isUSD          Boolean
             , isEUR          Boolean
             , isCard         Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbSumm TFloat;
   DECLARE vbSummChangePercent TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     
     SELECT Movement.OperDate 
    INTO vbOperDate
     FROM Movement
     WHERE Movement.Id = inMovementId;
     -- сумма к оплате
     SELECT CAST ( SUM (COALESCE(MovementItem.Amount,0) *  COALESCE(MIFloat_OperPriceList.ValueData,0) / COALESCE(MIFloat_CountForPrice.ValueData,1) 
                 - COALESCE(MIFloat_TotalChangePercent.ValueData,0)) AS NUMERIC (16, 2)) 
    INTO vbSumm
     FROM MovementItem
          LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                      ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                     AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()
          LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                      ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                     AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
          LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                      ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                     AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
     WHERE (MovementItem.Id = inId OR inId = 0)
       AND MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
       AND MovementItem.isErased   = FALSE;

     IF COALESCE (inId, 0) = 0    -- вариант оплата итого
     THEN
         -- Результат
         RETURN QUERY 
         WITH tmpMI AS 
                     (SELECT SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN() THEN COALESCE(MovementItem.Amount,0) ELSE 0 END) AS AmountGRN
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN COALESCE(MovementItem.Amount,0) ELSE 0 END) AS AmountUSD
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN COALESCE(MovementItem.Amount,0) ELSE 0 END) AS AmountEUR
                           , SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() THEN MovementItem.Amount ELSE 0 END) AS AmountCard
                      FROM MovementItem
                            LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                             ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Child()
                        AND MovementItem.isErased   = FALSE
                     )

          SELECT 0                       :: Integer  AS Id
               , tmp_USD.Amount          ::TFloat    AS CurrencyValue_USD
               , tmp_USD.ParValue        ::TFloat    AS ParValue_USD
               , tmp_EUR.Amount          ::TFloat    AS CurrencyValue_EUR
               , tmp_EUR.ParValue        ::TFloat    AS ParValue_EUR
               , tmpMI.AmountGRN         ::TFloat
               , tmpMI.AmountUSD         ::TFloat
               , tmpMI.AmountEUR         ::TFloat
               , tmpMI.AmountCard        ::TFloat

               /*, ( COALESCE (tmpMI.AmountGRN,0) 
               +  (COALESCE(tmpMI.AmountUSD,0) * COALESCE(tmp_USD.Amount,0))
               +  (COALESCE(tmpMI.AmountEUR,0) * COALESCE(tmp_EUR.Amount,0)) 
               +  COALESCE(tmpMI.AmountCard,0) )                            ::TFloat AS Amount*/
               , vbSumm                  ::TFloat    AS Amount

               , CASE WHEN vbSumm - ( COALESCE (tmpMI.AmountGRN,0) 
                                    + (COALESCE(tmpMI.AmountUSD,0) * COALESCE(tmp_USD.Amount,0))
                                    + (COALESCE(tmpMI.AmountEUR,0) * COALESCE(tmp_EUR.Amount,0)) 
                                    + COALESCE(tmpMI.AmountCard,0)) > 0 
                      THEN vbSumm - ( COALESCE (tmpMI.AmountGRN,0) 
                                    + (COALESCE(tmpMI.AmountUSD,0) * COALESCE(tmp_USD.Amount,0))
                                    + (COALESCE(tmpMI.AmountEUR,0) * COALESCE(tmp_EUR.Amount,0)) 
                                    + COALESCE(tmpMI.AmountCard,0))
                      ELSE 0
                 END            ::TFloat AS AmountRemains          
               , CASE WHEN vbSumm - ( COALESCE (tmpMI.AmountGRN,0) 
                                    + (COALESCE(tmpMI.AmountUSD,0) * COALESCE(tmp_USD.Amount,0))
                                    + (COALESCE(tmpMI.AmountEUR,0) * COALESCE(tmp_EUR.Amount,0)) 
                                    + COALESCE(tmpMI.AmountCard,0) ) < 0 
                      THEN (vbSumm - ( COALESCE (tmpMI.AmountGRN,0) 
                                    + (COALESCE(tmpMI.AmountUSD,0) * COALESCE(tmp_USD.Amount,0))
                                    + (COALESCE(tmpMI.AmountEUR,0) * COALESCE(tmp_EUR.Amount,0)) 
                                    + COALESCE(tmpMI.AmountCard,0) )) * (-1)
                      ELSE 0
                 END             ::TFloat AS AmountChange

               , TRUE AS isPayTotal
               , CASE WHEN COALESCE (tmpMI.AmountGRN,0) <> 0 THEN TRUE ELSE FALSE END     AS isGRN
               , CASE WHEN COALESCE (tmpMI.AmountUSD,0) <> 0 THEN TRUE ELSE FALSE END     AS isUSD
               , CASE WHEN COALESCE (tmpMI.AmountEUR,0) <> 0 THEN TRUE ELSE FALSE END     AS isEUR
               , CASE WHEN COALESCE (tmpMI.AmountCard,0) <> 0 THEN TRUE ELSE FALSE END    AS isCard

           FROM tmpMI
               LEFT JOIN lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= zc_Currency_USD()) AS tmp_USD ON 1=1
               LEFT JOIN lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= zc_Currency_EUR()) AS tmp_EUR ON 1=1
                ;

     ELSE
         -- Результат
         RETURN QUERY
           WITH tmpMI AS 
                     (SELECT SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN() THEN COALESCE(MovementItem.Amount,0) ELSE 0 END) AS AmountGRN
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN COALESCE(MovementItem.Amount,0) ELSE 0 END) AS AmountUSD
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN COALESCE(MovementItem.Amount,0) ELSE 0 END) AS AmountEUR
                           , SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() THEN MovementItem.Amount ELSE 0 END) AS AmountCard
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN COALESCE(MIFloat_CurrencyValue.ValueData,0) ELSE 0 END) AS CurrencyValue_USD
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN COALESCE(MIFloat_CurrencyValue.ValueData,0) ELSE 0 END) AS CurrencyValue_EUR
                      FROM MovementItem
                            LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                             ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()
                            LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                        ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()    
                            LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                        ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue() 
                      WHERE MovementItem.ParentId     = inId
                        AND MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Child()
                        AND MovementItem.isErased   = FALSE
                      )
           -- Результат
           SELECT
                 inId AS Id
               , COALESCE (tmpMI.CurrencyValue_USD, tmp_USD.Amount)      ::TFloat    AS CurrencyValue_USD
               , tmp_USD.ParValue    ::TFloat    AS ParValue_USD
               , COALESCE (tmpMI.CurrencyValue_EUR, tmp_EUR.Amount)      ::TFloat    AS CurrencyValue_EUR
               , tmp_EUR.ParValue    ::TFloat    AS ParValue_EUR

               , tmpMI.AmountGRN         ::TFloat
               , tmpMI.AmountUSD         ::TFloat
               , tmpMI.AmountEUR         ::TFloat
               , tmpMI.AmountCard        ::TFloat

               /*, ( COALESCE (tmpMI.AmountGRN,0) 
               +  (COALESCE (tmpMI.AmountUSD,0) * COALESCE (tmpMI.CurrencyValue_USD, tmp_USD.Amount))
               +  (COALESCE (tmpMI.AmountEUR,0) * COALESCE (tmpMI.CurrencyValue_EUR, tmp_EUR.Amount)) 
               +   COALESCE (tmpMI.AmountCard,0) )                            ::TFloat AS Amount*/
               , vbSumm                  ::TFloat    AS Amount

               , CASE WHEN vbSumm - (  COALESCE(tmpMI.AmountGRN,0) 
                                    + (COALESCE(tmpMI.AmountUSD,0) * COALESCE (tmpMI.CurrencyValue_USD, tmp_USD.Amount))
                                    + (COALESCE(tmpMI.AmountEUR,0) * COALESCE (tmpMI.CurrencyValue_EUR, tmp_EUR.Amount)) 
                                    +  COALESCE(tmpMI.AmountCard,0)) > 0 
                      THEN vbSumm - ( COALESCE (tmpMI.AmountGRN,0) 
                                    + (COALESCE(tmpMI.AmountUSD,0) * COALESCE (tmpMI.CurrencyValue_USD, tmp_USD.Amount))
                                    + (COALESCE(tmpMI.AmountEUR,0) * COALESCE (tmpMI.CurrencyValue_EUR, tmp_EUR.Amount)) 
                                    +  COALESCE(tmpMI.AmountCard,0) )
                      ELSE 0
                 END            ::TFloat AS AmountRemains          
               , CASE WHEN vbSumm - ( COALESCE (tmpMI.AmountGRN,0) 
                                    + (COALESCE(tmpMI.AmountUSD,0) * COALESCE (tmpMI.CurrencyValue_USD, tmp_USD.Amount))
                                    + (COALESCE(tmpMI.AmountEUR,0) * COALESCE (tmpMI.CurrencyValue_EUR, tmp_EUR.Amount)) 
                                    + COALESCE (tmpMI.AmountCard,0) ) < 0 
                      THEN (vbSumm - ( COALESCE(tmpMI.AmountGRN,0) 
                                    + (COALESCE(tmpMI.AmountUSD,0) * COALESCE (tmpMI.CurrencyValue_USD, tmp_USD.Amount))
                                    + (COALESCE(tmpMI.AmountEUR,0) * COALESCE (tmpMI.CurrencyValue_EUR, tmp_EUR.Amount)) 
                                    +  COALESCE(tmpMI.AmountCard,0) )) * (-1)
                      ELSE 0
                 END             ::TFloat AS AmountChange

               , False AS isPayTotal
               , CASE WHEN COALESCE (tmpMI.AmountGRN,0) <> 0 THEN TRUE ELSE FALSE END     AS isGRN
               , CASE WHEN COALESCE (tmpMI.AmountUSD,0) <> 0 THEN TRUE ELSE FALSE END     AS isUSD
               , CASE WHEN COALESCE (tmpMI.AmountEUR,0) <> 0 THEN TRUE ELSE FALSE END     AS isEUR
               , CASE WHEN COALESCE (tmpMI.AmountCard,0) <> 0 THEN TRUE ELSE FALSE END    AS isCard

           FROM tmpMI
                LEFT JOIN lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= zc_Currency_USD()) AS tmp_USD ON 1=1
                LEFT JOIN lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= zc_Currency_EUR()) AS tmp_EUR ON 1=1
               ;

    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 15.05.17         *
*/

-- тест
-- SELECT * FROM gpGet_MI_ReturnIn_Child (inId := 92 , inMovementId := 28 ,  inSession := '2');