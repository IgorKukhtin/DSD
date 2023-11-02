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
       -- пр-во приход
     tmpMI_production AS (SELECT Movement.Id          AS MovementId
                               , Movement.StatusId    AS StatusId
                               , Movement.InvNumber   AS InvNumber
                               , Movement.OperDate    AS OperDate
                               , MLO_From.ObjectId    AS FromId
                               , MovementItem.Id      AS MovementItemId
                               , MovementItem.Amount  AS Amount
                          FROM Movement
                               LEFT JOIN MovementBoolean AS MB_Peresort
                                                         ON MB_Peresort.MovementId = Movement.Id
                                                        AND MB_Peresort.DescId     = zc_MovementBoolean_Peresort()
                                                        AND MB_Peresort.ValueData  = TRUE
                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.isErased   = FALSE
                                                      AND MovementItem.DescId     = zc_MI_Master()

                               LEFT JOIN MovementLinkObject AS MLO_From
                                                            ON MLO_From.MovementId = Movement.Id
                                                           AND MLO_From.DescId = zc_MovementLinkObject_From()
                               LEFT JOIN MovementLinkObject AS MLO_To
                                                            ON MLO_To.MovementId = Movement.Id
                                                           AND MLO_To.DescId = zc_MovementLinkObject_To()
                            WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                              AND Movement.DescId = zc_Movement_ProductionUnion()
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                              AND MLO_From.ObjectId = inFromId
                              AND MLO_To.ObjectId = inToId
                              AND MB_Peresort.MovementId IS NULL
                           )
        --сначала выбираем для строк мастера zc_MIFloat_MovementItemId, по ним получаем строки док Lak и самb документы Lak
   , tmpMIFloat_lak AS (SELECT DISTINCT 
                               MIFloat_MovementItemId.MovementItemId     AS MovementItemId
                            ,  MIFloat_MovementItemId.ValueData::Integer AS MovementItemId_master
                        FROM MovementItemFloat AS MIFloat_MovementItemId
                               INNER JOIN MovementItem ON MovementItem.Id = MIFloat_MovementItemId.MovementItemId
                                                      AND MovementItem.DescId     = zc_MI_Master()
                               INNER JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.DescId = zc_Movement_ProductionUnion()
                        WHERE MIFloat_MovementItemId.ValueData IN (SELECT DISTINCT tmpMI_production.MovementItemId FROM tmpMI_production) 
                          AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()
                        )

   , tmpMI_partion AS (
                         SELECT  Movement_partion.OperDate                  AS OperDate
                               , Movement_partion.InvNumber                 AS InvNumber
                               , MovementItem.ObjectId                      AS GoodsId
                               , MILO_GoodsKind.ObjectId                    AS GoodsKindId
                               , MILO_GoodsKindComplete.ObjectId            AS GoodsKindId_Complete
                               --, MLO_DocumentKind.ObjectId                  AS DocumentKindId
                              -- , MovementItem.Id                            AS MovementItemId
                              -- , MovementItem.Amount                        AS Amount      
                               , SUM (COALESCE (MIFloat_Count.ValueData, 0))      AS Count
                               , SUM (COALESCE (MIFloat_RealWeight.ValueData,0))  AS RealWeight
                               , SUM (CASE WHEN MLO_DocumentKind.ObjectId = zc_Enum_DocumentKind_LakTo() THEN COALESCE (MIFloat_CountReal.ValueData,0) ELSE 0 END)     AS CountReal_to
                               , SUM (CASE WHEN MLO_DocumentKind.ObjectId = zc_Enum_DocumentKind_LakFrom() THEN COALESCE (MIFloat_CountReal.ValueData,0) ELSE 0 END)   AS CountReal_from
                               , SUM (CASE WHEN MLO_DocumentKind.ObjectId = zc_Enum_DocumentKind_LakTo() THEN COALESCE (MIFloat_Count.ValueData,0) ELSE 0 END)     AS Count_to
                               , SUM (CASE WHEN MLO_DocumentKind.ObjectId = zc_Enum_DocumentKind_LakFrom() THEN COALESCE (MIFloat_Count.ValueData,0) ELSE 0 END)   AS Count_from
                               , SUM (COALESCE (tmpMI_production.Amount,0)) AS Amount_partion
                         FROM (SELECT DISTINCT tmpMIFloat_lak.MovementItemId AS Id FROM tmpMIFloat_lak) AS tmp
                               INNER JOIN MovementItem ON MovementItem.Id = tmp.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                               INNER JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.DescId = zc_Movement_ProductionUnion()

                               INNER JOIN MovementLinkObject AS MLO_DocumentKind
                                                             ON MLO_DocumentKind.MovementId = Movement.Id
                                                            AND MLO_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind()
                                                            AND MLO_DocumentKind.ObjectId IN (zc_Enum_DocumentKind_LakTo(), zc_Enum_DocumentKind_LakFrom()) 

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
                               
                               LEFT JOIN tmpMIFloat_lak ON tmpMIFloat_lak.MovementItemId = MovementItem.Id
                               LEFT JOIN tmpMI_production ON tmpMI_production.MovementItemId = tmpMIFloat_lak.MovementItemId_master
                         GROUP BY Movement_partion.OperDate
                                , Movement_partion.InvNumber
                                , MovementItem.ObjectId
                                , MILO_GoodsKind.ObjectId
                                , MILO_GoodsKindComplete.ObjectId
                         )
       SELECT
              tmpMI.InvNumber
            , tmpMI.OperDate

            , Object_Goods.Id                   AS GoodsId
            , Object_Goods.ObjectCode           AS GoodsCode
            , Object_Goods.ValueData            AS GoodsName

            , tmpMI.CountReal_from                 --Вес после лак-ия
            , tmpMI.CountReal_to                   --Вес до лак-ия
            , tmpMI.Count_from                     --Колво батонов после
            , tmpMI.Count_to                       --Колво батонов до
            , tmpMI.Amount_partion                 --Вес п/ф факт 
            , 0 AS RealWeight_base                --Вес ГП (база),
            , 0 AS TaxExit_calc                   -- % выхода.

            , Object_GoodsKind.Id                   AS GoodsKindId
            , Object_GoodsKind.ObjectCode           AS GoodsKindCode
            , Object_GoodsKind.ValueData            AS GoodsKindName
            , Object_Measure.ValueData              AS MeasureName
            , Object_GoodsGroupAnalyst.ValueData    AS GoodsGroupName

            , Object_GoodsKindComplete.Id           AS GoodsKindId_Complete
            , Object_GoodsKindComplete.ObjectCode   AS GoodsKindCode_Complete
            , Object_GoodsKindComplete.ValueData    AS GoodsKindName_Complete

       FROM tmpMI_partion AS tmpMI
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
-- select * from gpSelect_Movement_ProductionUnionLak_Print(inStartDate := ('23.09.2023')::TDateTime , inEndDate := ('27.10.2023')::TDateTime , inFromId := 8449  , inToId := 8449  , inSession := '5'::TVarChar);
--FETCH ALL "<unnamed portal 11>";