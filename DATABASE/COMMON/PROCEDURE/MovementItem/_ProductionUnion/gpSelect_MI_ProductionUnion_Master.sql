-- Function: gpSelect_MI_ProductionUnion_Master()

--DROP FUNCTION gpSelect_MI_ProductionUnion_Master();

CREATE OR REPLACE FUNCTION gpSelect_MI_ProductionUnion_Master(
    IN inMovementId          Integer,       
    IN inShowAll             Boolean,
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, PartionClose Boolean
             , Count TFloat, RealWeight TFloat, CuterCount TFloat
             , ReceiptCode Integer, ReceiptName TVarChar
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
            , MIBoolean_PartionClose.ValueData AS PartionClose
            , MIString_Comment.ValueData   AS Comment
            , MIFloat_Count.ValueData      AS Count
            , MIFloat_RealWeight.ValueData AS RealWeight
            , MIFloat_CuterCount.ValueData AS CuterCount
           
            , Object_Receipt.ObjectCode AS ReceiptCode
            , Object_Receipt.ValueData  AS ReceiptName
 
            , MovementItem.isErased     AS isErased
            
        FROM MovementItem 
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
             
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                              ON MILinkObject_Receipt.MovementItemId = MovementItem.Id 
                                             AND MILinkObject_Receipt.DescId = zc_MILinkObject_Receipt()
             LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = MILinkObject_Receipt.ObjectId

             LEFT JOIN MovementItemFloat AS MIFloat_Count
                                         ON MIFloat_Count.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Count.DescId = zc_MIFloat_Count()

             LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                         ON MIFloat_RealWeight.MovementItemId = MovementItem.Id 
                                        AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()

             LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                         ON MIFloat_CuterCount.MovementItemId = MovementItem.Id 
                                        AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
             
             LEFT JOIN MovementItemBoolean AS MIBoolean_PartionClose
                                           ON MIBoolean_PartionClose.MovementItemId = MovementItem.Id 
                                          AND MIBoolean_PartionClose.DescId = zc_MIBoolean_PartionClose()

             LEFT JOIN MovementItemString AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = MovementItem.Id 
                                         AND MIString_Comment.DescId = zc_MIString_Comment()
                                         
       WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master();
    
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.07.13         *              

*/

-- тест
-- SELECT * FROM gpSelect_MI_ProductionUnion_Master (inMovementId:= 1, inShowAll:= TRUE, inSession:= '2')
