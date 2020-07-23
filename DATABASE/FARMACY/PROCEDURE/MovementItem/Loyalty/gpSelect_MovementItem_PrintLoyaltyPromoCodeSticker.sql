--- Function: gpSelect_MovementItem_PrintLoyaltyPromoCodeSticker()


DROP FUNCTION IF EXISTS gpSelect_MovementItem_PrintLoyaltyPromoCodeSticker (Integer, Text, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PrintLoyaltyPromoCodeSticker(
    IN inMovementId  Integer      , -- ключ Документа
    IN inUnitName    Text         ,
    IN inOperDate    TDateTime    ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Column1            Text
             , GUID1              TVarChar
             , Column2            Text
             , GUID2              TVarChar
             , Column3            Text
             , GUID3              TVarChar
              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
    vbUserId:= lpGetUserBySession (inSession);

  RETURN QUERY
  WITH
      tmpMI AS (SELECT MIString_GUID.ValueData                    AS GUID
                     , MI_Sign.Amount                             AS Amount
                     , ROW_NUMBER()OVER(ORDER BY MI_Sign.Id)      AS ORD
                FROM MovementItem AS MI_Sign

                    LEFT JOIN MovementItemString AS MIString_GUID
                                                 ON MIString_GUID.MovementItemId = MI_Sign.Id
                                                AND MIString_GUID.DescId = zc_MIString_GUID()

                    LEFT JOIN MovementItemDate AS MIDate_OperDate
                                               ON MIDate_OperDate.MovementItemId = MI_Sign.Id
                                              AND MIDate_OperDate.DescId = zc_MIDate_OperDate()

                WHERE MI_Sign.MovementId = inMovementId
                  AND MI_Sign.DescId = zc_MI_Sign()
                  AND MI_Sign.isErased = FALSE/*
                  AND MIDate_OperDate.ValueData = inOperDate*/)

    , tmpMIMax AS (SELECT Max(tmpMI.Amount) AS Amount FROM tmpMI)
    , tmpResult AS (SELECT Chr(13)||Chr(10)||
                           'Скидка для клиента до '||to_char(tmpMIMax.Amount,'FM9999990.00')::Text||' грн.'||Chr(13)||Chr(10)||
                           'код промо '||tmpMI.GUID::Text||Chr(13)||Chr(10)||
                           inUnitName||Chr(13)||Chr(10)            AS ResultData
                         , tmpMI.GUID
                         , tmpMI.Ord
                    FROM tmpMI
                         LEFT JOIN tmpMIMax ON 1 = 1)

  SELECT Result1.ResultData, Result1.GUID
       , Result2.ResultData, Result2.GUID
       , Result3.ResultData, Result3.GUID
  FROM tmpResult  AS Result1
       LEFT JOIN tmpResult AS Result2 ON Result2.Ord = Result1.Ord + 1
       LEFT JOIN tmpResult AS Result3 ON Result3.Ord = Result1.Ord + 2
  WHERE (Result1.Ord - 1) % 3  = 0
  ORDER BY Result1.Ord
  ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.   Шаблий О.В.
 22.08.18                                                                         *
 13.12.17         *
*/


--
select * from gpSelect_MovementItem_PrintLoyaltyPromoCodeSticker(inMovementId := 19620044 , inUnitName := 'Использовать только на сайте' , inOperDate := ('22.07.2020')::TDateTime ,  inSession := '3');