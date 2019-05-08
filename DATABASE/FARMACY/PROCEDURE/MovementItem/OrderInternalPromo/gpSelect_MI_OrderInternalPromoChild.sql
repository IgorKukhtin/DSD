--- Function: gpSelect_MI_OrderInternalPromoChild()


DROP FUNCTION IF EXISTS gpSelect_MI_OrderInternalPromoChild (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderInternalPromoChild(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , -- все
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , Amount TFloat, AmountOut TFloat, Remains TFloat
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
           SELECT MovementItem.Id
                , MovementItem.ParentId
                , Object_Unit.Id                   AS UnitId
                , Object_Unit.ObjectCode           AS UnitCode
                , Object_Unit.ValueData            AS UnitName
                
                , MovementItem.Amount              AS Amount
                , MIFloat_AmountOut.ValueData      AS AmountOut
                , MIFloat_Remains.ValueData        AS Remains
                , (((MIFloat_AmountOut.ValueData /vbDays )*300 - MIFloat_Remains.ValueData)/300) :: TFloat AS Koeff
                , MovementItem.IsErased
           FROM MovementItem
                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.ObjectId

                LEFT JOIN MovementItemFloat AS MIFloat_AmountOut
                                            ON MIFloat_AmountOut.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountOut.DescId = zc_MIFloat_AmountOut()

                LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                            ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                           AND MIFloat_Remains.DescId = zc_MIFloat_Remains()

           WHERE MovementItem.MovementId = inMovementId
             AND MovementItem.DescId = zc_MI_Child()
             AND (MovementItem.isErased = FALSE OR inIsErased = TRUE);
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.04.19         *
*/

--select * from gpSelect_MI_OrderInternalPromoChild(inMovementId := 0 , inIsErased := 'False' ,  inSession := '3');