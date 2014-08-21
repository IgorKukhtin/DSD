-- Function: gpReport_OrderExternal()

DROP FUNCTION IF EXISTS gpReport_OrderExternal (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderExternal(
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
RETURNS TABLE (InvNumber TVarChar
             , InvNumberPartner TVarChar
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , RouteId Integer, RouteName TVarChar
             , RouteSortingId Integer, RouteSortingName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , MeasureName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , Amount_Weight TFloat, Amount_Sh TFloat
             , Amount_Weight_Second TFloat, Amount_Sh_Second TFloat
             , AmountSumm TFloat, AmountSumm_Second TFloat, AmountSummTotal TFloat
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
     WITH tmpMovement AS (

       SELECT
             CAST (CASE WHEN inIsByDoc THEN Movement.InvNumber ELSE '' END AS TVarChar) AS InvNumber
           , CAST (CASE WHEN inIsByDoc THEN MovementString_InvNumberPartner.ValueData ELSE '' END AS TVarChar) AS InvNumberPartner
           , MovementLinkObject_From.ObjectId           AS FromId
           , MovementLinkObject_To.ObjectId             AS ToId
           , MovementLinkObject_Route.ObjectId          AS RouteId
           , MovementLinkObject_RouteSorting.ObjectId   AS RouteSortingId
           , MovementLinkObject_PaidKind.ObjectId       AS PaidKindId
           , MILinkObject_GoodsKind.ObjectId            AS GoodsKindId
           , MovementItem.ObjectId                      AS GoodsId

           , CAST (SUM((MovementItem.Amount * (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END ))) AS TFloat)            AS Amount_Weight
           , CAST (SUM((CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN MovementItem.Amount ELSE 0 END)) AS TFloat)                                              AS Amount_Sh
           , CAST (SUM((MIFloat_AmountSecond.ValueData * (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END ))) AS TFloat) AS Amount_Weight_Second
           , CAST (SUM((CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN MIFloat_AmountSecond.ValueData ELSE 0 END)) AS TFloat)                                   AS Amount_Sh_Second

           , CAST (SUM(CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( ( COALESCE (MovementItem.Amount, 0) ) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                           ELSE CAST ( ( COALESCE (MovementItem.Amount, 0) ) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END) AS TFloat)                      AS AmountSumm

           , CAST (SUM(CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( ( COALESCE (MIFloat_AmountSecond.ValueData, 0) ) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                           ELSE CAST ( ( COALESCE (MIFloat_AmountSecond.ValueData, 0) ) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END) AS TFloat)                      AS AmountSumm_Second


           , CAST (SUM(CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( ( COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                           ELSE CAST ( ( COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END) AS TFloat)                      AS AmountSummTotal
       FROM Movement

           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
           LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                    ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                   AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
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
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                 ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

       WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
         AND Movement.DescId = zc_Movement_OrderExternal()
         AND (COALESCE (MovementLinkObject_To.ObjectId,0) = CASE WHEN inToId <> 0 THEN inToId ELSE COALESCE (MovementLinkObject_To.ObjectId,0) END)
         AND (COALESCE (MovementLinkObject_From.ObjectId,0) = CASE WHEN inFromId <> 0 THEN inFromId ELSE COALESCE (MovementLinkObject_From.ObjectId,0) END)
         AND (COALESCE (MovementLinkObject_Route.ObjectId,0) = CASE WHEN inRouteId <> 0 THEN inRouteId ELSE COALESCE (MovementLinkObject_Route.ObjectId,0) END)
         AND (COALESCE (MovementLinkObject_RouteSorting.ObjectId,0) = CASE WHEN inRouteSortingId <> 0 THEN inRouteSortingId ELSE COALESCE (MovementLinkObject_RouteSorting.ObjectId,0) END)
         AND (COALESCE (MovementLinkObject_RouteSorting.ObjectId,0) = CASE WHEN inRouteSortingId <> 0 THEN inRouteSortingId ELSE COALESCE (MovementLinkObject_RouteSorting.ObjectId,0) END)

       GROUP BY
             CAST (CASE WHEN inIsByDoc THEN Movement.InvNumber ELSE '' END AS TVarChar)
           , CAST (CASE WHEN inIsByDoc THEN MovementString_InvNumberPartner.ValueData ELSE '' END AS TVarChar)
           , MovementString_InvNumberPartner.ValueData
           , MovementLinkObject_From.ObjectId
           , MovementLinkObject_To.ObjectId
           , MovementLinkObject_Route.ObjectId
           , MovementLinkObject_RouteSorting.ObjectId
           , MovementLinkObject_PaidKind.ObjectId
           , MILinkObject_GoodsKind.ObjectId
           , MovementItem.ObjectId
         )

       SELECT
             tmpMovement.InvNumber                      AS InvNumber
           , tmpMovement.InvNumberPartner               AS InvNumberPartner
           , Object_From.Id                             AS FromId
           , Object_From.ValueData                      AS FromName
           , Object_To.Id                               AS ToId
           , Object_To.ValueData                        AS ToName
           , Object_Route.Id                            AS RouteId
           , Object_Route.ValueData                     AS RouteName
           , Object_RouteSorting.Id                     AS RouteSortingId
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
           , tmpMovement.Amount_Weight                  AS Amount_Weight
           , tmpMovement.Amount_Sh                      AS Amount_Sh
           , tmpMovement.Amount_Weight_Second           AS Amount_Weight_Second
           , tmpMovement.Amount_Sh_Second               AS Amount_Sh_Second
           , tmpMovement.AmountSumm                     AS AmountSumm
           , tmpMovement.AmountSumm_Second              AS AmountSumm_Second
           , tmpMovement.AmountSummTotal                AS AmountSummTotal

       FROM tmpMovement
          LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMovement.FromId
          LEFT JOIN Object AS Object_To ON Object_To.Id = tmpMovement.ToId
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

            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_OrderExternal (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.08.14                                                        *

*/

-- тест
 SELECT * FROM gpReport_OrderExternal (inStartDate:= '01.01.2014', inEndDate:= '12.12.2014', inFromId := 0, inToId := 0, inRouteId := 0, inRouteSortingId := 0, inGoodsGroupId := 0, inIsByDoc := True, inSession:= '2')