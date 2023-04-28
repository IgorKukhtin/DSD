-- Function: gpSelect_Movement_OrderInternalPackRemains_Print()

--DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternalPackRemains_Print2 (Integer, Boolean, TVarChar);

--CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderInternalPackRemains_Print2(
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternalPackRemains_DetailsPrint2 (Integer, TVarChar);
CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderInternalPackRemains_DetailsPrint2(
    IN inMovementId    Integer  , -- ключ Документа
    --IN inIsMinus       Boolean  , -- 
    IN inSession       TVarChar   -- сессия пользователя
)
RETURNS TABLE (KeyId TVarChar, GoodsId              Integer
             , GoodsCode            Integer
             , GoodsName            TVarChar
             , GoodsId_basis           Integer 
             , GoodsCode_basis         Integer 
             , GoodsName_basis         TVarChar
             
             , GoodsKindId          Integer
             , GoodsKindName        TVarChar

             , MeasureName          TVarChar
             , GoodsGroupNameFull   TVarChar

             , Weight               TFloat
             , Weight_Child         TFloat

               -- ПРИОРИТЕТ
             , Num                  Integer

             , GoodsCode_Child            Integer
             , GoodsName_Child            TVarChar
             , GoodsKindName_Child        TVarChar
             , MeasureName_Child          TVarChar
                  
                -- План+План2 для упаковки (ИТОГО, факт)
             , AmountPackAllTotal_Child      TFloat
             , AmountPackAllTotal_Child_Sh   TFloat         
               -- ИТОГО по Child - ФАКТ - Перемещение на Цех Упаковки
             , Income_PACK_to       TFloat
               -- ИТОГО по Child - ФАКТ - Перемещение с Цеха Упаковки
             , Income_PACK_from     TFloat          
               -- ФАКТ - Перемещение на Цех Упаковки
             , Income_PACK_to_Child       TFloat
               -- ФАКТ - Перемещение с Цеха Упаковки
             , Income_PACK_from_Child     TFloat
             , Income_PACK_to_Child_all   TFloat
             , Income_PACK_from_Child_all TFloat             
 
             , AmountPack1_all     TFloat
             , AmountPack2_all     TFloat
             , AmountPack3_all     TFloat
             , AmountPack4_all     TFloat
             , AmountPack5_all     TFloat
             , AmountPack6_all     TFloat
             , AmountPack7_all     TFloat
             , AmountPack8_all     TFloat
             , AmountPackTotal_All TFloat
             
             , AmountPack1     TFloat
             , AmountPack2     TFloat
             , AmountPack3     TFloat
             , AmountPack4     TFloat
             , AmountPack5     TFloat
             , AmountPack6     TFloat
             , AmountPack7     TFloat
             , AmountPack8     TFloat
             , AmountPackTotal TFloat

             , AmountPack1_Sh  TFloat
             , AmountPack2_Sh  TFloat
             , AmountPack3_Sh  TFloat
             , AmountPack4_Sh  TFloat
             , AmountPack5_Sh  TFloat
             , AmountPack6_Sh  TFloat
             , AmountPack7_Sh  TFloat
             , AmountPack8_Sh  TFloat
             , AmountPackTotal_Sh TFloat

             , InsertDate1 TVarChar
             , InsertDate2 TVarChar
             , InsertDate3 TVarChar
             , InsertDate4 TVarChar
             , InsertDate5 TVarChar
             , InsertDate6 TVarChar
             , InsertDate7 TVarChar
             , InsertDate8 TVarChar  
             
             
              )
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbOperDate TDateTime;
    DECLARE vbMaxAmount TFloat;
    DECLARE inIsMinus Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     inIsMinus:= false;
     
     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate
      INTO vbDescId, vbStatusId, vbOperDate
     FROM Movement
     WHERE Movement.Id = inMovementId;

     --количество операций
     vbMaxAmount := (SELECT Max(MovementItem.Amount) FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Detail());

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

   , tmpRez AS (
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

                , _Result_Child.Id                AS MovementItemId_child
                , _Result_Child.GoodsId           AS GoodsId_Child
                , _Result_Child.GoodsCode         AS GoodsCode_Child
                , _Result_Child.GoodsName         AS GoodsName_Child
                , _Result_Child.GoodsKindName     AS GoodsKindName_Child
                , _Result_Child.MeasureId         AS MeasureId_Child
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
          )

    , tmpMI_Complete AS (SELECT *
                         FROM MovementItemLinkObject
                         WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpRez.Id FROM tmpRez)
                           AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Goods(), zc_MILinkObject_GoodsKindComplete())
                         )

    , tmpMI_detailList AS (SELECT MovementItem.Id                   AS MovementItemId
                           , MovementItem.ParentId             AS ParentId
                           , MovementItem.ObjectId             AS Insertd
                           , MILO_Update.ObjectId              AS UpdateId
                           , MIDate_Insert.ValueData           AS InsertDate
                           , MIDate_Update.ValueData           AS UpdateDate
                           , MovementItem.Amount               AS Amount
                           , COALESCE (MIBoolean_Calculated.ValueData, FALSE) ::Boolean AS isCalculated
                           
                           , MIFloat_AmountPack.ValueData                AS AmountPack
                           , MIFloat_AmountPackSecond.ValueData          AS AmountPackSecond
                           , MIFloat_AmountPackNext.ValueData            AS AmountPackNext
                           , MIFloat_AmountPackNextSecond.ValueData      AS AmountPackNextSecond

                           , COALESCE (MIFloat_AmountPack.ValueData,0)
                           + COALESCE (MIFloat_AmountPackSecond.ValueData,0)
                           + COALESCE (MIFloat_AmountPackNext.ValueData,0)
                           + COALESCE (MIFloat_AmountPackNextSecond.ValueData,0) AS AmountPackAllTotal
                             -- № п/п
                           , ROW_NUMBER() OVER (PARTITION BY MovementItem.ParentId ORDER BY MovementItem.Id ASC) AS Ord

                      FROM MovementItem
                           LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                         ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                                        AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()

                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPack
                                                       ON MIFloat_AmountPack.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPack.DescId = zc_MIFloat_AmountPack()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPackSecond
                                                       ON MIFloat_AmountPackSecond.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPackSecond.DescId = zc_MIFloat_AmountPackSecond()

                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNext
                                                       ON MIFloat_AmountPackNext.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPackNext.DescId = zc_MIFloat_AmountPackNext()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNextSecond
                                                       ON MIFloat_AmountPackNextSecond.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPackNextSecond.DescId = zc_MIFloat_AmountPackNextSecond()

                           LEFT JOIN MovementItemDate AS MIDate_Insert
                                                      ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                     AND MIDate_Insert.DescId = zc_MIDate_Insert()
                           LEFT JOIN MovementItemDate AS MIDate_Update
                                                      ON MIDate_Update.MovementItemId = MovementItem.Id
                                                     AND MIDate_Update.DescId = zc_MIDate_Update()
                           LEFT JOIN MovementItemLinkObject AS MILO_Update
                                                            ON MILO_Update.MovementItemId = MovementItem.Id
                                                           AND MILO_Update.DescId = zc_MILinkObject_Update()

                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Detail()
                        AND MovementItem.isErased   = FALSE
                      )
    --находим предідущие значения чтоб получить разницу, т.е. факт за каждую операцию
   , tmpMI_detail AS (SELECT tmpMI_detail.ParentId
                             , tmpMI_detail.Amount
                             , MIN (COALESCE (tmpMI_detail.UpdateDate, tmpMI_detail.InsertDate)) AS InsertDate

                             , SUM (COALESCE (tmpMI_detail.AmountPackAllTotal, 0)) AS AmountPackAllTotal 
                             , SUM ( COALESCE (tmpMI_detail.AmountPackAllTotal, 0) - COALESCE (tmpMI_detail_old.AmountPackAllTotal,0)) ::TFloat AS AmountPackAllTotal_diff                             
                        FROM tmpMI_detailList AS tmpMI_detail
                             LEFT JOIN tmpMI_detailList AS tmpMI_detail_old ON tmpMI_detail_old.ParentId = tmpMI_detail.ParentId
                                                                       AND tmpMI_detail_old.Amount   = tmpMI_detail.Amount - 1
                        GROUP BY tmpMI_detail.ParentId
                               , tmpMI_detail.Amount
                        )

         
    , tmpRez_Detail AS (
           SELECT tmpRez.KeyId
                 , tmpRez.GoodsId
                , tmpRez.GoodsCode
                , tmpRez.GoodsName
                , tmpRez.GoodsId_basis
                , tmpRez.GoodsCode_basis
                , tmpRez.GoodsName_basis 
                , tmpRez.GoodsKindId
                , tmpRez.GoodsKindName
                , tmpRez.MeasureName
                , tmpRez.MeasureName_basis
                , tmpRez.GoodsGroupNameFull
                , tmpRez.Weight
                , tmpRez.Weight_Child
                  -- ПРИОРИТЕТ
                , tmpRez.Num
                
                , tmpRez.GoodsId_Child
                , tmpRez.GoodsCode_Child
                , tmpRez.GoodsName_Child
                , tmpRez.GoodsKindName_Child
                , tmpRez.MeasureId_Child
                , tmpRez.MeasureName_Child

                  -- План+План2 для упаковки (ИТОГО, факт)
                , tmpRez.AmountPackAllTotal_Child      ::TFloat
                , tmpRez.AmountPackAllTotal_Child_Sh   ::TFloat
                
                  -- ИТОГО по Child - ФАКТ - Перемещение на Цех Упаковки
                , max (COALESCE (tmpRez.Income_PACK_to,0))  ::TFloat AS Income_PACK_to
                  -- ИТОГО по Child - ФАКТ - Перемещение с Цеха Упаковки
                , tmpRez.Income_PACK_from ::TFloat

                  -- ФАКТ - Перемещение на Цех Упаковки
                , tmpRez.Income_PACK_to_Child    ::TFloat       --***
                  -- ФАКТ - Перемещение с Цеха Упаковки         
                , tmpRez.Income_PACK_from_Child  ::TFloat       --***
 
              
               -- ,  (tmpMI_detail.AmountPackAllTotal) AS AmountPackAllTotal
                , SUM (tmpMI_detail.AmountPackAllTotal_diff) AS AmountPackAll
                , SUM (CASE WHEN vbMaxAmount < 8 AND tmpMI_detail.Amount = 1 THEN tmpMI_detail.AmountPackAllTotal
                            WHEN vbMaxAmount >= 8 AND tmpMI_detail.Amount <= vbMaxAmount-7 THEN tmpMI_detail.AmountPackAllTotal_diff  
                            ELSE 0
                       END) ::TFloat AS AmountPack1

                , SUM (CASE WHEN vbMaxAmount < 8 AND tmpMI_detail.Amount = 2 THEN tmpMI_detail.AmountPackAllTotal_diff
                            WHEN vbMaxAmount >= 8 AND tmpMI_detail.Amount = vbMaxAmount-6 THEN tmpMI_detail.AmountPackAllTotal_diff  
                            ELSE 0
                       END) ::TFloat AS AmountPack2 

                , SUM (CASE WHEN vbMaxAmount < 8 AND tmpMI_detail.Amount = 3 THEN tmpMI_detail.AmountPackAllTotal_diff
                            WHEN vbMaxAmount >= 8 AND tmpMI_detail.Amount = vbMaxAmount-5 THEN tmpMI_detail.AmountPackAllTotal_diff  
                            ELSE 0
                       END) ::TFloat AS AmountPack3 

                 , SUM (CASE WHEN vbMaxAmount < 8 AND tmpMI_detail.Amount = 4 THEN tmpMI_detail.AmountPackAllTotal_diff
                            WHEN vbMaxAmount >= 8 AND tmpMI_detail.Amount = vbMaxAmount-4 THEN tmpMI_detail.AmountPackAllTotal_diff  
                            ELSE 0
                       END) ::TFloat AS AmountPack4 

                , SUM (CASE WHEN vbMaxAmount < 8 AND tmpMI_detail.Amount = 5 THEN tmpMI_detail.AmountPackAllTotal_diff
                            WHEN vbMaxAmount >= 8 AND tmpMI_detail.Amount = vbMaxAmount-3 THEN tmpMI_detail.AmountPackAllTotal_diff  
                            ELSE 0
                       END) ::TFloat AS AmountPack5       
                , SUM (CASE WHEN vbMaxAmount < 8 AND tmpMI_detail.Amount = 6 THEN tmpMI_detail.AmountPackAllTotal_diff
                            WHEN vbMaxAmount >= 8 AND tmpMI_detail.Amount = vbMaxAmount-2 THEN tmpMI_detail.AmountPackAllTotal_diff  
                            ELSE 0
                       END) ::TFloat AS AmountPack6
                , SUM (CASE WHEN vbMaxAmount < 8 AND tmpMI_detail.Amount = 7 THEN tmpMI_detail.AmountPackAllTotal_diff
                            WHEN vbMaxAmount >= 8 AND tmpMI_detail.Amount = vbMaxAmount-1 THEN tmpMI_detail.AmountPackAllTotal_diff  
                            ELSE 0
                       END) ::TFloat AS AmountPack7
                , SUM (CASE WHEN vbMaxAmount <= 8 AND tmpMI_detail.Amount = 8 THEN tmpMI_detail.AmountPackAllTotal_diff
                            WHEN vbMaxAmount >= 8 AND tmpMI_detail.Amount = vbMaxAmount THEN tmpMI_detail.AmountPackAllTotal_diff  
                            ELSE 0
                       END) ::TFloat AS AmountPack8
                 ----
                , MIN (CASE WHEN vbMaxAmount < 8 AND tmpMI_detail.Amount = 1 THEN tmpMI_detail.InsertDate
                            WHEN vbMaxAmount >= 8 AND tmpMI_detail.Amount <= vbMaxAmount-7 THEN tmpMI_detail.InsertDate 
                            ELSE NULL
                       END) :: TDateTime AS InsertDate1 
                , MIN (CASE WHEN vbMaxAmount < 8 AND tmpMI_detail.Amount = 2 THEN tmpMI_detail.InsertDate
                            WHEN vbMaxAmount >= 8 AND tmpMI_detail.Amount = vbMaxAmount-6 THEN tmpMI_detail.InsertDate  
                            ELSE NULL
                       END) :: TDateTime AS InsertDate2
                , MIN (CASE WHEN vbMaxAmount < 8 AND tmpMI_detail.Amount = 3 THEN tmpMI_detail.InsertDate
                            WHEN vbMaxAmount >= 8 AND tmpMI_detail.Amount = vbMaxAmount-5 THEN tmpMI_detail.InsertDate  
                            ELSE NULL
                       END) :: TDateTime AS InsertDate3
                , MIN (CASE WHEN vbMaxAmount < 8 AND tmpMI_detail.Amount = 4 THEN tmpMI_detail.InsertDate
                            WHEN vbMaxAmount >= 8 AND tmpMI_detail.Amount = vbMaxAmount-4 THEN tmpMI_detail.InsertDate  
                            ELSE NULL
                       END) :: TDateTime AS InsertDate4
                , MIN (CASE WHEN vbMaxAmount < 8 AND tmpMI_detail.Amount = 5 THEN tmpMI_detail.InsertDate
                            WHEN vbMaxAmount >= 8 AND tmpMI_detail.Amount = vbMaxAmount-3 THEN tmpMI_detail.InsertDate  
                            ELSE NULL
                       END) :: TDateTime AS InsertDate5       
                , MIN (CASE WHEN vbMaxAmount < 8 AND tmpMI_detail.Amount = 6 THEN tmpMI_detail.InsertDate
                            WHEN vbMaxAmount >= 8 AND tmpMI_detail.Amount = vbMaxAmount-2 THEN tmpMI_detail.InsertDate  
                            ELSE NULL
                       END) :: TDateTime AS InsertDate6
                , MIN (CASE WHEN vbMaxAmount < 8 AND tmpMI_detail.Amount = 7 THEN tmpMI_detail.InsertDate
                            WHEN vbMaxAmount >= 8 AND tmpMI_detail.Amount = vbMaxAmount-1 THEN tmpMI_detail.InsertDate 
                            ELSE NULL
                       END) :: TDateTime AS InsertDate7
                , MIN (CASE WHEN vbMaxAmount <= 8 AND tmpMI_detail.Amount = 8 THEN tmpMI_detail.InsertDate
                            WHEN vbMaxAmount >= 8 AND tmpMI_detail.Amount = vbMaxAmount THEN tmpMI_detail.InsertDate  
                            ELSE NULL
                       END) :: TDateTime AS InsertDate8 


           FROM tmpRez
                LEFT JOIN tmpMI_detail ON tmpMI_detail.ParentId = tmpRez.MovementItemId_child
           GROUP BY tmpRez.GoodsId
                , tmpRez.GoodsCode
                , tmpRez.GoodsName
                , tmpRez.GoodsId_basis
                , tmpRez.GoodsCode_basis
                , tmpRez.GoodsName_basis
                , tmpRez.GoodsKindId
                , tmpRez.GoodsKindName
                , tmpRez.MeasureName
                , tmpRez.MeasureName_basis
                , tmpRez.GoodsGroupNameFull
                , tmpRez.Weight 
                , tmpRez.Weight_Child
                  -- ПРИОРИТЕТ
                , tmpRez.Num
                
                , tmpRez.GoodsId_Child
                , tmpRez.GoodsCode_Child
                , tmpRez.GoodsName_Child
                , tmpRez.GoodsKindName_Child
                , tmpRez.MeasureName_Child
                , tmpRez.MeasureId_Child

                  -- План+План2 для упаковки (ИТОГО, факт)
                , tmpRez.AmountPackAllTotal_Child   
                , tmpRez.AmountPackAllTotal_Child_Sh
                
                  -- ИТОГО по Child - ФАКТ - Перемещение на Цех Упаковки
                --, tmpRez.Income_PACK_to
                  -- ИТОГО по Child - ФАКТ - Перемещение с Цеха Упаковки
                , tmpRez.Income_PACK_from ::TFloat

                  -- ФАКТ - Перемещение на Цех Упаковки
                , tmpRez.Income_PACK_to_Child --Income_PACK_to_Child
                  -- ФАКТ - Перемещение с Цеха Упаковки
                , tmpRez.Income_PACK_from_Child
                , tmpRez.KeyId

    )      
    
           SELECT tmpRez.KeyId
                , tmpRez.GoodsId
                , tmpRez.GoodsCode
                , tmpRez.GoodsName
                , tmpRez.GoodsId_basis
                , tmpRez.GoodsCode_basis
                , tmpRez.GoodsName_basis
                , tmpRez.GoodsKindId
                , tmpRez.GoodsKindName 
                , tmpRez.MeasureName
                , tmpRez.GoodsGroupNameFull
                , tmpRez.Weight
                , tmpRez.Weight_Child
                  -- ПРИОРИТЕТ
                , tmpRez.Num
                
                , tmpRez.GoodsCode_Child
                , tmpRez.GoodsName_Child
                , tmpRez.GoodsKindName_Child
                , tmpRez.MeasureName_Child
              
                  -- План+План2 для упаковки (ИТОГО, факт)
                , tmpRez.AmountPackAllTotal_Child      ::TFloat
                , tmpRez.AmountPackAllTotal_Child_Sh   ::TFloat
 
                   -- ИТОГО по Child - ФАКТ - Перемещение на Цех Упаковки
                , tmpRez.Income_PACK_to
                  -- ИТОГО по Child - ФАКТ - Перемещение с Цеха Упаковки
                , tmpRez.Income_PACK_from ::TFloat
               
                  -- ФАКТ - Перемещение на Цех Упаковки
                , tmpRez.Income_PACK_to_Child    ::TFloat       --***
                  -- ФАКТ - Перемещение с Цеха Упаковки         
                , tmpRez.Income_PACK_from_Child  ::TFloat       --***  
                
                , SUM (COALESCE (tmpRez.Income_PACK_to_Child,0)) OVER (PARTITION BY tmpRez.KeyId)   ::TFloat  AS Income_PACK_to_Child_all
                , SUM (COALESCE (tmpRez.Income_PACK_from_Child,0)) OVER (PARTITION BY tmpRez.KeyId) ::TFloat  AS Income_PACK_from_Child_all

                , SUM (COALESCE (tmpRez.AmountPack1,0)) OVER (PARTITION BY tmpRez.KeyId) ::TFloat  AS AmountPack1_all
                , SUM (COALESCE (tmpRez.AmountPack2,0)) OVER (PARTITION BY tmpRez.KeyId) ::TFloat  AS AmountPack2_all
                , SUM (COALESCE (tmpRez.AmountPack3,0)) OVER (PARTITION BY tmpRez.KeyId) ::TFloat  AS AmountPack3_all
                , SUM (COALESCE (tmpRez.AmountPack4,0)) OVER (PARTITION BY tmpRez.KeyId) ::TFloat  AS AmountPack4_all
                , SUM (COALESCE (tmpRez.AmountPack5,0)) OVER (PARTITION BY tmpRez.KeyId) ::TFloat  AS AmountPack5_all
                , SUM (COALESCE (tmpRez.AmountPack6,0)) OVER (PARTITION BY tmpRez.KeyId) ::TFloat  AS AmountPack6_all
                , SUM (COALESCE (tmpRez.AmountPack7,0)) OVER (PARTITION BY tmpRez.KeyId) ::TFloat  AS AmountPack7_all
                , SUM (COALESCE (tmpRez.AmountPack8,0)) OVER (PARTITION BY tmpRez.KeyId) ::TFloat  AS AmountPack8_all
                , SUM (COALESCE (tmpRez.AmountPackAll,0)) OVER (PARTITION BY tmpRez.KeyId) ::TFloat  AS AmountPackTotal_All
              
                
                --, tmpRez.AmountPackAll::TFloat
                , tmpRez.AmountPack1::TFloat
                , tmpRez.AmountPack2 ::TFloat      
                , tmpRez.AmountPack3::TFloat
                , tmpRez.AmountPack4::TFloat
                , tmpRez.AmountPack5::TFloat
                , tmpRez.AmountPack6::TFloat
                , tmpRez.AmountPack7::TFloat
                , tmpRez.AmountPack8::TFloat
                
                , (COALESCE (tmpRez.AmountPack1,0)
                 + COALESCE (tmpRez.AmountPack2,0)
                 + COALESCE (tmpRez.AmountPack3,0)
                 + COALESCE (tmpRez.AmountPack4,0)
                 + COALESCE (tmpRez.AmountPack5,0)
                 + COALESCE (tmpRez.AmountPack6,0)
                 + COALESCE (tmpRez.AmountPack7,0)
                 + COALESCE (tmpRez.AmountPack8,0))  ::TFloat AS AmountPackTotal 
                 
                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND tmpRez.MeasureId_Child = zc_Measure_Sh() THEN (tmpRez.AmountPack1 / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountPack1_Sh
                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND tmpRez.MeasureId_Child = zc_Measure_Sh() THEN (tmpRez.AmountPack2 / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountPack2_Sh
                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND tmpRez.MeasureId_Child = zc_Measure_Sh() THEN (tmpRez.AmountPack3 / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountPack3_Sh
                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND tmpRez.MeasureId_Child = zc_Measure_Sh() THEN (tmpRez.AmountPack4 / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountPack4_Sh
                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND tmpRez.MeasureId_Child = zc_Measure_Sh() THEN (tmpRez.AmountPack5 / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountPack5_Sh
                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND tmpRez.MeasureId_Child = zc_Measure_Sh() THEN (tmpRez.AmountPack6 / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountPack6_Sh
                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND tmpRez.MeasureId_Child = zc_Measure_Sh() THEN (tmpRez.AmountPack7 / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountPack7_Sh
                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND tmpRez.MeasureId_Child = zc_Measure_Sh() THEN (tmpRez.AmountPack8 / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountPack8_Sh

                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND tmpRez.MeasureId_Child = zc_Measure_Sh() THEN ((COALESCE (tmpRez.AmountPack1,0)
                                                                                                                     + COALESCE (tmpRez.AmountPack2,0)
                                                                                                                     + COALESCE (tmpRez.AmountPack3,0)
                                                                                                                     + COALESCE (tmpRez.AmountPack4,0)
                                                                                                                     + COALESCE (tmpRez.AmountPack5,0)
                                                                                                                     + COALESCE (tmpRez.AmountPack6,0)
                                                                                                                     + COALESCE (tmpRez.AmountPack7,0)
                                                                                                                     + COALESCE (tmpRez.AmountPack8,0)) / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountPackTotal_Sh

                 ----
                
                , (zfConvert_TimeShortToString ( MAX (tmpRez.InsertDate1) OVER (ORDER BY tmpRez.AmountPack1 DESC)) ::TVarChar 
                  ||' (' ||CASE WHEN vbMaxAmount <= 8 THEN '1)' WHEN vbMaxAmount > 8 THEN '1-'|| (vbMaxAmount - 7)::integer ||')' ELSE ')' END) ::TVarChar AS InsertDate1
                , (zfConvert_TimeShortToString ( MAX (tmpRez.InsertDate2) OVER (ORDER BY tmpRez.AmountPack1 DESC)) ::TVarChar
                  ||' (' ||CASE WHEN vbMaxAmount <= 8 THEN '2)' WHEN vbMaxAmount > 8 THEN ''|| (vbMaxAmount - 6)::integer ||')' ELSE ')' END)  ::TVarChar  AS InsertDate2
                , (zfConvert_TimeShortToString ( MAX (tmpRez.InsertDate3) OVER (ORDER BY tmpRez.AmountPack1 DESC)) ::TVarChar                  
                  ||' (' ||CASE WHEN vbMaxAmount <= 8 THEN '3)' WHEN vbMaxAmount > 8 THEN ''|| (vbMaxAmount - 5)::integer ||')' ELSE ')' END)  ::TVarChar  AS InsertDate3
                , (zfConvert_TimeShortToString ( MAX (tmpRez.InsertDate4) OVER (ORDER BY tmpRez.AmountPack1 DESC)) ::TVarChar                  
                  ||' (' ||CASE WHEN vbMaxAmount <= 8 THEN '4)' WHEN vbMaxAmount > 8 THEN ''|| (vbMaxAmount - 4)::integer ||')' ELSE ')' END)  ::TVarChar  AS InsertDate4  
                , (zfConvert_TimeShortToString ( MAX (tmpRez.InsertDate5) OVER (ORDER BY tmpRez.AmountPack1 DESC)) ::TVarChar                  
                  ||' (' ||CASE WHEN vbMaxAmount <= 8 THEN '5)' WHEN vbMaxAmount > 8 THEN ''|| (vbMaxAmount - 3)::integer ||')' ELSE ')' END)  ::TVarChar  AS InsertDate5
                , (zfConvert_TimeShortToString ( MAX (tmpRez.InsertDate6) OVER (ORDER BY tmpRez.AmountPack1 DESC)) ::TVarChar                  
                  ||' (' ||CASE WHEN vbMaxAmount <= 8 THEN '6)' WHEN vbMaxAmount > 8 THEN ''|| (vbMaxAmount - 2)::integer ||')' ELSE ')' END)  ::TVarChar  AS InsertDate6
                , (zfConvert_TimeShortToString ( MAX (tmpRez.InsertDate7) OVER (ORDER BY tmpRez.AmountPack1 DESC)) ::TVarChar                  
                  ||' (' ||CASE WHEN vbMaxAmount <= 8 THEN '7)' WHEN vbMaxAmount > 8 THEN ''|| (vbMaxAmount - 1)::integer ||')' ELSE ')' END)  ::TVarChar  AS InsertDate7
                , (zfConvert_TimeShortToString ( MAX (tmpRez.InsertDate8) OVER (ORDER BY tmpRez.AmountPack1 DESC)) ::TVarChar                 
                  ||' (' ||CASE WHEN vbMaxAmount <= 8 THEN '8)' WHEN vbMaxAmount > 8 THEN ''|| (vbMaxAmount)::integer ||')' ELSE ')' END)      ::TVarChar  AS InsertDate8 
                
    FROM  tmpRez_Detail AS tmpRez
          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = tmpRez.GoodsId_child
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
       
    WHERE (COALESCE (tmpRez.AmountPack1, 0) <> 0
       OR COALESCE (tmpRez.AmountPack2, 0) <> 0
       OR COALESCE (tmpRez.AmountPack3, 0) <> 0
       OR COALESCE (tmpRez.AmountPack4, 0) <> 0
       OR COALESCE (tmpRez.AmountPack5, 0) <> 0
       OR COALESCE (tmpRez.AmountPack6, 0) <> 0
       OR COALESCE (tmpRez.AmountPack7, 0) <> 0
       OR COALESCE (tmpRez.AmountPack8, 0) <> 0
       OR COALESCE (tmpRez.Income_PACK_to, 0) <> 0
       OR COALESCE (tmpRez.Income_PACK_from_Child, 0) <> 0 )
       --AND tmpRez.GoodsId = 5244
       
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
-- 
--select * from gpSelect_Movement_OrderInternalPackRemains_Print2(inMovementId := 21321161 , inIsMinus := 'False' ,  inSession := '9457');
--select * from gpSelect_Movement_OrderInternalPackRemains_Print2(inMovementId := 21321161 , inIsMinus := 'False' ,  inSession := '9457');
--select * from gpSelect_Movement_OrderInternalPackRemains_DetailsPrint2(inMovementId := 25104454   ,  inSession := '9457')
--where goodscode = 190;

/*


  select  lpSelect_MI_OrderInternalPackRemains (inMovementId:= 25104454, inShowAll:= FALSE, inIsErased:= FALSE, inUserId:= 5) ;

     
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

   , tmpRez AS (
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

                , _Result_Child.Id                AS MovementItemId_child
                , _Result_Child.GoodsId           AS GoodsId_Child
                , _Result_Child.GoodsCode         AS GoodsCode_Child
                , _Result_Child.GoodsName         AS GoodsName_Child
                , _Result_Child.GoodsKindName     AS GoodsKindName_Child
                , _Result_Child.MeasureId         AS MeasureId_Child
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
              AND false = FALSE)

                 -- Или ТОЛЬКО чего не хватило
              OR (-- _Result_Child.Amount_result_pack < 0
                  tmpMinus.KeyId IS NOT NULL
              AND tmpFind.KeyId  IS NOT NULL
              AND false = TRUE)
          )

    , tmpMI_Complete AS (SELECT *
                         FROM MovementItemLinkObject
                         WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpRez.Id FROM tmpRez)
                           AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Goods(), zc_MILinkObject_GoodsKindComplete())
                         )

    , tmpMI_detailList AS (SELECT MovementItem.Id                   AS MovementItemId
                           , MovementItem.ParentId             AS ParentId
                           , MovementItem.ObjectId             AS Insertd
                           , MILO_Update.ObjectId              AS UpdateId
                           , MIDate_Insert.ValueData           AS InsertDate
                           , MIDate_Update.ValueData           AS UpdateDate
                           , MovementItem.Amount               AS Amount
                           , COALESCE (MIBoolean_Calculated.ValueData, FALSE) ::Boolean AS isCalculated
                           
                           , MIFloat_AmountPack.ValueData                AS AmountPack
                           , MIFloat_AmountPackSecond.ValueData          AS AmountPackSecond
                           , MIFloat_AmountPackNext.ValueData            AS AmountPackNext
                           , MIFloat_AmountPackNextSecond.ValueData      AS AmountPackNextSecond

                           , COALESCE (MIFloat_AmountPack.ValueData,0)
                           + COALESCE (MIFloat_AmountPackSecond.ValueData,0)
                           + COALESCE (MIFloat_AmountPackNext.ValueData,0)
                           + COALESCE (MIFloat_AmountPackNextSecond.ValueData,0) AS AmountPackAllTotal
                             -- № п/п
                           , ROW_NUMBER() OVER (PARTITION BY MovementItem.ParentId ORDER BY MovementItem.Id ASC) AS Ord

                      FROM MovementItem
                           LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                         ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                                        AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()

                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPack
                                                       ON MIFloat_AmountPack.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPack.DescId = zc_MIFloat_AmountPack()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPackSecond
                                                       ON MIFloat_AmountPackSecond.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPackSecond.DescId = zc_MIFloat_AmountPackSecond()

                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNext
                                                       ON MIFloat_AmountPackNext.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPackNext.DescId = zc_MIFloat_AmountPackNext()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNextSecond
                                                       ON MIFloat_AmountPackNextSecond.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPackNextSecond.DescId = zc_MIFloat_AmountPackNextSecond()

                           LEFT JOIN MovementItemDate AS MIDate_Insert
                                                      ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                     AND MIDate_Insert.DescId = zc_MIDate_Insert()
                           LEFT JOIN MovementItemDate AS MIDate_Update
                                                      ON MIDate_Update.MovementItemId = MovementItem.Id
                                                     AND MIDate_Update.DescId = zc_MIDate_Update()
                           LEFT JOIN MovementItemLinkObject AS MILO_Update
                                                            ON MILO_Update.MovementItemId = MovementItem.Id
                                                           AND MILO_Update.DescId = zc_MILinkObject_Update()

                      WHERE MovementItem.MovementId = 25104454
                        AND MovementItem.DescId     = zc_MI_Detail()
                        AND MovementItem.isErased   = FALSE
                      )
    --находим предідущие значения чтоб получить разницу, т.е. факт за каждую операцию
   , tmpMI_detail AS (SELECT tmpMI_detail.ParentId
                             , tmpMI_detail.Amount
                             , MIN (COALESCE (tmpMI_detail.UpdateDate, tmpMI_detail.InsertDate)) AS InsertDate

                             , SUM (COALESCE (tmpMI_detail.AmountPackAllTotal, 0)) AS AmountPackAllTotal 
                             , SUM ( COALESCE (tmpMI_detail.AmountPackAllTotal, 0) - COALESCE (tmpMI_detail_old.AmountPackAllTotal,0)) ::TFloat AS AmountPackAllTotal_diff                             
                        FROM tmpMI_detailList AS tmpMI_detail
                             LEFT JOIN tmpMI_detailList AS tmpMI_detail_old ON tmpMI_detail_old.ParentId = tmpMI_detail.ParentId
                                                                       AND tmpMI_detail_old.Amount   = tmpMI_detail.Amount - 1

                        GROUP BY tmpMI_detail.ParentId
                               , tmpMI_detail.Amount
                        )

         
    , tmpRez_Detail AS (
           SELECT tmpRez.KeyId
                 , tmpRez.GoodsId
                , tmpRez.GoodsCode
                , tmpRez.GoodsName
                , tmpRez.GoodsId_basis
                , tmpRez.GoodsCode_basis
                , tmpRez.GoodsName_basis 
         
                , tmpRez.GoodsKindId
                , tmpRez.GoodsKindName
                , tmpRez.MeasureName
                , tmpRez.MeasureName_basis
                , tmpRez.GoodsGroupNameFull
                , tmpRez.Weight
                , tmpRez.Weight_Child
                  -- ПРИОРИТЕТ
                , tmpRez.Num
                
                , tmpRez.GoodsId_Child
                , tmpRez.GoodsCode_Child
                , tmpRez.GoodsName_Child
                , tmpRez.GoodsKindName_Child
                , tmpRez.MeasureId_Child
                , tmpRez.MeasureName_Child

                  -- План+План2 для упаковки (ИТОГО, факт)
                , tmpRez.AmountPackAllTotal_Child      ::TFloat
                , tmpRez.AmountPackAllTotal_Child_Sh   ::TFloat
                
                  -- ИТОГО по Child - ФАКТ - Перемещение на Цех Упаковки
                --, tmpRez.Income_PACK_to   ::TFloat
                  -- ИТОГО по Child - ФАКТ - Перемещение с Цеха Упаковки
                --, tmpRez.Income_PACK_from ::TFloat

                  -- ФАКТ - Перемещение на Цех Упаковки
                , tmpRez.Income_PACK_to_Child    ::TFloat       --***
                  -- ФАКТ - Перемещение с Цеха Упаковки         
                , tmpRez.Income_PACK_from_Child  ::TFloat       --***
                , tmpRez.Income_PACK_to    ::TFloat    
                
               -- ,  (tmpMI_detail.AmountPackAllTotal) AS AmountPackAllTotal
                , SUM (tmpMI_detail.AmountPackAllTotal_diff) AS AmountPackAll
                , SUM (CASE WHEN 4 < 5 AND tmpMI_detail.Amount = 1 THEN tmpMI_detail.AmountPackAllTotal
                            WHEN 4 >= 5 AND tmpMI_detail.Amount <= 4-4 THEN tmpMI_detail.AmountPackAllTotal_diff  
                            ELSE 0
                       END) ::TFloat AS AmountPack1
                , SUM (CASE WHEN 4 < 5 AND tmpMI_detail.Amount = 2 THEN tmpMI_detail.AmountPackAllTotal_diff
                            WHEN 4 >= 5 AND tmpMI_detail.Amount = 4-3 THEN tmpMI_detail.AmountPackAllTotal_diff  
                            ELSE 0
                       END) ::TFloat AS AmountPack2       
                , SUM (CASE WHEN 4 < 5 AND tmpMI_detail.Amount = 2 THEN tmpMI_detail.AmountPackAllTotal_diff
                            WHEN 4 >= 5 AND tmpMI_detail.Amount = 4-2 THEN tmpMI_detail.AmountPackAllTotal_diff  
                            ELSE 0
                       END) ::TFloat AS AmountPack3
                , SUM (CASE WHEN 4 < 5 AND tmpMI_detail.Amount = 3 THEN tmpMI_detail.AmountPackAllTotal_diff
                            WHEN 4 >= 5 AND tmpMI_detail.Amount = 4-1 THEN tmpMI_detail.AmountPackAllTotal_diff  
                            ELSE 0
                       END) ::TFloat AS AmountPack4
                , SUM (CASE WHEN 4 < 5 AND tmpMI_detail.Amount = 4 THEN tmpMI_detail.AmountPackAllTotal_diff
                            WHEN 4 >= 5 AND tmpMI_detail.Amount = 4 THEN tmpMI_detail.AmountPackAllTotal_diff  
                            ELSE 0
                       END) ::TFloat AS AmountPack5
                 ----
                , MIN (CASE WHEN 4 < 5 AND tmpMI_detail.Amount = 1 THEN tmpMI_detail.InsertDate
                            WHEN 4 >= 5 AND tmpMI_detail.Amount <= 4-4 THEN tmpMI_detail.InsertDate 
                            ELSE NULL
                       END) :: TDateTime AS InsertDate1
                , MIN (CASE WHEN 4 < 5 AND tmpMI_detail.Amount = 2 THEN tmpMI_detail.InsertDate
                            WHEN 4 >= 5 AND tmpMI_detail.Amount = 4-3 THEN tmpMI_detail.InsertDate  
                            ELSE NULL
                       END) :: TDateTime AS InsertDate2       
                , MIN (CASE WHEN 4 < 5 AND tmpMI_detail.Amount = 3 THEN tmpMI_detail.InsertDate
                            WHEN 4 >= 5 AND tmpMI_detail.Amount = 4-2 THEN tmpMI_detail.InsertDate  
                            ELSE NULL
                       END) :: TDateTime AS InsertDate3
                , MIN (CASE WHEN 4 < 5 AND tmpMI_detail.Amount = 4 THEN tmpMI_detail.InsertDate
                            WHEN 4 >= 5 AND tmpMI_detail.Amount = 4-1 THEN tmpMI_detail.InsertDate 
                            ELSE NULL
                       END) :: TDateTime AS InsertDate4
                , MIN (CASE WHEN 4 <= 5 AND tmpMI_detail.Amount = 5 THEN tmpMI_detail.InsertDate
                            WHEN 4 >= 5 AND tmpMI_detail.Amount = 4 THEN tmpMI_detail.InsertDate  
                            ELSE NULL
                       END) :: TDateTime AS InsertDate5 


           FROM tmpRez
                INNER JOIN tmpMI_detail ON tmpMI_detail.ParentId = tmpRez.MovementItemId_child

           GROUP BY tmpRez.GoodsId
                , tmpRez.GoodsCode
                , tmpRez.GoodsName
                , tmpRez.GoodsId_basis
                , tmpRez.GoodsCode_basis
                , tmpRez.GoodsName_basis
                , tmpRez.GoodsKindId
                , tmpRez.GoodsKindName
                , tmpRez.MeasureName
                , tmpRez.MeasureName_basis
                , tmpRez.GoodsGroupNameFull
                , tmpRez.Weight 
                , tmpRez.Weight_Child
                  -- ПРИОРИТЕТ
                , tmpRez.Num
                
                , tmpRez.GoodsId_Child
                , tmpRez.GoodsCode_Child
                , tmpRez.GoodsName_Child
                , tmpRez.GoodsKindName_Child
                , tmpRez.MeasureName_Child
                , tmpRez.MeasureId_Child

                  -- План+План2 для упаковки (ИТОГО, факт)
                , tmpRez.AmountPackAllTotal_Child   
                , tmpRez.AmountPackAllTotal_Child_Sh
                
                  -- ИТОГО по Child - ФАКТ - Перемещение на Цех Упаковки
                --, tmpRez.Income_PACK_to
                  -- ИТОГО по Child - ФАКТ - Перемещение с Цеха Упаковки
                --, tmpRez.Income_PACK_from ::TFloat

                  -- ФАКТ - Перемещение на Цех Упаковки
                , tmpRez.Income_PACK_to_Child
                  -- ФАКТ - Перемещение с Цеха Упаковки
                , tmpRez.Income_PACK_from_Child 
      
, tmpRez.KeyId
, tmpRez.Income_PACK_to 

    )      
    
select KeyId
                 , tmpRez.GoodsId
                , tmpRez.GoodsCode
                , tmpRez.GoodsName
                    --       , tmpRez.GoodsKindId
                , tmpRez.GoodsKindName
         
  
                , tmpRez.GoodsGroupNameFull

                  -- ПРИОРИТЕТ
                , tmpRez.Num
                
                , tmpRez.GoodsId_Child
                , tmpRez.GoodsCode_Child
                , tmpRez.GoodsName_Child
                , tmpRez.GoodsKindName_Child
          
                  -- План+План2 для упаковки (ИТОГО, факт)
                , tmpRez.AmountPackAllTotal_Child      ::TFloat
                , tmpRez.AmountPackAllTotal_Child_Sh   ::TFloat
                
                   -- ФАКТ - Перемещение на Цех Упаковки
                , tmpRez.Income_PACK_to_Child    ::TFloat       --***
                  -- ФАКТ - Перемещение с Цеха Упаковки         
                , tmpRez.Income_PACK_from_Child  ::TFloat       --***
                , tmpRez.Income_PACK_to    ::TFloat    

                , AmountPackAll
                ,  AmountPack1
                , AmountPack2       
                , AmountPack3
                , AmountPack4
                , AmountPack5
                 ----
                ,  InsertDate1
                , InsertDate2       
                , InsertDate3
                ,  InsertDate4
                , InsertDate5 
 from tmpRez_Detail as tmpRez
where tmpRez.GoodsId = 5244

*/