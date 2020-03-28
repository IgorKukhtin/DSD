--- Function: gpSelect_MovementItem_PrintPromoCodeSticker()


DROP FUNCTION IF EXISTS gpSelect_MovementItem_PrintPromoCodeSticker (Integer, Text, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PrintPromoCodeSticker(
    IN inMovementId  Integer      , -- ключ Документа
    IN inUnitName    Text         ,
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
                     , MIFloat_ChangePercent.ValueData            AS ChangePercent
                     , ROW_NUMBER()OVER(ORDER BY MI_Sign.Id)      AS ORD
                FROM MovementItem AS MI_Sign

                    LEFT JOIN MovementItemString AS MIString_GUID
                                                 ON MIString_GUID.MovementItemId = MI_Sign.Id
                                                AND MIString_GUID.DescId = zc_MIString_GUID()

                    LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                ON MIFloat_ChangePercent.MovementItemId = MI_Sign.Id
                                               AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

                WHERE MI_Sign.MovementId = inMovementId
                  AND MI_Sign.DescId = zc_MI_Sign()
                  AND MI_Sign.isErased = FALSE
                  AND COALESCE (MIFloat_ChangePercent.ValueData, 0) > 0
                  AND MI_Sign.Amount = 1 )

    , tmpMIMax AS (SELECT Max(tmpMI.ChangePercent) AS ChangePercentMax FROM tmpMI)
    , tmpResult AS (SELECT Chr(13)||Chr(10)||
                           'Скидка для клиента до '||to_char(tmpMIMax.ChangePercentMax,'FM9999990.00')::Text||'%'||Chr(13)||Chr(10)||
                           'код промо '||tmpMI.GUID::Text||Chr(13)||Chr(10)||
                           'Скидка действует на'||Chr(13)||Chr(10)||inUnitName||Chr(13)||Chr(10)            AS ResultData
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


-- select * from gpSelect_MovementItem_PrintPromoCodeSticker(inMovementId := 18342218, inUnitName := ''  , inSession := '3');