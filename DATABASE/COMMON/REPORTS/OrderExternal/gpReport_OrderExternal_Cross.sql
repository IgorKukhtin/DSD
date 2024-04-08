-- Function: gpReport_OrderExternal_Cross()

DROP FUNCTION IF EXISTS gpReport_OrderExternal_Cross (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_OrderExternal_Cross (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderExternal_Cross(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inJuridicalId        Integer   , -- Юр.лицо
    IN inRetailId           Integer   , -- Торг. сеть
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
 
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

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

    CREATE TEMP TABLE tmpMovement (Id Integer, InvNumber TVarChar
                                 , FromId Integer, FromCode Integer, FromName TVarChar, ToId Integer, ToName TVarChar
                                 , RouteId Integer, RouteName TVarChar, RouteSortingId Integer, RouteSortingCode Integer, RouteSortingName TVarChar
                                 , PaidKindId Integer, PaidKindName TVarChar, Num INTEGER) ON COMMIT DROP;
    INSERT INTO tmpMovement
       SELECT Movement.Id                       AS Id
            , Movement.InvNumber                AS InvNumber
            , Object_From.Id                    AS FromId
            , Object_From.ObjectCode            AS FromCode
            , Object_From.ValueData             AS FromName
            , Object_To.Id                      AS ToId
            , Object_To.ValueData               AS ToName
            , Object_Route.Id                   AS RouteId
            , Object_Route.ValueData            AS RouteName
            , Object_RouteSorting.Id            AS RouteSortingId
            , Object_RouteSorting.ObjectCode    AS RouteSortingCode
            , Object_RouteSorting.ValueData     AS RouteSortingName
            , Object_PaidKind.Id                AS PaidKindId
            , Object_PaidKind.ValueData         AS PaidKindName
            , CAST(row_number() over (ORDER BY Object_From.ValueData) AS INTEGER) AS Num
       FROM Movement
           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
           LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
           LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

           LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                        ON MovementLinkObject_Route.MovementId = Movement.Id
                                       AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
           LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

           LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                       ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                      AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
           LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId

           LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                        ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                       AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
           LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                               AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

       WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
         AND Movement.DescId = zc_Movement_OrderExternal()
         AND Movement.StatusId  = zc_Enum_Status_Complete()
         AND (COALESCE (MovementLinkObject_To.ObjectId,0)             = CASE WHEN inToId <> 0           THEN inToId           ELSE COALESCE (MovementLinkObject_To.ObjectId,0) END)
         AND (COALESCE (MovementLinkObject_From.ObjectId,0)           = CASE WHEN inFromId <> 0         THEN inFromId         ELSE COALESCE (MovementLinkObject_From.ObjectId,0) END)
         AND (COALESCE (MovementLinkObject_Route.ObjectId,0)          = CASE WHEN inRouteId <> 0        THEN inRouteId        ELSE COALESCE (MovementLinkObject_Route.ObjectId,0) END)
         AND (COALESCE (MovementLinkObject_RouteSorting.ObjectId,0)   = CASE WHEN inRouteSortingId <> 0 THEN inRouteSortingId ELSE COALESCE (MovementLinkObject_RouteSorting.ObjectId,0) END)
         AND (COALESCE (ObjectLink_Partner_Juridical.ChildObjectId,0) = CASE WHEN inJuridicalId <> 0    THEN inJuridicalId    ELSE COALESCE (ObjectLink_Partner_Juridical.ChildObjectId,0) END)
         AND (COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0)  = CASE WHEN inRetailId <> 0       THEN inRetailId       ELSE COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) END)
       ORDER BY Object_From.ValueData;

     OPEN Cursor1 FOR
      SELECT
             MAX(CASE WHEN Movement.Num = 1 THEN Movement.FromName ELSE NULL END)                       AS Name1
           , MAX(CASE WHEN Movement.Num = 1 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber1
           , MAX(CASE WHEN Movement.Num = 2 THEN Movement.FromName ELSE NULL END)                       AS Name2
           , MAX(CASE WHEN Movement.Num = 2 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber2
           , MAX(CASE WHEN Movement.Num = 3 THEN Movement.FromName ELSE NULL END)                       AS Name3
           , MAX(CASE WHEN Movement.Num = 3 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber3
           , MAX(CASE WHEN Movement.Num = 4 THEN Movement.FromName ELSE NULL END)                       AS Name4
           , MAX(CASE WHEN Movement.Num = 4 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber4
           , MAX(CASE WHEN Movement.Num = 5 THEN Movement.FromName ELSE NULL END)                       AS Name5
           , MAX(CASE WHEN Movement.Num = 5 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber5
           , MAX(CASE WHEN Movement.Num = 6 THEN Movement.FromName ELSE NULL END)                       AS Name6
           , MAX(CASE WHEN Movement.Num = 6 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber6
           , MAX(CASE WHEN Movement.Num = 7 THEN Movement.FromName ELSE NULL END)                       AS Name7
           , MAX(CASE WHEN Movement.Num = 7 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber7
           , MAX(CASE WHEN Movement.Num = 8 THEN Movement.FromName ELSE NULL END)                       AS Name8
           , MAX(CASE WHEN Movement.Num = 8 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber8
           , MAX(CASE WHEN Movement.Num = 9 THEN Movement.FromName ELSE NULL END)                       AS Name9
           , MAX(CASE WHEN Movement.Num = 9 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber9
           , MAX(CASE WHEN Movement.Num = 10 THEN Movement.FromName ELSE NULL END)                       AS Name10
           , MAX(CASE WHEN Movement.Num = 10 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber10
           , MAX(CASE WHEN Movement.Num = 11 THEN Movement.FromName ELSE NULL END)                       AS Name11
           , MAX(CASE WHEN Movement.Num = 11 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber11
           , MAX(CASE WHEN Movement.Num = 12 THEN Movement.FromName ELSE NULL END)                       AS Name12
           , MAX(CASE WHEN Movement.Num = 12 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber12
           , MAX(CASE WHEN Movement.Num = 13 THEN Movement.FromName ELSE NULL END)                       AS Name13
           , MAX(CASE WHEN Movement.Num = 13 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber13
           , MAX(CASE WHEN Movement.Num = 14 THEN Movement.FromName ELSE NULL END)                       AS Name14
           , MAX(CASE WHEN Movement.Num = 14 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber14
           , MAX(CASE WHEN Movement.Num = 15 THEN Movement.FromName ELSE NULL END)                       AS Name15
           , MAX(CASE WHEN Movement.Num = 15 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber15
           , MAX(CASE WHEN Movement.Num = 16 THEN Movement.FromName ELSE NULL END)                       AS Name16
           , MAX(CASE WHEN Movement.Num = 16 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber16
           , MAX(CASE WHEN Movement.Num = 17 THEN Movement.FromName ELSE NULL END)                       AS Name17
           , MAX(CASE WHEN Movement.Num = 17 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber17
           , MAX(CASE WHEN Movement.Num = 18 THEN Movement.FromName ELSE NULL END)                       AS Name18
           , MAX(CASE WHEN Movement.Num = 18 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber18
           , MAX(CASE WHEN Movement.Num = 19 THEN Movement.FromName ELSE NULL END)                       AS Name19
           , MAX(CASE WHEN Movement.Num = 19 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber19
           , MAX(CASE WHEN Movement.Num = 20 THEN Movement.FromName ELSE NULL END)                       AS Name20
           , MAX(CASE WHEN Movement.Num = 20 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber20
           , MAX(CASE WHEN Movement.Num = 21 THEN Movement.FromName ELSE NULL END)                       AS Name21
           , MAX(CASE WHEN Movement.Num = 21 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber21
           , MAX(CASE WHEN Movement.Num = 22 THEN Movement.FromName ELSE NULL END)                       AS Name22
           , MAX(CASE WHEN Movement.Num = 22 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber22
           , MAX(CASE WHEN Movement.Num = 23 THEN Movement.FromName ELSE NULL END)                       AS Name23
           , MAX(CASE WHEN Movement.Num = 23 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber23
           , MAX(CASE WHEN Movement.Num = 24 THEN Movement.FromName ELSE NULL END)                       AS Name24
           , MAX(CASE WHEN Movement.Num = 24 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber24
           , MAX(CASE WHEN Movement.Num = 25 THEN Movement.FromName ELSE NULL END)                       AS Name25
           , MAX(CASE WHEN Movement.Num = 25 THEN Movement.InvNumber ELSE NULL END)   AS InvNumber25
           , CAST(MAX(Movement.Num) AS INTEGER)                                                          AS ColCount
      FROM tmpMovement AS Movement
      WHERE Num<26
--       ORDER BY Num
       ;
     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
     WITH
     tmpMovement_All AS (SELECT Movement.Id                      AS Id
                              , MovementItem.Id                  AS MovementItemId
                              , Movement.FromId                  AS FromId
                              , Movement.FromCode                AS FromCode
                              , Movement.FromName                AS FromName
                              , Movement.ToId                    AS ToId
                              , Movement.ToName                  AS ToName
                              , Movement.RouteId                 AS RouteId
                              , Movement.RouteName               AS RouteName
                              , Movement.RouteSortingId          AS RouteSortingId
                              , Movement.RouteSortingCode        AS RouteSortingCode
                              , Movement.RouteSortingName        AS RouteSortingName
                              , Movement.PaidKindId              AS PaidKindId
                              , Movement.PaidKindName            AS PaidKindName
                              , MovementItem.ObjectId            AS GoodsId
                              , Movement.Num                     AS Num
                              , SUM (MovementItem.Amount)        AS Amount
                          FROM tmpMovement AS Movement
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                              INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
                          GROUP BY
                                Movement.Id
                              , Movement.FromId
                              , Movement.FromCode
                              , Movement.FromName
                              , Movement.ToId 
                              , Movement.ToName 
                              , Movement.RouteId 
                              , Movement.RouteName
                              , Movement.RouteSortingId
                              , Movement.RouteSortingCode
                              , Movement.RouteSortingName
                              , Movement.PaidKindId
                              , Movement.PaidKindName
                              , MovementItem.ObjectId
                              , MovementItem.Id
                              , Movement.Num
                          )
   , tmpGoodsKind AS (SELECT MILinkObject_GoodsKind.MovementItemId  AS MovementItemId
                           , MILinkObject_GoodsKind.ObjectId        AS GoodsKindId
                      FROM MovementItemLinkObject AS MILinkObject_GoodsKind
                      WHERE MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                        AND MILinkObject_GoodsKind.MovementItemId IN (SELECT DISTINCT tmpMovement_All.MovementItemId FROM tmpMovement_All)
                      )                  
   , tmpMovement AS (SELECT Movement.Id                               AS Id
                          , Movement.FromId                           AS FromId
                          , Movement.FromCode                         AS FromCode
                          , Movement.FromName                         AS FromName
                          , Movement.ToId                             AS ToId
                          , Movement.ToName                           AS ToName
                          , Movement.RouteId                          AS RouteId
                          , Movement.RouteName                        AS RouteName
                          , Movement.RouteSortingId                   AS RouteSortingId
                          , Movement.RouteSortingCode                 AS RouteSortingCode
                          , Movement.RouteSortingName                 AS RouteSortingName
                          , Movement.PaidKindId                       AS PaidKindId
                          , Movement.PaidKindName                     AS PaidKindName
                          , tmpGoodsKind.GoodsKindId                  AS GoodsKindId
                          , Movement.GoodsId                          AS GoodsId
                          , SUM(CASE WHEN Movement.Num = 1 THEN Movement.Amount ELSE 0 END)       AS Amount1
                          , SUM(CASE WHEN Movement.Num = 2 THEN Movement.Amount ELSE 0 END)       AS Amount2
                          , SUM(CASE WHEN Movement.Num = 3 THEN Movement.Amount ELSE 0 END)       AS Amount3
                          , SUM(CASE WHEN Movement.Num = 4 THEN Movement.Amount ELSE 0 END)       AS Amount4
                          , SUM(CASE WHEN Movement.Num = 5 THEN Movement.Amount ELSE 0 END)       AS Amount5
                          , SUM(CASE WHEN Movement.Num = 6 THEN Movement.Amount ELSE 0 END)       AS Amount6
                          , SUM(CASE WHEN Movement.Num = 7 THEN Movement.Amount ELSE 0 END)       AS Amount7
                          , SUM(CASE WHEN Movement.Num = 8 THEN Movement.Amount ELSE 0 END)       AS Amount8
                          , SUM(CASE WHEN Movement.Num = 9 THEN Movement.Amount ELSE 0 END)       AS Amount9
                          , SUM(CASE WHEN Movement.Num = 10 THEN Movement.Amount ELSE 0 END)      AS Amount10
                          , SUM(CASE WHEN Movement.Num = 11 THEN Movement.Amount ELSE 0 END)      AS Amount11
                          , SUM(CASE WHEN Movement.Num = 12 THEN Movement.Amount ELSE 0 END)      AS Amount12
                          , SUM(CASE WHEN Movement.Num = 13 THEN Movement.Amount ELSE 0 END)      AS Amount13
                          , SUM(CASE WHEN Movement.Num = 14 THEN Movement.Amount ELSE 0 END)      AS Amount14
                          , SUM(CASE WHEN Movement.Num = 15 THEN Movement.Amount ELSE 0 END)      AS Amount15
                          , SUM(CASE WHEN Movement.Num = 16 THEN Movement.Amount ELSE 0 END)      AS Amount16
                          , SUM(CASE WHEN Movement.Num = 17 THEN Movement.Amount ELSE 0 END)      AS Amount17
                          , SUM(CASE WHEN Movement.Num = 18 THEN Movement.Amount ELSE 0 END)      AS Amount18
                          , SUM(CASE WHEN Movement.Num = 19 THEN Movement.Amount ELSE 0 END)      AS Amount19
                          , SUM(CASE WHEN Movement.Num = 20 THEN Movement.Amount ELSE 0 END)      AS Amount20
                          , SUM(CASE WHEN Movement.Num = 21 THEN Movement.Amount ELSE 0 END)      AS Amount21
                          , SUM(CASE WHEN Movement.Num = 22 THEN Movement.Amount ELSE 0 END)      AS Amount22
                          , SUM(CASE WHEN Movement.Num = 23 THEN Movement.Amount ELSE 0 END)      AS Amount23
                          , SUM(CASE WHEN Movement.Num = 24 THEN Movement.Amount ELSE 0 END)      AS Amount24
                          , SUM(CASE WHEN Movement.Num = 25 THEN Movement.Amount ELSE 0 END)      AS Amount25
                          , SUM(CASE WHEN Movement.Num > 25 THEN Movement.Amount ELSE 0 END)      AS AmountOther
                          , SUM(Movement.Amount)                                                  AS AmountTotal
                     FROM tmpMovement_All AS Movement
                          LEFT JOIN tmpGoodsKind ON tmpGoodsKind.MovementItemId = Movement.MovementItemId
                     GROUP BY Movement.Id
                            , Movement.FromId
                            , Movement.FromCode 
                            , Movement.FromName
                            , Movement.ToId 
                            , Movement.ToName 
                            , Movement.RouteId 
                            , Movement.RouteName
                            , Movement.RouteSortingId
                            , Movement.RouteSortingCode
                            , Movement.RouteSortingName
                            , Movement.PaidKindId
                            , Movement.PaidKindName
                            , tmpGoodsKind.GoodsKindId
                            , Movement.GoodsId
                     )

   , tmpGoods AS (SELECT Object_Goods.Id                            AS GoodsId
                       , Object_Goods.ObjectCode                    AS GoodsCode
                       , Object_Goods.ValueData                     AS GoodsName
                       , Object_Measure.ValueData                   AS MeasureName
                       , Object_GoodsGroup.ValueData                AS GoodsGroupName
                       , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
                       , Object_InfoMoney.ValueData                 AS InfoMoneyName
                  FROM _tmpGoods
                       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpGoods.GoodsId
          
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                                       AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                       LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                            ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                           AND ObjectLink_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
                       LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
                       LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                              ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                             AND ObjectString_Goods_GroupNameFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
             
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                            ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                           AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                       LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Goods_InfoMoney.ChildObjectId
                  )
       -- результат
       SELECT tmpMovement.Id                 AS Id
            , tmpMovement.FromId             AS FromId
            , tmpMovement.FromCode           AS FromCode
            , tmpMovement.FromName           AS FromName
            , tmpMovement.ToId               AS ToId
            , tmpMovement.ToName             AS ToName
            , tmpMovement.RouteId            AS RouteId
            , tmpMovement.RouteName          AS RouteName
            , tmpMovement.RouteSortingId     AS RouteSortingId
            , tmpMovement.RouteSortingCode   AS RouteSortingCode
            , tmpMovement.RouteSortingName   AS RouteSortingName
            , Object_GoodsKind.Id            AS GoodsKindId
            , Object_GoodsKind.ValueData     AS GoodsKindName
            , tmpGoods.GoodsId               AS GoodsId
            , tmpGoods.GoodsCode             AS GoodsCode
            , tmpGoods.GoodsName             AS GoodsName
            , tmpGoods.MeasureName           AS MeasureName
            , tmpGoods.GoodsGroupName        AS GoodsGroupName
            , tmpGoods.GoodsGroupNameFull    AS GoodsGroupNameFull
            , tmpGoods.InfoMoneyName         AS InfoMoneyName
            , tmpMovement.Amount1            AS Amount1
            , tmpMovement.Amount2            AS Amount2
            , tmpMovement.Amount3            AS Amount3
            , tmpMovement.Amount4            AS Amount4
            , tmpMovement.Amount5            AS Amount5
            , tmpMovement.Amount6            AS Amount6
            , tmpMovement.Amount7            AS Amount7
            , tmpMovement.Amount8            AS Amount8
            , tmpMovement.Amount9            AS Amount9
            , tmpMovement.Amount10           AS Amount10
            , tmpMovement.Amount11           AS Amount11
            , tmpMovement.Amount12           AS Amount12
            , tmpMovement.Amount13           AS Amount13
            , tmpMovement.Amount14           AS Amount14
            , tmpMovement.Amount15           AS Amount15
            , tmpMovement.Amount16           AS Amount16
            , tmpMovement.Amount17           AS Amount17
            , tmpMovement.Amount18           AS Amount18
            , tmpMovement.Amount19           AS Amount19
            , tmpMovement.Amount20           AS Amount20
            , tmpMovement.Amount21           AS Amount21
            , tmpMovement.Amount22           AS Amount22
            , tmpMovement.Amount23           AS Amount23
            , tmpMovement.Amount24           AS Amount24
            , tmpMovement.Amount25           AS Amount25
            , tmpMovement.AmountOther        AS AmountOther
            , tmpMovement.AmountTotal        AS AmountTotal
       FROM tmpMovement
          LEFT JOIN tmpGoods ON tmpGoods.GoodsId = tmpMovement.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMovement.GoodsKindId
         ;
     RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpReport_OrderExternal_Cross (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 26.07.17         * add inJuridicalId, inRetailId
 20.09.14                                                        *

*/


 --SELECT * FROM gpReport_OrderExternal_Cross (inStartDate:= '29.02.2016', inEndDate:= '29.02.2016', inJuridicalId := 15158 , inRetailId := 0, inFromId := 0, inToId := 0, inRouteId := 0, inRouteSortingId := 0, inGoodsGroupId := 0, inIsByDoc := False, inSession:= '2');
 --FETCH ALL "<unnamed portal 1>";

