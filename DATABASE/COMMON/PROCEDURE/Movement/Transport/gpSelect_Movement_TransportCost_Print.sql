-- Function: gpSelect_Movement_TransportCost_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_TransportCost_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TransportCost_Print(
    IN inMovementId        Integer   ,
    IN inSession           TVarChar  DEFAULT ''  -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbDescId Integer;

   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Reestr());
     vbUserId:= lpGetUserBySession (inSession);


     -- Определяется
     SELECT Movement.DescId, Movement.StatusId
            INTO vbDescId, vbStatusId
     FROM Movement WHERE Movement.Id = inMovementId;

  /*  -- очень важная проверка
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        -- это уже странная ошибка
        RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
    END IF;
*/

    CREATE TEMP TABLE tmpResult (Invnumber TVarChar, OperDate TDateTime, MovementDescName TVarChar, PartnerName TVarChar
                               , SumCount_Transport TFloat, SumAmount_Transport TFloat, SumAmount_TransportAdd TFloat, SumAmount_TransportAddLong TFloat
                               , SumAmount_TransportTaxi TFloat, SumAmount_TransportService TFloat, SumAmount_ServiceAdd TFloat
                               , SumAmount_ServiceTotal TFloat , SumAmount_PersonalSendCash TFloat, SumTotal TFloat, WeightTransport TFloat
                               , TotalWeight_Sale TFloat, TotalWeight_Doc TFloat, TotalSumm_Sale TFloat
                               , MovemenId_Sale Integer, OperDate_Sale TDateTime, Invnumber_Sale TVarChar
                               , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindName TVarChar, MeasureName TVarChar
                               , Amount_Sale TFloat, Weight_Sale TFloat ) ON COMMIT DROP;

    INSERT INTO tmpResult (Invnumber, OperDate, MovementDescName, PartnerName 
                         , SumCount_Transport , SumAmount_Transport , SumAmount_TransportAdd, SumAmount_TransportAddLong 
                         , SumAmount_TransportTaxi , SumAmount_TransportService , SumAmount_ServiceAdd 
                         , SumAmount_ServiceTotal, SumAmount_PersonalSendCash , SumTotal 
                         , WeightTransport , TotalWeight_Sale , TotalWeight_Doc , TotalSumm_Sale 
                         , MovemenId_Sale, OperDate_Sale, Invnumber_Sale
                         , GoodsId, GoodsCode, GoodsName, GoodsKindId, GoodsKindName, MeasureName
                         , Amount_Sale , Weight_Sale )


    WITH /*tmpAccount_50000 AS (SELECT * FROM Object_Account_View WHERE Object_Account_View.AccountGroupId = zc_Enum_AccountGroup_50000())
        , */tmpContainer AS
                          (SELECT tmpContainer.MovementId               
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
                               --, tmpContainer.ProfitLossId
                                , tmpContainer.BusinessId
                                , tmpContainer.isAccount_50000
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
                                       --, CLO_ProfitLoss.ObjectId                     AS ProfitLossId
                                       , CLO_Business.ObjectId                       AS BusinessId
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
                                       --LEFT JOIN tmpAccount_50000 ON tmpAccount_50000.AccountId = MIContainer.AccountId_Analyzer
                                  WHERE MIContainer.MovementId = inMovementId   --20787291 --
                                    AND MIContainer.MovementDescId in (zc_Movement_Transport(), zc_Movement_TransportService(),zc_Movement_PersonalSendCash())
                                  --  AND MIContainer.isActive = FALSE
                                  GROUP BY  MIContainer.MovementId, MIContainer.MovementDescId
                                          , MIContainer.ObjectId_Analyzer
                                          , MIContainer.WhereObjectId_Analyzer 
                                          , MIContainer.ObjectIntId_Analyzer 
                                          , MIContainer.ObjectExtId_Analyzer
                                          , CASE WHEN MIContainer.MovementDescId = zc_Movement_Transport() AND COALESCE (MIContainer.AnalyzerId, 0) NOT IN (zc_Enum_AnalyzerId_Transport_Add(), zc_Enum_AnalyzerId_Transport_AddLong(), zc_Enum_AnalyzerId_Transport_Taxi()) THEN MovementLinkObject_PersonalDriver.ObjectId ELSE MIContainer.ObjectId_Analyzer END
                                          , MILinkObject_Route.ObjectId
                                         -- , CLO_ProfitLoss.ObjectId
                                          , CLO_Business.ObjectId 
                                          , MovementItem.Id
                                          , MovementItem.ObjectId
                               /*  UNION ALL
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
                                      -- , MIContainer.AccountId_Analyzer              AS ProfitLossId
                                       , 0                                           AS BusinessId
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
                                                      
                                  WHERE MIContainer.MovementId = inMovementId
                                    AND MIContainer.MovementDescId in (zc_Movement_Transport(), zc_Movement_TransportService(),zc_Movement_PersonalSendCash())
                                  GROUP BY  MIContainer.MovementId, MIContainer.MovementDescId
                                          , MIContainer.ObjectId_Analyzer
                                          , MIContainer.WhereObjectId_Analyzer 
                                          , MIContainer.ObjectIntId_Analyzer 
                                          , MIContainer.ObjectExtId_Analyzer
                                          , CASE WHEN MIContainer.MovementDescId = zc_Movement_Transport() AND COALESCE (MIContainer.AnalyzerId, 0) NOT IN (zc_Enum_AnalyzerId_Transport_Add(), zc_Enum_AnalyzerId_Transport_AddLong(), zc_Enum_AnalyzerId_Transport_Taxi()) THEN MovementLinkObject_PersonalDriver.ObjectId ELSE MIContainer.ObjectId_Analyzer END
                                          , MILinkObject_Route.ObjectId
                                          --, MIContainer.AccountId_Analyzer
                                          , MovementItem.Id
                                          , MovementItem.ObjectId
                              */
                            ) AS tmpContainer   
                                 LEFT JOIN MovementItem ON MovementItem.MovementId = tmpContainer.MovementId
                                                       AND MovementItem.ObjectId   = tmpContainer.RouteId
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE

                                LEFT JOIN MovementItemFloat AS MIFloat_WeightTransport
                                                            ON MIFloat_WeightTransport.MovementItemId = MovementItem.Id
                                                           AND MIFloat_WeightTransport.DescId = zc_MIFloat_Weight()--zc_MIFloat_WeightTransport()
                                GROUP BY tmpContainer.MovementId               
                                       , tmpContainer.MovementDescId           
                                       , tmpContainer.CarId
                                       , tmpContainer.UnitId
                                       , tmpContainer.BranchId
                                       , tmpContainer.PersonalDriverId
                                       , tmpContainer.RouteId
                                       --, tmpContainer.ProfitLossId
                                       , tmpContainer.BusinessId
                                       , tmpContainer.isAccount_50000
                                , (CASE WHEN tmpContainer.MovementDescId = zc_Movement_Transport() THEN MIFloat_WeightTransport.ValueData ELSE 0 END)
                          )
          -- данные реестра
        , tmpWeight1 AS 
                        (SELECT MLM_Transport.MovementChildId                  AS MovementTransportId
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

          -- документы Продажа - строчная часть в Реестры накладных
        , tmpMF_MovementItemId AS 
                                  (SELECT MovementFloat_MovementItemId.MovementId
                                        , MovementFloat_MovementItemId.ValueData :: Integer
                                   FROM MovementFloat AS MovementFloat_MovementItemId
                                   WHERE MovementFloat_MovementItemId.ValueData IN (SELECT DISTINCT tmpWeight1.MI_Id FROM tmpWeight1)
                                     AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                                  )
 
        , tmpMLO_To AS 
                       (SELECT *
                        FROM MovementLinkObject AS MovementLinkObject_To
                        WHERE MovementLinkObject_To.MovementId IN (SELECT DISTINCT tmpMF_MovementItemId.MovementId FROM tmpMF_MovementItemId)
                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
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

        , tmpWeight AS 
                       (SELECT tmpWeight1.MovementTransportId
                             , tmpWeight1.CarId
                             , tmpWeight1.PersonalDriverId
                             , MLO_Route.ObjectId                             AS RouteId
                             , MovementFloat_MovementItemId.MovementId        AS MovementId_Sale
                             , MovementLinkObject_To.ObjectId                 AS PartnerId_Sale
                             , SUM (COALESCE (MovemenTFloat_TotalCountKg.ValueData,0))     AS TotalCountKg
                             , SUM (COALESCE (MovementFloat_TotalSumm.ValueData,0))        AS TotalSumm
                        FROM tmpWeight1
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
                             LEFT JOIN tmpMLO_Route AS MLO_Route
                                                    ON MLO_Route.MovementId = MLM_Order.MovementChildId
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
     , tmpMovementBoolean AS (SELECT MovementBoolean.*
                              FROM MovementBoolean
                              WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpWeight.MovementId_Sale FROM tmpWeight)
                                AND MovementBoolean.DescId IN (zc_MovementBoolean_PriceWithVAT())
                              )

     , tmpMovementFloat AS (SELECT MovementFloat.*
                            FROM MovementFloat
                            WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpWeight.MovementId_Sale FROM tmpWeight)
                              AND MovementFloat.DescId IN (zc_MovementFloat_VATPercent())
                           )
     , tmpSale_MI AS
                   (SELECT MovementItem.MovementId
                        , MovementItem.Id AS MI_Id
                        , MovementItem.ObjectId AS GoodsId
                        , SUM (MovementItem.Amount)    AS Amount
                        , MovementBoolean_PriceWithVAT.ValueData         AS PriceWithVAT
                        , MovementFloat_VATPercent.ValueData             AS VATPercent
                    FROM (SELECT DISTINCT tmpWeight.MovementId_Sale FROM tmpWeight) AS tmpSale
                         LEFT JOIN tmpMovementBoolean AS MovementBoolean_PriceWithVAT
                                                      ON MovementBoolean_PriceWithVAT.MovementId = tmpSale.MovementId_Sale
                         LEFT JOIN tmpMovementFloat AS MovementFloat_VATPercent
                                                    ON MovementFloat_VATPercent.MovementId = tmpSale.MovementId_Sale

                         INNER JOIN MovementItem ON MovementItem.MovementId = tmpSale.MovementId_Sale
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE
                    GROUP BY MovementItem.MovementId
                           , MovementItem.Id
                           , MovementItem.ObjectId
                           , MovementBoolean_PriceWithVAT.ValueData
                           , MovementFloat_VATPercent.ValueData
                  )
       , tmpMILO_GoodsKind AS (SELECT *
                               FROM MovementItemLinkObject
                               WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpSale_MI.MI_Id FROM tmpSale_MI)
                                 AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
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

       , tmpSale_Goods AS
                        (SELECT tmpSale_MI.MovementId
                              , tmpSale_MI.PriceWithVAT
                              , tmpSale_MI.VATPercent
                              , tmpSale_MI.GoodsId
                              , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)                 AS GoodsKindId
                              , ObjectLink_Goods_Measure.ChildObjectId                        AS MeasureId
                              , SUM (MIFloat_AmountPartner.ValueData)                         AS Amount
                              , SUM (MIFloat_AmountPartner.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS Weight
                              , SUM (CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                                 THEN  CAST( COALESCE (MIFloat_AmountPartner.ValueData, 0) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2)) 
                                                 ELSE  CAST( COALESCE (MIFloat_AmountPartner.ValueData, 0) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                                            END 
                                           AS NUMERIC (16, 2))
                                            )          ::TFloat         AS AmountSumm

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
                                , tmpSale_MI.GoodsId
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                , ObjectLink_Goods_Measure.ChildObjectId
                                , tmpSale_MI.PriceWithVAT
                                , tmpSale_MI.VATPercent
                          )

        , tmpWeight_All AS (SELECT tmpWeight.MovementTransportId 
                                 , tmpWeight.TotalCountKg
                                 , tmpWeight.TotalSumm
                                 , COALESCE (tmpContainer.CarId, tmpContainer2.CarId, tmpWeight.CarId)    AS CarId

                                 , COALESCE (tmpContainer.UnitId,tmpContainer2.UnitId)                    AS UnitId
                                 , COALESCE (tmpContainer.BranchId, tmpContainer2.BranchId)               AS BranchId
                                 , COALESCE (tmpContainer.PersonalDriverId, tmpContainer2.PersonalDriverId, tmpWeight.PersonalDriverId)  AS PersonalDriverId
                                 , COALESCE (tmpContainer.RouteId, tmpContainer2.RouteId)                 AS RouteId --tmpWeight.RouteId
                                 --, COALESCE (tmpContainer.ProfitLossId,tmpContainer2.ProfitLossId )       AS ProfitLossId
                                 , COALESCE (tmpContainer.BusinessId, tmpContainer2.BusinessId)           AS BusinessId
                                 , COALESCE (tmpContainer.isAccount_50000,tmpContainer2.isAccount_50000)  AS isAccount_50000
                                 , tmpWeight.PartnerId_Sale
                                 , tmpWeight.MovementId_Sale
                               --  , tmpTT.Count_TT
                               --  , 1 AS Count_doc
                            FROM tmpWeight
                                 LEFT JOIN tmpContainer ON tmpContainer.MovementId = tmpWeight.MovementTransportId
                                                       AND tmpContainer.RouteId    = tmpWeight.RouteId

                                 -- И второй раз если не совпадают маршруты
                                 LEFT JOIN (SELECT tmpContainer.CarId
                                                 , tmpContainer.UnitId
                                                 , tmpContainer.BranchId
                                                 , tmpContainer.PersonalDriverId
                                                -- , tmpContainer.ProfitLossId
                                                 , tmpContainer.BusinessId
                                                 , tmpContainer.isAccount_50000
                                                 , tmpContainer.MovementId
                                                 , MAX (tmpContainer.RouteId) AS RouteId
                                            FROM  tmpContainer
                                            GROUP BY tmpContainer.CarId
                                                   , tmpContainer.UnitId
                                                   , tmpContainer.BranchId
                                                   , tmpContainer.PersonalDriverId
                                                 --  , tmpContainer.ProfitLossId
                                                   , tmpContainer.BusinessId
                                                   , tmpContainer.isAccount_50000
                                                   , tmpContainer.MovementId
                                            ) AS tmpContainer2 ON tmpContainer2.MovementId = tmpWeight.MovementTransportId

                                -- LEFT JOIN tmpTT ON tmpTT.MovementTransportId = tmpWeight.MovementTransportId
                            )

        , tmpUnion AS (SELECT tmpAll.MovementId

                            , (tmpAll.WeightSale)                    AS WeightSale
                            , SUM(COALESCE (tmpAll.TotalSummsale,0))              AS TotalSummSale

                            , SUM(COALESCE (tmpAll.SumCount_Transport,0))         AS SumCount_Transport
                            , SUM(COALESCE (tmpAll.SumAmount_Transport,0))        AS SumAmount_Transport
                            , SUM(COALESCE (tmpAll.SumAmount_TransportAdd,0))     AS SumAmount_TransportAdd
                            , SUM(COALESCE (tmpAll.SumAmount_TransportAddLong,0)) AS SumAmount_TransportAddLong
                            , SUM(COALESCE (tmpAll.SumAmount_TransportTaxi,0))    AS SumAmount_TransportTaxi
                            , SUM(COALESCE (tmpAll.SumAmount_TransportService,0)) AS SumAmount_TransportService
                            , SUM(COALESCE (tmpAll.SumAmount_ServiceAdd,0))       AS SumAmount_ServiceAdd
                            , SUM(COALESCE (tmpAll.SumAmount_PersonalSendCash,0)) AS SumAmount_PersonalSendCash
                            , SUM (COALESCE (tmpAll.SumAmount_TransportService,0) + COALESCE (tmpAll.SumAmount_ServiceAdd,0)) :: TFloat AS SumAmount_ServiceTotal

                            , SUM (COALESCE (tmpAll.SumAmount_Transport,0) 
                                 + COALESCE (tmpAll.SumAmount_TransportAdd,0) 
                                 + COALESCE (tmpAll.SumAmount_TransportAddLong,0) 
                                 + COALESCE (tmpAll.SumAmount_TransportTaxi,0) 
                                 + COALESCE (tmpAll.SumAmount_TransportService,0)
                                 + COALESCE (tmpAll.SumAmount_ServiceAdd,0)
                                 + COALESCE (tmpAll.SumAmount_PersonalSendCash,0)) :: TFloat AS SumTotal
                            , SUM(COALESCE (tmpAll.WeightTransport,0)) AS WeightTransport

                            , tmpAll.MovementId_Sale
                            , tmpAll.PartnerId_Sale
        
                       FROM (SELECT tmpContainer.MovementId
                                  , SUM (tmpWeight_All.TotalCountKg) OVER () AS WeightSale
                                  , tmpWeight_All.TotalSumm    AS TotalSummSale
                                  , tmpContainer.SumCount_Transport
                                  , tmpContainer.SumAmount_Transport
                                  , tmpContainer.SumAmount_TransportAdd
                                  , tmpContainer.SumAmount_TransportAddLong
                                  , tmpContainer.SumAmount_TransportTaxi
                                  , tmpContainer.SumAmount_TransportService
                                  , tmpContainer.SumAmount_ServiceAdd
                                  , tmpContainer.SumAmount_PersonalSendCash
                                  , tmpContainer.WeightTransport
                                  , tmpWeight_All.MovementId_Sale
                                  , tmpWeight_All.PartnerId_Sale
                             FROM tmpContainer
                                  LEFT JOIN tmpWeight_All ON tmpWeight_All.MovementTransportId = tmpContainer.MovementId
                                                         AND tmpWeight_All.CarId = tmpContainer.CarId
                                                         AND tmpWeight_All.UnitId = tmpContainer.UnitId
                                                         AND COALESCE (tmpWeight_All.BranchId,0) = COALESCE (tmpContainer.BranchId,0)
                                                         AND tmpWeight_All.PersonalDriverId = tmpContainer.PersonalDriverId
                                                         AND tmpWeight_All.RouteId = tmpContainer.RouteId
                                                         AND COALESCE (tmpWeight_All.BusinessId,0) = COALESCE (tmpContainer.BusinessId,0)
                                                         AND tmpWeight_All.isAccount_50000 = tmpContainer.isAccount_50000

                             ) AS tmpAll

                       GROUP BY tmpAll.MovementId
                              , tmpAll.MovementId_Sale
                              , tmpAll.PartnerId_Sale
                              , tmpAll.WeightSale
                       )

        , tmpData1 AS (SELECT tmpUnion.MovementId_Sale
                            , tmpUnion.MovementId
                            , tmpUnion.PartnerId_Sale

                           , tmpSale_Goods.GoodsId      AS GoodsId
                           , tmpSale_Goods.GoodsKindId  AS GoodsKindId
                           , tmpSale_Goods.MeasureId

                           , (tmpUnion.SumCount_Transport)         :: TFloat AS SumCount_Transport 
                           , (tmpUnion.SumAmount_Transport)        :: TFloat AS SumAmount_Transport
                           , (tmpUnion.SumAmount_TransportAdd)     :: TFloat AS SumAmount_TransportAdd
                           , (tmpUnion.SumAmount_TransportAddLong) :: TFloat AS SumAmount_TransportAddLong
                           , (tmpUnion.SumAmount_TransportTaxi)    :: TFloat AS SumAmount_TransportTaxi
                           , (tmpUnion.SumAmount_TransportService) :: TFloat AS SumAmount_TransportService
                           , (tmpUnion.SumAmount_ServiceAdd)       :: TFloat AS SumAmount_ServiceAdd
                           , (tmpUnion.SumAmount_ServiceTotal)
                           , (tmpUnion.SumAmount_PersonalSendCash) :: TFloat AS SumAmount_PersonalSendCash
                           , (tmpUnion.SumTotal)
               
                           , (tmpUnion.WeightTransport):: TFloat  AS WeightTransport
                           , (tmpUnion.WeightSale)     :: TFloat  AS TotalWeight_Sale

                           , SUM (COALESCE (tmpSale_Goods.Weight,0))          :: TFloat  AS TotalWeight_Doc
                             -- доля каждого товара в общем весе путевого
                           , CASE WHEN COALESCE(tmpUnion.WeightSale,0) <> 0 THEN SUM (tmpSale_Goods.Weight) / tmpUnion.WeightSale ELSE 1 END AS Koeff_kg  

                           , SUM (CASE WHEN tmpSale_Goods.PriceWithVAT = TRUE OR tmpSale_Goods.VATPercent = 0 THEN COALESCE (tmpSale_Goods.AmountSumm,0)
                                       ELSE COALESCE (tmpSale_Goods.AmountSumm,0) * (1+tmpSale_Goods.VATPercent/100)
                                  END
                                  )::TFloat  AS TotalSumm_Sale
                          
                           , SUM (COALESCE (tmpSale_Goods.Amount,0))  ::TFloat AS Amount_Sale
                           , SUM (COALESCE (tmpSale_Goods.Weight,0))  ::TFloat AS Weight_Sale
                     FROM tmpUnion
                                LEFT JOIN tmpSale_Goods ON tmpSale_Goods.MovementId = tmpUnion.MovementId_Sale
                     GROUP BY tmpUnion.MovementId_Sale
                            , tmpUnion.MovementId
                            , tmpUnion.PartnerId_Sale
                            
                            , tmpSale_Goods.GoodsId
                            , tmpSale_Goods.GoodsKindId
                            , tmpSale_Goods.MeasureId

                            , tmpUnion.SumCount_Transport
                            , tmpUnion.SumAmount_Transport
                            , (tmpUnion.SumAmount_TransportAdd)
                            , (tmpUnion.SumAmount_TransportAddLong)
                            , (tmpUnion.SumAmount_TransportTaxi)
                            , (tmpUnion.SumAmount_TransportService)
                            , (tmpUnion.SumAmount_ServiceAdd)
                            , (tmpUnion.SumAmount_ServiceTotal)
                            , (tmpUnion.SumAmount_PersonalSendCash)
                            , (tmpUnion.SumTotal)
                            , (tmpUnion.WeightTransport)
                            , tmpUnion.WeightSale
                      )

        , tmpData AS ( SELECT COALESCE (Movement.Invnumber, '') :: TVarChar          AS Invnumber
                           , COALESCE (Movement.OperDate, CAST (NULL as TDateTime)) AS OperDate
                           , COALESCE (MovementDesc.ItemName, '') :: TVarChar       AS MovementDescName
                           , tmpUnion.PartnerId_Sale
                           , Movemen_Sale.Id            AS MovemenId_Sale
                           , Movemen_Sale.OperDate      AS OperDate_Sale
                           , Movemen_Sale.Invnumber     AS Invnumber_Sale

                           , tmpUnion.GoodsId      AS GoodsId
                           , tmpUnion.GoodsKindId  AS GoodsKindId
                           , tmpUnion.MeasureId

                           , SUM (tmpUnion.SumCount_Transport * tmpUnion.Koeff_kg) AS SumCount_Transport
                           , SUM (tmpUnion.SumAmount_Transport * tmpUnion.Koeff_kg) AS SumAmount_Transport
                           
                           , SUM (tmpUnion.SumAmount_TransportAdd * tmpUnion.Koeff_kg)     :: TFloat AS SumAmount_TransportAdd
                           , SUM (tmpUnion.SumAmount_TransportAddLong * tmpUnion.Koeff_kg) :: TFloat AS SumAmount_TransportAddLong
                           , SUM (tmpUnion.SumAmount_TransportTaxi * tmpUnion.Koeff_kg)    :: TFloat AS SumAmount_TransportTaxi
                           , SUM (tmpUnion.SumAmount_TransportService * tmpUnion.Koeff_kg) :: TFloat AS SumAmount_TransportService
                           , SUM (tmpUnion.SumAmount_ServiceAdd * tmpUnion.Koeff_kg)       :: TFloat AS SumAmount_ServiceAdd
                           
                           , SUM (tmpUnion.SumAmount_ServiceTotal  * tmpUnion.Koeff_kg) AS SumAmount_ServiceTotal
                           , SUM (tmpUnion.SumAmount_PersonalSendCash) :: TFloat AS SumAmount_PersonalSendCash
                           , SUM (tmpUnion.SumTotal * tmpUnion.Koeff_kg) AS SumTotal
                           , tmpUnion.SumTotal * tmpUnion.Koeff_kg AS SumTotal_calc
               
                           , (tmpUnion.WeightTransport)      :: TFloat  AS WeightTransport
                           , (tmpUnion.TotalWeight_Sale)     :: TFloat  AS TotalWeight_Sale
                           , SUM (COALESCE (tmpUnion.TotalWeight_Doc,0) * tmpUnion.Koeff_kg) :: TFloat  AS TotalWeight_Doc

                           , SUM (COALESCE (tmpUnion.TotalSumm_Sale,0)):: TFloat  AS TotalSumm_Sale -- * tmpUnion.Koeff_kg

                           , SUM (COALESCE (tmpUnion.Amount_Sale,0) * 1):: TFloat  AS Amount_Sale
                           , SUM (COALESCE (tmpUnion.Weight_Sale,0) * 1):: TFloat  AS Weight_Sale

                            , ROW_NUMBER() OVER (PARTITION BY tmpUnion.MovementId, tmpUnion.PartnerId_Sale ORDER BY tmpUnion.SumTotal DESC) AS Ord_TT

                       FROM tmpData1 AS tmpUnion
                                LEFT JOIN Movement ON Movement.Id = tmpUnion.MovementId

                                LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId 
               
                                LEFT JOIN Movement AS Movemen_Sale
                                                   ON Movemen_Sale.Id = tmpUnion.MovementId_Sale
               
                     GROUP BY tmpUnion.MovementId
                            , COALESCE (Movement.Invnumber, '')
                            , COALESCE (Movement.OperDate, CAST (NULL as TDateTime))
                            , COALESCE (MovementDesc.ItemName, '')

                            , tmpUnion.PartnerId_Sale
                            
                            , Movemen_Sale.Id
                            , Movemen_Sale.OperDate
                            , Movemen_Sale.Invnumber
                            , tmpUnion.GoodsId
                            , tmpUnion.GoodsKindId
                            , tmpUnion.MeasureId

                           /*, (tmpUnion.SumAmount_TransportAdd)
                            , (tmpUnion.SumAmount_TransportAddLong)
                            , (tmpUnion.SumAmount_TransportTaxi)
                            , (tmpUnion.SumAmount_TransportService)
                            , (tmpUnion.SumAmount_ServiceAdd)
                            , (tmpUnion.SumAmount_PersonalSendCash)
                           */ , tmpUnion.SumTotal
                            , tmpUnion.SumTotal * tmpUnion.Koeff_kg
                            , (tmpUnion.WeightTransport)
                            , tmpUnion.TotalWeight_Sale
                      )

       -- Результат
       SELECT COALESCE (tmpUnion.Invnumber, '') :: TVarChar          AS Invnumber
            , COALESCE (tmpUnion.OperDate, CAST (NULL as TDateTime)) AS OperDate
            , COALESCE (tmpUnion.MovementDescName, '') :: TVarChar   AS MovementDescName

            , Object_Partner.ValueData         AS PartnerName
            
            , CAST (tmpUnion.SumCount_Transport AS NUMERIC (16,2))   :: TFloat  AS SumCount_Transport 
            , CAST (tmpUnion.SumAmount_Transport AS NUMERIC (16,2))  :: TFloat  AS SumAmount_Transport

            , (tmpUnion.SumAmount_TransportAdd)     :: TFloat AS SumAmount_TransportAdd
            , (tmpUnion.SumAmount_TransportAddLong) :: TFloat AS SumAmount_TransportAddLong
            , (tmpUnion.SumAmount_TransportTaxi)    :: TFloat AS SumAmount_TransportTaxi
            , (tmpUnion.SumAmount_TransportService) :: TFloat AS SumAmount_TransportService
            , (tmpUnion.SumAmount_ServiceAdd)       :: TFloat AS SumAmount_ServiceAdd
            , CAST (tmpUnion.SumAmount_ServiceTotal AS NUMERIC (16,2))       :: TFloat AS SumAmount_ServiceTotal                                           --20 
            , (tmpUnion.SumAmount_PersonalSendCash) :: TFloat AS SumAmount_PersonalSendCash
            , CAST (tmpUnion.SumTotal AS NUMERIC (16,2)) :: TFloat AS SumTotal

            , (tmpUnion.WeightTransport):: TFloat  AS WeightTransport
            , (tmpUnion.TotalWeight_Sale) :: TFloat  AS TotalWeight_Sale
            , (tmpUnion.TotalWeight_Doc) ::TFloat  AS TotalWeight_Doc
            , (tmpUnion.TotalSumm_Sale)::TFloat AS TotalSumm_Sale

            , tmpUnion.MovemenId_Sale
            , tmpUnion.OperDate_Sale
            , tmpUnion.Invnumber_Sale

            , Object_Goods.Id            AS GoodsId
            , Object_Goods.ObjectCode    AS GoodsCode
            , Object_Goods.ValueData     AS GoodsName

            , Object_GoodsKind.Id         AS GoodsKindId
            , Object_GoodsKind.ValueData  AS GoodsKindName
            , Object_Measure.ValueData    AS MeasureName
            , tmpUnion.Amount_Sale    ::TFloat AS Amount_Sale
            , tmpUnion.Weight_Sale    ::TFloat AS Weight_Sale                               --40

              -- итого затрата транспорта
            --, tmpUnion.SumTotal_calc ::TFloat AS SumTotal_calc

      FROM tmpData AS tmpUnion
                 LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpUnion.PartnerId_Sale
                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpUnion.GoodsId
                 LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpUnion.GoodsKindId
                 LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpUnion.MeasureId

       ORDER BY COALESCE (tmpUnion.Invnumber, '')
              , COALESCE (tmpUnion.OperDate, CAST (NULL as TDateTime))
              , Object_Partner.ValueData
  ;

     
     -- Результат
     OPEN Cursor1 FOR
      SELECT *
      FROM tmpResult ;

    RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.08.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_TransportCost_Print(inMovementId := 20787291 , inSession := '5');
