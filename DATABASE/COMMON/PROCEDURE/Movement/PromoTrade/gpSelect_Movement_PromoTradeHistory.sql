
-- Function: gpSelect_Movement_PromoTradeHistory()

DROP FUNCTION IF EXISTS gpSelect_Movement_PromoTradeHistory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PromoTradeHistory(
    IN inMovementId    Integer , -- Ключ документа <Акция>
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Ord              Integer
             , Name             TVarChar    --имя параметра
             , Value            TFloat      --значение параметра
             , Value_2          TFloat      --значение параметра
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId_PromoTradeHistory Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

 /*
  select sum(zc_MI_Master.zc_MIFloat_AmountSale)
  union select sum(zc_MI_Master.zc_MIFloat_AmountReturnIn)
  union select % возврата- расчет
  union select zc_MovementFloat_DebtDay
  union select zc_MovementFloat_DebtSumm

      , AmountSale         TFloat -- Объем продаж (статистика за 3м.)
      , SummSale           TFloat --
      , AmountReturnIn     TFloat -- Объем возвраты  даж (статистика за 3м.)

 */

    vbMovementId_PromoTradeHistory := (SELECT Movement.Id
                                       FROM Movement
                                       WHERE Movement.DescId = zc_Movement_PromoTradeHistory()
                                         AND Movement.ParentId =  inMovementId
                                       );


    -- Результат
    RETURN QUERY
    WITH
    tmpText AS (    SELECT  1 ::Integer  AS Ord, '1.Среднемесячные продажи, кг:'                    ::TVarChar AS Name
              UNION SELECT  2 ::Integer  AS Ord, '2.Среднемесячные продажи, грн:'                   ::TVarChar AS Name   --
              UNION SELECT  3 ::Integer  AS Ord, '3.% возврата:'                                    ::TVarChar AS Name
              UNION SELECT  4 ::Integer  AS Ord, '4.Просроченная дебиторская задолженность, грн:'   ::TVarChar AS Name
              UNION SELECT  5 ::Integer  AS Ord, '5.Просроченная дебиторская задолженность, дней:'  ::TVarChar AS Name
                 )
  , tmpMovement AS (SELECT SUM (COALESCE (MF_AmountSale.ValueData,0))     AS AmountSale
                         , SUM (COALESCE (MF_AmountReturnIn.ValueData,0)) AS AmountReturnIn
                         , SUM (COALESCE (MF_SummSale.ValueData,0))       AS SummSale
                         , SUM (COALESCE (MF_SummReturnIn.ValueData,0))   AS SummReturnIn
                    FROM Movement
                         LEFT JOIN MovementFloat AS MF_AmountSale
                                                 ON MF_AmountSale.MovementId = Movement.Id
                                                AND MF_AmountSale.DescId = zc_MovementFloat_AmountSale()
                         LEFT JOIN MovementFloat AS MF_SummSale
                                                 ON MF_SummSale.MovementId = Movement.Id
                                                AND MF_SummSale.DescId = zc_MovementFloat_SummSale()
                         LEFT JOIN MovementFloat AS MF_AmountReturnIn
                                                 ON MF_AmountReturnIn.MovementId = Movement.Id
                                                AND MF_AmountReturnIn.DescId = zc_MovementFloat_AmountReturnIn()
                         LEFT JOIN MovementFloat AS MF_SummReturnIn
                                                 ON MF_SummReturnIn.MovementId = Movement.Id
                                                AND MF_SummReturnIn.DescId = zc_MovementFloat_SummReturnIn()
                    WHERE Movement.Id = vbMovementId_PromoTradeHistory
                    )

    -- 1.Среднемесячные продажи, кг
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          ,  (CAST (tmpMovement.AmountSale/3 AS NUMERIC (16,1))) ::TFloat AS Value
          ,  (CAST (tmpMovement.AmountReturnIn/3 AS NUMERIC (16,1))) ::TFloat AS Value_2
    FROM tmpText
         LEFT JOIN tmpMovement ON 1=1
    WHERE tmpText.Ord = 1

   UNION
    -- 2.Среднемесячные продажи, грн
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , (CAST (tmpMovement.SummSale/3 AS NUMERIC (16,1))) ::TFloat AS Value
          , (CAST (tmpMovement.SummReturnIn/3 AS NUMERIC (16,1))) ::TFloat AS Value_2
    FROM tmpText
         LEFT JOIN tmpMovement ON 1=1
    WHERE tmpText.Ord = 2

   UNION
    -- 3.% возврата
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , (CAST (CASE WHEN COALESCE (tmpMovement.AmountSale,0) <> 0 THEN tmpMovement.AmountReturnIn * 100 / tmpMovement.AmountSale ELSE 0 END AS NUMERIC (16,1))) ::TFloat AS Value
          , 0 ::TFloat AS Value_2
    FROM tmpText
         LEFT JOIN tmpMovement ON 1=1
    WHERE tmpText.Ord = 3

   UNION
    -- 4.Просроченная дебиторская задолженность, грн
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , MovementFloat_DebtSumm.ValueData ::TFloat AS Value
          , 0 ::TFloat AS Value_2
    FROM tmpText
         LEFT JOIN MovementFloat AS MovementFloat_DebtSumm
                                 ON MovementFloat_DebtSumm.MovementId = vbMovementId_PromoTradeHistory
                                AND MovementFloat_DebtSumm.DescId = zc_MovementFloat_DebtSumm()
    WHERE tmpText.Ord = 4

   UNION
    -- 5.Просроченная дебиторская задолженность, дней
    SELECT  tmpText.Ord             ::Integer
          , tmpText.Name            ::TVarChar
          , MovementFloat_DebtDay.ValueData ::TFloat AS Value
          , 0 ::TFloat AS Value_2
    FROM tmpText
         LEFT JOIN MovementFloat AS MovementFloat_DebtDay
                                 ON MovementFloat_DebtDay.MovementId = vbMovementId_PromoTradeHistory
                                AND MovementFloat_DebtDay.DescId = zc_MovementFloat_DebtDay()
    WHERE tmpText.Ord = 5

    ORDER by 1
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.09.24         *
*/

-- SELECT * FROM gpSelect_Movement_PromoTradeHistory (inMovementId:= 29197668 , inSession:= zfCalc_UserAdmin())
