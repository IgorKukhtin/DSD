-- Function: gpReport_OrderExternal_Sale()

DROP FUNCTION IF EXISTS gpReport_OrderExternal_Sale (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderExternal_Sale(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inFromId             Integer   , -- От кого (в документе)
    IN inToId               Integer   , -- Кому (в документе)
    IN inRouteId            Integer   , -- Маршрут
    IN inRouteSortingId     Integer   , -- Сортировки маршрутов
    IN inGoodsGroupId       Integer   ,
    IN inIsByDoc            Boolean   ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (
               FromId Integer, FromCode Integer, FromName TVarChar
             , RouteId Integer, RouteName TVarChar
             , RouteSortingId Integer, RouteSortingCode Integer, RouteSortingName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , MeasureName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , AmountSumm1 TFloat, AmountSumm2 TFloat, AmountSummTotal TFloat, AmountSumm_Dozakaz TFloat
             , Amount_Weight1 TFloat, Amount_Sh1 TFloat
             , Amount_Weight2 TFloat, Amount_Sh2 TFloat
             , Amount_Weight_Itog TFloat, Amount_Sh_Itog TFloat
             , Amount_Weight_Dozakaz TFloat, Amount_Sh_Dozakaz TFloat
             , Amount12 TFloat, Amount_WeightSK TFloat
             , AmountSale_Weight TFloat, AmountSale_Sh TFloat
             , InfoMoneyName TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- Ограничения по товарам
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
           SELECT GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
    END IF;


     RETURN QUERY
     WITH tmpMovement2 AS (

       SELECT
             MovementLinkObject_From.ObjectId                                                                                                   AS FromId
           , MovementLinkObject_Route.ObjectId                                                                                                  AS RouteId
           , MovementLinkObject_RouteSorting.ObjectId                                                                                           AS RouteSortingId
           , MovementLinkObject_PaidKind.ObjectId                                                                                               AS PaidKindId
           , MILinkObject_GoodsKind.ObjectId                                                                                                    AS GoodsKindId
           , MovementItem.ObjectId                                                                                                              AS GoodsId
           , CAST (SUM((CASE WHEN Movement.OperDate = MovementDate_OperDatePartner.ValueData THEN MovementItem.Amount ELSE 0 END)) AS TFloat)   AS Amount1
           , CAST (SUM((CASE WHEN Movement.OperDate <> MovementDate_OperDatePartner.ValueData THEN MovementItem.Amount ELSE 0 END)) AS TFloat)  AS Amount2
           , CAST (SUM((MIFloat_AmountSecond.ValueData )) AS TFloat)                                                                            AS Amount_Dozakaz


           , CAST (SUM(CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( ( COALESCE ((CASE WHEN Movement.OperDate = MovementDate_OperDatePartner.ValueData THEN MovementItem.Amount ELSE 0 END), 0) ) * COALESCE (MIFloat_Price.ValueData,0) / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                           ELSE CAST ( ( COALESCE (MovementItem.Amount, 0) ) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                   END) AS TFloat)                      AS AmountSumm1

           , CAST (SUM(CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( ( COALESCE ((CASE WHEN Movement.OperDate <> MovementDate_OperDatePartner.ValueData THEN MovementItem.Amount ELSE 0 END), 0) ) * COALESCE (MIFloat_Price.ValueData, 0) / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                           ELSE CAST ( ( COALESCE (MovementItem.Amount, 0) ) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                   END) AS TFloat)                      AS AmountSumm2


           , CAST (SUM(CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( ( COALESCE (MIFloat_AmountSecond.ValueData, 0) ) * COALESCE (MIFloat_Price.ValueData, 0) / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                           ELSE CAST ( ( COALESCE (MIFloat_AmountSecond.ValueData, 0) ) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                   END) AS TFloat)                      AS AmountSumm_Dozakaz


           , CAST (SUM(CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST (  COALESCE (MovementItem.Amount, 0) * COALESCE (MIFloat_Price.ValueData, 0) / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                           ELSE CAST (  COALESCE (MovementItem.Amount, 0) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                   END) AS TFloat)                      AS AmountSummTotal

       FROM Movement

           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                        ON MovementLinkObject_Route.MovementId = Movement.Id
                                       AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                       ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                      AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                        ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                       AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
           LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                  ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                 AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                  AND MovementItem.DescId     = zc_MI_Master()
                                  AND MovementItem.isErased   = FALSE
           INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
           LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                       ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                      AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()

           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
           LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                       ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                      AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

       WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
         AND Movement.DescId = zc_Movement_OrderExternal()
         AND (COALESCE (MovementLinkObject_To.ObjectId,0) = CASE WHEN inToId <> 0 THEN inToId ELSE COALESCE (MovementLinkObject_To.ObjectId,0) END)
         AND (COALESCE (MovementLinkObject_From.ObjectId,0) = CASE WHEN inFromId <> 0 THEN inFromId ELSE COALESCE (MovementLinkObject_From.ObjectId,0) END)
         AND (COALESCE (MovementLinkObject_Route.ObjectId,0) = CASE WHEN inRouteId <> 0 THEN inRouteId ELSE COALESCE (MovementLinkObject_Route.ObjectId,0) END)
         AND (COALESCE (MovementLinkObject_RouteSorting.ObjectId,0) = CASE WHEN inRouteSortingId <> 0 THEN inRouteSortingId ELSE COALESCE (MovementLinkObject_RouteSorting.ObjectId,0) END)

       GROUP BY
             MovementLinkObject_From.ObjectId
           , MovementLinkObject_Route.ObjectId
           , MovementLinkObject_RouteSorting.ObjectId
           , MovementLinkObject_PaidKind.ObjectId
           , MILinkObject_GoodsKind.ObjectId
           , MovementItem.ObjectId
         ),

       tmpMovementOrder AS (
       SELECT
             tmpMovement2.FromId             AS FromId
           , tmpMovement2.RouteId            AS RouteId
           , tmpMovement2.RouteSortingId     AS RouteSortingId
           , tmpMovement2.PaidKindId         AS PaidKindId
           , tmpMovement2.GoodsKindId        AS GoodsKindId
           , tmpMovement2.GoodsId            AS GoodsId
           , tmpMovement2.AmountSumm1        AS AmountSumm1
           , tmpMovement2.AmountSumm2        AS AmountSumm2
           , tmpMovement2.AmountSummTotal    AS AmountSummTotal
           , tmpMovement2.AmountSumm_Dozakaz AS AmountSumm_Dozakaz

           , CAST ((Amount1 * (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) AS TFloat)            AS Amount_Weight1
           , CAST ((CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN Amount1 ELSE 0 END) AS TFloat)                                              AS Amount_Sh1

           , CAST ((Amount2 * (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) AS TFloat)            AS Amount_Weight2
           , CAST ((CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN Amount2 ELSE 0 END) AS TFloat)                                              AS Amount_Sh2

           , CAST (( (Amount1+Amount2) * (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) AS TFloat) AS Amount_Weight_Itog
           , CAST ((CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN (Amount1+Amount2) ELSE 0 END) AS TFloat)                                    AS Amount_Sh_Itog

           , CAST ((Amount_Dozakaz * (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) AS TFloat)     AS Amount_Weight_Dozakaz
           , CAST ((CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN Amount_Dozakaz ELSE 0 END) AS TFloat)                                       AS Amount_Sh_Dozakaz

           , CAST ((Amount1 + Amount2) AS TFloat)                                                                                                                       AS Amount12
           , CAST (0 AS TFloat)               AS AmountSale_Weight
           , CAST (0 AS TFloat)               AS AmountSale_Sh


       FROM tmpMovement2 AS tmpMovement2

           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = tmpMovement2.GoodsId
                                                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                 ON ObjectFloat_Weight.ObjectId = tmpMovement2.GoodsId
                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
         ),

--     ПРОДАЖИ -------------------
       tmpMovementSale AS (
       SELECT


             MovementLinkObject_From.ObjectId           AS FromId
           , MovementLinkObject_Route.ObjectId          AS RouteId
           , MovementLinkObject_RouteSorting.ObjectId   AS RouteSortingId
           , MovementLinkObject_PaidKind.ObjectId       AS PaidKindId
           , MILinkObject_GoodsKind.ObjectId            AS GoodsKindId
           , MovementItem.ObjectId                      AS GoodsId
           , CAST (0 AS TFloat)                         AS Amount1
           , CAST (0 AS TFloat)                         AS Amount2
           , CAST (0 AS TFloat)                         AS Amount_Dozakaz
           , CAST (0 AS TFloat)                         AS AmountSumm1
           , CAST (0 AS TFloat)                         AS AmountSumm2
           , CAST (0 AS TFloat)                         AS AmountSumm_Dozakaz
           , CAST (0 AS TFloat)                         AS AmountSummTotal

           , CAST (0 AS TFloat)                         AS Amount_Weight1
           , CAST (0 AS TFloat)                         AS Amount_Sh1
           , CAST (0 AS TFloat)                         AS Amount_Weight2
           , CAST (0 AS TFloat)                         AS Amount_Sh2
           , CAST (0 AS TFloat)                         AS Amount_Weight_Itog
           , CAST (0 AS TFloat)                         AS Amount_Sh_Itog
           , CAST (0 AS TFloat)                         AS Amount_Weight_Dozakaz
           , CAST (0 AS TFloat)                         AS Amount_Sh_Dozakaz
           , CAST (0 AS TFloat)                         AS Amount12

           , CAST (SUM((MIFloat_AmountPartner.ValueData * (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END ))) AS TFloat) AS AmountSale_Weight
           , CAST (SUM((CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN MIFloat_AmountPartner.ValueData ELSE 0 END)) AS TFloat)                                   AS AmountSale_Sh

       FROM Movement

           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_To() --наоборот, что бы было как в заказе
           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_From()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                        ON MovementLinkObject_Route.MovementId = Movement.Id
                                       AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                       ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                      AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                        ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                       AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                  AND MovementItem.DescId     = zc_MI_Master()
                                  AND MovementItem.isErased   = FALSE
           INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId

           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                 ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()


       WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
         AND Movement.DescId = zc_Movement_Sale()
         AND (COALESCE (MovementLinkObject_To.ObjectId,0) = CASE WHEN inToId <> 0 THEN inToId ELSE COALESCE (MovementLinkObject_To.ObjectId,0) END)
         AND (COALESCE (MovementLinkObject_From.ObjectId,0) = CASE WHEN inFromId <> 0 THEN inFromId ELSE COALESCE (MovementLinkObject_From.ObjectId,0) END)
         AND (COALESCE (MovementLinkObject_Route.ObjectId,0) = CASE WHEN inRouteId <> 0 THEN inRouteId ELSE COALESCE (MovementLinkObject_Route.ObjectId,0) END)
         AND (COALESCE (MovementLinkObject_RouteSorting.ObjectId,0) = CASE WHEN inRouteSortingId <> 0 THEN inRouteSortingId ELSE COALESCE (MovementLinkObject_RouteSorting.ObjectId,0) END)

       GROUP BY
             MovementLinkObject_From.ObjectId
           , MovementLinkObject_Route.ObjectId
           , MovementLinkObject_RouteSorting.ObjectId
           , MovementLinkObject_PaidKind.ObjectId
           , MILinkObject_GoodsKind.ObjectId
           , MovementItem.ObjectId),

       tmpMovementAll AS (
       SELECT
             tmpMovementOrder.FromId             AS FromId
           , tmpMovementOrder.RouteId            AS RouteId
           , tmpMovementOrder.RouteSortingId     AS RouteSortingId
           , tmpMovementOrder.PaidKindId         AS PaidKindId
           , tmpMovementOrder.GoodsKindId        AS GoodsKindId
           , tmpMovementOrder.GoodsId            AS GoodsId
           , tmpMovementOrder.AmountSumm1        AS AmountSumm1
           , tmpMovementOrder.AmountSumm2        AS AmountSumm2
           , tmpMovementOrder.AmountSummTotal    AS AmountSummTotal
           , tmpMovementOrder.AmountSumm_Dozakaz AS AmountSumm_Dozakaz
           , tmpMovementOrder.Amount_Weight1     AS Amount_Weight1
           , tmpMovementOrder.Amount_Sh1         AS Amount_Sh1
           , tmpMovementOrder.Amount_Weight2     AS Amount_Weight2
           , tmpMovementOrder.Amount_Sh2         AS Amount_Sh2
           , tmpMovementOrder.Amount_Weight_Itog AS Amount_Weight_Itog
           , tmpMovementOrder.Amount_Sh_Itog     AS Amount_Sh_Itog
           , tmpMovementOrder.Amount_Weight_Dozakaz AS Amount_Weight_Dozakaz
           , tmpMovementOrder.Amount_Sh_Dozakaz  AS Amount_Sh_Dozakaz
           , tmpMovementOrder.Amount12           AS Amount12
           , tmpMovementOrder.AmountSale_Weight  AS AmountSale_Weight
           , tmpMovementOrder.AmountSale_Sh      AS AmountSale_Sh
       FROM tmpMovementOrder
       UNION ALL
       SELECT
             tmpMovementSale.FromId             AS FromId
           , tmpMovementSale.RouteId            AS RouteId
           , tmpMovementSale.RouteSortingId     AS RouteSortingId
           , tmpMovementSale.PaidKindId         AS PaidKindId
           , tmpMovementSale.GoodsKindId        AS GoodsKindId
           , tmpMovementSale.GoodsId            AS GoodsId
           , tmpMovementSale.AmountSumm1        AS AmountSumm1
           , tmpMovementSale.AmountSumm2        AS AmountSumm2
           , tmpMovementSale.AmountSummTotal    AS AmountSummTotal
           , tmpMovementSale.AmountSumm_Dozakaz AS AmountSumm_Dozakaz
           , tmpMovementSale.Amount_Weight1     AS Amount_Weight1
           , tmpMovementSale.Amount_Sh1         AS Amount_Sh1
           , tmpMovementSale.Amount_Weight2     AS Amount_Weight2
           , tmpMovementSale.Amount_Sh2         AS Amount_Sh2
           , tmpMovementSale.Amount_Weight_Itog AS Amount_Weight_Itog
           , tmpMovementSale.Amount_Sh_Itog     AS Amount_Sh_Itog
           , tmpMovementSale.Amount_Weight_Dozakaz AS Amount_Weight_Dozakaz
           , tmpMovementSale.Amount_Sh_Dozakaz  AS Amount_Sh_Dozakaz
           , tmpMovementSale.Amount12           AS Amount12
           , tmpMovementSale.AmountSale_Weight  AS AmountSale_Weight
           , tmpMovementSale.AmountSale_Sh      AS AmountSale_Sh

       FROM tmpMovementSale),
       tmpMovement AS (
       SELECT
             tmpMovementAll.FromId             AS FromId
           , COALESCE (tmpMovementAll.RouteId, 0)        AS RouteId
           , COALESCE (tmpMovementAll.RouteSortingId, 0) AS RouteSortingId

           , tmpMovementAll.PaidKindId         AS PaidKindId
           , tmpMovementAll.GoodsKindId        AS GoodsKindId
           , tmpMovementAll.GoodsId            AS GoodsId

           , CAST (SUM((tmpMovementAll.AmountSumm1)) AS TFloat)         AS AmountSumm1
           , CAST (SUM((tmpMovementAll.AmountSumm2)) AS TFloat)         AS AmountSumm2
           , CAST (SUM((tmpMovementAll.AmountSummTotal)) AS TFloat)     AS AmountSummTotal
           , CAST (SUM((tmpMovementAll.AmountSumm_Dozakaz)) AS TFloat)  AS AmountSumm_Dozakaz
           , CAST (SUM((tmpMovementAll.Amount_Weight1)) AS TFloat)      AS Amount_Weight1
           , CAST (SUM((tmpMovementAll.Amount_Sh1)) AS TFloat)          AS Amount_Sh1
           , CAST (SUM((tmpMovementAll.Amount_Weight2)) AS TFloat)      AS Amount_Weight2
           , CAST (SUM((tmpMovementAll.Amount_Sh2)) AS TFloat)          AS Amount_Sh2
           , CAST (SUM((tmpMovementAll.Amount_Weight_Itog)) AS TFloat)  AS Amount_Weight_Itog
           , CAST (SUM((tmpMovementAll.Amount_Sh_Itog)) AS TFloat)      AS Amount_Sh_Itog
           , CAST (SUM((tmpMovementAll.Amount_Weight_Dozakaz)) AS TFloat)  AS Amount_Weight_Dozakaz
           , CAST (SUM((tmpMovementAll.Amount_Sh_Dozakaz)) AS TFloat)   AS Amount_Sh_Dozakaz
           , CAST (SUM((tmpMovementAll.Amount12)) AS TFloat)            AS Amount12
           , CAST (SUM((tmpMovementAll.AmountSale_Weight)) AS TFloat)   AS AmountSale_Weight
           , CAST (SUM((tmpMovementAll.AmountSale_Sh)) AS TFloat)       AS AmountSale_Sh

       FROM tmpMovementAll
       GROUP BY
             tmpMovementAll.FromId
           , COALESCE (tmpMovementAll.RouteId, 0)
           , COALESCE (tmpMovementAll.RouteSortingId, 0)
           , tmpMovementAll.PaidKindId
           , tmpMovementAll.GoodsKindId
           , tmpMovementAll.GoodsId)

-- запрос
       SELECT
             Object_From.Id                             AS FromId
           , Object_From.ObjectCode                     AS FromCode
           , Object_From.ValueData                      AS FromName
           , Object_Route.Id                            AS RouteId
           , Object_Route.ValueData                     AS RouteName
           , Object_RouteSorting.Id                     AS RouteSortingId
           , Object_RouteSorting.ObjectCode             AS RouteSortingCode
           , Object_RouteSorting.ValueData              AS RouteSortingName
           , Object_PaidKind.Id                         AS PaidKindId
           , Object_PaidKind.ValueData                  AS PaidKindName
           , Object_GoodsKind.Id                        AS GoodsKindId
           , Object_GoodsKind.ValueData                 AS GoodsKindName
           , Object_Goods.Id                            AS GoodsId
           , Object_Goods.ObjectCode                    AS GoodsCode
           , Object_Goods.ValueData                     AS GoodsName
           , Object_Measure.ValueData                   AS MeasureName
           , Object_GoodsGroup.ValueData                AS GoodsGroupName
           , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull

           , tmpMovement.AmountSumm1                    AS AmountSumm1
           , tmpMovement.AmountSumm2                    AS AmountSumm2
           , tmpMovement.AmountSummTotal                AS AmountSummTotal
           , tmpMovement.AmountSumm_Dozakaz             AS AmountSumm_Dozakaz

           , tmpMovement.Amount_Weight1                 AS Amount_Weight1
           , tmpMovement.Amount_Sh1                     AS Amount_Sh1
           , tmpMovement.Amount_Weight2                 AS Amount_Weight2
           , tmpMovement.Amount_Sh2                     AS Amount_Sh2
           , tmpMovement.Amount_Weight_Itog             AS Amount_Weight_Itog
           , tmpMovement.Amount_Sh_Itog                 AS Amount_Sh_Itog

           , tmpMovement.Amount_Weight_Dozakaz          AS Amount_Weight_Dozakaz
           , tmpMovement.Amount_Sh_Dozakaz              AS Amount_Sh_Dozakaz
           , tmpMovement.Amount12                       AS Amount12
           , CAST (0 AS TFloat)                         AS Amount_WeightSK
           , tmpMovement.AmountSale_Weight              AS AmountSale_Weight
           , tmpMovement.AmountSale_Sh                  AS AmountSale_Sh
           , Object_InfoMoney_View.InfoMoneyName        AS InfoMoneyName

       FROM tmpMovement
          LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMovement.FromId
          LEFT JOIN Object AS Object_Route ON Object_Route.Id = tmpMovement.RouteId
          LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = tmpMovement.RouteSortingId
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpMovement.PaidKindId
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMovement.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMovement.GoodsKindId
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMovement.GoodsId
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()

          LEFT JOIN Object_InfoMoney_View AS Object_InfoMoney_View
                                          ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId



            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_OrderExternal_Sale (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.09.14                                                        *
*/

-- тест
-- SELECT * FROM gpReport_OrderExternal_Sale (inStartDate:= '01.06.2014', inEndDate:= '07.06.2014', inFromId := 0, inToId := 0, inRouteId := 0, inRouteSortingId := 0, inGoodsGroupId := 0, inIsByDoc := True, inSession:= '2')