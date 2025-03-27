-- Function: gpReport_Transport ()

DROP FUNCTION IF EXISTS gpReport_Transport (TDateTime, TDateTime, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_Transport (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Transport (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Transport(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inCarId         Integer   , --
    IN inBranchId      Integer   , -- филиал  
    IN inisMonth       Boolean   , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumberTransport Integer, OperDate TDateTime
             , BranchName TVarChar, UnitName_car TVarChar, UnitName_route TVarChar
             , CarModelName TVarChar, CarName TVarChar
             , PersonalDriverId Integer, PersonalDriverName TVarChar, PositionName TVarChar, PositionLevelName TVarChar
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
             , SumTransportAdd TFloat, SumTransportAddLong TFloat, SumTransportTaxi TFloat, SumRateExp TFloat
             , CountDoc_Reestr TFloat, CountDoc_Reestr_zp TFloat
             , TotalCountKg_Reestr TFloat, TotalCountKg_Reestr_zp TFloat, InvNumber_Reestr TVarChar
             , RouteName_order TVarChar

             , PartnerCount TFloat
             , HoursWork TFloat
             , HoursStop TFloat
             , HoursMove TFloat
             , HoursPartner_all  TFloat -- общее время в точках
             , HoursPartner      TFloat -- время в точке, часов
             , Speed     TFloat
             , CommentStop TVarChar
             , PersonalServiceListName_find TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Transport());
      vbUserId:= lpGetUserBySession (inSession);

      -- !!!Только просмотр Аудитор!!!
      PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

      RETURN QUERY
           -- Получили все Путевые листы по маршрутам
      WITH
           tmpTransport AS (SELECT Movement.Id AS MovementId
                                 , Movement.InvNumber
                                 , Movement.OperDate
                                 , MovementLinkObject_Car.ObjectId AS CarId
                                 , MovementLinkObject_PersonalDriver.ObjectId AS PersonalDriverId
                                 , MovementItem.Id AS MovementItemId_calc
                                 -- , MovementItem.Amount AS DistanceFuelMaster

                                 , ROW_NUMBER() OVER (PARTITION BY MovementItem.Id
                                                      ORDER BY CASE WHEN MIBoolean_MasterFuel.ValueData = TRUE AND MIContainer.Amount <> 0
                                                                         THEN 1
                                                                    WHEN MIContainer.Amount <> 0
                                                                         THEN 2
                                                                    WHEN MIBoolean_MasterFuel.ValueData = TRUE
                                                                         THEN 3
                                                                    ELSE 4
                                                               END
                                                     ) AS Ord

                                 , CASE WHEN MIBoolean_MasterFuel.ValueData = TRUE THEN MovementItem.Amount ELSE COALESCE (MIFloat_DistanceFuelChild.ValueData) END AS DistanceFuel

                                 , MovementItem.ObjectId AS RouteId
                                 , MILinkObject_RouteKind.ObjectId AS RouteKindId

                                 -- , MIFloat_Weight.ValueData          AS Weight
                                 -- , MIFloat_WeightTransport.ValueData AS WeightTransport
                                 , CASE WHEN ROW_NUMBER() OVER (PARTITION BY MovementItem.Id
                                                      ORDER BY CASE WHEN MIBoolean_MasterFuel.ValueData = TRUE AND MIContainer.Amount <> 0
                                                                         THEN 1
                                                                    WHEN MIContainer.Amount <> 0
                                                                         THEN 2
                                                                    WHEN MIBoolean_MasterFuel.ValueData = TRUE
                                                                         THEN 3
                                                                    ELSE 4
                                                               END
                                                     ) = 1
                                             THEN MIFloat_Weight.ValueData          ELSE 0 END AS Weight
                                 , CASE WHEN ROW_NUMBER() OVER (PARTITION BY MovementItem.Id
                                                      ORDER BY CASE WHEN MIBoolean_MasterFuel.ValueData = TRUE AND MIContainer.Amount <> 0
                                                                         THEN 1
                                                                    WHEN MIContainer.Amount <> 0
                                                                         THEN 2
                                                                    WHEN MIBoolean_MasterFuel.ValueData = TRUE
                                                                         THEN 3
                                                                    ELSE 4
                                                               END
                                                     ) = 1
                                             THEN MIFloat_WeightTransport.ValueData ELSE 0 END AS WeightTransport

                                 , CASE WHEN ROW_NUMBER() OVER (PARTITION BY MovementItem.Id
                                                      ORDER BY CASE WHEN MIBoolean_MasterFuel.ValueData = TRUE AND MIContainer.Amount <> 0
                                                                         THEN 1
                                                                    WHEN MIContainer.Amount <> 0
                                                                         THEN 2
                                                                    WHEN MIBoolean_MasterFuel.ValueData = TRUE
                                                                         THEN 3
                                                                    ELSE 4
                                                               END
                                                     ) = 1
                                             THEN COALESCE (MIFloat_RateSumma.ValueData, 0) ELSE 0 END AS SumTransportAdd

                                 , CASE WHEN ROW_NUMBER() OVER (PARTITION BY MovementItem.Id
                                                      ORDER BY CASE WHEN MIBoolean_MasterFuel.ValueData = TRUE AND MIContainer.Amount <> 0
                                                                         THEN 1
                                                                    WHEN MIContainer.Amount <> 0
                                                                         THEN 2
                                                                    WHEN MIBoolean_MasterFuel.ValueData = TRUE
                                                                         THEN 3
                                                                    ELSE 4
                                                               END
                                                     ) = 1
                                             THEN COALESCE (MIFloat_RatePrice.ValueData, 0) * (COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_DistanceFuelChild.ValueData, 0))
                                                + COALESCE (MIFloat_RateSummaAdd.ValueData, 0)
                                        ELSE 0 END AS SumTransportAddLong
                                 , CASE WHEN ROW_NUMBER() OVER (PARTITION BY MovementItem.Id
                                                      ORDER BY CASE WHEN MIBoolean_MasterFuel.ValueData = TRUE AND MIContainer.Amount <> 0
                                                                         THEN 1
                                                                    WHEN MIContainer.Amount <> 0
                                                                         THEN 2
                                                                    WHEN MIBoolean_MasterFuel.ValueData = TRUE
                                                                         THEN 3
                                                                    ELSE 4
                                                               END
                                                     ) = 1
                                             THEN COALESCE (MIFloat_Taxi.ValueData, 0) ELSE 0 END AS SumTransportTaxi

                                 , CASE WHEN COALESCE (MovementLinkObject_Personal.ObjectId, 0) = 0
                                        THEN CASE WHEN ROW_NUMBER() OVER (PARTITION BY MovementItem.Id
                                                                          ORDER BY CASE WHEN MIBoolean_MasterFuel.ValueData = TRUE AND MIContainer.Amount <> 0
                                                                                             THEN 1
                                                                                        WHEN MIContainer.Amount <> 0
                                                                                             THEN 2
                                                                                        WHEN MIBoolean_MasterFuel.ValueData = TRUE
                                                                                             THEN 3
                                                                                        ELSE 4
                                                                                   END
                                                                         ) = 1
                                                  THEN COALESCE (MIFloat_RateSummaExp.ValueData, 0) ELSE 0 END
                                        ELSE 0
                                   END AS SumRateExp

                                 , CASE WHEN ROW_NUMBER() OVER (PARTITION BY MovementItem.Id
                                                      ORDER BY CASE WHEN MIBoolean_MasterFuel.ValueData = TRUE AND MIContainer.Amount <> 0
                                                                         THEN 1
                                                                    WHEN MIContainer.Amount <> 0
                                                                         THEN 2
                                                                    WHEN MIBoolean_MasterFuel.ValueData = TRUE
                                                                         THEN 3
                                                                    ELSE 4
                                                               END
                                                     ) = 1
                                             THEN COALESCE (MIFloat_StartOdometre.ValueData, 0) ELSE 0 END AS StartOdometre
                                 , CASE WHEN ROW_NUMBER() OVER (PARTITION BY MovementItem.Id
                                                      ORDER BY CASE WHEN MIBoolean_MasterFuel.ValueData = TRUE AND MIContainer.Amount <> 0
                                                                         THEN 1
                                                                    WHEN MIContainer.Amount <> 0
                                                                         THEN 2
                                                                    WHEN MIBoolean_MasterFuel.ValueData = TRUE
                                                                         THEN 3
                                                                    ELSE 4
                                                               END
                                                     ) = 1
                                             THEN COALESCE (MIFloat_EndOdometre.ValueData, 0) ELSE 0 END AS EndOdometre

                                 , MILinkObject_RateFuelKind.ObjectId AS RateFuelKindId
                                 , COALESCE (MIContainer.ObjectId_Analyzer, MI.ObjectId) AS FuelId

                                 , COALESCE (MIFloat_RateFuelKindTax.ValueData, 0)  AS RateFuelKindTax

                                 , COALESCE (MIFloat_StartAmountFuel.ValueData, 0) AS AmountFuel_Start
                                 , -1 * COALESCE (MIContainer.Amount, 0) AS AmountFuel_Out

                                 , COALESCE (MIFloat_ColdHour.ValueData, 0)     AS ColdHour
                                 , COALESCE (MIFloat_ColdDistance.ValueData, 0) AS ColdDistance

                                 , COALESCE (MIFloat_AmountFuel.ValueData, 0)         AS AmountFuel
                                 , COALESCE (MIFloat_AmountColdHour.ValueData, 0)     AS AmountColdHour
                                 , COALESCE (MIFloat_AmountColdDistance.ValueData, 0) AS AmountColdDistance

                                 , zfCalc_RateFuelValue_Distance     (inDistance           := CASE WHEN COALESCE (MIBoolean_MasterFuel.ValueData, FALSE) = TRUE  THEN MovementItem.Amount                 -- если "Основной" вид топлива
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

                            FROM Movement
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                                              ON MovementLinkObject_Car.MovementId = Movement.Id
                                                             AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                                              ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                                             AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                                              ON MovementLinkObject_Personal.MovementId = Movement.Id
                                                             AND MovementLinkObject_Personal.DescId     = zc_MovementLinkObject_Personal()
                                                             --AND MovementLinkObject_Personal.ObjectId   > 0

                                 LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE

                                 LEFT JOIN MovementItemFloat AS MIFloat_StartOdometre
                                                             ON MIFloat_StartOdometre.MovementItemId = MovementItem.Id
                                                            AND MIFloat_StartOdometre.DescId = zc_MIFloat_StartOdometre()
                                 LEFT JOIN MovementItemFloat AS MIFloat_EndOdometre
                                                             ON MIFloat_EndOdometre.MovementItemId = MovementItem.Id
                                                            AND MIFloat_EndOdometre.DescId = zc_MIFloat_EndOdometre()

                                 LEFT JOIN MovementItemFloat AS MIFloat_RateSumma
                                                             ON MIFloat_RateSumma.MovementItemId =  MovementItem.Id
                                                            AND MIFloat_RateSumma.DescId = zc_MIFloat_RateSumma()
                                 LEFT JOIN MovementItemFloat AS MIFloat_RatePrice
                                                             ON MIFloat_RatePrice.MovementItemId =  MovementItem.Id
                                                            AND MIFloat_RatePrice.DescId = zc_MIFloat_RatePrice()
                                 LEFT JOIN MovementItemFloat AS MIFloat_RateSummaAdd
                                                             ON MIFloat_RateSummaAdd.MovementItemId =  MovementItem.Id
                                                            AND MIFloat_RateSummaAdd.DescId = zc_MIFloat_RateSummaAdd()
                                 LEFT JOIN MovementItemFloat AS MIFloat_RateSummaExp
                                                             ON MIFloat_RateSummaExp.MovementItemId =  MovementItem.Id
                                                            AND MIFloat_RateSummaExp.DescId = zc_MIFloat_RateSummaExp()
                                 LEFT JOIN MovementItemFloat AS MIFloat_Taxi
                                                             ON MIFloat_Taxi.MovementItemId =  MovementItem.Id
                                                            AND MIFloat_Taxi.DescId = zc_MIFloat_Taxi()

                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_RouteKind
                                                                  ON MILinkObject_RouteKind.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_RouteKind.DescId = zc_MILinkObject_RouteKind()
                                 LEFT JOIN MovementItemFloat AS MIFloat_Weight
                                                             ON MIFloat_Weight.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Weight.DescId = zc_MIFloat_Weight()
                                 LEFT JOIN MovementItemFloat AS MIFloat_WeightTransport
                                                             ON MIFloat_WeightTransport.MovementItemId = MovementItem.Id
                                                            AND MIFloat_WeightTransport.DescId = zc_MIFloat_WeightTransport()

                                 LEFT JOIN MovementItemFloat AS MIFloat_DistanceFuelChild
                                                             ON MIFloat_DistanceFuelChild.MovementItemId = MovementItem.Id
                                                            AND MIFloat_DistanceFuelChild.DescId = zc_MIFloat_DistanceFuelChild()

                                 LEFT JOIN MovementItem AS MI ON MI.ParentId = MovementItem.Id
                                                             AND MI.DescId   = zc_MI_Child()
                                                             AND MI.isErased   = FALSE
                                 LEFT JOIN MovementItemContainer AS MIContainer
                                                                 ON MIContainer.MovementId = MI.MovementId
                                                                AND MIContainer.MovementItemId = MI.Id
                                                                AND MIContainer.DescId = zc_MIContainer_Count()
                                                                AND MIContainer.MovementDescId = zc_Movement_Transport()

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

                            WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                              AND Movement.DescId = zc_Movement_Transport()
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                              -- AND Movement.Id = 4902267
                              AND (MI.ParentId IS NULL OR MI.Amount <> 0 OR MIFloat_StartAmountFuel.ValueData <> 0
                                OR MIFloat_Weight.ValueData <> 0 OR MIFloat_WeightTransport.ValueData <> 0
                                  )
                           UNION ALL
                            SELECT Movement.Id AS MovementId
                                 , Movement.InvNumber
                                 , Movement.OperDate
                                 , MovementLinkObject_Car.ObjectId AS CarId
                                 , MovementLinkObject_PersonalDriver.ObjectId AS PersonalDriverId
                                 , MovementItem.Id AS MovementItemId_calc
                                 -- , MovementItem.Amount AS DistanceFuelMaster

                                 , ROW_NUMBER() OVER (PARTITION BY MovementItem.Id
                                                      ORDER BY CASE WHEN MIBoolean_MasterFuel.ValueData = TRUE AND MIContainer.Amount <> 0
                                                                         THEN 1
                                                                    WHEN MIContainer.Amount <> 0
                                                                         THEN 2
                                                                    WHEN MIBoolean_MasterFuel.ValueData = TRUE
                                                                         THEN 3
                                                                    ELSE 4
                                                               END
                                                     ) AS Ord

                                 , 0 AS DistanceFuel

                                 , MovementItem.ObjectId AS RouteId
                                 , MILinkObject_RouteKind.ObjectId AS RouteKindId

                                 , 0 AS Weight
                                 , 0 AS WeightTransport

                                 , CASE WHEN ROW_NUMBER() OVER (PARTITION BY MovementItem.Id
                                                      ORDER BY CASE WHEN MIBoolean_MasterFuel.ValueData = TRUE AND MIContainer.Amount <> 0
                                                                         THEN 1
                                                                    WHEN MIContainer.Amount <> 0
                                                                         THEN 2
                                                                    WHEN MIBoolean_MasterFuel.ValueData = TRUE
                                                                         THEN 3
                                                                    ELSE 4
                                                               END
                                                     ) = 1
                                             THEN COALESCE (MIFloat_RateSumma.ValueData, 0) ELSE 0 END AS SumTransportAdd

                                 , CASE WHEN ROW_NUMBER() OVER (PARTITION BY MovementItem.Id
                                                      ORDER BY CASE WHEN MIBoolean_MasterFuel.ValueData = TRUE AND MIContainer.Amount <> 0
                                                                         THEN 1
                                                                    WHEN MIContainer.Amount <> 0
                                                                         THEN 2
                                                                    WHEN MIBoolean_MasterFuel.ValueData = TRUE
                                                                         THEN 3
                                                                    ELSE 4
                                                               END
                                                     ) = 1
                                             THEN COALESCE (MIFloat_RatePrice.ValueData, 0) * (COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_DistanceFuelChild.ValueData, 0))
                                                + COALESCE (MIFloat_RateSummaAdd.ValueData, 0)
                                        ELSE 0 END AS SumTransportAddLong
                                 , CASE WHEN ROW_NUMBER() OVER (PARTITION BY MovementItem.Id
                                                      ORDER BY CASE WHEN MIBoolean_MasterFuel.ValueData = TRUE AND MIContainer.Amount <> 0
                                                                         THEN 1
                                                                    WHEN MIContainer.Amount <> 0
                                                                         THEN 2
                                                                    WHEN MIBoolean_MasterFuel.ValueData = TRUE
                                                                         THEN 3
                                                                    ELSE 4
                                                               END
                                                     ) = 1
                                             THEN COALESCE (MIFloat_TaxiMore.ValueData, 0) ELSE 0 END AS SumTransportTaxi
                                 , 0 AS SumRateExp
                                 , 0 AS StartOdometre
                                 , 0 AS EndOdometre

                                 , MILinkObject_RateFuelKind.ObjectId AS RateFuelKindId
                                 , COALESCE (MIContainer.ObjectId_Analyzer, MI.ObjectId) AS FuelId

                                 , COALESCE (MIFloat_RateFuelKindTax.ValueData, 0)  AS RateFuelKindTax

                                 , 0 AS AmountFuel_Start
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
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                                              ON MovementLinkObject_Car.MovementId = Movement.Id
                                                             AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                                               ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                                              AND MovementLinkObject_PersonalDriver.DescId     = zc_MovementLinkObject_PersonalDriverMore()
                                                              AND MovementLinkObject_PersonalDriver.ObjectId   > 0

                                 LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE

                                 LEFT JOIN MovementItemFloat AS MIFloat_StartOdometre
                                                             ON MIFloat_StartOdometre.MovementItemId = MovementItem.Id
                                                            AND MIFloat_StartOdometre.DescId = zc_MIFloat_StartOdometre()
                                 LEFT JOIN MovementItemFloat AS MIFloat_EndOdometre
                                                             ON MIFloat_EndOdometre.MovementItemId = MovementItem.Id
                                                            AND MIFloat_EndOdometre.DescId = zc_MIFloat_EndOdometre()

                                 LEFT JOIN MovementItemFloat AS MIFloat_RateSumma
                                                             ON MIFloat_RateSumma.MovementItemId =  MovementItem.Id
                                                            AND MIFloat_RateSumma.DescId = zc_MIFloat_RateSumma()
                                 LEFT JOIN MovementItemFloat AS MIFloat_RatePrice
                                                             ON MIFloat_RatePrice.MovementItemId =  MovementItem.Id
                                                            AND MIFloat_RatePrice.DescId = zc_MIFloat_RatePrice()
                                 LEFT JOIN MovementItemFloat AS MIFloat_RateSummaAdd
                                                             ON MIFloat_RateSummaAdd.MovementItemId =  MovementItem.Id
                                                            AND MIFloat_RateSummaAdd.DescId = zc_MIFloat_RateSummaAdd()

                                 LEFT JOIN MovementItemFloat AS MIFloat_TaxiMore
                                                             ON MIFloat_TaxiMore.MovementItemId =  MovementItem.Id
                                                            AND MIFloat_TaxiMore.DescId = zc_MIFloat_TaxiMore()

                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_RouteKind
                                                                  ON MILinkObject_RouteKind.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_RouteKind.DescId = zc_MILinkObject_RouteKind()
                                 LEFT JOIN MovementItemFloat AS MIFloat_Weight
                                                             ON MIFloat_Weight.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Weight.DescId = zc_MIFloat_Weight()
                                 LEFT JOIN MovementItemFloat AS MIFloat_WeightTransport
                                                             ON MIFloat_WeightTransport.MovementItemId = MovementItem.Id
                                                            AND MIFloat_WeightTransport.DescId = zc_MIFloat_WeightTransport()

                                 LEFT JOIN MovementItemFloat AS MIFloat_DistanceFuelChild
                                                             ON MIFloat_DistanceFuelChild.MovementItemId = MovementItem.Id
                                                            AND MIFloat_DistanceFuelChild.DescId = zc_MIFloat_DistanceFuelChild()

                                 LEFT JOIN MovementItem AS MI ON MI.ParentId = MovementItem.Id
                                                             AND MI.DescId   = zc_MI_Child()
                                                             AND MI.isErased   = FALSE
                                 LEFT JOIN MovementItemContainer AS MIContainer
                                                                 ON MIContainer.MovementId = MI.MovementId
                                                                AND MIContainer.MovementItemId = MI.Id
                                                                AND MIContainer.DescId = zc_MIContainer_Count()
                                                                AND MIContainer.MovementDescId = zc_Movement_Transport()

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

                            WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                              AND Movement.DescId = zc_Movement_Transport()
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                              -- AND Movement.Id = 4902267
                              AND (MI.ParentId IS NULL OR MI.Amount <> 0 OR MIFloat_StartAmountFuel.ValueData <> 0
                                OR MIFloat_Weight.ValueData <> 0 OR MIFloat_WeightTransport.ValueData <> 0
                                  )
                           UNION ALL
                           -- єкспедитор
                            SELECT Movement.Id AS MovementId
                                 , Movement.InvNumber
                                 , Movement.OperDate
                                 , MovementLinkObject_Car.ObjectId AS CarId
                                 , MovementLinkObject_Personal.ObjectId AS PersonalDriverId
                                 , 0 AS MovementItemId_calc

                                 , 1 AS Ord

                                 , 0 AS DistanceFuel

                                 , MovementItem.ObjectId AS RouteId
                                 , MILinkObject_RouteKind.ObjectId AS RouteKindId

                                 , 0 AS Weight
                                 , 0 AS WeightTransport
                                 , 0 AS SumTransportAdd
                                 , 0 AS SumTransportAddLong
                                 , 0 AS SumTransportTaxi

                                 , COALESCE (MIFloat_RateSummaExp.ValueData, 0) AS SumRateExp

                                 , 0 AS StartOdometre
                                 , 0 AS EndOdometre

                                 , 0 AS RateFuelKindId
                                 , 0 AS FuelId

                                 , 0 AS RateFuelKindTax

                                 , 0 AS AmountFuel_Start
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
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                                              ON MovementLinkObject_Car.MovementId = Movement.Id
                                                             AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_Personal
                                                               ON MovementLinkObject_Personal.MovementId = Movement.Id
                                                              AND MovementLinkObject_Personal.DescId     = zc_MovementLinkObject_Personal()
                                                              AND MovementLinkObject_Personal.ObjectId   > 0

                                 LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE

                                 LEFT JOIN MovementItemFloat AS MIFloat_RateSummaExp
                                                             ON MIFloat_RateSummaExp.MovementItemId =  MovementItem.Id
                                                            AND MIFloat_RateSummaExp.DescId = zc_MIFloat_RateSummaExp()

                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_RouteKind
                                                                  ON MILinkObject_RouteKind.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_RouteKind.DescId = zc_MILinkObject_RouteKind()

                            WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                              AND Movement.DescId = zc_Movement_Transport()
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                              AND COALESCE (MIFloat_RateSummaExp.ValueData, 0) <> 0

                           )
         -- вытаскиваем из реестра виз кол-во накладных и вес
         , tmpDataReestr AS (SELECT tmp.MovementId                                AS MovementId
                               -- , STRING_AGG (DISTINCT tmp.InvNumber, ';')      AS InvNumber
                                  , STRING_AGG (DISTINCT tmp.InvNumber || ' ' || tmp.FromName, ';')          AS InvNumber
                                  , STRING_AGG (DISTINCT tmp.InvNumber || ' ' || tmp.RouteName_order, ';')   AS RouteName_order
                                  , COUNT (DISTINCT tmp.MovementId_sale)          AS CountDoc
                                  , COUNT (DISTINCT tmp.MovementId_sale_zp)       AS CountDoc_zp
                                  , SUM (tmp.TotalCountKg)                        AS TotalCountKg
                                  , SUM (tmp.TotalCountKg_Reestr_zp)              AS TotalCountKg_Reestr_zp

                             FROM (SELECT tmp.MovementId                                            AS MovementId
                                     -- , STRING_AGG (DISTINCT Movement_Reestr.InvNumber, ';')      AS InvNumber
                                        , Movement_Reestr.InvNumber                                 AS InvNumber
                                        , Object_From.ValueData                                     AS FromName
                                        , MovementFloat_MovementItemId.MovementId                   AS MovementId_sale
                                        , MovementFloat_TotalCountKg.ValueData                      AS TotalCountKg
                                        , CASE WHEN OB_NotPayForWeight.ValueData = TRUE THEN 0 ELSE MovementFloat_TotalCountKg.ValueData END AS TotalCountKg_Reestr_zp
                                        , CASE WHEN OB_NotPayForWeight.ValueData = TRUE THEN NULL ELSE MovementFloat_MovementItemId.MovementId END AS MovementId_sale_zp
                                        , Object_Route.ValueData                                    AS RouteName_order
                                   FROM (SELECT DISTINCT tmpTransport.MovementId FROM tmpTransport) AS tmp
                                        INNER JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                                                        ON MovementLinkMovement_Transport.MovementChildId = tmp.MovementId
                                                                       AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
                                        INNER JOIN Movement AS Movement_Reestr
                                                            ON Movement_Reestr.Id       = MovementLinkMovement_Transport.MovementId
                                                           AND Movement_Reestr.DescId   = zc_Movement_Reestr()
                                                           AND Movement_Reestr.StatusId <> zc_Enum_Status_Erased()  --IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())   --zc_Enum_Status_Erased()
                                        -- строки реестра
                                        INNER JOIN MovementItem ON MovementItem.MovementId = MovementLinkMovement_Transport.MovementId
                                                               AND MovementItem.DescId     = zc_MI_Master()
                                                               AND MovementItem.isErased   = FALSE
                                        -- связь с накладными
                                        LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                                                ON MovementFloat_MovementItemId.ValueData = MovementItem.Id
                                                               AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                                        -- вес накладных
                                        LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                                                ON MovementFloat_TotalCountKg.MovementId = MovementFloat_MovementItemId.MovementId -- Movement_Sale.Id
                                                               AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
                                        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                     ON MovementLinkObject_From.MovementId = MovementFloat_MovementItemId.MovementId
                                                                    AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                        LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                                        INNER JOIN Movement AS Movement_Sale
                                                            ON Movement_Sale.Id       = MovementFloat_MovementItemId.MovementId
                                                           AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                                        -- маршрут в заявке
                                        LEFT JOIN MovementLinkMovement AS MLM_Order
                                                                       ON MLM_Order.MovementId = Movement_Sale.Id
                                                                      AND MLM_Order.DescId     = zc_MovementLinkMovement_Order()
                                        LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                                                     ON MovementLinkObject_Route.MovementId = MLM_Order.MovementChildId
                                                                    AND MovementLinkObject_Route.DescId     = zc_MovementLinkObject_Route()
                                        LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

                                        LEFT JOIN ObjectBoolean AS OB_NotPayForWeight
                                                                ON OB_NotPayForWeight.ObjectId  = MovementLinkObject_Route.ObjectId
                                                               AND OB_NotPayForWeight.DescId    = zc_ObjectBoolean_Route_NotPayForWeight()

                                   ORDER BY tmp.MovementId, Movement_Reestr.InvNumber, Object_From.ValueData
                                  ) AS tmp
                             GROUP BY tmp.MovementId
                             )

 , tmpList_1 AS (SELECT DISTINCT lpInsertFind_Object_ServiceDate (GENERATE_SERIES) AS ServiceDateId FROM GENERATE_SERIES (inStartDate, inEndDate, '1 MONTH' :: INTERVAL)
                )
 , tmpList_2 AS (SELECT DISTINCT CLO_Personal.ContainerId
                 FROM (SELECT DISTINCT tmpTransport.PersonalDriverId FROM tmpTransport) AS tmpTransport
                      INNER JOIN ContainerLinkObject AS CLO_Personal
                                                     ON CLO_Personal.ObjectId  = tmpTransport.PersonalDriverId
                                                    AND CLO_Personal.DescId    = zc_ContainerLinkObject_Personal()
                      INNER JOIN ContainerLinkObject AS CLO_ServiceDate
                                                     ON CLO_ServiceDate.ContainerId = CLO_Personal.ContainerId
                                                    AND CLO_ServiceDate.ObjectId    IN (SELECT DISTINCT tmpList_1.ServiceDateId FROM tmpList_1)
                                                    AND CLO_ServiceDate.DescId      = zc_ContainerLinkObject_ServiceDate()
                )

 , tmpList_MIC AS (SELECT MIContainer.*
                   FROM tmpList_2
                        INNER JOIN MovementItemContainer AS MIContainer
                                                         ON MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                        AND MIContainer.ContainerId = tmpList_2.ContainerId -- IN (SELECT DISTINCT tmpList_2.ContainerId FROM tmpList_2)
                                                        AND MIContainer.DescId         = zc_MIContainer_Summ()
                                                        AND MIContainer.MovementDescId = zc_Movement_Transport()
                  )

 , tmpPersonalServiceList_find_all AS (SELECT DISTINCT tmpTransport.MovementId
                                                     , tmpTransport.PersonalDriverId
                                                     , MIContainer.ContainerId
                                       FROM (SELECT DISTINCT tmpTransport.MovementId, tmpTransport.MovementItemId_calc, tmpTransport.PersonalDriverId FROM tmpTransport
                                            ) AS tmpTransport
                                            JOIN tmpList_MIC AS MIContainer
                                                             ON MIContainer.MovementId     = tmpTransport.MovementId
                                                            AND MIContainer.MovementItemId = tmpTransport.MovementItemId_calc
                                                            AND MIContainer.DescId         = zc_MIContainer_Summ()
                                                            AND MIContainer.Amount         <> 0
                                      )
 , tmpPersonalServiceList_find_add AS (SELECT DISTINCT tmpPersonalServiceList_find_all.MovementId
                                                     , tmpPersonalServiceList_find_all.PersonalDriverId
                                                     , CLO_PersonalServiceList.ObjectId AS PersonalServiceListId
                                       FROM tmpPersonalServiceList_find_all
                                            INNER JOIN ContainerLinkObject AS CLO_Personal
                                                                           ON CLO_Personal.ContainerId = tmpPersonalServiceList_find_all.ContainerId
                                                                          AND CLO_Personal.ObjectId    = tmpPersonalServiceList_find_all.PersonalDriverId
                                                                          AND CLO_Personal.DescId      = zc_ContainerLinkObject_Personal()
                                            INNER JOIN ContainerLinkObject AS CLO_PersonalServiceList
                                                                           ON CLO_PersonalServiceList.ContainerId = tmpPersonalServiceList_find_all.ContainerId
                                                                          AND CLO_PersonalServiceList.DescId      = zc_ContainerLinkObject_PersonalServiceList()
                                            INNER JOIN Object AS Object_PersonalServiceList
                                                              ON Object_PersonalServiceList.Id     = CLO_PersonalServiceList.ObjectId
                                                             AND Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                      )
  , tmpPersonalServiceList_find AS (SELECT tmpPersonalServiceList_find_add.MovementId
                                         , tmpPersonalServiceList_find_add.PersonalDriverId
                                         , STRING_AGG (DISTINCT Object_PersonalServiceList.ValueData, ';') AS PersonalServiceListName
                                    FROM tmpPersonalServiceList_find_add
                                         LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = tmpPersonalServiceList_find_add.PersonalServiceListId
                                    GROUP BY tmpPersonalServiceList_find_add.MovementId
                                           , tmpPersonalServiceList_find_add.PersonalDriverId
                                   )
       , tmpFuel AS(SELECT tmpAll.MovementId
                         , tmpAll.InvNumber
                         , tmpAll.OperDate
                         , tmpAll.CarId
                         , tmpAll.PersonalDriverId
                         , (tmpAll.RouteId)             AS RouteId
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

                         , MAX (tmpAll.SumTransportAdd)          AS SumTransportAdd
                         , MAX (tmpAll.SumTransportAddLong)      AS SumTransportAddLong
                         , MAX (tmpAll.SumTransportTaxi)         AS SumTransportTaxi
                         , MAX (tmpAll.SumRateExp)               AS SumRateExp

                         , ROW_NUMBER() OVER (PARTITION BY tmpAll.MovementId ORDER BY tmpAll.MovementId, MAX (tmpAll.Weight) desc) AS Ord

                    FROM (-- 2.1. Начальный остаток (!!!расчетный!!!) + Расход топлива
                          SELECT tmpTransport.MovementId
                               , tmpTransport.InvNumber
                               , tmpTransport.OperDate
                               , tmpTransport.CarId
                               , tmpTransport.PersonalDriverId
                               , tmpTransport.RouteId
                               , tmpTransport.RouteKindId
                               , tmpTransport.RateFuelKindId
                               , tmpTransport.FuelId

                               , tmpTransport.DistanceFuel
                               , tmpTransport.RateFuelKindTax

                               , tmpTransport.Weight
                               , tmpTransport.WeightTransport

                               , tmpTransport.StartOdometre
                               , tmpTransport.EndOdometre

                               , tmpTransport.AmountFuel_Start
                               , 0 AS AmountFuel_In
                               , tmpTransport.AmountFuel_Out

                               , tmpTransport.ColdHour
                               , tmpTransport.ColdDistance

                               , tmpTransport.AmountFuel
                               , tmpTransport.AmountColdHour
                               , tmpTransport.AmountColdDistance

                               , tmpTransport.Amount_Distance_calc
                               , tmpTransport.Amount_ColdHour_calc
                               , tmpTransport.Amount_ColdDistance_calc

                               , tmpTransport.SumTransportAdd
                               , tmpTransport.SumTransportAddLong
                               , tmpTransport.SumTransportTaxi
                               , tmpTransport.SumRateExp

                          FROM tmpTransport
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
                               , MIContainer.ObjectId_Analyzer AS FuelId

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

                               , 0 AS SumTransportAdd
                               , 0 AS SumTransportAddLong
                               , 0 AS SumTransportTaxi
                               , 0 AS SumRateExp

                          FROM Container
                               -- так ограничили приходы только на Автомобиль
                               JOIN ContainerLinkObject AS ContainerLO_Car
                                                        ON ContainerLO_Car.ContainerId = Container.Id
                                                       AND ContainerLO_Car.DescId = zc_ContainerLinkObject_Car()
                                                       AND ContainerLO_Car.ObjectId > 0
                               JOIN MovementItemContainer AS MIContainer
                                                          ON MIContainer.ContainerId = ContainerLO_Car.ContainerId
                                                         AND MIContainer.MovementDescId = zc_Movement_Income()
                                                         AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                               LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                                            ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                                           AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                                            ON MovementLinkObject_Route.MovementId = Movement.Id
                                                           AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()

                               LEFT JOIN Movement AS Movement_Transport
                                                  ON Movement_Transport.Id     = Movement.ParentId
                                                 AND Movement_Transport.DescId = zc_Movement_Transport()
                          WHERE Container.DescId = zc_container_Count()

                         ) AS tmpAll
                    GROUP BY tmpAll.MovementId
                         , tmpAll.InvNumber
                         , tmpAll.OperDate
                         , tmpAll.CarId
                         , tmpAll.PersonalDriverId
                         , tmpAll.FuelId
                         , tmpAll.RouteId
                    )

         , tmpMovementString AS (SELECT *
                                 FROM MovementString
                                 WHERE MovementString.MovementId IN (SELECT DISTINCT tmpFuel.MovementId FROM tmpFuel)
                                   AND MovementString.DescId = zc_MovementString_CommentStop()
                                 )

         , tmpMovementFloat AS (SELECT *
                                FROM MovementFloat
                                WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpFuel.MovementId FROM tmpFuel)
                                 AND MovementFloat.DescId IN (zc_MovementFloat_PartnerCount()
                                                            , zc_MovementFloat_HoursWork()
                                                            , zc_MovementFloat_HoursAdd()
                                                            , zc_MovementFloat_HoursStop()
                                                            )
                                )

        -- результат
        SELECT CASE WHEN inisMonth = FALSE THEN tmpFuel.MovementId ELSE 0 END :: Integer
             , CASE WHEN inisMonth = FALSE THEN zfConvert_StringToNumber (tmpFuel.InvNumber) ELSE NULL END       ::Integer  AS InvNumberTransport
             , CASE WHEN inisMonth = FALSE THEN tmpFuel.OperDate ELSE DATE_TRUNC ('Month', tmpFuel.OperDate) END ::TDateTime AS OperDate

             , ViewObject_Unit.BranchName
             , ViewObject_Unit.Name             AS UnitName_car
             , STRING_AGG (DISTINCT Object_Unit_route.ValueData, ';') :: TVarChar AS UnitName_route
             , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
             , Object_Car.ValueData             AS CarName

             , tmpFuel.PersonalDriverId :: Integer
             --, View_PersonalDriver.PersonalName AS PersonalDriverName 
             , View_PersonalDriver.PersonalName       :: TVarChar AS PersonalDriverName 
             , View_PersonalDriver.PositionName       :: TVarChar AS PositionName
             , View_PersonalDriver.PositionLevelName  :: TVarChar AS PositionLevelName
             , Object_Route.ValueData           AS RouteName
             , Object_RouteKind.ValueData       AS RouteKindName
             , Object_RateFuelKind.ValueData    AS RateFuelKindName
             , Object_Fuel.ValueData            AS FuelName


             , SUM (tmpFuel.DistanceFuel)    :: TFloat AS DistanceFuel
             , MAX (tmpFuel.RateFuelKindTax) :: TFloat AS RateFuelKindTax

             , SUM (tmpFuel.Weight)          :: TFloat AS Weight
             , SUM (tmpFuel.WeightTransport) :: TFloat AS WeightTransport
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

             , SUM (tmpFuel.SumTransportAdd)          :: TFloat AS SumTransportAdd
             , SUM (tmpFuel.SumTransportAddLong)      :: TFloat AS SumTransportAddLong
             , SUM (tmpFuel.SumTransportTaxi)         :: TFloat AS SumTransportTaxi
             , SUM (tmpFuel.SumRateExp)               :: TFloat AS SumRateExp

             , SUM (COALESCE (tmpDataReestr.CountDoc, 0))           :: TFloat   AS CountDoc_Reestr
             , SUM (COALESCE (tmpDataReestr.CountDoc_zp, 0))        :: TFloat   AS CountDoc_Reestr_zp
             , SUM (COALESCE (tmpDataReestr.TotalCountKg, 0))       :: TFloat   AS TotalCountKg_Reestr
           --, MAX (CASE WHEN OB_NotPayForWeight.ValueData = TRUE THEN 0 ELSE COALESCE (tmpDataReestr.TotalCountKg, 0) END) :: TFloat AS TotalCountKg_Reestr_zp
             , SUM (COALESCE (tmpDataReestr.TotalCountKg_Reestr_zp, 0)) :: TFloat AS TotalCountKg_Reestr_zp

             , MAX (COALESCE (tmpDataReestr.InvNumber, ''))         :: TVarChar AS InvNumber_Reestr
             , MAX (COALESCE (tmpDataReestr.RouteName_order, ''))   :: TVarChar AS RouteName_order


             , SUM (CAST (MovementFloat_PartnerCount.ValueData AS TFloat))       ::TFloat                                        AS PartnerCount
             --часы по маршрутам так же проссумировать как и точки
             , SUM (CAST (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) AS TFloat)) ::TFloat AS HoursWork
             , SUM (CAST (COALESCE (MovementFloat_HoursStop.ValueData, 0) AS TFloat))                                                  ::TFloat AS HoursStop
             , SUM (CAST (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) - COALESCE (MovementFloat_HoursStop.ValueData, 0)  AS TFloat)) ::TFloat AS HoursMove
             ,  (SUM (COALESCE (MovementFloat_PartnerCount.ValueData,0)) * CAST(COALESCE (ObjectFloat_PartnerMin.ValueData,20) / 60  AS NUMERIC (16,2))) :: TFloat AS HoursPartner_all  -- общее время в точках
             , CAST((COALESCE (ObjectFloat_PartnerMin.ValueData,20) / 60 )  AS NUMERIC (16,2))           :: TFloat AS HoursPartner      -- время в точке, часов

             , CASE WHEN ( SUM (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) - COALESCE (MovementFloat_HoursStop.ValueData, 0) )
                        - ( SUM (COALESCE (MovementFloat_PartnerCount.ValueData,0)) * CAST (COALESCE (ObjectFloat_PartnerMin.ValueData,20) / 60 AS NUMERIC (16,2)))
                         ) <> 0
                    THEN SUM (tmpFuel.DistanceFuel) / ( SUM (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) - COALESCE (MovementFloat_HoursStop.ValueData, 0))
                                                     - (SUM (COALESCE (MovementFloat_PartnerCount.ValueData,0)) * CAST (COALESCE (ObjectFloat_PartnerMin.ValueData,20) / 60 AS NUMERIC (16,2)))
                                                      )
                    ELSE 0
               END :: TFloat AS Speed
             , MovementString_CommentStop.ValueData ::TVarChar    AS CommentStop

             , tmpPersonalServiceList_find.PersonalServiceListName ::TVarChar AS PersonalServiceListName_find

              -- группировка по всем
        FROM tmpFuel
             LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpFuel.CarId
             LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                            AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
             LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                  ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                 AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
             LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

             LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = tmpFuel.PersonalDriverId
             LEFT JOIN Object AS Object_Route ON Object_Route.Id = tmpFuel.RouteId
             LEFT JOIN Object AS Object_RouteKind ON Object_RouteKind.Id = tmpFuel.RouteKindId
             LEFT JOIN Object AS Object_RateFuelKind ON Object_RateFuelKind.Id = tmpFuel.RateFuelKindId
             LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = tmpFuel.FuelId

             LEFT JOIN tmpPersonalServiceList_find ON tmpPersonalServiceList_find.MovementId       = tmpFuel.MovementId
                                                  AND tmpPersonalServiceList_find.PersonalDriverId = tmpFuel.PersonalDriverId

           --LEFT JOIN ObjectBoolean AS OB_NotPayForWeight
           --                        ON OB_NotPayForWeight.ObjectId = tmpFuel.RouteId
           --                       AND OB_NotPayForWeight.DescId   = zc_ObjectBoolean_Route_NotPayForWeight()

             -- ограничиваем по филиалу, если нужно
             LEFT JOIN ObjectLink AS ObjectLink_Car_Unit
                                  ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id
                                 AND ObjectLink_Car_Unit.DescId   = zc_ObjectLink_Car_Unit()
             LEFT JOIN Object_Unit_View AS ViewObject_Unit
                                        ON ViewObject_Unit.Id = ObjectLink_Car_Unit.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Route_Unit
                                  ON ObjectLink_Route_Unit.ObjectId = tmpFuel.RouteId
                                 AND ObjectLink_Route_Unit.DescId   = zc_ObjectLink_Route_Unit()
             LEFT JOIN Object AS Object_Unit_route ON Object_Unit_route.Id = ObjectLink_Route_Unit.ChildObjectId

             -- данные из реестра виз
             LEFT JOIN tmpDataReestr ON tmpDataReestr.MovementId = tmpFuel.MovementId
                                    AND tmpFuel.Ord = 1

             LEFT JOIN tmpMovementString AS MovementString_CommentStop
                                         ON MovementString_CommentStop.MovementId = tmpFuel.MovementId

             LEFT JOIN tmpMovementFloat AS MovementFloat_HoursWork
                                        ON MovementFloat_HoursWork.MovementId = tmpFuel.MovementId
                                       AND MovementFloat_HoursWork.DescId = zc_MovementFloat_HoursWork()
                                       AND tmpFuel.Ord = 1
             LEFT JOIN tmpMovementFloat AS MovementFloat_HoursAdd
                                        ON MovementFloat_HoursAdd.MovementId = tmpFuel.MovementId
                                       AND MovementFloat_HoursAdd.DescId = zc_MovementFloat_HoursAdd()
                                       AND tmpFuel.Ord = 1
             LEFT JOIN tmpMovementFloat AS MovementFloat_HoursStop
                                        ON MovementFloat_HoursStop.MovementId = tmpFuel.MovementId
                                       AND MovementFloat_HoursStop.DescId = zc_MovementFloat_HoursStop()
                                       AND tmpFuel.Ord = 1
             LEFT JOIN tmpMovementFloat AS MovementFloat_PartnerCount
                                        ON MovementFloat_PartnerCount.MovementId = tmpFuel.MovementId
                                       AND MovementFloat_PartnerCount.DescId = zc_MovementFloat_PartnerCount()
                                       AND tmpFuel.Ord = 1

             LEFT JOIN ObjectFloat AS ObjectFloat_PartnerMin
                                   ON ObjectFloat_PartnerMin.ObjectId = Object_Car.Id
                                  AND ObjectFloat_PartnerMin.DescId = zc_ObjectFloat_Car_PartnerMin()
                                  AND tmpFuel.Ord = 1

        WHERE COALESCE (ViewObject_Unit.BranchId, 0) = inBranchId
           OR inBranchId = 0
           OR (inBranchId = zc_Branch_Basis() AND COALESCE (ViewObject_Unit.BranchId, 0) = 0)

        GROUP BY CASE WHEN inisMonth = FALSE THEN tmpFuel.MovementId ELSE 0 END 
               , CASE WHEN inisMonth = FALSE THEN zfConvert_StringToNumber (tmpFuel.InvNumber) ELSE NULL END
               , CASE WHEN inisMonth = FALSE THEN tmpFuel.OperDate ELSE DATE_TRUNC ('Month', tmpFuel.OperDate) END
               , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') )
               , Object_Car.ValueData
               , tmpFuel.PersonalDriverId
               , View_PersonalDriver.PersonalName 
               , View_PersonalDriver.PositionName
               , View_PersonalDriver.PositionLevelName
               , Object_Route.ValueData
               , Object_RouteKind.ValueData
               , Object_RateFuelKind.ValueData
               , Object_Fuel.ValueData
               , ViewObject_Unit.BranchName
               , ViewObject_Unit.Name

           --  , MovementFloat_PartnerCount.ValueData
            -- , (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) )
           --  , (COALESCE (MovementFloat_HoursStop.ValueData, 0) )
             /*, CASE WHEN (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) - COALESCE (MovementFloat_HoursStop.ValueData, 0)
                        - (COALESCE (MovementFloat_PartnerCount.ValueData,0) * CAST (COALESCE (ObjectFloat_PartnerMin.ValueData,20) / 60 AS NUMERIC (16,2)))
                         ) <> 0
                    THEN (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) - COALESCE (MovementFloat_HoursStop.ValueData, 0)
                        - (COALESCE (MovementFloat_PartnerCount.ValueData,0) * CAST (COALESCE (ObjectFloat_PartnerMin.ValueData,20) / 60 AS NUMERIC (16,2)))
                         )
                    ELSE 0
               END   */ 
               
             , (COALESCE (ObjectFloat_PartnerMin.ValueData,20) / 60)
             , MovementString_CommentStop.ValueData
             , tmpPersonalServiceList_find.PersonalServiceListName
              ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpReport_Transport (TDateTime, TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.09.23         *
 27.04.21         *
 31.01.19         *
 21.06.18         * add tmpDataReestr
 07.07.14                                       * add Weight and WeightTransport
 09.02.14         * ограничения для zc_Branch_Basis()
 12.12.13         * add inBranchId
 28.10.13                                        *
 05.10.13         *
*/

-- тест
-- SELECT * FROM gpReport_Transport (inStartDate:= '06.03.2021', inEndDate:= '10.03.2021', inCarId:= null,  inBranchId:= 1, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpReport_Transport (inStartDate:= '19.02.2025', inEndDate:= '19.02.2025', inCarId:= 0, inBranchId := 8380 , inIsMonth:= FALSE, inSession:= '5');
