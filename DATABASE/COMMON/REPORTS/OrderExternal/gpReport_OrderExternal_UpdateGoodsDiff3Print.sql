-- Function: gpReport_OrderExternal_UpdateGoodsDiffPrint()

--DROP FUNCTION IF EXISTS gpReport_OrderExternal_UpdateGoodsDiff3Print (TDateTime, TDateTime, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_OrderExternal_UpdateGoodsDiff3Print (TDateTime, TDateTime, Boolean, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderExternal_UpdateGoodsDiff3Print(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsDate_CarInfo    Boolean   , -- по  дате  Дата/время отгрузки
    IN inisSub             Boolean   ,
    IN inToId              Integer   , -- Кому (в документе)
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , GoodsCode_sub Integer, GoodsName_sub TVarChar, GoodsKindName_sub  TVarChar
             , DayOfWeekName_CarInfo TVarChar
             , OperDate_CarInfo_date TDateTime
             , Count_Partner Integer
             , GroupPrint Integer

             , Amount_sh                 TFloat
             , AmountWeight              TFloat
             , AmountWeight1             TFloat
             , AmountWeight2             TFloat
             , AmountWeight3             TFloat

               -- Резервы, вес
             , AmountWeight_child_one    TFloat
             , AmountWeight_child_sec    TFloat
             , AmountWeight_child        TFloat
               -- Итого не хватает для резерва, вес
             , AmountWeight_diff         TFloat

             , AmountSh_child_one    TFloat
             , AmountSh_child_sec    TFloat
             , AmountSh_child        TFloat
             , AmountSh_diff         TFloat           


             , Amount_remains_min_Weight TFloat
             , Amount_remains_max_Weight TFloat
             , Amount_remains_min_Sh TFloat
             , Amount_remains_max_Sh TFloat
             
             , OperDate_CarInfo1         TVarChar
             , OperDate_CarInfo2         TVarChar
             , OperDate_CarInfo3         TVarChar
 
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
   DECLARE inGoodsGroupId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- !!!временно
     inGoodsGroupId:= 1832; -- ГП

     inIsDate_CarInfo:= TRUE;
     inEndDate:= inStartDate + INTERVAL'3 Day' ;


     vbStartDate := (inStartDate::Date ||' 8:00') :: TDateTime;
     vbEndDate   := ((inStartDate + INTERVAL'3 Day' )::Date||' 7:59') :: TDateTime;

     -- Результат
     CREATE TEMP TABLE _Result (GoodsId Integer, GoodsKindId Integer, Amount_sh TFloat, AmountWeight TFloat
                              , AmountWeight_child_one TFloat, AmountWeight_child_sec TFloat, AmountWeight_child TFloat, AmountWeight_diff TFloat
                              , AmountSh_child_one TFloat, AmountSh_child_sec TFloat, AmountSh_child TFloat, AmountSh_diff TFloat
                              , Amount_remains_min_Weight TFloat, Amount_remains_max_Weight TFloat
                              , Amount_remains_min_Sh TFloat, Amount_remains_max_Sh TFloat
                              , Count_Partner TFloat
                              , OperDate_CarInfo TDateTime, OperDate_CarInfo_date TDateTime
                              , GroupPrint Integer, Ord Integer
                               ) ON COMMIT DROP;
     --
     WITH
       -- Только эти товары
       tmpGoods AS (SELECT lfSelect.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect)
       -- Документы - Заказ
     , tmpMovementAll AS (SELECT Movement.*
                               , MovementLinkObject_To.ObjectId AS ToId
                               , COALESCE (MovementBoolean_Remains.ValueData, FALSE) AS isRemains

                          FROM (SELECT Movement.*
                                       -- Дата/время отгрузки
                                     , COALESCE (MovementDate_CarInfo.ValueData, MovementDate_OperDatePartner.ValueData) AS OperDate_CarInfo
                                       -- Дата смены
                                     , CASE WHEN EXTRACT (HOUR FROM COALESCE (MovementDate_CarInfo.ValueData, MovementDate_OperDatePartner.ValueData)) < 8 THEN DATE_TRUNC ('DAY', COALESCE (MovementDate_CarInfo.ValueData, MovementDate_OperDatePartner.ValueData)) - INTERVAL '1 DAY'
                                            ELSE DATE_TRUNC ('DAY', COALESCE (MovementDate_CarInfo.ValueData, MovementDate_OperDatePartner.ValueData))
                                       END  AS OperDate_CarInfo_date
                                FROM Movement
                                     LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                            ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                           AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                                     LEFT JOIN MovementDate AS MovementDate_CarInfo
                                                            ON MovementDate_CarInfo.MovementId = Movement.Id
                                                           AND MovementDate_CarInfo.DescId = zc_MovementDate_CarInfo()
                                WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                                  AND Movement.DescId = zc_Movement_OrderExternal()
                                  AND inIsDate_CarInfo = FALSE
                               UNION
                                SELECT Movement.*
                                       -- Дата/время отгрузки
                                     , MovementDate_CarInfo.ValueData AS OperDate_CarInfo
                                       -- Дата смены
                                     , CASE WHEN EXTRACT (HOUR FROM MovementDate_CarInfo.ValueData) < 8 THEN DATE_TRUNC ('DAY', MovementDate_CarInfo.ValueData) - INTERVAL '1 DAY'
                                            ELSE DATE_TRUNC ('DAY', MovementDate_CarInfo.ValueData)
                                       END AS OperDate_CarInfo_date
                                FROM MovementDate AS MovementDate_CarInfo
                                     INNER JOIN Movement ON Movement.Id       = MovementDate_CarInfo.MovementId
                                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                                                        AND Movement.DescId   = zc_Movement_OrderExternal()
                                WHERE MovementDate_CarInfo.DescId = zc_MovementDate_CarInfo()
                                  AND MovementDate_CarInfo.ValueData BETWEEN vbStartDate AND vbEndDate
                                  AND inIsDate_CarInfo = TRUE
                               ) AS Movement
                               INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                                            AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                            AND MovementLinkObject_To.ObjectId   = inToId
                               LEFT JOIN MovementBoolean AS MovementBoolean_Remains
                                                         ON MovementBoolean_Remains.MovementId = Movement.Id
                                                        AND MovementBoolean_Remains.DescId     = zc_MovementBoolean_Remains()
                         )
       -- группа для печати
     , tmpGroupPrint AS (SELECT -- Дата смены
                                tmp.OperDate_CarInfo_date
                              , ROW_NUMBER() OVER (ORDER BY tmp.OperDate_CarInfo_date ASC) AS GroupPrint
                         FROM (SELECT DISTINCT tmpMovementAll.OperDate_CarInfo_date FROM tmpMovementAll
                              ) AS tmp
                        )

              -- Сортировка № п/п
         , tmpNPP AS (SELECT -- Дата/время отгрузки
                             tmp.OperDate_CarInfo
                             -- Дата смены
                           , tmp.OperDate_CarInfo_date
                             -- № п/п
                           , ROW_NUMBER() OVER (PARTITION BY tmp.OperDate_CarInfo_date ORDER BY tmp.OperDate_CarInfo ASC) AS Ord
                      FROM (SELECT DISTINCT tmpMovementAll.OperDate_CarInfo , tmpMovementAll.OperDate_CarInfo_date FROM tmpMovementAll
                           ) AS tmp
                     )
       -- Заказы
     , tmpMI AS (SELECT MovementItem.*
                 FROM MovementItem
                 WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovementAll.Id FROM tmpMovementAll)
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.isErased   = FALSE
                   -- Только эти товары
                   AND MovementItem.ObjectId   IN (SELECT DISTINCT tmpGoods.GoodsId FROM tmpGoods)
                )
     , tmpMovementItemFloat AS (SELECT MovementItemFloat.*
                                FROM MovementItemFloat
                                WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                  AND MovementItemFloat.DescId = zc_MIFloat_AmountSecond()
                               )
     , tmpMovementItemLinkObject AS (SELECT MovementItemLinkObject.*
                                     FROM MovementItemLinkObject
                                     WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                       AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                                     )
       -- Резервы
     , tmpMIChild AS (SELECT MovementItem.*
                      FROM MovementItem
                      WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovementAll.Id FROM tmpMovementAll)
                        AND MovementItem.DescId     = zc_MI_Child()
                        AND MovementItem.isErased   = FALSE
                     )
       -- Резервы - св-ва
     , tmpMIFloat_Child AS (SELECT MovementItemFloat.*
                            FROM MovementItemFloat
                            WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMIChild.Id FROM tmpMIChild)
                              AND MovementItemFloat.DescId IN (zc_MIFloat_MovementId()
                                                             , zc_MIFloat_Remains()
                                                              )
                           )
       -- Резервы - все
     , tmpChild AS (SELECT MovementItem.ParentId
                          --
                         , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) = 0 THEN MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END ELSE 0 END) AS Amount_Weight
                         , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) > 0 THEN MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END ELSE 0 END) AS AmountSecond_Weight
                         , SUM (MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Amount_all_Weight

                         , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) = 0 THEN MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END ELSE 0 END) AS Amount_sh
                         , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) > 0 THEN MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END ELSE 0 END) AS AmountSecond_sh
                         , SUM (MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END) AS Amount_all_sh
                          --
                         , MIN (COALESCE (MIFloat_Remains.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Amount_remains_min_Weight
                         , MAX (COALESCE (MIFloat_Remains.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Amount_remains_max_Weight

                         , MIN (COALESCE (MIFloat_Remains.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END) AS Amount_remains_min_Sh
                         , MAX (COALESCE (MIFloat_Remains.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END) AS Amount_remains_max_Sh

                    FROM tmpMIChild AS MovementItem
                         LEFT JOIN tmpMIFloat_Child AS MIFloat_MovementId
                                                    ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                   AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                         LEFT JOIN tmpMIFloat_Child AS MIFloat_Remains
                                                    ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                                   AND MIFloat_Remains.DescId = zc_MIFloat_Remains()
                         LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                              ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                             AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                         LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                               ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                              AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                    GROUP BY MovementItem.ParentId
                   )
       -- Заказы + Резервы
     , tmpMovement AS (SELECT MovementItem.ObjectId AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId

                            , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END AS Amount_sh
                              -- Заказы
                            , ((COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))
                             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                              ) AS AmountWeight
                              -- Резервы
                            ,  (tmpMI_Child.Amount_Weight)       AS AmountWeight_child_one -- с Остатка
                            ,  (tmpMI_Child.AmountSecond_Weight) AS AmountWeight_child_sec -- с Прихода
                            ,  (tmpMI_Child.Amount_all_Weight)   AS AmountWeight_child     -- Итого

                            ,  (tmpMI_Child.Amount_sh)       AS AmountSh_child_one -- с Остатка
                            ,  (tmpMI_Child.AmountSecond_sh) AS AmountSh_child_sec -- с Прихода
                            ,  (tmpMI_Child.Amount_all_sh)   AS AmountSh_child     -- Итого
                            
                              -- Итого не хватает для резерва, вес
                            , (CASE WHEN Movement.isRemains = TRUE
                                        THEN (COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))
                                           * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                                           - COALESCE (tmpMI_Child.Amount_all_Weight, 0)
                                        ELSE 0
                               END) AS AmountWeight_diff

                            , (CASE WHEN Movement.isRemains = TRUE
                                        THEN (COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))
                                           * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END
                                           - COALESCE (tmpMI_Child.Amount_all_sh, 0)
                                        ELSE 0
                               END) AS AmountSh_diff

                              -- мин Остаток начальный для резерва
                            , tmpMI_Child.Amount_remains_min_Weight
                              -- макс Остаток начальный для резерва
                            , tmpMI_Child.Amount_remains_max_Weight

                              -- мин Остаток начальный для резерва
                            , tmpMI_Child.Amount_remains_min_Sh
                              -- макс Остаток начальный для резерва
                            , tmpMI_Child.Amount_remains_max_Sh

                            , MovementLinkObject_From.ObjectId AS FromId

                              -- Дата/время отгрузки
                            , Movement.OperDate_CarInfo
                              -- Дата смены
                            , Movement.OperDate_CarInfo_date
                              -- группа для печати
                            , tmpGroupPrint.GroupPrint
                              -- Сортировка № п/п
                            , tmpNPP.Ord

                       FROM tmpMovementAll AS Movement
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()

                            LEFT JOIN tmpGroupPrint ON tmpGroupPrint.OperDate_CarInfo_date = Movement.OperDate_CarInfo_date
                            LEFT JOIN tmpNPP        ON tmpNPP.OperDate_CarInfo             = Movement.OperDate_CarInfo

                            -- Заказы
                            INNER JOIN tmpMI AS MovementItem  ON MovementItem.MovementId = Movement.Id
                            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountSecond
                                                           ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                          AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()

                            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                  ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                            -- Резервы
                            LEFT JOIN tmpChild AS tmpMI_Child ON tmpMI_Child.ParentId = MovementItem.Id

                      )

     , tmpMov AS (SELECT tmpMovement.GoodsId
                       , tmpMovement.GoodsKindId
                       , SUM (tmpMovement.Amount_sh)              AS Amount_sh
                       , SUM (tmpMovement.AmountWeight)           AS AmountWeight
                       , SUM (tmpMovement.AmountWeight_child_one) AS AmountWeight_child_one
                       , SUM (tmpMovement.AmountWeight_child_sec) AS AmountWeight_child_sec
                       , SUM (tmpMovement.AmountWeight_child)     AS AmountWeight_child
                       , SUM (tmpMovement.AmountWeight_diff)      AS AmountWeight_diff

                       , SUM (tmpMovement.AmountSh_child_one) AS AmountSh_child_one
                       , SUM (tmpMovement.AmountSh_child_sec) AS AmountSh_child_sec
                       , SUM (tmpMovement.AmountSh_child)     AS AmountSh_child
                       , SUM (tmpMovement.AmountSh_diff)      AS AmountSh_diff

                       , MIN (tmpMovement.Amount_remains_min_Weight) AS Amount_remains_min_Weight
                       , MAX (tmpMovement.Amount_remains_max_Weight) AS Amount_remains_max_Weight
                       , MIN (tmpMovement.Amount_remains_min_Sh)     AS Amount_remains_min_Sh
                       , MAX (tmpMovement.Amount_remains_max_Sh)     AS Amount_remains_max_Sh
                         --
                       , COUNT (DISTINCT tmpMovement.FromId) AS Count_Partner
                         -- Дата/время отгрузки
                       , tmpMovement.OperDate_CarInfo
                         -- Дата смены
                       , tmpMovement.OperDate_CarInfo_date
                         -- группа для печати
                       , tmpMovement.GroupPrint
                         --
                       , tmpMovement.Ord
                  FROM tmpMovement
                  GROUP BY tmpMovement.GoodsId
                         , tmpMovement.GoodsKindId
                         , tmpMovement.OperDate_CarInfo
                         , tmpMovement.OperDate_CarInfo_date
                         , tmpMovement.GroupPrint
                         , tmpMovement.Ord
                --  HAVING SUM (tmpMovement.AmountSh_diff) <> 0
                  --    OR SUM (tmpMovement.AmountWeight_diff)  <> 0
                 )
      -- Результат
     INSERT INTO _Result (GoodsId, GoodsKindId, Amount_sh, AmountWeight
                        , AmountWeight_child_one, AmountWeight_child_sec, AmountWeight_child, AmountWeight_diff
                        , AmountSh_child_one, AmountSh_child_sec, AmountSh_child, AmountSh_diff
                        , Amount_remains_min_Weight, Amount_remains_max_Weight 
                        , Amount_remains_min_Sh, Amount_remains_max_Sh
                        , Count_Partner, OperDate_CarInfo, OperDate_CarInfo_date, GroupPrint, Ord)
        SELECT tmpMovement.GoodsId, tmpMovement.GoodsKindId
             , tmpMovement.Amount_sh
             , tmpMovement.AmountWeight
             , tmpMovement.AmountWeight_child_one, tmpMovement.AmountWeight_child_sec, tmpMovement.AmountWeight_child, tmpMovement.AmountWeight_diff
             , tmpMovement.AmountSh_child_one, tmpMovement.AmountSh_child_sec, tmpMovement.AmountSh_child, tmpMovement.AmountSh_diff
             , tmpMovement.Amount_remains_min_Weight, tmpMovement.Amount_remains_max_Weight 
             , tmpMovement.Amount_remains_min_Sh, tmpMovement.Amount_remains_max_Sh
             , tmpMovement.Count_Partner
             , tmpMovement.OperDate_CarInfo
             , tmpMovement.OperDate_CarInfo_date
             , tmpMovement.GroupPrint
             , tmpMovement.Ord
        FROM tmpMov AS tmpMovement
        -- !!!если есть заказ!!!
        WHERE tmpMovement.AmountWeight_diff <> 0
       ;

     -- Результат
     RETURN QUERY
     WITH
       tmpGroup AS (SELECT tmp.GoodsId
                         , tmp.GoodsKindId
                         , tmp.GroupPrint
                         , tmp.OperDate_CarInfo_date

                         , MIN (tmp.Ord)             AS Ord
                         , SUM (tmp.Count_Partner)   AS Count_Partner

                         , SUM (tmp.AmountWeight)    AS AmountWeight
                         , SUM (tmp.Amount_sh)       AS Amount_sh

                         , SUM (tmp.AmountWeight1)   AS AmountWeight1
                         , SUM (tmp.AmountWeight2)   AS AmountWeight2
                         , SUM (tmp.AmountWeight3)   AS AmountWeight3

                         , SUM (tmp.AmountWeight_child_one)  AS AmountWeight_child_one
                         , SUM (tmp.AmountWeight_child_sec)  AS AmountWeight_child_sec
                         , SUM (tmp.AmountWeight_child)      AS AmountWeight_child
                         , SUM (tmp.AmountWeight_diff)       AS AmountWeight_diff

                         , SUM (tmp.AmountSh_child_one)  AS AmountSh_child_one
                         , SUM (tmp.AmountSh_child_sec)  AS AmountSh_child_sec
                         , SUM (tmp.AmountSh_child)      AS AmountSh_child
                         , SUM (tmp.AmountSh_diff)       AS AmountSh_diff

                         , MIN (tmp.Amount_remains_min_Weight) AS Amount_remains_min_Weight
                         , MAX (tmp.Amount_remains_max_Weight) AS Amount_remains_max_Weight
                         , MIN (tmp.Amount_remains_min_Sh) AS Amount_remains_min_Sh
                         , MAX (tmp.Amount_remains_max_Sh) AS Amount_remains_max_Sh
                    FROM (SELECT _Result.GoodsId
                               , _Result.GoodsKindId
                               , _Result.OperDate_CarInfo_date
                               , _Result.GroupPrint
                               , _Result.Ord
                               , _Result.Count_Partner

                               , _Result.AmountWeight
                               , _Result.Amount_sh
                               , CASE WHEN _Result.OperDate_CarInfo_date = inStartDate                    THEN _Result.AmountWeight_diff ELSE 0 END  AS AmountWeight1
                               , CASE WHEN _Result.OperDate_CarInfo_date = inStartDate + INTERVAL '1 Day' THEN _Result.AmountWeight_diff ELSE 0 END  AS AmountWeight2
                               , CASE WHEN _Result.OperDate_CarInfo_date = inStartDate + INTERVAL '2 Day' THEN _Result.AmountWeight_diff ELSE 0 END  AS AmountWeight3

                               , _Result.AmountWeight_child_one
                               , _Result.AmountWeight_child_sec
                               , _Result.AmountWeight_child
                               , _Result.AmountWeight_diff

                               , _Result.AmountSh_child_one
                               , _Result.AmountSh_child_sec
                               , _Result.AmountSh_child
                               , _Result.AmountSh_diff

                               , _Result.Amount_remains_min_Weight
                               , _Result.Amount_remains_max_Weight  
                               , _Result.Amount_remains_min_Sh
                               , _Result.Amount_remains_max_Sh
                          FROM  _Result
                         ) AS tmp
                    GROUP BY tmp.GoodsId
                           , tmp.GoodsKindId
                           , tmp.GroupPrint
                           , tmp.OperDate_CarInfo_date
                   )


         , tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                        , Object_GoodsByGoodsKind_View.GoodsKindId
                                        , ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId      AS GoodsId_sub
                                        , ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId  AS GoodsKindId_sub
                                   FROM Object_GoodsByGoodsKind_View
                                        LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsSub
                                                             ON ObjectLink_GoodsByGoodsKind_GoodsSub.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                            AND ObjectLink_GoodsByGoodsKind_GoodsSub.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsSub()
                                        LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindSub
                                                             ON ObjectLink_GoodsByGoodsKind_GoodsKindSub.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                            AND ObjectLink_GoodsByGoodsKind_GoodsKindSub.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub()
                                   WHERE ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId     > 0
                                     AND ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId > 0
                                     AND Object_GoodsByGoodsKind_View.GoodsId IN (SELECT DISTINCT tmpGroup.GoodsId FROM tmpGroup)
                                  )


       SELECT Object_Goods.Id                               AS GoodsId
            , Object_Goods.ObjectCode                       AS GoodsCode
            , Object_Goods.ValueData                        AS GoodsName
            , Object_GoodsKind.Id                           AS GoodsKindId
            , Object_GoodsKind.ValueData                    AS GoodsKindName
            , ObjectString_Goods_GroupNameFull.ValueData    AS GoodsGroupNameFull
            , Object_Measure.ValueData                      AS MeasureName

            , Object_Goods_sub.ObjectCode      :: Integer   AS GoodsCode_sub
            , Object_Goods_sub.ValueData       :: TVarChar  AS GoodsName_sub
            , Object_GoodsKind_sub.ValueData   :: TVarChar  AS GoodsKindName_sub

            , tmpWeekDay.DayOfWeekName_Full    :: TVarChar  AS DayOfWeekName_CarInfo
            , tmpGroup.OperDate_CarInfo_date   :: TDateTime AS OperDate_CarInfo_date
            , tmpGroup.Count_Partner           :: Integer   AS Count_Partner
            , tmpGroup.GroupPrint              :: Integer   AS GroupPrint

            , tmpGroup.Amount_sh               :: TFloat
            , tmpGroup.AmountWeight            :: TFloat
            , tmpGroup.AmountWeight1           :: TFloat
            , tmpGroup.AmountWeight2           :: TFloat
            , tmpGroup.AmountWeight3           :: TFloat

            , tmpGroup.AmountWeight_child_one  :: TFloat
            , tmpGroup.AmountWeight_child_sec  :: TFloat
            , tmpGroup.AmountWeight_child      :: TFloat
            , tmpGroup.AmountWeight_diff       :: TFloat

            , tmpGroup.AmountSh_child_one      :: TFloat
            , tmpGroup.AmountSh_child_sec      :: TFloat
            , tmpGroup.AmountSh_child          :: TFloat
            , tmpGroup.AmountSh_diff           :: TFloat

            , tmpGroup.Amount_remains_min_Weight   :: TFloat
            , tmpGroup.Amount_remains_max_Weight   :: TFloat
            , tmpGroup.Amount_remains_min_Sh   :: TFloat
            , tmpGroup.Amount_remains_max_Sh   :: TFloat
            
            , zfConvert_DateShortToString (tmpGroup.OperDate_CarInfo_date)                    AS OperDate_CarInfo1
            , zfConvert_DateShortToString (tmpGroup.OperDate_CarInfo_date + INTERVAL '1 Day') AS OperDate_CarInfo2
            , zfConvert_DateShortToString (tmpGroup.OperDate_CarInfo_date + INTERVAL '2 Day') AS OperDate_CarInfo3

       FROM tmpGroup
          LEFT JOIN zfCalc_DayOfWeekName (tmpGroup.OperDate_CarInfo_date) AS tmpWeekDay ON 1=1

          LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId     = tmpGroup.GoodsId
                                       AND tmpGoodsByGoodsKind.GoodsKindId = tmpGroup.GoodsKindId

          LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = CASE WHEN inisSub = TRUE THEN COALESCE (tmpGoodsByGoodsKind.GoodsId_sub, tmpGroup.GoodsId) ELSE tmpGroup.GoodsId END
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = CASE WHEN inisSub = TRUE THEN COALESCE (tmpGoodsByGoodsKind.GoodsKindId_sub, tmpGroup.GoodsKindId) ELSE tmpGroup.GoodsKindId END 

          LEFT JOIN Object AS Object_Goods_sub     ON Object_Goods_sub.Id     = tmpGoodsByGoodsKind.GoodsId_sub
          LEFT JOIN Object AS Object_GoodsKind_sub ON Object_GoodsKind_sub.Id = tmpGoodsByGoodsKind.GoodsKindId_sub

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

       ORDER BY tmpGroup.GroupPrint
              , tmpGroup.Ord
              , ObjectString_Goods_GroupNameFull.ValueData
              , Object_Goods.ValueData
              , Object_GoodsKind.ValueData
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.07.22         *
*/

-- тест
-- SELECT * FROM gpReport_OrderExternal_UpdateGoodsDiff3Print (inStartDate:= '05.07.2022', inEndDate:= '28.06.2022', inIsDate_CarInfo:= FALSE, inisSub:= FALSE, inToId := 8459, inSession := '5') WHERE GoodsCode IN (306, 163)
