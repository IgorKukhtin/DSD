-- Function: gpSelect_MovementItem_ServiceItem_onDate()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ServiceItem (Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ServiceItem (Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS gpMovementItem_ServiceItem_SetUnErased (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpMovementItem_ServiceItem_SetErased (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ServiceItem (Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_ServiceItem (Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ServiceItem_onDate (TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_ServiceItem_onDate (TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_ServiceItem_onDate (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ServiceItem_onDate(
    IN inOperDate         TDateTime , --
    IN inUnitId           Integer   , 
    IN inInfoMoneyId      Integer   ,
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber Integer
             , Id Integer
             , UnitId Integer, UnitCode Integer, UnitName TVarChar, UnitName_Full TVarChar
             , UnitGroupNameFull TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyCode Integer, CommentInfoMoneyName TVarChar

             , DateStart TDateTime, DateStart_month TDateTime, DateEnd TDateTime, DateEnd_month TDateTime
             , Amount TFloat, Price TFloat, Area TFloat
             , Month_diff Integer

             , DateStart_before TDateTime, DateStart_before_month TDateTime, DateEnd_before TDateTime, DateEnd_before_month TDateTime
             , Amount_before TFloat, Price_before TFloat, Area_before TFloat
             , Month_diff_before Integer

             , DateStart_after TDateTime, DateStart_after_month TDateTime, DateEnd_after TDateTime, DateEnd_after_month TDateTime
             , Amount_after TFloat, Price_after TFloat, Area_after TFloat
             , Month_diff_after Integer

             , isErased Boolean 
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_ServiceItem());
     vbUserId:= lpGetUserBySession (inSession);

     --
     inOperDate := CASE WHEN inOperDate IS NULL THEN CURRENT_DATE ELSE inOperDate END;

          -- ���������
         RETURN QUERY
          WITH
          -- ������ ���
          tmpMI_All AS (SELECT tmp.*
                        FROM  (SELECT MovementItem.MovementId
                                    , Movement.OperDate
                                    , Movement.OperDate AS DateEnd
                                    , Movement.InvNumber
                                    , MovementItem.Id                 AS MovementItemId
                                    , MovementItem.ObjectId           AS UnitId
                                    , MILinkObject_InfoMoney.ObjectId AS InfoMoneyId
                                    , MovementItem.Amount
                                    , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, MILinkObject_InfoMoney.ObjectId ORDER BY COALESCE (Movement.OperDate, zc_DateEnd()) DESC) AS Ord
                               FROM Movement
                                    INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                           AND MovementItem.DescId     = zc_MI_Master()
                                                           AND MovementItem.isErased   = FALSE
                                                           AND (MovementItem.ObjectId = inUnitId OR inUnitId = 0)

                                    INNER JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                      ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                                                     AND (MILinkObject_InfoMoney.ObjectId = inInfoMoneyId OR inInfoMoneyId = 0)
                               WHERE Movement.DescId = zc_Movement_ServiceItem()
                                 AND Movement.StatusId IN (zc_Enum_Status_Complete()) -- , zc_Enum_Status_UnComplete()
                               --AND Movement.OperDate > inOperDate
                              ) AS tmp
                       )

    , tmpMI_find AS (SELECT MovementItem.UnitId
                          , MovementItem.InfoMoneyId
                          , MovementItem.DateEnd
                          , MovementItem.Amount
                          , MovementItem.MovementItemId
                          , MovementItem.MovementId
                          , MovementItem.OperDate
                          , MovementItem.InvNumber
                          , MovementItem.Ord
                          , COALESCE (tmp_before.Ord, 0) AS Ord_before
                     FROM tmpMI_All AS MovementItem
                          LEFT JOIN tmpMI_All AS tmp_before
                                              ON tmp_before.UnitId      = MovementItem.UnitId
                                             AND tmp_before.InfoMoneyId = MovementItem.InfoMoneyId
                                             -- !!!����������
                                             AND tmp_before.Ord         = MovementItem.Ord + 1
                     WHERE MovementItem.DateEnd >= inOperDate
                       AND COALESCE (tmp_before.DateEnd, zc_DateStart()) < inOperDate
                    )
         , tmpMI AS (SELECT tmpMI_find.UnitId
                          , tmpMI_find.InfoMoneyId
                          , tmpMI_find.DateEnd
                          , tmpMI_find.Amount
                          , tmpMI_find.MovementItemId
                          , tmpMI_find.MovementId
                          , tmpMI_find.OperDate
                          , tmpMI_find.InvNumber
                          , tmpMI_find.Ord
                          , tmpMI_find.Ord_before
                     FROM tmpMI_find

                    UNION ALL
                     SELECT tmpMI_All.UnitId
                          , tmpMI_All.InfoMoneyId
                          , NULL AS DateEnd
                          , 0    AS Amount
                          , NULL AS MovementItemId
                          , NULL AS MovementId
                          , NULL AS OperDate
                          , NULL AS InvNumber
                          , 0    AS Ord
                          , tmpMI_All.Ord AS Ord_before
                     FROM tmpMI_All
                          LEFT JOIN tmpMI_find ON tmpMI_find.UnitId      = tmpMI_All.UnitId
                                              AND tmpMI_find.InfoMoneyId = tmpMI_All.InfoMoneyId
                     WHERE tmpMI_All.Ord = 1
                       AND tmpMI_find.UnitId IS NULL
                    )
           -- ���������
           SELECT CASE WHEN tmpMI.MovementId > 0 THEN tmpMI.MovementId ELSE tmp_before.MovementId END :: Integer AS MovementId
                , tmpMI.OperDate               :: TDateTime AS OperDate
                , zfConvert_StringToNumber (tmpMI.InvNumber)AS InvNumber
                , CASE WHEN tmpMI.MovementId > 0 THEN tmpMI.MovementId ELSE tmp_before.MovementId END :: Integer AS Id
                , Object_Unit.Id                            AS UnitId
                , Object_Unit.ObjectCode                    AS UnitCode
                , Object_Unit.ValueData                     AS UnitName
                , TRIM (COALESCE (ObjectString_Unit_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS UnitName_Full
                , ObjectString_Unit_GroupNameFull.ValueData AS UnitGroupNameFull

                , Object_InfoMoney.Id                       AS Object_InfoMoneyId
                , Object_InfoMoney.ObjectCode               AS Object_InfoMoneyCode
                , Object_InfoMoney.ValueData                AS Object_InfoMoneyName

                , Object_CommentInfoMoney.Id                AS Object_CommentInfoMoneyId
                , Object_CommentInfoMoney.ObjectCode        AS Object_CommentInfoMoneyCode
                , Object_CommentInfoMoney.ValueData         AS Object_CommentInfoMoneyName

                , CASE WHEN tmpMI.MovementItemId IS NULL THEN NULL ELSE COALESCE (tmp_before.DateEnd + INTERVAL '1 DAY', NULL) END :: TDateTime AS DateStart
                , CASE WHEN tmpMI.MovementItemId IS NULL THEN NULL ELSE COALESCE (zfCalc_Month_start (tmp_before.DateEnd + INTERVAL '1 DAY'), NULL) END :: TDateTime AS DateStart_month_month
                , tmpMI.DateEnd                          :: TDateTime AS DateEnd
                , zfCalc_Month_end (tmpMI.DateEnd)       :: TDateTime AS DateEnd_month

                , tmpMI.Amount                           :: TFloat AS Amount
                , COALESCE (MIFloat_Price.ValueData, 0)  :: TFloat AS Price
                , COALESCE (MIFloat_Area.ValueData, 0)   :: TFloat AS Area
                , zfCalc_Month_diff (tmp_before.DateEnd + INTERVAL '1 DAY', tmpMI.DateEnd) :: Integer AS Month_diff

                , CASE WHEN tmp_before.MovementItemId IS NULL THEN NULL ELSE COALESCE (tmp_before_before.DateEnd + INTERVAL '1 DAY', NULL) END :: TDateTime AS DateStart_before
                , CASE WHEN tmp_before.MovementItemId IS NULL THEN NULL ELSE COALESCE (zfCalc_Month_start (tmp_before_before.DateEnd + INTERVAL '1 DAY'), NULL) END :: TDateTime AS DateStart_before_month
                , tmp_before.DateEnd                            :: TDateTime AS DateEnd_before
                , zfCalc_Month_end (tmp_before.DateEnd)         :: TDateTime AS DateEnd_before_month

                , tmp_before.Amount                             :: TFloat    AS Amount_before
                , COALESCE (MIFloat_Price_before.ValueData, 0)  :: TFloat    AS Price_before
                , COALESCE (MIFloat_Area_before.ValueData, 0)   :: TFloat    AS Area_before
                , zfCalc_Month_diff (tmp_before_before.DateEnd + INTERVAL '1 DAY', tmp_before.DateEnd) :: Integer AS Month_diff_before

                , CASE WHEN tmp_after.MovementItemId IS NULL THEN NULL ELSE COALESCE (tmpMI.DateEnd + INTERVAL '1 DAY', NULL) END :: TDateTime AS DateStart_after
                , CASE WHEN tmp_after.MovementItemId IS NULL THEN NULL ELSE COALESCE (zfCalc_Month_start (tmpMI.DateEnd + INTERVAL '1 DAY'), NULL) END :: TDateTime AS DateStart_after_month
                , tmp_after.DateEnd                                 :: TDateTime AS DateEnd_after
                , zfCalc_Month_end (tmp_after.DateEnd)              :: TDateTime AS DateEnd_after_month

                , tmp_after.Amount                                  :: TFloat    AS Amount_after
                , COALESCE (MIFloat_Price_after.ValueData, 0)       :: TFloat    AS Price_after
                , COALESCE (MIFloat_Area_after.ValueData, 0)        :: TFloat    AS Area_after
                , zfCalc_Month_diff (tmpMI.DateEnd + INTERVAL '1 DAY', tmp_after.DateEnd) :: Integer AS Month_diff_after

                , FALSE isErased

                , Object_Insert.ValueData                    AS InsertName
                , MovementDate_Insert.ValueData              AS InsertDate
                , Object_Update.ValueData                    AS UpdateName
                , MovementDate_Update.ValueData              AS UpdateDate
           FROM tmpMI
                LEFT JOIN tmpMI_All AS tmp_before
                                    ON tmp_before.UnitId      = tmpMI.UnitId
                                   AND tmp_before.InfoMoneyId = tmpMI.InfoMoneyId
                                   -- !!!����������
                                   AND tmp_before.Ord         = tmpMI.Ord_before

                LEFT JOIN tmpMI_All AS tmp_before_before
                                    ON tmp_before_before.UnitId      = tmpMI.UnitId
                                   AND tmp_before_before.InfoMoneyId = tmpMI.InfoMoneyId
                                   -- !!!���������� - ���
                                   AND tmp_before_before.Ord  = tmpMI.Ord_before + 1

                LEFT JOIN tmpMI_All AS tmp_after
                                    ON tmp_after.UnitId      = tmpMI.UnitId
                                   AND tmp_after.InfoMoneyId = tmpMI.InfoMoneyId
                                   -- !!!���������
                                   AND tmp_after.Ord  = tmpMI.Ord - 1


                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = tmpMI.MovementItemId
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                           AND tmpMI.Ord > 0
                LEFT JOIN MovementItemFloat AS MIFloat_Area
                                            ON MIFloat_Area.MovementItemId = tmpMI.MovementItemId
                                           AND MIFloat_Area.DescId = zc_MIFloat_Area()
                                           AND tmpMI.Ord > 0

                LEFT JOIN MovementItemFloat AS MIFloat_Price_before
                                            ON MIFloat_Price_before.MovementItemId = tmp_before.MovementItemId
                                           AND MIFloat_Price_before.DescId = zc_MIFloat_Price()
                LEFT JOIN MovementItemFloat AS MIFloat_Area_before
                                            ON MIFloat_Area_before.MovementItemId = tmp_before.MovementItemId
                                           AND MIFloat_Area_before.DescId = zc_MIFloat_Area()

                LEFT JOIN MovementItemFloat AS MIFloat_Price_after
                                            ON MIFloat_Price_after.MovementItemId = tmp_after.MovementItemId
                                           AND MIFloat_Price_after.DescId = zc_MIFloat_Price()
                LEFT JOIN MovementItemFloat AS MIFloat_Area_after
                                            ON MIFloat_Area_after.MovementItemId = tmp_after.MovementItemId
                                           AND MIFloat_Area_after.DescId = zc_MIFloat_Area()

                -- ����� ����� "�����"
                LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                                 ON MILinkObject_CommentInfoMoney.MovementItemId = tmpMI.MovementItemId
                                                AND MILinkObject_CommentInfoMoney.DescId = zc_MILinkObject_CommentInfoMoney()


                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMI.UnitId
                LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpMI.InfoMoneyId
                LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = MILinkObject_CommentInfoMoney.ObjectId

                LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                       ON ObjectString_Unit_GroupNameFull.ObjectId = tmpMI.UnitId
                                      AND ObjectString_Unit_GroupNameFull.DescId   = zc_ObjectString_Unit_GroupNameFull()

                LEFT JOIN MovementDate AS MovementDate_Insert
                                       ON MovementDate_Insert.MovementId = tmpMI.MovementId
                                      AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                LEFT JOIN MovementLinkObject AS MLO_Insert
                                             ON MLO_Insert.MovementId = tmpMI.MovementId
                                            AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
                LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

                LEFT JOIN MovementDate AS MovementDate_Update
                                       ON MovementDate_Update.MovementId = tmpMI.MovementId
                                      AND MovementDate_Update.DescId = zc_MovementDate_Update()
                LEFT JOIN MovementLinkObject AS MLO_Update
                                             ON MLO_Update.MovementId = tmpMI.MovementId
                                            AND MLO_Update.DescId = zc_MovementLinkObject_Update()
                LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId
           ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.06.22         *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_ServiceItem_onDate (inOperDAte := '01.06.2022'::TDateTime, inUnitId:= 0, inInfoMoneyId :=0, inSession:= zfCalc_UserAdmin()) order by 2
