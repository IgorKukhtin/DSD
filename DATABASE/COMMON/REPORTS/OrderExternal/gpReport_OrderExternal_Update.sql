-- Function: gpReport_OrderExternal_Update()

DROP FUNCTION IF EXISTS gpReport_OrderExternal_Update (TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_OrderExternal_Update (TDateTime, TDateTime, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_OrderExternal_Update (TDateTime, TDateTime, Boolean, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderExternal_Update(
    IN inStartDate         TDateTime , -- 
    IN inEndDate           TDateTime , -- 
    IN inIsDate_CarInfo    Boolean   , -- �� ����  ����/����� ��������  
    IN inisGoods           Boolean   , -- �� ������� - ���� ���������������
    IN inToId              Integer   , -- ���� (� ���������)
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (OperDate        TDateTime
             , OperDatePartner TDateTime
             , RouteId Integer, RouteName TVarChar
             , RetailId Integer, RetailName TVarChar
             , PartnerTagName TVarChar
             , OperDate_CarInfo TDateTime, OperDate_CarInfo_str TVarChar
             , CarInfoId Integer, CarInfoName TVarChar, CarComment TVarChar 
             , ToId Integer, ToCode Integer, ToName TVarChar  
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName  TVarChar
             , GoodsGroupNameFull TVarChar
             , Amount TFloat
             , AmountSh TFloat
             , AmountWeight TFloat
             , Count_Partner TFloat
             , Count_Doc TFloat
             , CountPartner TVarChar
             , Days Integer, Times TVarChar

             , DayOfWeekName          TVarChar
             , DayOfWeekName_Partner  TVarChar
             , DayOfWeekName_CarInfo  TVarChar

             , StartWeighing        TDateTime
             , EndWeighing          TDateTime
             , DayOfWeekName_StartW TVarChar
             , DayOfWeekName_EndW   TVarChar
             , Hours_EndW           TFloat
             , Hours_real           TFloat
              )  

AS
$BODY$
   DECLARE vbUserId Integer; 
BEGIN

     inIsDate_CarInfo:= TRUE;
     inEndDate:= inStartDate;


     RETURN QUERY
     WITH 
       tmpMovementAll AS (SELECT Movement.*
                               , MovementLinkObject_To.ObjectId AS ToId
                          FROM (SELECT Movement.*
                                FROM Movement    
                                WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                                  AND Movement.DescId = zc_Movement_OrderExternal()
                                  AND inIsDate_CarInfo = FALSE
                               UNION
                                SELECT Movement.*
                                FROM MovementDate AS MovementDate_CarInfo
                                     INNER JOIN Movement ON Movement.Id = MovementDate_CarInfo.MovementId
                                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                                                        AND Movement.DescId = zc_Movement_OrderExternal()
                                WHERE MovementDate_CarInfo.DescId = zc_MovementDate_CarInfo()
                                  AND MovementDate_CarInfo.ValueData >= inStartDate
                                --AND MovementDate_CarInfo.ValueData <= inEndDate
                                  AND inStartDate = inEndDate
                                --AND inStartDate >= CURRENT_DATE - INTERVAL '5 DAY'
                                  AND inIsDate_CarInfo = TRUE
                                ) AS Movement
                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                         AND (COALESCE (MovementLinkObject_To.ObjectId,0) = inToId OR inToId = 0)
                           )

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
     , tmpMovement AS (SELECT Movement.OperDate
                            , MovementDate_OperDatePartner.ValueData                   AS OperDatePartner
                            , Movement.ToId                                            AS ToId
                            , MovementLinkObject_Route.ObjectId                        AS RouteId
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
                            , STRING_AGG (DISTINCT CASE WHEN Object_Route.ValueData ILIKE '������� �%'
                                                          OR Object_Route.ValueData ILIKE '�����%'
                                                          OR Object_Route.ValueData ILIKE '%-�������' 
                                                          OR Object_Route.ValueData ILIKE '%������ ���%'
                                                        THEN Object_Retail.ValueData
                                                        ELSE ''
                                                   END, '; ') ::TVarChar AS Retail_list
                            , STRING_AGG (DISTINCT Object_PartnerTag.ValueData, '; ') ::TVarChar AS PartnerTagName
                            , MovementLinkObject_CarInfo.ObjectId                      AS CarInfoId
                            , MovementDate_CarInfo.ValueData               ::TDateTime AS OperDate_CarInfo 
                            , MovementString_CarComment.ValueData          ::TVarChar  AS CarComment 
                            
                            , CASE WHEN inisGoods = TRUE THEN MovementItem.ObjectId ELSE 0 END AS GoodsId
                            , CASE WHEN inisGoods = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) ELSE 0 END AS GoodsKindId
                            
                            --, SUM (COALESCE (MovementItem.Amount,0))                   AS Amount
                            --, SUM (COALESCE (MIFloat_AmountSecond.ValueData, 0) )      AS AmountSecond
                            , SUM (COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0)) AS Amount
                            , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountSh
                            , SUM ((COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))
                                   * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeight
                            , COUNT (DISTINCT Object_From.Id) AS CountPartner
                            , COUNT (DISTINCT Movement.Id) AS CountDoc
                            
                            , MIN (tmpWeighing.StartWeighing) AS StartWeighing, MAX (tmpWeighing.EndWeighing) AS EndWeighing

                       FROM tmpMovementAll AS Movement
                            LEFT JOIN tmpWeighing ON tmpWeighing.Id = Movement.Id

                            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                            LEFT JOIN MovementDate AS MovementDate_CarInfo
                                                   ON MovementDate_CarInfo.MovementId = Movement.Id
                                                  AND MovementDate_CarInfo.DescId = zc_MovementDate_CarInfo()

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

                        GROUP BY Movement.OperDate
                               , MovementDate_OperDatePartner.ValueData
                               , Movement.ToId
                               , MovementLinkObject_Route.ObjectId
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
                               , MovementLinkObject_CarInfo.ObjectId
                               , MovementDate_CarInfo.ValueData
                               , MovementString_CarComment.ValueData

                               , CASE WHEN inisGoods = TRUE THEN MovementItem.ObjectId ELSE 0 END
                               , CASE WHEN inisGoods = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) ELSE 0 END

                          )

 
       -- ���������
       SELECT
             tmpMovement.OperDate              AS OperDate
           , tmpMovement.OperDatePartner       AS OperDatePartner
           , Object_Route.Id                   AS RouteId 
           , Object_Route.ValueData            AS RouteName
           , Object_Retail.Id                  AS RetailId
           , CASE WHEN Object_Retail.Id > 0 THEN Object_Retail.ValueData ELSE tmpMovement.Retail_list END :: TVarChar AS RetailName
           , tmpMovement.PartnerTagName        AS PartnerTagName
           , tmpMovement.OperDate_CarInfo      ::TDateTime
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
             --
           , tmpMovement.Amount         :: TFloat  AS Amount 
           , tmpMovement.AmountSh       :: TFloat  AS AmountSh
           , tmpMovement.AmountWeight   :: TFloat  AS AmountWeight
           , tmpMovement.CountPartner   :: TFloat  AS Count_Partner
           , tmpMovement.CountDoc       :: TFloat  AS Count_Doc
         --, (zfConvert_IntToString (tmpMovement.CountPartner::integer) || ' / '  || zfConvert_IntToString (tmpMovement.CountDoc::integer))  :: TVarChar  AS CountPartner
           , (tmpMovement.CountPartner :: TVarChar || ' / '  || tmpMovement.CountDoc :: TVarChar) :: TVarChar  AS CountPartner

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
           
           , tmpWeekDay.DayOfWeekName         ::TVarChar AS DayOfWeekName
           , tmpWeekDay_Partner.DayOfWeekName ::TVarChar AS DayOfWeekName_Partner
           , tmpWeekDay_CarInfo.DayOfWeekName ::TVarChar AS DayOfWeekName_CarInfo
           
           , tmpMovement.StartWeighing :: TDateTime AS StartWeighing
           , tmpMovement.EndWeighing   :: TDateTime AS EndWeighing
           , tmpWeekDay_StartW.DayOfWeekName ::TVarChar AS DayOfWeekName_StartW
           , tmpWeekDay_EndW.DayOfWeekName   ::TVarChar AS DayOfWeekName_EndW

           , (EXTRACT (HOUR FROM tmpMovement.EndWeighing - tmpMovement.StartWeighing) )    ::TFloat AS Hours_EndW
           , (EXTRACT (HOUR FROM tmpMovement.EndWeighing - tmpMovement.OperDate_CarInfo) ) ::TFloat AS Hours_real

      FROM tmpMovement
          LEFT JOIN Object AS Object_To ON Object_To.Id = tmpMovement.ToId
          LEFT JOIN Object AS Object_Route ON Object_Route.Id = tmpMovement.RouteId
          LEFT JOIN Object AS Object_CarInfo ON Object_CarInfo.Id = tmpMovement.CarInfoId
          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = tmpMovement.RetailId 
          LEFT JOIN zfCalc_DayOfWeekName (tmpMovement.OperDate) AS tmpWeekDay ON 1=1
          LEFT JOIN zfCalc_DayOfWeekName (tmpMovement.OperDatePartner) AS tmpWeekDay_Partner ON 1=1
          LEFT JOIN zfCalc_DayOfWeekName (tmpMovement.OperDate_CarInfo) AS tmpWeekDay_CarInfo ON 1=1
          LEFT JOIN zfCalc_DayOfWeekName (tmpMovement.StartWeighing) AS tmpWeekDay_StartW ON 1=1
          LEFT JOIN zfCalc_DayOfWeekName (tmpMovement.EndWeighing) AS tmpWeekDay_EndW ON 1=1  
          
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMovement.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMovement.GoodsKindId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.06.22         *
*/

-- ����
--SELECT * FROM gpReport_OrderExternal_Update (inStartDate:= '15.06.2022', inEndDate:= '15.06.2022', inIsDate_CarInfo:= FALSE, inToId := 346093 ,  inSession := '9457');
