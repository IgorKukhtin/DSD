-- Function: gpReport_OrderExternal_Cross()

DROP FUNCTION IF EXISTS gpReport_OrderExternal_Cross (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderExternal_Cross(
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
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
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

    CREATE TEMP TABLE tmpMovement (Id Integer, InvNumber TVarChar, Num INTEGER) ON COMMIT DROP;
    INSERT INTO tmpMovement

       SELECT
              Movement.Id
            , Movement.InvNumber
            , CAST(row_number() over (ORDER BY Object_From.ValueData) AS INTEGER)

       FROM Movement

           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
           LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                        ON MovementLinkObject_Route.MovementId = Movement.Id
                                       AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                       ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                      AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
/*
           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                  AND MovementItem.DescId     = zc_MI_Master()
                                  AND MovementItem.isErased   = FALSE
           INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
*/
       WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
         AND Movement.DescId = zc_Movement_OrderExternal()
         AND Movement.StatusId  = zc_Enum_Status_Complete()
         AND (COALESCE (MovementLinkObject_To.ObjectId,0) = CASE WHEN inToId <> 0 THEN inToId ELSE COALESCE (MovementLinkObject_To.ObjectId,0) END)
         AND (COALESCE (MovementLinkObject_From.ObjectId,0) = CASE WHEN inFromId <> 0 THEN inFromId ELSE COALESCE (MovementLinkObject_From.ObjectId,0) END)
         AND (COALESCE (MovementLinkObject_Route.ObjectId,0) = CASE WHEN inRouteId <> 0 THEN inRouteId ELSE COALESCE (MovementLinkObject_Route.ObjectId,0) END)
         AND (COALESCE (MovementLinkObject_RouteSorting.ObjectId,0) = CASE WHEN inRouteSortingId <> 0 THEN inRouteSortingId ELSE COALESCE (MovementLinkObject_RouteSorting.ObjectId,0) END)

--       GROUP BY
--             Movement.Id
--            , CAST (Movement.InvNumber  AS TVarChar)

       ORDER BY Object_From.ValueData;
--       LIMIT 25;


     OPEN Cursor1 FOR
       SELECT
--              Movement.Id                                                           AS MovementId
--            , Object_From.ValueData                                                 AS FromName
--            , CAST (MovementString_InvNumberPartner.ValueData  AS TVarChar)         AS InvNumberPartner
--            , Num                                                                   AS Num
             MAX(CASE WHEN Movement.Num = 1 THEN Object_From.ValueData ELSE NULL END)                       AS Name1
           , MAX(CASE WHEN Movement.Num = 1 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber1
           , MAX(CASE WHEN Movement.Num = 2 THEN Object_From.valuedata ELSE NULL END)                       AS Name2
           , MAX(CASE WHEN Movement.Num = 2 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber2
           , MAX(CASE WHEN Movement.Num = 3 THEN Object_From.valuedata ELSE NULL END)                       AS Name3
           , MAX(CASE WHEN Movement.Num = 3 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber3
           , MAX(CASE WHEN Movement.Num = 4 THEN Object_From.valuedata ELSE NULL END)                       AS Name4
           , MAX(CASE WHEN Movement.Num = 4 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber4
           , MAX(CASE WHEN Movement.Num = 5 THEN Object_From.valuedata ELSE NULL END)                       AS Name5
           , MAX(CASE WHEN Movement.Num = 5 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber5
           , MAX(CASE WHEN Movement.Num = 6 THEN Object_From.valuedata ELSE NULL END)                       AS Name6
           , MAX(CASE WHEN Movement.Num = 6 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber6
           , MAX(CASE WHEN Movement.Num = 7 THEN Object_From.valuedata ELSE NULL END)                       AS Name7
           , MAX(CASE WHEN Movement.Num = 7 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber7
           , MAX(CASE WHEN Movement.Num = 8 THEN Object_From.valuedata ELSE NULL END)                       AS Name8
           , MAX(CASE WHEN Movement.Num = 8 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber8
           , MAX(CASE WHEN Movement.Num = 9 THEN Object_From.valuedata ELSE NULL END)                       AS Name9
           , MAX(CASE WHEN Movement.Num = 9 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber9
           , MAX(CASE WHEN Movement.Num = 10 THEN Object_From.valuedata ELSE NULL END)                       AS Name10
           , MAX(CASE WHEN Movement.Num = 10 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber10
           , MAX(CASE WHEN Movement.Num = 11 THEN Object_From.ValueData ELSE NULL END)                       AS Name11
           , MAX(CASE WHEN Movement.Num = 11 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber11
           , MAX(CASE WHEN Movement.Num = 12 THEN Object_From.valuedata ELSE NULL END)                       AS Name12
           , MAX(CASE WHEN Movement.Num = 12 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber12
           , MAX(CASE WHEN Movement.Num = 13 THEN Object_From.valuedata ELSE NULL END)                       AS Name13
           , MAX(CASE WHEN Movement.Num = 13 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber13
           , MAX(CASE WHEN Movement.Num = 14 THEN Object_From.valuedata ELSE NULL END)                       AS Name14
           , MAX(CASE WHEN Movement.Num = 14 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber14
           , MAX(CASE WHEN Movement.Num = 15 THEN Object_From.valuedata ELSE NULL END)                       AS Name15
           , MAX(CASE WHEN Movement.Num = 15 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber15
           , MAX(CASE WHEN Movement.Num = 16 THEN Object_From.valuedata ELSE NULL END)                       AS Name16
           , MAX(CASE WHEN Movement.Num = 16 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber16
           , MAX(CASE WHEN Movement.Num = 17 THEN Object_From.valuedata ELSE NULL END)                       AS Name17
           , MAX(CASE WHEN Movement.Num = 17 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber17
           , MAX(CASE WHEN Movement.Num = 18 THEN Object_From.valuedata ELSE NULL END)                       AS Name18
           , MAX(CASE WHEN Movement.Num = 18 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber18
           , MAX(CASE WHEN Movement.Num = 19 THEN Object_From.valuedata ELSE NULL END)                       AS Name19
           , MAX(CASE WHEN Movement.Num = 19 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber19
           , MAX(CASE WHEN Movement.Num = 20 THEN Object_From.valuedata ELSE NULL END)                       AS Name20
           , MAX(CASE WHEN Movement.Num = 20 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber20
           , MAX(CASE WHEN Movement.Num = 21 THEN Object_From.ValueData ELSE NULL END)                       AS Name21
           , MAX(CASE WHEN Movement.Num = 21 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber21
           , MAX(CASE WHEN Movement.Num = 22 THEN Object_From.valuedata ELSE NULL END)                       AS Name22
           , MAX(CASE WHEN Movement.Num = 22 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber22
           , MAX(CASE WHEN Movement.Num = 23 THEN Object_From.valuedata ELSE NULL END)                       AS Name23
           , MAX(CASE WHEN Movement.Num = 23 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber23
           , MAX(CASE WHEN Movement.Num = 24 THEN Object_From.valuedata ELSE NULL END)                       AS Name24
           , MAX(CASE WHEN Movement.Num = 24 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber24
           , MAX(CASE WHEN Movement.Num = 25 THEN Object_From.valuedata ELSE NULL END)                       AS Name25
           , MAX(CASE WHEN Movement.Num = 25 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber25
           , CAST(MAX(Movement.Num) AS INTEGER)                                                              AS ColCount

       FROM tmpMovement AS Movement

           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
           LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
           LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                    ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                   AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
       WHERE Num<26
--       ORDER BY Num

            ;
     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
     WITH
       tmpMovement AS (

       SELECT
             Movement.Id
           , MovementLinkObject_From.ObjectId                                                                                                   AS FromId
           , MovementLinkObject_To.ObjectId                                                                                                     AS ToId
           , MovementLinkObject_Route.ObjectId                                                                                                  AS RouteId
           , MovementLinkObject_RouteSorting.ObjectId                                                                                           AS RouteSortingId
           , MovementLinkObject_PaidKind.ObjectId                                                                                               AS PaidKindId
           , MILinkObject_GoodsKind.ObjectId                                                                                                    AS GoodsKindId
           , MovementItem.ObjectId                                                                                                              AS GoodsId
--           , CAST (SUM(MovementItem.Amount)) AS TFloat    AS Amount12
           , SUM(CASE WHEN Movement.Num = 1 THEN MovementItem.Amount ELSE 0 END)       AS Amount1
           , SUM(CASE WHEN Movement.Num = 2 THEN MovementItem.Amount ELSE 0 END)       AS Amount2
           , SUM(CASE WHEN Movement.Num = 3 THEN MovementItem.Amount ELSE 0 END)       AS Amount3
           , SUM(CASE WHEN Movement.Num = 4 THEN MovementItem.Amount ELSE 0 END)       AS Amount4
           , SUM(CASE WHEN Movement.Num = 5 THEN MovementItem.Amount ELSE 0 END)       AS Amount5
           , SUM(CASE WHEN Movement.Num = 6 THEN MovementItem.Amount ELSE 0 END)       AS Amount6
           , SUM(CASE WHEN Movement.Num = 7 THEN MovementItem.Amount ELSE 0 END)       AS Amount7
           , SUM(CASE WHEN Movement.Num = 8 THEN MovementItem.Amount ELSE 0 END)       AS Amount8
           , SUM(CASE WHEN Movement.Num = 9 THEN MovementItem.Amount ELSE 0 END)       AS Amount9
           , SUM(CASE WHEN Movement.Num = 10 THEN MovementItem.Amount ELSE 0 END)      AS Amount10
           , SUM(CASE WHEN Movement.Num = 11 THEN MovementItem.Amount ELSE 0 END)      AS Amount11
           , SUM(CASE WHEN Movement.Num = 12 THEN MovementItem.Amount ELSE 0 END)      AS Amount12
           , SUM(CASE WHEN Movement.Num = 13 THEN MovementItem.Amount ELSE 0 END)      AS Amount13
           , SUM(CASE WHEN Movement.Num = 14 THEN MovementItem.Amount ELSE 0 END)      AS Amount14
           , SUM(CASE WHEN Movement.Num = 15 THEN MovementItem.Amount ELSE 0 END)      AS Amount15
           , SUM(CASE WHEN Movement.Num = 16 THEN MovementItem.Amount ELSE 0 END)      AS Amount16
           , SUM(CASE WHEN Movement.Num = 17 THEN MovementItem.Amount ELSE 0 END)      AS Amount17
           , SUM(CASE WHEN Movement.Num = 18 THEN MovementItem.Amount ELSE 0 END)      AS Amount18
           , SUM(CASE WHEN Movement.Num = 19 THEN MovementItem.Amount ELSE 0 END)      AS Amount19
           , SUM(CASE WHEN Movement.Num = 20 THEN MovementItem.Amount ELSE 0 END)      AS Amount20
           , SUM(CASE WHEN Movement.Num = 21 THEN MovementItem.Amount ELSE 0 END)      AS Amount21
           , SUM(CASE WHEN Movement.Num = 22 THEN MovementItem.Amount ELSE 0 END)      AS Amount22
           , SUM(CASE WHEN Movement.Num = 23 THEN MovementItem.Amount ELSE 0 END)      AS Amount23
           , SUM(CASE WHEN Movement.Num = 24 THEN MovementItem.Amount ELSE 0 END)      AS Amount24
           , SUM(CASE WHEN Movement.Num = 25 THEN MovementItem.Amount ELSE 0 END)      AS Amount25
           , SUM(CASE WHEN Movement.Num > 25 THEN MovementItem.Amount ELSE 0 END)      AS AmountOther
           , SUM(MovementItem.Amount)                                                  AS AmountTotal



       FROM tmpMovement AS Movement

           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

--           LEFT JOIN tmpFrom25 ON tmpFrom25.FromId = MovementLinkObject_From.ObjectId

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

       GROUP BY
             Movement.Id
           , MovementLinkObject_From.ObjectId
           , MovementLinkObject_To.ObjectId
           , MovementLinkObject_Route.ObjectId
           , MovementLinkObject_RouteSorting.ObjectId
           , MovementLinkObject_PaidKind.ObjectId
           , MILinkObject_GoodsKind.ObjectId
           , MovementItem.ObjectId
         )


       SELECT
             tmpMovement.Id
           , Object_From.Id                             AS FromId
           , Object_From.ObjectCode                     AS FromCode
           , Object_From.ValueData                      AS FromName
           , Object_To.Id                               AS ToId
           , Object_To.ValueData                        AS ToName
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
           , Object_InfoMoney_View.InfoMoneyName        AS InfoMoneyName
           , tmpMovement.Amount1                        AS Amount1
           , tmpMovement.Amount2                        AS Amount2
           , tmpMovement.Amount3                        AS Amount3
           , tmpMovement.Amount4                        AS Amount4
           , tmpMovement.Amount5                        AS Amount5
           , tmpMovement.Amount6                        AS Amount6
           , tmpMovement.Amount7                        AS Amount7
           , tmpMovement.Amount8                        AS Amount8
           , tmpMovement.Amount9                        AS Amount9
           , tmpMovement.Amount10                       AS Amount10
           , tmpMovement.Amount11                       AS Amount11
           , tmpMovement.Amount12                       AS Amount12
           , tmpMovement.Amount13                       AS Amount13
           , tmpMovement.Amount14                       AS Amount14
           , tmpMovement.Amount15                       AS Amount15
           , tmpMovement.Amount16                       AS Amount16
           , tmpMovement.Amount17                       AS Amount17
           , tmpMovement.Amount18                       AS Amount18
           , tmpMovement.Amount19                       AS Amount19
           , tmpMovement.Amount20                       AS Amount20
           , tmpMovement.Amount21                       AS Amount21
           , tmpMovement.Amount22                       AS Amount22
           , tmpMovement.Amount23                       AS Amount23
           , tmpMovement.Amount24                       AS Amount24
           , tmpMovement.Amount25                       AS Amount25
           , tmpMovement.AmountOther                    AS AmountOther
           , tmpMovement.AmountTotal                    AS AmountTotal

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

          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMovement.GoodsId
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()

          LEFT JOIN Object_InfoMoney_View AS Object_InfoMoney_View
                                          ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
            ;
     RETURN NEXT Cursor2;



END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_OrderExternal_Cross (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.09.14                                                        *

*/

-- тест
/*
BEGIN;
 SELECT * FROM gpReport_OrderExternal_Cross (inStartDate:= '05.11.2014', inEndDate:= '05.11.2014', inFromId := 0, inToId := 0, inRouteId := 0, inRouteSortingId := 0, inGoodsGroupId := 0, inIsByDoc := False, inSession:= '2')
COMMIT;
*/
