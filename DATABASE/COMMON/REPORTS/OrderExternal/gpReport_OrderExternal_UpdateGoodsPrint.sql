-- Function: gpReport_OrderExternal_UpdateGoodsPrint()

--DROP FUNCTION IF EXISTS gpReport_OrderExternal_UpdateGoodsPrint (TDateTime, TDateTime, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_OrderExternal_UpdateGoodsPrint (TDateTime, TDateTime, Boolean, Boolean, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_OrderExternal_UpdateGoodsPrint(
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
             , Ord Integer

             , Amount_sh                 TFloat
             , AmountWeight              TFloat      --не хватает для резерва
             , AmountWeight1             TFloat      --не хватает для резерва
             , AmountWeight2             TFloat
             , AmountWeight3             TFloat
             , AmountWeight4             TFloat
             , AmountWeight5             TFloat
             , AmountWeight6             TFloat
             , AmountWeight7             TFloat
             , AmountWeight8             TFloat
             , AmountWeight9             TFloat
             , AmountWeight10            TFloat
             , AmountWeight11            TFloat
             , AmountWeight12            TFloat
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
             , OperDate_CarInfo4         TVarChar
             , OperDate_CarInfo5         TVarChar
             , OperDate_CarInfo6         TVarChar
             , OperDate_CarInfo7         TVarChar
             , OperDate_CarInfo8         TVarChar
             , OperDate_CarInfo9         TVarChar
             , OperDate_CarInfo10        TVarChar
             , OperDate_CarInfo11        TVarChar
             , OperDate_CarInfo12        TVarChar
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
     inEndDate:= inStartDate;


     vbStartDate := (inStartDate::Date ||' 8:00') :: TDateTime;
     vbEndDate   := ((inStartDate + INTERVAL'1 Day' )::Date||' 7:59') :: TDateTime;

     -- Результат
     CREATE TEMP TABLE _Result (GoodsId Integer, GoodsKindId Integer, Amount_sh TFloat, AmountWeight TFloat
                              , AmountWeight_child_one TFloat, AmountWeight_child_sec TFloat, AmountWeight_child TFloat, AmountWeight_diff TFloat
                              , AmountSh_child_one TFloat, AmountSh_child_sec TFloat, AmountSh_child TFloat, AmountSh_diff TFloat
                              , Amount_remains_min_Weight TFloat, Amount_remains_max_Weight TFloat
                              , Amount_remains_min_Sh TFloat, Amount_remains_max_Sh TFloat
                              , Count_Partner TFloat
                              , OperDate_CarInfo TDateTime, OperDate_CarInfo_date TDateTime
                              , GroupPrint Integer, Ord Integer, OperDate_inf Text
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
                                  --AND Movement.OperDate <= CURRENT_DATE + INTERVAL '1 DAY'
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
            -- группа
          , tmpRoute AS (SELECT tmp.OperDate_CarInfo
                            --, STRING_AGG (tmp.RouteName, '; ' ) AS RouteName
                              , STRING_AGG (tmp.RouteName, CHR (13)) AS RouteName
                         FROM (SELECT DISTINCT
                                      tmpMovementAll.OperDate_CarInfo
                                    , COALESCE (Object_Route.ValueData, Object_Retail.ValueData, Object_Juridical.ValueData) AS RouteName
                               FROM tmpMovementAll
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = tmpMovementAll.Id
                                                                AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                    LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                         ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                        AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                    LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
                                    LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                         ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                        AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                                    LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                                                 ON MovementLinkObject_Route.MovementId = tmpMovementAll.Id
                                                                AND MovementLinkObject_Route.DescId     = zc_MovementLinkObject_Route()
                                    LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId
                              ) AS tmp
                         GROUP BY tmp.OperDate_CarInfo
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
                           -- Элемент заявки не удален
                           INNER JOIN tmpMI AS MovementItem_parent
                                            ON MovementItem_parent.MovementId = MovementItem.MovementId
                                           AND MovementItem_parent.DescId     = zc_MI_Master()
                                           AND MovementItem_parent.Id         = MovementItem.ParentId
                                           AND MovementItem_parent.isErased   = FALSE
                      WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovementAll.Id FROM tmpMovementAll)
                        AND MovementItem.DescId     = zc_MI_Child()
                        AND MovementItem.isErased   = FALSE
                        AND MovementItem.Amount     > 0
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
                       --, SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) = 0 THEN MovementItem.Amount ELSE 0 END) AS Amount
                       --, SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) > 0 THEN MovementItem.Amount ELSE 0 END) AS AmountSecond
                       --, SUM (MovementItem.Amount) AS Amount_all
                           --
                         , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) = 0 THEN MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END ELSE 0 END) AS Amount_Weight
                         , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) > 0 THEN MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END ELSE 0 END) AS AmountSecond_Weight
                         , SUM (MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Amount_all_Weight

                         , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) = 0 THEN MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END ELSE 0 END) AS Amount_sh
                         , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) > 0 THEN MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END ELSE 0 END) AS AmountSecond_sh
                         , SUM (MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END) AS Amount_all_sh

                           --
                       --, MIN (COALESCE (MIFloat_Remains.ValueData, 0)) AS Amount_remains_min
                       --, MAX (COALESCE (MIFloat_Remains.ValueData, 0)) AS Amount_remains_max
                           --
                         , MIN (COALESCE (MIFloat_Remains.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Amount_remains_min_Weight
                         , MAX (COALESCE (MIFloat_Remains.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Amount_remains_max_Weight 

                         , MIN (COALESCE (MIFloat_Remains.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END) AS Amount_remains_min_Sh
                         , MAX (COALESCE (MIFloat_Remains.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END) AS Amount_remains_max_Sh

                         , MAX (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN zc_Measure_Sh()              ELSE 0 END) AS MeasureId_isSh
                         , MAX (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 0 END) AS Weight_isSh

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
       -- Заказ + Резерв - в одну строчку
     , tmpMovement AS (SELECT MovementItem.ObjectId AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId
                              -- Заказ - шт
                            , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                   -- если пересорт и резерв есть хоть один = шт а заявка = кг, тогда нужно информативно шт
                                   WHEN ObjectLink_Goods_Measure.ChildObjectId <> zc_Measure_Sh() AND tmpMI_Child.MeasureId_isSh = zc_Measure_Sh()
                                        AND tmpMI_Child.Weight_isSh > 0

                                        THEN (COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))
                                              -- !!!вес из Резерва!!!
                                           / tmpMI_Child.Weight_isSh
                                   ELSE 0
                              END AS Amount_sh
                              -- Заказ - кг
                            , ((COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))
                             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                              ) AS AmountWeight

                              -- Резерв
                            , (tmpMI_Child.Amount_Weight)       AS AmountWeight_child_one -- с Остатка
                            , (tmpMI_Child.AmountSecond_Weight) AS AmountWeight_child_sec -- с Прихода
                            , (tmpMI_Child.Amount_all_Weight)   AS AmountWeight_child     -- Итого

                            , (tmpMI_Child.Amount_sh)       AS AmountSh_child_one -- с Остатка
                            , (tmpMI_Child.AmountSecond_sh) AS AmountSh_child_sec -- с Прихода 
                              -- Итого - если пересорт и резерв = кг а заявка = шт, тогда нужно пересчитать резерв в шт
                            , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND COALESCE (tmpMI_Child.MeasureId_isSh, 0) <> zc_Measure_Sh()
                                   THEN CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,0) <> 0
                                             THEN tmpMI_Child.Amount_all_Weight / ObjectFloat_Weight.ValueData  
                                             ELSE 0
                                             END
                                   ELSE COALESCE (tmpMI_Child.Amount_all_sh,0)
                              END  AS AmountSh_child

                              -- Итого не хватает для резерва, вес
                            , (CASE WHEN Movement.isRemains = TRUE
                                        THEN (COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))
                                           * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                                           - COALESCE (tmpMI_Child.Amount_all_Weight, 0)
                                        ELSE 0
                               END) AS AmountWeight_diff

                              -- Итого не хватает для резерва, шт
                            , (CASE WHEN Movement.isRemains = TRUE
                                         -- если пересорт и резерв есть хоть один = шт а заявка = кг, тогда нужно получить шт
                                     AND ObjectLink_Goods_Measure.ChildObjectId <> zc_Measure_Sh() AND tmpMI_Child.MeasureId_isSh = zc_Measure_Sh()
                                     AND tmpMI_Child.Weight_isSh > 0
                                         THEN (COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))
                                              -- !!!вес из Резерва!!!
                                            / tmpMI_Child.Weight_isSh
                                              -- если пересорт и резерв = кг а заявка = шт, тогда нужно пересчитать резерв в шт
                                            - COALESCE (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND COALESCE (tmpMI_Child.MeasureId_isSh, 0) <> zc_Measure_Sh()
                                                             THEN CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,0) <> 0
                                                                       THEN tmpMI_Child.Amount_all_Weight / ObjectFloat_Weight.ValueData 
                                                                       ELSE 0
                                                                       END
                                                             ELSE COALESCE (tmpMI_Child.Amount_all_sh,0)
                                                        END, 0)

                                    WHEN Movement.isRemains = TRUE
                                    THEN (COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))
                                       * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END
                                         -- если пересорт и резерв = кг а заявка = шт, тогда нужно пересчитать резерв в шт
                                       - COALESCE (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND COALESCE (tmpMI_Child.MeasureId_isSh, 0) <> zc_Measure_Sh()
                                                        THEN CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,0) <> 0
                                                                  THEN tmpMI_Child.Amount_all_Weight / ObjectFloat_Weight.ValueData 
                                                                  ELSE 0
                                                                  END
                                                        ELSE COALESCE (tmpMI_Child.Amount_all_sh,0)
                                                   END, 0)
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

                              -- !!!Информация в названии колонки!!!
                            , (CASE WHEN EXTRACT (DAY   FROM Movement.OperDate_CarInfo) < 10 THEN '0' ELSE '' END || EXTRACT (DAY   FROM Movement.OperDate_CarInfo) :: TVarChar
                     || '.' || CASE WHEN EXTRACT (MONTH FROM Movement.OperDate_CarInfo) < 10 THEN '0' ELSE '' END || EXTRACT (MONTH FROM Movement.OperDate_CarInfo) :: TVarChar

                  ||CHR (13)|| zfConvert_TimeShortToString (Movement.OperDate_CarInfo)
                  ||CHR (13)|| tmpRoute.RouteName
                              ) AS OperDate_inf

                       FROM tmpMovementAll AS Movement
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()

                            LEFT JOIN tmpGroupPrint ON tmpGroupPrint.OperDate_CarInfo_date = Movement.OperDate_CarInfo_date
                            LEFT JOIN tmpNPP        ON tmpNPP.OperDate_CarInfo             = Movement.OperDate_CarInfo
                            LEFT JOIN tmpRoute      ON tmpRoute.OperDate_CarInfo           = Movement.OperDate_CarInfo

                            -- Заказ
                            INNER JOIN tmpMI AS MovementItem  ON MovementItem.MovementId = Movement.Id
                            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountSecond
                                                           ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                          AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()

                            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                            -- Заказ
                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                  ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                 AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                            -- Резерв
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
                       , tmpMovement.OperDate_inf
                         --
                       , tmpMovement.Ord
                  FROM tmpMovement
                  GROUP BY tmpMovement.GoodsId
                         , tmpMovement.GoodsKindId
                         , tmpMovement.OperDate_CarInfo
                         , tmpMovement.OperDate_CarInfo_date
                         , tmpMovement.GroupPrint
                         , tmpMovement.OperDate_inf
                         , tmpMovement.Ord
                 )
      -- Результат
     INSERT INTO _Result (GoodsId, GoodsKindId, Amount_sh, AmountWeight
                        , AmountWeight_child_one, AmountWeight_child_sec, AmountWeight_child, AmountWeight_diff  
                        , AmountSh_child_one, AmountSh_child_sec, AmountSh_child, AmountSh_diff
                        , Amount_remains_min_Weight, Amount_remains_max_Weight
                        , Amount_remains_min_Sh, Amount_remains_max_Sh
                        , Count_Partner, OperDate_CarInfo, OperDate_CarInfo_date, GroupPrint, Ord, OperDate_inf)
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
             , tmpMovement.OperDate_inf :: Text AS OperDate_inf
        FROM tmpMov AS tmpMovement
        -- !!!если есть заказ!!!
        WHERE tmpMovement.Amount_sh    <> 0
           OR tmpMovement.AmountWeight <> 0
       ;

     -- Результат
     RETURN QUERY
     WITH
       tmpColumn AS (SELECT tmp.GroupPrint
                          , MAX (tmp.OperDate_CarInfo1) AS OperDate_CarInfo1
                          , MAX (tmp.OperDate_CarInfo2) AS OperDate_CarInfo2
                          , MAX (tmp.OperDate_CarInfo3) AS OperDate_CarInfo3
                          , MAX (tmp.OperDate_CarInfo4) AS OperDate_CarInfo4
                          , MAX (tmp.OperDate_CarInfo5) AS OperDate_CarInfo5
                          , MAX (tmp.OperDate_CarInfo6) AS OperDate_CarInfo6
                          , MAX (tmp.OperDate_CarInfo7) AS OperDate_CarInfo7
                          , MAX (tmp.OperDate_CarInfo8) AS OperDate_CarInfo8
                          , MAX (tmp.OperDate_CarInfo9) AS OperDate_CarInfo9
                          , MAX (tmp.OperDate_CarInfo10) AS OperDate_CarInfo10
                          , MAX (tmp.OperDate_CarInfo11) AS OperDate_CarInfo11
                          , MAX (tmp.OperDate_CarInfo12) AS OperDate_CarInfo12
                     FROM (SELECT _Result.GroupPrint
                                , CASE WHEN _Result.Ord = 1  THEN _Result.OperDate_inf ELSE Null END ::TVarChar AS OperDate_CarInfo1
                                , CASE WHEN _Result.Ord = 2  THEN _Result.OperDate_inf ELSE Null END ::TVarChar AS OperDate_CarInfo2
                                , CASE WHEN _Result.Ord = 3  THEN _Result.OperDate_inf ELSE Null END ::TVarChar AS OperDate_CarInfo3
                                , CASE WHEN _Result.Ord = 4  THEN _Result.OperDate_inf ELSE Null END ::TVarChar AS OperDate_CarInfo4
                                , CASE WHEN _Result.Ord = 5  THEN _Result.OperDate_inf ELSE Null END ::TVarChar AS OperDate_CarInfo5
                                , CASE WHEN _Result.Ord = 6  THEN _Result.OperDate_inf ELSE Null END ::TVarChar AS OperDate_CarInfo6
                                , CASE WHEN _Result.Ord = 7  THEN _Result.OperDate_inf ELSE Null END ::TVarChar AS OperDate_CarInfo7
                                , CASE WHEN _Result.Ord = 8  THEN _Result.OperDate_inf ELSE Null END ::TVarChar AS OperDate_CarInfo8
                                , CASE WHEN _Result.Ord = 9  THEN _Result.OperDate_inf ELSE Null END ::TVarChar AS OperDate_CarInfo9
                                , CASE WHEN _Result.Ord = 10 THEN _Result.OperDate_inf ELSE Null END ::TVarChar AS OperDate_CarInfo10
                                , CASE WHEN _Result.Ord = 11 THEN _Result.OperDate_inf ELSE Null END ::TVarChar AS OperDate_CarInfo11
                                , CASE WHEN _Result.Ord = 12 THEN _Result.OperDate_inf ELSE Null END ::TVarChar AS OperDate_CarInfo12
                             FROM _Result
                             )AS tmp
                     GROUP BY tmp.GroupPrint
                    )

     , tmpGroup AS (SELECT tmp.GoodsId
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
                         , SUM (tmp.AmountWeight4)   AS AmountWeight4
                         , SUM (tmp.AmountWeight5)   AS AmountWeight5
                         , SUM (tmp.AmountWeight6)   AS AmountWeight6
                         , SUM (tmp.AmountWeight7)   AS AmountWeight7
                         , SUM (tmp.AmountWeight8)   AS AmountWeight8
                         , SUM (tmp.AmountWeight9)   AS AmountWeight9
                         , SUM (tmp.AmountWeight10)  AS AmountWeight10
                         , SUM (tmp.AmountWeight11)  AS AmountWeight11
                         , SUM (tmp.AmountWeight12)  AS AmountWeight12

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
                               , CASE WHEN _Result.Ord = 1  THEN _Result.AmountWeight ELSE 0 END  AS AmountWeight1
                               , CASE WHEN _Result.Ord = 2  THEN _Result.AmountWeight ELSE 0 END  AS AmountWeight2
                               , CASE WHEN _Result.Ord = 3  THEN _Result.AmountWeight ELSE 0 END  AS AmountWeight3
                               , CASE WHEN _Result.Ord = 4  THEN _Result.AmountWeight ELSE 0 END  AS AmountWeight4
                               , CASE WHEN _Result.Ord = 5  THEN _Result.AmountWeight ELSE 0 END  AS AmountWeight5
                               , CASE WHEN _Result.Ord = 6  THEN _Result.AmountWeight ELSE 0 END  AS AmountWeight6
                               , CASE WHEN _Result.Ord = 7  THEN _Result.AmountWeight ELSE 0 END  AS AmountWeight7
                               , CASE WHEN _Result.Ord = 8  THEN _Result.AmountWeight ELSE 0 END  AS AmountWeight8
                               , CASE WHEN _Result.Ord = 9  THEN _Result.AmountWeight ELSE 0 END  AS AmountWeight9
                               , CASE WHEN _Result.Ord = 10 THEN _Result.AmountWeight ELSE 0 END  AS AmountWeight10
                               , CASE WHEN _Result.Ord = 11 THEN _Result.AmountWeight ELSE 0 END  AS AmountWeight11
                               , CASE WHEN _Result.Ord = 12 THEN _Result.AmountWeight ELSE 0 END  AS AmountWeight12

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

            , Object_Goods_sub.ObjectCode                AS GoodsCode_sub
            , Object_Goods_sub.ValueData                 AS GoodsName_sub
            , Object_GoodsKind_sub.ValueData             AS GoodsKindName_sub

            , tmpWeekDay.DayOfWeekName_Full    :: TVarChar  AS DayOfWeekName_CarInfo
            , tmpGroup.OperDate_CarInfo_date   :: TDateTime AS OperDate_CarInfo_date
            , tmpGroup.Count_Partner           :: Integer   AS Count_Partner
            , tmpColumn.GroupPrint             :: Integer   AS GroupPrint
          --, tmpGroup.Ord                     :: Integer   AS Ord
            , 0                                :: Integer   AS Ord

            , CAST (tmpGroup.Amount_sh AS NUMERIC (16, 0)) :: TFloat
            , tmpGroup.AmountWeight            :: TFloat
            , tmpGroup.AmountWeight1           :: TFloat
            , tmpGroup.AmountWeight2           :: TFloat
            , tmpGroup.AmountWeight3           :: TFloat
            , tmpGroup.AmountWeight4           :: TFloat
            , tmpGroup.AmountWeight5           :: TFloat
            , tmpGroup.AmountWeight6           :: TFloat
            , tmpGroup.AmountWeight7           :: TFloat
            , tmpGroup.AmountWeight8           :: TFloat
            , tmpGroup.AmountWeight9           :: TFloat
            , tmpGroup.AmountWeight10          :: TFloat
            , tmpGroup.AmountWeight11          :: TFloat
            , tmpGroup.AmountWeight12          :: TFloat

            , tmpGroup.AmountWeight_child_one  :: TFloat
            , tmpGroup.AmountWeight_child_sec  :: TFloat
            , tmpGroup.AmountWeight_child      :: TFloat
            , tmpGroup.AmountWeight_diff       :: TFloat

            , CAST (tmpGroup.AmountSh_child_one AS NUMERIC (16, 0)) :: TFloat
            , CAST (tmpGroup.AmountSh_child_sec AS NUMERIC (16, 0)) :: TFloat
            , CAST (tmpGroup.AmountSh_child     AS NUMERIC (16, 0)) :: TFloat                                           
            , CAST (tmpGroup.AmountSh_diff      AS NUMERIC (16, 0)) :: TFloat

            , tmpGroup.Amount_remains_min_Weight   :: TFloat
            , tmpGroup.Amount_remains_max_Weight   :: TFloat

            , tmpGroup.Amount_remains_min_Sh   :: TFloat
            , tmpGroup.Amount_remains_max_Sh   :: TFloat

            , tmpColumn.OperDate_CarInfo1      :: TVarChar
            , tmpColumn.OperDate_CarInfo2      :: TVarChar
            , tmpColumn.OperDate_CarInfo3      :: TVarChar
            , tmpColumn.OperDate_CarInfo4      :: TVarChar
            , tmpColumn.OperDate_CarInfo5      :: TVarChar
            , tmpColumn.OperDate_CarInfo6      :: TVarChar
            , tmpColumn.OperDate_CarInfo7      :: TVarChar
            , tmpColumn.OperDate_CarInfo8      :: TVarChar
            , tmpColumn.OperDate_CarInfo9      :: TVarChar
            , tmpColumn.OperDate_CarInfo10     :: TVarChar
            , tmpColumn.OperDate_CarInfo11     :: TVarChar
            , tmpColumn.OperDate_CarInfo12     :: TVarChar

       FROM tmpGroup
            LEFT JOIN tmpColumn ON tmpColumn.GroupPrint = tmpGroup.GroupPrint

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
 01.07.22         *
*/

-- тест
-- SELECT * FROM gpReport_OrderExternal_UpdateGoodsPrint (inStartDate:= '05.07.2022', inEndDate:= '28.06.2022', inIsDate_CarInfo:= FALSE, inisSub:= FALSE, inToId := 8459, inSession := '5') WHERE GoodsCode IN (306, 163)
