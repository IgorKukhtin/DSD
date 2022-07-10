-- Function: gpReport_OrderExternal_UpdatePrint()

DROP FUNCTION IF EXISTS gpReport_OrderExternal_UpdatePrint (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderExternal_UpdatePrint(
    IN inStartDate         TDateTime , -- 
    IN inEndDate           TDateTime , -- 
    IN inIsDate_CarInfo    Boolean   , -- ��  ����  ����/����� ��������
    IN inToId              Integer   , -- ���� (� ���������)
    IN inSession           TVarChar    -- ������ ������������
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
     vbEndDate   := ((inStartDate + INTERVAL'1 Day' )::Date||' 7:59') :: TDateTime; 
     
     -- ���������
     CREATE TEMP TABLE _Result (RouteId Integer, RetailId Integer, AmountWeight TFloat, Count_Partner TFloat
                              , OperDate TDateTime, OperDate_CarInfo TDateTime, OperDate_CarInfo_date TDateTime
                              , GroupPrint Integer, Ord Integer, OperDate_inf TVarChar
                              , StartWeighing TDateTime, EndWeighing TDateTime
                               ) ON COMMIT DROP;
     --
     WITH 
       -- ������
       tmpMovementAll AS (SELECT Movement.*
                               , MovementLinkObject_To.ObjectId AS ToId 

                          FROM (SELECT Movement.*
                                       -- ����/����� ��������
                                     , COALESCE (MovementDate_CarInfo.ValueData, MovementDate_OperDatePartner.ValueData) AS OperDate_CarInfo 
                                       -- ���� �����
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
                                       -- ����/����� ��������
                                     , MovementDate_CarInfo.ValueData AS OperDate_CarInfo 
                                       -- ���� �����
                                     , CASE WHEN EXTRACT (HOUR FROM MovementDate_CarInfo.ValueData) < 8 THEN DATE_TRUNC ('DAY', MovementDate_CarInfo.ValueData) - INTERVAL '1 DAY'
                                            ELSE DATE_TRUNC ('DAY', MovementDate_CarInfo.ValueData)
                                       END  AS OperDate_CarInfo_date
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
                                                         AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                         AND MovementLinkObject_To.ObjectId   = inToId
                           )
       -- ������ ��� ������, ������ ����� �� ���. ��������
     , tmpGroupPrint AS (SELECT -- ���� �����
                                tmp.OperDate_CarInfo_date
                              , ROW_NUMBER() OVER (ORDER BY tmp.OperDate_CarInfo_date ASC) AS GroupPrint
                         FROM (SELECT DISTINCT tmpMovementAll.OperDate_CarInfo_date FROM tmpMovementAll
                              ) AS tmp
                        )
              -- ���������� � �/�
            , tmpNPP AS (SELECT -- ����/����� ��������
                                tmp.OperDate_CarInfo
                                -- ���� �����
                              , tmp.OperDate_CarInfo_date
                                -- � �/�
                              , ROW_NUMBER() OVER (PARTITION BY tmp.OperDate_CarInfo_date ORDER BY tmp.OperDate_CarInfo ASC) AS Ord
                         FROM (SELECT DISTINCT tmpMovementAll.OperDate_CarInfo , tmpMovementAll.OperDate_CarInfo_date FROM tmpMovementAll
                              ) AS tmp
                        )
       -- ����������� ����
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
     , tmpMovement AS (SELECT MIN (Movement.OperDate)             AS OperDate
                            , MovementLinkObject_Route.ObjectId   AS RouteId
                              -- 
                            , CASE WHEN Object_From.DescId = zc_Object_Unit()
                                        THEN Object_From.Id
                                   -- ��������
                                   WHEN Object_Route.ValueData ILIKE '������� �%'
                                     OR Object_Route.ValueData ILIKE '�����%'
                                     OR Object_Route.ValueData ILIKE '%-�������'
                                     OR Object_Route.ValueData ILIKE '%������ ���%'
                                           THEN 0
                                   ELSE ObjectLink_Juridical_Retail.ChildObjectId
                              END AS RetailId

                              -- �����
                            , SUM ((COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))
                                   * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeight
                              -- 
                            , COUNT (DISTINCT Object_From.Id) AS Count_Partner

                              -- 
                            , MIN (tmpWeighing.StartWeighing) AS StartWeighing
                            , MAX (tmpWeighing.EndWeighing)   AS EndWeighing

                              -- ����/����� ��������
                            , Movement.OperDate_CarInfo
                              -- ���� �����
                            , Movement.OperDate_CarInfo_date
                              -- ������ ��� ������
                            , tmpGroupPrint.GroupPrint
                              -- ���������� � �/�
                            , tmpNPP.Ord
                             
                       FROM tmpMovementAll AS Movement
                           
                            LEFT JOIN tmpWeighing   ON tmpWeighing.Id = Movement.Id

                            LEFT JOIN tmpGroupPrint ON tmpGroupPrint.OperDate_CarInfo_date = Movement.OperDate_CarInfo_date
                            LEFT JOIN tmpNPP        ON tmpNPP.OperDate_CarInfo             = Movement.OperDate_CarInfo
                
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
                
                            -- ������
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
                                     -- ��������
                                     WHEN Object_Route.ValueData ILIKE '������� �%'
                                       OR Object_Route.ValueData ILIKE '�����%'
                                       OR Object_Route.ValueData ILIKE '%-�������'
                                       OR Object_Route.ValueData ILIKE '%������ ���%'
                                          THEN 0
                                     ELSE ObjectLink_Juridical_Retail.ChildObjectId
                                END
                                -- ����/����� ��������
                              , Movement.OperDate_CarInfo
                                -- ���� �����
                              , Movement.OperDate_CarInfo_date
                                -- ������ ��� ������
                              , tmpGroupPrint.GroupPrint
                                -- ���������� � �/�
                              , tmpNPP.Ord
                       )
     -- ���������
     INSERT INTO _Result (RouteId, RetailId, AmountWeight, Count_Partner, OperDate, OperDate_CarInfo, OperDate_CarInfo_date, GroupPrint, Ord, OperDate_inf, StartWeighing, EndWeighing) 
         SELECT tmpMovement.RouteId, tmpMovement.RetailId, tmpMovement.AmountWeight, tmpMovement.Count_Partner
                -- ���� ������
              , tmpMovement.OperDate
                -- ����/����� ��������
              , tmpMovement.OperDate_CarInfo
                -- ���� �����
              , tmpMovement.OperDate_CarInfo_date
                --
              , tmpMovement.GroupPrint, tmpMovement.Ord

                -- !!!���������� � �������� �������!!!
              , (CASE WHEN EXTRACT (DAY   FROM tmpMovement.OperDate_CarInfo) < 10 THEN '0' ELSE '' END || EXTRACT (DAY   FROM tmpMovement.OperDate_CarInfo) :: TVarChar
       || '.' || CASE WHEN EXTRACT (MONTH FROM tmpMovement.OperDate_CarInfo) < 10 THEN '0' ELSE '' END || EXTRACT (MONTH FROM tmpMovement.OperDate_CarInfo) :: TVarChar
              || CASE WHEN tmpMovement.EndWeighing IS NOT NULL
                       AND EXTRACT (DAY FROM tmpMovement.OperDate_CarInfo) <> EXTRACT (DAY FROM tmpMovement.EndWeighing)
                       AND (tmpMovement.OperDate_CarInfo < tmpMovement.EndWeighing
                         OR 12 < EXTRACT (HOUR FROM tmpMovement.EndWeighing - tmpMovement.OperDate_CarInfo)
                           )
                      THEN '/'
                        || CASE WHEN EXTRACT (DAY   FROM tmpMovement.EndWeighing) < 10 THEN '0' ELSE '' END || EXTRACT (DAY   FROM tmpMovement.EndWeighing) :: TVarChar
                 || '.' || CASE WHEN EXTRACT (MONTH FROM tmpMovement.EndWeighing) < 10 THEN '0' ELSE '' END || EXTRACT (MONTH FROM tmpMovement.EndWeighing) :: TVarChar
                      ELSE ''
                 END

    ||CHR (13)|| zfConvert_TimeShortToString (tmpMovement.OperDate_CarInfo)
       || '/' || CASE WHEN tmpMovement.EndWeighing IS NOT NULL THEN zfConvert_TimeShortToString (tmpMovement.EndWeighing) ELSE '' END
                ) AS OperDate_inf
                  -- 
                , tmpMovement.StartWeighing
                  -- 
                , tmpMovement.EndWeighing
         FROM tmpMovement
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

     OPEN Cursor2 FOR    --��� � 1 �������,  ����� 2 ������� �� ��������������� �������
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
					 
       SELECT Object_Route.Id                          AS RouteId 
           , Object_Route.ValueData                    AS RouteName
           , Object_Retail.Id                          AS RetailId
           , Object_Retail.ValueData       :: TVarChar AS RetailName
           , _Result.OperDate              ::TDateTime AS OperDate
           , _Result.OperDate_CarInfo      ::TDateTime AS OperDate_CarInfo
           , _Result.OperDate_CarInfo_date ::TDateTime AS OperDate_CarInfo_date
           , tmpWeekDay.DayOfWeekName_Full ::TVarChar  AS DayOfWeekName_CarInfo
           , _Result.AmountWeight          :: TFloat   AS AmountWeight
           , _Result.Count_Partner         :: TFloat   AS Count_Partner

           , _Result.Ord                   :: Integer
           , tmpColumn.GroupPrint          :: Integer

           , tmpColumn.OperDate_CarInfo1   ::TVarChar
           , tmpColumn.OperDate_CarInfo2   ::TVarChar
           , tmpColumn.OperDate_CarInfo3   ::TVarChar
           , tmpColumn.OperDate_CarInfo4   ::TVarChar
           , tmpColumn.OperDate_CarInfo5   ::TVarChar
           , tmpColumn.OperDate_CarInfo6   ::TVarChar
           , tmpColumn.OperDate_CarInfo7   ::TVarChar
           , tmpColumn.OperDate_CarInfo8   ::TVarChar
           , tmpColumn.OperDate_CarInfo9   ::TVarChar
           , tmpColumn.OperDate_CarInfo10  ::TVarChar
           , tmpColumn.OperDate_CarInfo11  ::TVarChar
           , tmpColumn.OperDate_CarInfo12  ::TVarChar
       FROM _Result
          LEFT JOIN Object AS Object_Route ON Object_Route.Id = _Result.RouteId
          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = _Result.RetailId
	  LEFT JOIN tmpColumn ON tmpColumn.GroupPrint = _Result.GroupPrint
          LEFT JOIN zfCalc_DayOfWeekName (_Result.OperDate_CarInfo_date) AS tmpWeekDay ON 1=1
       ORDER BY _Result.GroupPrint
              , _Result.OperDate_CarInfo_date
              , _Result.OperDate_CarInfo
              , Object_Route.ValueData
              , Object_Retail.ValueData
               ;
     RETURN NEXT Cursor2;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.07.22         *
*/

-- ����
-- SELECT * FROM gpReport_OrderExternal_UpdatePrint (inStartDate:= CURRENT_DATE - INTERVAL '1 DAY', inEndDate:= NULL, inIsDate_CarInfo:= FALSE, inToId := 8459 ,  inSession := '5'); -- FETCH ALL "<unnamed portal 27>";
