-- Function: gpSelect_MovementItem_ServiceItemAdd()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ServiceItemAdd (Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_ServiceItemAdd (Integer, Integer, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ServiceItemAdd(
    IN inMovementId       Integer      , -- ���� ���������
    IN inInfoMoneyId      Integer   ,
    IN inShowAll          Boolean      , --
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , UnitId Integer, UnitCode Integer, UnitName TVarChar, UnitName_Full TVarChar
             , UnitGroupNameFull TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyCode Integer, CommentInfoMoneyName TVarChar

             , DateStart TDateTime, DateEnd TDateTime
             , MonthNameStart TDateTime, MonthNameEnd   TDateTime
             , NumYearStart   Integer            --��� �����
             , NumYearEnd     Integer            --��� ���
             , NumStartDate   Integer            --����� ������ �����
             , NumEndDate     Integer            --����� ������ ���
             , Amount TFloat

             , DateStart_Main TDateTime, DateEnd_Main TDateTime
             , Amount_Main TFloat, Price_Main TFloat, Area_Main TFloat

             , MonthNameStart_before  TDateTime
             , MonthNameEnd_before TDateTime
             , Amount_before TFloat

             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean

              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_ServiceItemAdd());
     vbUserId:= lpGetUserBySession (inSession);
     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     IF inShowAll = TRUE
     THEN
        -- ���������� ���
        RETURN QUERY
          WITH tmpMI AS (SELECT MovementItem.Id
                              , MovementItem.ObjectId                  AS UnitId
                              , MILinkObject_InfoMoney.ObjectId        AS InfoMoneyId
                              , MILinkObject_CommentInfoMoney.ObjectId AS CommentInfoMoneyId
                              , MovementItem.Amount
                              , COALESCE (MIDate_DateStart.ValueData, vbOperDate) AS DateStart
                              , COALESCE (MIDate_DateEnd.ValueData, zc_DateEnd()) AS DateEnd
                              , MovementItem.isErased
                          FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                               JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = tmpIsErased.isErased

                               LEFT JOIN MovementItemDate AS MIDate_DateStart
                                                          ON MIDate_DateStart.MovementItemId = MovementItem.Id
                                                         AND MIDate_DateStart.DescId = zc_MIDate_DateStart()
                               LEFT JOIN MovementItemDate AS MIDate_DateEnd
                                                          ON MIDate_DateEnd.MovementItemId = MovementItem.Id
                                                         AND MIDate_DateEnd.DescId = zc_MIDate_DateEnd()

                               LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()

                               LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                                                ON MILinkObject_CommentInfoMoney.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_CommentInfoMoney.DescId         = zc_MILinkObject_CommentInfoMoney()
                          )

             , tmpUnit AS (SELECT Object_Unit.Id AS UnitId
                           FROM Object AS Object_Unit
                           WHERE Object_Unit.DescId = zc_Object_Unit()
                             AND Object_Unit.isErased = FALSE
                          )
               -- ������� ������� - �� ���� vbOperDate
             , tmpMI_Main AS (SELECT *
                              FROM gpSelect_MovementItem_ServiceItem_onDate (inOperDate := vbOperDate, inUnitId:= 0, inInfoMoneyId:= inInfoMoneyId, inSession := inSession) AS gpSelect
                              WHERE gpSelect.Amount > 0
                             )
               -- ����� ����������� ����������
             , tmp_last AS (SELECT tmp.*
                            FROM (SELECT tmpMI.Id AS MovementItemId_find
                                       , tmp_View.*
                                       , ROW_NUMBER() OVER (PARTITION BY tmp_View.UnitId, tmp_View.InfoMoneyId ORDER BY tmp_View.OperDate DESC, tmp_View.MovementId DESC) AS ord
                                  FROM tmpMI
                                       INNER JOIN Movement_ServiceItemAdd_View AS tmp_View
                                                                               ON tmp_View.UnitId      = tmpMI.UnitId
                                                                              AND tmp_View.InfoMoneyId = tmpMI.InfoMoneyId
                                                                              AND tmp_View.isErased    = FALSE
                                                                              AND tmpMI.DateStart BETWEEN tmp_View.DateStart AND tmp_View.DateEnd
                                                                              AND tmp_View.OperDate    < vbOperDate
                                  ) AS tmp
                            WHERE tmp.Ord = 1
                           )

           -- ���������
           SELECT 0                             AS Id
                , Object_Unit.Id                AS UnitId
                , Object_Unit.ObjectCode        AS UnitCode
                , Object_Unit.ValueData         AS UnitName 
                , TRIM (COALESCE (ObjectString_Unit_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS UnitName_Full
                , ObjectString_Unit_GroupNameFull.ValueData AS UnitGroupNameFull

                , Object_InfoMoney.Id           AS InfoMoneyId
                , Object_InfoMoney.ObjectCode   AS InfoMoneyCode
                , Object_InfoMoney.ValueData    AS InfoMoneyName

                , 0              AS CommentInfoMoneyId
                , 0              AS CommentInfoMoneyCode
                , '' ::TVarChar  AS CommentInfoMoneyName

                , tmpMI_Main.DateStart                    :: TDateTime AS DateStart
                , tmpMI_Main.DateEnd                      :: TDateTime AS DateEnd
                , tmpMI_Main.DateStart                    :: TDateTime AS MonthNameStart
                , tmpMI_Main.DateEnd                      :: TDateTime AS MonthNameEnd

                , (EXTRACT (Year FROM tmpMI_Main.DateStart) - 2000) ::Integer  AS NumYearStart    --��� �����
                , (EXTRACT (Year FROM tmpMI_Main.DateEnd)   - 2000) ::Integer  AS NumYearEnd      --��� ���
                , EXTRACT (MONTH FROM tmpMI_Main.DateStart) ::Integer  AS NumStartDate            --����� ������ �����
                , EXTRACT (MONTH FROM tmpMI_Main.DateEnd)   ::Integer  AS NumEndDate              --����� ������ ���

                , 0                          :: TFloat    AS Amount

                , tmpMI_Main.DateStart       :: TDateTime AS DateStart_Main
                , tmpMI_Main.DateEnd         :: TDateTime AS DateEnd_Main
                , tmpMI_Main.Amount          :: TFloat    AS Amount_Main
                , tmpMI_Main.Price           :: TFloat    AS Price_Main
                , tmpMI_Main.Area            :: TFloat    AS Area_Main

                , NULL            :: TDateTime AS MonthNameStart_before
                , NULL            :: TDateTime AS MonthNameEnd_before
                , NULL            :: TFloat    AS Amount_before

                , '' ::TVarChar       AS InsertName
                , '' ::TVarChar       AS UpdateName
                , CURRENT_TIMESTAMP ::TDateTime AS InsertDate
                , NULL ::TDateTime    AS UpdateDate

                , FALSE           :: Boolean   AS isErased

           FROM tmpUnit
                INNER JOIN tmpMI_Main ON tmpMI_Main.UnitId = tmpUnit.UnitId
                --                    AND tmpMI_Main.InfoMoneyId = tmpMI.InfoMoneyId

                LEFT JOIN tmpMI ON tmpMI.UnitId = tmpUnit.UnitId

                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUnit.UnitId

                LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                       ON ObjectString_Unit_GroupNameFull.ObjectId = tmpUnit.UnitId
                                      AND ObjectString_Unit_GroupNameFull.DescId   = zc_ObjectString_Unit_GroupNameFull()
                LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = COALESCE(tmpMI_Main.InfoMoneyId,76878)

           WHERE tmpMI.UnitId IS NULL

         UNION ALL
           -- ������� �������� ���������
           SELECT tmpMI.Id                      AS Id
                , Object_Unit.Id                AS UnitId
                , Object_Unit.ObjectCode        AS UnitCode
                , Object_Unit.ValueData         AS UnitName  
                , TRIM (COALESCE (ObjectString_Unit_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS UnitName_Full
                , ObjectString_Unit_GroupNameFull.ValueData AS UnitGroupNameFull

                , Object_InfoMoney.Id           AS InfoMoneyId
                , Object_InfoMoney.ObjectCode   AS InfoMoneyCode
                , Object_InfoMoney.ValueData    AS InfoMoneyName

                , Object_CommentInfoMoney.Id         AS CommentInfoMoneyId
                , Object_CommentInfoMoney.ObjectCode AS CommentInfoMoneyCode
                , Object_CommentInfoMoney.ValueData  AS CommentInfoMoneyName

                , tmpMI.DateStart            :: TDateTime AS DateStart
                , tmpMI.DateEnd              :: TDateTime AS DateEnd
                , tmpMI.DateStart            :: TDateTime AS MonthNameStart
                , tmpMI.DateEnd              :: TDateTime AS MonthNameEnd
                , (EXTRACT (Year FROM tmpMI.DateStart) - 2000) ::Integer  AS NumYearStart            --��� �����
                , (EXTRACT (Year FROM tmpMI.DateEnd)   - 2000) ::Integer  AS NumYearEnd              --��� ���
                , EXTRACT (MONTH FROM tmpMI.DateStart) ::Integer  AS NumStartDate            --����� ������ �����
                , EXTRACT (MONTH FROM tmpMI.DateEnd)   ::Integer  AS NumEndDate              --����� ������ ���

                , tmpMI.Amount               :: TFloat    AS Amount

                , tmpMI_Main.DateStart       :: TDateTime AS DateStart_Main
                , tmpMI_Main.DateEnd         :: TDateTime AS DateEnd_Main
                , tmpMI_Main.Amount          :: TFloat    AS Amount_Main
                , tmpMI_Main.Price           :: TFloat    AS Price_Main
                , tmpMI_Main.Area            :: TFloat    AS Area_Main

                , tmp_last.DateStart       :: TDateTime AS MonthNameStart_before
                , tmp_last.DateEnd         :: TDateTime AS MonthNameEnd_before
                , tmp_last.Amount          :: TFloat    AS Amount_before

                , Object_Insert.ValueData    AS InsertName
                , Object_Update.ValueData    AS UpdateName
                , MIDate_Insert.ValueData    AS InsertDate
                , MIDate_Update.ValueData    AS UpdateDate

                , tmpMI.isErased
           FROM tmpMI
                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMI.UnitId

                LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = tmpMI.CommentInfoMoneyId
                LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpMI.InfoMoneyId

                LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                       ON ObjectString_Unit_GroupNameFull.ObjectId = tmpMI.UnitId
                                      AND ObjectString_Unit_GroupNameFull.DescId   = zc_ObjectString_Unit_GroupNameFull()

                -- ������� ������� - �� ����
                LEFT JOIN gpSelect_MovementItem_ServiceItem_onDate (inOperDate   := tmpMI.DateStart
                                                                  , inUnitId     := tmpMI.UnitId
                                                                  , inInfoMoneyId:= tmpMI.InfoMoneyId
                                                                  , inSession    := inSession
                                                                   ) AS tmpMI_Main
                                                                     ON tmpMI.DateStart BETWEEN COALESCE (tmpMI_Main.DateStart, zc_DateStart()) AND tmpMI_Main.DateEnd
                                                                    AND tmpMI_Main.Amount > 0

                LEFT JOIN tmp_last ON tmp_last.MovementItemId_find = tmpMI.Id 

                LEFT JOIN MovementItemDate AS MIDate_Insert
                                           ON MIDate_Insert.MovementItemId = tmpMI.Id
                                          AND MIDate_Insert.DescId = zc_MIDate_Insert()
                LEFT JOIN MovementItemDate AS MIDate_Update
                                           ON MIDate_Update.MovementItemId = tmpMI.Id
                                          AND MIDate_Update.DescId = zc_MIDate_Update()

                LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                 ON MILO_Insert.MovementItemId = tmpMI.Id
                                                AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

                LEFT JOIN MovementItemLinkObject AS MILO_Update
                                                 ON MILO_Update.MovementItemId = tmpMI.Id
                                                AND MILO_Update.DescId = zc_MILinkObject_Update()
                LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId

          ;

     ELSE
         -- ��������� - ������ ������� �������� ���������
         RETURN QUERY
          WITH tmpMI AS (SELECT MovementItem.Id
                              , MovementItem.ObjectId                  AS UnitId
                              , MILinkObject_InfoMoney.ObjectId        AS InfoMoneyId
                              , MILinkObject_CommentInfoMoney.ObjectId AS CommentInfoMoneyId
                              , MovementItem.Amount
                              , COALESCE (MIDate_DateStart.ValueData, vbOperDate) AS DateStart
                              , COALESCE (MIDate_DateEnd.ValueData, zc_DateEnd()) AS DateEnd
                              , MovementItem.isErased
                         FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                              JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                               AND MovementItem.DescId     = zc_MI_Master()
                                               AND MovementItem.isErased   = tmpIsErased.isErased

                              LEFT JOIN MovementItemDate AS MIDate_DateStart
                                                         ON MIDate_DateStart.MovementItemId = MovementItem.Id
                                                        AND MIDate_DateStart.DescId = zc_MIDate_DateStart()
                              LEFT JOIN MovementItemDate AS MIDate_DateEnd
                                                         ON MIDate_DateEnd.MovementItemId = MovementItem.Id
                                                        AND MIDate_DateEnd.DescId = zc_MIDate_DateEnd()

                              LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                               ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()

                              LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                                               ON MILinkObject_CommentInfoMoney.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_CommentInfoMoney.DescId         = zc_MILinkObject_CommentInfoMoney()
                        )

               -- ����� ����������� ����������
             , tmp_last AS (SELECT tmp.*
                            FROM (SELECT tmpMI.Id AS MovementItemId_find
                                       , tmp_View.*
                                       , ROW_NUMBER() OVER (PARTITION BY tmp_View.UnitId, tmp_View.InfoMoneyId ORDER BY tmp_View.OperDate DESC, tmp_View.MovementId DESC) AS ord
                                  FROM tmpMI
                                       INNER JOIN Movement_ServiceItemAdd_View AS tmp_View
                                                                               ON tmp_View.UnitId      = tmpMI.UnitId
                                                                              AND tmp_View.InfoMoneyId = tmpMI.InfoMoneyId
                                                                              AND tmp_View.isErased    = FALSE
                                                                              AND tmpMI.DateStart BETWEEN tmp_View.DateStart AND tmp_View.DateEnd
                                                                              AND tmp_View.OperDate    < vbOperDate
                                  ) AS tmp
                            WHERE tmp.Ord = 1
                           )
           -- ���������
           SELECT tmpMI.Id                      AS Id
                , Object_Unit.Id                AS UnitId
                , Object_Unit.ObjectCode        AS UnitCode
                , Object_Unit.ValueData         AS UnitName
                , TRIM (COALESCE (ObjectString_Unit_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS UnitName_Full
                , ObjectString_Unit_GroupNameFull.ValueData AS UnitGroupNameFull

                , Object_InfoMoney.Id         AS InfoMoneyId
                , Object_InfoMoney.ObjectCode AS InfoMoneyCode
                , Object_InfoMoney.ValueData  AS InfoMoneyName

                , Object_CommentInfoMoney.Id         AS CommentInfoMoneyId
                , Object_CommentInfoMoney.ObjectCode AS CommentInfoMoneyCode
                , Object_CommentInfoMoney.ValueData  AS CommentInfoMoneyName

                , tmpMI.DateStart            :: TDateTime AS DateStart
                , tmpMI.DateEnd              :: TDateTime AS DateEnd
                , zfCalc_Month_start (tmpMI.DateStart)    AS MonthNameStart
                , zfCalc_Month_end (tmpMI.DateEnd)        AS MonthNameEnd
                , (EXTRACT (Year FROM tmpMI.DateStart) - 2000) ::Integer  AS NumYearStart            --��� �����
                , (EXTRACT (Year FROM tmpMI.DateEnd)   - 2000) ::Integer  AS NumYearEnd              --��� ���
                , EXTRACT (MONTH FROM tmpMI.DateStart) ::Integer  AS NumStartDate            --����� ������ �����
                , EXTRACT (MONTH FROM tmpMI.DateEnd)   ::Integer  AS NumEndDate              --����� ������ ���

                , tmpMI.Amount               :: TFloat    AS Amount

                , zfCalc_Month_start (tmpMI_Main.DateStart) AS DateStart_Main
                , zfCalc_Month_end (tmpMI_Main.DateEnd)     AS DateEnd_Main
                , tmpMI_Main.Amount          :: TFloat      AS Amount_Main
                , tmpMI_Main.Price           :: TFloat      AS Price_Main
                , tmpMI_Main.Area                :: TFloat  AS Area_Main

                , zfCalc_Month_start (tmp_last.DateStart)   AS MonthNameStart_before
                , zfCalc_Month_end (tmp_last.DateEnd)       AS MonthNameEnd_before
                , tmp_last.Amount              :: TFloat    AS Amount_before

                , Object_Insert.ValueData    AS InsertName
                , Object_Update.ValueData    AS UpdateName
                , MIDate_Insert.ValueData    AS InsertDate
                , MIDate_Update.ValueData    AS UpdateDate

                , tmpMI.isErased
           FROM tmpMI
                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMI.UnitId
                LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = tmpMI.CommentInfoMoneyId
                LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpMI.InfoMoneyId

                LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                       ON ObjectString_Unit_GroupNameFull.ObjectId = tmpMI.UnitId
                                      AND ObjectString_Unit_GroupNameFull.DescId   = zc_ObjectString_Unit_GroupNameFull()

                -- ������� ������� - �� ����
                LEFT JOIN gpSelect_MovementItem_ServiceItem_onDate (inOperDate   := tmpMI.DateStart
                                                                  , inUnitId     := tmpMI.UnitId
                                                                  , inInfoMoneyId:= tmpMI.InfoMoneyId
                                                                  , inSession    := inSession
                                                                   ) AS tmpMI_Main
                                                                     ON tmpMI.DateStart BETWEEN COALESCE (tmpMI_Main.DateStart, zc_DateStart()) AND tmpMI_Main.DateEnd
                                                                    AND tmpMI_Main.Amount > 0

                LEFT JOIN tmp_last ON tmp_last.MovementItemId_find = tmpMI.Id   

                LEFT JOIN MovementItemDate AS MIDate_Insert
                                           ON MIDate_Insert.MovementItemId = tmpMI.Id
                                          AND MIDate_Insert.DescId = zc_MIDate_Insert()
                LEFT JOIN MovementItemDate AS MIDate_Update
                                           ON MIDate_Update.MovementItemId = tmpMI.Id
                                          AND MIDate_Update.DescId = zc_MIDate_Update()

                LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                 ON MILO_Insert.MovementItemId = tmpMI.Id
                                                AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

                LEFT JOIN MovementItemLinkObject AS MILO_Update
                                                 ON MILO_Update.MovementItemId = tmpMI.Id
                                                AND MILO_Update.DescId = zc_MILinkObject_Update()
                LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId

           ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 31.08.22         *
 01.06.22         *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_ServiceItemAdd (inMovementId:= 7, inInfoMoneyId:= 76878, inShowAll:= TRUE,  inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpSelect_MovementItem_ServiceItemAdd (inMovementId:= 7, inInfoMoneyId:= 76878, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
