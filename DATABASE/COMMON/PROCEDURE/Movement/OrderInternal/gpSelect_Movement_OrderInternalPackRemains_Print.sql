-- Function: gpSelect_Movement_OrderInternalPackRemains_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternalPackRemains_Print (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternalPackRemains_Print (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderInternalPackRemains_Print(
    IN inMovementId    Integer  , -- ключ Документа
    IN inIsMinus       Boolean  , -- 
    IN inSession       TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id                   Integer
             , KeyId                TVarChar
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

               -- ПРИОРИТЕТ
             , Num                  Integer

               -- План1 выдачи с Ост. на УПАК
             , Amount               TFloat
             , Amount_Sh            TFloat
               -- План1 выдачи с Цеха на УПАК
             , AmountSecond         TFloat
             , AmountSecond_Sh      TFloat
               -- План1 выдачи ИТОГО на УПАК
             , AmountTotal          TFloat
             , AmountTotal_Sh       TFloat

               -- План2 выдачи с Ост. на УПАК
             , AmountNext               TFloat
             , AmountNext_Sh            TFloat
               -- План2 выдачи с Цеха на УПАК
             , AmountNextSecond         TFloat
             , AmountNextSecond_Sh      TFloat
               -- План2 выдачи ИТОГО на УПАК
             , AmountNextTotal          TFloat
             , AmountNextTotal_Sh       TFloat

               -- План1 + План2 выдачи ИТОГО на УПАК
             , AmountAllTotal       TFloat
             , AmountAllTotal_Sh    TFloat
             
               -- Ост. начальн. - произв. (СЕГОДНЯ)
             , Remains_CEH                   TFloat
               -- Ост. начальн. - произв. (ПОЗЖЕ)
             , Remains_CEH_Next              TFloat

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

                  -- ИТОГО по Child - 
             , Amount_result_pack_total    TFloat
             , Amount_result_pack_total_sh TFloat

               -- ИТОГО по Child - План для упаковки (с остатка, факт)
             , AmountPack_total           TFloat
             , AmountPack_total_sh        TFloat
               -- ИТОГО по Child - План для упаковки (с прихода с пр-ва, факт)
             , AmountPackSecond_total     TFloat
             , AmountPackSecond_total_sh  TFloat
               -- ИТОГО по Child - План для упаковки (ИТОГО, факт)
             , AmountPackTotal_total      TFloat
             , AmountPackTotal_total_sh   TFloat

               -- ИТОГО по Child - План2 для упаковки (с остатка, факт)
             , AmountPackNext_total           TFloat
             , AmountPackNext_total_sh        TFloat
               -- ИТОГО по Child - План2 для упаковки (с прихода с пр-ва, факт)
             , AmountPackNextSecond_total     TFloat
             , AmountPackNextSecond_total_sh  TFloat
               -- ИТОГО по Child - План2 для упаковки (ИТОГО, факт)
             , AmountPackNextTotal_total      TFloat
             , AmountPackNextTotal_total_sh   TFloat

               -- ИТОГО по Child - План+План2 для упаковки (ИТОГО, факт)
             , AmountPackAllTotal_total      TFloat
             , AmountPackAllTotal_total_sh   TFloat
             
             , Weight_Child                  TFloat

               -- План для упаковки (с остатка, факт)
             , AmountPack_Child           TFloat
             , AmountPack_Child_Sh        TFloat
               -- План для упаковки (с прихода с пр-ва, факт)
             , AmountPackSecond_Child     TFloat
             , AmountPackSecond_Child_Sh  TFloat
               -- План для упаковки (ИТОГО, факт)
             , AmountPackTotal_Child      TFloat
             , AmountPackTotal_Child_Sh   TFloat
             
               -- План2 для упаковки (с остатка, факт)
             , AmountPackNext_Child           TFloat
             , AmountPackNext_Child_Sh        TFloat
               -- План2 для упаковки (с прихода с пр-ва, факт)
             , AmountPackNextSecond_Child     TFloat
             , AmountPackNextSecond_Child_Sh  TFloat
               -- План2 для упаковки (ИТОГО, факт)
             , AmountPackNextTotal_Child      TFloat
             , AmountPackNextTotal_Child_Sh   TFloat
               -- План+План2 для упаковки (ИТОГО, факт)
             , AmountPackAllTotal_Child      TFloat
             , AmountPackAllTotal_Child_Sh   TFloat
                
               -- Результат ПОСЛЕ УПАКОВКИ
             , Amount_result_pack_Child     TFloat
               -- Результат ПОСЛЕ УПАКОВКИ
             , Amount_result_pack_Child_Sh  TFloat
               -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
             , DayCountForecast_calc_Child  TFloat

               -- ФАКТ - Перемещение на Цех Упаковки
             , Income_PACK_to_Child       TFloat
               -- ФАКТ - Перемещение с Цеха Упаковки
             , Income_PACK_from_Child     TFloat

               -- Разница - ФАКТ и ПЛАН
             , DiffPlus_PACK_from_Child   TFloat
             , DiffMinus_PACK_from_Child  TFloat
             , NormPack  TFloat
             , HourPack_calc TFloat    -- расчет сколько времени надо на весь план
             , HourPack_calc_ch TFloat -- расчет сколько времени надо на весь план
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
           WITH
              tmpGoodsByGoodsKind AS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId         AS GoodsId
                                           , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId     AS GoodsKindId
                                           , ObjectFloat_NormPack.ValueData                          AS NormPack
                                      FROM Object AS Object_GoodsByGoodsKind
                                           INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                                 ON ObjectLink_GoodsByGoodsKind_Goods.ObjectId          = Object_GoodsByGoodsKind.Id
                                                                AND ObjectLink_GoodsByGoodsKind_Goods.DescId            = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                                                AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId     > 0
                                           INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                                 ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId      = Object_GoodsByGoodsKind.Id
                                                                AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                                AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId > 0
       
                                           INNER JOIN ObjectFloat AS ObjectFloat_NormPack
                                                                  ON ObjectFloat_NormPack.ObjectId = Object_GoodsByGoodsKind.Id
                                                                 AND ObjectFloat_NormPack.DescId = zc_ObjectFloat_GoodsByGoodsKind_NormPack()
                                                                 AND COALESCE (ObjectFloat_NormPack.ValueData,0) <> 0
                                      WHERE Object_GoodsByGoodsKind.DescId   = zc_Object_GoodsByGoodsKind()
                                        AND Object_GoodsByGoodsKind.isErased = FALSE
                                     ) 
            , tmpChild_total AS (SELECT _Result_Child.KeyId
                                      , SUM (_Result_Child.AmountPack)       AS AmountPack
                                      , SUM (_Result_Child.AmountPackSecond) AS AmountPackSecond
                                      , SUM (_Result_Child.AmountPackTotal)  AS AmountPackTotal
                                      , SUM (CASE WHEN ObjectFloat_Weight.ValueData > 0 AND _Result_Child.MeasureId = zc_Measure_Sh() THEN _Result_Child.AmountPack       / ObjectFloat_Weight.ValueData ELSE 0 END :: Integer) AS AmountPack_sh
                                      , SUM (CASE WHEN ObjectFloat_Weight.ValueData > 0 AND _Result_Child.MeasureId = zc_Measure_Sh() THEN _Result_Child.AmountPackSecond / ObjectFloat_Weight.ValueData ELSE 0 END :: Integer) AS AmountPackSecond_sh
 
                                      , SUM (-1 * CASE WHEN _Result_Child.Amount_result_pack < 0 THEN _Result_Child.Amount_result_pack ELSE 0 END) AS Amount_result_pack
                                      , SUM (-1 * CASE WHEN _Result_Child.Amount_result_pack < 0 AND ObjectFloat_Weight.ValueData > 0 AND _Result_Child.MeasureId = zc_Measure_Sh() THEN _Result_Child.Amount_result_pack  / ObjectFloat_Weight.ValueData ELSE 0 END :: Integer) AS Amount_result_pack_sh
 
                                      , SUM (_Result_Child.AmountPackNext)       AS AmountPackNext
                                      , SUM (_Result_Child.AmountPackNextSecond) AS AmountPackNextSecond
                                      , SUM (_Result_Child.AmountPackNextTotal)  AS AmountPackNextTotal
                                      , SUM (CASE WHEN ObjectFloat_Weight.ValueData > 0 AND _Result_Child.MeasureId = zc_Measure_Sh() THEN _Result_Child.AmountPackNext       / ObjectFloat_Weight.ValueData ELSE 0 END :: Integer) AS AmountPackNext_sh
                                      , SUM (CASE WHEN ObjectFloat_Weight.ValueData > 0 AND _Result_Child.MeasureId = zc_Measure_Sh() THEN _Result_Child.AmountPackNextSecond / ObjectFloat_Weight.ValueData ELSE 0 END :: Integer) AS AmountPackNextSecond_sh

                                      , SUM (CASE WHEN COALESCE (tmpGoodsByGoodsKind.NormPack,0) <> 0 
                                                  THEN (COALESCE (_Result_Child.AmountPack,0)
                                                      + COALESCE (_Result_Child.AmountPackSecond,0)
                                                      + COALESCE (_Result_Child.AmountPackNext,0)
                                                      + COALESCE (_Result_Child.AmountPackNextSecond,0)) / tmpGoodsByGoodsKind.NormPack
                                                  ELSE 0
                                             END) ::TFloat AS HourPack_calc  -- расчет сколько врмени надо на весь план

                                 FROM _Result_Child
                                      LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                            ON ObjectFloat_Weight.ObjectId = _Result_Child.GoodsId
                                                           AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                        
                                      LEFT JOIN ObjectFloat AS ObjectFloat_Weight_Child
                                                            ON ObjectFloat_Weight_Child.ObjectId = _Result_Child.GoodsId
                                                           AND ObjectFloat_Weight_Child.DescId   = zc_ObjectFloat_Goods_Weight()

                                      LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId     = _Result_Child.GoodsId
                                                                   AND tmpGoodsByGoodsKind.GoodsKindId = _Result_Child.GoodsKindId
                                 WHERE _Result_Child.AmountPack       <> 0
                                    OR _Result_Child.AmountPackSecond <> 0
                                    OR _Result_Child.Income_PACK_from <> 0
                                    OR _Result_Child.AmountPackNext       <> 0
                                    OR _Result_Child.AmountPackNextSecond <> 0
                                    OR _Result_Child.Amount_result_pack   <> 0
                                 GROUP BY _Result_Child.KeyId
                                )

            , tmpMinus AS (SELECT DISTINCT _Result_Child.KeyId FROM _Result_Child WHERE _Result_Child.Amount_result_pack < 0)
            , tmpFind AS (SELECT DISTINCT _Result_Master.KeyId
                          FROM _Result_Master
                               LEFT JOIN _Result_Child ON _Result_Child.KeyId = _Result_Master.KeyId
                          WHERE _Result_Master.GoodsKindId <> COALESCE (_Result_Child.GoodsKindId, 0)
                         )                        


           -- Результат
           SELECT _Result_Master.Id
                , _Result_Master.KeyId
                , _Result_Master.GoodsId, _Result_Master.GoodsCode, _Result_Master.GoodsName
                , _Result_Master.GoodsId_basis, _Result_Master.GoodsCode_basis, _Result_Master.GoodsName_basis
                , _Result_Master.GoodsKindId, _Result_Master.GoodsKindName
                , _Result_Master.MeasureName, _Result_Master.MeasureName_basis
                , _Result_Master.GoodsGroupNameFull

                , COALESCE (ObjectFloat_Weight.ValueData, 0) :: TFloat AS Weight

                  -- ПРИОРИТЕТ
                , _Result_Master.Num

                  -- План1 выдачи с Ост. на УПАК
                , _Result_Master.Amount
                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND _Result_Master.MeasureId = zc_Measure_Sh() THEN (_Result_Master.Amount       / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS Amount_Sh
                  -- План1 выдачи с Цеха на УПАК
                , _Result_Master.AmountSecond
                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND _Result_Master.MeasureId = zc_Measure_Sh() THEN (_Result_Master.AmountSecond / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountSecond_Sh
                  -- План1 выдачи ИТОГО на УПАК
                , _Result_Master.AmountTotal
                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND _Result_Master.MeasureId = zc_Measure_Sh() THEN (_Result_Master.Amount       / ObjectFloat_Weight.ValueData) :: Integer + (_Result_Master.AmountSecond / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountTotal_Sh

                  -- План2 выдачи с Ост. на УПАК
                , _Result_Master.AmountNext
                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND _Result_Master.MeasureId = zc_Measure_Sh() THEN (_Result_Master.AmountNext   / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountNext_Sh
                  -- План2 выдачи с Цеха на УПАК
                , _Result_Master.AmountNextSecond
                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND _Result_Master.MeasureId = zc_Measure_Sh() THEN (_Result_Master.AmountNextSecond / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountNextSecond_Sh
                  -- План2 выдачи ИТОГО на УПАК
                , _Result_Master.AmountNextTotal
                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND _Result_Master.MeasureId = zc_Measure_Sh() THEN (_Result_Master.AmountNext       / ObjectFloat_Weight.ValueData) :: Integer + (_Result_Master.AmountNextSecond / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountNextTotal_Sh

                  -- План1 + План2 выдачи ИТОГО на УПАК
                , (_Result_Master.AmountTotal + _Result_Master.AmountNextTotal) :: TFloat AS AmountAllTotal
                , (CASE WHEN ObjectFloat_Weight.ValueData > 0 AND _Result_Master.MeasureId = zc_Measure_Sh() THEN (_Result_Master.Amount       / ObjectFloat_Weight.ValueData) :: Integer + (_Result_Master.AmountSecond / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END
                 + CASE WHEN ObjectFloat_Weight.ValueData > 0 AND _Result_Master.MeasureId = zc_Measure_Sh() THEN (_Result_Master.AmountNext       / ObjectFloat_Weight.ValueData) :: Integer + (_Result_Master.AmountNextSecond / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END
                  ) :: TFloat AS AmountAllTotal_Sh

                  -- Ост. начальн. - произв. (СЕГОДНЯ)
                , _Result_Master.Remains_CEH
                  -- Ост. начальн. - произв. (ПОЗЖЕ)
                , _Result_Master.Remains_CEH_Next
                
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

                  -- ИТОГО по Child - 
                , COALESCE (tmpChild_total.Amount_result_pack, 0)           :: TFloat AS Amount_result_pack_total
                , COALESCE (tmpChild_total.Amount_result_pack_sh, 0)        :: TFloat AS Amount_result_pack_total_sh

                  -- ИТОГО по Child - План для упаковки (с остатка, факт)
                , COALESCE (tmpChild_total.AmountPack, 0)           :: TFloat AS AmountPack_total
                , COALESCE (tmpChild_total.AmountPack_sh, 0)        :: TFloat AS AmountPack_total_sh
                  -- ИТОГО по Child - План для упаковки (с прихода с пр-ва, факт)
                , COALESCE (tmpChild_total.AmountPackSecond, 0)     :: TFloat AS AmountPackSecond_total
                , COALESCE (tmpChild_total.AmountPackSecond_sh, 0)  :: TFloat AS AmountPackSecond_total_sh
                  -- ИТОГО по Child - План для упаковки (ИТОГО, факт)
                , COALESCE (tmpChild_total.AmountPackTotal, 0)      :: TFloat AS AmountPackTotal_total
                , (COALESCE (tmpChild_total.AmountPack_sh, 0) + COALESCE (tmpChild_total.AmountPackSecond_sh, 0))   :: TFloat AS AmountPackTotal_total_sh

                  -- ИТОГО по Child - План2 для упаковки (с остатка, факт)
                , COALESCE (tmpChild_total.AmountPackNext, 0)           :: TFloat AS AmountPackNext_total
                , COALESCE (tmpChild_total.AmountPackNext_sh, 0)        :: TFloat AS AmountPackNext_total_sh
                  -- ИТОГО по Child - План2 для упаковки (с прихода с пр-ва, факт)
                , COALESCE (tmpChild_total.AmountPackNextSecond, 0)     :: TFloat AS AmountPackNextSecond_total
                , COALESCE (tmpChild_total.AmountPackNextSecond_sh, 0)  :: TFloat AS AmountPackNextSecond_total_sh
                  -- ИТОГО по Child - План2 для упаковки (ИТОГО, факт)
                , COALESCE (tmpChild_total.AmountPackNextTotal, 0)      :: TFloat AS AmountPackNextTotal_total
                , (COALESCE (tmpChild_total.AmountPackNext_sh, 0) + COALESCE (tmpChild_total.AmountPackNextSecond_sh, 0))   :: TFloat AS AmountPackNextTotal_total_sh
                  -- ИТОГО по Child - План+План2 для упаковки (ИТОГО, факт)
                , (COALESCE (tmpChild_total.AmountPackTotal, 0)+COALESCE (tmpChild_total.AmountPackNextTotal, 0))      :: TFloat AS AmountPackAllTotal_total
                , (COALESCE (tmpChild_total.AmountPack_sh, 0) + COALESCE (tmpChild_total.AmountPackSecond_sh, 0) + COALESCE (tmpChild_total.AmountPackNext_sh, 0) + COALESCE (tmpChild_total.AmountPackNextSecond_sh, 0))   :: TFloat AS AmountPackAllTotal_total_sh
                
                                
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
                
                -- План2 для упаковки (с остатка, факт)
                , _Result_Child.AmountPackNext        AS AmountPackNext_Child
                , CASE WHEN ObjectFloat_Weight_Child.ValueData > 0 AND _Result_Child.MeasureId = zc_Measure_Sh() THEN (_Result_Child.AmountPackNext       / ObjectFloat_Weight_Child.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountPackNext_Child_Sh
                  -- План2 для упаковки (с прихода с пр-ва, факт)
                , _Result_Child.AmountPackNextSecond  AS AmountPackNextSecond_Child
                , CASE WHEN ObjectFloat_Weight_Child.ValueData > 0 AND _Result_Child.MeasureId = zc_Measure_Sh() THEN (_Result_Child.AmountPackNextSecond / ObjectFloat_Weight_Child.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountPackNextSecond_Child_Sh
                  -- План2 для упаковки (ИТОГО, факт)
                , _Result_Child.AmountPackNextTotal   AS AmountPackNextTotal_Child
                , CASE WHEN ObjectFloat_Weight_Child.ValueData > 0 AND _Result_Child.MeasureId = zc_Measure_Sh() THEN (_Result_Child.AmountPackNext       / ObjectFloat_Weight_Child.ValueData) :: Integer + (_Result_Child.AmountPackNextSecond / ObjectFloat_Weight_Child.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountPackNextTotal_Child_Sh

                  -- План+План2 для упаковки (ИТОГО, факт)
                , (_Result_Child.AmountPackTotal+_Result_Child.AmountPackNextTotal)  :: TFloat  AS AmountPackAllTotal_Child
                , CASE WHEN ObjectFloat_Weight_Child.ValueData > 0 AND _Result_Child.MeasureId = zc_Measure_Sh() THEN ((_Result_Child.AmountPack / ObjectFloat_Weight_Child.ValueData) :: Integer + (_Result_Child.AmountPackSecond / ObjectFloat_Weight_Child.ValueData) :: Integer + _Result_Child.AmountPackNext / ObjectFloat_Weight_Child.ValueData) :: Integer + (_Result_Child.AmountPackNextSecond / ObjectFloat_Weight_Child.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountPackAllTotal_Child_Sh
               
                  -- Результат ПОСЛЕ УПАКОВКИ
                , _Result_Child.Amount_result_pack    AS Amount_result_pack_Child
                  -- Результат ПОСЛЕ УПАКОВКИ
                , CASE WHEN ObjectFloat_Weight_Child.ValueData > 0 AND _Result_Child.MeasureId = zc_Measure_Sh() THEN (_Result_Child.Amount_result_pack / ObjectFloat_Weight_Child.ValueData) :: Integer  ELSE 0 END :: TFloat  AS Amount_result_pack_Child_sh
                  -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
                , _Result_Child.DayCountForecast_calc AS DayCountForecast_calc_Child

                  -- ФАКТ - Перемещение на Цех Упаковки
                , _Result_Child.Income_PACK_to    AS Income_PACK_to_Child
                  -- ФАКТ - Перемещение с Цеха Упаковки
                , _Result_Child.Income_PACK_from  AS Income_PACK_from_Child

                , CASE WHEN _Result_Child.Income_PACK_from > _Result_Child.AmountPackTotal + _Result_Child.AmountPackNextTotal
                            THEN _Result_Child.Income_PACK_from - (_Result_Child.AmountPackTotal + _Result_Child.AmountPackNextTotal)
                       ELSE 0
                  END :: TFloat AS DiffPlus_PACK_from_Child

                , CASE WHEN _Result_Child.Income_PACK_from < _Result_Child.AmountPackTotal + _Result_Child.AmountPackNextTotal
                            THEN (_Result_Child.AmountPackTotal + _Result_Child.AmountPackNextTotal) - _Result_Child.Income_PACK_from
                       ELSE 0
                  END :: TFloat AS DiffMinus_PACK_from_Child

                , tmpGoodsByGoodsKind_ch.NormPack  ::TFloat

                , CAST (tmpChild_total.HourPack_calc AS NUMERIC (16,2)) ::TFloat AS HourPack_calc  -- расчет сколько врмени надо на весь план
                , CAST (CASE WHEN COALESCE (tmpGoodsByGoodsKind_ch.NormPack,0) <> 0 
                             THEN (COALESCE (_Result_Child.AmountPack,0)
                                 + COALESCE (_Result_Child.AmountPackSecond,0)
                                 + COALESCE (_Result_Child.AmountPackNext,0)
                                 + COALESCE (_Result_Child.AmountPackNextSecond,0)) / tmpGoodsByGoodsKind_ch.NormPack
                             ELSE 0
                        END  AS NUMERIC (16,2)) ::TFloat AS HourPack_calc_ch  -- расчет сколько врмени надо на весь план
           FROM _Result_Master
              LEFT JOIN tmpChild_total ON tmpChild_total.KeyId = _Result_Master.KeyId
              LEFT JOIN tmpFind        ON tmpFind.KeyId        = _Result_Master.KeyId
              LEFT JOIN (SELECT *
                         FROM _Result_Child
                         WHERE _Result_Child.Remains_pack         <> 0
                            OR _Result_Child.AmountPack           <> 0
                            OR _Result_Child.AmountPackSecond     <> 0
                            OR _Result_Child.AmountPackNext       <> 0
                            OR _Result_Child.AmountPackNextSecond <> 0
                            OR _Result_Child.Income_PACK_from     <> 0
                            OR _Result_Child.Amount_result_pack   < 0
                        ) AS _Result_Child ON _Result_Child.KeyId = _Result_Master.KeyId
              LEFT JOIN tmpMinus ON tmpMinus.KeyId = _Result_Master.KeyId

              LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                    ON ObjectFloat_Weight.ObjectId = _Result_Master.GoodsId
                                   AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

              LEFT JOIN ObjectFloat AS ObjectFloat_Weight_Child
                                    ON ObjectFloat_Weight_Child.ObjectId = _Result_Child.GoodsId
                                   AND ObjectFloat_Weight_Child.DescId = zc_ObjectFloat_Goods_Weight()

            LEFT JOIN tmpGoodsByGoodsKind AS tmpGoodsByGoodsKind_ch
                                          ON tmpGoodsByGoodsKind_ch.GoodsId     = _Result_Child.GoodsId
                                         AND tmpGoodsByGoodsKind_ch.GoodsKindId = _Result_Child.GoodsKindId

           WHERE ((COALESCE (_Result_Master.AmountTotal, 0)      <> 0 -- План1 выдачи ИТОГО на УПАК (факт)
                OR COALESCE (_Result_Master.AmountNextTotal, 0)  <> 0 -- План2 выдачи ИТОГО на УПАК (факт)
  
                OR COALESCE (_Result_Master.Income_PACK_to, 0)   <> 0 -- ИТОГО по Child - ФАКТ - Перемещение на Цех Упаковки
                OR COALESCE (_Result_Child.Income_PACK_from, 0)  <> 0 -- ФАКТ - Перемещение с Цеха Упаковки
  
                OR COALESCE (_Result_Child.AmountPackTotal, 0)       <> 0 -- План1 для упаковки (ИТОГО, факт)
                OR COALESCE (_Result_Child.AmountPackNextTotal, 0)   <> 0 -- План2 для упаковки (ИТОГО, факт)
  
                OR COALESCE (_Result_Child.Amount_result_pack, 0) < 0 -- Результат ПОСЛЕ УПАКОВКИ
  
                OR COALESCE (tmpChild_total.AmountPack, 0)       <> 0 -- ИТОГО по Child - План1 для упаковки (с остатка, факт)
                OR COALESCE (tmpChild_total.AmountPackSecond, 0) <> 0 -- ИТОГО по Child - План1 для упаковки (с прихода с пр-ва, факт)
  
                OR COALESCE (tmpChild_total.AmountPackNext, 0)       <> 0 -- ИТОГО по Child - План2 для упаковки (с остатка, факт)
                OR COALESCE (tmpChild_total.AmountPackNextSecond, 0) <> 0 -- ИТОГО по Child - План2 для упаковки (с прихода с пр-ва, факт)
                  )
              AND inIsMinus = FALSE)

                 -- Или ТОЛЬКО чего не хватило
              OR (-- _Result_Child.Amount_result_pack < 0
                  tmpMinus.KeyId IS NOT NULL
              AND tmpFind.KeyId  IS NOT NULL
              AND inIsMinus = TRUE)
          ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.11.17         *
 14.11.17                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderInternalPackRemains_Print (inMovementId:= 7463854, inIsMinus:= FALSE, inSession:= zfCalc_UserAdmin())
--select * from gpSelect_Movement_OrderInternalPackRemains_Print(inMovementId := 21321161 , inIsMinus := 'False' ,  inSession := '9457');