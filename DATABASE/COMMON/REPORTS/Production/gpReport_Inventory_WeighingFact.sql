-- Function: gpReport_Inventory_WeighingFact -

DROP FUNCTION IF EXISTS gpReport_Inventory_WeighingFact (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Inventory_WeighingFact(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , -- 
    IN inUnitId             Integer,
    IN inGoodsGroupId       Integer,
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , Amount              TFloat
             , Amount_sh           TFloat
             , Amount_scale        TFloat
             , Amount_scale_sh     TFloat
             , Amount_Weighing     TFloat
             , Amount_Weighing_sh  TFloat
             , Amount_calc         TFloat
             , Amount_calc_sh      TFloat
             , Amount_diff         TFloat
             , Amount_diff_sh      TFloat
             , isDiff              BooLean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

 /*
 1) данные из zc_Movement_Inventory - колонки шт и вес 
 2) данные из gpSelect_Movement_Inventory_scale - итого по товару и колонки шт и вес 
 3) данные из zc_Movement_WeighingProduction + zc_Movement_WeighingPartner с условием COALESCE (MB_isAuto.ValueData, FALSE)  = FALSE 
 4) 2+4 
 5) разница 1 и 4  
 + булеан разница да/нет
 */
 
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
     -- Ограничения по товару
    INSERT INTO _tmpGoods (GoodsId)
       SELECT lfSelect.GoodsId
       FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
       WHERE inGoodsGroupId <> 0
      UNION
       SELECT Object.Id AS GoodsId
       FROM Object
       WHERE Object.DescId = zc_Object_Goods()
         AND COALESCE (inGoodsGroupId, 0) = 0
       ;

     RETURN QUERY
     WITH
    
     tmpInventory AS (SELECT MovementItem.ObjectId     AS GoodsId
                           , SUM (MovementItem.Amount) AS Amount
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MLO_From
                                                         ON MLO_From.MovementId = Movement.Id
                                                        AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                                        AND MLO_From.ObjectId   = inUnitId
                           INNER JOIN MovementLinkObject AS MLO_To
                                                         ON MLO_To.MovementId = Movement.Id
                                                        AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                        AND MLO_To.ObjectId   = inUnitId

                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId = zc_MI_Master()
                                                  AND MovementItem.isErased = FALSE
                           INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
                      WHERE Movement.DescId IN (zc_Movement_Inventory())
                        AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                      GROUP BY MovementItem.ObjectId
                     )

   , tmpInventory_scale AS (SELECT MovementItem.ObjectId     AS GoodsId
                                 , SUM (MovementItem.Amount) AS Amount
                            FROM Movement
                             INNER JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                                      AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                                                      AND MLO_From.ObjectId   = zc_Unit_RK()
                             INNER JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                                    AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                                    AND MLO_To.ObjectId   = zc_Unit_RK()
                             -- Инвентаризация
                             INNER JOIN MovementFloat AS MovementFloat_MovementDesc
                                                      ON MovementFloat_MovementDesc.MovementId =  Movement.Id
                                                     AND MovementFloat_MovementDesc.DescId     = zc_MovementFloat_MovementDesc()
                                                     AND MovementFloat_MovementDesc.ValueData  = zc_Movement_Inventory() :: TFloat
                             -- Автоматический
                             INNER JOIN MovementBoolean AS MB_isAuto ON MB_isAuto.MovementId = Movement.Id
                                                                    AND MB_isAuto.DescId     = zc_MovementBoolean_isAuto()
                                                                    -- Автоматический, значит с КПК
                                                                    AND MB_isAuto.ValueData  = TRUE

                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId = zc_MI_Master()
                                                    AND MovementItem.isErased = FALSE
                             INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
                      WHERE Movement.DescId IN (zc_Movement_WeighingProduction())
                        AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                        AND Movement.StatusId = zc_Enum_Status_Complete()                             
                      GROUP BY MovementItem.ObjectId
                     )

   , tmpWeighing AS (SELECT MovementItem.ObjectId     AS GoodsId
                          , SUM (MovementItem.Amount) AS Amount
                     FROM Movement
                          INNER JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                                   AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                                                   AND MLO_From.ObjectId   = inUnitId
                          INNER JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                                 AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                                 AND MLO_To.ObjectId   = inUnitId
                          -- Инвентаризация
                          INNER JOIN MovementFloat AS MovementFloat_MovementDesc
                                                   ON MovementFloat_MovementDesc.MovementId =  Movement.Id
                                                  AND MovementFloat_MovementDesc.DescId     = zc_MovementFloat_MovementDesc()
                                                  AND MovementFloat_MovementDesc.ValueData  = zc_Movement_Inventory() :: TFloat
                          -- не Автоматический
                          INNER JOIN MovementBoolean AS MB_isAuto ON MB_isAuto.MovementId = Movement.Id
                                                                 AND MB_isAuto.DescId     = zc_MovementBoolean_isAuto()
                                                                 AND MB_isAuto.ValueData  = FALSE
    
                          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                 AND MovementItem.DescId = zc_MI_Master()
                                                 AND MovementItem.isErased = FALSE 
                          INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
                     WHERE Movement.DescId IN (zc_Movement_WeighingProduction(), zc_Movement_WeighingPartner())
                       AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                       AND Movement.StatusId = zc_Enum_Status_Complete()
                     GROUP BY MovementItem.ObjectId                             
                    )

   , tmpMI AS (SELECT tmp.GoodsId
                    , SUM (tmp.Amount_Inventory)  AS Amount_Inventory
                    , SUM (tmp.Amount_scale)      AS Amount_scale
                    , SUM (tmp.Amount_Weighing)   AS Amount_Weighing
               FROM (SELECT tmp.GoodsId
                    , tmp.Amount   AS Amount_Inventory
                    , 0            AS Amount_scale
                    , 0            AS Amount_Weighing
               FROM tmpInventory AS tmp
            UNION 
               SELECT tmp.GoodsId
                    , 0            AS Amount_Inventory
                    , tmp.Amount   AS Amount_scale
                    , 0            AS Amount_Weighing
               FROM tmpInventory_scale AS tmp
            UNION 
               SELECT tmp.GoodsId
                    , 0            AS Amount_Inventory
                    , 0            AS Amount_scale
                    , tmp.Amount   AS Amount_Weighing
               FROM tmpWeighing AS tmp                 
               )AS tmp
           GROUP BY tmp.GoodsId
           )

   , tmpData AS (SELECT tmp.GoodsId
                      , tmp.MeasureId

                      , tmp.Amount
                      , ROUND (tmp.Amount_sh,0)       AS Amount_sh
                      , tmp.Amount_scale
                      , ROUND (tmp.Amount_scale_sh,0) AS Amount_scale_sh
                      , tmp.Amount_Weighing
                      , ROUND (tmp.Amount_Weighing_sh,0) AS Amount_Weighing_sh 
                      , (COALESCE (tmp.Amount_scale,0) + COALESCE (tmp.Amount_Weighing,0))       AS Amount_calc
                      , ROUND(COALESCE (tmp.Amount_scale_sh,0) + COALESCE (tmp.Amount_Weighing_sh,0) ,0) AS Amount_calc_sh
                      , (COALESCE (tmp.Amount,0) - (COALESCE (tmp.Amount_scale,0) + COALESCE (tmp.Amount_Weighing,0)))       AS Amount_diff
                      , ROUND(COALESCE (tmp.Amount_sh,0) - (COALESCE (tmp.Amount_scale,0) + COALESCE (tmp.Amount_Weighing,0)) ,0)    AS Amount_diff_sh
                 FROM (
                       SELECT tmp.GoodsId
                            , ObjectLink_Goods_Measure.ChildObjectId AS MeasureId
      
                            , tmp.Amount_Inventory * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END AS Amount
                            , tmp.Amount_Inventory * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END                            AS Amount_sh
      
                            , tmp.Amount_scale
                            , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() 
                                   THEN CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,0) <> 0 THEN tmp.Amount_scale / ObjectFloat_Weight.ValueData ELSE 0 END
                                   ELSE 0
                              END ::TFloat AS Amount_scale_sh
      
                            , tmp.Amount_Weighing
                            , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() 
                                   THEN CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,0) <> 0 THEN tmp.Amount_Weighing / ObjectFloat_Weight.ValueData ELSE 0 END
                                   ELSE 0
                              END ::TFloat AS Amount_Weighing_sh                 
                       FROM tmpMI AS tmp
                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                 ON ObjectLink_Goods_Measure.ObjectId = tmp.GoodsId 
                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
      
                            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                  ON ObjectFloat_Weight.ObjectId = tmp.GoodsId
                                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()                      
                       ) AS tmp
                 )

          --РЕЗУЛЬТАТ
          SELECT Object_Goods.Id                   AS GoodsId
               , Object_Goods.ObjectCode ::Integer AS GoodsCode
               , Object_Goods.ValueData            AS GoodsName
               , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
               , Object_Measure.ValueData                    AS MeasureName
               , tmpData.Amount              ::TFloat
               , tmpData.Amount_sh           ::TFloat
               , tmpData.Amount_scale        ::TFloat
               , tmpData.Amount_scale_sh     ::TFloat
               , tmpData.Amount_Weighing     ::TFloat
               , tmpData.Amount_Weighing_sh  ::TFloat
               , tmpData.Amount_calc         ::TFloat
               , tmpData.Amount_calc_sh      ::TFloat
               , tmpData.Amount_diff         ::TFloat
               , tmpData.Amount_diff_sh      ::TFloat
               , CASE WHEN COALESCE (tmpData.Amount_diff,0) <> 0 THEN TRUE ELSE FALSE END ::BooLean AS isDiff
          FROM tmpData
               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId

               LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                      ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                     AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

               LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpData.MeasureId
              ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.03.25         *
*/

-- тест
-- SELECT * FROM gpReport_Inventory_WeighingFact (inStartDate := ('02.02.2025')::TDateTime , inEndDate := ('14.03.2025')::TDateTime , inUnitId := 8447, inGoodsGroupId:= 1952,inSession := '5');
