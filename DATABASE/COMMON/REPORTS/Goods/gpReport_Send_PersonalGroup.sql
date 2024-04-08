 -- Function: gpReport_Send_PersonalGroup ()

DROP FUNCTION IF EXISTS gpReport_Send_PersonalGroup (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Send_PersonalGroup (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Send_PersonalGroup (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Send_PersonalGroup (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Send_PersonalGroup (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Send_PersonalGroup (
    IN inStartDate         TDateTime ,
    IN inEndDate           TDateTime ,
    IN inUnitId            Integer   ,
    IN inFromId            Integer   ,
    IN inToId              Integer   ,
    IN inGoodsGroupId      Integer   ,
    IN inGoodsId           Integer   ,
    IN inModelServiceId    Integer   ,
    IN inIsMovement        Boolean   ,
    IN inIsDays            Boolean   , --
    IN inIsGoods           Boolean   , --
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime
             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar
             , Weight         TFloat
             , WeightTotal    TFloat
             --, FromCode Integer
             , FromName TVarChar
             --, ToCode Integer
             , ToName TVarChar
             , PersonalGroupCode Integer, PersonalGroupName TVarChar
             , AmountHour     TFloat
             , CountPack      TFloat
             , CountPack_in   TFloat
             , CountPack_out  TFloat
             , Amount         TFloat
             , AmountIn       TFloat
             , AmountOut      TFloat
             , Amount_kg      TFloat
             , AmountIn_kg    TFloat
             , AmountOut_kg   TFloat
             , isError        Boolean
             , MovementId     Integer
             , InvNumber      TVarChar   
             
             , Amount_group     TFloat
             , AmountHour_group TFloat

             )
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     --
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- Замена
     IF inIsMovement = TRUE THEN inIsDays:= TRUE; END IF;

     -- Результат
     RETURN QUERY

     WITH -- Ограничения по товару
          tmpGoods_Group AS (SELECT lfSelect.GoodsId, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, ObjectFloat_Weight.ValueData AS Weight
                             FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = lfSelect.GoodsId
                                                                                  AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                        ON ObjectFloat_Weight.ObjectId = lfSelect.GoodsId
                                                       AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                             WHERE inGoodsGroupId <> 0 AND COALESCE (inGoodsId,0) = 0
                            UNION ALL
                             SELECT Object.Id, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, ObjectFloat_Weight.ValueData AS Weight
                             FROM Object
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object.Id
                                                                                  AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                        ON ObjectFloat_Weight.ObjectId = Object.Id
                                                       AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                             WHERE Object.DescId = zc_Object_Goods()
                               AND COALESCE (inGoodsGroupId, 0) = 0 AND COALESCE (inGoodsId,0) = 0
                            UNION ALL
                             SELECT inGoodsId AS GoodsId, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, ObjectFloat_Weight.ValueData AS Weight
                             FROM ObjectLink AS ObjectLink_Goods_Measure 
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                        ON ObjectFloat_Weight.ObjectId = inGoodsId
                                                       AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                             WHERE ObjectLink_Goods_Measure.ObjectId = inGoodsId
                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                               AND COALESCE (inGoodsId,0) <> 0
                            )
        -- должности из штатного расписания
      , tmpPosition_ModelService AS (SELECT DISTINCT ObjectLink_StaffList_Position.ChildObjectId AS PositionId
                                     FROM ObjectLink AS ObjectLink_ModelService
                                          JOIN Object ON Object.Id       = ObjectLink_ModelService.ObjectId
                                                     -- не удален
                                                     AND Object.isErased = FALSE
                                          LEFT JOIN ObjectLink AS ObjectLink_StaffListCost_StaffList
                                                               ON ObjectLink_StaffListCost_StaffList.ObjectId = ObjectLink_ModelService.ObjectId
                                                              AND ObjectLink_StaffListCost_StaffList.DescId   = zc_ObjectLink_StaffListCost_StaffList()
                                          JOIN Object AS Object_StaffList ON Object_StaffList.Id       = ObjectLink_StaffListCost_StaffList.ChildObjectId
                                                                         -- не удален
                                                                         AND Object_StaffList.isErased = FALSE
                                          INNER JOIN ObjectLink AS ObjectLink_StaffList_Position
                                                                ON ObjectLink_StaffList_Position.ObjectId = Object_StaffList.Id
                                                               AND ObjectLink_StaffList_Position.DescId   = zc_ObjectLink_StaffList_Position()
   
                                     WHERE ObjectLink_ModelService.ChildObjectId = inModelServiceId
                                       AND ObjectLink_ModelService.DescId        = zc_ObjectLink_StaffListCost_ModelService()
                                    )

        -- товары из модели начисления
      , tmpGoods_ModelService AS (WITH
                                  -- Главные элементы Модели начисления
                                  tmpMaster AS (SELECT ObjectLink_ModelService.ObjectId AS Id_Master
                                                FROM ObjectLink AS ObjectLink_ModelService
                                                     JOIN Object ON Object.Id       = ObjectLink_ModelService.ObjectId
                                                                -- не удален
                                                                AND Object.isErased = FALSE
                                                WHERE ObjectLink_ModelService.ChildObjectId = inModelServiceId
                                                  AND ObjectLink_ModelService.DescId        = zc_ObjectLink_ModelServiceItemMaster_ModelService()
                                               )
                                 , tmpChild AS (SELECT DISTINCT
                                                       ObjectLink_ModelServiceItemChild_From.ChildObjectId          AS GoodsId
                                                     , ObjectLink_ModelServiceItemChild_FromGoodsKind.ChildObjectId AS GoodsKindId
                                                FROM ObjectLink AS ObjectLink_ModelServiceItemMaster
                                                     JOIN Object ON Object.Id       = ObjectLink_ModelServiceItemMaster.ObjectId
                                                                -- не удален
                                                                AND Object.isErased = FALSE
                                                     LEFT JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_From
                                                                          ON ObjectLink_ModelServiceItemChild_From.ObjectId = ObjectLink_ModelServiceItemMaster.ObjectId
                                                                         AND ObjectLink_ModelServiceItemChild_From.DescId   = zc_ObjectLink_ModelServiceItemChild_From()

                                                     LEFT JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_FromGoodsKind
                                                                          ON ObjectLink_ModelServiceItemChild_FromGoodsKind.ObjectId = ObjectLink_ModelServiceItemMaster.ObjectId
                                                                         AND ObjectLink_ModelServiceItemChild_FromGoodsKind.DescId   = zc_ObjectLink_ModelServiceItemChild_FromGoodsKind()

                                                WHERE ObjectLink_ModelServiceItemMaster.ChildObjectId IN (SELECT DISTINCT tmpMaster.Id_Master FROM tmpMaster)
                                                  AND ObjectLink_ModelServiceItemMaster.DescId        = zc_ObjectLink_ModelServiceItemChild_ModelServiceItemMaster()
                                                  -- есть товар / Группа тов.
                                                  AND ObjectLink_ModelServiceItemChild_From.ChildObjectId > 0

                                               UNION
                                                SELECT DISTINCT
                                                       ObjectLink_ModelServiceItemChild_To.ChildObjectId             AS GoodsId
                                                    ,  ObjectLink_ModelServiceItemChild_ToGoodsKind.ChildObjectId    AS GoodsKindId
                                                FROM ObjectLink AS ObjectLink_ModelServiceItemMaster
                                                     JOIN Object ON Object.Id       = ObjectLink_ModelServiceItemMaster.ObjectId
                                                                -- не удален
                                                                AND Object.isErased = FALSE
                                                     LEFT JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_To
                                                                          ON ObjectLink_ModelServiceItemChild_To.ObjectId = ObjectLink_ModelServiceItemMaster.ObjectId
                                                                         AND ObjectLink_ModelServiceItemChild_To.DescId   = zc_ObjectLink_ModelServiceItemChild_To()

                                                     LEFT JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_ToGoodsKind
                                                                          ON ObjectLink_ModelServiceItemChild_ToGoodsKind.ObjectId = ObjectLink_ModelServiceItemMaster.ObjectId
                                                                         AND ObjectLink_ModelServiceItemChild_ToGoodsKind.DescId   = zc_ObjectLink_ModelServiceItemChild_ToGoodsKind()

                                                WHERE ObjectLink_ModelServiceItemMaster.ChildObjectId IN (SELECT DISTINCT tmpMaster.Id_Master FROM tmpMaster)
                                                  AND ObjectLink_ModelServiceItemMaster.DescId        = zc_ObjectLink_ModelServiceItemChild_ModelServiceItemMaster()
                                                  -- есть товар / Группа тов.
                                                  AND ObjectLink_ModelServiceItemChild_To.ChildObjectId > 0
                                                )
                                 , tmpGoodsGroup AS (SELECT DISTINCT lfSelect.GoodsId
                                                     FROM tmpChild
                                                          JOIN Object ON Object.Id     = tmpChild.GoodsId
                                                                     AND Object.DescId = zc_Object_GoodsGroup()
                                                          LEFT JOIN lfSelect_Object_Goods_byGoodsGroup (tmpChild.GoodsId) AS lfSelect ON 1 = 1
                                                    )
                                  -- Результат
                                  SELECT tmpGoodsGroup.GoodsId
                                         -- ?без вида товара?
                                       , 0 AS GoodsKindId
                                  FROM tmpGoodsGroup

                                 UNION
                                  SELECT tmpChild.GoodsId
                                       , tmpChild.GoodsKindId
                                  FROM tmpChild
                                       JOIN Object ON Object.Id     = tmpChild.GoodsId
                                                  AND Object.DescId = zc_Object_Goods()
                                       LEFT JOIN tmpGoodsGroup ON tmpGoodsGroup.GoodsId = tmpChild.GoodsId
                                  -- без товаров из групп
                                  WHERE tmpGoodsGroup.GoodsId IS NULL

                                  )
      , tmpGoods_gk AS (SELECT tmpGoods_ModelService.GoodsId
                             , tmpGoods_ModelService.GoodsKindId
                        FROM tmpGoods_ModelService
                             INNER JOIN tmpGoods_Group ON tmpGoods_Group.GoodsId = tmpGoods_ModelService.GoodsId
                        WHERE inModelServiceId <> 0

                       UNION
                        SELECT tmpGoods_Group.GoodsId
                             , 0 AS GoodsKindId
                        FROM tmpGoods_Group
                        WHERE COALESCE (inModelServiceId, 0) = 0
                       )

      , tmpContainer_all AS (SELECT MIContainer.OperDate ::TDateTime AS OperDate
                                  , CASE WHEN inIsMovement = TRUE THEN MIContainer.MovementId ELSE 0 END AS MovementId
                                  , CASE WHEN MIContainer.isActive = TRUE  THEN MIContainer.ObjectExtId_Analyzer ELSE 0 END AS FromId
                                  , CASE WHEN MIContainer.isActive = FALSE THEN MIContainer.ObjectExtId_Analyzer ELSE 0 END AS ToId
                                  , COALESCE (MovementLinkObject_PersonalGroup.ObjectId, 0) AS PersonalGroupId
                                  , MIContainer.ObjectId_analyzer     AS GoodsId
                                  , MIContainer.ObjectIntId_analyzer  AS GoodsKindId
                                    -- Кол-во итого
                                  , SUM (-1 * MIContainer.Amount ) AS Amount
                                    --  Кол-во расход
                                  , SUM (CASE WHEN MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) AS AmountOut
                                    -- Кол-во приход
                                  , SUM (CASE WHEN MIContainer.isActive = TRUE  THEN  1 * MIContainer.Amount ELSE 0 END) AS AmountIn

                             FROM MovementItemContainer AS MIContainer
                                  -- ограничиваем товары
                                  INNER JOIN tmpGoods_gk ON tmpGoods_gk.GoodsId     = MIContainer.ObjectId_analyzer
                                                        AND (tmpGoods_gk.GoodsKindId = MIContainer.ObjectIntId_analyzer
                                                          OR tmpGoods_gk.GoodsKindId = 0
                                                            )
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                                               ON MovementLinkObject_PersonalGroup.MovementId = MIContainer.MovementId
                                                              AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()

                             WHERE MIContainer.MovementDescId = zc_Movement_Send()
                               AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                               AND MIContainer.DescId = zc_MIContainer_Count()
                               AND MIContainer.WhereObjectId_analyzer = inUnitId
                               AND ( ((MIContainer.isActive = FALSE AND MIContainer.ObjectExtId_Analyzer = inToId)   OR (MIContainer.isActive = FALSE AND COALESCE (inToId,0)   = 0))
                                  OR ((MIContainer.isActive = TRUE  AND MIContainer.ObjectExtId_Analyzer = inFromId) OR (MIContainer.isActive = TRUE  AND COALESCE (inFromId,0) = 0))
                                   )
                             GROUP BY MIContainer.OperDate
                                    , CASE WHEN inIsMovement = TRUE THEN MIContainer.MovementId ELSE 0 END
                                    , CASE WHEN MIContainer.isActive = TRUE  THEN MIContainer.ObjectExtId_Analyzer ELSE 0 END
                                    , CASE WHEN MIContainer.isActive = FALSE THEN MIContainer.ObjectExtId_Analyzer ELSE 0 END
                                    , MovementLinkObject_PersonalGroup.ObjectId
                                    , MIContainer.ObjectId_analyzer
                                    , MIContainer.ObjectIntId_analyzer
                            )
          , tmpContainer AS (SELECT tmpContainer_all.OperDate
                                  , tmpContainer_all.MovementId
                                  , tmpContainer_all.FromId
                                  , tmpContainer_all.ToId
                                  , tmpContainer_all.PersonalGroupId
                                    --
                                  , CASE WHEN inIsGoods = TRUE THEN tmpContainer_all.GoodsId     ELSE 0 END AS GoodsId
                                  , CASE WHEN inIsGoods = TRUE THEN tmpContainer_all.GoodsKindId ELSE 0 END AS GoodsKindId
                                    --
                                  , CASE WHEN inIsGoods = TRUE THEN ObjectFloat_WeightTotal.ValueData ELSE 0 END AS WeightTotal
                                  , CASE WHEN inIsGoods = TRUE THEN tmpGoods_Group.Weight             ELSE 0 END AS Weight
                                  , CASE WHEN inIsGoods = TRUE THEN tmpGoods_Group.MeasureId          ELSE 0 END AS MeasureId
                                    -- Кол-во итого
                                  , tmpContainer_all.Amount
                                    -- Кол-во расход
                                  , tmpContainer_all.AmountOut
                                    -- Кол-во приход
                                  , tmpContainer_all.AmountIn

                                    -- Вес итого
                                  , CASE WHEN tmpGoods_Group.MeasureId = zc_Measure_Sh()
                                         THEN tmpContainer_all.Amount * COALESCE (tmpGoods_Group.Weight, 0)
                                         ELSE tmpContainer_all.Amount
                                    END AS Amount_Weight
                                    -- Вес расход
                                  , CASE WHEN tmpGoods_Group.MeasureId = zc_Measure_Sh()
                                         THEN tmpContainer_all.AmountOut * COALESCE (tmpGoods_Group.Weight, 0)
                                         ELSE tmpContainer_all.AmountOut
                                    END AS AmountOut_Weight
                                    -- Вес приход
                                  , CASE WHEN tmpGoods_Group.MeasureId = zc_Measure_Sh()
                                         THEN tmpContainer_all.AmountIn * COALESCE (tmpGoods_Group.Weight, 0)
                                         ELSE tmpContainer_all.AmountIn
                                    END AS AmountIn_Weight

                                    -- Пакеты итого
                                  , CASE WHEN ObjectFloat_WeightTotal.ValueData > 0 THEN tmpContainer_all.Amount    / ObjectFloat_WeightTotal.ValueData ELSE 0 END AS Amount_pack
                                    -- Пакеты расход
                                  , CASE WHEN ObjectFloat_WeightTotal.ValueData > 0 THEN tmpContainer_all.AmountOut / ObjectFloat_WeightTotal.ValueData ELSE 0 END AS AmountOut_pack
                                    -- Пакеты приход
                                  , CASE WHEN ObjectFloat_WeightTotal.ValueData > 0 THEN tmpContainer_all.AmountIn  / ObjectFloat_WeightTotal.ValueData ELSE 0 END AS AmountIn_pack

                                    -- бригада день
                                  , ROW_NUMBER() OVER (PARTITION BY tmpContainer_all.OperDate, tmpContainer_all.PersonalGroupId) AS Ord

                             FROM tmpContainer_all
                                  -- Товар и Вид товара
                                  LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId     = tmpContainer_all.GoodsId
                                                                        AND Object_GoodsByGoodsKind_View.GoodsKindId = tmpContainer_all.GoodsKindId
                                  -- вес в упаковке: "чистый" вес + вес 1-ого пакета
                                  LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                                        ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                       AND ObjectFloat_WeightTotal.DescId   = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
                                  -- товары
                                  LEFT JOIN tmpGoods_Group ON tmpGoods_Group.GoodsId = tmpContainer_all.GoodsId
                            )
        -- данные из табеля Бригада кол-во часов
      , tmpOperDate AS (SELECT generate_series (inStartDate, inEndDate, '1 DAY'::interval) OperDate) --все дни выбранного периода

      , tmpSheetWorkTime AS (SELECT tmpOperDate.OperDate                         AS OperDate
                                  , COALESCE(MIObject_PersonalGroup.ObjectId, 0) AS PersonalGroupId
                                  , MovementLinkObject_Unit.ObjectId             AS UnitId
                                  , SUM (MI_SheetWorkTime.Amount)                AS Amount
                             FROM tmpOperDate
                                  JOIN Movement ON Movement.operDate = tmpOperDate.OperDate
                                               AND Movement.DescId = zc_Movement_SheetWorkTime()
                                  JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                         AND MovementLinkObject_Unit.ObjectId = inUnitId
                                  JOIN MovementItem AS MI_SheetWorkTime ON MI_SheetWorkTime.MovementId = Movement.Id
                                                                       AND MI_SheetWorkTime.isErased   = FALSE
                                                                       AND MI_SheetWorkTime.Amount     > 0
                                  LEFT JOIN MovementItemLinkObject AS MIObject_Position
                                                                   ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id
                                                                  AND MIObject_Position.DescId         = zc_MILinkObject_Position()
                                  LEFT JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                                   ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id
                                                                  AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                                                                   
                                  INNER JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                                   ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id
                                                                  AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()
                                                                /*AND MIObject_WorkTimeKind.ObjectId IN (zc_Enum_WorkTimeKind_WorkN()
                                                                                                        ,zc_Enum_WorkTimeKind_WorkD()
                                                                                                        ,zc_Enum_WorkTimeKind_RemoteAccess()
                                                                                                        ,zc_Enum_WorkTimeKind_Work()
                                                                                                        ,zc_Enum_WorkTimeKind_Trainee50()
                                                                                                        ,zc_Enum_WorkTimeKind_Inventory()
                                                                                                        )*/
                                  LEFT JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                                   ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id
                                                                  AND MIObject_PersonalGroup.DescId         = zc_MILinkObject_PersonalGroup()
                             WHERE -- Ограничение по должности
                                   MIObject_Position.ObjectId       IN (SELECT tmpPosition_ModelService.PositionId FROM tmpPosition_ModelService)
                                   -- иди нет Модели
                                OR COALESCE (inModelServiceId, 0) = 0

                             GROUP BY tmpOperDate.OperDate
                                    , COALESCE(MIObject_PersonalGroup.ObjectId, 0)
                                    , MovementLinkObject_Unit.ObjectId
                            )
        -- связываем перемещения с табелем по дате бригаде подразделению
      , tmpData AS (SELECT tmp.OperDate
                         , tmp.MovementId
                         , tmp.PersonalGroupId
                         , STRING_AGG (DISTINCT Object_From.ValueData, ', ') ::TVarChar AS FromName
                         , STRING_AGG (DISTINCT Object_To.ValueData, ', ') ::TVarChar AS ToName
                         , tmp.GoodsId
                         , tmp.GoodsKindId
                         , tmp.WeightTotal
                         , tmp.Weight
                         , tmp.MeasureId
                           --
                         , SUM (COALESCE (tmp.AmountHour,0)) AS AmountHour

                         , SUM (COALESCE (tmp.Amount,0))     AS Amount
                         , SUM (COALESCE (tmp.AmountIn,0))   AS AmountIn
                         , SUM (COALESCE (tmp.AmountOut,0))  AS AmountOut

                         , SUM (COALESCE (tmp.Amount_Weight,0))     AS Amount_Weight
                         , SUM (COALESCE (tmp.AmountIn_Weight,0))   AS AmountIn_Weight
                         , SUM (COALESCE (tmp.AmountOut_Weight,0))  AS AmountOut_Weight

                         , SUM (COALESCE (tmp.Amount_pack,0))     AS Amount_pack
                         , SUM (COALESCE (tmp.AmountIn_pack,0))   AS AmountIn_pack
                         , SUM (COALESCE (tmp.AmountOut_pack,0))  AS AmountOut_pack
                         
                         , SUM (tmp.Amount_group)     AS Amount_group
                         , SUM (tmp.AmountHour_group) AS AmountHour_group

                    FROM (SELECT CASE WHEN inIsDays = TRUE THEN COALESCE (tmpContainer.OperDate, tmpSheetWorkTime.OperDate) ELSE NULL END ::TDateTime AS OperDate
                               , COALESCE (tmpContainer.MovementId, 0) AS MovementId
                               , COALESCE (tmpContainer.PersonalGroupId, tmpSheetWorkTime.PersonalGroupId) AS PersonalGroupId
                               , COALESCE (tmpContainer.FromId, 0)  AS FromId
                               , COALESCE (tmpContainer.ToId, 0)    AS ToId
                                 --
                               , COALESCE (tmpContainer.GoodsId, 0)     AS GoodsId
                               , COALESCE (tmpContainer.GoodsKindId, 0) AS GoodsKindId
                               , COALESCE (tmpContainer.WeightTotal, 0) AS WeightTotal
                               , COALESCE (tmpContainer.Weight, 0)      AS Weight
                               , COALESCE (tmpContainer.MeasureId, 0)   AS MeasureId
                                 --
                               , (COALESCE (tmpContainer.Amount,0))          AS Amount
                               , (COALESCE (tmpContainer.AmountIn,0))        AS AmountIn
                               , (COALESCE (tmpContainer.AmountOut,0))       AS AmountOut

                               , (COALESCE (tmpContainer.Amount_Weight,0))     AS Amount_Weight
                               , (COALESCE (tmpContainer.AmountIn_Weight,0))   AS AmountIn_Weight
                               , (COALESCE (tmpContainer.AmountOut_Weight,0))  AS AmountOut_Weight

                               , (COALESCE (tmpContainer.Amount_pack,0))     AS Amount_pack
                               , (COALESCE (tmpContainer.AmountIn_pack,0))   AS AmountIn_pack
                               , (COALESCE (tmpContainer.AmountOut_pack,0))  AS AmountOut_pack
                                 --
                               , CASE WHEN COALESCE (tmpContainer.Ord, 1) = 1 THEN COALESCE (tmpSheetWorkTime.Amount, 0) ELSE 0 END AS AmountHour  
                               
                               --если есть и часі и кг то соотношение 1 к 1, потом группируя понятно біли ли ошибки по бригадам и дням
                               , CASE WHEN  (COALESCE (tmpContainer.Amount,0)) <> 0 THEN 1 ELSE 0 END       AS Amount_group
                               , CASE WHEN  (COALESCE (tmpSheetWorkTime.Amount, 0)) <> 0 THEN 1 ELSE 0 END  AS AmountHour_group
                               
                          FROM tmpContainer
                               FULL JOIN tmpSheetWorkTime ON tmpSheetWorkTime.OperDate        = tmpContainer.OperDate
                                                         AND tmpSheetWorkTime.PersonalGroupId = tmpContainer.PersonalGroupId
                          ) AS tmp
                          LEFT JOIN Object AS Object_To   ON Object_To.Id = tmp.ToId
                          LEFT JOIN Object AS Object_From ON Object_From.Id = tmp.FromId
                    GROUP BY tmp.OperDate
                           , tmp.MovementId
                           , tmp.PersonalGroupId
                           , tmp.GoodsId
                           , tmp.GoodsKindId
                           , tmp.WeightTotal
                           , tmp.Weight
                           , tmp.MeasureId
                   )

       -- Результат
       SELECT tmpOperationGroup.OperDate
            , Object_GoodsGroup.Id                       AS GoodsGroupId
            , Object_GoodsGroup.ValueData                AS GoodsGroupName
            , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
            , Object_Goods.Id                            AS GoodsId
            , Object_Goods.ObjectCode                    AS GoodsCode
            , Object_Goods.ValueData                     AS GoodsName
            , Object_GoodsKind.ValueData                 AS GoodsKindName
            , Object_Measure.ValueData                   AS MeasureName
              --
            , tmpOperationGroup.Weight        ::TFloat   AS Weight

              -- Вес в упаковке - GoodsByGoodsKind
            , tmpOperationGroup.WeightTotal   :: TFloat  AS WeightTotal

            , tmpOperationGroup.FromName      AS FromName
            , tmpOperationGroup.ToName        AS ToName
            , Object_PersonalGroup.ObjectCode AS PersonalGroupCode
            , Object_PersonalGroup.ValueData  AS PersonalGroupName

            , tmpOperationGroup.AmountHour       :: TFloat AS AmountHour

            , CAST (tmpOperationGroup.Amount_pack    AS NUMERIC (16, 0)) :: TFloat AS CountPack
            , CAST (tmpOperationGroup.AmountIn_pack  AS NUMERIC (16, 0)) :: TFloat AS CountPack_in
            , CAST (tmpOperationGroup.AmountOut_pack AS NUMERIC (16, 0)) :: TFloat AS CountPack_out

            , tmpOperationGroup.Amount           :: TFloat
            , tmpOperationGroup.AmountIn         :: TFloat
            , tmpOperationGroup.AmountOut        :: TFloat

            , tmpOperationGroup.Amount_Weight    :: TFloat AS Amount_kg
            , tmpOperationGroup.AmountIn_Weight  :: TFloat AS AmountIn_kg
            , tmpOperationGroup.AmountOut_Weight :: TFloat AS AmountOut_kg

            /*, CASE WHEN ((tmpOperationGroup.AmountHour = 0 AND tmpOperationGroup.Amount <> 0 AND tmpOperationGroup.PersonalGroupId > 0)
                    OR (tmpOperationGroup.AmountHour > 0 AND tmpOperationGroup.Amount = 0 AND tmpOperationGroup.PersonalGroupId > 0)
                        )
                  --  AND inIsMovement = FALSE
                  --  AND inIsGoods    = FALSE
                    THEN TRUE
                    ELSE FALSE
              END :: Boolean AS isError
              */ 
              -- сли кол-во единиц времени  = кол-ву ед. веса то ошибки нет, иначе ошибка, в какой-то из дней  не было часов или веса
            , CASE WHEN ((tmpOperationGroup.AmountHour_group <> tmpOperationGroup.Amount_group AND tmpOperationGroup.PersonalGroupId > 0)
                        )
                    THEN TRUE
                    ELSE FALSE
              END :: Boolean AS isError
              
            , tmpOperationGroup.MovementId      AS MovementId
            , Movement.InvNumber

            , tmpOperationGroup.Amount_group     ::TFloat
            , tmpOperationGroup.AmountHour_group ::TFloat

     FROM (SELECT tmpData.OperDate
                , tmpData.MovementId
                , tmpData.FromName
                , tmpData.ToName
                , tmpData.GoodsId
                , tmpData.GoodsKindId
                  -- Вес в упаковке
                , tmpData.WeightTotal
                  --
                , tmpData.Weight
                , tmpData.MeasureId
                  --
                , tmpData.PersonalGroupId
                  --
                , SUM (tmpData.AmountHour)  AS AmountHour

                , SUM (tmpData.Amount)           AS Amount
                , SUM (tmpData.AmountIn)         AS AmountIn
                , SUM (tmpData.AmountOut)        AS AmountOut

                , SUM (tmpData.Amount_Weight)    AS Amount_Weight
                , SUM (tmpData.AmountIn_Weight)  AS AmountIn_Weight
                , SUM (tmpData.AmountOut_Weight) AS AmountOut_Weight

                , SUM (tmpData.Amount_pack)      AS Amount_pack
                , SUM (tmpData.AmountIn_pack)    AS AmountIn_pack
                , SUM (tmpData.AmountOut_pack)   AS AmountOut_pack  
                
                --только для расчета ошибки, понимать были часы и вес по бригада + день
                , SUM (tmpData.Amount_group)     AS Amount_group
                , SUM (tmpData.AmountHour_group) AS AmountHour_group

           FROM tmpData
           GROUP BY tmpData.OperDate
                  , tmpData.MovementId
                  , tmpData.FromName
                  , tmpData.ToName
                  , tmpData.GoodsId
                  , tmpData.GoodsKindId
                  , tmpData.WeightTotal
                  , tmpData.Weight
                  , tmpData.MeasureId
                  , tmpData.PersonalGroupId
           ) AS tmpOperationGroup

          LEFT JOIN Movement ON Movement.Id = tmpOperationGroup.MovementId

          LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = tmpOperationGroup.PersonalGroupId
          LEFT JOIN Object AS Object_Goods         ON Object_Goods.Id         = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind     ON Object_GoodsKind.Id     = tmpOperationGroup.GoodsKindId
          LEFT JOIN Object AS Object_Measure       ON Object_Measure.Id       = tmpOperationGroup.MeasureId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
        ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.09.23         *
*/

-- тест
-- SELECT * FROM gpReport_Send_PersonalGroup (inStartDate:= '01.09.2023', inEndDate:= '05.09.2023', inUnitId:= 8451, inFromId:= 0, inToId:= 8459, inGoodsGroupId:= 0, inGoodsId:= 0, inModelServiceId:=5678129  , inIsMovement:= false, inIsDays:= false, inIsGoods:= true, inSession:= zfCalc_UserAdmin()); -- Склад Реализации

--select * from gpReport_Send_PersonalGroup(inStartDate := ('01.09.2023')::TDateTime , inEndDate := ('05.09.2023')::TDateTime , inUnitId := 8451 , inFromId := 8459 , inToId := 0 , inGoodsGroupId := 0 , inGoodsId := 7493 , inModelServiceId := 0 , inisMovement := 'False' , inIsDays := 'True' , inisGoods := 'True' ,  inSession := '9457');