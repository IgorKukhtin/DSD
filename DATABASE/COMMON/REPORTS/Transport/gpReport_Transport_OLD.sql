-- Function: gpReport_Transport ()

DROP FUNCTION IF EXISTS gpReport_Transport (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Transport (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Transport(
    IN inStartDate     TDateTime , -- 
    IN inEndDate       TDateTime , --
    IN inCarId         Integer   , --
    IN inBranchId      Integer   , -- филиал
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (InvNumberTransport Integer, OperDate TDateTime
             , BranchName TVarChar
             , CarModelName TVarChar, CarName TVarChar
             , PersonalDriverName TVarChar
             , RouteName TVarChar, RouteKindName TVarChar
             , RateFuelKindName TVarChar
             , FuelName TVarChar
             , DistanceFuel TFloat, RateFuelKindTax TFloat
             , Weight TFloat, WeightTransport TFloat
             , StartOdometre TFloat, EndOdometre TFloat
             , AmountFuel_Start TFloat, AmountFuel_In TFloat, AmountFuel_Out TFloat, AmountFuel_End TFloat
             , ColdHour TFloat, ColdDistance TFloat
             , AmountFuel TFloat, AmountColdHour TFloat, AmountColdDistance TFloat
             , Amount_Distance_calc TFloat, Amount_ColdHour_calc TFloat, Amount_ColdDistance_calc TFloat
              )
AS
$BODY$
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Transport());

      RETURN QUERY 
           -- Получили все Путевые листы по маршрутам
      WITH tmpTransport AS (SELECT Movement.Id AS MovementId
                                 , Movement.InvNumber
                                 , Movement.OperDate
                                 , MovementLinkObject_Car.ObjectId AS CarId
                                 , MovementLinkObject_PersonalDriver.ObjectId AS PersonalDriverId
                                 , MovementItem.Id AS MovementItemId
                                 , MovementItem.Amount AS DistanceFuelMaster
                                 , MovementItem.ObjectId AS RouteId
                                 , MILinkObject_RouteKind.ObjectId AS RouteKindId
                                 , MIFloat_Weight.ValueData          AS Weight
                                 , MIFloat_WeightTransport.ValueData AS WeightTransport
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
                                 LEFT JOIN MovementItemFloat AS MIFloat_Weight
                                                             ON MIFloat_Weight.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Weight.DescId = zc_MIFloat_Weight()
                                 LEFT JOIN MovementItemFloat AS MIFloat_WeightTransport
                                                             ON MIFloat_WeightTransport.MovementItemId = MovementItem.Id
                                                            AND MIFloat_WeightTransport.DescId = zc_MIFloat_WeightTransport()
                            WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                              AND Movement.DescId = zc_Movement_Transport()
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                           )

        SELECT zfConvert_StringToNumber (tmpFuel.InvNumber) AS InvNumberTransport
             , tmpFuel.OperDate
             , ViewObject_Unit.BranchName
             , Object_CarModel.ValueData        AS CarModelName
             , Object_Car.ValueData             AS CarName
             , View_PersonalDriver.PersonalName AS PersonalDriverName
             , Object_Route.ValueData           AS RouteName
             , Object_RouteKind.ValueData       AS RouteKindName
             , Object_RateFuelKind.ValueData    AS RateFuelKindName
             , Object_Fuel.ValueData            AS FuelName

             , SUM (tmpFuel.DistanceFuel)    :: TFloat AS DistanceFuel
             , MAX (tmpFuel.RateFuelKindTax) :: TFloat AS RateFuelKindTax

             , MAX (tmpFuel.Weight)          :: TFloat AS Weight
             , MAX (tmpFuel.WeightTransport) :: TFloat AS WeightTransport
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

              -- группировка по всем
        FROM (SELECT tmpAll.MovementId
                   , tmpAll.InvNumber
                   , tmpAll.OperDate
                   , tmpAll.CarId
                   , tmpAll.PersonalDriverId
                   , MAX (tmpAll.RouteId)         AS RouteId
                   , MAX (tmpAll.RouteKindId)     AS RouteKindId
                   , MAX (tmpAll.RateFuelKindId)  AS RateFuelKindId
                   , (tmpAll.FuelId)              AS FuelId

                   , SUM (tmpAll.DistanceFuel)    AS DistanceFuel
                   , MAX (tmpAll.RateFuelKindTax) AS RateFuelKindTax

                   , MAX (tmpAll.Weight)          AS Weight
                   , MAX (tmpAll.WeightTransport) AS WeightTransport
                   , MAX (tmpAll.StartOdometre)   AS StartOdometre
                   , MAX (tmpAll.EndOdometre)     AS EndOdometre

                   , SUM (tmpAll.AmountFuel_Start) AS AmountFuel_Start
                   , SUM (tmpAll.AmountFuel_In)    AS AmountFuel_In
                   , SUM (tmpAll.AmountFuel_Out)   AS AmountFuel_Out
                   , SUM (tmpAll.AmountFuel_Start + tmpAll.AmountFuel_In - tmpAll.AmountFuel_Out) AS AmountFuel_End

                   , SUM (tmpAll.ColdHour)     AS ColdHour
                   , SUM (tmpAll.ColdDistance) AS ColdDistance

                   , MAX (tmpAll.AmountFuel)         AS AmountFuel
                   , MAX (tmpAll.AmountColdHour)     AS AmountColdHour
                   , MAX (tmpAll.AmountColdDistance) AS AmountColdDistance

                   , SUM (tmpAll.Amount_Distance_calc)     AS Amount_Distance_calc
                   , SUM (tmpAll.Amount_ColdHour_calc)     AS Amount_ColdHour_calc
                   , SUM (tmpAll.Amount_ColdDistance_calc) AS Amount_ColdDistance_calc
              FROM
              -- 1. Маршруты
             (/*SELECT tmpTransport.MovementId
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

                   , COALESCE (MIFloat_StartOdometre.ValueData, 0) AS StartOdometre
                   , COALESCE (MIFloat_EndOdometre.ValueData, 0)   AS EndOdometre
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
             UNION ALL*/
              -- 2.1. Начальный остаток (!!!расчетный!!!) + Расход топлива
              SELECT tmpTransport.MovementId
                   , tmpTransport.InvNumber
                   , tmpTransport.OperDate
                   , tmpTransport.CarId
                   , tmpTransport.PersonalDriverId
                   , tmpTransport.RouteId
                   , tmpTransport.RouteKindId
                   , MILinkObject_RateFuelKind.ObjectId AS RateFuelKindId
                   , COALESCE (Container.ObjectId, MI.ObjectId) AS FuelId

                   , CASE WHEN COALESCE (MIBoolean_MasterFuel.ValueData, FALSE) = TRUE THEN tmpTransport.DistanceFuelMaster ELSE COALESCE (MIFloat_DistanceFuelChild.ValueData) END AS DistanceFuel
                   , COALESCE (MIFloat_RateFuelKindTax.ValueData, 0)  AS RateFuelKindTax

--                   , 0 AS StartOdometre
--                   , 0 AS EndOdometre

                   , tmpTransport.Weight
                   , tmpTransport.WeightTransport

                   , COALESCE (MIFloat_StartOdometre.ValueData, 0) AS StartOdometre
                   , COALESCE (MIFloat_EndOdometre.ValueData, 0)   AS EndOdometre

                   , COALESCE (MIFloat_StartAmountFuel.ValueData, 0) AS AmountFuel_Start
                   , 0 AS AmountFuel_In
                   , -1 * COALESCE (MIContainer.Amount, 0) AS AmountFuel_Out

                   , COALESCE (MIFloat_ColdHour.ValueData, 0)     AS ColdHour
                   , COALESCE (MIFloat_ColdDistance.ValueData, 0) AS ColdDistance

                   , COALESCE (MIFloat_AmountFuel.ValueData, 0)         AS AmountFuel
                   , COALESCE (MIFloat_AmountColdHour.ValueData, 0)     AS AmountColdHour
                   , COALESCE (MIFloat_AmountColdDistance.ValueData, 0) AS AmountColdDistance

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
                   LEFT JOIN MovementItemFloat AS MIFloat_StartOdometre
                                               ON MIFloat_StartOdometre.MovementItemId = tmpTransport.MovementItemId
                                              AND MIFloat_StartOdometre.DescId = zc_MIFloat_StartOdometre()
                   LEFT JOIN MovementItemFloat AS MIFloat_EndOdometre
                                               ON MIFloat_EndOdometre.MovementItemId = tmpTransport.MovementItemId
                                              AND MIFloat_EndOdometre.DescId = zc_MIFloat_EndOdometre()


                   JOIN MovementItem AS MI ON MI.ParentId = tmpTransport.MovementItemId
                                          AND MI.DescId   = zc_MI_Child()
                                          AND MI.isErased   = FALSE
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
             UNION ALL
              -- 2.2. Приход топлива
              SELECT Movement.ParentId AS MovementId
                   , Movement_Transport.InvNumber
                   , Movement.OperDate
                   , ContainerLO_Car.ObjectId AS CarId
                   , MovementLinkObject_PersonalDriver.ObjectId AS PersonalDriverId
                   , MovementLinkObject_Route.ObjectId AS RouteId
                   , 0 AS RouteKindId
                   , 0 AS RateFuelKindId
                   , Container.ObjectId AS FuelId

                   , 0 AS DistanceFuel
                   , 0 AS RateFuelKindTax

                   , 0 AS Weight
                   , 0 AS WeightTransport
                   , 0 AS StartOdometre
                   , 0 AS EndOdometre
                   , 0 AS AmountFuel_Start
                   , MIContainer.Amount AS AmountFuel_In
                   , 0 AS AmountFuel_Out

                   , 0 AS ColdHour
                   , 0 AS ColdDistance

                   , 0 AS AmountFuel
                   , 0 AS AmountColdHour
                   , 0 AS AmountColdDistance

                   , 0 AS Amount_Distance_calc
                   , 0 AS Amount_ColdHour_calc
                   , 0 AS Amount_ColdDistance_calc
              FROM Movement
                   JOIN MovementItemContainer AS MIContainer
                                              ON MIContainer.MovementId = Movement.Id
                                             AND MIContainer.DescId = zc_MIContainer_Count()
                   -- так ограничили приходы только на Автомобиль
                   JOIN ContainerLinkObject AS ContainerLO_Car
                                            ON ContainerLO_Car.ContainerId = MIContainer.ContainerId
                                           AND ContainerLO_Car.DescId = zc_ContainerLinkObject_Car()
                                           AND ContainerLO_Car.ObjectId > 0
                   LEFT JOIN Container ON Container.Id = MIContainer.ContainerId

                   LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                                ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                               AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                                ON MovementLinkObject_Route.MovementId = Movement.Id
                                               AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()

                   LEFT JOIN Movement AS Movement_Transport
                                      ON Movement_Transport.Id     = Movement.ParentId
                                     AND Movement_Transport.DescId = zc_Movement_Transport()
              WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                AND Movement.DescId = zc_Movement_Income()
                AND Movement.StatusId = zc_Enum_Status_Complete()

             ) AS tmpAll
              GROUP BY tmpAll.MovementId
                     , tmpAll.InvNumber
                     , tmpAll.OperDate
                     , tmpAll.CarId
                     , tmpAll.PersonalDriverId
                     , tmpAll.FuelId
                     , tmpAll.RouteId

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

             -- ограничиваем по филиалу, если нужно
             LEFT JOIN ObjectLink AS ObjectLink_Car_Unit 
                             ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id
                            AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
             LEFT JOIN Object_Unit_View AS ViewObject_Unit
                                   ON ViewObject_Unit.Id = ObjectLink_Car_Unit.ChildObjectId
        WHERE COALESCE (ViewObject_Unit.BranchId, 0) = inBranchId 
           OR inBranchId = 0 
           OR (inBranchId = zc_Branch_Basis() AND COALESCE (ViewObject_Unit.BranchId, 0) = 0)   

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
               , ViewObject_Unit.BranchName
       ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_Transport (TDateTime, TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.07.14                                       * add Weight and WeightTransport
 09.02.14         * ограничения для zc_Branch_Basis()
 12.12.13         * add inBranchId     
 28.10.13                                        *
 05.10.13         *
*/

-- тест
-- SELECT * FROM gpReport_Transport (inStartDate:= '01.01.2014', inEndDate:= '31.01.2014', inCarId:= null,  inBranchId:= 1, inSession:= zfCalc_UserAdmin());
