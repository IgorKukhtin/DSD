 -- Function: gpSelect_Goods_AutoVIPforSalesCash()

DROP FUNCTION IF EXISTS gpSelect_Goods_AutoVIPforSalesCash (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Goods_AutoVIPforSalesCash(
    IN inUnitId      Integer,       -- Подразделение
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer, Amount TFloat)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP());
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
    WITH tmpMovement AS (SELECT MovementBoolean_AutoVIPforSales.MovementId
                              , MovementLinkObject_Unit.ObjectId                    AS UnitId  
                         FROM MovementBoolean AS MovementBoolean_AutoVIPforSales
                              
                              INNER JOIN Movement ON Movement.ID = MovementBoolean_AutoVIPforSales.MovementId
                                                 AND Movement.DescId = zc_Movement_Check()
                                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                                 AND Movement.OperDate >= DATE_TRUNC ('MONTH', CURRENT_DATE)

                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    
                                                                                       
                         WHERE MovementBoolean_AutoVIPforSales.DescId = zc_MovementBoolean_AutoVIPforSales()),
         tmpMI AS (SELECT MovementItem.ObjectId               AS GoodsId
                        , SUM(MovementItem.Amount)            AS Amount
                   FROM tmpMovement 
                   
                        INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                               AND MovementItem.DescId     = zc_MI_Master()
                                               AND MovementItem.Amount     > 0
                                               AND MovementItem.isErased   = False
                                               
                   GROUP BY MovementItem.ObjectId)  
                          
    SELECT T1.GoodsId
         , tmpMI.Amount::TFloat
    FROM gpSelect_MovementItem_Promo(inMovementId := 20813880 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := inSession) AS T1
    
         LEFT JOIN tmpMI ON tmpMI.GoodsId = T1.GoodsId
         
    WHERE inUnitId = 13711869;
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 23.12.21                                                      *
*/

--ТЕСТ
-- 

SELECT * FROM gpSelect_Goods_AutoVIPforSalesCash (inUnitId := 13711869 , inSession:= '3')