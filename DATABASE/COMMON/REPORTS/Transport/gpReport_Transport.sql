-- Function: gpReport_Transport ()

DROP FUNCTION IF EXISTS gpReport_Transport (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Transport (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Transport(
    IN inStartDate     TDateTime , -- 
    IN inEndDate       TDateTime , --
    IN inCarId         Integer   , --
    IN inBranchId      Integer   , -- ������
    IN inSession       TVarChar    -- ������ ������������
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
             , SumTransportAdd TFloat, SumTransportAddLong TFloat, SumTransportTaxi TFloat
             , CountDoc_Reestr TFloat, TotalCountKg_Reestr TFloat, InvNumber_Reestr TVarChar
              )
AS
$BODY$
BEGIN

      -- �������� ���� ������������ �� ����� ���������
      -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Transport());

      RETURN QUERY 
           -- �������� ��� ������� ����� �� ���������
      WITH tmpTransport AS (SELECT Movement.Id AS MovementId
                                 , Movement.InvNumber
                                 , Movement.OperDate
                                 , MovementLinkObject_Car.ObjectId AS CarId
                                 , MovementLinkObject_PersonalDriver.ObjectId AS PersonalDriverId
                                 -- , MovementItem.Id AS MovementItemId
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
                                             THEN COALESCE (MIFloat_RatePrice.ValueData, 0) * (COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_DistanceFuelChild.ValueData, 0)) + COALESCE (MIFloat_RateSummaAdd.ValueData, 0) ELSE 0 END AS SumTransportAddLong
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

                                 , zfCalc_RateFuelValue_Distance     (inDistance           := CASE WHEN COALESCE (MIBoolean_MasterFuel.ValueData, FALSE) = TRUE  THEN MovementItem.Amount                 -- ���� "��������" ��� �������
                                                                                                   WHEN COALESCE (MIBoolean_MasterFuel.ValueData, FALSE) = FALSE THEN MIFloat_DistanceFuelChild.ValueData -- ���� "��������������" ��� �������
                                                                                                   ELSE 0
                                                                                              END
                                                                    , inAmountFuel         := MIFloat_AmountFuel.ValueData
                                                                    , inFuel_Ratio         := 1 -- !!!����������� �������� ����� ��� �����!!!
                                                                    , inRateFuelKindTax    := 0 -- !!!% ��������������� ������� � ����� � �������/������������ ��� �����!!!
                                                                     ) AS Amount_Distance_calc
                                 , zfCalc_RateFuelValue_ColdHour     (inColdHour           := MIFloat_ColdHour.ValueData
                                                                    , inAmountColdHour     := MIFloat_AmountColdHour.ValueData
                                                                    , inFuel_Ratio         := 1 -- !!!����������� �������� ����� ��� �����!!!
                                                                    , inRateFuelKindTax    := 0 -- !!!% ��������������� ������� � ����� � �������/������������ ��� �����!!!
                                                                     ) AS Amount_ColdHour_calc
                                 , zfCalc_RateFuelValue_ColdDistance (inColdDistance       := MIFloat_ColdDistance.ValueData
                                                                    , inAmountColdDistance := MIFloat_AmountColdDistance.ValueData
                                                                    , inFuel_Ratio         := 1 -- !!!����������� �������� ����� ��� �����!!!
                                                                    , inRateFuelKindTax    := 0 -- !!!% ��������������� ������� � ����� � �������/������������ ��� �����!!!
                                                                     ) AS Amount_ColdDistance_calc

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
                                 -- , MovementItem.Id AS MovementItemId
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
                                             THEN COALESCE (MIFloat_RatePrice.ValueData, 0) * (COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_DistanceFuelChild.ValueData, 0)) + COALESCE (MIFloat_RateSummaAdd.ValueData, 0) ELSE 0 END AS SumTransportAddLong
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
                           )
         -- ����������� �� ������� ��� ���-�� ��������� � ���
         , tmpDataReestr AS (SELECT tmp.MovementId                                            AS MovementId
                                  , STRING_AGG (DISTINCT Movement_Reestr.InvNumber, ';')      AS InvNumber
                                  , COUNT (DISTINCT MovementFloat_MovementItemId.MovementId)  AS CountDoc
                                  , SUM (MovementFloat_TotalCountKg.ValueData)                AS TotalCountKg
                             FROM (SELECT DISTINCT tmpTransport.MovementId FROM tmpTransport) AS tmp
                                  INNER JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                                                  ON MovementLinkMovement_Transport.MovementChildId = tmp.MovementId
                                                                 AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
                                  INNER JOIN Movement AS Movement_Reestr 
                                                      ON Movement_Reestr.Id       = MovementLinkMovement_Transport.MovementId
                                                     AND Movement_Reestr.DescId   = zc_Movement_Reestr()
                                                     AND Movement_Reestr.StatusId <> zc_Enum_Status_Erased()  --IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())   --zc_Enum_Status_Erased()
                                  -- ������ �������
                                  INNER JOIN MovementItem ON MovementItem.MovementId = MovementLinkMovement_Transport.MovementId
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                         AND MovementItem.isErased   = FALSE
                                  -- ����� � ����������
                                  LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                                          ON MovementFloat_MovementItemId.ValueData = MovementItem.Id
                                                         AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                                  -- ��� ���������
                                  LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                                          ON MovementFloat_TotalCountKg.MovementId = MovementFloat_MovementItemId.MovementId -- Movement_Sale.Id
                                                         AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
                             GROUP BY tmp.MovementId
                             )

        -- ���������
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

             , MAX (tmpFuel.SumTransportAdd)          :: TFloat AS SumTransportAdd
             , MAX (tmpFuel.SumTransportAddLong)      :: TFloat AS SumTransportAddLong
             , MAX (tmpFuel.SumTransportTaxi)         :: TFloat AS SumTransportTaxi

             , MAX (tmpDataReestr.CountDoc)           :: TFloat   AS CountDoc_Reestr
             , MAX (tmpDataReestr.TotalCountKg)       :: TFloat   AS TotalCountKg_Reestr
             , MAX (tmpDataReestr.InvNumber)          :: TVarChar AS InvNumber_Reestr

              -- ����������� �� ����
        FROM (SELECT tmpAll.MovementId
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
                   
                   , ROW_NUMBER() OVER (PARTITION BY tmpAll.MovementId ORDER BY tmpAll.MovementId, MAX (tmpAll.Weight) desc) AS Ord
              FROM
             (-- 2.1. ��������� ������� (!!!���������!!!) + ������ �������
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

              FROM tmpTransport
             UNION ALL
              -- 2.2. ������ �������
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

              FROM Container
                   -- ��� ���������� ������� ������ �� ����������
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

             -- ������������ �� �������, ���� �����
             LEFT JOIN ObjectLink AS ObjectLink_Car_Unit 
                             ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id
                            AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
             LEFT JOIN Object_Unit_View AS ViewObject_Unit
                                   ON ViewObject_Unit.Id = ObjectLink_Car_Unit.ChildObjectId
                                   
             -- ������ �� ������� ���
             LEFT JOIN tmpDataReestr ON tmpDataReestr.MovementId = tmpFuel.MovementId
                                     AND tmpFuel.Ord = 1
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.06.18         * add tmpDataReestr
 07.07.14                                       * add Weight and WeightTransport
 09.02.14         * ����������� ��� zc_Branch_Basis()
 12.12.13         * add inBranchId     
 28.10.13                                        *
 05.10.13         *
*/

-- ����
-- SELECT * FROM gpReport_Transport (inStartDate:= '01.01.2016', inEndDate:= '01.01.2016', inCarId:= null,  inBranchId:= 1, inSession:= zfCalc_UserAdmin());
--select * from gpReport_Transport(inStartDate := ('01.12.2016')::TDateTime , inEndDate := ('31.12.2016')::TDateTime , inCarId := 0 , inBranchId := 0 ,  inSession := '5') as tt----
--where InvNumberTransport = 38113