-- Function: gpSelect_Movement_OrderInternalPackRemains_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternalPackRemains_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderInternalPackRemains_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id                   Integer
             , GoodsId              Integer
             , GoodsCode            Integer
             , GoodsName            TVarChar

             , GoodsId_basis        Integer
             , GoodsCode_basis      Integer
             , GoodsName_basis      TVarChar

             , GoodsKindId          Integer
             , GoodsKindName        TVarChar

             , MeasureName          TVarChar
             , MeasureName_basis    TVarChar
             , GoodsGroupNameFull   TVarChar

             , Weight               TFloat

               -- План выдачи с Ост. на УПАК
             , Amount               TFloat
             , Amount_Sh            TFloat
               -- План выдачи с Цеха на УПАК
             , AmountSecond         TFloat
             , AmountSecond_Sh      TFloat
               -- План выдачи ИТОГО на УПАК
             , AmountTotal          TFloat
             , AmountTotal_Sh       TFloat

               -- ПРИОРИТЕТ
             , Num                  Integer

               -- Приход пр-во (ФАКТ)
             , Income_CEH           TFloat
               -- ИТОГО по Child - ФАКТ - Перемещение на Цех Упаковки
             , Income_PACK_to       TFloat
               -- ИТОГО по Child - ФАКТ - Перемещение с Цеха Упаковки
             , Income_PACK_from     TFloat

             , GoodsCode_Child            Integer
             , GoodsName_Child            TVarChar
             , GoodsKindName_Child        TVarChar
             , MeasureName_Child          TVarChar

               -- ИТОГО по Child - План для упаковки (с остатка, факт)
             , AmountPack_total           TFloat
             , AmountPack_total_sh        TFloat
               -- ИТОГО по Child - План для упаковки (с прихода с пр-ва, факт)
             , AmountPackSecond_total     TFloat
             , AmountPackSecond_total_sh  TFloat
               -- ИТОГО по Child - План для упаковки (ИТОГО, факт)
             , AmountPackTotal_total      TFloat
             , AmountPackTotal_total_sh   TFloat

             , Weight_Child               TFloat

               -- План для упаковки (с остатка, факт)
             , AmountPack_Child           TFloat
             , AmountPack_Child_Sh        TFloat
               -- План для упаковки (с прихода с пр-ва, факт)
             , AmountPackSecond_Child     TFloat
             , AmountPackSecond_Child_Sh  TFloat
               -- План для упаковки (ИТОГО, факт)
             , AmountPackTotal_Child      TFloat
             , AmountPackTotal_Child_Sh   TFloat
             
               -- Результат ПОСЛЕ УПАКОВКИ
             , Amount_result_pack_Child     TFloat
               -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
             , DayCountForecast_calc_Child  TFloat

               -- ФАКТ - Перемещение на Цех Упаковки
             , Income_PACK_to_Child       TFloat
               -- ФАКТ - Перемещение с Цеха Упаковки
             , Income_PACK_from_Child     TFloat
              )
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);


     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate
      INTO vbDescId, vbStatusId, vbOperDate
     FROM Movement
     WHERE Movement.Id = inMovementId;

     -- очень важная проверка
     /*IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete() AND vbUserId <> 5 -- !!!кроме Админа!!!
     THEN
         IF vbStatusId = zc_Enum_Status_Erased()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         IF vbStatusId = zc_Enum_Status_UnComplete()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT MovementDesc.ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         -- это уже странная ошибка
         RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
     END IF;*/


      -- формируются данные в _Result_Master, _Result_Child, _Result_ChildTotal
      PERFORM lpSelect_MI_OrderInternalPackRemains (inMovementId:= inMovementId, inShowAll:= FALSE, inIsErased:= FALSE, inUserId:= vbUserId) ;


      -- Результат
      RETURN QUERY
           WITH tmpChild_total AS (SELECT _Result_Child.KeyId
                                        , SUM (_Result_Child.AmountPack)       AS AmountPack
                                        , SUM (_Result_Child.AmountPackSecond) AS AmountPackSecond
                                        , SUM (_Result_Child.AmountPackTotal)  AS AmountPackTotal
                                        , SUM (CASE WHEN ObjectFloat_Weight.ValueData > 0 AND _Result_Child.MeasureId = zc_Measure_Sh() THEN _Result_Child.AmountPack       / ObjectFloat_Weight.ValueData ELSE 0 END :: Integer) AS AmountPack_sh
                                        , SUM (CASE WHEN ObjectFloat_Weight.ValueData > 0 AND _Result_Child.MeasureId = zc_Measure_Sh() THEN _Result_Child.AmountPackSecond / ObjectFloat_Weight.ValueData ELSE 0 END :: Integer) AS AmountPackSecond_sh
                                   FROM _Result_Child
                                        LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                              ON ObjectFloat_Weight.ObjectId = _Result_Child.GoodsId
                                                             AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                          
                                        LEFT JOIN ObjectFloat AS ObjectFloat_Weight_Child
                                                              ON ObjectFloat_Weight_Child.ObjectId = _Result_Child.GoodsId
                                                             AND ObjectFloat_Weight_Child.DescId   = zc_ObjectFloat_Goods_Weight()
                                   WHERE _Result_Child.AmountPack       <> 0
                                      OR _Result_Child.AmountPackSecond <> 0
                                      OR _Result_Child.Income_PACK_from <> 0
                                   GROUP BY _Result_Child.KeyId
                                  )
           SELECT _Result_Master.Id
                , _Result_Master.GoodsId, _Result_Master.GoodsCode, _Result_Master.GoodsName
                , _Result_Master.GoodsId_basis, _Result_Master.GoodsCode_basis, _Result_Master.GoodsName_basis
                , _Result_Master.GoodsKindId, _Result_Master.GoodsKindName
                , _Result_Master.MeasureName, _Result_Master.MeasureName_basis
                , _Result_Master.GoodsGroupNameFull

                , COALESCE (ObjectFloat_Weight.ValueData, 0) :: TFloat AS Weight

                  -- План выдачи с Ост. на УПАК
                , _Result_Master.Amount
                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND _Result_Master.MeasureId = zc_Measure_Sh() THEN (_Result_Master.Amount       / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS Amount_Sh
                  -- План выдачи с Цеха на УПАК
                , _Result_Master.AmountSecond
                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND _Result_Master.MeasureId = zc_Measure_Sh() THEN (_Result_Master.AmountSecond / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountSecond_Sh
                  -- План выдачи ИТОГО на УПАК
                , _Result_Master.AmountTotal
                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND _Result_Master.MeasureId = zc_Measure_Sh() THEN (_Result_Master.Amount       / ObjectFloat_Weight.ValueData) :: Integer + (_Result_Master.AmountSecond / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountTotal_Sh

                  -- ПРИОРИТЕТ
                , _Result_Master.Num

                  -- Приход пр-во (ФАКТ)
                , _Result_Master.Income_CEH
                  -- ИТОГО по Child - ФАКТ - Перемещение на Цех Упаковки
                , _Result_Master.Income_PACK_to
                  -- ИТОГО по Child - ФАКТ - Перемещение с Цеха Упаковки
                , _Result_Master.Income_PACK_from

                , _Result_Child.GoodsCode         AS GoodsCode_Child
                , _Result_Child.GoodsName         AS GoodsName_Child
                , _Result_Child.GoodsKindName     AS GoodsKindName_Child
                , _Result_Child.MeasureName       AS MeasureName_Child

                  -- ИТОГО по Child - План для упаковки (с остатка, факт)
                , COALESCE (tmpChild_total.AmountPack, 0)           :: TFloat AS AmountPack_total
                , COALESCE (tmpChild_total.AmountPack_sh, 0)        :: TFloat AS AmountPack_total_sh
                  -- ИТОГО по Child - План для упаковки (с прихода с пр-ва, факт)
                , COALESCE (tmpChild_total.AmountPackSecond, 0)     :: TFloat AS AmountPackSecond_total
                , COALESCE (tmpChild_total.AmountPackSecond_sh, 0)  :: TFloat AS AmountPackSecond_total_sh
                  -- ИТОГО по Child - План для упаковки (ИТОГО, факт)
                , COALESCE (tmpChild_total.AmountPackTotal, 0)      :: TFloat AS AmountPackTotal_total
                , (COALESCE (tmpChild_total.AmountPackSecond_sh, 0) + COALESCE (tmpChild_total.AmountPackSecond_sh, 0))   :: TFloat AS AmountPackTotal_total_sh

                , COALESCE (ObjectFloat_Weight_Child.ValueData, 0) :: TFloat  AS Weight_Child

                  -- План для упаковки (с остатка, факт)
                , _Result_Child.AmountPack        AS AmountPack_Child
                , CASE WHEN ObjectFloat_Weight_Child.ValueData > 0 AND _Result_Child.MeasureId = zc_Measure_Sh() THEN (_Result_Child.AmountPack       / ObjectFloat_Weight_Child.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountPack_Child_Sh
                  -- План для упаковки (с прихода с пр-ва, факт)
                , _Result_Child.AmountPackSecond  AS AmountPackSecond_Child
                , CASE WHEN ObjectFloat_Weight_Child.ValueData > 0 AND _Result_Child.MeasureId = zc_Measure_Sh() THEN (_Result_Child.AmountPackSecond / ObjectFloat_Weight_Child.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountPackSecond_Child_Sh
                  -- План для упаковки (ИТОГО, факт)
                , _Result_Child.AmountPackTotal   AS AmountPackTotal_Child
                , CASE WHEN ObjectFloat_Weight_Child.ValueData > 0 AND _Result_Child.MeasureId = zc_Measure_Sh() THEN (_Result_Child.AmountPack       / ObjectFloat_Weight_Child.ValueData) :: Integer + (_Result_Child.AmountPackSecond / ObjectFloat_Weight_Child.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountPackTotal_Child_Sh
                
                  -- Результат ПОСЛЕ УПАКОВКИ
                , _Result_Child.Amount_result_pack    AS Amount_result_pack_Child
                  -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
                , _Result_Child.DayCountForecast_calc AS DayCountForecast_calc_Child

                  -- ФАКТ - Перемещение на Цех Упаковки
                , _Result_Child.Income_PACK_to    AS Income_PACK_to_Child
                  -- ФАКТ - Перемещение с Цеха Упаковки
                , _Result_Child.Income_PACK_from  AS Income_PACK_from_Child

           FROM _Result_Master
              LEFT JOIN tmpChild_total ON tmpChild_total.KeyId = _Result_Master.KeyId
              LEFT JOIN (SELECT *
                         FROM _Result_Child
                         WHERE _Result_Child.AmountPack       <> 0
                            OR _Result_Child.AmountPackSecond <> 0
                            OR _Result_Child.Income_PACK_from <> 0
                        ) AS _Result_Child ON _Result_Child.KeyId = _Result_Master.KeyId

              LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                    ON ObjectFloat_Weight.ObjectId = _Result_Master.GoodsId
                                   AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

              LEFT JOIN ObjectFloat AS ObjectFloat_Weight_Child
                                    ON ObjectFloat_Weight_Child.ObjectId = _Result_Child.GoodsId
                                   AND ObjectFloat_Weight_Child.DescId = zc_ObjectFloat_Goods_Weight()
           WHERE COALESCE (_Result_Master.AmountTotal, 0)      <> 0 -- План выдачи ИТОГО на УПАК (факт)
              OR COALESCE (_Result_Master.Income_PACK_to, 0)   <> 0 -- ИТОГО по Child - ФАКТ - Перемещение на Цех Упаковки
              OR COALESCE (_Result_Child.AmountPackTotal, 0)   <> 0 -- План для упаковки (ИТОГО, факт)
              OR COALESCE (_Result_Child.Income_PACK_from, 0)  <> 0 -- ФАКТ - Перемещение с Цеха Упаковки
              OR COALESCE (_Result_Child.Amount_result_pack, 0) < 0 -- Результат ПОСЛЕ УПАКОВКИ
              OR COALESCE (tmpChild_total.AmountPack, 0)       <> 0 -- ИТОГО по Child - План для упаковки (с остатка, факт)
              OR COALESCE (tmpChild_total.AmountPackSecond, 0) <> 0 -- ИТОГО по Child - План для упаковки (с прихода с пр-ва, факт)

          ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.11.17                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderInternalPackRemains_Print (inMovementId := 7463854, inSession:= zfCalc_UserAdmin())
