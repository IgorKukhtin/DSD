 -- Function: gpReport_CheckSendSUN_InOut()

DROP FUNCTION IF EXISTS gpReport_CheckSendSUN_InOut(TDateTime, TDateTime, TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckSendSUN_InOut(
    IN inStartDate1        TDateTime,  -- Дата начала пер.1
    IN inEndDate1          TDateTime,  -- Дата окончания пер.1
    IN inStartDate2        TDateTime,  -- Дата начала пер.2
    IN inEndDate2          TDateTime,  -- Дата окончания пер.2
    IN inUnitId            Integer  ,  -- Подразделение
    IN inGoodsId           Integer  ,  -- товар
    --IN inisSendDefSUN     Boolean,    -- Отложенное Перемещение по СУН (да / нет)
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId    Integer
             , UnitName  TVarChar
             , GoodsId   Integer
             , GoodsCode Integer
             , GoodsName TVarChar
             , GoodsGroupName TVarChar
             , FromName       TVarChar
             , ToName         TVarChar
             , InvNumber_From TVarChar
             , InvNumber_To   TVarChar
             , Amount_In     TFloat
             , Amount_Out    TFloat
             , SummaFrom_In  TFloat
             , SummaTo_In    TFloat
             , SummaFrom_Out TFloat
             , SummaTo_Out   TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    WITH   
     -- Данные 1-го периода приход
     tmpMovement1 AS (SELECT Movement.*
                           , MovementLinkObject_To.ObjectId              AS ToId -- кому
                           , MovementLinkObject_From.ObjectId            AS FromId --от кого
                           , MovementLinkObject_PartionDateKind.ObjectId AS PartionDateKindId
                           , COALESCE (MovementBoolean_SUN.ValueData, FALSE)     AS isSUN
                           , COALESCE (MovementBoolean_DefSUN.ValueData, FALSE)  AS isDefSUN
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                        AND (MovementLinkObject_To.ObjectId = inUnitId OR inUnitId =0)
 
                           LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                                     ON MovementBoolean_SUN.MovementId = Movement.Id
                                                    AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
 
                           LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                                     ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                                    AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()
  
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
 
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                                        ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                                       AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
                           LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MovementLinkObject_PartionDateKind.ObjectId
                      WHERE Movement.DescId = zc_Movement_Send()
                      AND Movement.OperDate >= inStartDate1 AND Movement.OperDate < inEndDate1 + INTERVAL '1 DAY'
                      AND (COALESCE (MovementBoolean_SUN.ValueData, FALSE) = TRUE /*OR COALESCE (MovementBoolean_DefSUN.ValueData, FALSE) = TRUE*/)
                      )

   , tmpMI_Master1 AS (SELECT MovementItem.*
                            , COALESCE(MIFloat_PriceFrom.ValueData,0)*MovementItem.Amount     AS SummaFrom
                            , COALESCE(MIFloat_PriceTo.ValueData,0)*MovementItem.Amount       AS SummaTo
                       FROM tmpMovement1 AS Movement
                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = FALSE
                                                   AND COALESCE (MovementItem.Amount,0) <> 0
                                                   AND (MovementItem.ObjectId  = inGoodsId OR inGoodsId = 0)

                            -- цена подразделений записанная при автоматическом распределении 
                            LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceFrom
                                                              ON MIFloat_PriceFrom.MovementItemId = MovementItem.Id
                                                             AND MIFloat_PriceFrom.DescId = zc_MIFloat_PriceFrom()
                            LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceTo
                                                              ON MIFloat_PriceTo.MovementItemId = MovementItem.Id
                                                             AND MIFloat_PriceTo.DescId = zc_MIFloat_PriceTo()
                      )

    -- Данные 2-го периода расход
   , tmpMovement2 AS (SELECT Movement.*
                           , MovementLinkObject_To.ObjectId              AS ToId
                           , MovementLinkObject_From.ObjectId            AS FromId
                           , MovementLinkObject_PartionDateKind.ObjectId AS PartionDateKindId
                           , COALESCE (MovementBoolean_SUN.ValueData, FALSE)     AS isSUN
                           , COALESCE (MovementBoolean_DefSUN.ValueData, FALSE)  AS isDefSUN
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                        AND (MovementLinkObject_From.ObjectId = inUnitId OR inUnitId =0)

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
 
                           LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                                     ON MovementBoolean_SUN.MovementId = Movement.Id
                                                    AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
 
                           LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                                     ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                                    AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()
  
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                                        ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                                       AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
                           LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MovementLinkObject_PartionDateKind.ObjectId
                      WHERE Movement.DescId = zc_Movement_Send()
                      AND Movement.OperDate >= inStartDate2 AND Movement.OperDate < inEndDate2 + INTERVAL '1 DAY'
                      AND (COALESCE (MovementBoolean_SUN.ValueData, FALSE) = TRUE /*OR COALESCE (MovementBoolean_DefSUN.ValueData, FALSE) = TRUE*/)
                      )

   , tmpMI_Master2 AS (SELECT MovementItem.*
                            , COALESCE(MIFloat_PriceFrom.ValueData,0)*MovementItem.Amount     AS SummaFrom
                            , COALESCE(MIFloat_PriceTo.ValueData,0)*MovementItem.Amount       AS SummaTo
                       FROM tmpMovement2 AS Movement
                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = FALSE
                                                   AND COALESCE (MovementItem.Amount,0) <> 0
                                                   AND (MovementItem.ObjectId  = inGoodsId OR inGoodsId = 0)
                            -- цена подразделений записанная при автоматическом распределении 
                            LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceFrom
                                                              ON MIFloat_PriceFrom.MovementItemId = MovementItem.Id
                                                             AND MIFloat_PriceFrom.DescId = zc_MIFloat_PriceFrom()
                            LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceTo
                                                              ON MIFloat_PriceTo.MovementItemId = MovementItem.Id
                                                             AND MIFloat_PriceTo.DescId = zc_MIFloat_PriceTo()
                      )

   , tmpIN AS (SELECT Movement.OperDate     AS OperDate
                    , Movement.InvNumber    AS InvNumber
                    , Movement.ToId         AS UnitId
                    , Object_To.ValueData   AS UnitName
                    , Movement.FromId       AS FromId
                    , Object_From.ValueData AS FromName
                    , Movement.ToId         AS ToId
                    , Object_To.ValueData   AS ToName
                    , tmpMI_Master.ObjectId AS GoodsId
                    , tmpMI_Master.Amount   AS Amount
                    , COALESCE(tmpMI_Master.SummaFrom,0) AS SummaFrom
                    , COALESCE(tmpMI_Master.SummaTo,0)   AS SummaTo
               FROM tmpMI_Master1 AS tmpMI_Master
                    LEFT JOIN tmpMovement1 AS Movement ON Movement.Id    = tmpMI_Master.MovementId
                    LEFT JOIN Object AS Object_From    ON Object_From.Id = Movement.FromId
                    LEFT JOIN Object AS Object_To      ON Object_To.Id   = Movement.ToId
               )

   , tmpOUT AS (SELECT Movement.OperDate     AS OperDate
                     , Movement.InvNumber    AS InvNumber
                     , Movement.FromId       AS UnitId
                     , Object_From.ValueData AS UnitName
                     , Movement.FromId       AS FromId
                     , Object_From.ValueData AS FromName
                     , Movement.ToId         AS ToId
                     , Object_To.ValueData   AS ToName
                     , tmpMI_Master.ObjectId AS GoodsId
                     , tmpMI_Master.Amount   AS Amount
                     , COALESCE(tmpMI_Master.SummaFrom,0) AS SummaFrom
                     , COALESCE(tmpMI_Master.SummaTo,0)   AS SummaTo
                FROM tmpMI_Master2 AS tmpMI_Master
                     LEFT JOIN tmpMovement2 AS Movement ON Movement.Id    = tmpMI_Master.MovementId
                     LEFT JOIN Object AS Object_From    ON Object_From.Id = Movement.FromId
                     LEFT JOIN Object AS Object_To      ON Object_To.Id   = Movement.ToId
                )

       --Результат
       SELECT tmpIN.UnitId                         AS UnitId
            , tmpIN.UnitName                       AS UnitName
            , Object_Goods.Id                      AS GoodsId
            , Object_Goods.ObjectCode              AS GoodsCode
            , Object_Goods.ValueData               AS GoodsName
            , Object_GoodsGroup.ValueData          AS GoodsGroupName
            , STRING_AGG (DISTINCT tmpIN.FromName, ','  ORDER BY tmpIN.FromName DESC) ::TVarChar AS FromName
            , STRING_AGG (DISTINCT tmpOUT.ToName,   ','  ORDER BY tmpOUT.ToName DESC) ::TVarChar AS ToName
            , STRING_AGG (DISTINCT ('№ '||tmpIN.InvNumber ||' ('|| LEFT(tmpIN.OperDate::TVarChar,10)::TVarChar||')') ::TVarChar , ',' ::TVarChar) ::TVarChar AS InvNumber_From
            , STRING_AGG (DISTINCT ('№ '||tmpOUT.InvNumber ||' ('||LEFT(tmpOUT.OperDate::TVarChar,10)::TVarChar||')') ::TVarChar , ',' ::TVarChar)::TVarChar AS InvNumber_To
            , SUM (COALESCE (tmpIN.Amount,0))    ::TFloat  AS Amount_In
            , SUM (COALESCE (tmpOUT.Amount,0))   ::TFloat  AS Amount_Out
            , SUM (COALESCE(tmpIN.SummaFrom,0))  ::TFloat  AS SummaFrom_In
            , SUM (COALESCE(tmpIN.SummaTo,0))    ::TFloat  AS SummaTo_In
            , SUM (COALESCE(tmpOUT.SummaFrom,0)) ::TFloat  AS SummaFrom_Out
            , SUM (COALESCE(tmpOUT.SummaTo,0))   ::TFloat  AS SummaTo_Out
       FROM tmpIN
            LEFT JOIN tmpOUT ON tmpOUT.GoodsId = tmpIN.GoodsId
                            AND tmpOUT.UnitId = tmpIN.UnitId --tmpOUT.FromId = tmpIN.ToId
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpIN.GoodsId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpIN.GoodsId
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
       WHERE tmpOUT.GoodsId IS NOT NULL
       GROUP BY tmpIN.UnitId
              , tmpIN.UnitName 
              , Object_Goods.Id
              , Object_Goods.ValueData
              , Object_GoodsGroup.ValueData
;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.08.19         *
*/

-- тест
--select * from gpReport_CheckSendSUN_InOut(inStartDate1:= '01.08.2019' ::TDateTime, inEndDate1:= '16.08.2019' ::TDateTime, inStartDate2 := '01.08.2019' ::TDateTime, inEndDate2 := '16.08.2019' ::TDateTime,inUnitId:= 0, inGoodsId:= 0, inSession:= '3'::TVarChar);