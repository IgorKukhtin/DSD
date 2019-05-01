-- Function: gpSelect_MI_Transport (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MI_Transport (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MI_Transport (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Transport(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , -- 
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_MI_Transport());

    IF COALESCE (inMovementId, 0) = 0
    THEN 

        OPEN Cursor1 FOR 
            SELECT 
                  0  :: Integer  AS Id
                , 0  :: Integer  AS RouteId
                , 0  :: Integer  AS RouteCode
                , '' :: TVarChar AS RouteName
              
                , 0  :: Integer  AS UnitId
                , '' :: TVarChar AS UnitName
    
                , 0  :: TFloat   AS Amount
                , 0  :: TFloat   AS DistanceFuelChild
                , 0  :: TFloat   AS DistanceWeightTransport
                , 0  :: TFloat   AS Weight
                , 0  :: TFloat   AS WeightTransport
                , 0  :: TFloat   AS StartOdometre
                , 0  :: TFloat   AS EndOdometre
                , 0  :: TFloat   AS RateSumma
                , 0  :: TFloat   AS RatePrice
                , 0  :: TFloat   AS RatePrice_Calc
                , 0  :: TFloat   AS TimePrice
                , 0  :: TFloat   AS Taxi
                , 0  :: TFloat   AS TaxiMore
                , 0  :: TFloat   AS RateSummaAdd
                , 0  :: TFloat   AS RateSummaExp
    
                , 0  :: Integer  AS FreightId
                , '' :: TVarChar AS FreightName
                , 0  :: Integer  AS RouteKindId
                , '' :: TVarChar AS RouteKindName
                , 0  :: Integer  AS RouteKindId_Freight
                , '' :: TVarChar AS RouteKindName_Freight
            
                , '' :: TVarChar AS Comment
                
                , FALSE :: Boolean AS isErased
            WHERE 1=0;
        RETURN NEXT Cursor1;
   
        OPEN Cursor2 FOR 
            SELECT 
                  0  :: Integer  AS Id
                , 0  :: TFloat   AS Number
                , 0  :: Integer  AS FuelId
                , 0  :: Integer  AS FuelCode
                , '' :: TVarChar AS FuelName
    
                , 0  :: Integer AS ParentId
                , 0  :: TFloat  AS Amount
                  -- Расчитываем норму за все
                , 0  :: TFloat  AS Amount_calc
    
                , 0  :: TFloat   AS Amount_Distance_calc
                , 0  :: TFloat   AS Amount_ColdHour_calc
                , 0  :: TFloat   AS Amount_ColdDistance_calc
    
                , TRUE :: Boolean  AS isCalculated
                , FALSE :: Boolean AS isMasterFuel
    
                , 0  :: TFloat AS ColdHour
                , 0  :: TFloat AS ColdDistance
    
                , 0  :: TFloat AS AmountFuel         -- !!!Коэффициент и % дополнительного расхода уже учтены!!!
                , 0  :: TFloat AS AmountColdHour     -- !!!Коэффициент и % дополнительного расхода уже учтены!!!
                , 0  :: TFloat AS AmountColdDistance -- !!!Коэффициент и % дополнительного расхода уже учтены!!!
    
                , 0  :: TFloat AS RatioFuel        -- Коэффициента перевода нормы
                , 0  :: TFloat AS RateFuelKindTax  -- % дополнительного расхода в связи с сезоном/температурой
                
                , 0  :: Integer AS RateFuelKindId
                , '' :: TVarChar AS RateFuelKindName
    
                , '' :: TVarChar AS UnitName
                , '' :: TVarChar AS BranchName
    
                , FALSE :: Boolean AS isErased
            WHERE 1=0;
        RETURN NEXT Cursor2;

    ELSE

        OPEN Cursor1 FOR 
          WITH
          tmpMI AS (SELECT MovementItem.*
                         , ROW_NUMBER() OVER (ORDER BY MovementItem.isErased ASC, MovementItem.Id ASC) AS Ord
                    FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                         JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                          AND MovementItem.DescId     = zc_MI_Master()
                                          AND MovementItem.isErased   = tmpIsErased.isErased
                    )
    
            SELECT 
                  MovementItem.Id
                , MovementItem.ObjectId    AS RouteId
                , Object_Route.ObjectCode  AS RouteCode
                , Object_Route.ValueData   AS RouteName
              
                , Object_Unit.Id           AS UnitId
                , Object_Unit.ValueData    AS UnitName
    
                , MovementItem.Amount
                , MIFloat_DistanceFuelChild.ValueData                    AS DistanceFuelChild
                , MIFloat_DistanceWeightTransport.ValueData              AS DistanceWeightTransport
                , MIFloat_Weight.ValueData                               AS Weight
                , MIFloat_WeightTransport.ValueData                      AS WeightTransport
                , MIFloat_StartOdometre.ValueData                        AS StartOdometre
                , MIFloat_EndOdometre.ValueData                          AS EndOdometre
                , MIFloat_RateSumma.ValueData                            AS RateSumma
                , MIFloat_RatePrice.ValueData                            AS RatePrice
                , (COALESCE (MIFloat_RatePrice.ValueData, 0) * (COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_DistanceFuelChild.ValueData, 0))
                 + COALESCE (MIFloat_RateSummaAdd.ValueData, 0)) :: TFloat AS RatePrice_Calc
                , COALESCE (MIFloat_TimePrice.ValueData, 0)              AS TimePrice
                , MIFloat_Taxi.ValueData                                 AS Taxi
                , COALESCE (MIFloat_TaxiMore.ValueData, 0)     :: TFloat AS TaxiMore
                , COALESCE (MIFloat_RateSummaAdd.ValueData, 0) :: TFloat AS RateSummaAdd
                , COALESCE (MIFloat_RateSummaExp.ValueData, 0) :: TFloat AS RateSummaExp
    
                , Object_Freight.Id                  AS FreightId
                , Object_Freight.ValueData           AS FreightName
                , Object_RouteKind.Id                AS RouteKindId
                , Object_RouteKind.ValueData         AS RouteKindName
                , Object_RouteKindFreight.Id         AS RouteKindId_Freight
                , Object_RouteKindFreight.ValueData  AS RouteKindName_Freight
     
                --, CASE WHEN COALESCE(ObjectDate_StartRunPlan.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_StartRunPlan.ValueData ELSE Null END ::TDateTime  AS StartRunPlan
                --, CASE WHEN COALESCE(ObjectDate_EndRunPlan.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_EndRunPlan.ValueData ELSE Null END ::TDateTime  AS EndRunPlan
            
                , MIString_Comment.ValueData   AS Comment
                
                , MovementItem.isErased     AS isErased
                
            FROM tmpMI AS MovementItem
                 LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementItem.ObjectId
    
                 LEFT JOIN MovementItemFloat AS MIFloat_RateSumma
                                             ON MIFloat_RateSumma.MovementItemId =  MovementItem.Id
                                            AND MIFloat_RateSumma.DescId = zc_MIFloat_RateSumma()
                 LEFT JOIN MovementItemFloat AS MIFloat_RatePrice
                                             ON MIFloat_RatePrice.MovementItemId =  MovementItem.Id
                                            AND MIFloat_RatePrice.DescId = zc_MIFloat_RatePrice()
                 LEFT JOIN MovementItemFloat AS MIFloat_TimePrice
                                             ON MIFloat_TimePrice.MovementItemId =  MovementItem.Id
                                            AND MIFloat_TimePrice.DescId = zc_MIFloat_TimePrice()
    
                 LEFT JOIN MovementItemFloat AS MIFloat_Taxi
                                             ON MIFloat_Taxi.MovementItemId =  MovementItem.Id
                                            AND MIFloat_Taxi.DescId = zc_MIFloat_Taxi()
                 LEFT JOIN MovementItemFloat AS MIFloat_TaxiMore
                                             ON MIFloat_TaxiMore.MovementItemId =  MovementItem.Id
                                            AND MIFloat_TaxiMore.DescId = zc_MIFloat_TaxiMore()
    
                 LEFT JOIN MovementItemFloat AS MIFloat_DistanceWeightTransport
                                             ON MIFloat_DistanceWeightTransport.MovementItemId = MovementItem.Id
                                            AND MIFloat_DistanceWeightTransport.DescId = zc_MIFloat_DistanceWeightTransport()
    
                 LEFT JOIN MovementItemFloat AS MIFloat_DistanceFuelChild
                                             ON MIFloat_DistanceFuelChild.MovementItemId = MovementItem.Id
                                            AND MIFloat_DistanceFuelChild.DescId = zc_MIFloat_DistanceFuelChild()
    
                 LEFT JOIN MovementItemFloat AS MIFloat_Weight
                                             ON MIFloat_Weight.MovementItemId = MovementItem.Id
                                            AND MIFloat_Weight.DescId = zc_MIFloat_Weight()
                 LEFT JOIN MovementItemFloat AS MIFloat_WeightTransport
                                             ON MIFloat_WeightTransport.MovementItemId = MovementItem.Id
                                            AND MIFloat_WeightTransport.DescId = zc_MIFloat_WeightTransport()
                                                                       
                 LEFT JOIN MovementItemFloat AS MIFloat_StartOdometre
                                             ON MIFloat_StartOdometre.MovementItemId = MovementItem.Id
                                            AND MIFloat_StartOdometre.DescId = zc_MIFloat_StartOdometre()
                 LEFT JOIN MovementItemFloat AS MIFloat_EndOdometre
                                             ON MIFloat_EndOdometre.MovementItemId = MovementItem.Id
                                            AND MIFloat_EndOdometre.DescId = zc_MIFloat_EndOdometre()
    
                 LEFT JOIN MovementItemFloat AS MIFloat_RateSummaAdd
                                             ON MIFloat_RateSummaAdd.MovementItemId = MovementItem.Id
                                            AND MIFloat_RateSummaAdd.DescId = zc_MIFloat_RateSummaAdd()
    
                 LEFT JOIN MovementItemFloat AS MIFloat_RateSummaExp
                                             ON MIFloat_RateSummaExp.MovementItemId = MovementItem.Id
                                            AND MIFloat_RateSummaExp.DescId = zc_MIFloat_RateSummaExp()
    
                 LEFT JOIN MovementItemString AS MIString_Comment
                                              ON MIString_Comment.MovementItemId = MovementItem.Id 
                                             AND MIString_Comment.DescId = zc_MIString_Comment()
    
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Freight
                                                  ON MILinkObject_Freight.MovementItemId = MovementItem.Id 
                                                 AND MILinkObject_Freight.DescId = zc_MILinkObject_Freight()
                 LEFT JOIN Object AS Object_Freight ON Object_Freight.Id = MILinkObject_Freight.ObjectId
    
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_RouteKind
                                                  ON MILinkObject_RouteKind.MovementItemId = MovementItem.Id 
                                                 AND MILinkObject_RouteKind.DescId = zc_MILinkObject_RouteKind()
                 LEFT JOIN Object AS Object_RouteKind ON Object_RouteKind.Id = MILinkObject_RouteKind.ObjectId
    
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_RouteKindFreight
                                                  ON MILinkObject_RouteKindFreight.MovementItemId = MovementItem.Id 
                                                 AND MILinkObject_RouteKindFreight.DescId = zc_MILinkObject_RouteKindFreight()
                 LEFT JOIN Object AS Object_RouteKindFreight ON Object_RouteKindFreight.Id = MILinkObject_RouteKindFreight.ObjectId
                 
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                  ON MILinkObject_Unit.MovementItemId = MovementItem.Id 
                                                 AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                 LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId
    
          ;
        
        RETURN NEXT Cursor1;
    
    --    IF inShowAll THEN
    
        OPEN Cursor2 FOR 
            -- это для тех видов топлива, которые не введены в документ
            SELECT 
                  0 AS Id
                , CASE WHEN ObjectLink_Car_FuelAll.DescId = zc_ObjectLink_Car_FuelMaster()
                            THEN 1
                       ELSE 2
                  END AS Number
                , Object_Fuel.Id            AS FuelId
                , Object_Fuel.ObjectCode    AS FuelCode
                , Object_Fuel.ValueData     AS FuelName
    
                , MovementItem_Master.Id     AS ParentId
                , 0                          AS Amount
                  -- Расчитываем норму за все
                , zfCalc_RateFuelValue (inDistance           := CASE WHEN ObjectLink_Car_FuelAll.DescId = zc_ObjectLink_Car_FuelMaster() THEN MovementItem_Master.Amount         -- если "Основной" вид топлива
                                                                     WHEN ObjectLink_Car_FuelAll.DescId = zc_ObjectLink_Car_FuelChild() THEN MIFloat_DistanceFuelChild.ValueData -- если "Дополнительный" вид топлива
                                                                     ELSE 0
                                                                END
                                      , inAmountFuel         := tmpRateFuel.AmountFuel
                                      , inColdHour           := 0
                                      , inAmountColdHour     := tmpRateFuel.AmountColdHour
                                      , inColdDistance       := 0
                                      , inAmountColdDistance := tmpRateFuel.AmountColdDistance
                                      , inFuel_Ratio         := ObjectFloat_Fuel_Ratio.ValueData
                                      , inRateFuelKindTax    := ObjectFloat_RateFuelKind_Tax.ValueData
                                       ) AS Amount_calc
                , zfCalc_RateFuelValue_Distance     (inDistance           := CASE WHEN ObjectLink_Car_FuelAll.DescId = zc_ObjectLink_Car_FuelMaster() THEN MovementItem_Master.Amount         -- если "Основной" вид топлива
                                                                                  WHEN ObjectLink_Car_FuelAll.DescId = zc_ObjectLink_Car_FuelChild() THEN MIFloat_DistanceFuelChild.ValueData -- если "Дополнительный" вид топлива
                                                                                  ELSE 0
                                                                             END
                                                   , inAmountFuel         := tmpRateFuel.AmountFuel
                                                   , inFuel_Ratio         := ObjectFloat_Fuel_Ratio.ValueData
                                                   , inRateFuelKindTax    := ObjectFloat_RateFuelKind_Tax.ValueData
                                                    ) AS Amount_Distance_calc
                , 0 AS Amount_ColdHour_calc
                , 0 AS Amount_ColdDistance_calc
    
                  -- если нормы нет, тогда признак по умолчанию считаем FALSE
                , CASE WHEN (tmpRateFuel.AmountFuel = 0) AND (tmpRateFuel.AmountColdHour = 0) AND (tmpRateFuel.AmountColdDistance = 0) THEN FALSE ELSE TRUE END AS isCalculated
                , CASE WHEN ObjectLink_Car_FuelAll.DescId = zc_ObjectLink_Car_FuelMaster() THEN TRUE ELSE FALSE END AS isMasterFuel
                , 0 AS ColdHour
                , 0 AS ColdDistance
    
                  -- Кол-во норма на 100 км, с учетом Коэффициента и % дополнительного расхода
                , zfCalc_RateFuelValue_Distance (inDistance           := 100
                                               , inAmountFuel         := tmpRateFuel.AmountFuel
                                               , inFuel_Ratio         := ObjectFloat_Fuel_Ratio.ValueData
                                               , inRateFuelKindTax    := ObjectFloat_RateFuelKind_Tax.ValueData
                                                ) AS AmountFuel
                  -- Холод, Кол-во норма в час, с учетом Коэффициента и % дополнительного расхода
                , zfCalc_RateFuelValue_ColdHour (inColdHour           := 1
                                               , inAmountColdHour     := tmpRateFuel.AmountColdHour
                                               , inFuel_Ratio         := ObjectFloat_Fuel_Ratio.ValueData
                                               , inRateFuelKindTax    := ObjectFloat_RateFuelKind_Tax.ValueData
                                                ) AS AmountColdHour
    
                  -- Холод, Кол-во норма на 100 км, с учетом Коэффициента и % дополнительного расхода
                , zfCalc_RateFuelValue_ColdDistance (inColdDistance       := 100
                                                   , inAmountColdDistance := tmpRateFuel.AmountColdDistance
                                                   , inFuel_Ratio         := ObjectFloat_Fuel_Ratio.ValueData
                                                   , inRateFuelKindTax    := ObjectFloat_RateFuelKind_Tax.ValueData
                                                    ) AS AmountColdDistance
                 
                , COALESCE (ObjectFloat_Fuel_Ratio.ValueData, 1)       AS RatioFuel        -- Коэффициента перевода нормы
                , COALESCE (ObjectFloat_RateFuelKind_Tax.ValueData, 0) AS RateFuelKindTax  -- % дополнительного расхода в связи с сезоном/температурой
                
                , Object_RateFuelKind.Id         AS RateFuelKindId
                , Object_RateFuelKind.ValueData  AS RateFuelKindName
    
                , ''   AS UnitName
                , ''   AS BranchName
    
                , FALSE AS isErased
                
            FROM (SELECT zc_ObjectLink_Car_FuelMaster() AS DescId UNION ALL SELECT zc_ObjectLink_Car_FuelChild() AS DescId) AS tmpDesc
                 -- выбрали автомобиль (он один)
                 JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = inMovementId
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
                 -- выбрали у автомобиля - все Виды топлива
                 JOIN ObjectLink AS ObjectLink_Car_FuelAll ON ObjectLink_Car_FuelAll.ObjectId = MovementLinkObject_Car.ObjectId
                                                          AND ObjectLink_Car_FuelAll.DescId = tmpDesc.DescId
                                                          AND ObjectLink_Car_FuelAll.ChildObjectId IS NOT NULL
                 LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = ObjectLink_Car_FuelAll.ChildObjectId
    
                 -- выбрали у Вида топлива - Коэффициент перевода нормы 
                 LEFT JOIN ObjectFloat AS ObjectFloat_Fuel_Ratio ON ObjectFloat_Fuel_Ratio.ObjectId = ObjectLink_Car_FuelAll.ChildObjectId
                                                                AND ObjectFloat_Fuel_Ratio.DescId = zc_ObjectFloat_Fuel_Ratio()
                                                                AND ObjectFloat_Fuel_Ratio.ValueData <> 0
    
                 -- выбрали у Вида топлива - Вид норм для топлива
                 LEFT JOIN ObjectLink AS ObjectLink_Fuel_RateFuelKind ON ObjectLink_Fuel_RateFuelKind.ObjectId = ObjectLink_Car_FuelAll.ChildObjectId
                                                                     AND ObjectLink_Fuel_RateFuelKind.DescId = zc_ObjectLink_Fuel_RateFuelKind()
                 LEFT JOIN Object AS Object_RateFuelKind ON Object_RateFuelKind.Id = ObjectLink_Fuel_RateFuelKind.ChildObjectId
                 -- выбрали у нормы для топлива - % дополнительного расхода в связи с сезоном/температурой
                 LEFT JOIN ObjectFloat AS ObjectFloat_RateFuelKind_Tax ON ObjectFloat_RateFuelKind_Tax.ObjectId = ObjectLink_Fuel_RateFuelKind.ChildObjectId
                                                                      AND ObjectFloat_RateFuelKind_Tax.DescId = zc_ObjectFloat_RateFuelKind_Tax()
                 -- выбрали все маршруты (нужен Пробег, км (основной вид топлива))
                 LEFT JOIN MovementItem AS MovementItem_Master ON MovementItem_Master.MovementId = inMovementId
                                                              AND MovementItem_Master.DescId = zc_MI_Master()
                 -- выбрали у маршрута свойство - Пробег, км (дополнительный вид топлива)
                 LEFT JOIN MovementItemFloat AS MIFloat_DistanceFuelChild
                                             ON MIFloat_DistanceFuelChild.MovementItemId = MovementItem_Master.Id
                                            AND MIFloat_DistanceFuelChild.DescId = zc_MIFloat_DistanceFuelChild()
                 -- этот нужен что б отбросить уже введенный вид топлива (если удален/не удален)
                 LEFT JOIN MovementItem AS MovementItem_Find ON MovementItem_Find.MovementId = inMovementId
                                                            AND MovementItem_Find.ParentId   = MovementItem_Master.Id
                                                            AND MovementItem_Find.ObjectId   = ObjectLink_Car_FuelAll.ChildObjectId
                                                            AND MovementItem_Find.DescId     = zc_MI_Child()
                                                            -- AND MovementItem_Find.isErased = FALSE
    
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
                                           AND tmpRateFuel.RouteKindId = COALESCE (MILinkObject_RouteKind.ObjectId, zc_Enum_RouteKind_Internal())
    
            WHERE MovementItem_Find.ObjectId IS NULL
          UNION ALL
            -- это для тех видов топлива, которые введены в документ
            SELECT 
                  MovementItem.Id
                , COALESCE (MIFloat_Number.ValueData, 0) AS Number
                , MovementItem.ObjectId     AS FuelId
                , Object_Fuel.ObjectCode    AS FuelCode
                , Object_Fuel.ValueData     AS FuelName
    
                , MovementItem.ParentId      AS ParentId
                , MovementItem.Amount        AS Amount
                  -- Расчитываем норму за все
                , zfCalc_RateFuelValue (inDistance           := CASE WHEN COALESCE (MIBoolean_MasterFuel.ValueData, FALSE) = TRUE  THEN MovementItem_Master.Amount          -- если "Основной" вид топлива
                                                                     WHEN COALESCE (MIBoolean_MasterFuel.ValueData, FALSE) = FALSE THEN MIFloat_DistanceFuelChild.ValueData -- если "Дополнительный" вид топлива
                                                                     ELSE 0
                                                                END
                                      , inAmountFuel         := MIFloat_AmountFuel.ValueData
                                      , inColdHour           := MIFloat_ColdHour.ValueData
                                      , inAmountColdHour     := MIFloat_AmountColdHour.ValueData
                                      , inColdDistance       := MIFloat_ColdDistance.ValueData
                                      , inAmountColdDistance := MIFloat_AmountColdDistance.ValueData
                                      , inFuel_Ratio         := 1 -- !!!Коэффициент перевода нормы уже учтен!!!
                                      , inRateFuelKindTax    := 0 -- !!!% дополнительного расхода в связи с сезоном/температурой уже учтен!!!
                                       ) AS Amount_calc
    
                , zfCalc_RateFuelValue_Distance     (inDistance           := CASE WHEN COALESCE (MIBoolean_MasterFuel.ValueData, FALSE) = TRUE  THEN MovementItem_Master.Amount          -- если "Основной" вид топлива
                                                                                  WHEN COALESCE (MIBoolean_MasterFuel.ValueData, FALSE) = FALSE THEN MIFloat_DistanceFuelChild.ValueData -- если "Дополнительный" вид топлива
                                                                                  ELSE 0
                                                                             END
                                                   , inAmountFuel         := MIFloat_AmountFuel.ValueData
                                                   , inFuel_Ratio         := 1 -- !!!Коэффициент перевода нормы уже учтен!!!
                                                   , inRateFuelKindTax    := 0 -- !!!% дополнительного расхода в связи с сезоном/температурой уже учтен!!!
                                                    ) AS Amount_Distance_calc
                , zfCalc_RateFuelValue_ColdHour     (inColdHour           := MIFloat_ColdHour.ValueData
                                                   , inAmountColdHour     := MIFloat_AmountColdHour.ValueData
                                                   , inFuel_Ratio         := 1 -- !!!Коэффициент перевода нормы уже учтен!!!
                                                   , inRateFuelKindTax    := 0 -- !!!% дополнительного расхода в связи с сезоном/температурой уже учтен!!!
                                                    ) AS Amount_ColdHour_calc
                , zfCalc_RateFuelValue_ColdDistance (inColdDistance       := MIFloat_ColdDistance.ValueData
                                                   , inAmountColdDistance := MIFloat_AmountColdDistance.ValueData
                                                   , inFuel_Ratio         := 1 -- !!!Коэффициент перевода нормы уже учтен!!!
                                                   , inRateFuelKindTax    := 0 -- !!!% дополнительного расхода в связи с сезоном/температурой уже учтен!!!
                                                    ) AS Amount_ColdDistance_calc
    
                , COALESCE (MIBoolean_Calculated.ValueData, TRUE)  AS isCalculated
                , COALESCE (MIBoolean_MasterFuel.ValueData, FALSE) AS isMasterFuel
    
                , MIFloat_ColdHour.ValueData            AS ColdHour
                , MIFloat_ColdDistance.ValueData        AS ColdDistance
    
                , MIFloat_AmountFuel.ValueData          AS AmountFuel         -- !!!Коэффициент и % дополнительного расхода уже учтены!!!
                , MIFloat_AmountColdHour.ValueData      AS AmountColdHour     -- !!!Коэффициент и % дополнительного расхода уже учтены!!!
                , MIFloat_AmountColdDistance.ValueData  AS AmountColdDistance -- !!!Коэффициент и % дополнительного расхода уже учтены!!!
    
                , COALESCE (ObjectFloat_Fuel_Ratio.ValueData, 1) AS RatioFuel        -- Коэффициента перевода нормы
                , MIFloat_RateFuelKindTax.ValueData              AS RateFuelKindTax  -- % дополнительного расхода в связи с сезоном/температурой
                
                , Object_RateFuelKind.Id         AS RateFuelKindId
                , Object_RateFuelKind.ValueData  AS RateFuelKindName
    
                , Object_Unit.ValueData    AS UnitName
                , Object_Branch.ValueData  AS BranchName
    
                , MovementItem.isErased
                
            FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased -- !!!Показываем Все!!!
                 JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                  AND MovementItem.DescId     = zc_MI_Child()
                                  AND MovementItem.isErased   = tmpIsErased.isErased
                 LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = MovementItem.ObjectId
    
                 -- выбрали Подразделение для затрат
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                  ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                 LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId
                 -- выбрали Филиал для затрат
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                  ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
                 LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = MILinkObject_Branch.ObjectId
    
                 -- выбрали автомобиль (он один)
                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                              ON MovementLinkObject_Car.MovementId = inMovementId
                                             AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
                 -- выбрали у автомобиля - Вид топлива
                 LEFT JOIN ObjectLink AS ObjectLink_Car_FuelAll ON ObjectLink_Car_FuelAll.ObjectId = MovementLinkObject_Car.ObjectId
                                                               AND ObjectLink_Car_FuelAll.ChildObjectId = MovementItem.ObjectId
                                                               AND ObjectLink_Car_FuelAll.DescId IN (zc_ObjectLink_Car_FuelMaster(), zc_ObjectLink_Car_FuelChild())
    
                 LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                               ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                              AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                 LEFT JOIN MovementItemBoolean AS MIBoolean_MasterFuel
                                               ON MIBoolean_MasterFuel.MovementItemId = MovementItem.Id
                                              AND MIBoolean_MasterFuel.DescId = zc_MIBoolean_MasterFuel()
    
                 LEFT JOIN MovementItemFloat AS MIFloat_ColdHour
                                             ON MIFloat_ColdHour.MovementItemId = MovementItem.Id
                                            AND MIFloat_ColdHour.DescId = zc_MIFloat_ColdHour()
                 LEFT JOIN MovementItemFloat AS MIFloat_ColdDistance
                                             ON MIFloat_ColdDistance.MovementItemId = MovementItem.Id
                                            AND MIFloat_ColdDistance.DescId = zc_MIFloat_ColdDistance()
    
                 LEFT JOIN MovementItemFloat AS MIFloat_AmountColdHour
                                             ON MIFloat_AmountColdHour.MovementItemId = MovementItem.Id
                                            AND MIFloat_AmountColdHour.DescId = zc_MIFloat_AmountColdHour()
                                            AND ObjectLink_Car_FuelAll.ChildObjectId IS NOT NULL
                 LEFT JOIN MovementItemFloat AS MIFloat_AmountColdDistance
                                             ON MIFloat_AmountColdDistance.MovementItemId = MovementItem.Id
                                            AND MIFloat_AmountColdDistance.DescId = zc_MIFloat_AmountColdDistance()
                                            AND ObjectLink_Car_FuelAll.ChildObjectId IS NOT NULL
                 LEFT JOIN MovementItemFloat AS MIFloat_AmountFuel
                                             ON MIFloat_AmountFuel.MovementItemId = MovementItem.Id
                                            AND MIFloat_AmountFuel.DescId = zc_MIFloat_AmountFuel()
                                            AND ObjectLink_Car_FuelAll.ChildObjectId IS NOT NULL
                 LEFT JOIN MovementItemFloat AS MIFloat_RateFuelKindTax
                                             ON MIFloat_RateFuelKindTax.MovementItemId = MovementItem.Id
                                            AND MIFloat_RateFuelKindTax.DescId = zc_MIFloat_RateFuelKindTax()
    
                 LEFT JOIN MovementItemFloat AS MIFloat_Number
                                             ON MIFloat_Number.MovementItemId = MovementItem.Id
                                            AND MIFloat_Number.DescId = zc_MIFloat_Number()
    
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_RateFuelKind
                                                  ON MILinkObject_RateFuelKind.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_RateFuelKind.DescId = zc_MILinkObject_RateFuelKind()
                 LEFT JOIN Object AS Object_RateFuelKind ON Object_RateFuelKind.Id = MILinkObject_RateFuelKind.ObjectId
    
                 LEFT JOIN MovementItem AS MovementItem_Master ON MovementItem_Master.Id = MovementItem.ParentId
                 -- выбрали у маршрута свойство - Пробег, км (дополнительный вид топлива)
                 LEFT JOIN MovementItemFloat AS MIFloat_DistanceFuelChild
                                             ON MIFloat_DistanceFuelChild.MovementItemId = MovementItem_Master.Id
                                            AND MIFloat_DistanceFuelChild.DescId = zc_MIFloat_DistanceFuelChild()
                 -- выбрали у Вида топлива - Коэффициент перевода нормы 
                 LEFT JOIN ObjectFloat AS ObjectFloat_Fuel_Ratio ON ObjectFloat_Fuel_Ratio.ObjectId = MovementItem.ObjectId
                                                                AND ObjectFloat_Fuel_Ratio.DescId = zc_ObjectFloat_Fuel_Ratio()
                                                                AND ObjectFloat_Fuel_Ratio.ValueData <> 0
          ;
           
        RETURN NEXT Cursor2;

    END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MI_Transport (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.01.19         * add RateSummaExp
 24.10.17         * add RateSummaAdd
 02.02.17         * add TaxiMore
 17.04.16         *
 10.12.13         * add WeightTransport, DistanceWeightTransport              
 02.12.13         * add Comment
 26.10.13                                        * add zc_MILinkObject_RouteKindFreight
 24.10.13                                        * add zfCalc_RateFuelValue_...
 13.10.13                                        * add ObjectLink_Car_FuelAll.ChildObjectId IS NOT NULL
 12.10.13                                        * add zc_ObjectFloat_Fuel_Ratio
 07.10.13                                        * add DistanceFuelChild and isMasterFuel
 04.10.13                                        * inIsErased
 01.10.13                                        * add zc_MIFloat_RateFuelKindTax and zfCalc_RateFuelValue
 29.09.13                                        *
 25.09.13         * add Cursor...; rename  TransportFuelOut- Transport             
*/

-- тест
-- SELECT * FROM gpSelect_MI_Transport (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MI_Transport (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
