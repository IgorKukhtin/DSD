-- Function: gpSelect_Movement_OrderInternalPackRemains_DetailsPrint()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternalPackRemains_DetailsPrint (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderInternalPackRemains_DetailsPrint(
    IN inMovementId    Integer  , -- ключ Документа
    IN inSession       TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id                   Integer
             --, KeyId                TVarChar
             , GoodsId              Integer
             , GoodsCode            Integer
             , GoodsName            TVarChar

             , GoodsId_complete        Integer
             , GoodsCode_complete      Integer
             , GoodsName_complete      TVarChar

             , GoodsKindId          Integer
             , GoodsKindName        TVarChar
             , GoodsKindName_complete TVarChar

             , MeasureName          TVarChar
             , MeasureName_complete    TVarChar
             , GoodsGroupNameFull   TVarChar

             , Weight               TFloat

             , Num                  Integer

             , AmountPack1_all     TFloat
             , AmountPack2_all     TFloat
             , AmountPack3_all     TFloat
             , AmountPack4_all     TFloat
             , AmountPack5_all     TFloat
             , AmountPackTotal_All TFloat
 
             , AmountPack1     TFloat
             , AmountPack2     TFloat
             , AmountPack3     TFloat
             , AmountPack4     TFloat
             , AmountPack5     TFloat
             , AmountPackTotal TFloat

             , AmountPack1_Sh  TFloat
             , AmountPack2_Sh  TFloat
             , AmountPack3_Sh  TFloat
             , AmountPack4_Sh  TFloat
             , AmountPack5_Sh  TFloat
             , AmountPackTotal_Sh TFloat  

             , InsertDate1 TVarChar
             , InsertDate2 TVarChar
             , InsertDate3 TVarChar
             , InsertDate4 TVarChar
             , InsertDate5 TVarChar  
             
             , Income_PACK_to TFloat
             , Income_PACK_from TFloat   
             , Income_PACK_toAll TFloat
             , Income_PACK_fromAll TFloat
                
             )
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbOperDate TDateTime;
    DECLARE vbMaxAmount TFloat;
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

     --количество операций
     vbMaxAmount := (SELECT Max(MovementItem.Amount) FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Detail());

      -- Результат
      RETURN QUERY
     WITH
     tmpMI_master AS (SELECT MovementItem.Id                                       
                           , COALESCE (MIFloat_ContainerId.ValueData, 0)           AS ContainerId

                           , Object_Goods.Id                     AS GoodsId
                           , Object_Goods.ObjectCode             AS GoodsCode
                           , Object_Goods.ValueData              AS GoodsName
                
                           , Object_Goods_complete.Id            AS GoodsId_complete
                           , Object_Goods_complete.ObjectCode    AS GoodsCode_complete
                           , Object_Goods_complete.ValueData     AS GoodsName_complete
                
                           , Object_Goods_basis.Id               AS GoodsId_basis
                           , Object_Goods_basis.ObjectCode       AS GoodsCode_basis
                           , Object_Goods_basis.ValueData        AS GoodsName_basis
                
                           , Object_GoodsKind.Id                 AS GoodsKindId
                           , Object_GoodsKind.ValueData          AS GoodsKindName
                           , Object_GoodsKind_complete.Id        AS GoodsKindId_complete
                           , Object_GoodsKind_complete.ValueData AS GoodsKindName_complete
                
                           , Object_Measure.Id                   AS MeasureId
                           , Object_Measure.ValueData            AS MeasureName
                           , Object_Measure_complete.ValueData   AS MeasureName_complete
                           , Object_Measure_basis.ValueData      AS MeasureName_basis 
                           
                           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                           
                           , COALESCE (MovementItem.Amount,0)
                           + COALESCE (MIFloat_AmountSecond.ValueData,0)
                           + COALESCE (MIFloat_AmountNext.ValueData,0)
                           + COALESCE (MIFloat_AmountNextSecond.ValueData,0) AS AmountTotal
                      FROM MovementItem

                            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                        ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                            --
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsBasis
                                                             ON MILinkObject_GoodsBasis.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsBasis.DescId         = zc_MILinkObject_GoodsBasis()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsComplete
                                                             ON MILinkObject_GoodsComplete.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsComplete.DescId         = zc_MILinkObject_Goods()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                             ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKindComplete.DescId         = zc_MILinkObject_GoodsKindComplete()

                            LEFT JOIN Object AS Object_Goods              ON Object_Goods.Id          = MovementItem.ObjectId
                            LEFT JOIN Object AS Object_Goods_complete     ON Object_Goods_complete.Id = COALESCE (MILinkObject_GoodsComplete.ObjectId, 0)
                            LEFT JOIN Object AS Object_Goods_basis        ON Object_Goods_basis.Id    = COALESCE (MILinkObject_GoodsBasis.ObjectId, 0) 
                
                            LEFT JOIN Object AS Object_GoodsKind          ON Object_GoodsKind.Id          = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                            LEFT JOIN Object AS Object_GoodsKind_complete ON Object_GoodsKind_complete.Id = COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0)
                
                            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods_complete.Id
                                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                
                                
                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_complete
                                                 ON ObjectLink_Goods_Measure_complete.ObjectId = Object_Goods_complete.Id
                                                AND ObjectLink_Goods_Measure_complete.DescId   = zc_ObjectLink_Goods_Measure()
                            LEFT JOIN Object AS Object_Measure_complete ON Object_Measure_complete.Id = ObjectLink_Goods_Measure_complete.ChildObjectId
                
                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_basis
                                                 ON ObjectLink_Goods_Measure_basis.ObjectId = Object_Goods_basis.Id
                                                AND ObjectLink_Goods_Measure_basis.DescId   = zc_ObjectLink_Goods_Measure()
                            LEFT JOIN Object AS Object_Measure_basis ON Object_Measure_basis.Id = ObjectLink_Goods_Measure_basis.ChildObjectId

                            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountNext
                                                        ON MIFloat_AmountNext.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountNext.DescId = zc_MIFloat_AmountNext()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountNextSecond
                                                        ON MIFloat_AmountNextSecond.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountNextSecond.DescId = zc_MIFloat_AmountNextSecond()

                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                     )


   , tmpMI_detail AS (SELECT MovementItem.Id                   AS MovementItemId
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
   , tmpMI_detail_2 AS (SELECT tmpMI_detail.ParentId
                             , tmpMI_detail.Amount
                             , MIN (COALESCE (tmpMI_detail.UpdateDate, tmpMI_detail.InsertDate)) AS InsertDate

                             , SUM (COALESCE (tmpMI_detail.AmountPackAllTotal, 0)) AS AmountPackAllTotal 
                             , SUM ( COALESCE (tmpMI_detail.AmountPackAllTotal, 0) - COALESCE (tmpMI_detail_old.AmountPackAllTotal,0)) ::TFloat AS AmountPackAllTotal_diff                             
                        FROM tmpMI_detail
                             LEFT JOIN tmpMI_detail AS tmpMI_detail_old ON tmpMI_detail_old.ParentId = tmpMI_detail.ParentId
                                                                       AND tmpMI_detail_old.Amount   = tmpMI_detail.Amount - 1
                        GROUP BY tmpMI_detail.ParentId
                               , tmpMI_detail.Amount
                        )

   , tmpMI_detail_3 AS (SELECT tmpMI_detail.ParentId
                             --, MIN(tmpMI_detail.InsertDate) InsertDate
                             , SUM (tmpMI_detail.AmountPackAllTotal) AS AmountPackAllTotal
                             , SUM (tmpMI_detail.AmountPackAllTotal_diff) AS AmountPackAll
                             , SUM (CASE WHEN vbMaxAmount < 5 AND tmpMI_detail.Amount = 1 THEN tmpMI_detail.AmountPackAllTotal
                                         WHEN vbMaxAmount >= 5 AND tmpMI_detail.Amount <= vbMaxAmount-4 THEN tmpMI_detail.AmountPackAllTotal_diff  
                                         ELSE 0
                                    END) AS AmountPack1
                             , SUM (CASE WHEN vbMaxAmount < 5 AND tmpMI_detail.Amount = 2 THEN tmpMI_detail.AmountPackAllTotal_diff
                                         WHEN vbMaxAmount >= 5 AND tmpMI_detail.Amount = vbMaxAmount-3 THEN tmpMI_detail.AmountPackAllTotal_diff  
                                         ELSE 0
                                    END) AS AmountPack2       
                             , SUM (CASE WHEN vbMaxAmount < 5 AND tmpMI_detail.Amount = 2 THEN tmpMI_detail.AmountPackAllTotal_diff
                                         WHEN vbMaxAmount >= 5 AND tmpMI_detail.Amount = vbMaxAmount-2 THEN tmpMI_detail.AmountPackAllTotal_diff  
                                         ELSE 0
                                    END) AS AmountPack3
                             , SUM (CASE WHEN vbMaxAmount < 5 AND tmpMI_detail.Amount = 3 THEN tmpMI_detail.AmountPackAllTotal_diff
                                         WHEN vbMaxAmount >= 5 AND tmpMI_detail.Amount = vbMaxAmount-1 THEN tmpMI_detail.AmountPackAllTotal_diff  
                                         ELSE 0
                                    END) AS AmountPack4
                             , SUM (CASE WHEN vbMaxAmount < 5 AND tmpMI_detail.Amount = 4 THEN tmpMI_detail.AmountPackAllTotal_diff
                                         WHEN vbMaxAmount >= 5 AND tmpMI_detail.Amount = vbMaxAmount THEN tmpMI_detail.AmountPackAllTotal_diff  
                                         ELSE 0
                                    END) AS AmountPack5
                              ----
                             , MIN (CASE WHEN vbMaxAmount < 5 AND tmpMI_detail.Amount = 1 THEN tmpMI_detail.InsertDate
                                         WHEN vbMaxAmount >= 5 AND tmpMI_detail.Amount <= vbMaxAmount-4 THEN tmpMI_detail.InsertDate 
                                         ELSE NULL
                                    END) AS InsertDate1
                             , MIN (CASE WHEN vbMaxAmount < 5 AND tmpMI_detail.Amount = 2 THEN tmpMI_detail.InsertDate
                                         WHEN vbMaxAmount >= 5 AND tmpMI_detail.Amount = vbMaxAmount-3 THEN tmpMI_detail.InsertDate  
                                         ELSE NULL
                                    END) AS InsertDate2       
                             , MIN (CASE WHEN vbMaxAmount < 5 AND tmpMI_detail.Amount = 2 THEN tmpMI_detail.InsertDate
                                         WHEN vbMaxAmount >= 5 AND tmpMI_detail.Amount = vbMaxAmount-2 THEN tmpMI_detail.InsertDate  
                                         ELSE NULL
                                    END) AS InsertDate3
                             , MIN (CASE WHEN vbMaxAmount < 5 AND tmpMI_detail.Amount = 3 THEN tmpMI_detail.InsertDate
                                         WHEN vbMaxAmount >= 5 AND tmpMI_detail.Amount = vbMaxAmount-1 THEN tmpMI_detail.InsertDate 
                                         ELSE NULL
                                    END) AS InsertDate4
                             , MIN (CASE WHEN vbMaxAmount < 5 AND tmpMI_detail.Amount = 4 THEN tmpMI_detail.InsertDate
                                         WHEN vbMaxAmount >= 5 AND tmpMI_detail.Amount = vbMaxAmount THEN tmpMI_detail.InsertDate  
                                         ELSE NULL
                                    END) AS InsertDate5 
                        FROM tmpMI_detail_2 AS tmpMI_detail
                        GROUP BY tmpMI_detail.ParentId
                        )

             -- хардкодим - Склады База + Реализации + Склад Поклейки этикетки
           , tmpUnit_SKLAD AS (SELECT UnitId, FALSE AS isContainer FROM lfSelect_Object_Unit_byGroup (8457) AS lfSelect_Object_Unit_byGroup
                              UNION
                               SELECT 9073781 AS UnitId, FALSE AS isContainer
                              )
            -- хардкодим - Цех Упаковки
           , tmpUnit_PACK  AS (SELECT 8451 AS UnitId)
             -- Приход - с Цеха Упаковки
           , tmpPACK AS (SELECT MIContainer.ObjectId_Analyzer                    AS GoodsId
                                , COALESCE (MIContainer.ObjectIntId_Analyzer, 0) AS GoodsKindId
                                , SUM (CASE WHEN MIContainer.isActive = TRUE  THEN      MIContainer.Amount ELSE 0 END) AS Amount_to
                                , SUM (CASE WHEN MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) AS Amount_from
                                , MIContainer.WhereObjectId_Analyzer             AS UnitId_pf
                           FROM MovementItemContainer AS MIContainer
                                -- Склады База + Реализации
                                INNER JOIN tmpUnit_SKLAD   ON tmpUnit_SKLAD.UnitId   = MIContainer.ObjectExtId_Analyzer
                                -- Цех Упаковки
                                INNER JOIN tmpUnit_PACK ON tmpUnit_PACK.UnitId = MIContainer.WhereObjectId_Analyzer
                                -- убрали Тару
                                INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                      ON ObjectLink_Goods_InfoMoney.ObjectId      = MIContainer.ObjectId_Analyzer
                                                     AND ObjectLink_Goods_InfoMoney.DescId        = zc_ObjectLink_Goods_InfoMoney()
                                                     AND ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                                    , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                                    , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                                                     )
                           WHERE MIContainer.OperDate       = vbOperDate
                             AND MIContainer.DescId         = zc_MIContainer_Count()
                             AND MIContainer.MovementDescId = zc_Movement_Send()
                             -- AND MIContainer.isActive       = FALSE
                             AND MIContainer.Amount <> 0
                             -- AND 1=0
                           GROUP BY MIContainer.ObjectId_Analyzer
                                  , MIContainer.ObjectIntId_Analyzer
                                  , MIContainer.WhereObjectId_Analyzer
                          )

           , tmpLpSelect AS (SELECT _Result_Master.Id
                                  , _Result_Master.Income_PACK_to
                                  , ( COALESCE (_Result_Child.AmountPack,0) 
                                    + COALESCE (_Result_Child.AmountPackSecond,0) 
                                    + COALESCE (_Result_Child.AmountPackNext,0) 
                                    + COALESCE (_Result_Child.AmountPackNextSecond,0)) AS AmountPack
                             FROM _Result_Master
                                  LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                                ON MIBoolean_Calculated.MovementItemId = _Result_Master.Id
                                                               AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                                  LEFT JOIN Object ON Object.Id = COALESCE (_Result_Master.GoodsKindId, zc_GoodsKind_Basis())
                                  LEFT JOIN (SELECT _Result_Child.KeyId
                                                  , SUM (_Result_Child.AmountPack)                AS AmountPack
                                                  , SUM (_Result_Child.AmountPackSecond)          AS AmountPackSecond
                       
                                                  , SUM (_Result_Child.AmountPackNext)            AS AmountPackNext
                                                  , SUM (_Result_Child.AmountPackNextSecond)      AS AmountPackNextSecond
                       
                                             FROM _Result_Child
                                             GROUP BY _Result_Child.KeyId
                                            ) AS _Result_Child ON _Result_Child.KeyId = _Result_Master.KeyId
                     
)
           -- Результат
           SELECT tmpMI_master.Id
                --, tmpMI_master.KeyId
                , tmpMI_master.GoodsId, tmpMI_master.GoodsCode, tmpMI_master.GoodsName
                , tmpMI_master.GoodsId_complete, tmpMI_master.GoodsCode_complete, tmpMI_master.GoodsName_complete
                , tmpMI_master.GoodsKindId, tmpMI_master.GoodsKindName, tmpMI_master.GoodsKindName_complete
                , tmpMI_master.MeasureName, tmpMI_master.MeasureName_complete
                , tmpMI_master.GoodsGroupNameFull

                , COALESCE (ObjectFloat_Weight.ValueData, 0) :: TFloat AS Weight

                  -- ПРИОРИТЕТ
                , 0 /*tmpMI_detail.Ord*/ ::Integer AS Num   

                , SUM (COALESCE (tmpMI_detail.AmountPack1,0)) OVER (PARTITION BY tmpMI_master.GoodsId_complete) ::TFloat  AS AmountPack1_all
                , SUM (COALESCE (tmpMI_detail.AmountPack2,0)) OVER (PARTITION BY tmpMI_master.GoodsId_complete) ::TFloat  AS AmountPack2_all
                , SUM (COALESCE (tmpMI_detail.AmountPack3,0)) OVER (PARTITION BY tmpMI_master.GoodsId_complete) ::TFloat  AS AmountPack3_all
                , SUM (COALESCE (tmpMI_detail.AmountPack4,0)) OVER (PARTITION BY tmpMI_master.GoodsId_complete) ::TFloat  AS AmountPack4_all
                , SUM (COALESCE (tmpMI_detail.AmountPack5,0)) OVER (PARTITION BY tmpMI_master.GoodsId_complete) ::TFloat  AS AmountPack5_all
                , SUM (COALESCE (tmpMI_detail.AmountPackAll,0)) OVER (PARTITION BY tmpMI_master.GoodsId_complete) ::TFloat  AS AmountPackTotal_All
                
                , tmpMI_detail.AmountPack1  ::TFloat
                , tmpMI_detail.AmountPack2  ::TFloat
                , tmpMI_detail.AmountPack3  ::TFloat
                , tmpMI_detail.AmountPack4  ::TFloat
                , tmpMI_detail.AmountPack5  ::TFloat

                , (COALESCE (tmpMI_detail.AmountPack1,0)
                 + COALESCE (tmpMI_detail.AmountPack2,0)
                 + COALESCE (tmpMI_detail.AmountPack3,0)
                 + COALESCE (tmpMI_detail.AmountPack4,0)
                 + COALESCE (tmpMI_detail.AmountPack5,0))  ::TFloat AS AmountPackTotal
                
                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND tmpMI_master.MeasureId = zc_Measure_Sh() THEN (tmpMI_detail.AmountPack1 / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountPack1_Sh
                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND tmpMI_master.MeasureId = zc_Measure_Sh() THEN (tmpMI_detail.AmountPack2 / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountPack2_Sh
                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND tmpMI_master.MeasureId = zc_Measure_Sh() THEN (tmpMI_detail.AmountPack3 / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountPack3_Sh
                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND tmpMI_master.MeasureId = zc_Measure_Sh() THEN (tmpMI_detail.AmountPack4 / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountPack4_Sh
                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND tmpMI_master.MeasureId = zc_Measure_Sh() THEN (tmpMI_detail.AmountPack5 / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountPack5_Sh

                , CASE WHEN ObjectFloat_Weight.ValueData > 0 AND tmpMI_master.MeasureId = zc_Measure_Sh() THEN ((COALESCE (tmpMI_detail.AmountPack1,0)
                                                                                                               + COALESCE (tmpMI_detail.AmountPack2,0)
                                                                                                               + COALESCE (tmpMI_detail.AmountPack3,0)
                                                                                                               + COALESCE (tmpMI_detail.AmountPack4,0)
                                                                                                               + COALESCE (tmpMI_detail.AmountPack5,0)) / ObjectFloat_Weight.ValueData) :: Integer ELSE 0 END :: TFloat AS AmountPackTotal_Sh
                
                
                , (zfConvert_TimeShortToString ( MAX (tmpMI_detail.InsertDate1) OVER (ORDER BY tmpMI_detail.AmountPack1 DESC)) ::TVarChar 
                  ||' (' ||CASE WHEN vbMaxAmount <= 5 THEN '1)' WHEN vbMaxAmount > 5 THEN '1-'|| (vbMaxAmount - 4)::integer ||')' ELSE ')' END) ::TVarChar  AS InsertDate1
                , (zfConvert_TimeShortToString ( MAX (tmpMI_detail.InsertDate2) OVER (ORDER BY tmpMI_detail.AmountPack1 DESC)) ::TVarChar
                  ||' (' ||CASE WHEN vbMaxAmount <= 5 THEN '2)' WHEN vbMaxAmount > 5 THEN ''|| (vbMaxAmount - 3)::integer ||')' ELSE ')' END) ::TVarChar  AS InsertDate2
                , (zfConvert_TimeShortToString ( MAX (tmpMI_detail.InsertDate3) OVER (ORDER BY tmpMI_detail.AmountPack1 DESC)) ::TVarChar 
                  ||' (' ||CASE WHEN vbMaxAmount <= 5 THEN '3)' WHEN vbMaxAmount > 5 THEN ''|| (vbMaxAmount - 2)::integer ||')' ELSE ')' END) ::TVarChar  AS InsertDate3
                , (zfConvert_TimeShortToString ( MAX (tmpMI_detail.InsertDate4) OVER (ORDER BY tmpMI_detail.AmountPack1 DESC)) ::TVarChar  
                  ||' (' ||CASE WHEN vbMaxAmount <= 5 THEN '4)' WHEN vbMaxAmount > 5 THEN ''|| (vbMaxAmount - 1)::integer ||')' ELSE ')' END) ::TVarChar  AS InsertDate4
                , (zfConvert_TimeShortToString ( MAX (tmpMI_detail.InsertDate5) OVER (ORDER BY tmpMI_detail.AmountPack1 DESC)) ::TVarChar                 
                  ||' (' ||CASE WHEN vbMaxAmount <= 5 THEN '5)' WHEN vbMaxAmount > 5 THEN ''|| (vbMaxAmount)::integer ||')' ELSE ')' END) ::TVarChar      AS InsertDate5 
                  

                --, (tmpPACK.Amount_to   * CASE WHEN tmpMI_master.MeasureId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) ::TFloat AS Income_PACK_to
                --, (tmpPACK.Amount_from * CASE WHEN tmpMI_master.MeasureId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) ::TFloat AS Income_PACK_from
                , 0 ::TFloat AS Income_PACK_to
                , 0 ::TFloat AS Income_PACK_from
                --, (tmpPACK.Amount_from * CASE WHEN tmpMI_master.MeasureId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) ::TFloat AS Income_PACK_from 

                
                , (tmpPACK.Amount_to   * CASE WHEN tmpMI_master.MeasureId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) ::TFloat AS Income_PACK_toAll
                , tmpFrom.AmountTotal  ::TFloat AS Income_PACK_fromAll
           FROM tmpMI_detail_3 AS tmpMI_detail
              LEFT JOIN tmpMI_master ON tmpMI_master.Id = tmpMI_detail.ParentId

              LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                    ON ObjectFloat_Weight.ObjectId = tmpMI_master.GoodsId
                                   AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

              LEFT JOIN tmpPACK ON tmpPACK.GoodsId = tmpMI_master.GoodsId_complete
                               AND tmpPACK.GoodsKindId = tmpMI_master.GoodsKindId_complete 
            
              LEFT JOIN (SELECT tmpMI_master.GoodsId, tmpMI_master.GoodsKindId, SUM (tmpMI_master.AmountTotal) AS AmountTotal
                         FROM tmpMI_master
                         GROUP BY tmpMI_master.GoodsId, tmpMI_master.GoodsKindId) AS tmpFrom ON tmpFrom.GoodsId = tmpMI_master.GoodsId_complete
                                                                                            AND tmpFrom.GoodsKindId = tmpMI_master.GoodsKindId_complete
                
           WHERE COALESCE (tmpMI_detail.AmountPack1, 0) <> 0
              OR COALESCE (tmpMI_detail.AmountPack2, 0) <> 0
              OR COALESCE (tmpMI_detail.AmountPack3, 0) <> 0
              OR COALESCE (tmpMI_detail.AmountPack4, 0) <> 0
              OR COALESCE (tmpMI_detail.AmountPack5, 0) <> 0
          ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.04.23         *
*/

-- тест
-- select * from gpSelect_Movement_OrderInternalPackRemains_DetailsPrint(inMovementId := 24933183 ,  inSession := '9457');