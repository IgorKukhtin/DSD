-- Function: gpReport_Transport ()

DROP FUNCTION IF EXISTS gpReport_Transport (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Transport(
    IN inStartDate     TDateTime , -- 
    IN inEndDate       TDateTime , --
    IN inCarId         Integer   , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (InvNumberTransport Integer, OperDate TDateTime
             , CarModelName TVarChar, CarName TVarChar
             , PersonalDriverName TVarChar
             , RouteName TVarChar, RouteKindName TVarChar
             , RateFuelKindName TVarChar
             , FuelName TVarChar
             , DistanceFuel TFloat, RateFuelKindTax TFloat
             , StartOdometre TFloat, EndOdometre TFloat
--             , AmountCash_Start TFloat, AmountCash_In TFloat, AmountCash_Out TFloat, AmountCash_End TFloat
             , AmountFuel_Start TFloat, AmountFuel_In TFloat, AmountFuel_Out TFloat, AmountFuel_End TFloat
--             , AmountTicketFuel_Start TFloat, AmountTicketFuel_In TFloat, AmountTicketFuel_Out TFloat, AmountTicketFuel_End TFloat
             , ColdHour TFloat, ColdDistance TFloat
             , AmountFuel TFloat, AmountColdHour TFloat, AmountColdDistance TFloat
             , Amount_Distance_calc TFloat, Amount_ColdHour_calc TFloat, Amount_ColdDistance_calc TFloat
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Transport());
/*
     -- таблица - 
RETURN QUERY 
       SELECT cast ('01.01.2013' as TDateTime) 
            , cast (1 as integer) as  RouteId, cast (1 as integer) as RouteCode, cast ('Маршрут' as TVarChar) as RouteName
            , cast (1 as integer) as PersonalDriverId, cast (1 as integer) as PersonalDriverCode, cast('Водитель 111' as TVarChar) as PersonalDriverName
            , cast (120 as Tfloat), cast (150 as Tfloat), cast (140 as Tfloat), cast (130 as Tfloat)
            , cast (400 as Tfloat), cast (500 as Tfloat), cast (450 as Tfloat), cast (480 as Tfloat) 
            , cast (450 as Tfloat), cast (480 as Tfloat) 
            , cast ('InvNumberPersonalSendCash' as TVarChar) asInvNumberPersonalSendCash
            , cast (120 as Tfloat), cast (120 as Tfloat), cast (120 as Tfloat)
            , cast ('invNumberIncome' as TVarChar)
            , cast (120 as Tfloat), cast (120 as Tfloat)
*/


      RETURN QUERY 
     -- Получили все Путевые листы
     WITH tmpTransport AS (SELECT Movement.Id AS MovementId
                                , Movement.InvNumber
                                , Movement.OperDate
                                , MovementLinkObject_Car.ObjectId AS CarId
                                , MovementLinkObject_PersonalDriver.ObjectId AS PersonalDriverId
                                , MovementItem.Id AS MovementItemId
                                , MovementItem.Amount AS DistanceFuelMaster
                                , MovementItem.ObjectId AS RouteId
                                , MILinkObject_RouteKind.ObjectId AS RouteKindId
                           FROM Movement
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                                             ON MovementLinkObject_Car.MovementId = Movement.Id
                                                            AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                                             ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                                            AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
                                LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_RouteKind
                                                                 ON MILinkObject_RouteKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_RouteKind.DescId = zc_MILinkObject_RouteKind()
                           WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                             AND Movement.DescId = zc_Movement_Transport()
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                           )
        SELECT zfConvert_StringToNumber (tmpFuel.InvNumber) AS InvNumberTransport
             , tmpFuel.OperDate
             , Object_CarModel.ValueData        AS CarModelName
             , Object_Car.ValueData             AS CarName
             , View_PersonalDriver.PersonalName AS PersonalDriverName
             , Object_Route.ValueData           AS RouteName
             , Object_RouteKind.ValueData       AS RouteKindName
             , Object_RateFuelKind.ValueData    AS RateFuelKindName
             , Object_Fuel.ValueData            AS FuelName

             , SUM (tmpFuel.DistanceFuel)    :: TFloat AS DistanceFuel
             , MAX (tmpFuel.RateFuelKindTax) :: TFloat AS RateFuelKindTax

             , MAX (tmpFuel.StartOdometre)   :: TFloat AS StartOdometre
             , MAX (tmpFuel.EndOdometre)     :: TFloat AS EndOdometre

             , SUM (tmpFuel.AmountFuel_Start)        :: TFloat AS AmountFuel_Start
             , SUM (tmpFuel.AmountFuel_In)           :: TFloat AS AmountFuel_In
             , SUM (tmpFuel.AmountFuel_Out)          :: TFloat AS AmountFuel_Out
             , SUM (tmpFuel.AmountFuel_Start + tmpFuel.AmountFuel_In - tmpFuel.AmountFuel_Out) :: TFloat AS AmountFuel_End

             , SUM (tmpFuel.ColdHour)     :: TFloat AS ColdHour
             , SUM (tmpFuel.ColdDistance) :: TFloat AS ColdDistance

             , MAX (tmpFuel.AmountFuel)         :: TFloat AS AmountFuel
             , MAX (tmpFuel.AmountColdHour)     :: TFloat AS AmountColdHour
             , MAX (tmpFuel.AmountColdDistance) :: TFloat AS AmountColdDistance

             , SUM (tmpFuel.Amount_Distance_calc)     :: TFloat AS Amount_Distance_calc
             , SUM (tmpFuel.Amount_ColdHour_calc)     :: TFloat AS Amount_ColdHour_calc
             , SUM (tmpFuel.Amount_ColdDistance_calc) :: TFloat AS Amount_ColdDistance_calc

              -- 2. Топливо
        FROM (SELECT tmpFuel_All.MovementId
                   , tmpFuel_All.InvNumber
                   , tmpFuel_All.OperDate
                   , tmpFuel_All.CarId
                   , tmpFuel_All.PersonalDriverId
                   , tmpFuel_All.RouteId
                   , tmpFuel_All.RouteKindId
                   , MAX (tmpFuel_All.RateFuelKindId)  AS RateFuelKindId
                   , MAX (tmpFuel_All.FuelId)          AS FuelId

                   , SUM (tmpFuel_All.DistanceFuel)    AS DistanceFuel
                   , MAX (tmpFuel_All.RateFuelKindTax) AS RateFuelKindTax

                   , MAX (tmpFuel_All.StartOdometre) AS StartOdometre
                   , MAX (tmpFuel_All.EndOdometre)   AS EndOdometre

                   , SUM (tmpFuel_All.AmountFuel_Start) AS AmountFuel_Start
                   , SUM (tmpFuel_All.AmountFuel_In)    AS AmountFuel_In
                   , SUM (tmpFuel_All.AmountFuel_Out)   AS AmountFuel_Out
                   , SUM (tmpFuel_All.AmountFuel_Start + tmpFuel_All.AmountFuel_In - tmpFuel_All.AmountFuel_Out) AS AmountFuel_End

                   , SUM (tmpFuel_All.ColdHour)     AS ColdHour
                   , SUM (tmpFuel_All.ColdDistance) AS ColdDistance

                   , MAX (tmpFuel_All.AmountFuel)         AS AmountFuel
                   , MAX (tmpFuel_All.AmountColdHour)     AS AmountColdHour
                   , MAX (tmpFuel_All.AmountColdDistance) AS AmountColdDistance

                   , SUM (tmpFuel_All.Amount_Distance_calc)     AS Amount_Distance_calc
                   , SUM (tmpFuel_All.Amount_ColdHour_calc)     AS Amount_ColdHour_calc
                   , SUM (tmpFuel_All.Amount_ColdDistance_calc) AS Amount_ColdDistance_calc
              FROM
             (SELECT tmpTransport.MovementId
                   , tmpTransport.InvNumber
                   , tmpTransport.OperDate
                   , tmpTransport.CarId
                   , tmpTransport.PersonalDriverId
                   , tmpTransport.RouteId
                   , tmpTransport.RouteKindId
                   , 0 AS RateFuelKindId
                   , 0 AS FuelId

                   , 0 AS DistanceFuel
                   , 0 AS RateFuelKindTax

                   , MIFloat_StartOdometre.ValueData AS StartOdometre
                   , MIFloat_EndOdometre.ValueData   AS EndOdometre
                   , 0 AS AmountFuel_Start
                   , 0 AS AmountFuel_In
                   , 0 AS AmountFuel_Out

                   , 0 AS ColdHour
                   , 0 AS ColdDistance

                   , 0 AS AmountFuel
                   , 0 AS AmountColdHour
                   , 0 AS AmountColdDistance

                   , 0 AS Amount_Distance_calc
                   , 0 AS Amount_ColdHour_calc
                   , 0 AS Amount_ColdDistance_calc

              FROM tmpTransport
                   LEFT JOIN MovementItemFloat AS MIFloat_StartOdometre
                                               ON MIFloat_StartOdometre.MovementItemId = tmpTransport.MovementItemId
                                              AND MIFloat_StartOdometre.DescId = zc_MIFloat_StartOdometre()
                   LEFT JOIN MovementItemFloat AS MIFloat_EndOdometre
                                               ON MIFloat_EndOdometre.MovementItemId = tmpTransport.MovementItemId
                                              AND MIFloat_EndOdometre.DescId = zc_MIFloat_EndOdometre()
             UNION ALL
              SELECT tmpTransport.MovementId
                   , tmpTransport.InvNumber
                   , tmpTransport.OperDate
                   , tmpTransport.CarId
                   , tmpTransport.PersonalDriverId
                   , tmpTransport.RouteId
                   , tmpTransport.RouteKindId
                   , MILinkObject_RateFuelKind.ObjectId AS RateFuelKindId
                   , COALESCE (Container.ObjectId, MI.ObjectId) AS FuelId

                   , CASE WHEN COALESCE (MIBoolean_MasterFuel.ValueData, FALSE) = TRUE THEN COALESCE (MIFloat_DistanceFuelChild.ValueData) ELSE tmpTransport.DistanceFuelMaster END AS DistanceFuel
                   , MIFloat_RateFuelKindTax.ValueData  AS RateFuelKindTax

                   , 0 AS StartOdometre
                   , 0 AS EndOdometre
                   , COALESCE (MIFloat_StartAmountFuel.ValueData, 0) AS AmountFuel_Start
                   , 0 AS AmountFuel_In
                   , -1 * MIContainer.Amount AS AmountFuel_Out

                   , MIFloat_ColdHour.ValueData     AS ColdHour
                   , MIFloat_ColdDistance.ValueData AS ColdDistance

                   , MIFloat_AmountFuel.ValueData         AS AmountFuel
                   , MIFloat_AmountColdHour.ValueData     AS AmountColdHour
                   , MIFloat_AmountColdDistance.ValueData AS AmountColdDistance

                   , zfCalc_RateFuelValue_Distance     (inDistance           := CASE WHEN COALESCE (MIBoolean_MasterFuel.ValueData, FALSE) = TRUE  THEN tmpTransport.DistanceFuelMaster     -- если "Основной" вид топлива
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
              FROM tmpTransport
                   JOIN MovementItem AS MI ON MI.ParentId = tmpTransport.MovementItemId
                                          AND MI.DescId   = zc_MI_Child()
                   LEFT JOIN MovementItemContainer AS MIContainer
                                                   ON MIContainer.MovementItemId = MI.Id
                                                  AND MIContainer.DescId = zc_MIContainer_Count()
                   LEFT JOIN Container ON Container.Id = MIContainer.ContainerId

                   LEFT JOIN MovementItemBoolean AS MIBoolean_MasterFuel
                                                 ON MIBoolean_MasterFuel.MovementItemId = MI.Id
                                                AND MIBoolean_MasterFuel.DescId = zc_MIBoolean_MasterFuel()

                   LEFT JOIN MovementItemFloat AS MIFloat_StartAmountFuel
                                               ON MIFloat_StartAmountFuel.MovementItemId = MI.Id
                                              AND MIFloat_StartAmountFuel.DescId = zc_MIFloat_StartAmountFuel()

                   LEFT JOIN MovementItemFloat AS MIFloat_ColdHour
                                               ON MIFloat_ColdHour.MovementItemId = MI.Id
                                              AND MIFloat_ColdHour.DescId = zc_MIFloat_ColdHour()
                   LEFT JOIN MovementItemFloat AS MIFloat_ColdDistance
                                               ON MIFloat_ColdDistance.MovementItemId = MI.Id
                                              AND MIFloat_ColdDistance.DescId = zc_MIFloat_ColdDistance()

                   LEFT JOIN MovementItemFloat AS MIFloat_AmountColdHour
                                               ON MIFloat_AmountColdHour.MovementItemId = MI.Id
                                              AND MIFloat_AmountColdHour.DescId = zc_MIFloat_AmountColdHour()
                   LEFT JOIN MovementItemFloat AS MIFloat_AmountColdDistance
                                               ON MIFloat_AmountColdDistance.MovementItemId = MI.Id
                                              AND MIFloat_AmountColdDistance.DescId = zc_MIFloat_AmountColdDistance()
                   LEFT JOIN MovementItemFloat AS MIFloat_AmountFuel
                                               ON MIFloat_AmountFuel.MovementItemId = MI.Id
                                              AND MIFloat_AmountFuel.DescId = zc_MIFloat_AmountFuel()

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_RateFuelKind
                                                    ON MILinkObject_RateFuelKind.MovementItemId = MI.Id
                                                   AND MILinkObject_RateFuelKind.DescId = zc_MILinkObject_RateFuelKind()
                   LEFT JOIN MovementItemFloat AS MIFloat_RateFuelKindTax
                                               ON MIFloat_RateFuelKindTax.MovementItemId = MI.Id
                                              AND MIFloat_RateFuelKindTax.DescId = zc_MIFloat_RateFuelKindTax()

                   LEFT JOIN MovementItemFloat AS MIFloat_DistanceFuelChild
                                               ON MIFloat_DistanceFuelChild.MovementItemId = tmpTransport.MovementItemId
                                              AND MIFloat_DistanceFuelChild.DescId = zc_MIFloat_DistanceFuelChild()
--              WHERE 
             ) AS tmpFuel_All
              GROUP BY tmpFuel_All.MovementId
                     , tmpFuel_All.InvNumber
                     , tmpFuel_All.OperDate
                     , tmpFuel_All.CarId
                     , tmpFuel_All.PersonalDriverId
                     , tmpFuel_All.RouteId
                     , tmpFuel_All.RouteKindId
             ) AS tmpFuel
             LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpFuel.CarId
             LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                            AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
             LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId
             LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = tmpFuel.PersonalDriverId
             LEFT JOIN Object AS Object_Route ON Object_Route.Id = tmpFuel.RouteId
             LEFT JOIN Object AS Object_RouteKind ON Object_RouteKind.Id = tmpFuel.RouteKindId
             LEFT JOIN Object AS Object_RateFuelKind ON Object_RateFuelKind.Id = tmpFuel.RateFuelKindId
             LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = tmpFuel.FuelId

        GROUP BY tmpFuel.MovementId
               , tmpFuel.InvNumber
               , tmpFuel.OperDate
               , Object_CarModel.ValueData
               , Object_Car.ValueData
               , View_PersonalDriver.PersonalName
               , Object_Route.ValueData
               , Object_RouteKind.ValueData
               , Object_RateFuelKind.ValueData
               , Object_Fuel.ValueData
       ;


END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_Transport (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.10.13                                        *
 05.10.13         *
*/

-- тест
-- SELECT * FROM gpReport_Transport (inStartDate:= '01.10.2013', inEndDate:= '31.10.2013', inCarId:= null, inSession:= '2');
