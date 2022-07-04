-- Function: gpReport_OrderExternal_UpdatePrint()

DROP FUNCTION IF EXISTS gpReport_OrderExternal_UpdatePrint (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderExternal_UpdatePrint(
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
     
 CREATE TEMP TABLE _Result (RouteId Integer, RetailId Integer, AmountWeight TFloat, Count_Partner TFloat, OperDate_CarInfo TDateTime, GroupPrint Integer, Ord Integer,OperDate_inf TVarChar
                           ) ON COMMIT DROP;
 INSERT INTO _Result(RouteId, RetailId, AmountWeight, Count_Partner, OperDate_CarInfo, GroupPrint, Ord, OperDate_inf) 
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
                                 -- AND MovementDate_CarInfo.ValueData < vbEndDate
                                  AND Movement.OperDate <= CURRENT_DATE + INTERVAL '1 DAY'
                                  AND inIsDate_CarInfo = TRUE
                                ) AS Movement
                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                         AND (COALESCE (MovementLinkObject_To.ObjectId,0) = inToId OR inToId = 0)
                           )

     , tmpMovement AS (SELECT MovementLinkObject_Route.ObjectId   AS RouteId
                            , CASE WHEN Object_From.DescId = zc_Object_Unit()
                                        THEN Object_From.Id
                                   -- временно
                                   WHEN Object_Route.ValueData ILIKE 'Маршрут №%'
                                     OR Object_Route.ValueData ILIKE 'Самов%'
                                     OR Object_Route.ValueData ILIKE '%-колбаса'
                                     OR Object_Route.ValueData ILIKE '%Кривой Рог%'
                                           THEN 0
                                   ELSE ObjectLink_Juridical_Retail.ChildObjectId
                              END AS RetailId
                            , SUM ((COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))
                                   * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeight
                            , COUNT (DISTINCT Object_From.Id) AS CountPartner
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
                
                            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
                
                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = FALSE
                 
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond() 
                
                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                  ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                
                       GROUP BY MovementLinkObject_Route.ObjectId
                              , CASE WHEN Object_From.DescId = zc_Object_Unit()
                                          THEN Object_From.Id
                                     -- временно
                                     WHEN Object_Route.ValueData ILIKE 'Маршрут №%'
                                       OR Object_Route.ValueData ILIKE 'Самов%'
                                       OR Object_Route.ValueData ILIKE '%-колбаса'
                                       OR Object_Route.ValueData ILIKE '%Кривой Рог%'
                                          THEN 0
                                     ELSE ObjectLink_Juridical_Retail.ChildObjectId
                                END
                              , MovementDate_CarInfo.ValueData
                              , Movement.GroupPrint
                       )
     , tmpTime AS (SELECT  tmp.GroupPrint
				         , tmp.OperDate_CarInfo
                         , ROW_NUMBER () OVER (PARTITION BY tmp.GroupPrint ORDER BY tmp.OperDate_CarInfo) AS Ord
                   FROM (SELECT DISTINCT tmpMovement.GroupPrint, tmpMovement.OperDate_CarInfo FROM tmpMovement) AS tmp
                   )
      SELECT tmpMovement.*
           , tmpTime.Ord
		   ,(CASE WHEN EXTRACT (DAY FROM tmpTime.OperDate_CarInfo) < 10 THEN '0' ELSE '' END || EXTRACT (DAY FROM tmpTime.OperDate_CarInfo) :: TVarChar
    || '.' || CASE WHEN EXTRACT (MONTH FROM tmpTime.OperDate_CarInfo) < 10 THEN '0' ELSE '' END || EXTRACT (MONTH FROM tmpTime.OperDate_CarInfo) :: TVarChar
	|| CHR (13) || zfConvert_TimeShortToString (tmpTime.OperDate_CarInfo)) AS OperDate_inf
      FROM tmpMovement
          LEFT JOIN tmpTime ON tmpTime.OperDate_CarInfo = tmpMovement.OperDate_CarInfo
		                   AND tmpTime.GroupPrint = tmpMovement.GroupPrint
       ;


     OPEN Cursor1 FOR
       WITH
       tmp AS (SELECT _Result.GroupPrint
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
               ) 

       SELECT tmp.GroupPrint
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
       FROM tmp
       GROUP BY tmp.GroupPrint
	   ORDER BY tmp.GroupPrint
       ;
     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR    --все в 1 запросе,  через 2 курсора не получилосьшапку вывести
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
					 
       SELECT Object_Route.Id                     AS RouteId 
           , Object_Route.ValueData               AS RouteName
           , Object_Retail.Id                     AS RetailId
           , Object_Retail.ValueData  :: TVarChar AS RetailName
           , _Result.OperDate_CarInfo ::TDateTime AS OperDate_CarInfo
           , _Result.AmountWeight     :: TFloat   AS AmountWeight
           , _Result.Count_Partner    :: TFloat   AS Count_Partner
           , _Result.Ord
           , tmpColumn.*
       FROM _Result
          LEFT JOIN Object AS Object_Route ON Object_Route.Id = _Result.RouteId
          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = _Result.RetailId
		  LEFT JOIN tmpColumn ON tmpColumn.GroupPrint = _Result.GroupPrint
	   ORDER BY _Result.GroupPrint
	          , _Result.OperDate_CarInfo
			  , Object_Route.ValueData
              , Object_Retail.ValueData
      ;
     RETURN NEXT Cursor2;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.07.22         *
*/

-- тест
--     SELECT * FROM gpReport_OrderExternal_UpdatePrint (inStartDate:= '15.06.2022', inEndDate:= '15.06.2022', inIsDate_CarInfo:= FALSE, inToId := 346093 ,  inSession := '9457');

--select * from gpReport_OrderExternal_UpdatePrint(inStartDate := ('28.06.2022')::TDateTime , inEndDate := ('27.06.2022')::TDateTime , inIsDate_CarInfo := 'true' , inToId := 8459  ,  inSession := '5');
--FETCH ALL "<unnamed portal 27>";
