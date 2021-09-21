--- Function: gpSelect_MI_OrderInternalPromoChild()


DROP FUNCTION IF EXISTS gpSelect_MI_OrderInternalPromoChild (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderInternalPromoChild(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , -- все
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , Amount TFloat, AmountManual TFloat
             , AmountOut TFloat, Remains TFloat
             , Koeff TFloat, Koeff2 TFloat
             , RemainsDay TFloat
             , IsErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbDays TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderInternalPromo());
    vbUserId:= lpGetUserBySession (inSession);

    -- данные из шапки документа
    SELECT DATE_PART ( 'day', ((Movement.OperDate - MovementDate_StartSale.ValueData)+ INTERVAL '1 DAY')) :: TFloat
    INTO vbDays
    FROM Movement
        LEFT JOIN MovementDate AS MovementDate_StartSale
                               ON MovementDate_StartSale.MovementId = Movement.Id
                              AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
    WHERE Movement.Id = inMovementId;
    
        RETURN QUERY
        WITH
        -- строки чайлд
        tmpMI_Child AS (SELECT MovementItem.Id
                             , MovementItem.ParentId
                             , MovementItem.ObjectId                       
                             , MovementItem.Amount              AS Amount
                             , MIFloat_AmountManual.ValueData   AS AmountManual
                             , MIFloat_AmountOut.ValueData      AS AmountOut
                             , MIFloat_Remains.ValueData        AS Remains
                             , CASE WHEN MIFloat_AmountOut.ValueData <> 0 AND vbDays <> 0
                                    THEN ( (COALESCE (MIFloat_Remains.ValueData,0) 
                                          + COALESCE (MovementItem.Amount,0) 
                                          + COALESCE (MIFloat_AmountManual.ValueData,0)
                                           ) / (MIFloat_AmountOut.ValueData/vbDays) )
                                    ELSE 0
                               END :: TFloat AS RemainsDay
                             , MovementItem.IsErased
                        FROM MovementItem
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountOut
                                                         ON MIFloat_AmountOut.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountOut.DescId = zc_MIFloat_AmountOut()

                             LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                                         ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Remains.DescId = zc_MIFloat_Remains()

                             LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                                         ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()

                        WHERE MovementItem.MovementId = inMovementId
                          AND MovementItem.DescId = zc_MI_Child()
                          AND MovementItem.isErased = FALSE
                        )
      -- строки мастера, для расчета кол-ва дней ()
      , tmpMI_Master AS (SELECT MovementItem.Id
                              , MovementItem.Amount
                              , (COALESCE (MovementItem.Amount,0) - COALESCE (tmpChild_AmountManual.AmountManual,0)) AS Amount_calc
                              , CASE WHEN COALESCE (tmpChild.AmountOut,0) <> 0 AND vbDays <> 0 
                                     THEN (COALESCE (tmpChild.Remains,0) + COALESCE (MovementItem.Amount,0) - COALESCE (tmpChild_AmountManual.AmountManual,0) ) / (COALESCE (tmpChild.AmountOut,0) / vbDays)
                                     ELSE 0
                                END AS RemainsDay
                         FROM MovementItem
                              LEFT JOIN (SELECT MovementItem.ParentId
                                              , SUM (COALESCE (MovementItem.Remains,0))      AS Remains
                                              , SUM (COALESCE (MovementItem.AmountOut,0))    AS AmountOut
                                         FROM tmpMI_Child AS MovementItem
                                         WHERE COALESCE (MovementItem.AmountManual,0) = 0
                                         GROUP BY MovementItem.ParentId
                                         ) AS tmpChild ON tmpChild.ParentId = MovementItem.Id
                              LEFT JOIN (SELECT MovementItem.ParentId
                                              , SUM (COALESCE (MovementItem.AmountManual,0)) AS AmountManual
                                         FROM tmpMI_Child AS MovementItem
                                         WHERE COALESCE (MovementItem.AmountManual,0) <> 0
                                         GROUP BY MovementItem.ParentId
                                         ) AS tmpChild_AmountManual ON tmpChild_AmountManual.ParentId = MovementItem.Id
                         WHERE MovementItem.MovementId = inMovementId
                           AND MovementItem.DescId = zc_MI_Master()
                           AND MovementItem.isErased = FALSE
                        )

      , tmpMI_Child_Calc AS (SELECT tmpMI_Child.*
                                  , (((tmpMI_Child.AmountOut / vbDays) * tmpMI_Master.RemainsDay - COALESCE (tmpMI_Child.Remains,0)) / tmpMI_Master.RemainsDay) :: TFloat AS Koeff
                                  , SUM (((tmpMI_Child.AmountOut / vbDays) * tmpMI_Master.RemainsDay - COALESCE (tmpMI_Child.Remains,0)) / tmpMI_Master.RemainsDay) OVER (PARTITION BY tmpMI_Child.ParentId) AS KoeffSUM
                             FROM tmpMI_Child
                                  LEFT JOIN tmpMI_Master ON tmpMI_Master.Id = tmpMI_Child.ParentId
                             WHERE COALESCE (tmpMI_Child.AmountManual,0) = 0
                               AND tmpMI_Master.RemainsDay <> 0
                            )

      -- Пересчитывает кол-во дней остатка без аптек с отриц. коэфф.
      , tmpMI_Master2 AS (SELECT MovementItem.Id
                               , CASE WHEN COALESCE (tmpChild.AmountOut,0) <> 0 AND vbDays <> 0 
                                      THEN (COALESCE (tmpChild.Remains,0) + COALESCE (MovementItem.Amount_calc,0)) / (COALESCE (tmpChild.AmountOut,0) / vbDays)
                                      ELSE 0
                                 END AS RemainsDay
                          FROM tmpMI_Master AS MovementItem
                               LEFT JOIN (SELECT MovementItem.ParentId
                                               , SUM (COALESCE (MovementItem.Remains,0))      AS Remains
                                               , SUM (COALESCE (MovementItem.AmountOut,0))    AS AmountOut
                                          FROM tmpMI_Child_Calc AS MovementItem
                                          WHERE COALESCE (MovementItem.Koeff,0) > 0
                                          GROUP BY MovementItem.ParentId
                                          ) AS tmpChild ON tmpChild.ParentId = MovementItem.Id
                          )


      , tmpMI_Child_Calc2 AS (SELECT tmpMI_Child.*
                                   , SUM (tmpMI_Child.Koeff) OVER (PARTITION BY tmpMI_Child.ParentId) AS KoeffSUM
                                   , (((tmpMI_Child.AmountOut / vbDays) * tmpMI_Master.RemainsDay - COALESCE (tmpMI_Child.Remains,0)) / tmpMI_Master.RemainsDay) :: TFloat AS Koeff2
                                   , SUM (((tmpMI_Child.AmountOut / vbDays) * tmpMI_Master.RemainsDay - COALESCE (tmpMI_Child.Remains,0)) / tmpMI_Master.RemainsDay) OVER (PARTITION BY tmpMI_Child.ParentId) AS KoeffSUM2
                              FROM tmpMI_Child_Calc AS tmpMI_Child
                                   LEFT JOIN tmpMI_Master2 AS tmpMI_Master ON tmpMI_Master.Id = tmpMI_Child.ParentId
                              WHERE COALESCE (tmpMI_Child.Koeff,0) > 0
                                AND tmpMI_Master.RemainsDay <> 0
                             )
       
           SELECT MovementItem.Id
                , MovementItem.ParentId
                , Object_Unit.Id                   AS UnitId
                , Object_Unit.ObjectCode           AS UnitCode
                , Object_Unit.ValueData            AS UnitName
                
                , MovementItem.Amount       :: TFloat
                , MovementItem.AmountManual :: TFloat
                , MovementItem.AmountOut    :: TFloat
                , MovementItem.Remains      :: TFloat
                , CASE WHEN COALESCE (tmpMI_Child_Calc.KoeffSUM,0)::TFloat > 0 THEN (tmpMI_Child_Calc.Koeff / tmpMI_Child_Calc.KoeffSUM) ELSE 0 END :: TFloat AS Koeff
                , CASE WHEN COALESCE (tmpMI_Child_Calc2.KoeffSUM2,0)::TFloat > 0 THEN (tmpMI_Child_Calc2.Koeff2 / tmpMI_Child_Calc2.KoeffSUM2) ELSE 0 END :: TFloat AS Koeff2
                , MovementItem.RemainsDay   :: TFloat 
                , MovementItem.IsErased
           FROM tmpMI_Child AS MovementItem
                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.ObjectId
                LEFT JOIN tmpMI_Child_Calc2 ON tmpMI_Child_Calc2.Id = MovementItem.Id
                LEFT JOIN tmpMI_Child_Calc  ON tmpMI_Child_Calc.Id = MovementItem.Id
           ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.05.19         *
 15.04.19         *
*/

--select * from gpSelect_MI_OrderInternalPromoChild(inMovementId := 0 , inIsErased := 'False' ,  inSession := '3');

select * from gpSelect_MI_OrderInternalPromoChild(inMovementId := 24868017 , inIsErased := 'False' ,  inSession := '3');