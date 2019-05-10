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
             , Koeff TFloat
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
    SELECT (DATE_PART ('DAY', AGE (Movement.OperDate + INTERVAL '1 DAY', MovementDate_StartSale.ValueData))) :: TFloat
   INTO vbDays
    FROM Movement
        LEFT JOIN MovementDate AS MovementDate_StartSale
                               ON MovementDate_StartSale.MovementId = Movement.Id
                              AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
    WHERE Movement.Id = inMovementId;
    
        RETURN QUERY
        WITH
        tmpMI AS (SELECT MovementItem.Id
                       , MovementItem.ParentId
                       , MovementItem.ObjectId                       
                       , MovementItem.Amount              AS Amount
                       , MIFloat_AmountManual.ValueData   AS AmountManual
                       , MIFloat_AmountOut.ValueData      AS AmountOut
                       , MIFloat_Remains.ValueData        AS Remains
                       , (((MIFloat_AmountOut.ValueData /vbDays )*300 - COALESCE (MIFloat_Remains.ValueData,0))/300) :: TFloat AS Koeff
                       , SUM (((MIFloat_AmountOut.ValueData /vbDays )*300 - COALESCE (MIFloat_Remains.ValueData,0))/300) OVER (PARTITION BY MovementItem.ParentId) AS KoeffSUM
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
                    AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                  )
        
           SELECT MovementItem.Id
                , MovementItem.ParentId
                , Object_Unit.Id                   AS UnitId
                , Object_Unit.ObjectCode           AS UnitCode
                , Object_Unit.ValueData            AS UnitName
                
                , MovementItem.Amount              AS Amount
                , MovementItem.AmountManual
                , MovementItem.AmountOut
                , MovementItem.Remains
                , CASE WHEN COALESCE (MovementItem.KoeffSUM,0) <> 0 THEN (MovementItem.Koeff / MovementItem.KoeffSUM) ELSE 0 END :: TFloat AS Koeff
                , MovementItem.IsErased
           FROM tmpMI AS MovementItem
                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.ObjectId
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