-- Function: gpReport_OrderExternal_Update()

DROP FUNCTION IF EXISTS gpReport_OrderExternal_Update (TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_OrderExternal_Update (TDateTime, TDateTime, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_OrderExternal_Update (TDateTime, TDateTime, Boolean, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderExternal_Update(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsDate_CarInfo    Boolean   , -- по дате  Дата/время отгрузки
    IN inIsGoods           Boolean   , -- по товарам - блок предактирования
    IN inToId              Integer   , -- Кому (в документе)
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate        TDateTime
             , OperDatePartner TDateTime
             , RouteId Integer, RouteName TVarChar
             , RetailId Integer, RetailName TVarChar
             , PartnerTagName TVarChar
             , OperDate_CarInfo TDateTime, OperDate_CarInfo_date TDateTime, OperDate_CarInfo_str TVarChar
             , CarInfoId Integer, CarInfoName TVarChar, CarComment TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindName  TVarChar, GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , GoodsId_sub Integer, GoodsCode_sub Integer, GoodsName_sub TVarChar, GoodsKindName_sub  TVarChar, MeasureName_sub TVarChar

               -- Заказы
             , AmountSh TFloat
             , AmountWeight TFloat
               --
             , Count_Partner TFloat
             , Count_Doc TFloat
             , isRemains Boolean
             , Count_Partner_str TVarChar
             , Days Integer, Times TVarChar

             , DayOfWeekName              TVarChar
             , DayOfWeekName_Partner      TVarChar
             , DayOfWeekName_CarInfo      TVarChar
             , DayOfWeekName_CarInfo_date TVarChar

             , StartWeighing        TDateTime
             , EndWeighing          TDateTime
             , DayOfWeekName_StartW TVarChar
             , DayOfWeekName_EndW   TVarChar
             , Hours_EndW           Integer
             , Hours_real           Integer

               -- Резервы, вес
             , AmountWeight_child_one TFloat
             , AmountWeight_child_sec TFloat
             , AmountWeight_child     TFloat
               -- Итого не хватает для резерва, вес
             , AmountWeight_diff      TFloat

               -- Резервы, шт
             , AmountSh_child_one   TFloat
             , AmountSh_child_sec   TFloat
             , AmountSh_child       TFloat
             , AmountSh_diff        TFloat
           
               -- Резервы - пересорт, вес
             , AmountWeight_sub_child_one TFloat -- с Остатка
             , AmountWeight_sub_child_sec TFloat -- с Прихода
             , AmountWeight_sub_child     TFloat -- Итого

               -- Резервы - пересорт, шт
             , AmountSh_sub_child_one     TFloat -- с Остатка
             , AmountSh_sub_child_sec     TFloat -- с Прихода
             , AmountSh_sub_child         TFloat -- Итого

               --
             , OperDate_CarInfo_calc      TDateTime
             , DayOfWeekName_CarInfo_calc TVarChar
             , Min_calc                   Integer
             , Id_calc                    Integer

             , Ord Integer
             , DayOfWeekName_CarInfo_all_1 TVarChar
             , DayOfWeekName_CarInfo_all_2 TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
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
     

     -- Результат
     RETURN QUERY
     WITH
       -- Только эти товары
       tmpGoods AS (SELECT lfSelect.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect)
       -- Документы - Заказ
     , tmpMovementAll AS (SELECT Movement.*
                               , MovementLinkObject_To.ObjectId AS ToId
                               , COALESCE (MovementBoolean_Remains.ValueData, FALSE) AS isRemains
                          FROM (SELECT Movement.*
                                       -- Дата/время отгрузки
                                     , MovementDate_CarInfo.ValueData AS OperDate_CarInfo
                                       -- Дата смены
                                     , CASE WHEN EXTRACT (HOUR FROM MovementDate_CarInfo.ValueData) < 8 THEN DATE_TRUNC ('DAY', MovementDate_CarInfo.ValueData) - INTERVAL '1 DAY'
                                            ELSE DATE_TRUNC ('DAY', MovementDate_CarInfo.ValueData)
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
                                     , Movement.OperDate AS OperDate_CarInfo
                                       -- Дата смены
                                     , Movement.OperDate AS OperDate_CarInfo_date
                                FROM Movement
                                     LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                            ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                           AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                                     LEFT JOIN MovementDate AS MovementDate_CarInfo
                                                            ON MovementDate_CarInfo.MovementId = Movement.Id
                                                           AND MovementDate_CarInfo.DescId = zc_MovementDate_CarInfo()
                                WHERE Movement.OperDate BETWEEN inStartDate AND inStartDate + INTERVAL '7 DAY'
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                                  AND Movement.DescId = zc_Movement_OrderExternal()
                                  AND MovementDate_CarInfo.MovementId IS NULL
                                  AND inIsDate_CarInfo = TRUE
                               UNION
                                SELECT Movement.*
                                       -- Дата/время отгрузки
                                     , MovementDate_CarInfo.ValueData AS OperDate_CarInfo
                                       -- Дата смены
                                     , CASE WHEN EXTRACT (HOUR FROM MovementDate_CarInfo.ValueData) < 8 THEN DATE_TRUNC ('DAY', MovementDate_CarInfo.ValueData) - INTERVAL '1 DAY'
                                          --WHEN EXTRACT (HOUR FROM MovementDate_CarInfo.ValueData) >= 13 THEN DATE_TRUNC ('DAY', MovementDate_CarInfo.ValueData)
                                          --WHEN Movement.OperDate + INTERVAL '1 DAY' <= MovementDate_OperDatePartner.ValueData THEN DATE_TRUNC ('DAY', MovementDate_CarInfo.ValueData) - INTERVAL '1 DAY'
                                            ELSE DATE_TRUNC ('DAY', MovementDate_CarInfo.ValueData)
                                       END  AS OperDate_CarInfo_date
                                FROM MovementDate AS MovementDate_CarInfo
                                     INNER JOIN Movement ON Movement.Id = MovementDate_CarInfo.MovementId
                                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                                                        AND Movement.DescId = zc_Movement_OrderExternal()
                                WHERE MovementDate_CarInfo.DescId = zc_MovementDate_CarInfo()
                                  AND MovementDate_CarInfo.ValueData >= inStartDate + INTERVAL '8 HOUR'
                                --AND MovementDate_CarInfo.ValueData <= inEndDate
                                  AND inStartDate = inEndDate
                                --AND inStartDate >= CURRENT_DATE - INTERVAL '5 DAY'
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
       -- Взвешивание факт
     , tmpWeighing AS (SELECT tmpMovementAll.Id, MIN (MovementDate_StartWeighing.ValueData) AS StartWeighing, MAX (COALESCE (MovementDate_EndWeighing.ValueData, CURRENT_TIMESTAMP)) AS EndWeighing
                       FROM tmpMovementAll
                            INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                            ON MovementLinkMovement_Order.MovementChildId = tmpMovementAll.Id
                                                           AND MovementLinkMovement_Order.DescId          = zc_MovementLinkMovement_Order()
                            INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Order.MovementId
                                               AND Movement.DescId = zc_Movement_WeighingPartner()
                                               AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                            LEFT JOIN MovementDate AS MovementDate_StartWeighing
                                                   ON MovementDate_StartWeighing.MovementId = Movement.Id
                                                  AND MovementDate_StartWeighing.DescId     = zc_MovementDate_StartWeighing()
                            LEFT JOIN MovementDate AS MovementDate_EndWeighing
                                                   ON MovementDate_EndWeighing.MovementId = Movement.Id
                                                  AND MovementDate_EndWeighing.DescId     = zc_MovementDate_EndWeighing()
                       GROUP BY tmpMovementAll.Id
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
                           , MovementItem_parent.ObjectId                  AS GoodsId_parent
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId_parent
                      FROM MovementItem
                           -- Элемент заявки не удален
                           INNER JOIN tmpMI AS MovementItem_parent
                                            ON MovementItem_parent.MovementId = MovementItem.MovementId
                                           AND MovementItem_parent.DescId     = zc_MI_Master()
                                           AND MovementItem_parent.Id         = MovementItem.ParentId
                                           AND MovementItem_parent.isErased   = FALSE
                            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem_parent.Id
                                                               AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                      WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovementAll.Id FROM tmpMovementAll)
                        AND MovementItem.DescId     = zc_MI_Child()
                        AND MovementItem.isErased   = FALSE
                        AND MovementItem.Amount     > 0
                     )
     , tmpMIFloat_Child AS (SELECT MovementItemFloat.*
                            FROM MovementItemFloat
                            WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMIChild.Id FROM tmpMIChild)
                              AND MovementItemFloat.DescId = zc_MIFloat_MovementId()
                           )
     , tmpMILO_GoodsKind_Child AS (SELECT MovementItemLinkObject.*
                                   FROM MovementItemLinkObject
                                   WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMIChild.Id FROM tmpMIChild)
                                     AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                                  )

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
                         , SUM (COALESCE (MovementItem.Amount,0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END) AS Amount_all_sh

                           -- 1.1. пересорт, вес
                         , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) = 0
                                      AND (MovementItem.GoodsId_parent <> MovementItem.ObjectId OR MovementItem.GoodsKindId_parent <> COALESCE (MILinkObject_GoodsKind.ObjectId, 0))
                                     THEN MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                                     ELSE 0
                                END) AS Amount_sub_Weight
                           -- 1.2. пересорт, вес
                         , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) > 0
                                      AND (MovementItem.GoodsId_parent <> MovementItem.ObjectId OR MovementItem.GoodsKindId_parent <> COALESCE (MILinkObject_GoodsKind.ObjectId, 0))
                                     THEN MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                                     ELSE 0
                                END) AS AmountSecond_sub_Weight
                           -- 1.3. пересорт, вес
                         , SUM (CASE WHEN (MovementItem.GoodsId_parent <> MovementItem.ObjectId OR MovementItem.GoodsKindId_parent <> COALESCE (MILinkObject_GoodsKind.ObjectId, 0))
                                     THEN MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                                     ELSE 0
                                END) AS Amount_sub_all_Weight

                           -- 2.1. пересорт, шт
                         , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) = 0
                                      AND (MovementItem.GoodsId_parent <> MovementItem.ObjectId OR MovementItem.GoodsKindId_parent <> COALESCE (MILinkObject_GoodsKind.ObjectId, 0))
                                     THEN -- если пересорт и резерв = кг а заявка = шт, тогда нужно пересчитать резерв в шт
                                          CASE WHEN ObjectLink_Goods_Measure_parent.ChildObjectId = zc_Measure_Sh() AND ObjectLink_Goods_Measure.ChildObjectId <> zc_Measure_Sh()
                                           AND ObjectFloat_Weight_parent.ValueData > 0
                                          THEN MovementItem.Amount / ObjectFloat_Weight_parent.ValueData

                                          -- здесь шт
                                          ELSE MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END
                                          END
                                     ELSE 0
                                END) AS Amount_sub_sh
                           -- 2.2. пересорт, шт
                         , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) > 0
                                      AND (MovementItem.GoodsId_parent <> MovementItem.ObjectId OR MovementItem.GoodsKindId_parent <> COALESCE (MILinkObject_GoodsKind.ObjectId, 0))
                                     THEN -- если пересорт и резерв = кг а заявка = шт, тогда нужно пересчитать резерв в шт
                                          CASE WHEN ObjectLink_Goods_Measure_parent.ChildObjectId = zc_Measure_Sh() AND ObjectLink_Goods_Measure.ChildObjectId <> zc_Measure_Sh()
                                           AND ObjectFloat_Weight_parent.ValueData > 0
                                          THEN MovementItem.Amount / ObjectFloat_Weight_parent.ValueData

                                          -- здесь шт
                                          ELSE MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END
                                          END
                                     ELSE 0
                                END) AS AmountSecond_sub_sh
                           -- 2.3. пересорт, шт
                         , SUM (CASE WHEN (MovementItem.GoodsId_parent <> MovementItem.ObjectId OR MovementItem.GoodsKindId_parent <> COALESCE (MILinkObject_GoodsKind.ObjectId, 0))
                                     THEN -- если пересорт и резерв = кг а заявка = шт, тогда нужно пересчитать резерв в шт
                                          CASE WHEN ObjectLink_Goods_Measure_parent.ChildObjectId = zc_Measure_Sh() AND ObjectLink_Goods_Measure.ChildObjectId <> zc_Measure_Sh()
                                           AND ObjectFloat_Weight_parent.ValueData > 0
                                          THEN MovementItem.Amount / ObjectFloat_Weight_parent.ValueData

                                          -- здесь шт
                                          ELSE COALESCE (MovementItem.Amount,0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 1 ELSE 0 END
                                          END
                                     ELSE 0
                                END) AS Amount_sub_all_sh

                         , MAX (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN zc_Measure_Sh()              ELSE 0 END) AS MeasureId_isSh
                         , MAX (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 0 END) AS Weight_isSh

                    FROM tmpMIChild AS MovementItem
                         LEFT JOIN tmpMIFloat_Child AS MIFloat_MovementId
                                                    ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                   AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                         LEFT JOIN tmpMILO_GoodsKind_Child AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                   
                         LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                              ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                             AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                         LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                               ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                              AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                                              
                         LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_parent
                                              ON ObjectLink_Goods_Measure_parent.ObjectId = MovementItem.GoodsId_parent
                                             AND ObjectLink_Goods_Measure_parent.DescId = zc_ObjectLink_Goods_Measure()
                         LEFT JOIN ObjectFloat AS ObjectFloat_Weight_parent
                                               ON ObjectFloat_Weight_parent.ObjectId = MovementItem.GoodsId_parent
                                              AND ObjectFloat_Weight_parent.DescId   = zc_ObjectFloat_Goods_Weight()
                                              
                    GROUP BY MovementItem.ParentId
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
       , tmpNPP_date AS (SELECT -- Дата смены
                                tmp.OperDate_CarInfo_date
                                -- № п/п
                              , ROW_NUMBER() OVER (ORDER BY tmp.OperDate_CarInfo_date ASC) AS Ord
                         FROM (SELECT DISTINCT tmpMovementAll.OperDate_CarInfo_date FROM tmpMovementAll
                              ) AS tmp
                        )
       -- Заказ + Резерв - в одну строчку
     , tmpMovement AS (SELECT Movement.OperDate
                            , MovementDate_OperDatePartner.ValueData                   AS OperDatePartner
                            , Movement.ToId                                            AS ToId
                            , MovementLinkObject_Route.ObjectId                        AS RouteId
                            , CASE --
                                   WHEN ObjectLink_Juridical_Retail.ChildObjectId IS NULL AND MovementLinkObject_Route.ObjectId IS NULL
                                        THEN Object_From.Id
                                   WHEN Object_From.DescId = zc_Object_Unit()
                                        THEN Object_From.Id
                                   -- временно
                                   WHEN Object_Route.ValueData ILIKE 'Маршрут №%'
                                     OR Object_Route.ValueData ILIKE 'Самов%'
                                     OR Object_Route.ValueData ILIKE '%-колбаса'
                                     OR Object_Route.ValueData ILIKE '%Кривой Рог%'
                                           THEN 0
                                   ELSE COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, 0)
                              END AS RetailId
                            , STRING_AGG (DISTINCT CASE WHEN Object_Route.ValueData ILIKE 'Маршрут №%'
                                                          OR Object_Route.ValueData ILIKE 'Самов%'
                                                          OR Object_Route.ValueData ILIKE '%-колбаса'
                                                          OR Object_Route.ValueData ILIKE '%Кривой Рог%'
                                                        THEN Object_Retail.ValueData
                                                        ELSE ''
                                                   END, '; ') ::TVarChar AS Retail_list
                            , STRING_AGG (DISTINCT Object_PartnerTag.ValueData, '; ') ::TVarChar AS PartnerTagName
                            , MovementLinkObject_CarInfo.ObjectId                      AS CarInfoId
                            , Movement.OperDate_CarInfo                                AS OperDate_CarInfo
                            , Movement.OperDate_CarInfo_date                           AS OperDate_CarInfo_date

                            , tmpNPP.Ord
                            , MovementString_CarComment.ValueData          ::TVarChar  AS CarComment
                            , COALESCE (MovementBoolean_Remains.ValueData, FALSE)      AS isRemains

                            , CASE WHEN inIsGoods = TRUE THEN MovementItem.ObjectId ELSE 0 END AS GoodsId
                            , CASE WHEN inIsGoods = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) ELSE 0 END AS GoodsKindId

                            , COUNT (DISTINCT Object_From.Id) AS CountPartner
                            , COUNT (DISTINCT Movement.Id) AS CountDoc

                            , MIN (tmpWeighing.StartWeighing) AS StartWeighing, MAX (tmpWeighing.EndWeighing) AS EndWeighing

                              -- Заказ - шт
                            , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                        -- если пересорт и резерв есть хоть один = шт а заявка = кг, тогда нужно информативно шт
                                        WHEN ObjectLink_Goods_Measure.ChildObjectId <> zc_Measure_Sh() AND tmpMI_Child.MeasureId_isSh = zc_Measure_Sh()
                                             AND tmpMI_Child.Weight_isSh > 0
     
                                             THEN (COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))
                                                   -- !!!вес из Резерва!!!
                                                / tmpMI_Child.Weight_isSh
                                        ELSE 0
                                   END) AS AmountSh
                              -- Заказ - кг
                            , SUM ((COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))
                                   * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                                  ) AS AmountWeight

                              -- Резерв
                            , SUM (tmpMI_Child.Amount_Weight)       AS AmountWeight_child_one -- с Остатка
                            , SUM (tmpMI_Child.AmountSecond_Weight) AS AmountWeight_child_sec -- с Прихода
                            , SUM (tmpMI_Child.Amount_all_Weight)   AS AmountWeight_child     -- Итого

                            , SUM (tmpMI_Child.Amount_sh)           AS AmountSh_child_one -- с Остатка
                            , SUM (tmpMI_Child.AmountSecond_sh)     AS AmountSh_child_sec -- с Прихода
                              -- Итого - если пересорт и резерв = кг а заявка = шт, тогда нужно пересчитать резерв в шт
                            , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND COALESCE (tmpMI_Child.MeasureId_isSh, 0) <> zc_Measure_Sh()
                                        THEN CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,0) <> 0
                                                  THEN tmpMI_Child.Amount_all_Weight/ObjectFloat_Weight.ValueData  
                                                  ELSE 0
                                                  END
                                        ELSE COALESCE (tmpMI_Child.Amount_all_sh,0)
                                   END) AS AmountSh_child

                              -- Итого не хватает для резерва, вес
                            , SUM (CASE WHEN Movement.isRemains = TRUE
                                        THEN (COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))
                                            * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                                            - COALESCE (tmpMI_Child.Amount_all_Weight, 0)
                                        ELSE 0
                                   END) AS AmountWeight_diff

                              -- Итого не хватает для резерва, шт
                            , SUM (CASE WHEN Movement.isRemains = TRUE
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
                                                                            THEN tmpMI_Child.Amount_all_Weight/ObjectFloat_Weight.ValueData 
                                                                            ELSE 0
                                                                            END
                                                                  ELSE COALESCE (tmpMI_Child.Amount_all_sh,0)
                                                             END, 0)
                                        ELSE 0
                                   END) AS AmountSh_diff

                              -- Резервы - пересорт
                            , SUM (tmpMI_Child.Amount_sub_Weight)       AS AmountWeight_sub_child_one -- с Остатка
                            , SUM (tmpMI_Child.AmountSecond_sub_Weight) AS AmountWeight_sub_child_sec -- с Прихода
                            , SUM (tmpMI_Child.Amount_sub_all_Weight)   AS AmountWeight_sub_child     -- Итого

                            , SUM (tmpMI_Child.Amount_sub_sh)           AS AmountSh_sub_child_one     -- с Остатка
                            , SUM (tmpMI_Child.AmountSecond_sub_sh)     AS AmountSh_sub_child_sec     -- с Прихода
                            , SUM (tmpMI_Child.Amount_sub_all_sh)       AS AmountSh_sub_child         -- Итого

                       FROM tmpMovementAll AS Movement
                            LEFT JOIN tmpWeighing ON tmpWeighing.Id = Movement.Id

                            LEFT JOIN tmpNPP ON tmpNPP.OperDate_CarInfo = Movement.OperDate_CarInfo

                            LEFT JOIN MovementBoolean AS MovementBoolean_Remains
                                                      ON MovementBoolean_Remains.MovementId = Movement.Id
                                                     AND MovementBoolean_Remains.DescId = zc_MovementBoolean_Remains()

                            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                            LEFT JOIN MovementString AS MovementString_CarComment
                                                     ON MovementString_CarComment.MovementId = Movement.Id
                                                    AND MovementString_CarComment.DescId = zc_MovementString_CarComment()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_CarInfo
                                                         ON MovementLinkObject_CarInfo.MovementId = Movement.Id
                                                        AND MovementLinkObject_CarInfo.DescId = zc_MovementLinkObject_CarInfo()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                                         ON MovementLinkObject_Route.MovementId = Movement.Id
                                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
                            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

                            LEFT JOIN ObjectLink AS ObjectLink_Partner_PartnerTag
                                                 ON ObjectLink_Partner_PartnerTag.ObjectId = MovementLinkObject_From.ObjectId
                                                AND ObjectLink_Partner_PartnerTag.DescId = zc_ObjectLink_Partner_PartnerTag()
                            LEFT JOIN Object AS Object_PartnerTag ON Object_PartnerTag.Id = ObjectLink_Partner_PartnerTag.ChildObjectId

                            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

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
                                                 AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                            -- Резервы
                            LEFT JOIN tmpChild AS tmpMI_Child ON tmpMI_Child.ParentId = MovementItem.Id

                        GROUP BY Movement.OperDate
                               , MovementDate_OperDatePartner.ValueData
                               , Movement.ToId
                               , MovementLinkObject_Route.ObjectId
                               , CASE WHEN ObjectLink_Juridical_Retail.ChildObjectId IS NULL AND MovementLinkObject_Route.ObjectId IS NULL
                                           THEN Object_From.Id
                                      WHEN Object_From.DescId = zc_Object_Unit()
                                           THEN Object_From.Id
                                      -- временно
                                      WHEN Object_Route.ValueData ILIKE 'Маршрут №%'
                                        OR Object_Route.ValueData ILIKE 'Самов%'
                                        OR Object_Route.ValueData ILIKE '%-колбаса'
                                        OR Object_Route.ValueData ILIKE '%Кривой Рог%'
                                           THEN 0
                                      ELSE COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, 0)
                                 END
                               , MovementLinkObject_CarInfo.ObjectId
                               , Movement.OperDate_CarInfo
                               , Movement.OperDate_CarInfo_date
                               , MovementString_CarComment.ValueData
                               , tmpNPP.Ord
                               , COALESCE (MovementBoolean_Remains.ValueData, FALSE)

                               , CASE WHEN inIsGoods = TRUE THEN MovementItem.ObjectId ELSE 0 END
                               , CASE WHEN inIsGoods = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) ELSE 0 END

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
                                     AND Object_GoodsByGoodsKind_View.GoodsId IN (SELECT DISTINCT tmpMovement.GoodsId FROM tmpMovement)
                                   --AND 1=0
                                  )
             , tmpOrderCarInfo AS (SELECT MAX (gpSelect.Id) AS Id, gpSelect.RouteId, gpSelect.RetailId
                                        , gpSelect.OperDate_int, gpSelect.OperDatePartner_int
                                        , gpSelect.Days, MAX (gpSelect.Hour) AS Hour, MAX (gpSelect.Min) AS Min
                                   FROM gpSelect_Object_OrderCarInfo (inIsShowAll:= FALSE, inSession:= inSession) AS gpSelect

                                   WHERE gpSelect.UnitId = inToId
                                   GROUP BY gpSelect.RouteId, gpSelect.RetailId
                                          , gpSelect.OperDate_int, gpSelect.OperDatePartner_int
                                          , gpSelect.Days
                                  )
       -- Результат
       SELECT
             tmpMovement.OperDate              AS OperDate
           , tmpMovement.OperDatePartner       AS OperDatePartner
           , Object_Route.Id                   AS RouteId
           , COALESCE (Object_Route.ValueData, Object_Retail.ValueData) :: TVarChar AS RouteName
           , Object_Retail.Id                  AS RetailId
           , CASE WHEN Object_Retail.Id > 0 THEN Object_Retail.ValueData ELSE tmpMovement.Retail_list END :: TVarChar AS RetailName
           , tmpMovement.PartnerTagName        AS PartnerTagName
           , tmpMovement.OperDate_CarInfo      ::TDateTime AS OperDate_CarInfo
           , tmpMovement.OperDate_CarInfo_date ::TDateTime AS OperDate_CarInfo_date
           , (zfConvert_DateShortToString (tmpMovement.OperDate_CarInfo) || ' ' ||zfConvert_TimeShortToString (tmpMovement.OperDate_CarInfo)) ::TVarChar AS OperDate_CarInfo_str
           , Object_CarInfo.Id                 AS CarInfoId
           , Object_CarInfo.ValueData          AS CarInfoName
           , tmpMovement.CarComment ::TVarChar AS CarComment
           , Object_To.Id                      AS ToId
           , Object_To.ObjectCode              AS ToCode
           , Object_To.ValueData               AS ToName

           , Object_Goods.Id                            AS GoodsId
           , Object_Goods.ObjectCode                    AS GoodsCode
           , Object_Goods.ValueData                     AS GoodsName
           , Object_GoodsKind.ValueData                 AS GoodsKindName
           , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                   AS MeasureName
             --
           , Object_Goods_sub.Id                        AS GoodsId_sub
           , Object_Goods_sub.ObjectCode                AS GoodsCode_sub
           , Object_Goods_sub.ValueData                 AS GoodsName_sub
           , Object_GoodsKind_sub.ValueData             AS GoodsKindName_sub
           , Object_Measure_sub.ValueData               AS MeasureName_sub

             -- Заказы
           , tmpMovement.AmountSh       :: TFloat  AS AmountSh
           , tmpMovement.AmountWeight   :: TFloat  AS AmountWeight

           , tmpMovement.CountPartner   :: TFloat  AS Count_Partner
           , tmpMovement.CountDoc       :: TFloat  AS Count_Doc
           , tmpMovement.isRemains      :: Boolean AS isRemains
           , (tmpMovement.CountPartner :: TVarChar || ' / '  || tmpMovement.CountDoc :: TVarChar) :: TVarChar  AS Count_Partner_str

           , CASE WHEN tmpMovement.OperDate_CarInfo < tmpMovement.OperDatePartner
                       THEN -1 * EXTRACT (DAY FROM tmpMovement.OperDatePartner - DATE_TRUNC ('DAY', tmpMovement.OperDate_CarInfo))
                  WHEN tmpMovement.OperDatePartner < tmpMovement.OperDate_CarInfo
                       THEN  1 * EXTRACT (DAY FROM DATE_TRUNC ('DAY', tmpMovement.OperDate_CarInfo) - tmpMovement.OperDatePartner)
                  ELSE 0
             END :: Integer AS Days
           , CASE WHEN zfConvert_TimeShortToString (tmpMovement.OperDate_CarInfo) = '00:00'
                  THEN ''
                  ELSE zfConvert_TimeShortToString (tmpMovement.OperDate_CarInfo)
             END ::TVarChar AS Times

           , tmpWeekDay.DayOfWeekName                   ::TVarChar AS DayOfWeekName
           , tmpWeekDay_Partner.DayOfWeekName           ::TVarChar AS DayOfWeekName_Partner
           , tmpWeekDay_CarInfo.DayOfWeekName           ::TVarChar AS DayOfWeekName_CarInfo
           , tmpWeekDay_CarInfo_date.DayOfWeekName      ::TVarChar AS DayOfWeekName_CarInfo_date

           , tmpMovement.StartWeighing :: TDateTime AS StartWeighing
           , tmpMovement.EndWeighing   :: TDateTime AS EndWeighing
           , tmpWeekDay_StartW.DayOfWeekName ::TVarChar AS DayOfWeekName_StartW
           , tmpWeekDay_EndW.DayOfWeekName   ::TVarChar AS DayOfWeekName_EndW

           , ((EXTRACT (EPOCH FROM tmpMovement.EndWeighing - tmpMovement.StartWeighing) )    / 60 / 60) ::Integer AS Hours_EndW
           , ((EXTRACT (EPOCH FROM tmpMovement.EndWeighing - tmpMovement.OperDate_CarInfo) ) / 60 / 60) ::Integer AS Hours_real

             -- Резервы, вес
           , tmpMovement.AmountWeight_child_one   ::TFloat AS AmountWeight_child_one
           , tmpMovement.AmountWeight_child_sec   ::TFloat AS AmountWeight_child_sec
           , tmpMovement.AmountWeight_child       ::TFloat AS AmountWeight_child    
             -- Итого не хватает для резерва, вес
           , tmpMovement.AmountWeight_diff        ::TFloat AS AmountWeight_diff
             -- Резервы, шт
           , tmpMovement.AmountSh_child_one       ::TFloat AS AmountSh_child_one
           , tmpMovement.AmountSh_child_sec       ::TFloat AS AmountSh_child_sec
           , tmpMovement.AmountSh_child           ::TFloat AS AmountSh_child
             -- Итого не хватает для резерва, шт
           , tmpMovement.AmountSh_diff            ::TFloat AS AmountSh_diff

             -- Резервы - пересорт
           , tmpMovement.AmountWeight_sub_child_one ::TFloat -- с Остатка
           , tmpMovement.AmountWeight_sub_child_sec ::TFloat -- с Прихода
           , tmpMovement.AmountWeight_sub_child     ::TFloat -- Итого

           , tmpMovement.AmountSh_sub_child_one     ::TFloat -- с Остатка
           , tmpMovement.AmountSh_sub_child_sec     ::TFloat -- с Прихода
           , tmpMovement.AmountSh_sub_child         ::TFloat -- Итого

             -- !!!Дата/время отгрузки - Расчет!!!
           , (CASE WHEN tmpOrderCarInfo.Id IS NULL
                        THEN NULL
                   ELSE tmpMovement.OperDatePartner + ((CASE WHEN tmpOrderCarInfo.Days > 0 THEN  1 * tmpOrderCarInfo.Days ELSE 0 END :: Integer) :: TVarChar || ' DAY') :: INTERVAL
                                                    - ((CASE WHEN tmpOrderCarInfo.Days < 0 THEN -1 * tmpOrderCarInfo.Days ELSE 0 END :: Integer) :: TVarChar || ' DAY') :: INTERVAL
                                                    + ((COALESCE (tmpOrderCarInfo.Hour, 0) :: Integer) :: TVarChar || ' HOUR')   :: INTERVAL
                                                    + ((COALESCE (tmpOrderCarInfo.Min, 0)  :: Integer) :: TVarChar || ' MINUTE') :: INTERVAL
              END) :: TDateTime AS OperDate_CarInfo_calc
           , tmpWeekDay_CarInfo_calc.DayOfWeekName      ::TVarChar AS DayOfWeekName_CarInfo_calc

           , ((EXTRACT (EPOCH FROM tmpMovement.OperDate_CarInfo
                                 - (tmpMovement.OperDatePartner + ((CASE WHEN tmpOrderCarInfo.Days > 0 THEN  1 * tmpOrderCarInfo.Days ELSE 0 END :: Integer) :: TVarChar || ' DAY') :: INTERVAL
                                                                - ((CASE WHEN tmpOrderCarInfo.Days < 0 THEN -1 * tmpOrderCarInfo.Days ELSE 0 END :: Integer) :: TVarChar || ' DAY') :: INTERVAL
                                                                + ((COALESCE (tmpOrderCarInfo.Hour, 0) :: Integer) :: TVarChar || ' HOUR')   :: INTERVAL
                                                                + ((COALESCE (tmpOrderCarInfo.Min, 0)  :: Integer) :: TVarChar || ' MINUTE') :: INTERVAL
                                   ) :: TDateTime
                       )) / 60) ::Integer AS Min_calc
           , tmpOrderCarInfo.Id AS Id_calc

           , tmpMovement.Ord                      :: Integer AS Ord
           , (CASE WHEN tmpNPP_date.Ord < 10 THEN '0' ELSE '' END || tmpNPP_date.Ord :: TVarChar || ' ' || tmpWeekDay_CarInfo_date.DayOfWeekName || '-' || EXTRACT (DAY FROM tmpMovement.OperDate_CarInfo_date) :: TVarChar ) :: TVarChar AS DayOfWeekName_CarInfo_all_1
           , (CASE WHEN tmpNPP_date.Ord < 10 THEN '0' ELSE '' END || tmpNPP_date.Ord :: TVarChar || '/'
           || CASE WHEN tmpMovement.Ord < 10 THEN '0' ELSE '' END || tmpMovement.Ord :: TVarChar || '-' || zfConvert_TimeShortToString (tmpMovement.OperDate_CarInfo)) :: TVarChar AS DayOfWeekName_CarInfo_all_2

      FROM tmpMovement
          LEFT JOIN tmpNPP_date ON tmpNPP_date.OperDate_CarInfo_date = tmpMovement.OperDate_CarInfo_date
          LEFT JOIN tmpOrderCarInfo ON tmpOrderCarInfo.RouteId                = tmpMovement.RouteId

                                   AND COALESCE (tmpOrderCarInfo.RetailId, 0) = tmpMovement.RetailId
                                   AND tmpOrderCarInfo.OperDate_int           = zfCalc_DayOfWeekNumber (tmpMovement.OperDate)
                                   AND tmpOrderCarInfo.OperDatePartner_int    = zfCalc_DayOfWeekNumber (tmpMovement.OperDatePartner)

          LEFT JOIN Object AS Object_To      ON Object_To.Id      = tmpMovement.ToId
          LEFT JOIN Object AS Object_Route   ON Object_Route.Id   = tmpMovement.RouteId
          LEFT JOIN Object AS Object_CarInfo ON Object_CarInfo.Id = tmpMovement.CarInfoId
          LEFT JOIN Object AS Object_Retail  ON Object_Retail.Id  = tmpMovement.RetailId

          LEFT JOIN zfCalc_DayOfWeekName (tmpMovement.OperDate)              AS tmpWeekDay              ON 1=1
          LEFT JOIN zfCalc_DayOfWeekName (tmpMovement.OperDatePartner)       AS tmpWeekDay_Partner      ON 1=1
          LEFT JOIN zfCalc_DayOfWeekName (tmpMovement.OperDate_CarInfo)      AS tmpWeekDay_CarInfo      ON 1=1
          LEFT JOIN zfCalc_DayOfWeekName (tmpMovement.OperDate_CarInfo_date) AS tmpWeekDay_CarInfo_date ON 1=1
          LEFT JOIN zfCalc_DayOfWeekName (tmpMovement.StartWeighing)         AS tmpWeekDay_StartW       ON 1=1
          LEFT JOIN zfCalc_DayOfWeekName (tmpMovement.EndWeighing)           AS tmpWeekDay_EndW         ON 1=1
          LEFT JOIN zfCalc_DayOfWeekName ((tmpMovement.OperDatePartner + ((CASE WHEN tmpOrderCarInfo.Days > 0 THEN  1 * tmpOrderCarInfo.Days ELSE 0 END :: Integer) :: TVarChar || ' DAY') :: INTERVAL
                                                                       - ((CASE WHEN tmpOrderCarInfo.Days < 0 THEN -1 * tmpOrderCarInfo.Days ELSE 0 END :: Integer) :: TVarChar || ' DAY') :: INTERVAL
                                                                       + ((COALESCE (tmpOrderCarInfo.Hour, 0) :: Integer) :: TVarChar || ' HOUR')   :: INTERVAL
                                                                       + ((COALESCE (tmpOrderCarInfo.Min, 0)  :: Integer) :: TVarChar || ' MINUTE') :: INTERVAL
                                                                       ) :: TDateTime)                    AS tmpWeekDay_CarInfo_calc ON 1=1

          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMovement.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMovement.GoodsKindId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId     = tmpMovement.GoodsId
                                       AND tmpGoodsByGoodsKind.GoodsKindId = tmpMovement.GoodsKindId

          LEFT JOIN Object AS Object_Goods_sub     ON Object_Goods_sub.Id     = tmpGoodsByGoodsKind.GoodsId_sub
          LEFT JOIN Object AS Object_GoodsKind_sub ON Object_GoodsKind_sub.Id = tmpGoodsByGoodsKind.GoodsKindId_sub

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_sub
                               ON ObjectLink_Goods_Measure_sub.ObjectId = Object_Goods_sub.Id
                              AND ObjectLink_Goods_Measure_sub.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure_sub ON Object_Measure_sub.Id = ObjectLink_Goods_Measure_sub.ChildObjectId

      -- !!!если есть заказ!!!
      WHERE tmpMovement.AmountSh     <> 0
         OR tmpMovement.AmountWeight <> 0
      ORDER BY tmpMovement.OperDate_CarInfo_date, tmpMovement.OperDate_CarInfo
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.06.22         *
*/

-- тест
-- SELECT * FROM gpReport_OrderExternal_Update (inStartDate:= CURRENT_DATE - INTERVAL '1 DAY', inEndDate:= NULL, inIsDate_CarInfo:= FALSE, inIsGoods:= FALSE, inToId:= 346093, inSession:= '9457');
