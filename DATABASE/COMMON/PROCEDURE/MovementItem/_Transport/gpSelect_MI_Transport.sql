-- Function: gpSelect_MI_Transport()

-- DROP FUNCTION gpSelect_MI_Transport (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Transport(
    IN inMovementId  Integer      , -- ÍÎ˛˜ ƒÓÍÛÏÂÌÚ‡
    IN inShowAll     Boolean      , -- 
    IN inSession     TVarChar       -- ÒÂÒÒËˇ ÔÓÎ¸ÁÓ‚‡ÚÂÎˇ
)
RETURNS SETOF refcursor AS
$BODY$
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_MI_Transport());

    OPEN Cursor1 FOR 
        SELECT 
              MovementItem.Id
            , MovementItem.ObjectId
            , Object_Route.ObjectCode  AS RouteCode
            , Object_Route.ValueData   AS RouteName
          
            , MIFloat_Weight.ValueData      AS Weight
            , MIFloat_RealWeight.ValueData AS RealWeight
            , MIFloat_CuterCount.ValueData AS CuterCount
           
            , Object_GoodsKind.ObjectCode AS GoodsKindCode
            , Object_GoodsKind.ValueData  AS GoodsKindName

            , Object_Receipt.ObjectCode AS ReceiptCode
            , Object_Receipt.ValueData  AS ReceiptName
 
            , MovementItem.isErased     AS isErased
            
        FROM MovementItem 
             LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementItem.ObjectId
             
             LEFT JOIN MovementItemFloat AS MIFloat_Weight
                                         ON MIFloat_Weight.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Weightt.DescId = zc_MIFloat_Weight()
             
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Freight
                                              ON MILinkObject_Freight.MovementItemId = MovementItem.Id 
                                             AND MILinkObject_Freight.DescId = zc_MILinkObject_Freight()
             LEFT JOIN Object AS Object_Freight ON Object_Freight.Id = MILinkObject_Freight.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_RouteKind
                                              ON MILinkObject_RouteKind.MovementItemId = MovementItem.Id 
                                             AND MILinkObject_RouteKind.DescId = zc_MILinkObject_RouteKind()
             LEFT JOIN Object AS Object_RouteKind ON Object_RouteKind.Id = MILinkObject_RouteKind.ObjectId

       WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master();
    
    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR 
        SELECT 
              MovementItem.Id
            , MovementItem.ObjectId
            , Object_Fuel.ObjectCode    AS FuelCode
            , Object_Fuel.ValueData     AS FuelName

            , MovementItem.Amount        AS Amount
            , MovementItem.ParentId      AS ParentId
            
            , MIBoolean_Calculated.ValueData AS Calculated
            
            , MIFloat_—oldHour.ValueData           AS —oldHour
            , MIFloat_—oldDistance.ValueData       AS —oldDistance
            , MIFloat_Amount—oldHour.ValueData     AS Amount—oldHour
            , MIFloat_Amount—oldDistance.ValueData AS Amount—oldDistance
            , MIFloat_AmountFuel.ValueData         AS AmountFuel
            
            , Object_RateFuelKind.ObjectId   AS RateFuelKindId
            , Object_RateFuelKind.ObjectCode AS RateFuelKindCode
            , Object_RateFuelKind.ValueData  AS RateFuelKindName

            , MovementItem.isErased
            
        FROM MovementItem 
             LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = MovementItem.ObjectId

             LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                           ON MIBoolean_Calculated.MovementItemId = MovementItem.Id 
                                          AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                          
             LEFT JOIN MovementItemFloat AS MIFloat_—oldHour
                                         ON MIFloat_—oldHour.MovementItemId = MovementItem.Id 
                                        AND MIFloat_—oldHour.DescId = zc_MIFloat_—oldHour()

             LEFT JOIN MovementItemFloat AS MIFloat_—oldDistance
                                         ON MIFloat_—oldDistance.MovementItemId = MovementItem.Id 
                                        AND MIFloat_—oldDistance.DescId = zc_MIFloat_—oldDistance()

             LEFT JOIN MovementItemFloat AS MIFloat_Amount—oldHour
                                         ON MIFloat_Amount—oldHour.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Amount—oldHour.DescId = zc_MIFloat_Amount—oldHour()

             LEFT JOIN MovementItemFloat AS MIFloat_Amount—oldDistance
                                         ON MIFloat_Amount—oldDistance.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Amount—oldDistance.DescId = zc_MIFloat_Amount—oldDistance()

             LEFT JOIN MovementItemFloat AS MIFloat_AmountFuel
                                         ON MIFloat_AmountFuel.MovementItemId = MovementItem.Id 
                                        AND MIFloat_AmountFuel.DescId = zc_MIFloat_AmountFuel()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_RateFuelKind
                                              ON MILinkObject_RateFuelKind.MovementItemId = MovementItem.Id 
                                             AND MILinkObject_RateFuelKind.DescId = zc_MILinkObject_RateFuelKind()
             LEFT JOIN Object AS Object_RateFuelKind ON Object_RateFuelKind.Id = MILinkObject_RateFuelKind.ObjectId
       
       WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Child();
       
    RETURN NEXT Cursor2;

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MI_Transport (Integer, Boolean, TVarChar) OWNER TO postgres;


/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 25.09.13         * add Cursor...; rename  TransportFuelOut- Transport             
 20.08.13         * 
*/

-- ÚÂÒÚ
-- SELECT * FROM gpSelect_MI_Transport (inMovementId:= 25173, inShowAll:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MI_Transport (inMovementId:= 25173, inShowAll:= FALSE, inSession:= '2')
