--- Function: gpSelect_MovementItem_PromoCodeInfo()


DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoCodeInfo (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoCodeInfo(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Name TVarChar
             , Value TFloat
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
        WITH
        tmpMI AS (SELECT MI_Sign.Id
                       , CASE WHEN MI_Sign.Amount = 1 THEN TRUE ELSE FALSE END AS IsChecked
                       , MI_Sign.IsErased

                  FROM MovementItem AS MI_Sign
                  WHERE MI_Sign.MovementId = inMovementId
                    AND MI_Sign.DescId = zc_MI_Sign()
                    AND MI_Sign.Amount = 1
                    AND MI_Sign.isErased = False
                  )
       -- для скорости сначала вібираем все zc_MovementFloat_MovementItemId
      , tmpMovementFloat AS (SELECT MovementFloat_MovementItemId.MovementId
                                  , MovementFloat_MovementItemId.ValueData :: Integer As MovementItemId
                             FROM MovementFloat AS MovementFloat_MovementItemId
                             WHERE MovementFloat_MovementItemId.ValueData IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                               AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                            )
      -- Документ чек, по идее должен быть 1 , но чтоб не задвоилось берем макс и считаем сколько чеков
      , tmpCheck_Mov AS (SELECT tmpMI.Id
                              , MAX (MovementFloat_MovementItemId.MovementId)   AS MovementId_Check
                              , COUNT (MovementFloat_MovementItemId.MovementId) AS Count_Check
                              , SUM(MovementFloat_TotalSumm.ValueData)          AS Summa_Check
                         FROM tmpMI
                              INNER JOIN tmpMovementFloat AS MovementFloat_MovementItemId
                                                          ON MovementFloat_MovementItemId.MovementItemId = tmpMI.Id

                              LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                      ON MovementFloat_TotalSumm.MovementId =  MovementFloat_MovementItemId.MovementId
                                                     AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                         GROUP BY tmpMI.Id
                         )
       SELECT  1 as Id, 'Количество промокодов'::TVarChar AS Name, (SELECT COUNT(*) FROM tmpMI)::TFloat AS Value
       UNION ALL
       SELECT  2 as Id, 'Использовано промокодов'::TVarChar AS Name, (SELECT COUNT(*) FROM tmpCheck_Mov)::TFloat AS Value
       UNION ALL
       SELECT  3 as Id, 'Количество чеков'::TVarChar AS Name, (SELECT SUM(Count_Check) FROM tmpCheck_Mov)::TFloat AS Value
       UNION ALL
       SELECT  4 as Id, 'Средняя сумма чека'::TVarChar AS Name, (SELECT SUM(Summa_Check) / SUM(Count_Check) FROM tmpCheck_Mov)::TFloat AS Value
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.   Шаблий О.В.
 13.09.18                                                                         *
*/

-- select * from gpSelect_MovementItem_PromoCodeInfo(inMovementId := 18342218,  inSession := '3'::TVarChar);

