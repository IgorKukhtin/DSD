--- Function: gpSelect_MI_OrderInternalPromoChild()


DROP FUNCTION IF EXISTS gpSelect_MI_OrderInternalPromoChild (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderInternalPromoChild(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , -- все
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , Amount TFloat, AmountOut TFloat, Remains TFloat
             , IsErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderInternalPromo());
    vbUserId:= lpGetUserBySession (inSession);

        RETURN QUERY
           SELECT MovementItem.Id
                , Object_Unit.Id                   AS UnitId
                , Object_Unit.ObjectCode           AS UnitCode
                , Object_Unit.ValueData            AS UnitName
                
                , MovementItem.Amount              AS Amount
                , MIFloat_AmountOut.ValueData      AS AmountOut
                , MIFloat_Remains.ValueData        AS Remains
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