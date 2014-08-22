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
             , AmountSumm1 TFloat, AmountSumm2 TFloat, AmountSummTotal TFloat, AmountSumm_Dozakaz TFloat
             , Amount_Weight1 TFloat, Amount_Sh1 TFloat
             , Amount_Weight2 TFloat, Amount_Sh2 TFloat
             , Amount_Weight_Itog TFloat, Amount_Sh_Itog TFloat
             , Amount_Weight_Dozakaz TFloat, Amount_Sh_Dozakaz TFloat
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
             CAST (CASE WHEN inIsByDoc THEN Movement.InvNumber ELSE '' END AS TVarChar)                                                         AS InvNumber
           , CAST (CASE WHEN inIsByDoc THEN MovementString_InvNumberPartner.ValueData ELSE '' END AS TVarChar)                                  AS InvNumberPartner
           , MovementLinkObject_From.ObjectId                                                                                                   AS FromId
           , MovementLinkObject_To.ObjectId                                                                                                     AS ToId
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
         ),

       tmpMovement AS (
       SELECT
             tmpMovement2.InvNumber          AS InvNumber
           , tmpMovement2.InvNumberPartner   AS InvNumberPartner
           , tmpMovement2.FromId             AS FromId
           , tmpMovement2.ToId               AS ToId
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

       FROM tmpMovement2 AS tmpMovement2

           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = tmpMovement2.GoodsId
                                                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                 ON ObjectFloat_Weight.ObjectId = tmpMovement2.GoodsId
                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
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
 22.08.14                                                        *
 21.08.14                                                        *

*/

-- тест
 SELECT * FROM gpReport_OrderExternal (inStartDate:= '01.01.2014', inEndDate:= '12.12.2014', inFromId := 0, inToId := 0, inRouteId := 0, inRouteSortingId := 0, inGoodsGroupId := 0, inIsByDoc := True, inSession:= '2')