-- Function: gpSelect_Movement_ProductionUnionLak_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionUnionLak_Print (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProductionUnionLak_Print(
    IN inStartDate         TDateTime,
    IN inEndDate           TDateTime,
    IN inFromId            Integer,
    IN inToId              Integer,
    IN inSession           TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbFromId_group Integer;
  DECLARE vbIsOrder Boolean;

  DECLARE Cursor1 refcursor;
  DECLARE inisCuterCount      Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- определяется
     vbFromId_group:= (SELECT ObjectLink_Parent.ChildObjectId FROM ObjectLink AS ObjectLink_Parent WHERE ObjectLink_Parent.ObjectId = inFromId AND ObjectLink_Parent.DescId = zc_ObjectLink_Unit_Parent());
     --

    -- для оптимизации - в Табл. 1
    CREATE TEMP TABLE _tmpRes_cur1 ON COMMIT DROP AS
       -- Результат - пр-во приход 
       WITH 
     -- пр-во приход лакирование
     tmpProductionLak AS (SELECT Movement.Id          AS MovementId
                               , Movement.StatusId    AS StatusId
                               , Movement.InvNumber   AS InvNumber
                               , Movement.OperDate    AS OperDate
                               , MLO_From.ObjectId    AS FromId
                               , MLO_To.ObjectId      AS ToId
                               , MLO_DocumentKind.ObjectId AS DocumentKindId 
                              -- , MovementItem.Id      AS MovementItemId
                              -- , MIFloat_MovementItemId.ValueData :: Integer AS MovementItemId_partion
                              -- , MovementItem.Amount  AS Amount
                          FROM Movement
                               INNER JOIN MovementLinkObject AS MLO_DocumentKind
                                                             ON MLO_DocumentKind.MovementId = Movement.Id
                                                            AND MLO_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind()
                                                            AND MLO_DocumentKind.ObjectId IN (zc_Enum_DocumentKind_LakTo(), zc_Enum_DocumentKind_LakFrom())
                               LEFT JOIN MovementLinkObject AS MLO_From
                                                            ON MLO_From.MovementId = Movement.Id
                                                           AND MLO_From.DescId = zc_MovementLinkObject_From()
                               LEFT JOIN MovementLinkObject AS MLO_To
                                                            ON MLO_To.MovementId = Movement.Id
                                                           AND MLO_To.DescId = zc_MovementLinkObject_To()

                               LEFT JOIN MovementBoolean AS MB_Peresort
                                                         ON MB_Peresort.MovementId = Movement.Id
                                                        AND MB_Peresort.DescId     = zc_MovementBoolean_Peresort()
                                                        AND MB_Peresort.ValueData  = TRUE
                               
                               --LEFT JOIN MovementItem AS MovementItem_partion ON MovementItem_partion.Id = MIFloat_MovementItemId.ValueData :: Integer
                               --LEFT JOIN Movement AS Movement_partion ON Movement_partion.Id = MovementItem_partion.MovementId 
                               
                            WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                              AND Movement.DescId = zc_Movement_ProductionUnion()
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                              AND MLO_From.ObjectId = inFromId
                              AND MLO_To.ObjectId = inToId
                              AND MB_Peresort.MovementId IS NULL
                           )

   , tmpMI_Lak AS (SELECT  Movement.OperDate                            AS OperDate
                         --, Movement.InvNumber                           AS InvNumber
                         , Movement_partion.OperDate                    AS OperDate_partion  
                         , Movement_partion.InvNumber                   AS InvNumber_partion
                         , MovementItem.ObjectId                        AS GoodsId
                         , MILO_GoodsKind.ObjectId                      AS GoodsKindId
                         , MILO_GoodsKindComplete.ObjectId              AS GoodsKindId_Complete 
                         , MIFloat_MovementItemId.ValueData :: Integer  AS MovementItemId_partion
                         , SUM (COALESCE (MIFloat_Count.ValueData, 0))      AS Count
                         , SUM (COALESCE (MIFloat_RealWeight.ValueData,0))  AS RealWeight
                         , SUM (CASE WHEN Movement.DocumentKindId = zc_Enum_DocumentKind_LakTo() THEN COALESCE (MIFloat_CountReal.ValueData,0) ELSE 0 END)     AS CountReal_to
                         , SUM (CASE WHEN Movement.DocumentKindId = zc_Enum_DocumentKind_LakFrom() THEN COALESCE (MIFloat_CountReal.ValueData,0) ELSE 0 END)   AS CountReal_from
                         , SUM (CASE WHEN Movement.DocumentKindId = zc_Enum_DocumentKind_LakTo() THEN COALESCE (MIFloat_Count.ValueData,0) ELSE 0 END)         AS Count_to
                         , SUM (CASE WHEN Movement.DocumentKindId = zc_Enum_DocumentKind_LakFrom() THEN COALESCE (MIFloat_Count.ValueData,0) ELSE 0 END)       AS Count_from
                         
                         ,  (COALESCE (MovementItem_partion.Amount,0)) AS Amount_partion
                         
                   FROM tmpProductionLak AS Movement
                         INNER JOIN MovementItem ON MovementItem.MovementId = Movement.MovementId
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE
                         
                         LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                          ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                         AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                         LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                                          ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                         AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()

                         LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                                     ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                                    AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight() 
                         LEFT JOIN MovementItemFloat AS MIFloat_CountReal
                                                     ON MIFloat_CountReal.MovementItemId = MovementItem.Id
                                                    AND MIFloat_CountReal.DescId = zc_MIFloat_CountReal() 
                         LEFT JOIN MovementItemFloat AS MIFloat_Count
                                                     ON MIFloat_Count.MovementItemId = MovementItem.Id
                                                    AND MIFloat_Count.DescId = zc_MIFloat_Count() 
                                                    
                         LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                     ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                                    AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId() 
                         LEFT JOIN MovementItem AS MovementItem_partion ON MovementItem_partion.Id = MIFloat_MovementItemId.ValueData :: Integer
                         LEFT JOIN Movement AS Movement_partion ON Movement_partion.Id = MovementItem_partion.MovementId   
                         
                   GROUP BY Movement.OperDate
                          --, Movement.InvNumber 
                          , Movement_partion.OperDate
                          , Movement_partion.InvNumber
                          , MovementItem.ObjectId
                          , MILO_GoodsKind.ObjectId
                          , MILO_GoodsKindComplete.ObjectId
                          , MIFloat_MovementItemId.ValueData    
                          , COALESCE (MovementItem_partion.Amount,0)
                   )
     --вес база из проводок из партии
   , tmpMIContainer1 AS (SELECT MIContainer.ContainerId
                              , MIContainer.MovementItemId
                         FROM MovementItemContainer AS MIContainer
                         WHERE MIContainer.MovementItemId IN (SELECT DISTINCT tmpMI_Lak.MovementItemId_partion From tmpMI_Lak)
                           AND DescId = zc_MIContainer_Count()   -- = 1
                         ) 

   , tmpMIContainer2 AS (SELECT MIContainer.ContainerId
                              , SUM (MI_parent.Amount) AS Amount
                         FROM MovementItemContainer AS MIContainer 
                             JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId
                                              AND MovementItem.DescId = zc_MI_Child() -- =2 
                             JOIN MovementItem AS MI_parent 
                                               ON MI_parent.Id = MovementItem.ParentId
                                              AND MI_parent.DescId = zc_MI_Master()  --1
                         WHERE MIContainer.ContainerId IN (SELECT DISTINCT tmpMIContainer1.ContainerId FROM tmpMIContainer1)
                           AND MIContainer.MovementDescId = zc_Movement_ProductionUnion() 
                         GROUP BY MIContainer.ContainerId
                         )
   , tmpMIContainer AS (SELECT tmpMIContainer1.MovementItemId
                             , SUM (tmpMIContainer2.Amount) AS Amount
                        FROM tmpMIContainer1
                             JOIN tmpMIContainer2 ON tmpMIContainer2.ContainerId = tmpMIContainer1.ContainerId
                        GROUP BY tmpMIContainer1.MovementItemId
                        )
 
       SELECT
             --tmpMI.InvNumber
              tmpMI.OperDate
            , tmpMI.InvNumber_partion
            , tmpMI.OperDate_partion 

            , Object_Goods.Id                   AS GoodsId
            , Object_Goods.ObjectCode           AS GoodsCode
            , Object_Goods.ValueData            AS GoodsName

            , tmpMI.CountReal_from                 --Вес после лак-ия
            , tmpMI.CountReal_to                   --Вес до лак-ия
            , tmpMI.Count_from                     --Колво батонов после
            , tmpMI.Count_to                       --Колво батонов до
            , tmpMI.Amount_partion                 --Вес п/ф факт 
            , tmpMIContainer.Amount  AS RealWeight_base --Вес ГП (база),
            , CASE WHEN COALESCE (tmpMI.Amount_partion,0) <> 0 THEN (tmpMIContainer.Amount *100 / tmpMI.Amount_partion) ELSE 0 END ::TFloat  AS TaxExit_calc                    -- % выхода.
             
            , tmpMIContainer.Amount           ::TFloat  AS Amount_container
             
            , Object_GoodsKind.Id                   AS GoodsKindId
            , Object_GoodsKind.ObjectCode           AS GoodsKindCode
            , Object_GoodsKind.ValueData            AS GoodsKindName
            , Object_Measure.ValueData              AS MeasureName
            , Object_GoodsGroupAnalyst.ValueData    AS GoodsGroupName

            , Object_GoodsKindComplete.Id           AS GoodsKindId_Complete
            , Object_GoodsKindComplete.ObjectCode   AS GoodsKindCode_Complete
            , Object_GoodsKindComplete.ValueData    AS GoodsKindName_Complete

       FROM tmpMI_Lak AS tmpMI
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                 AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            
             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                  ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = tmpMI.GoodsId
                                 AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
             LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId

             LEFT JOIN Object AS Object_Goods             ON Object_Goods.Id             = tmpMI.GoodsId
             LEFT JOIN Object AS Object_GoodsKind         ON Object_GoodsKind.Id         = tmpMI.GoodsKindId
             LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = tmpMI.GoodsKindId_Complete
             LEFT JOIN Object AS Object_Measure           ON Object_Measure.Id           = ObjectLink_Goods_Measure.ChildObjectId
             
             LEFT JOIN tmpMIContainer ON tmpMIContainer.MovementItemId = tmpMI.MovementItemId_partion
        ;


    -- Результат - 1
    OPEN Cursor1 FOR

    SELECT *

    FROM _tmpRes_cur1
    ;
   
    RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР

               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.10.23         *
*/

-- тест
--
--
-- 
select * from gpSelect_Movement_ProductionUnionLak_Print(inStartDate := ('23.09.2023')::TDateTime , inEndDate := ('27.10.2023')::TDateTime , inFromId := 8449  , inToId := 8449  , inSession := '5'::TVarChar);
--FETCH ALL "<unnamed portal 11>";