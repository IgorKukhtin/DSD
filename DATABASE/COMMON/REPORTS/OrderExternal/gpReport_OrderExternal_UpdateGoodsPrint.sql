-- Function: gpReport_OrderExternal_UpdateGoodsPrint()

DROP FUNCTION IF EXISTS gpReport_OrderExternal_UpdateGoodsPrint (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderExternal_UpdateGoodsPrint(
    IN inStartDate         TDateTime , -- 
    IN inEndDate           TDateTime , -- 
    IN inIsDate_CarInfo    Boolean   , -- по  дате  Дата/время отгрузки
    IN inToId              Integer   , -- Кому (в документе)
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer; 
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor; 
BEGIN

     inIsDate_CarInfo:= TRUE;
     inEndDate:= inStartDate; 
     

     vbStartDate := (inStartDate::Date ||' 8:00') :: TDateTime;
     vbEndDate := ((inStartDate+ INTERVAL '1 Day' )::Date||' 7:59') :: TDateTime; 
     
 CREATE TEMP TABLE _Result (GoodsId Integer, GoodsKindId Integer, RouteName Text, AmountWeight TFloat, Count_Partner TFloat, OperDate_CarInfo TDateTime, GroupPrint Integer, Ord Integer,OperDate_inf Text
                           ) ON COMMIT DROP;
 INSERT INTO _Result(GoodsId, GoodsKindId, RouteName, AmountWeight, Count_Partner, OperDate_CarInfo, GroupPrint, Ord, OperDate_inf) 
     WITH 
       tmpMovementAll AS (SELECT Movement.*
                               , MovementLinkObject_To.ObjectId AS ToId 

                          FROM (SELECT Movement.*
                                     , EXTRACT (DAY FROM (Movement.OperDate - inStartDate)) + 1  AS GroupPrint     --группа для печати, каждый день а отд. старничке
                                FROM Movement    
                                WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                                  AND Movement.DescId = zc_Movement_OrderExternal()
                                  AND inIsDate_CarInfo = FALSE
                               UNION
                                SELECT Movement.*
                                     , EXTRACT (DAY FROM (MovementDate_CarInfo.ValueData - vbStartDate)) + 1  AS GroupPrint     --группа для печати, каждый день а отд. старничке
                                FROM MovementDate AS MovementDate_CarInfo
                                     INNER JOIN Movement ON Movement.Id = MovementDate_CarInfo.MovementId
                                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                                                        AND Movement.DescId = zc_Movement_OrderExternal()
                                WHERE MovementDate_CarInfo.DescId = zc_MovementDate_CarInfo()
                                  AND MovementDate_CarInfo.ValueData >= vbStartDate
                                  AND MovementDate_CarInfo.ValueData <= vbEndDate
                                  --AND Movement.OperDate <= CURRENT_DATE + INTERVAL '1 DAY'
                                  AND inIsDate_CarInfo = TRUE
                                ) AS Movement
                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                         AND (COALESCE (MovementLinkObject_To.ObjectId,0) = inToId OR inToId = 0)
                           )

     , tmpMI AS (SELECT MovementItem.*
                 FROM MovementItem
                 WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovementAll.Id FROM tmpMovementAll)               
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.isErased   = FALSE
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

     , tmpMovement AS (SELECT MovementItem.ObjectId AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId
                           -- , STRING_AGG ( Object_Route.ValueData, '; ' ) AS RouteName
                            , Object_Route.ValueData AS RouteName
                            ,  ((COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))
                                   * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeight
                            --, COUNT (DISTINCT Object_From.Id) AS Count_Partner  
                            , Object_From.Id AS FromId
                            , MovementDate_CarInfo.ValueData               ::TDateTime AS OperDate_CarInfo
                            , Movement.GroupPrint
                             
                       FROM tmpMovementAll AS Movement
                            LEFT JOIN MovementDate AS MovementDate_CarInfo
                                                   ON MovementDate_CarInfo.MovementId = Movement.Id
                                                  AND MovementDate_CarInfo.DescId = zc_MovementDate_CarInfo()
                
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                                         ON MovementLinkObject_Route.MovementId = Movement.Id
                                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
                            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId
                
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
                
                       /*GROUP BY MovementDate_CarInfo.ValueData
                              , Movement.GroupPrint
                              , MovementItem.ObjectId
                              , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis())    */
                              
                       )
     , tmpDist AS (SELECT tmp.GroupPrint
      			        , tmp.OperDate_CarInfo 
      			        , ROW_NUMBER () OVER (PARTITION BY tmp.GroupPrint ORDER BY tmp.OperDate_CarInfo) AS Ord
      			        , (CASE WHEN EXTRACT (DAY FROM tmp.OperDate_CarInfo) < 10 THEN '0' ELSE '' END || EXTRACT (DAY FROM tmp.OperDate_CarInfo) :: TVarChar
                 || '.' || CASE WHEN EXTRACT (MONTH FROM tmp.OperDate_CarInfo) < 10 THEN '0' ELSE '' END || EXTRACT (MONTH FROM tmp.OperDate_CarInfo) :: TVarChar
                 || '  ' || zfConvert_TimeShortToString (tmp.OperDate_CarInfo) 
             	|| CHR (13) || tmp.RouteName  :: Text   
             	          ) :: Text AS OperDate_inf
                   FROM (SELECT tmpMovement.GroupPrint
      			              , tmpMovement.OperDate_CarInfo
                              , STRING_AGG (tmpMovement.RouteName, '; ' ) AS RouteName
                         FROM (SELECT DISTINCT
                                      tmpMovement.GroupPrint
            			            , tmpMovement.OperDate_CarInfo
                                    , tmpMovement.RouteName
                               FROM tmpMovement
                               ) AS tmpMovement                                             
                         GROUP BY tmpMovement.GroupPrint
      			                , tmpMovement.OperDate_CarInfo
                         ) AS tmp
                   ) 

     , tmpTime AS (SELECT  tmp.GroupPrint
				         , tmp.OperDate_CarInfo
                         , ROW_NUMBER () OVER (PARTITION BY tmp.GroupPrint ORDER BY tmp.OperDate_CarInfo) AS Ord
                   FROM (SELECT DISTINCT tmpMovement.GroupPrint, tmpMovement.OperDate_CarInfo FROM tmpMovement) AS tmp
                   )

     , tmpMov AS (SELECT tmpMovement.GoodsId
                       , tmpMovement.GoodsKindId
                       , STRING_AGG ( tmpMovement.RouteName, '; ' ) AS RouteName
                       , SUM (tmpMovement.AmountWeight) AS AmountWeight
                       , COUNT (DISTINCT tmpMovement.FromId) AS Count_Partner
                       , tmpMovement.OperDate_CarInfo
                       , tmpMovement.GroupPrint
                  FROM tmpMovement
                  GROUP BY tmpMovement.GoodsId
                       , tmpMovement.GoodsKindId
                       , tmpMovement.OperDate_CarInfo
                       , tmpMovement.GroupPrint
                 )


      SELECT tmpMovement.*
           , tmpDist.Ord
		   , tmpDist.OperDate_inf :: Text AS OperDate_inf
      FROM tmpMov AS tmpMovement
          LEFT JOIN tmpDist ON tmpDist.OperDate_CarInfo = tmpMovement.OperDate_CarInfo
		                   AND tmpDist.GroupPrint = tmpMovement.GroupPrint
		  
       ;

     OPEN Cursor1 FOR    --все в 1 запросе,  через 2 курсора не получилосьшапку вывести
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
                         --, STRING_AGG (DISTINCT tmp.RouteName, '; ' )     :: Text AS RouteName
                         , SUM (tmp.Count_Partner)   :: TFloat   AS Count_Partner
                         , SUM (tmp.AmountWeight1)  AS AmountWeight1
                         , SUM (tmp.AmountWeight2)  AS AmountWeight2 
                         , SUM (tmp.AmountWeight3)  AS AmountWeight3 
                         , SUM (tmp.AmountWeight4)  AS AmountWeight4 
                         , SUM (tmp.AmountWeight5)  AS AmountWeight5 
                         , SUM (tmp.AmountWeight6)  AS AmountWeight6 
                         , SUM (tmp.AmountWeight7)  AS AmountWeight7 
                         , SUM (tmp.AmountWeight8)  AS AmountWeight8 
                         , SUM (tmp.AmountWeight9)  AS AmountWeight9 
                         , SUM (tmp.AmountWeight10)  AS AmountWeight10
                         , SUM (tmp.AmountWeight11)  AS AmountWeight11
                         , SUM (tmp.AmountWeight12)  AS AmountWeight12
                         , SUM (tmp.AmountWeight)    AS AmountWeight
                    FROM (SELECT _Result.GoodsId
                         , _Result.GoodsKindId                                                    
                         , _Result.GroupPrint
                         --, _Result.RouteName     :: Text AS RouteName
                         , (_Result.Count_Partner)   :: TFloat   AS Count_Partner
                         , _Result.AmountWeight
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
                    FROM  _Result
                    ) AS tmp
                    GROUP BY tmp.GoodsId
                           , tmp.GoodsKindId                                                    
                           , tmp.GroupPrint
                    )   
                    
       SELECT Object_Goods.Id                         AS GoodsId 
            , Object_Goods.ObjectCode                 AS GoodsCode 
            , Object_Goods.ValueData                  AS GoodsName
            , Object_GoodsKind.Id                     AS GoodsKindId
            , Object_GoodsKind.ValueData  :: TVarChar AS GoodsKindName
          --  , tmpGroup.RouteName           :: Text
            , tmpGroup.Count_Partner    :: TFloat   AS Count_Partner
            , tmpColumn.*
            , tmpGroup.AmountWeight
            , tmpGroup.AmountWeight1  :: TFloat
            , tmpGroup.AmountWeight2  :: TFloat
            , tmpGroup.AmountWeight3  :: TFloat
            , tmpGroup.AmountWeight4  :: TFloat
            , tmpGroup.AmountWeight5  :: TFloat
            , tmpGroup.AmountWeight6  :: TFloat
            , tmpGroup.AmountWeight7  :: TFloat
            , tmpGroup.AmountWeight8  :: TFloat
            , tmpGroup.AmountWeight9  :: TFloat
            , tmpGroup.AmountWeight10 :: TFloat
            , tmpGroup.AmountWeight11 :: TFloat
            , tmpGroup.AmountWeight12 :: TFloat

       FROM tmpGroup
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGroup.GoodsKindId
		  LEFT JOIN tmpColumn ON tmpColumn.GroupPrint = tmpGroup.GroupPrint

where   Object_Goods.ObjectCode = 101
	   ORDER BY tmpGroup.GroupPrint
			  , Object_Goods.ValueData
              , Object_GoodsKind.ValueData
      ;
     RETURN NEXT Cursor1;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.07.22         *
*/

-- тест
-- SELECT * FROM gpReport_OrderExternal_UpdateGoodsPrint (inStartDate:= '15.06.2022', inEndDate:= '15.06.2022', inIsDate_CarInfo:= FALSE, inToId := 346093 ,  inSession := '9457');

--select * from gpReport_OrderExternal_UpdateGoodsPrint(inStartDate := ('28.06.2022')::TDateTime , inEndDate := ('27.06.2022')::TDateTime , inIsDate_CarInfo := 'true' , inToId := 8459  ,  inSession := '5');
--FETCH ALL "<unnamed portal 27>";
