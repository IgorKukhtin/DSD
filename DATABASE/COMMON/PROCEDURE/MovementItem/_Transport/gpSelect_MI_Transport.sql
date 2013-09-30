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
           
            , Object_Freight.Id           AS FreightId
            , Object_Freight.ValueData    AS FreightName
            , Object_RouteKind.Id         AS RouteKindId
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

    IF inShowAll THEN

    OPEN Cursor2 FOR 
        SELECT 
              0 AS Id
            , Object_Fuel.Id            AS FuelId
            , Object_Fuel.ObjectCode    AS FuelCode
            , Object_Fuel.ValueData     AS FuelName

            , MovementItem_Master.Id     AS ParentId
            , 0                          AS Amount
              -- для "Основного" вида топлива расчитываем норму
            , CASE WHEN ObjectLink_Car_FuelAll.DescId = zc_ObjectLink_Car_FuelMaster()
                        THEN  -- для расстояния
                             (COALESCE (MovementItem_Master.Amount, 0) * COALESCE (tmpRateFuel.AmountFuel, 0) * (1 + COALESCE (ObjectFloat_Tax.ValueData, 0) / 100)
                              -- для Холод, часов
                            + 0 * COALESCE (tmpRateFuel.AmountColdHour, 0)
                              -- для Холод, км
                            + 0 * COALESCE (tmpRateFuel.AmountColdDistance, 0)
                             )
                             -- !!!Коэффициент перевода нормы!!!
                             -- * COALESCE (ObjectFloat_Ratio.ValueData, 0)
                   ELSE 0
              END Amount_calc

            , TRUE AS Calculated
            , 0            AS ColdHour
            , 0            AS ColdDistance
            , tmpRateFuel.AmountColdHour     * (1 + COALESCE (ObjectFloat_Tax.ValueData, 0) / 100) AS AmountColdHour
            , tmpRateFuel.AmountColdDistance * (1 + COALESCE (ObjectFloat_Tax.ValueData, 0) / 100) AS AmountColdDistance
            , tmpRateFuel.AmountFuel         * (1 + COALESCE (ObjectFloat_Tax.ValueData, 0) / 100) AS AmountFuel
            
            , Object_RateFuelKind.ValueData  AS RateFuelKindName

            , FALSE isErased
            
        FROM (SELECT zc_ObjectLink_Car_FuelMaster() AS DescId UNION ALL SELECT zc_ObjectLink_Car_FuelChild() AS DescId) AS tmpDesc
             -- выбрали автомобиль (он один)
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = inMovementId
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
             -- выбрали у автомобиля - все Виды топлива
             LEFT JOIN ObjectLink AS ObjectLink_Car_FuelAll ON ObjectLink_Car_FuelAll.ObjectId = MovementLinkObject_Car.ObjectId
                                                           AND ObjectLink_Car_FuelAll.DescId = tmpDesc.DescId
             LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = ObjectLink_Car_FuelAll.ChildObjectId

             -- выбрали у Вида топлива - Вид норм для топлива
             LEFT JOIN ObjectLink AS ObjectLink_Fuel_RateFuelKind ON ObjectLink_Fuel_RateFuelKind.ObjectId = Object_Fuel.Id
                                                                 AND ObjectLink_Fuel_RateFuelKind.DescId = zc_ObjectLink_Fuel_RateFuelKind()
             LEFT JOIN Object AS Object_RateFuelKind ON Object_RateFuelKind.Id = ObjectLink_Fuel_RateFuelKind.ChildObjectId
             -- выбрали у нормы для топлива - % дополнительного расхода в связи с сезоном/температурой
             LEFT JOIN ObjectFloat AS ObjectFloat_Tax ON ObjectFloat_Tax.ObjectId = ObjectLink_Fuel_RateFuelKind.ChildObjectId
                                                     AND ObjectFloat_Tax.DescId = zc_ObjectFloat_RateFuelKind_Tax()
             -- выбрали все маршруты
             LEFT JOIN MovementItem AS MovementItem_Master ON MovementItem_Master.MovementId = inMovementId
                                                          AND MovementItem_Master.DescId = zc_MI_Master()
             -- выбрали у маршрута - Тип маршрута
             LEFT JOIN MovementItemLinkObject AS MILinkObject_RouteKind
                                              ON MILinkObject_RouteKind.MovementItemId = MovementItem_Master.Id 
                                             AND MILinkObject_RouteKind.DescId = zc_MILinkObject_RouteKind()

             -- выбрали норму для автомобиль + Тип маршрута
             LEFT JOIN (SELECT ObjectLink_RateFuel_Car.ChildObjectId       AS CarId
                             , ObjectLink_RateFuel_RouteKind.ChildObjectId AS RouteKindId
                             , ObjectFloat_Amount.ValueData                AS AmountFuel
                             , ObjectFloat_AmountColdHour.ValueData        AS AmountColdHour
                             , ObjectFloat_AmountColdDistance.ValueData    AS AmountColdDistance
                        FROM ObjectLink AS ObjectLink_RateFuel_Car
                             LEFT JOIN ObjectLink AS ObjectLink_RateFuel_RouteKind
                                                  ON ObjectLink_RateFuel_RouteKind.ObjectId = ObjectLink_RateFuel_Car.ObjectId
                                                 AND ObjectLink_RateFuel_RouteKind.DescId = zc_ObjectLink_RateFuel_RouteKind()
                             LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                                   ON ObjectFloat_Amount.ObjectId = ObjectLink_RateFuel_Car.ObjectId
                                                  AND ObjectFloat_Amount.DescId = zc_ObjectFloat_RateFuel_Amount()
                             LEFT JOIN ObjectFloat AS ObjectFloat_AmountColdHour
                                                   ON ObjectFloat_AmountColdHour.ObjectId = ObjectLink_RateFuel_Car.ObjectId
                                                  AND ObjectFloat_AmountColdHour.DescId = zc_ObjectFloat_RateFuel_AmountColdHour()
                             LEFT JOIN ObjectFloat AS ObjectFloat_AmountColdDistance
                                                   ON ObjectFloat_AmountColdDistance.ObjectId = ObjectLink_RateFuel_Car.ObjectId
                                                  AND ObjectFloat_AmountColdDistance.DescId = zc_ObjectFloat_RateFuel_AmountColdDistance()
                        WHERE ObjectLink_RateFuel_Car.DescId = zc_ObjectLink_RateFuel_Car()
                       ) AS tmpRateFuel ON tmpRateFuel.CarId       = MovementLinkObject_Car.ObjectId
                                       AND tmpRateFuel.RouteKindId = MILinkObject_RouteKind.ObjectId

             -- выбрали у Вида топлива - Коэффициент перевода нормы 
             -- LEFT JOIN ObjectFloat AS ObjectFloat_Ratio ON ObjectFloat_Ratio.ObjectId = Object_Fuel.Id
             --                                           AND ObjectFloat_Ratio.DescId = zc_ObjectFloat_Fuel_Ratio()

      ;

    ELSE
    OPEN Cursor2 FOR 
        SELECT 
              MovementItem.Id
            , MovementItem.ObjectId     AS FuelId
            , Object_Fuel.ObjectCode    AS FuelCode
            , Object_Fuel.ValueData     AS FuelName

            , MovementItem.ParentId      AS ParentId
            , MovementItem.Amount        AS Amount
              -- для "Основного" вида топлива расчитываем норму
            , CASE WHEN MovementItem.ObjectId = ObjectLink_Car_FuelMaster.ChildObjectId
                        THEN  -- для расстояния
                             (COALESCE (MovementItem_Master.Amount, 0) * COALESCE (MIFloat_AmountFuel.ValueData, 0)
                              -- для Холод, часов
                            + COALESCE (MIFloat_ColdHour.ValueData, 0) * COALESCE (MIFloat_AmountColdHour.ValueData, 0)
                              -- для Холод, км
                            + COALESCE (MIFloat_ColdDistance.ValueData, 0) * COALESCE (MIFloat_AmountColdDistance.ValueData, 0)
                             )
                             -- !!!Коэффициент перевода нормы!!!
                             -- * COALESCE (ObjectFloat_Ratio.ValueData, 0)
                   ELSE 0
              END Amount_calc

            , COALESCE (MIBoolean_Calculated.ValueData, TRUE) AS Calculated
            , MIFloat_ColdHour.ValueData            AS ColdHour
            , MIFloat_ColdDistance.ValueData        AS ColdDistance
            , MIFloat_AmountColdHour.ValueData      AS AmountColdHour
            , MIFloat_AmountColdDistance.ValueData  AS AmountColdDistance
            , MIFloat_AmountFuel.ValueData          AS AmountFuel
            
            , Object_RateFuelKind.ValueData  AS RateFuelKindName

            , MovementItem.isErased
            
        FROM MovementItem
             LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = MovementItem.ObjectId

             LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                           ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                          AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
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

             -- LEFT JOIN ObjectFloat AS ObjectFloat_Ratio ON ObjectFloat_Ratio.ObjectId = MovementItem.ObjectId
             --                                           AND ObjectFloat_Ratio.DescId = zc_ObjectFloat_Fuel_Ratio()

             LEFT JOIN MovementItem AS MovementItem_Master ON MovementItem_Master.Id = MovementItem.ParentId
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                          ON MovementLinkObject_Car.MovementId = MovementItem.MovementId
                                         AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
             LEFT JOIN ObjectLink AS ObjectLink_Car_FuelMaster ON ObjectLink_Car_FuelMaster.ObjectId = MovementLinkObject_Car.ObjectId
                                                              AND ObjectLink_Car_FuelMaster.DescId = zc_ObjectLink_Car_FuelMaster()

       WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Child();
    END IF;
       
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
