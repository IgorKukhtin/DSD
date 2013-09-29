-- Function: gpSelect_MI_Transport()

-- DROP FUNCTION gpSelect_MI_Transport (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Transport(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
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
            , MovementItem.ObjectId    AS RouteId
            , Object_Route.ObjectCode  AS RouteCode
            , Object_Route.ValueData   AS RouteName
          
            , MovementItem.Amount
            , MIFloat_Weight.ValueData        AS Weight
            , MIFloat_StartOdometre.ValueData AS StartOdometre
            , MIFloat_EndOdometre.ValueData   AS EndOdometre
           
            , Object_Freight.ValueData    AS FreightName
            , Object_RouteKind.ValueData  AS RouteKindName
 
            , MovementItem.isErased     AS isErased
            
        FROM MovementItem
             LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementItem.ObjectId
             
             LEFT JOIN MovementItemFloat AS MIFloat_Weight
                                         ON MIFloat_Weight.MovementItemId = MovementItem.Id
                                        AND MIFloat_Weight.DescId = zc_MIFloat_Weight()
             LEFT JOIN MovementItemFloat AS MIFloat_StartOdometre
                                         ON MIFloat_StartOdometre.MovementItemId = MovementItem.Id
                                        AND MIFloat_StartOdometre.DescId = zc_MIFloat_StartOdometre()
             LEFT JOIN MovementItemFloat AS MIFloat_EndOdometre
                                         ON MIFloat_EndOdometre.MovementItemId = MovementItem.Id
                                        AND MIFloat_EndOdometre.DescId = zc_MIFloat_StartOdometre()
             
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
            , MovementItem.ObjectId     AS FuelId
            , Object_Fuel.ObjectCode    AS FuelCode
            , Object_Fuel.ValueData     AS FuelName

            , MovementItem.ParentId      AS ParentId
            , MovementItem.Amount        AS Amount

            , MIFloat_ColdHour.ValueData           AS ColdHour
            , MIFloat_ColdDistance.ValueData       AS ColdDistance
            , MIFloat_AmountColdHour.ValueData     AS AmountColdHour
            , MIFloat_AmountColdDistance.ValueData AS AmountColdDistance
            , MIFloat_AmountFuel.ValueData         AS AmountFuel
            
            , Object_RateFuelKind.ValueData  AS RateFuelKindName

            , MovementItem.isErased
            
        FROM MovementItem 
             LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = MovementItem.ObjectId

             LEFT JOIN MovementItemFloat AS MIFloat_ColdHour
                                         ON MIFloat_ColdHour.MovementItemId = MovementItem.Id 
                                        AND MIFloat_ColdHour.DescId = zc_MIFloat_ColdHour()
             LEFT JOIN MovementItemFloat AS MIFloat_ColdDistance
                                         ON MIFloat_ColdDistance.MovementItemId = MovementItem.Id 
                                        AND MIFloat_ColdDistance.DescId = zc_MIFloat_ColdDistance()

             LEFT JOIN MovementItemFloat AS MIFloat_AmountColdHour
                                         ON MIFloat_AmountColdHour.MovementItemId = MovementItem.Id 
                                        AND MIFloat_AmountColdHour.DescId = zc_MIFloat_AmountColdHour()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountColdDistance
                                         ON MIFloat_AmountColdDistance.MovementItemId = MovementItem.Id 
                                        AND MIFloat_AmountColdDistance.DescId = zc_MIFloat_AmountColdDistance()

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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.07.13                                        *
 25.09.13         * add Cursor...; rename  TransportFuelOut- Transport             
*/

-- тест
-- SELECT * FROM gpSelect_MI_Transport (inMovementId:= 25173, inShowAll:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MI_Transport (inMovementId:= 25173, inShowAll:= FALSE, inSession:= '2')
