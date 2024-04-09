-- Function: gpReport_Transport_Cost ()

DROP FUNCTION IF EXISTS gpReport_Transport_Cost (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Transport_Cost (
    IN inStartDate        TDateTime ,  
    IN inEndDate          TDateTime ,
    IN inBusinessId       Integer   ,
    IN inBranchId         Integer   ,
    IN inUnitId           Integer   ,
    IN inCarId            Integer   ,
    IN inIsMovement       Boolean   ,
    IN inIsPartner        Boolean   ,
    IN inIsGoods          Boolean   ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Invnumber TVarChar, OperDate TDateTime, MovementDescName TVarChar
             --, FuelName TVarChar
             , CarModelName TVarChar, CarName TVarChar--, FuelMasterName TVarChar
             , RouteName TVarChar, PersonalDriverName TVarChar
             , UnitName TVarChar, BranchName TVarChar,  BusinessName TVarChar
             , PartnerName TVarChar
             , SummByPrint TFloat
             , ProfitLossGroupName TVarChar, ProfitLossDirectionName TVarChar, ProfitLossName TVarChar, ProfitLossName_all TVarChar
             , SumCount_Transport TFloat, SumAmount_Transport TFloat, PriceFuel TFloat
             , SumAmount_TransportAdd TFloat, SumAmount_TransportAddLong TFloat, SumAmount_TransportTaxi TFloat
             , SumAmount_TransportService TFloat, SumAmount_ServiceAdd TFloat, SumAmount_ServiceTotal TFloat, SumAmount_PersonalSendCash TFloat
             , SumTotal TFloat
             , Distance TFloat
             , WeightTransport TFloat
             , TotalWeight_Sale TFloat
             , TotalWeight_Doc  TFloat
             , TotalSumm_Sale TFloat
             , HoursWork TFloat
             , One_KM TFloat, One_KG TFloat
             , isAccount_50000 Boolean

             , MovemenId_Sale Integer
             , OperDate_Sale  TDateTime
             , Invnumber_Sale TVarChar
             , GoodsId        Integer
             , GoodsCode      Integer
             , GoodsName      TVarChar
             , GoodsKindId    Integer
             , GoodsKindName  TVarChar
             , Amount_Sale    TFloat
             , Weight_Sale    TFloat
             , Count_doc      TFloat
             , Count_TT       TFloat
             
             , Sum_one        TFloat  --итого расх на 1 точку = итого расходы / кол. тт в реестре
             , Weight_one     TFloat  --итого расх на 1 кг = итого расходы / кол. кг
             , Wage_kg        TFloat  --За вес грн/кг (0.05)            --Расходы ЗП водителей
             , Wage_Hours     TFloat  --За время грн/час (60)           --Расходы ЗП водителей
             , Wage_doc       TFloat  --За точку доставки грн (5)       --Расходы ЗП водителей
             , TotalWageSumm  TFloat  --Итого расходы на точку грн      -- Расходы ЗП водителей
             , TotalWageKg    TFloat  --Итого расходы на кг             --Расходы ЗП водителей
             , TotalSum_one   TFloat  --Итого расходы на точку грн      --ГСМ+ЗП
             , TotalSum_kg    TFloat  --Итого расходы на кг             --ГСМ+ЗП
             , SumTotal_calc  TFloat  -- итого затрата
             )   
AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE vbIsGroup Boolean;
BEGIN
      vbUserId:= lpGetUserBySession (inSession);

      -- !!!Только просмотр Аудитор!!!
      PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

      vbIsGroup:= (inSession = '');

    -- Результат
    RETURN QUERY
    WITH tmpAccount_50000 AS (SELECT * FROM Object_Account_View WHERE Object_Account_View.AccountGroupId = zc_Enum_AccountGroup_50000())
        , tmpContainer AS (SELECT tmpContainer.MovementId               
                                , tmpContainer.MovementDescId           
                                --, tmpContainer.FuelId
                                , SUM (tmpContainer.SumCount_Transport)         AS SumCount_Transport
                                , SUM (tmpContainer.SumAmount_Transport)        AS SumAmount_Transport
                                , SUM (tmpContainer.SumAmount_TransportAdd)     AS SumAmount_TransportAdd
                                , SUM (tmpContainer.SumAmount_TransportAddLong) AS SumAmount_TransportAddLong
                                , SUM (tmpContainer.SumAmount_TransportTaxi)    AS SumAmount_TransportTaxi
                                , SUM (tmpContainer.SumAmount_TransportService) AS SumAmount_TransportService
                                , SUM (tmpContainer.SumAmount_ServiceAdd)       AS SumAmount_ServiceAdd
                                , SUM (tmpContainer.SumAmount_PersonalSendCash) AS SumAmount_PersonalSendCash
                                , tmpContainer.CarId
                                , tmpContainer.UnitId
                                , tmpContainer.BranchId
                                , tmpContainer.PersonalDriverId
                                , tmpContainer.RouteId
                                , tmpContainer.ProfitLossId
                                , tmpContainer.BusinessId
                                , tmpContainer.isAccount_50000
                   
                                , (CASE WHEN tmpContainer.MovementDescId = zc_Movement_TransportService() THEN MIFloat_Distance.ValueData
                                       WHEN tmpContainer.MovementDescId = zc_Movement_Transport() THEN (MovementItem.Amount + COALESCE(MIFloat_Distance.ValueData,0))
                                       ELSE 0 END)   AS Distance
                                , (CASE WHEN tmpContainer.MovementDescId = zc_Movement_Transport() THEN MIFloat_WeightTransport.ValueData ELSE 0 END)  AS WeightTransport
                                
                           FROM (
                                  SELECT MIContainer.MovementId               AS MovementId
                                       , MIContainer.MovementDescId           AS MovementDescId
                                       , CASE WHEN MIContainer.MovementDescId = zc_Movement_Transport() AND MovementItem.Id IS NULL THEN MIContainer.ObjectId_Analyzer ELSE 0 END AS FuelId
                                       , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.MovementDescId = zc_Movement_Transport() THEN -1 * MIContainer.Amount ELSE 0 END) AS SumCount_Transport
                                       , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.MovementDescId = zc_Movement_Transport()        AND COALESCE (MIContainer.AnalyzerId, 0) IN (0, zc_Enum_AnalyzerId_ProfitLoss()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SumAmount_Transport
                                       , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.MovementDescId = zc_Movement_Transport()        AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Transport_Add() THEN -1 * MIContainer.Amount ELSE 0 END) AS SumAmount_TransportAdd
                                       , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.AnalyzerId     = zc_Enum_AnalyzerId_Transport_AddLong() THEN -1 * MIContainer.Amount ELSE 0 END) AS SumAmount_TransportAddLong
                                       , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.AnalyzerId     = zc_Enum_AnalyzerId_Transport_Taxi()    THEN -1 * MIContainer.Amount ELSE 0 END) AS SumAmount_TransportTaxi
                                       , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.MovementDescId = zc_Movement_TransportService() AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss()    THEN -1 * MIContainer.Amount ELSE 0 END) AS SumAmount_TransportService
                                       , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.MovementDescId = zc_Movement_TransportService() AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Transport_Add() THEN -1 * MIContainer.Amount ELSE 0 END) AS SumAmount_ServiceAdd
                                       , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.MovementDescId = zc_Movement_PersonalSendCash()         THEN -1 * MIContainer.Amount ELSE 0 END) AS SumAmount_PersonalSendCash
                                       , MIContainer.WhereObjectId_Analyzer          AS CarId
                                       , MIContainer.ObjectIntId_Analyzer            AS UnitId
                                       , MIContainer.ObjectExtId_Analyzer            AS BranchId
                                       , CASE WHEN MIContainer.MovementDescId = zc_Movement_Transport() AND COALESCE (MIContainer.AnalyzerId, 0) NOT IN (zc_Enum_AnalyzerId_Transport_Add(), zc_Enum_AnalyzerId_Transport_AddLong(), zc_Enum_AnalyzerId_Transport_Taxi()) THEN MovementLinkObject_PersonalDriver.ObjectId ELSE MIContainer.ObjectId_Analyzer END AS PersonalDriverId
                                       , COALESCE (MovementItem.ObjectId, MILinkObject_Route.ObjectId)  AS RouteId
                                       , CLO_ProfitLoss.ObjectId                     AS ProfitLossId
                                       , CLO_Business.ObjectId                       AS BusinessId
                                       , 0                                           AS ContainerId
                                     --, MIContainer.ContainerId
                                     --, CASE WHEN tmpAccount_50000.AccountId > 0 THEN TRUE ELSE FALSE END AS isAccount_50000
                                       , FALSE AS isAccount_50000
                               
                                  FROM MovementItemContainer AS MIContainer
                                       INNER JOIN ContainerLinkObject AS CLO_ProfitLoss
                                                                      ON CLO_ProfitLoss.ContainerId = MIContainer.ContainerId_Analyzer
                                                                     AND CLO_ProfitLoss.DescId      = zc_ContainerLinkObject_ProfitLoss()   
                                       LEFT JOIN ContainerLinkObject AS CLO_Business
                                                                     ON CLO_Business.ContainerId = MIContainer.ContainerId_Analyzer
                                                                    AND CLO_Business.DescId = zc_ContainerLinkObject_Business()
                                                           
                                       LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                                                    ON MovementLinkObject_PersonalDriver.MovementId = MIContainer.MovementId
                                                                   AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
         
                                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                                                        ON MILinkObject_Route.MovementItemId = MIContainer.MovementItemId
                                                                       AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
                                       LEFT JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId
                                                             AND MovementItem.DescId = zc_MI_Master()
                                                             AND MIContainer.MovementDescId = zc_Movement_Transport()
                                       -- LEFT JOIN tmpAccount_50000 ON tmpAccount_50000.AccountId = MIContainer.AccountId
                                       LEFT JOIN tmpAccount_50000 ON tmpAccount_50000.AccountId = MIContainer.AccountId_Analyzer
                                                      
                                  WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate  
                                    AND MIContainer.MovementDescId in (zc_Movement_Transport(), zc_Movement_TransportService(),zc_Movement_PersonalSendCash())
                                    -- AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss()
                                    AND (MIContainer.ObjectExtId_Analyzer   = inBranchId   OR inBranchId   = 0) -- филиал
                                    AND (MIContainer.ObjectIntId_Analyzer   = inUnitId     OR inUnitId     = 0) -- подразделение
                                    AND (MIContainer.WhereObjectId_Analyzer = inCarId      OR inCarId      = 0) -- Автомобиль
                                    AND (CLO_Business.ObjectId              = inBusinessId OR inBusinessId = 0) -- Бизнес  
                                 -- AND (CLO_ProfitLoss.ContainerId > 0 OR tmpAccount_50000.AccountId > 0)
                                 -- AND MIContainer.isActive = FALSE
                                  GROUP BY  MIContainer.MovementId, MIContainer.MovementDescId
                                          , MIContainer.ObjectId_Analyzer
                                          , MIContainer.WhereObjectId_Analyzer 
                                          , MIContainer.ObjectIntId_Analyzer 
                                          , MIContainer.ObjectExtId_Analyzer
                                          , CASE WHEN MIContainer.MovementDescId = zc_Movement_Transport() AND COALESCE (MIContainer.AnalyzerId, 0) NOT IN (zc_Enum_AnalyzerId_Transport_Add(), zc_Enum_AnalyzerId_Transport_AddLong(), zc_Enum_AnalyzerId_Transport_Taxi()) THEN MovementLinkObject_PersonalDriver.ObjectId ELSE MIContainer.ObjectId_Analyzer END
                                          , MILinkObject_Route.ObjectId
                                          , CLO_ProfitLoss.ObjectId
                                          , CLO_Business.ObjectId 
                                        --, MIContainer.ContainerId
                                          , MovementItem.Id
                                          , MovementItem.ObjectId
                                       -- , CASE WHEN tmpAccount_50000.AccountId > 0 THEN TRUE ELSE FALSE END
                                 UNION ALL
                                  SELECT MIContainer.MovementId               AS MovementId
                                       , MIContainer.MovementDescId           AS MovementDescId
                                       , CASE WHEN MIContainer.MovementDescId = zc_Movement_Transport() AND MovementItem.Id IS NULL THEN MIContainer.ObjectId_Analyzer ELSE 0 END AS FuelId
                                       , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.MovementDescId = zc_Movement_Transport() THEN -1 * MIContainer.Amount ELSE 0 END) AS SumCount_Transport
                                       , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.MovementDescId = zc_Movement_Transport()        AND COALESCE (MIContainer.AnalyzerId, 0) IN (0, zc_Enum_AnalyzerId_ProfitLoss()) THEN -1 * MIContainer.Amount ELSE 0 END) AS SumAmount_Transport
                                       , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.MovementDescId = zc_Movement_Transport()        AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Transport_Add() THEN -1 * MIContainer.Amount ELSE 0 END) AS SumAmount_TransportAdd
                                       , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.AnalyzerId     = zc_Enum_AnalyzerId_Transport_AddLong() THEN -1 * MIContainer.Amount ELSE 0 END) AS SumAmount_TransportAddLong
                                       , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.AnalyzerId     = zc_Enum_AnalyzerId_Transport_Taxi()    THEN -1 * MIContainer.Amount ELSE 0 END) AS SumAmount_TransportTaxi
                                       , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.MovementDescId = zc_Movement_TransportService() AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss()    THEN -1 * MIContainer.Amount ELSE 0 END) AS SumAmount_TransportService
                                       , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.MovementDescId = zc_Movement_TransportService() AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Transport_Add() THEN -1 * MIContainer.Amount ELSE 0 END) AS SumAmount_ServiceAdd
                                       , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.MovementDescId = zc_Movement_PersonalSendCash()         THEN -1 * MIContainer.Amount ELSE 0 END) AS SumAmount_PersonalSendCash
                                       , MIContainer.WhereObjectId_Analyzer          AS CarId
                                       , MIContainer.ObjectIntId_Analyzer            AS UnitId
                                       , MIContainer.ObjectExtId_Analyzer            AS BranchId
                                       , CASE WHEN MIContainer.MovementDescId = zc_Movement_Transport() AND COALESCE (MIContainer.AnalyzerId, 0) NOT IN (zc_Enum_AnalyzerId_Transport_Add(), zc_Enum_AnalyzerId_Transport_AddLong(), zc_Enum_AnalyzerId_Transport_Taxi()) THEN MovementLinkObject_PersonalDriver.ObjectId ELSE MIContainer.ObjectId_Analyzer END AS PersonalDriverId
                                       , COALESCE (MovementItem.ObjectId, MILinkObject_Route.ObjectId)  AS RouteId
                                       , MIContainer.AccountId_Analyzer              AS ProfitLossId
                                       , 0                                           AS BusinessId
                                       , 0                                           AS ContainerId
                                       -- , MIContainer.AnalyzerId
                                       , TRUE AS isAccount_50000
                               
                                  FROM MovementItemContainer AS MIContainer
                                       INNER JOIN tmpAccount_50000 ON tmpAccount_50000.AccountId = MIContainer.AccountId_Analyzer
                                                          
                                       LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                                                    ON MovementLinkObject_PersonalDriver.MovementId = MIContainer.MovementId
                                                                   AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
         
                                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                                                        ON MILinkObject_Route.MovementItemId = MIContainer.MovementItemId
                                                                       AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
                                       LEFT JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId
                                                             AND MovementItem.DescId = zc_MI_Master()
                                                             AND MIContainer.MovementDescId = zc_Movement_Transport()
                                                      
                                  WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate  
                                    AND MIContainer.MovementDescId in (zc_Movement_Transport(), zc_Movement_TransportService(),zc_Movement_PersonalSendCash())
                                    -- AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ProfitLoss()
                                    AND (MIContainer.ObjectExtId_Analyzer   = inBranchId   OR inBranchId   = 0) -- филиал
                                    AND (MIContainer.ObjectIntId_Analyzer   = inUnitId     OR inUnitId     = 0) -- подразделение
                                    AND (MIContainer.WhereObjectId_Analyzer = inCarId      OR inCarId      = 0) -- Автомобиль
                                    AND (                                                     inBusinessId = 0) -- Бизнес  
                                  GROUP BY  MIContainer.MovementId, MIContainer.MovementDescId
                                          , MIContainer.ObjectId_Analyzer
                                          , MIContainer.WhereObjectId_Analyzer 
                                          , MIContainer.ObjectIntId_Analyzer 
                                          , MIContainer.ObjectExtId_Analyzer
                                          , CASE WHEN MIContainer.MovementDescId = zc_Movement_Transport() AND COALESCE (MIContainer.AnalyzerId, 0) NOT IN (zc_Enum_AnalyzerId_Transport_Add(), zc_Enum_AnalyzerId_Transport_AddLong(), zc_Enum_AnalyzerId_Transport_Taxi()) THEN MovementLinkObject_PersonalDriver.ObjectId ELSE MIContainer.ObjectId_Analyzer END
                                          , MILinkObject_Route.ObjectId
                                          , MIContainer.AccountId_Analyzer
                                          , MovementItem.Id
                                          , MovementItem.ObjectId
                            ) AS tmpContainer   
                                 LEFT JOIN MovementItem ON MovementItem.MovementId = tmpContainer.MovementId
                                                       AND MovementItem.ObjectId   = tmpContainer.RouteId
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE
                                 LEFT JOIN MovementItemFloat AS MIFloat_Distance
                                                             ON MIFloat_Distance.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Distance.DescId = CASE WHEN tmpContainer.MovementDescId = zc_Movement_Transport() THEN zc_MIFloat_DistanceFuelChild()
                                                                                               WHEN tmpContainer.MovementDescId = zc_Movement_TransportService() THEN zc_MIFloat_Distance() END
                                LEFT JOIN MovementItemFloat AS MIFloat_WeightTransport
                                                            ON MIFloat_WeightTransport.MovementItemId = MovementItem.Id
                                                           AND MIFloat_WeightTransport.DescId = zc_MIFloat_Weight()--zc_MIFloat_WeightTransport()
                                GROUP BY tmpContainer.MovementId               
                                       , tmpContainer.MovementDescId           
--                                       , tmpContainer.FuelId
                                       , tmpContainer.CarId
                                       , tmpContainer.UnitId
                                       , tmpContainer.BranchId
                                       , tmpContainer.PersonalDriverId
                                       , tmpContainer.RouteId
                                       , tmpContainer.ProfitLossId
                                       , tmpContainer.BusinessId
                                       , tmpContainer.isAccount_50000
                                , (CASE WHEN tmpContainer.MovementDescId = zc_Movement_TransportService() THEN MIFloat_Distance.ValueData
                                       WHEN tmpContainer.MovementDescId = zc_Movement_Transport() THEN (MovementItem.Amount + COALESCE(MIFloat_Distance.ValueData,0))
                                       ELSE 0 END)
                                , (CASE WHEN tmpContainer.MovementDescId = zc_Movement_Transport() THEN MIFloat_WeightTransport.ValueData ELSE 0 END)
                          )
        -- выбираем данные путевых из реестра, получаем док. продаж которые указаны в реестре
        , tmpWeight1 AS (SELECT MLM_Transport.MovementChildId                  AS MovementTransportId
                              , MovementLinkObject_Car.ObjectId                AS CarId
                              , MovementLinkObject_PersonalDriver.ObjectId     AS PersonalDriverId
                              , MovementItem.Id                                AS MI_Id
                         FROM MovementLinkMovement AS MLM_Transport
                              JOIN Movement ON Movement.Id = MLM_Transport.MovementId 
                                           AND Movement.DescId = zc_Movement_Reestr()
                                           --AND Movement.OperDate = '21.10.2019'
                                           AND Movement.StatusId <> zc_Enum_Status_Erased()

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                                           ON MovementLinkObject_Car.MovementId = Movement.Id
                                                          AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                                           ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                                          AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()

                              LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
 
                         WHERE MLM_Transport.DescId = zc_MovementLinkMovement_Transport()
                           AND MLM_Transport.MovementChildId in (SELECT tmpContainer.MovementId FROM tmpContainer)
                        )

       -- 
        , tmpMF_HoursWork AS (SELECT *
                              FROM MovementFloat
                              WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpWeight1.MovementTransportId FROM tmpWeight1)
                                AND MovementFloat.DescId IN (zc_MovementFloat_HoursWork()
                                                           , zc_MovementFloat_HoursAdd())
                             )
            
        , tmpMF_MovementItemId AS (SELECT MovementFloat_MovementItemId.MovementId
                                        , MovementFloat_MovementItemId.ValueData :: Integer
                                   FROM MovementFloat AS MovementFloat_MovementItemId
                                   WHERE MovementFloat_MovementItemId.ValueData ::Integer IN (SELECT DISTINCT tmpWeight1.MI_Id FROM tmpWeight1)
                                     AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                                  )
 
        , tmpMLO_To AS (SELECT *
                        FROM MovementLinkObject AS MovementLinkObject_To
                        WHERE MovementLinkObject_To.MovementId IN (SELECT DISTINCT tmpMF_MovementItemId.MovementId FROM tmpMF_MovementItemId)
                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                         -- AND inIsPartner = TRUE
                        )

        , tmpMF_TotalCountKg AS (SELECT *
                                 FROM MovemenTFloat AS MovemenTFloat_TotalCountKg
                                 WHERE MovemenTFloat_TotalCountKg.MovementId IN (SELECT DISTINCT tmpMF_MovementItemId.MovementId FROM tmpMF_MovementItemId)
                                   AND MovemenTFloat_TotalCountKg.DescId = zc_MovemenTFloat_TotalCountKg()
                                 )
        , tmpMF_TotalSumm AS (SELECT *
                              FROM MovemenTFloat AS MovementFloat_TotalSumm
                              WHERE MovementFloat_TotalSumm.MovementId IN (SELECT DISTINCT tmpMF_MovementItemId.MovementId FROM tmpMF_MovementItemId)
                                AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                              )

        , tmpMLM_Order AS (SELECT *
                           FROM MovementLinkMovement AS MLM_Order
                           WHERE MLM_Order.MovementId IN (SELECT DISTINCT tmpMF_MovementItemId.MovementId FROM tmpMF_MovementItemId)
                             AND MLM_Order.DescId = zc_MovementLinkMovement_Order()
                           )

        , tmpMLO_Route AS (SELECT *
                           FROM MovementLinkObject AS MLO_Route
                           WHERE MLO_Route.MovementId IN (SELECT DISTINCT tmpMLM_Order.MovementChildId FROM tmpMLM_Order)
                             AND MLO_Route.DescId = zc_MovementLinkObject_Route()
                           )

        , tmpWeight AS (SELECT tmpWeight1.MovementTransportId
                             , tmpWeight1.CarId
                             , tmpWeight1.PersonalDriverId
                             , MLO_Route.ObjectId                             AS RouteId
                             , MovementFloat_MovementItemId.MovementId        AS MovementId_Sale
                             , MovementLinkObject_To.ObjectId                 AS PartnerId_Sale
                             , SUM (COALESCE (MovemenTFloat_TotalCountKg.ValueData,0))     AS TotalCountKg
                             , SUM (COALESCE (MovementFloat_TotalSumm.ValueData,0))        AS TotalSumm
                             , SUM (CAST (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) AS TFloat)) AS HoursWork
                        FROM tmpWeight1

                             LEFT JOIN tmpMF_HoursWork AS MovementFloat_HoursWork
                                                       ON MovementFloat_HoursWork.MovementId = tmpWeight1.MovementTransportId
                                                      AND MovementFloat_HoursWork.DescId = zc_MovementFloat_HoursWork()
                             
                             LEFT JOIN tmpMF_HoursWork AS MovementFloat_HoursAdd
                                                       ON MovementFloat_HoursAdd.MovementId = tmpWeight1.MovementTransportId
                                                      AND MovementFloat_HoursAdd.DescId = zc_MovementFloat_HoursAdd()

                             LEFT JOIN tmpMF_MovementItemId AS MovementFloat_MovementItemId
                                                            ON MovementFloat_MovementItemId.ValueData = tmpWeight1.MI_Id

                             LEFT JOIN tmpMLO_To AS MovementLinkObject_To
                                                 ON MovementLinkObject_To.MovementId = MovementFloat_MovementItemId.MovementId -- покупатель
                                                AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                             LEFT JOIN tmpMF_TotalCountKg AS MovemenTFloat_TotalCountKg
                                                          ON MovemenTFloat_TotalCountKg.MovementId = MovementFloat_MovementItemId.MovementId

                             LEFT JOIN tmpMF_TotalSumm AS MovementFloat_TotalSumm
                                                       ON MovementFloat_TotalSumm.MovementId = MovementFloat_MovementItemId.MovementId

                             LEFT JOIN tmpMLM_Order AS MLM_Order						-- из документа заявки получаем маршрут
                                                    ON MLM_Order.MovementId = MovementFloat_MovementItemId.MovementId
                                                  -- AND MLM_Order.DescId = zc_MovementLinkMovement_Order()

                             LEFT JOIN tmpMLO_Route AS MLO_Route
                                                          ON MLO_Route.MovementId = MLM_Order.MovementChildId
                                                         --AND MLO_Route.DescId = zc_MovementLinkObject_Route()
                        WHERE COALESCE (MovemenTFloat_TotalCountKg.ValueData,0) <> 0
                        GROUP BY tmpWeight1.MovementTransportId
                               , tmpWeight1.CarId
                               , tmpWeight1.PersonalDriverId
                               , MovementFloat_MovementItemId.MovementId
                               , MovementLinkObject_To.ObjectId
                               , MLO_Route.ObjectId
                       )
-----------------***-----------------------
        -- получение данных из док. продаж по товарам
       , tmpSale_MI AS (SELECT MovementItem.MovementId
                             , MovementItem.Id AS MI_Id
                             , MovementItem.ObjectId AS GoodsId
                             , SUM (MovementItem.Amount)    AS Amount
                         FROM (SELECT DISTINCT tmpWeight.MovementId_Sale FROM tmpWeight) AS tmpSale
                              INNER JOIN MovementItem ON MovementItem.MovementId = tmpSale.MovementId_Sale
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                         GROUP BY MovementItem.MovementId
                                , MovementItem.Id
                                , MovementItem.ObjectId
                       )
       , tmpMILO_GoodsKind AS (SELECT *
                               FROM MovementItemLinkObject
                               WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpSale_MI.MI_Id FROM tmpSale_MI)
                                 AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                                 AND inisGoods = TRUE
                              )

       , tmpMIF_AmountPartner AS (SELECT *
                                  FROM MovementItemFloat AS MIFloat_AmountPartner
                                  WHERE MIFloat_AmountPartner.MovementItemId IN (SELECT DISTINCT tmpSale_MI.MI_Id FROM tmpSale_MI)
                                   AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                  )
       , tmpMIF_Price AS (SELECT *
                             FROM MovementItemFloat AS MIFloat_AmountPartner
                             WHERE MIFloat_AmountPartner.MovementItemId IN (SELECT DISTINCT tmpSale_MI.MI_Id FROM tmpSale_MI)
                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_Price()
                             )

       , tmpMIF_CountForPrice AS (SELECT *
                             FROM MovementItemFloat AS MIFloat_AmountPartner
                             WHERE MIFloat_AmountPartner.MovementItemId IN (SELECT DISTINCT tmpSale_MI.MI_Id FROM tmpSale_MI)
                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_CountForPrice()
                             )

        , tmpSale_Goods AS (SELECT tmpSale_MI.MovementId
                                 , CASE WHEN inisGoods = TRUE THEN tmpSale_MI.GoodsId ELSE 0 END AS GoodsId
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                 --, SUM (tmpSale_MI.Amount) AS Amount
                                 --, SUM (tmpSale_MI.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS Weight
                                 , SUM (MIFloat_AmountPartner.ValueData) AS Amount
                                 , SUM (MIFloat_AmountPartner.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS Weight
                                 , SUM (CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                                   THEN CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0)) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                                                   ELSE CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0)) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                                               END AS TFloat) )                   AS AmountSumm

                            FROM tmpSale_MI
                                 LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = tmpSale_MI.MI_Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                                 LEFT JOIN tmpMIF_AmountPartner AS MIFloat_AmountPartner
                                                                ON MIFloat_AmountPartner.MovementItemId = tmpSale_MI.MI_Id
                                 LEFT JOIN tmpMIF_Price AS MIFloat_Price
                                                                ON MIFloat_Price.MovementItemId = tmpSale_MI.MI_Id
                                 LEFT JOIN tmpMIF_CountForPrice AS MIFloat_CountForPrice
                                                                ON MIFloat_CountForPrice.MovementItemId = tmpSale_MI.MI_Id

                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure 
                                                      ON ObjectLink_Goods_Measure.ObjectId = tmpSale_MI.GoodsId
                                                     AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                       ON ObjectFloat_Weight.ObjectId = tmpSale_MI.GoodsId
                                                      AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

                            GROUP BY tmpSale_MI.MovementId
                                   , CASE WHEN inisGoods = TRUE THEN tmpSale_MI.GoodsId ELSE 0 END
                                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                   
                             )

        -- считаем кол-во точек в реестре
        , tmpTT AS (SELECT tmp.MovementTransportId
                           , COUNT (*) AS Count_TT
                      FROM (SELECT DISTINCT 
                                 tmpWeight.MovementTransportId 
                               , tmpWeight.PartnerId_Sale
                            FROM tmpWeight
                            ) AS tmp
                      GROUP BY tmp.MovementTransportId
                      )
                      

        , tmpWeight_All AS (SELECT DISTINCT
                                   tmpWeight.MovementTransportId 
                                 , tmpWeight.TotalCountKg
                                 , tmpWeight.TotalSumm
                                 , tmpWeight.HoursWork
                                 , COALESCE (tmpContainer.CarId, tmpContainer2.CarId, tmpWeight.CarId)    AS CarId
                                 --, tmpContainer.FuelId
                                 , COALESCE (tmpContainer.UnitId,tmpContainer2.UnitId)                    AS UnitId
                                 , COALESCE (tmpContainer.BranchId, tmpContainer2.BranchId)               AS BranchId
                                 , COALESCE (tmpContainer.PersonalDriverId, tmpContainer2.PersonalDriverId, tmpWeight.PersonalDriverId)  AS PersonalDriverId
                                 , COALESCE (tmpContainer.RouteId, tmpContainer2.RouteId)                 AS RouteId --tmpWeight.RouteId
                                 , COALESCE (tmpContainer.ProfitLossId,tmpContainer2.ProfitLossId )       AS ProfitLossId
                                 , COALESCE (tmpContainer.BusinessId, tmpContainer2.BusinessId)           AS BusinessId
                                 , COALESCE (tmpContainer.isAccount_50000,tmpContainer2.isAccount_50000)  AS isAccount_50000
                                 , tmpWeight.PartnerId_Sale
                                 , tmpWeight.MovementId_Sale
                                 , tmpTT.Count_TT
                                 , 1 AS Count_doc
                            FROM tmpWeight
                                 LEFT JOIN tmpContainer ON tmpContainer.MovementId = tmpWeight.MovementTransportId
                                                       AND tmpContainer.RouteId    = tmpWeight.RouteId

                                 -- И второй раз если не совпадают маршруты
                                 LEFT JOIN (SELECT tmpContainer.CarId
                                                 , tmpContainer.UnitId
                                                 , tmpContainer.BranchId
                                                 , tmpContainer.PersonalDriverId
                                                 , tmpContainer.ProfitLossId
                                                 , tmpContainer.BusinessId
                                                 , tmpContainer.isAccount_50000
                                                 , tmpContainer.MovementId
                                                 , MAX (tmpContainer.RouteId) AS RouteId
                                            FROM  tmpContainer
                                            GROUP BY tmpContainer.CarId
                                                   , tmpContainer.UnitId
                                                   , tmpContainer.BranchId
                                                   , tmpContainer.PersonalDriverId
                                                   , tmpContainer.ProfitLossId
                                                   , tmpContainer.BusinessId
                                                   , tmpContainer.isAccount_50000
                                                   , tmpContainer.MovementId
                                            ) AS tmpContainer2 ON tmpContainer2.MovementId = tmpWeight.MovementTransportId
                                                             -- AND tmpContainer.RouteId IS NULL 
                                                             -- and 1=0

                                 LEFT JOIN tmpTT ON tmpTT.MovementTransportId = tmpWeight.MovementTransportId
                            )

           



        , tmpUnion AS (SELECT tmpAll.MovementId
                            , tmpAll.CarId
                            --, tmpAll.FuelId
                            , tmpAll.UnitId
                            , tmpAll.BranchId
                            , tmpAll.PersonalDriverId
                            , tmpAll.RouteId
                            , tmpAll.ProfitLossId
                            , tmpAll.BusinessId
                            , tmpAll.isAccount_50000
                            , (tmpAll.WeightSale)                    AS WeightSale
                            , SUM(tmpAll.TotalSummsale)              AS TotalSummSale
                            , SUM(tmpAll.HoursWork)                  AS HoursWork
                            , SUM(tmpAll.SumCount_Transport)         AS SumCount_Transport
                            , SUM(tmpAll.SumAmount_Transport)        AS SumAmount_Transport
                            , SUM(COALESCE (tmpAll.SumAmount_TransportAdd,0))     AS SumAmount_TransportAdd
                            , SUM(tmpAll.SumAmount_TransportAddLong) AS SumAmount_TransportAddLong
                            , SUM(tmpAll.SumAmount_TransportTaxi)    AS SumAmount_TransportTaxi
                            , SUM(tmpAll.SumAmount_TransportService) AS SumAmount_TransportService
                            , SUM(tmpAll.SumAmount_ServiceAdd)       AS SumAmount_ServiceAdd
                            , SUM(tmpAll.SumAmount_PersonalSendCash) AS SumAmount_PersonalSendCash
                            , SUM (tmpAll.SumAmount_TransportService + tmpAll.SumAmount_ServiceAdd) :: TFloat AS SumAmount_ServiceTotal
                            , CASE WHEN SUM (tmpAll.SumCount_Transport)<>0 THEN CAST (SUM (tmpAll.SumAmount_Transport)/SUM (tmpAll.SumCount_Transport) AS NUMERIC (16, 4)) ELSE 0 END :: TFloat AS PriceFuel
                            , SUM (tmpAll.SumAmount_Transport 
                                 + COALESCE (tmpAll.SumAmount_TransportAdd,0)
                                 + tmpAll.SumAmount_TransportAddLong 
                                 + tmpAll.SumAmount_TransportTaxi 
                                 + tmpAll.SumAmount_TransportService
                                 + tmpAll.SumAmount_ServiceAdd
                                 + tmpAll.SumAmount_PersonalSendCash) :: TFloat AS SumTotal
                            , SUM(tmpAll.Distance)        AS Distance
                            , SUM(tmpAll.WeightTransport) AS WeightTransport
                            , CAST (CASE WHEN SUM (tmpAll.Distance) <> 0 THEN SUM (tmpAll.SumAmount_Transport + COALESCE (tmpAll.SumAmount_TransportAdd,0) + tmpAll.SumAmount_TransportAddLong + tmpAll.SumAmount_TransportTaxi + tmpAll.SumAmount_TransportService + tmpAll.SumAmount_ServiceAdd + tmpAll.SumAmount_PersonalSendCash) / SUM (tmpAll.Distance) 
                                         ELSE 0 END  AS TFloat)  AS One_KM
                            , CAST (CASE WHEN SUM (tmpAll.WeightTransport) <> 0 THEN  SUM (tmpAll.SumAmount_Transport + COALESCE (tmpAll.SumAmount_TransportAdd,0) + tmpAll.SumAmount_TransportAddLong + tmpAll.SumAmount_TransportTaxi + tmpAll.SumAmount_TransportService + tmpAll.SumAmount_ServiceAdd + tmpAll.SumAmount_PersonalSendCash) /SUM (tmpAll.WeightTransport)
                                         ELSE 0 END AS TFloat)  AS One_KG
                            , tmpAll.MovementId_Sale
                            , tmpAll.PartnerId_Sale
                            , (tmpAll.Count_doc) AS Count_doc
                            , (tmpAll.Count_TT)  AS Count_TT
        
                       FROM (SELECT tmpContainer.MovementId
                                  , tmpContainer.CarId
                                  , tmpContainer.UnitId
                                  , tmpContainer.BranchId
                                  , tmpContainer.PersonalDriverId
                                  , tmpContainer.RouteId
                                  , tmpContainer.BusinessId
                                  , tmpContainer.ProfitLossId
                                  , tmpContainer.isAccount_50000
                                  --, tmpWeight_All.TotalCountKg AS WeightSale
                                  , SUM (tmpWeight_All.TotalCountKg) OVER (PARTITION BY tmpWeight_All.MovementTransportId/*CASE WHEN inisMovement = TRUE THEN tmpWeight_All.MovementTransportId ELSE 1 END*/
                                                                                      , tmpContainer.CarId
                                                                                      , tmpContainer.UnitId
                                                                                      , tmpContainer.BranchId
                                                                                      , tmpContainer.PersonalDriverId
                                                                                      , tmpContainer.RouteId
                                                                                      , tmpContainer.BusinessId
                                                                                      , tmpContainer.isAccount_50000
                                                                                      , tmpContainer.ProfitLossId) AS WeightSale
                                  , tmpWeight_All.TotalSumm    AS TotalSummSale
                                  , tmpWeight_All.HoursWork
                                  , tmpContainer.SumCount_Transport
                                  , tmpContainer.SumAmount_Transport
                                  , COALESCE (tmpContainer.SumAmount_TransportAdd,0) AS SumAmount_TransportAdd
                                  , tmpContainer.SumAmount_TransportAddLong
                                  , tmpContainer.SumAmount_TransportTaxi
                                  , tmpContainer.SumAmount_TransportService
                                  , tmpContainer.SumAmount_ServiceAdd
                                  , tmpContainer.SumAmount_PersonalSendCash
                                  , tmpContainer.Distance
                                  , tmpContainer.WeightTransport
                                  , tmpWeight_All.MovementId_Sale
                                  , CASE WHEN inIsPartner = TRUE THEN tmpWeight_All.PartnerId_Sale ELSE 0 END AS PartnerId_Sale
                                  , SUM (tmpWeight_All.Count_doc) OVER (PARTITION BY tmpWeight_All.MovementTransportId --CASE WHEN inisMovement = TRUE THEN tmpWeight_All.MovementTransportId ELSE 1 END
                                                                                   , tmpContainer.CarId
                                                                                   , tmpContainer.UnitId
                                                                                   , tmpContainer.BranchId
                                                                                   , tmpContainer.PersonalDriverId
                                                                                   , tmpContainer.RouteId
                                                                                   , tmpContainer.BusinessId
                                                                                   , tmpContainer.ProfitLossId
                                                                                   ) AS Count_doc
                                  , tmpWeight_All.Count_TT
                             FROM tmpContainer
                                  LEFT JOIN tmpWeight_All ON tmpWeight_All.MovementTransportId = tmpContainer.MovementId
                                                         AND tmpWeight_All.CarId = tmpContainer.CarId
                                                         AND tmpWeight_All.UnitId = tmpContainer.UnitId
                                                         AND COALESCE (tmpWeight_All.BranchId,0) = COALESCE (tmpContainer.BranchId,0)
                                                         AND tmpWeight_All.PersonalDriverId = tmpContainer.PersonalDriverId
                                                         AND tmpWeight_All.RouteId = tmpContainer.RouteId
                                                         AND COALESCE (tmpWeight_All.BusinessId,0) = COALESCE (tmpContainer.BusinessId,0)
                                                         AND tmpWeight_All.isAccount_50000 = tmpContainer.isAccount_50000
                                                         AND tmpWeight_All.ProfitLossId = tmpContainer.ProfitLossId
                         
                                                         

                             ) AS tmpAll

                       GROUP BY tmpAll.MovementId
                              , tmpAll.CarId
                              , tmpAll.UnitId
                              , tmpAll.BranchId
                              , tmpAll.PersonalDriverId
                              , tmpAll.RouteId
                              , tmpAll.BusinessId
                              , tmpAll.ProfitLossId
                              , tmpAll.isAccount_50000
                              , tmpAll.MovementId_Sale
                              , tmpAll.PartnerId_Sale
                              , tmpAll.Count_doc
                              , tmpAll.WeightSale
                              , tmpAll.Count_TT
                       )

        , tmpData1 AS (SELECT tmpUnion.MovementId_Sale
                            , tmpUnion.MovementId
                            , tmpUnion.RouteId
                            , tmpUnion.UnitId
                            , tmpUnion.PersonalDriverId
                            , tmpUnion.CarId
                            , tmpUnion.BusinessId
                            , tmpUnion.ProfitLossId
                            , tmpUnion.PartnerId_Sale

                           , tmpSale_Goods.GoodsId      AS GoodsId
                           , tmpSale_Goods.GoodsKindId  AS GoodsKindId

                           , tmpUnion.One_KM
                           , tmpUnion.One_KG
                           , tmpUnion.isAccount_50000 :: Boolean AS isAccount_50000

                           , (tmpUnion.SumCount_Transport)         :: TFloat  AS SumCount_Transport 
                           , (tmpUnion.SumAmount_Transport)        :: TFloat  AS SumAmount_Transport
                           , (tmpUnion.PriceFuel)
                           , (tmpUnion.SumAmount_TransportAdd)     :: TFloat AS SumAmount_TransportAdd
                           , (tmpUnion.SumAmount_TransportAddLong) :: TFloat AS SumAmount_TransportAddLong
                           , (tmpUnion.SumAmount_TransportTaxi)    :: TFloat AS SumAmount_TransportTaxi
                           , (tmpUnion.SumAmount_TransportService) :: TFloat AS SumAmount_TransportService
                           , (tmpUnion.SumAmount_ServiceAdd)       :: TFloat AS SumAmount_ServiceAdd
                           , (tmpUnion.SumAmount_ServiceTotal)
                           , (tmpUnion.SumAmount_PersonalSendCash) :: TFloat AS SumAmount_PersonalSendCash
                           , (tmpUnion.SumTotal)
               
                           , (tmpUnion.Distance)       :: TFloat  AS Distance
                           , (tmpUnion.WeightTransport):: TFloat  AS WeightTransport
                           , (tmpUnion.WeightSale)     :: TFloat  AS TotalWeight_Sale
                         --, SUM (COALESCE (tmpSale.Weight,0))          :: TFloat  AS TotalWeight_Doc
                           , SUM (COALESCE (tmpSale_Goods.Weight,0))          :: TFloat  AS TotalWeight_Doc
                             -- доля накладной в общем весе путевого
                           , CASE WHEN inIsGoods = TRUE
                                  THEN CASE WHEN COALESCE(tmpUnion.WeightSale,0) <> 0 THEN SUM (tmpSale_Goods.Weight) / tmpUnion.WeightSale ELSE 1 END
                                  ELSE CASE WHEN COALESCE(tmpUnion.WeightSale,0) <> 0 THEN SUM (tmpSale.Weight) / tmpUnion.WeightSale ELSE 1 END
                             END AS Koeff_kg  
                          -- , SUM (tmpUnion.TotalSummSale)::TFloat AS TotalSumm_Sale
                           , SUM (COALESCE (tmpSale_Goods.AmountSumm,0))::TFloat  AS TotalSumm_Sale
                           ,  (COALESCE (tmpUnion.HoursWork,0))      ::TFloat  AS HoursWork
                          
                           , SUM (COALESCE (tmpSale_Goods.Amount,0))  ::TFloat AS Amount_Sale
                           , SUM (COALESCE (tmpSale_Goods.Weight,0))  ::TFloat AS Weight_Sale
                           --, SUM (tmpUnion.Count_doc)    :: TFloat AS Count_doc-- кол. накладных
                           , (tmpUnion.Count_doc)  AS Count_doc
                           , tmpUnion.Count_TT
                           
                           --, SUM (tmpSale_Goods.Weight  * 0.05)  :: TFloat AS Wage_kg    --За вес грн/кг (0.05)       --Расходы ЗП водителей
                           , SUM (COALESCE (tmpSale.Weight,0)     * 0.05)  :: TFloat AS Wage_kg    --За вес грн/кг (0.05)       --Расходы ЗП водителей
                           ,  (COALESCE (tmpUnion.HoursWork,0) * 60)    :: TFloat AS Wage_Hours --За время грн/час (60)      --Расходы ЗП водителей
                           , SUM (COALESCE (tmpUnion.Count_doc,0) * 5)     :: TFloat AS Wage_doc   --За точку доставки грн (5)  --Расходы ЗП водителей
                       FROM tmpUnion
               
                                LEFT JOIN tmpSale_Goods ON tmpSale_Goods.MovementId = tmpUnion.MovementId_Sale
                                LEFT JOIN (SELECT tmpSale_Goods.MovementId, SUM(COALESCE (tmpSale_Goods.Weight,0)) AS Weight 
                                           FROM tmpSale_Goods GROUP BY tmpSale_Goods.MovementId
                                           ) AS tmpSale ON tmpSale.MovementId = tmpUnion.MovementId_Sale
               
                     GROUP BY tmpUnion.MovementId_Sale
                            , tmpUnion.MovementId
                            , tmpUnion.RouteId
                            , tmpUnion.UnitId
                            , tmpUnion.PersonalDriverId
                            , tmpUnion.CarId
                            , tmpUnion.BusinessId
                            , tmpUnion.ProfitLossId
                            , tmpUnion.PartnerId_Sale
                            
                            , tmpSale_Goods.GoodsId
                            , tmpSale_Goods.GoodsKindId
                            , tmpUnion.One_KM
                            , tmpUnion.One_KG
                            , tmpUnion.isAccount_50000
                            , tmpUnion.SumCount_Transport
                            , tmpUnion.SumAmount_Transport
                            , (tmpUnion.PriceFuel)
                            , (tmpUnion.SumAmount_TransportAdd)
                            , (tmpUnion.SumAmount_TransportAddLong)
                            , (tmpUnion.SumAmount_TransportTaxi)
                            , (tmpUnion.SumAmount_TransportService)
                            , (tmpUnion.SumAmount_ServiceAdd)
                            , (tmpUnion.SumAmount_ServiceTotal)
                            , (tmpUnion.SumAmount_PersonalSendCash)
                            , (tmpUnion.SumTotal)
                            , (tmpUnion.Distance)
                            , (tmpUnion.WeightTransport)
                            , tmpUnion.HoursWork
                            , tmpUnion.Count_doc
                            , tmpUnion.WeightSale
                            , tmpUnion.Count_TT
                            --, tmpSale.Weight
                            --, CASE WHEN COALESCE(tmpUnion.WeightSale,0) <> 0 THEN (tmpSale.Weight) * 100 / tmpUnion.WeightSale ELSE 0 END
                      )

        , tmpData AS ( SELECT COALESCE (Movement.Invnumber, '') :: TVarChar          AS Invnumber
                           , COALESCE (Movement.OperDate, CAST (NULL as TDateTime)) AS OperDate
                           , COALESCE (MovementDesc.ItemName, '') :: TVarChar       AS MovementDescName
                            , tmpUnion.RouteId
                            , tmpUnion.UnitId
                            , tmpUnion.PersonalDriverId
                            , tmpUnion.CarId
                            , tmpUnion.BusinessId
                            , tmpUnion.ProfitLossId
                            , tmpUnion.PartnerId_Sale
                           , Movemen_Sale.Id            AS MovemenId_Sale
                           , Movemen_Sale.OperDate      AS OperDate_Sale
                           , Movemen_Sale.Invnumber     AS Invnumber_Sale

                           , tmpUnion.GoodsId      AS GoodsId
                           , tmpUnion.GoodsKindId  AS GoodsKindId

                           , tmpUnion.One_KM
                           , tmpUnion.One_KG
                           , tmpUnion.isAccount_50000 :: Boolean AS isAccount_50000

                            , SUM (tmpUnion.SumCount_Transport * tmpUnion.Koeff_kg) AS SumCount_Transport
                            , SUM (tmpUnion.SumAmount_Transport * tmpUnion.Koeff_kg) AS SumAmount_Transport
                           , (tmpUnion.PriceFuel)
                           , SUM (tmpUnion.SumAmount_TransportAdd * tmpUnion.Koeff_kg)     :: TFloat AS SumAmount_TransportAdd
                           , SUM (tmpUnion.SumAmount_TransportAddLong * tmpUnion.Koeff_kg) :: TFloat AS SumAmount_TransportAddLong
                           , SUM (tmpUnion.SumAmount_TransportTaxi * tmpUnion.Koeff_kg)    :: TFloat AS SumAmount_TransportTaxi
                           , SUM (tmpUnion.SumAmount_TransportService * tmpUnion.Koeff_kg) :: TFloat AS SumAmount_TransportService
                           , SUM (tmpUnion.SumAmount_ServiceAdd * tmpUnion.Koeff_kg)       :: TFloat AS SumAmount_ServiceAdd
                           , SUM (tmpUnion.SumAmount_ServiceTotal * tmpUnion.Koeff_kg) AS SumAmount_ServiceTotal
                           , SUM (tmpUnion.SumAmount_PersonalSendCash * tmpUnion.Koeff_kg) :: TFloat AS SumAmount_PersonalSendCash
                           , SUM (tmpUnion.SumTotal * tmpUnion.Koeff_kg) AS SumTotal
                           , CASE WHEN inIsGoods = TRUE -- OR 1=1
                                  THEN tmpUnion.SumTotal * tmpUnion.Koeff_kg
                                  ELSE tmpUnion.SumTotal
                             END AS SumTotal_calc
               
                           , (tmpUnion.Distance)       :: TFloat  AS Distance
                           , (tmpUnion.WeightTransport):: TFloat  AS WeightTransport
                           , (tmpUnion.TotalWeight_Sale)     :: TFloat  AS TotalWeight_Sale
                           , CASE WHEN inIsGoods = TRUE -- OR 1=1
                                  THEN SUM (COALESCE (tmpUnion.TotalWeight_Doc,0) * tmpUnion.Koeff_kg)
                                  ELSE SUM (COALESCE (tmpUnion.TotalWeight_Doc,0))
                             END :: TFloat  AS TotalWeight_Doc

                           , CASE WHEN inIsGoods = TRUE OR 1=1
                                  THEN SUM (COALESCE (tmpUnion.TotalSumm_Sale,0) * tmpUnion.Koeff_kg)
                                  ELSE SUM (COALESCE (tmpUnion.TotalSumm_Sale,0))
                             END :: TFloat  AS TotalSumm_Sale

                           , (COALESCE (tmpUnion.HoursWork,0))      ::TFloat  AS HoursWork
                          
                           , CASE WHEN inIsGoods = TRUE
                                  THEN SUM (COALESCE (tmpUnion.Amount_Sale,0) * 1)
                                  ELSE SUM (COALESCE (tmpUnion.Amount_Sale,0))
                             END :: TFloat  AS Amount_Sale
                           , CASE WHEN inIsGoods = TRUE
                                  THEN SUM (COALESCE (tmpUnion.Weight_Sale,0) * 1)
                                  ELSE SUM (COALESCE (tmpUnion.Weight_Sale,0))
                             END :: TFloat  AS Weight_Sale

                           --, SUM (tmpUnion.Count_doc)    :: TFloat AS Count_doc-- кол. накладных
                           , (tmpUnion.Count_doc)  AS Count_doc
                           , tmpUnion.Count_TT

                             -- За вес грн/кг (0.05)       --Расходы ЗП водителей
                           , CASE WHEN inIsGoods = TRUE OR 1=1
                                  THEN SUM (COALESCE (tmpUnion.Wage_kg,0) * tmpUnion.Koeff_kg)
                                  ELSE SUM (COALESCE (tmpUnion.Wage_kg,0))
                             END :: TFloat  AS Wage_kg
                             -- За время грн/час (60)      --Расходы ЗП водителей
                           , CASE WHEN inIsGoods = TRUE OR 1=1
                                  THEN SUM (COALESCE (tmpUnion.Wage_Hours,0) * tmpUnion.Koeff_kg)
                                  ELSE SUM  (COALESCE (tmpUnion.Wage_Hours,0))
                             END :: TFloat  AS Wage_Hours
                             -- За точку доставки грн (5)  --Расходы ЗП водителей
                           , CASE WHEN inIsGoods = TRUE OR 1=1
                                  THEN SUM (COALESCE (tmpUnion.Wage_doc,0) * tmpUnion.Koeff_kg)
                                  ELSE SUM (COALESCE (tmpUnion.Wage_doc,0))
                             END :: TFloat  AS Wage_doc

                           , ROW_NUMBER() OVER (PARTITION BY tmpUnion.MovementId, tmpUnion.PartnerId_Sale ORDER BY tmpUnion.SumTotal DESC) AS Ord_TT

                       FROM tmpData1 AS tmpUnion
              
                                LEFT JOIN Movement ON Movement.Id = tmpUnion.MovementId
                                                 -- AND inisMovement = TRUE

                                LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId 
               
                                LEFT JOIN Movement AS Movemen_Sale
                                                   ON Movemen_Sale.Id = tmpUnion.MovementId_Sale
                                                 --  AND inisMovement = TRUE
               
                     GROUP BY tmpUnion.MovementId
                            , COALESCE (Movement.Invnumber, '')
                            , COALESCE (Movement.OperDate, CAST (NULL as TDateTime))
                            , COALESCE (MovementDesc.ItemName, '')
                            , tmpUnion.RouteId
                            , tmpUnion.UnitId
                            , tmpUnion.PersonalDriverId
                            , tmpUnion.CarId
                            , tmpUnion.BusinessId
                            , tmpUnion.ProfitLossId
                            , tmpUnion.PartnerId_Sale
                            
                            , Movemen_Sale.Id
                            , Movemen_Sale.OperDate
                            , Movemen_Sale.Invnumber
                            , tmpUnion.GoodsId
                            , tmpUnion.GoodsKindId
                            , tmpUnion.One_KM
                            , tmpUnion.One_KG
                            , tmpUnion.isAccount_50000
                            --, (tmpUnion.SumCount_Transport)
                            --, (tmpUnion.SumAmount_Transport)
                            , (tmpUnion.PriceFuel)
                            /*, (tmpUnion.SumAmount_TransportAdd)
                            , (tmpUnion.SumAmount_TransportAddLong)
                            , (tmpUnion.SumAmount_TransportTaxi)
                            , (tmpUnion.SumAmount_TransportService)
                            , (tmpUnion.SumAmount_ServiceAdd)
                            */
                            --, (tmpUnion.SumAmount_ServiceTotal)
                            --, (tmpUnion.SumAmount_PersonalSendCash)
                            , tmpUnion.SumTotal
                            , CASE WHEN inIsGoods = TRUE -- OR 1=1
                                   THEN tmpUnion.SumTotal * tmpUnion.Koeff_kg
                                   ELSE tmpUnion.SumTotal
                              END
                            , (tmpUnion.Distance)
                            , (tmpUnion.WeightTransport)
                            , tmpUnion.HoursWork
                            , tmpUnion.Count_doc
                            , tmpUnion.TotalWeight_Sale
                            , tmpUnion.Count_TT
                            --, tmpSale.Weight
                            --, CASE WHEN COALESCE(tmpUnion.WeightSale,0) <> 0 THEN (tmpSale.Weight) * 100 / tmpUnion.WeightSale ELSE 0 END
                      )


       -- Результат
       SELECT COALESCE (tmpUnion.Invnumber, '') :: TVarChar          AS Invnumber
            , COALESCE (tmpUnion.OperDate, CAST (NULL as TDateTime)) AS OperDate
            , COALESCE (tmpUnion.MovementDescName, '') :: TVarChar       AS MovementDescName
            , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
            , Object_Car.ValueData             AS CarName
           
            , Object_Route.ValueData           AS RouteName
            , Object_PersonalDriver.ValueData  AS PersonalDriverName
            , Object_Unit_View.Name            AS UnitName
            , Object_Unit_View.BranchName
            , Object_Business.ValueData        AS BusinessName                         --10
            , Object_Partner.ValueData         AS PartnerName
            
            -- если сумма больше 0 показываем в печати наименование 
            , SUM (COALESCE (tmpUnion.Weight_Sale,0)
                 + COALESCE (CASE WHEN COALESCE (tmpUnion.Count_TT,0) <> 0 THEN tmpUnion.SumTotal / tmpUnion.Count_TT ELSE 0 END,0)
                 + COALESCE (tmpUnion.Wage_doc,0)
                 + COALESCE (tmpUnion.Wage_Hours,0)
                 + COALESCE (tmpUnion.Wage_kg,0)
                 ) OVER (PARTITION BY Object_Route.ValueData) :: TFloat AS SummByPrint

            , COALESCE (View_ProfitLoss.ProfitLossGroupName, View_Account.AccountGroupName)         :: TVarChar AS ProfitLossGroupName
            , COALESCE (View_ProfitLoss.ProfitLossDirectionName, View_Account.AccountDirectionName) :: TVarChar AS ProfitLossDirectionName
            , COALESCE (View_ProfitLoss.ProfitLossName, View_Account.AccountName)                   :: TVarChar AS ProfitLossName
            , COALESCE (View_ProfitLoss.ProfitLossName_all, View_Account.AccountName_all)           :: TVarChar AS ProfitLossName_all

            , CAST (tmpUnion.SumCount_Transport AS NUMERIC (16,2))   :: TFloat  AS SumCount_Transport 
            , CAST (tmpUnion.SumAmount_Transport AS NUMERIC (16,2))  :: TFloat  AS SumAmount_Transport
            , (tmpUnion.PriceFuel)
            , (tmpUnion.SumAmount_TransportAdd)     :: TFloat AS SumAmount_TransportAdd
            , (tmpUnion.SumAmount_TransportAddLong) :: TFloat AS SumAmount_TransportAddLong
            , (tmpUnion.SumAmount_TransportTaxi)    :: TFloat AS SumAmount_TransportTaxi
            , (tmpUnion.SumAmount_TransportService) :: TFloat AS SumAmount_TransportService
            , (tmpUnion.SumAmount_ServiceAdd)       :: TFloat AS SumAmount_ServiceAdd
            , CAST (tmpUnion.SumAmount_ServiceTotal AS NUMERIC (16,2))       :: TFloat AS SumAmount_ServiceTotal                                           --20 
            , (tmpUnion.SumAmount_PersonalSendCash) :: TFloat AS SumAmount_PersonalSendCash
            , CAST (tmpUnion.SumTotal AS NUMERIC (16,2)) :: TFloat AS SumTotal

            , (tmpUnion.Distance)       :: TFloat  AS Distance
            , (tmpUnion.WeightTransport):: TFloat  AS WeightTransport
            , (tmpUnion.TotalWeight_Sale) :: TFloat  AS TotalWeight_Sale
            , (tmpUnion.TotalWeight_Doc) ::TFloat  AS TotalWeight_Doc
            , (tmpUnion.TotalSumm_Sale)::TFloat AS TotalSumm_Sale
            , (tmpUnion.HoursWork)  :: TFloat  AS HoursWork
            , tmpUnion.One_KM
            , tmpUnion.One_KG
            , tmpUnion.isAccount_50000 :: Boolean AS isAccount_50000                             --30
            
            , tmpUnion.MovemenId_Sale
            , tmpUnion.OperDate_Sale
            , tmpUnion.Invnumber_Sale

            , Object_Goods.Id            AS GoodsId
            , Object_Goods.ObjectCode    AS GoodsCode
            , Object_Goods.ValueData     AS GoodsName

            , Object_GoodsKind.Id         AS GoodsKindId
            , Object_GoodsKind.ValueData  AS GoodsKindName
            , tmpUnion.Amount_Sale    ::TFloat AS Amount_Sale
            , tmpUnion.Weight_Sale    ::TFloat AS Weight_Sale                               --40

            , tmpUnion.Count_doc      :: TFloat AS Count_doc -- кол-во накладных
            , tmpUnion.Count_TT       :: TFloat AS Count_TT  -- кол-во точек по путевому из реестра 	

              -- итого расх на 1 точку = итого расходы / кол. тт в реестре
            , CAST (CASE WHEN COALESCE (tmpUnion.Count_TT,0) <> 0 AND tmpUnion.Ord_TT = 1 THEN tmpUnion.SumTotal_calc / tmpUnion.Count_TT ELSE 0 END  AS NUMERIC (16,2))     :: TFloat AS Sum_one
              -- итого расх на 1 кг = итого расходы / кол. кг
            , CAST (CASE WHEN COALESCE (tmpUnion.Count_TT,0) <> 0 AND COALESCE (tmpUnion.TotalWeight_Doc,0) <> 0 AND tmpUnion.Ord_TT = 1 THEN tmpUnion.SumTotal_calc / tmpUnion.Count_TT/ tmpUnion.TotalWeight_Doc ELSE 0 END  AS NUMERIC (16,2))   :: TFloat AS Weight_one  
            
            ---
            , CAST (tmpUnion.Wage_kg    AS NUMERIC (16,2))    :: TFloat AS Wage_kg    -- За вес грн/кг (0.05)       --Расходы ЗП водителей
            , CAST (tmpUnion.Wage_Hours AS NUMERIC (16,2))    :: TFloat AS Wage_Hours -- За время грн/час (60)      --Расходы ЗП водителей
            , CAST (tmpUnion.Wage_doc   AS NUMERIC (16,2))    :: TFloat AS Wage_doc   -- За точку доставки грн (5)  --Расходы ЗП водителей
           
           
              -- Итого расходы на точку грн     -- Расходы ЗП водителей          
            , CAST (CASE WHEN COALESCE (tmpUnion.Count_TT,0) <> 0 AND COALESCE (tmpUnion.TotalWeight_Sale,0) <> 0 AND COALESCE (tmpUnion.TotalWeight_Doc,0) <> 0 AND tmpUnion.Ord_TT = 1
                    THEN tmpUnion.Wage_kg + tmpUnion.Wage_Hours/tmpUnion.TotalWeight_Sale * tmpUnion.TotalWeight_Doc + tmpUnion.Wage_doc / tmpUnion.Count_TT
                    ELSE 0
              END AS NUMERIC (16,2))                            :: TFloat AS TotalWageSumm

              -- Итого расходы на кг             --Расходы ЗП водителей
            , CAST (CASE WHEN COALESCE (tmpUnion.Count_TT,0) <> 0 AND COALESCE (tmpUnion.Wage_doc,0) <> 0 AND COALESCE (tmpUnion.TotalWeight_Sale,0) <> 0 AND COALESCE (tmpUnion.TotalWeight_Doc,0) <> 0 AND tmpUnion.Ord_TT = 1
                    THEN (tmpUnion.Wage_kg + tmpUnion.Wage_Hours/tmpUnion.TotalWeight_Sale * tmpUnion.TotalWeight_Doc + tmpUnion.Wage_doc / tmpUnion.Count_TT) / tmpUnion.TotalWeight_Doc
                    ELSE 0
               END AS NUMERIC (16,2))                            :: TFloat AS TotalWageKg
          
            
              -- ГСМ+ЗП --Итого расходы на точку грн	
            , CAST (CASE WHEN COALESCE (tmpUnion.Count_TT,0) <> 0 AND COALESCE (tmpUnion.TotalWeight_Sale,0) <> 0 AND COALESCE (tmpUnion.TotalWeight_Doc,0) <> 0 AND tmpUnion.Ord_TT = 1
                     THEN (tmpUnion.Wage_kg + tmpUnion.Wage_Hours/tmpUnion.TotalWeight_Sale * tmpUnion.TotalWeight_Doc + tmpUnion.Wage_doc / tmpUnion.Count_TT)
                        + (tmpUnion.SumTotal_calc / tmpUnion.Count_TT)  
                     ELSE 0 
              END AS NUMERIC (16,2)) :: TFloat AS TotalSum_one
                
              -- ГСМ+ЗП --Итого расходы на кг 
            , CAST (CASE WHEN COALESCE (tmpUnion.Count_TT,0) <> 0 AND COALESCE (tmpUnion.Wage_doc,0) <> 0 AND COALESCE (tmpUnion.TotalWeight_Sale,0) <> 0 AND COALESCE (tmpUnion.TotalWeight_Doc,0) <> 0 AND tmpUnion.Ord_TT = 1
                    THEN (tmpUnion.Wage_kg + tmpUnion.Wage_Hours/tmpUnion.TotalWeight_Sale * tmpUnion.TotalWeight_Doc + tmpUnion.Wage_doc / tmpUnion.Count_TT) / tmpUnion.TotalWeight_Doc
                    ELSE 0
               END
             + (CASE WHEN COALESCE (tmpUnion.Count_TT,0) <> 0 AND COALESCE (tmpUnion.TotalWeight_Doc,0) <> 0 AND tmpUnion.Ord_TT = 1 THEN tmpUnion.SumTotal_calc / tmpUnion.Count_TT/ tmpUnion.TotalWeight_Doc ELSE 0 END) AS NUMERIC (16,2)) :: TFloat AS TotalSum_kg

              -- итого затрата транспорта
            , tmpUnion.SumTotal_calc ::TFloat AS SumTotal_calc

      FROM tmpData AS tmpUnion
                 LEFT JOIN Object AS Object_Route on Object_Route.Id = tmpUnion.RouteId

                 LEFT JOIN Object_Unit_View  on Object_Unit_View.Id = tmpUnion.UnitId

                 LEFT JOIN Object AS Object_PersonalDriver on Object_PersonalDriver.Id = tmpUnion.PersonalDriverId

                 LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpUnion.CarId

                 LEFT JOIN Object AS Object_Business ON Object_Business.Id = tmpUnion.BusinessId

                 LEFT JOIN Object_ProfitLoss_View AS View_ProfitLoss ON View_ProfitLoss.ProfitLossId = tmpUnion.ProfitLossId
                 LEFT JOIN Object_Account_View    AS View_Account    ON View_Account.AccountId       = tmpUnion.ProfitLossId

                 LEFT JOIN ObjectLink AS ObjectLink_Car_FuelMaster 
                                      ON ObjectLink_Car_FuelMaster.ObjectId = Object_Car.Id
                                     AND ObjectLink_Car_FuelMaster.DescId = zc_ObjectLink_Car_FuelMaster()
                 LEFT JOIN Object AS Object_FuelMaster ON Object_FuelMaster.Id = ObjectLink_Car_FuelMaster.ChildObjectId

                 LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel
                                      ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                     AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
                 LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

                 LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                      ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                     AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
                 LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

                 LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpUnion.PartnerId_Sale
                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpUnion.GoodsId
                 LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpUnion.GoodsKindId

       ORDER BY Object_Unit_View.BusinessName
              , Object_Unit_View.BranchName
              , Object_Unit_View.Name
              , COALESCE (tmpUnion.Invnumber, '')
              , COALESCE (tmpUnion.OperDate, CAST (NULL as TDateTime))
              , Object_Car.ValueData 
              , Object_Route.ValueData
              , Object_Partner.ValueData
  ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.10.19         * 
*/

-- тест
-- select * from gpReport_Transport_Cost  (inStartDate := ('01.10.2019')::TDateTime , inEndDate := ('02.10.2019')::TDateTime , inBusinessId := 0 , inBranchId := 0 , inUnitId := 0, inCarId := 1200072  , inIsMovement := false ,  inIsPartner:=false, inIsGoods:= false, inSession := '5');

/*
select * from gpReport_Transport_Cost(inStartDate := ('09.05.2021')::TDateTime , inEndDate := ('09.05.2021')::TDateTime , inBusinessId := 0 , inBranchId := 0 , inUnitId := 8396 , inCarId := 0 , inIsMovement := 'False' , inisPartner := 'True' , inisGoods := 'False' ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e')
where CarName Like '%АЕ 61-33 НТ%'
and PartnerName like '%МЕТРО Кеш енд Кері Україна ТОВ РЦ с. Колонщина вул. Київська буд.3К, корп.3Д%'
*/