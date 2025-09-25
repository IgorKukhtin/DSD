-- Function: gpSelect_Movement_StaffListClose()

DROP FUNCTION IF EXISTS gpSelect_Movement_StaffListClose (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_StaffListClose(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer , -- ��. ��.����
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
             , OperDate TDateTime
             , OperDateClose TDateTime
             , TimeClose Time                             -- ����� ���� ��������  �� ��������� ���� ����� ��������� �������
             , StatusCode Integer, StatusName TVarChar
             , isClosed Boolean, isClosedAll Boolean
             , UnitId Integer, UnitName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             , MemberId Integer, MemberCode Integer, MemberName TVarChar
             , Count TFloat
             , isAmount Boolean
              )
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbIsDocumentUser Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_StaffListClose());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!������ �������� �������!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- ���������
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )    
                       
        , tmpDateList AS (SELECT GENERATE_SERIES (inStartDate, inEndDate, '1 DAY':: INTERVAL) AS OperDate)

        , tmpMovement AS (SELECT Movement.*
                          FROM tmpStatus
                               JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                            AND Movement.DescId = zc_Movement_StaffListClose()
                                            AND Movement.StatusId = tmpStatus.StatusId
                         )
        -- ����� �������� ��������� ������ � ������� - ��������� ���������
        , tmpMI AS (SELECT *
                    FROM (SELECT MovementItem.MovementId
                               , MovementItem.ObjectId AS MemberId
                               , MovementItem.Amount
                               , ROW_NUMBER () OVER (PARTITION BY MovementItem.MovementId ORDER BY MovementItem.Id DESC) AS ord
                               , SUM (COUNT(*)) OVER (PARTITION BY MovementItem.MovementId) AS Count
                          FROM tmpMovement
                               INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                          GROUP BY MovementItem.MovementId
                               , MovementItem.ObjectId
                               , MovementItem.Amount
                               , MovementItem.Id
                          ) AS tmp
                    WHERE tmp.ord = 1
                    )


       SELECT
             Movement.Id                         AS Id
           , Movement.InvNumber                  AS InvNumber
           , tmpDateList.OperDate ::TDateTime       AS OperDate
             -- ���� ���� ��������
           , DATE_TRUNC ('DAY', MovementDate_TimeClose.ValueData) :: TDateTime AS OperDateClose
             -- ����� ���� ��������
           , MovementDate_TimeClose.ValueData   ::Time AS TimeClose
           , Object_Status.ObjectCode            AS StatusCode
           , Object_Status.ValueData             AS StatusName
             -- ������ ������ (������ �����)
           , COALESCE (MovementBoolean_Closed.ValueData, FALSE)    ::Boolean AS isClosed
             -- ��� ������ �������
           , COALESCE (MovementBoolean_ClosedAll.ValueData, FALSE) ::Boolean AS isClosedAll
           
           , Object_Unit.Id                      AS UnitId
           , Object_Unit.ValueData               AS UnitName

           , Object_Insert.ValueData             AS InsertName
           , MovementDate_Insert.ValueData       AS InsertDate
           , Object_Update.ValueData             AS UpdateName
           , MovementDate_Update.ValueData       AS UpdateDate

           --
           , Object_Member.Id          		AS MemberId
           , Object_Member.ObjectCode  		AS MemberCode
           , Object_Member.ValueData   		AS MemberName
           , tmpMI.Count ::TFloat
             -- ������ ������ (��/���)
           , CASE WHEN MovementDate_TimeClose.ValueData <= CURRENT_TIMESTAMP
                       THEN TRUE
                  WHEN COALESCE (tmpMI.Amount,0) = 0
                       THEN FALSE
                  ELSE TRUE
             END ::Boolean AS isAmount

       FROM tmpDateList 
            LEFT JOIN tmpMovement AS Movement ON Movement.OperDate = tmpDateList.OperDate

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_Closed
                                      ON MovementBoolean_Closed.MovementId = Movement.Id
                                     AND MovementBoolean_Closed.DescId = zc_MovementBoolean_Closed()
            LEFT JOIN MovementBoolean AS MovementBoolean_ClosedAll
                                      ON MovementBoolean_ClosedAll.MovementId = Movement.Id
                                     AND MovementBoolean_ClosedAll.DescId = zc_MovementBoolean_ClosedAll()

            LEFT JOIN MovementDate AS MovementDate_TimeClose
                                   ON MovementDate_TimeClose.MovementId = Movement.Id
                                  AND MovementDate_TimeClose.DescId = zc_MovementDate_TimeClose()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
            
            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Update
                                         ON MovementLinkObject_Update.MovementId = Movement.Id
                                        AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId

            LEFT JOIN tmpMI ON tmpMI.MovementId = Movement.Id
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpMI.MemberId
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
  25.09.25         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_StaffListClose (inStartDate:= '30.11.2017', inEndDate:= '30.11.2017', inJuridicalBasisId:=0, inIsErased := FALSE, inSession:= '2')
