-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child(
    IN inId             Integer  , -- ключ
    IN inMovementId     Integer  , --
    IN inSession        TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , CurrencyValue_DOL TFloat, ParValue_DOL TFloat
             , CurrencyValue_EUR TFloat, ParValue_EUR TFloat
             , AmountGRN     TFloat
             , AmountDOL     TFloat
             , AmountEUR     TFloat
             , AmountCard    TFloat
             , Amount        TFloat
             , AmountRemains TFloat
             , AmountChange TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbSumm TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     
     SELECT Movement.OperDate 
    INTO vbOperDate
     FROM Movement
     WHERE Movement.Id = inMovementId;

     SELECT CAST (COALESCE(MovementItem.Amount,0) *  COALESCE(MIFloat_OperPriceList.ValueData,0) / COALESCE(MIFloat_CountForPrice.ValueData,1) AS NUMERIC (16, 2)) 
    INTO vbSumm
     FROM MovementItem
          LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                      ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                     AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()
          LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                      ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                     AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
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
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_DOL() THEN COALESCE(MovementItem.Amount,0) ELSE 0 END) AS AmountDOL          
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

          SELECT 0 :: Integer                    AS Id
               , tmp_DOL.Amount   ::TFloat       AS CurrencyValue_DOL
               , tmp_DOL.ParValue ::TFloat       AS ParValue_DOL
               , tmp_EUR.Amount   ::TFloat       AS CurrencyValue_EUR
               , tmp_EUR.ParValue ::TFloat       AS ParValue_EUR
               , tmpMI.AmountGRN         ::TFloat
               , tmpMI.AmountDOL         ::TFloat
               , tmpMI.AmountEUR         ::TFloat
               , tmpMI.AmountCard        ::TFloat

               , ( COALESCE (tmpMI.AmountGRN,0) 
               +  (COALESCE(tmpMI.AmountDOL,0) * COALESCE(tmp_DOL.Amount,0))
               +  (COALESCE(tmpMI.AmountEUR,0) * COALESCE(tmp_EUR.Amount,0)) 
               +  COALESCE(tmpMI.AmountCard,0) )                            ::TFloat AS Amount

               , CASE WHEN vbSumm - ( COALESCE (tmpMI.AmountGRN,0) 
                                    + (COALESCE(tmpMI.AmountDOL,0) * COALESCE(tmp_DOL.Amount,0))
                                    + (COALESCE(tmpMI.AmountEUR,0) * COALESCE(tmp_EUR.Amount,0)) 
                                    + COALESCE(tmpMI.AmountCard,0) ) > 0 
                      THEN vbSumm - ( COALESCE (tmpMI.AmountGRN,0) 
                                    + (COALESCE(tmpMI.AmountDOL,0) * COALESCE(tmp_DOL.Amount,0))
                                    + (COALESCE(tmpMI.AmountEUR,0) * COALESCE(tmp_EUR.Amount,0)) 
                                    + COALESCE(tmpMI.AmountCard,0) )
                      ELSE 0
                 END            ::TFloat AS AmountRemains          
               , CASE WHEN vbSumm - ( COALESCE (tmpMI.AmountGRN,0) 
                                    + (COALESCE(tmpMI.AmountDOL,0) * COALESCE(tmp_DOL.Amount,0))
                                    + (COALESCE(tmpMI.AmountEUR,0) * COALESCE(tmp_EUR.Amount,0)) 
                                    + COALESCE(tmpMI.AmountCard,0) ) < 0 
                      THEN (vbSumm - ( COALESCE (tmpMI.AmountGRN,0) 
                                    + (COALESCE(tmpMI.AmountDOL,0) * COALESCE(tmp_DOL.Amount,0))
                                    + (COALESCE(tmpMI.AmountEUR,0) * COALESCE(tmp_EUR.Amount,0)) 
                                    + COALESCE(tmpMI.AmountCard,0) )) * (-1)
                      ELSE 0
                 END             ::TFloat AS AmountChange

           FROM tmpMI
               LEFT JOIN lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= zc_Currency_DOL()) AS tmp_DOL ON 1=1
               LEFT JOIN lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= zc_Currency_EUR()) AS tmp_EUR ON 1=1
                ;

     ELSE
         -- Результат
         RETURN QUERY
           WITH tmpMI AS 
                     (SELECT SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN() THEN COALESCE(MovementItem.Amount,0) ELSE 0 END) AS AmountGRN
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_DOL() THEN COALESCE(MovementItem.Amount,0) ELSE 0 END) AS AmountDOL          
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN COALESCE(MovementItem.Amount,0) ELSE 0 END) AS AmountEUR
                           , SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() THEN MovementItem.Amount ELSE 0 END) AS AmountCard
                      FROM MovementItem
                            LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                             ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()
                      WHERE MovementItem.ParentId     = inId
                        AND MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Child()
                        AND MovementItem.isErased   = FALSE
                      )
           -- Результат
           SELECT
                 inId AS Id
               , tmp_DOL.Amount      ::TFloat    AS CurrencyValue_DOL
               , tmp_DOL.ParValue    ::TFloat    AS ParValue_DOL
               , tmp_EUR.Amount      ::TFloat    AS CurrencyValue_EUR
               , tmp_EUR.ParValue    ::TFloat    AS ParValue_EUR

               , tmpMI.AmountGRN         ::TFloat
               , tmpMI.AmountDOL         ::TFloat
               , tmpMI.AmountEUR         ::TFloat
               , tmpMI.AmountCard        ::TFloat

               , ( COALESCE (tmpMI.AmountGRN,0) 
               +  (COALESCE(tmpMI.AmountDOL,0) * COALESCE(tmp_DOL.Amount,0))
               +  (COALESCE(tmpMI.AmountEUR,0) * COALESCE(tmp_EUR.Amount,0)) 
               +  COALESCE(tmpMI.AmountCard,0) )                            ::TFloat AS Amount

               , CASE WHEN vbSumm - ( COALESCE (tmpMI.AmountGRN,0) 
                                    + (COALESCE(tmpMI.AmountDOL,0) * COALESCE(tmp_DOL.Amount,0))
                                    + (COALESCE(tmpMI.AmountEUR,0) * COALESCE(tmp_EUR.Amount,0)) 
                                    + COALESCE(tmpMI.AmountCard,0) ) > 0 
                      THEN vbSumm - ( COALESCE (tmpMI.AmountGRN,0) 
                                    + (COALESCE(tmpMI.AmountDOL,0) * COALESCE(tmp_DOL.Amount,0))
                                    + (COALESCE(tmpMI.AmountEUR,0) * COALESCE(tmp_EUR.Amount,0)) 
                                    + COALESCE(tmpMI.AmountCard,0) )
                      ELSE 0
                 END            ::TFloat AS AmountRemains          
               , CASE WHEN vbSumm - ( COALESCE (tmpMI.AmountGRN,0) 
                                    + (COALESCE(tmpMI.AmountDOL,0) * COALESCE(tmp_DOL.Amount,0))
                                    + (COALESCE(tmpMI.AmountEUR,0) * COALESCE(tmp_EUR.Amount,0)) 
                                    + COALESCE(tmpMI.AmountCard,0) ) < 0 
                      THEN (vbSumm - ( COALESCE (tmpMI.AmountGRN,0) 
                                    + (COALESCE(tmpMI.AmountDOL,0) * COALESCE(tmp_DOL.Amount,0))
                                    + (COALESCE(tmpMI.AmountEUR,0) * COALESCE(tmp_EUR.Amount,0)) 
                                    + COALESCE(tmpMI.AmountCard,0) )) * (-1)
                      ELSE 0
                 END             ::TFloat AS AmountChange

           FROM tmpMI
                LEFT JOIN lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= zc_Currency_DOL()) AS tmp_DOL ON 1=1
                LEFT JOIN lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= zc_Currency_EUR()) AS tmp_EUR ON 1=1
               ;

    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 10.04.17         *
*/

-- тест
-- SELECT * FROM gpGet_MI_Sale_Child (inId:= 1, inSession:= '9818')