-- Function: gpSelect_MI_ProductionSeparate_Master()

--DROP FUNCTION gpSelect_MI_ProductionSeparate_Master();

CREATE OR REPLACE FUNCTION gpSelect_MI_ProductionSeparate_Master(
    IN inMovementId          Integer,       
    IN inShowAll             Boolean,
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, HeadCount TFloat
             , isErased Boolean
             )
AS
$BODY$
BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_MovementItem_ProductionSeparate());

    RETURN QUERY 
       SELECT
             MovementItem.Id
           , MovementItem.ObjectId
           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName
          
           , MovementItem.Amount          AS Amount
           , MIFloat_HeadCount.ValueData  AS HeadCount

           , MovementItem.isErased     AS isErased
            
        FROM MovementItem 
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
             
             LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                         ON MIFloat_HeadCount.MovementItemId = MovementItem.Id 
                                        AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

       WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master();
    
  
 
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

ALTER FUNCTION gpSelect_MI_ProductionSeparate_Master (Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.07.13         *              

*/

-- тест
-- SELECT * FROM gpSelect_MI_ProductionSeparate_Master (inMovementId:= 1, inShowAll:= TRUE, inSession:= '2')
