-- Function: gpReport_TransportTire ()

DROP FUNCTION IF EXISTS gpReport_TransportTire (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_TransportTire (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TransportTire(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inUnitId        Integer   , -- 
    IN inUnitCarId     Integer   , -- 
    IN inCarId         Integer   , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId_SendIn Integer
             , OperDate_SendIn TDateTime
             , InvNumber_SendIn TVarChar
             , MovementId_SendOut Integer
             , OperDate_SendOut TDateTime
             , InvNumber_SendOut TVarChar
             , MovementId_TransportStart Integer
             , OperDate_TransportStartt TDateTime
             , InvNumber_TransportStart TVarChar
             , MovementId_TransportEnd Integer
             , OperDate_TransportEnd TDateTime
             , InvNumber_TransportEnd TVarChar
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , CarId Integer, CarCode Integer, CarName TVarChar
             , CarModelId Integer, CarModelCode Integer, CarModelName TVarChar
             , UnitId_Car Integer, UnitCode_Car Integer, UnitName_Car TVarChar
             , PersonalDriverId Integer, PersonalDriverCode Integer, PersonalDriverName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , PartionGoodsId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
             , Amount_in   TFloat
             , Amount_out  TFloat
             , Amount_km   TFloat
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

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Transport());

      RETURN QUERY
      WITH 
         tmpGoods AS (SELECT Object_Goods.Id AS GoodsId
                      FROM Object AS Object_Goods
                           INNER JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                                                AND ObjectLink_Goods_GoodsGroup.ChildObjectId = 2034  --группа резина
                      WHERE Object_Goods.DescId = zc_Object_Goods()
                      --  AND Object_Goods.Id = 1208042
                      )

       , tmpCar AS (SELECT Object.Id AS CarId
                    FROM Object
                    WHERE Object.Id = inCarId AND inCarId <> 0
                   UNION 
                    SELECT ObjectLink_Car_Unit.ObjectId AS CarId
                    FROM ObjectLink AS ObjectLink_Car_Unit 
                    WHERE ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
                      AND (ObjectLink_Car_Unit.ChildObjectId = inUnitCarId AND inUnitCarId <> 0)
                   UNION
                    SELECT Object.Id AS CarId
                    FROM Object
                    WHERE Object.DescId = zc_Object_Car()
                      AND inCarId = 0 AND inUnitCarId = 0
                    )

         --перемещения резина на авто
       , tmpSend_In AS (SELECT Movement.OperDate              AS OperDate
                             , MovementLinkObject_To.ObjectId AS CarId
                             , MovementItem.ObjectId          AS GoodsId
                             , COALESCE (Object_PartionGoods.Id,0 ) AS PartionGoodsId
                             , COALESCE (Object_PartionGoods.ValueData, MIString_PartionGoods.ValueData) :: TVarChar AS PartionGoods
                             , MIDate_PartionGoods.ValueData AS PartionGoodsDate
                             , MovementItem.Amount            AS Amount
                             , Movement.Id                    AS MovementId
                             , MovementItem.Id                AS MI_Id
                             , Object_From.Id                 AS FromId
                             , Object_From.ValueData          AS FromName
                        FROM Movement
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                         AND (MovementLinkObject_From.ObjectId = inUnitId OR inUnitId = 0)
                             INNER JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId AND Object_From.DescId = zc_Object_Unit()
   
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                         --AND (MovementLinkObject_To.ObjectId = inCarId OR inCarId = 0)
                             INNER JOIN tmpCar ON tmpCar.CarId = MovementLinkObject_To.ObjectId
                             --INNER JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId AND Object_To.DescId = zc_Object_Car()
   
                             JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                              AND MovementItem.DescId     = zc_MI_Master()
                                              AND MovementItem.isErased   = FALSE
                                              AND COALESCE (MovementItem.Amount,0) > 0
                             INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionGoods
                                                              ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()
                             LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = MILinkObject_PartionGoods.ObjectId
                             LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                          ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                                         AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                             LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                        ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                       AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                        WHERE Movement.DescId = zc_Movement_Send()
                          AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                        )

         --перемещения резина c авто
       , tmpSend_Out AS (SELECT tmp.OperDate
                              , tmp.CarId
                              , tmp.GoodsId
                              , tmp.PartionGoodsId
                              , tmp.PartionGoods
                              , tmp.PartionGoodsDate
                              , tmp.Amount
                              , tmp.MovementId
                              , tmp.MI_Id
                              , tmp.ToId
                              , tmp.ToName
                         FROM (SELECT Movement.Id              AS MovementId
                                    , MovementItem.Id          AS MI_Id
                                    , Movement.OperDate        AS OperDate
                                    , MovementLinkObject_From.ObjectId AS CarId
                                    , MovementItem.ObjectId          AS GoodsId
                                    , COALESCE (Object_PartionGoods.Id,0 ) AS PartionGoodsId
                                    , COALESCE (Object_PartionGoods.ValueData, MIString_PartionGoods.ValueData) :: TVarChar AS PartionGoods
                                    , MIDate_PartionGoods.ValueData AS PartionGoodsDate
                                    , MovementItem.Amount            AS Amount
                                    , Object_To.Id                   AS ToId
                                    , Object_To.ValueData            AS ToName
                                    , ROW_NUMBER () OVER (PARTITION BY MovementLinkObject_From.ObjectId ORDER BY Movement.OperDate ASC, Movement.Id) AS Ord
                               FROM Movement
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = Movement.Id
                                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                    INNER JOIN tmpSend_In ON tmpSend_In.CarId = MovementLinkObject_From.ObjectId
                                                         AND tmpSend_In.OperDate + INTERVAL '1 MONTH' <= Movement.OperDate
                                                         
                                    INNER JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId AND Object_From.DescId = zc_Object_Car()
          
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                 AND (MovementLinkObject_From.ObjectId = inUnitId OR inUnitId = 0)
                                    INNER JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId AND Object_To.DescId = zc_Object_Unit()
          
                                    JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                                                     AND COALESCE (MovementItem.Amount,0) > 0
                                                     AND MovementItem.ObjectId = tmpSend_In.GoodsId
                                    --INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                                    LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionGoods
                                                                     ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                                                    AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()
                                    LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = MILinkObject_PartionGoods.ObjectId
                                    LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                                 ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                                                AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                    LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                               ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                              AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                               WHERE Movement.DescId = zc_Movement_Send()
                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                               )AS tmp
                         WHERE tmp.Ord = 1       -- берем первый документ перемещения 
                         )

         --даты для определения пробега по путевым
       , tmpDateList AS (SELECT tmpSend_In.OperDate  AS StartDate
                              , COALESCE (tmpSend_Out.OperDate, CURRENT_DATE) ::TDateTime AS EndDate
                              , tmpSend_In.CarId
                         FROM tmpSend_In
                              LEFT JOIN tmpSend_Out ON tmpSend_Out.CarId = tmpSend_In.CarId
                        )
         --путевые
       , tmpTransport AS (SELECT tmpMov.CarId
                               , MAX (CASE WHEN tmpMov.Ord_min = 1 THEN tmpMov.MovementId ELSE 0 END) AS MovementId_Start
                               , MAX (CASE WHEN tmpMov.Ord_max = 1 THEN tmpMov.MovementId ELSE 0 END) AS MovementId_End
                               ---, SUM (tmp.EndOdometre - tmp.StartOdometre) AS od
                               , SUM (CASE WHEN tmpMov.Ord_max = 1 THEN COALESCE (MIFloat_EndOdometre.ValueData,0)
                                           WHEN tmpMov.Ord_min = 1 THEN (-1) * COALESCE (MIFloat_StartOdometre.ValueData,0)
                                      END) AS Amount_km
                          FROM (SELECT MovementLinkObject_Car.ObjectId AS CarId
                                     , Movement.Id AS MovementId
                                     , ROW_NUMBER () OVER (PARTITION BY MovementLinkObject_Car.ObjectId ORDER BY Movement.OperDate ASC, Movement.Id)  AS Ord_min
                                     , ROW_NUMBER () OVER (PARTITION BY MovementLinkObject_Car.ObjectId ORDER BY Movement.OperDate DESC, Movement.Id) AS Ord_max
                                FROM tmpDateList 
                                     INNER JOIN Movement ON Movement.OperDate BETWEEN tmpDateList.StartDate AND tmpDateList.EndDate
                                                        AND Movement.DescId = zc_Movement_Transport()
                                                        AND Movement.StatusId = zc_Enum_Status_Complete()
      
                                     -- выбрали автомобиль (он один)
                                     JOIN MovementLinkObject AS MovementLinkObject_Car
                                                             ON MovementLinkObject_Car.MovementId = Movement.Id
                                                            AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
                                                            AND MovementLinkObject_Car.ObjectId = tmpDateList.CarId

                                ) AS tmpMov
                               JOIN MovementItem ON MovementItem.MovementId = tmpMov.MovementId
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE

                               LEFT JOIN MovementItemFloat AS MIFloat_StartOdometre
                                                           ON MIFloat_StartOdometre.MovementItemId = MovementItem.Id
                                                          AND MIFloat_StartOdometre.DescId = zc_MIFloat_StartOdometre()
                               LEFT JOIN MovementItemFloat AS MIFloat_EndOdometre
                                                           ON MIFloat_EndOdometre.MovementItemId = MovementItem.Id  
                                                          AND MIFloat_EndOdometre.DescId = zc_MIFloat_EndOdometre()
                                 
                          WHERE tmpMov.Ord_min = 1 OR tmpMov.Ord_max = 1
                          GROUP BY tmpMov.CarId
                          )

---партии
      , tmpMIContainer AS (SELECT tmp.MovementItemId
                                , tmp.PartionGoodsId
                                , tmp.PartionGoods
                                , tmp.PartionDate
                           FROM (SELECT MIContainer.MovementItemId            AS MovementItemId
                                      , Object_PartionGoods.Id                AS PartionGoodsId
                                      , CASE WHEN Object_PartionGoods.ValueData = '0' THEN '' ELSE Object_PartionGoods.ValueData END AS PartionGoods
                                      , ObjectDate_Value.ValueData            AS PartionDate

                                      , ROW_NUMBER() OVER (PARTITION BY MIContainer.ObjectId_Analyzer ORDER BY ABS (MIContainer.Amount) DESC) AS Ord
                                 FROM MovementItemContainer AS MIContainer
                                      INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                     ON CLO_PartionGoods.ContainerId = MIContainer.ContainerId
                                                                    AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                      LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId

                                      LEFT JOIN ObjectDate AS ObjectDate_Value
                                                           ON ObjectDate_Value.ObjectId = Object_PartionGoods.Id
                                                          AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                                 WHERE MIContainer.MovementId IN (SELECT DISTINCT tmpSend_In.MovementId FROM tmpSend_In UNION SELECT DISTINCT tmpSend_Out.MovementId FROM tmpSend_Out)
                                   AND MIContainer.DescId                 = zc_MIContainer_Count()
                                ) AS tmp
                           WHERE tmp.Ord = 1 -- !!!берем только ОДНУ партию!!!
                          )



       , tmpData AS (SELECT tmpSend_In.CarId
                          , tmpSend_In.MovementId       AS MovementId_in
                          , tmpSend_Out.MovementId      AS MovementId_out
                          , tmpTransport.MovementId_Start AS MovementId_Start
                          , tmpTransport.MovementId_End   AS MovementId_End
                          , tmpSend_In.FromId
                          , tmpSend_In.FromName
                          , tmpSend_Out.ToId
                          , tmpSend_Out.ToName
                          , tmpSend_In.GoodsId
                          , COALESCE (tmpMIContainer.PartionGoodsId, tmpSend_In.PartionGoodsId)     AS PartionGoodsId
                          , COALESCE (tmpMIContainer.PartionGoods, tmpSend_In.PartionGoods)         AS PartionGoods
                          , COALESCE (tmpMIContainer.PartionDate, tmpSend_In.PartionGoodsDate)      AS PartionGoodsDate
                          , tmpSend_In.Amount           AS Amount_in
                          , tmpSend_Out.Amount          AS Amount_out
                          , tmpTransport.Amount_km
                     FROM tmpSend_In
                         LEFT JOIN tmpSend_Out ON tmpSend_Out.CarId = tmpSend_In.CarId
                                              AND tmpSend_Out.GoodsId = tmpSend_In.GoodsId
                         LEFT JOIN tmpTransport ON tmpTransport.CarId = tmpSend_In.CarId

                         LEFT JOIN tmpMIContainer ON tmpMIContainer.MovementItemId = tmpSend_In.MI_Id
                     )


    SELECT Movement_SendIn.Id         AS MovementId_SendIn
         , Movement_SendIn.OperDate   AS OperDate_SendIn
         , Movement_SendIn.InvNumber  AS InvNumber_SendIn

         , Movement_SendOut.Id        AS MovementId_SendOut
         , Movement_SendOut.OperDate  AS OperDate_SendOut
         , Movement_SendOut.InvNumber AS InvNumber_SendOut

         , Movement_TransportStart.Id        AS MovementId_TransportStart
         , Movement_TransportStart.OperDate  AS OperDate_TransportStartt
         , Movement_TransportStart.InvNumber AS InvNumber_TransportStart

         , Movement_TransportEnd.Id        AS MovementId_TransportEnd
         , Movement_TransportEnd.OperDate  AS OperDate_TransportEnd
         , Movement_TransportEnd.InvNumber AS InvNumber_TransportEnd

         , tmpData.FromId
         , tmpData.FromName
         , tmpData.ToId
         , tmpData.ToName

         , Object_Car.Id         AS CarId
         , Object_Car.ObjectCode AS CarCode
         , Object_Car.ValueData  AS CarName

         , Object_CarModel.Id         AS CarModelId
         , Object_CarModel.ObjectCode AS CarModelCode
         , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName

         , Object_Unit.Id          AS UnitId_Car
         , Object_Unit.ObjectCode  AS UnitCode_Car
         , Object_Unit.ValueData   AS UnitName_Car

         , Object_PersonalDriver.Id           AS PersonalDriverId
         , Object_PersonalDriver.ObjectCode   AS PersonalDriverCode
         , Object_PersonalDriver.ValueData    AS PersonalDriverName

         , Object_GoodsGroup.Id        AS GoodsGroupId
         , Object_GoodsGroup.ValueData AS GoodsGroupName

         , Object_Goods.Id         AS GoodsId
         , Object_Goods.ObjectCode AS GoodsCode
         , Object_Goods.ValueData  AS GoodsName

         --  , COALESCE (tmpMIContainer.PartionGoodsId, Object_PartionGoods.Id,0 ) AS PartionGoodsId
         --  , COALESCE (tmpMIContainer.PartionGoods, Object_PartionGoods.ValueData, MIString_PartionGoods.ValueData) :: TVarChar AS PartionGoods
         , tmpData.PartionGoodsId ::Integer
         , tmpData.PartionGoods   :: TVarChar
         , tmpData.PartionGoodsDate ::TDateTime

         , tmpData.Amount_in   ::TFloat
         , tmpData.Amount_out  ::TFloat
         , tmpData.Amount_km   ::TFloat
    FROM tmpData
         LEFT JOIN Movement AS Movement_SendIn ON Movement_SendIn.Id = tmpData.MovementId_in
         LEFT JOIN Movement AS Movement_SendOut ON Movement_SendOut.Id = tmpData.MovementId_out
         LEFT JOIN Movement AS Movement_TransportStart ON Movement_TransportStart.Id = tmpData.MovementId_Start
         LEFT JOIN Movement AS Movement_TransportEnd ON Movement_TransportEnd.Id = tmpData.MovementId_End
         
         LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpData.CarId
         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
         --LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpData.PartionGoodsId

         LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                              ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                             AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
         LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

         LEFT JOIN ObjectLink AS Car_CarModel
                              ON Car_CarModel.ObjectId = Object_Car.Id
                             AND Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
         LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = Car_CarModel.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                              ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                             AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
         LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Car_Unit 
                              ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id
                             AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Car_Unit.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Car_PersonalDriver
                              ON ObjectLink_Car_PersonalDriver.ObjectId = Object_Car.Id
                             AND ObjectLink_Car_PersonalDriver.DescId = zc_ObjectLink_Car_PersonalDriver()
         LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = ObjectLink_Car_PersonalDriver.ChildObjectId

 ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.12.21         *
*/

-- тест
-- select * from gpReport_TransportTire(inStartDate:= '01.11.2020'::TDateTime, inEndDate:='08.11.2020'::TDateTime, inUnitId:= 0 ::Integer, inCarId := 0, inUnitCarId := 8391 ::Integer, inSession := '5':: TVarChar)