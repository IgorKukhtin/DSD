-- Function: gpReport_TransportRepair ()

DROP FUNCTION IF EXISTS gpReport_TransportRepair (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TransportRepair(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inUnitId        Integer   , -- подразделение авто
    IN inCarId         Integer   , --
    IN inIsMovement    Boolean   , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, MovementDescName TVarChar
             , CarId Integer, CarCode Integer, CarName TVarChar, CarModelName TVarChar
             , ObjectId Integer, ObjectCode Integer, ObjectName TVarChar, DescName TVarChar
             , UnitId Integer, UnitName TVarChar
             , BranchId Integer, BranchName TVarChar
             , PersonalDriverId Integer, PersonalDriverCode Integer, PersonalDriverName TVarChar
             , Amount TFloat, Price TFloat, Summa TFloat, SummaLoss TFloat, SummaService TFloat
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

-- zc_Movement_Loss - zc_MovementLinkObject_To + zc_Movement_Service - zc_MILinkObject_Asset - zc_ObjectLink_Asset_Car

   RETURN QUERY
   WITH
   tmpCar AS (SELECT Object_Car.*
              FROM Object AS Object_Car
                   LEFT JOIN ObjectLink AS ObjectLink_Car_Unit
                                        ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id
                                       AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
              WHERE Object_Car.DescId = zc_Object_Car()
                 AND (Object_Car.Id = inCarId OR inCarId = 0) 
                 AND (ObjectLink_Car_Unit.ChildObjectId = inUnitId OR inUnitId = 0)
             )

 , tmpMovLoss AS (SELECT Movement.Id AS MovementId
                     , Movement.OperDate
                     , Movement.InvNumber
                     , tmpCar.Id         AS CarId
                     , tmpCar.ObjectCode AS CarCode
                     , tmpCar.ValueData  AS CarName
                     , Movement.DescId   AS MovementDescId
                FROM Movement
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                     INNER JOIN tmpCar ON tmpCar.Id = MovementLinkObject_To.ObjectId
                WHERE Movement.DescId = zc_Movement_Loss()
                  AND Movement.StatusId = zc_Enum_Status_Complete()
                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                )

 , tmpContainerLoss AS (SELECT MIContainer.MovementId               AS MovementId
                             , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN -1 * COALESCE (MIContainer.Amount,0) ELSE 0 END) AS Amount
                             , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() THEN -1 * COALESCE (MIContainer.Amount,0) ELSE 0 END)  AS Summa
                             , ObjectFloat_Price.ValueData          AS Price
                             , MIContainer.WhereObjectId_Analyzer   AS CarId
                             , MIContainer.ObjectIntId_Analyzer     AS UnitId
                             , MIContainer.ObjectExtId_Analyzer     AS BranchId
                             , MIContainer.ObjectId_Analyzer        AS ObjectId
                        FROM MovementItemContainer AS MIContainer
                             LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                            ON CLO_PartionGoods.ContainerId = MIContainer.ContainerId
                                                           AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                             LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId

                             LEFT JOIN ObjectFloat AS ObjectFloat_Price
                                                   ON ObjectFloat_Price.ObjectId = Object_PartionGoods.Id
                                                  AND ObjectFloat_Price.DescId   = zc_ObjectFloat_PartionGoods_Price()
                        WHERE MIContainer.MovementId IN (SELECT DISTINCT  tmpMovLoss.MovementId FROM tmpMovLoss) 
                          AND MIContainer.MovementDescId IN (zc_Movement_Loss())
                 --  and MIContainer.MovementId = 21590008 
                          AND MIContainer.ContainerId_analyzer IS NOT NULL
                        GROUP BY MIContainer.MovementId, MIContainer.MovementDescId
                               , MIContainer.ObjectId_Analyzer
                               , MIContainer.WhereObjectId_Analyzer 
                               , MIContainer.ObjectIntId_Analyzer 
                               , MIContainer.ObjectExtId_Analyzer
                               , MIContainer.ObjectId_Analyzer
                               , ObjectFloat_Price.ValueData
                       )

 , tmpMILos AS (SELECT CASE WHEN inIsMovement = TRUE THEN tmpMovLoss.MovementId ELSE 0    END AS MovementId
                     , CASE WHEN inIsMovement = TRUE THEN tmpMovLoss.OperDate   ELSE NULL END AS OperDate
                     , CASE WHEN inIsMovement = TRUE THEN tmpMovLoss.InvNumber  ELSE ''   END AS InvNumber
                     , CASE WHEN inIsMovement = TRUE THEN tmpMovLoss.MovementDescId ELSE 0 END AS MovementDescId
                     , tmpMovLoss.CarId
                     , tmpMovLoss.CarCode
                     , tmpMovLoss.CarName
                     , CASE WHEN inIsMovement = TRUE THEN MovementItem.ObjectId ELSE 0 END     AS ObjectId
                     --,  MovementItem.ObjectId     AS ObjectId
                     , MILinkObject_Asset.ObjectId  AS AssetId
                     , COALESCE (tmpContainerLoss.Amount,0)      AS Amount
                     --, CASE WHEN COALESCE (tmpContainerLoss.Price,0) = 0 AND COALESCE (tmpContainerLoss.Amount,0) <> 0 THEN tmpContainerLoss.Summa / tmpContainerLoss.Amount ELSE tmpContainerLoss.Price END AS Price
                     , tmpContainerLoss.Summa       AS Summa
                FROM tmpMovLoss
                     INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovLoss.MovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = FALSE
                                            AND COALESCE (MovementItem.Amount,0) <> 0

                     LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                      ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

                     LEFT JOIN tmpContainerLoss ON tmpContainerLoss.MovementId = tmpMovLoss.MovementId
                                               --AND tmpContainerLoss.CarId = tmpMovLoss.CarId
                                               AND tmpContainerLoss.ObjectId = MovementItem.ObjectId
                )

 , tmpMIService AS (SELECT CASE WHEN inIsMovement = TRUE THEN Movement.Id ELSE 0 END          AS MovementId
                         , CASE WHEN inIsMovement = TRUE THEN Movement.OperDate ELSE NULL END AS OperDate
                         , CASE WHEN inIsMovement = TRUE THEN Movement.InvNumber ELSE '' END  AS InvNumber
                         , CASE WHEN inIsMovement = TRUE THEN Movement.DescId ELSE 0 END      AS MovementDescId
                         , tmpCar.Id         AS CarId
                         , tmpCar.ObjectCode AS CarCode
                         , tmpCar.ValueData  AS CarName
                         , CASE WHEN inIsMovement = TRUE THEN MILinkObject_InfoMoney.ObjectId ELSE 0 END AS ObjectId
                         --, MILinkObject_InfoMoney.ObjectId AS ObjectId
                         --, MILinkObject_Asset.ObjectId     AS AssetId

                         , COALESCE (MovementItem.Amount,0)*(-1) AS Summa
                         , COALESCE (MIFloat_Count.ValueData,1)         AS Amount -- количество
                    FROM Movement
                         LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
                         INNER JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                           ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset() 

                         LEFT JOIN ObjectLink AS ObjectLink_Asset_Car
                                              ON ObjectLink_Asset_Car.ObjectId = MILinkObject_Asset.ObjectId
                                             AND ObjectLink_Asset_Car.DescId = zc_ObjectLink_Asset_Car()

                         INNER JOIN tmpCar ON tmpCar.Id = ObjectLink_Asset_Car.ChildObjectId

                         LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                          ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()

                         LEFT JOIN MovementItemFloat AS MIFloat_Count
                                                     ON MIFloat_Count.MovementItemId = MovementItem.Id
                                                    AND MIFloat_Count.DescId = zc_MIFloat_Count()

                    WHERE Movement.DescId = zc_Movement_Service()
                      AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                      AND Movement.StatusId = zc_Enum_Status_Complete()
                    )
 
 -- 
 , tmpData AS (SELECT tmp.MovementId
                    , tmp.OperDate
                    , tmp.InvNumber
                    , tmp.MovementDescId
                    , tmp.CarId
                    , tmp.CarCode
                    , tmp.CarName
                    , tmp.ObjectId
                    --, tmp.AssetId
                    , SUM (COALESCE (tmp.Amount,0))        AS Amount
                    --, tmp.Price
                    , SUM (COALESCE (tmp.SummaLoss,0))     AS SummaLoss
                    , SUM (COALESCE (tmp.SummaService,0))  AS SummaService
                    , SUM (COALESCE (tmp.SummaLoss,0) + COALESCE (tmp.SummaService,0))  AS Summa
               FROM (SELECT tmp.MovementId
                          , tmp.OperDate
                          , tmp.InvNumber
                          , tmp.MovementDescId
                          , tmp.CarId
                          , tmp.CarCode
                          , tmp.CarName
                          , tmp.ObjectId
                          --, tmp.AssetId
                          , tmp.Amount AS Amount
                          --, tmp.Price
                          , tmp.Summa  AS SummaLoss
                          , 0          AS SummaService
                     FROM tmpMILos AS tmp
                    UNION ALL
                     SELECT tmp.MovementId
                          , tmp.OperDate
                          , tmp.InvNumber
                          , tmp.MovementDescId
                          , tmp.CarId
                          , tmp.CarCode
                          , tmp.CarName
                          , tmp.ObjectId
                          --, tmp.AssetId
                          , tmp.Amount AS Amount
                          --, tmp.Price
                          , 0          AS SummaLoss
                          , tmp.Summa  AS SummaService
                     FROM tmpMIService AS tmp
                    ) AS tmp
               GROUP BY tmp.MovementId
                      , tmp.OperDate
                      , tmp.InvNumber
                      , tmp.MovementDescId
                      , tmp.CarId
                      , tmp.CarCode
                      , tmp.CarName
                      , tmp.ObjectId
                      --, tmp.AssetId
                      --, tmp.Price
               )

   --Результат
   SELECT tmpData.MovementId ::Integer
        , tmpData.OperDate   ::TDateTime
        , tmpData.InvNumber ::TVarChar
        , MovementDesc.ItemName ::TVarChar AS MovementDescName
        , tmpData.CarId
        , tmpData.CarCode
        , tmpData.CarName
        , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
        , Object.Id           AS ObjectId
        , Object.ObjectCode   AS ObjectCode
        , Object.ValueData    AS ObjectName
        , ObjectDesc.ItemName AS DescName

        , Object_Unit.Id          AS UnitId
        , Object_Unit.ValueData   AS UnitName

        , Object_Branch.Id         AS BranchId
        , Object_Branch.ValueData  AS BranchName

        , Object_PersonalDriver.Id         AS PersonalDriverId
        , Object_PersonalDriver.ObjectCode AS PersonalDriverCode
        , Object_PersonalDriver.ValueData  AS PersonalDriverName

        , tmpData.Amount ::TFloat
        --, tmpData.Price  ::TFloat
        , CASE WHEN COALESCE (tmpData.Amount,0) <> 0 THEN tmpData.Summa / tmpData.Amount ELSE 0 END ::TFloat AS Price
        , tmpData.Summa        ::TFloat
        , tmpData.SummaLoss    ::TFloat
        , tmpData.SummaService ::TFloat
   FROM tmpData
       LEFT JOIN MovementDesc ON MovementDesc.Id = tmpData.MovementDescId
       
       LEFT JOIN Object ON Object.Id = tmpData.ObjectId
       LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId

            LEFT JOIN ObjectLink AS ObjectLink_Car_Unit
                                 ON ObjectLink_Car_Unit.ObjectId = tmpData.CarId
                                AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Car_Unit.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_PersonalDriver 
                                 ON ObjectLink_Car_PersonalDriver.ObjectId = tmpData.CarId
                                AND ObjectLink_Car_PersonalDriver.DescId = zc_ObjectLink_Car_PersonalDriver()
            LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = ObjectLink_Car_PersonalDriver.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel
                                 ON ObjectLink_Car_CarModel.ObjectId = tmpData.CarId
                                AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = tmpData.CarId
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.12.21         *
*/

-- тест
-- SELECT * FROM gpReport_TransportRepair (inStartDate:= '01.11.2021', inEndDate:= '01.12.2021', inUnitId:=6136671, inCarId:= 0, inIsMovement:= true, inSession:= zfCalc_UserAdmin());

/*

 WITH
 
   tmpCar AS (SELECT Object_Car.*
              FROM Object AS Object_Car
                   LEFT JOIN ObjectLink AS ObjectLink_Car_Unit
                                        ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id
                                       AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
              WHERE Object_Car.DescId = zc_Object_Car()
               --  AND (Object_Car.Id = inCarId OR inCarId = 0) 
               --  AND (ObjectLink_Car_Unit.ChildObjectId = inUnitId OR inUnitId = 0)
             )

 , tmpMovLoss AS (SELECT Movement.Id AS MovementId
                     , Movement.OperDate
                     , Movement.InvNumber
                     , tmpCar.Id         AS CarId
                     , tmpCar.ObjectCode AS CarCode
                     , tmpCar.ValueData  AS CarName
                     , Movement.DescId   AS MovementDescId
                FROM Movement
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                     INNER JOIN tmpCar ON tmpCar.Id = MovementLinkObject_To.ObjectId
                WHERE Movement.DescId = zc_Movement_Loss()
                  AND Movement.StatusId = zc_Enum_Status_Complete()
                  AND Movement.OperDate BETWEEN '01.11.2021' AND '30.11.2021' -- inStartDate AND inEndDate
                )

 , tmpContainer AS (
                                  SELECT MIContainer.MovementId               AS MovementId
                                       , MIContainer.MovementDescId           AS MovementDescId
                                       , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.Amount ELSE 0 END) AS Count_Transport
                                       , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() THEN MIContainer.Amount ELSE 0 END) AS Summa
                                       , MIContainer.WhereObjectId_Analyzer          AS CarId
                                       , MIContainer.ObjectIntId_Analyzer            AS UnitId
                                       , MIContainer.ObjectExtId_Analyzer            AS BranchId
                                       --, CASE WHEN MIContainer.MovementDescId = zc_Movement_Transport() AND COALESCE (MIContainer.AnalyzerId, 0) NOT IN (zc_Enum_AnalyzerId_Transport_Add(), zc_Enum_AnalyzerId_Transport_AddLong(), zc_Enum_AnalyzerId_Transport_Taxi()) THEN MovementLinkObject_PersonalDriver.ObjectId ELSE MIContainer.ObjectId_Analyzer END AS PersonalDriverId
                                    --  , MIContainer.ObjectId
                                    
                                  FROM tmpMovLoss
                                       LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.MovementId = tmpMovLoss.MovementId
                                                                      AND MIContainer.MovementDescId in (zc_Movement_Loss(), zc_Movement_Service())
                                                         
                                       LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                                                    ON MovementLinkObject_PersonalDriver.MovementId = MIContainer.MovementId
                                                                   AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()

                                  WHERE MIContainer.OperDate BETWEEN '01.11.2021' AND '30.11.2021'--inStartDate AND inEndDate  
                                   
                                    --AND (MIContainer.ObjectIntId_Analyzer   = inUnitId     OR inUnitId     = 0) -- подразделение
                                    --AND (MIContainer.WhereObjectId_Analyzer = inCarId      OR inCarId      = 0) -- Автомобиль
                                  GROUP BY  MIContainer.MovementId, MIContainer.MovementDescId
                                          , MIContainer.ObjectId_Analyzer
                                          , MIContainer.WhereObjectId_Analyzer 
                                          , MIContainer.ObjectIntId_Analyzer 
                                          , MIContainer.ObjectExtId_Analyzer
                                         -- , MIContainer.ObjectId
                                 )
             SELECT MIContainer.MovementId               AS MovementId
                  , MIContainer.MovementDescId           AS MovementDescId
                  ,  (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN -1 * MIContainer.Amount ELSE 0 END) AS Count_Transport
                  ,  (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() THEN MIContainer.Amount ELSE 0 END) AS Summa
                  , MIContainer.WhereObjectId_Analyzer          AS CarId
                  , MIContainer.ObjectIntId_Analyzer            AS UnitId
                  , MIContainer.ObjectExtId_Analyzer            AS BranchId
                  --, CASE WHEN MIContainer.MovementDescId = zc_Movement_Transport() AND COALESCE (MIContainer.AnalyzerId, 0) NOT IN (zc_Enum_AnalyzerId_Transport_Add(), zc_Enum_AnalyzerId_Transport_AddLong(), zc_Enum_AnalyzerId_Transport_Taxi()) THEN MovementLinkObject_PersonalDriver.ObjectId ELSE MIContainer.ObjectId_Analyzer END AS PersonalDriverId
               --  , MIContainer.ObjectId
             FROM MovementItemContainer AS MIContainer 
             WHERE  MIContainer.MovementId IN ( SELECT DISTINCT  tmpMovLoss.MovementId FROM tmpMovLoss) 
                                                 AND MIContainer.MovementDescId in (zc_Movement_Loss(), zc_Movement_Service())
               and MIContainer.MovementId = 21590008 

*/