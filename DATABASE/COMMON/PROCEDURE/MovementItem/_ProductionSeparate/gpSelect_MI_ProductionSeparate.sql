-- Function: gpSelect_MI_ProductionSeparate()

--DROP FUNCTION gpSelect_MI_ProductionSeparate();

CREATE OR REPLACE FUNCTION gpSelect_MI_ProductionSeparate(
    IN inMovementId          Integer,       
    IN inShowAll             Boolean,
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor AS
$BODY$
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_MovementItem_ProductionSeparate());

    OPEN Cursor1 FOR 
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
    
    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR 
        SELECT 
              MovementItem.Id
            , MovementItem.ObjectId
            , Object_Goods.ObjectCode    AS GoodsCode
            , Object_Goods.ValueData     AS GoodsName

            , MovementItem.Amount        AS Amount
            , MovementItem.ParentId      AS ParentId
            
            , MIFloat_HeadCount.ValueData  AS HeadCount
            
            , MovementItem.isErased
            
        FROM MovementItem 
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

             LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                         ON MIFloat_HeadCount.MovementItemId = MovementItem.Id 
                                        AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                                               
       WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Child();
       
    RETURN NEXT Cursor2;
 
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.07.13         *              

*/

-- тест
-- SELECT * FROM gpSelect_MI_ProductionSeparate (inMovementId:= 1, inShowAll:= TRUE, inSession:= '2')
