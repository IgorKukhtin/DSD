-- Function: gpSelect_Movement_SendChoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_Loss (TDateTime, TDateTime, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement_Loss(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumber_Full  TVarChar
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat
             , TotalSumm TFloat
             , FromId Integer, FromCode Integer, FromName TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Loss());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        , Movement_Loss AS ( SELECT Movement_Loss.Id
                                  , Movement_Loss.InvNumber
                                  , Movement_Loss.OperDate             AS OperDate
                                  , Movement_Loss.StatusId             AS StatusId
                                  , MovementLinkObject_To.ObjectId     AS ToId
                                  , MovementLinkObject_From.ObjectId   AS FromId
                             FROM tmpStatus
                                  INNER JOIN Movement AS Movement_Loss
                                                      ON Movement_Loss.StatusId = tmpStatus.StatusId
                                                     AND Movement_Loss.OperDate BETWEEN inStartDate AND inEndDate
                                                     AND Movement_Loss.DescId = zc_Movement_Loss()

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement_Loss.Id
                                                              AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement_Loss.Id
                                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                            )

        SELECT Movement_Loss.Id
             , zfConvert_StringToNumber (Movement_Loss.InvNumber) AS InvNumber
             , ('� ' || Movement_Loss.InvNumber || ' �� ' || zfConvert_DateToString (Movement_Loss.OperDate) :: TVarChar ) :: TVarChar  AS InvNumber_Full
             , Movement_Loss.OperDate
             , Object_Status.ObjectCode                   AS StatusCode
             , Object_Status.ValueData                    AS StatusName

             , MovementFloat_TotalCount.ValueData         AS TotalCount
             , MovementFloat_TotalSumm.ValueData          AS TotalSumm

             , Object_From.Id                             AS FromId
             , Object_From.ObjectCode                     AS FromCode
             , Object_From.ValueData                      AS FromName
             , Object_To.Id                               AS ToId
             , Object_To.ObjectCode                       AS ToCode
             , Object_To.ValueData                        AS ToName
             , MovementString_Comment.ValueData :: TVarChar AS Comment

             , Object_Insert.ValueData              AS InsertName
             , MovementDate_Insert.ValueData        AS InsertDate
             , Object_Update.ValueData              AS UpdateName
             , MovementDate_Update.ValueData        AS UpdateDate

        FROM Movement_Loss

        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Loss.StatusId
        LEFT JOIN Object AS Object_From   ON Object_From.Id   = Movement_Loss.FromId
        LEFT JOIN Object AS Object_To     ON Object_To.Id     = Movement_Loss.ToId

        LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                ON MovementFloat_TotalCount.MovementId = Movement_Loss.Id
                               AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId = Movement_Loss.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement_Loss.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement_Loss.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
        LEFT JOIN MovementLinkObject AS MLO_Insert
                                     ON MLO_Insert.MovementId = Movement_Loss.Id
                                    AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

        LEFT JOIN MovementDate AS MovementDate_Update
                               ON MovementDate_Update.MovementId = Movement_Loss.Id
                              AND MovementDate_Update.DescId = zc_MovementDate_Update()
        LEFT JOIN MovementLinkObject AS MLO_Update
                                     ON MLO_Update.MovementId = Movement_Loss.Id
                                    AND MLO_Update.DescId = zc_MovementLinkObject_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.06.21         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_Loss (inStartDate:= '29.01.2016', inEndDate:= '01.02.2016', inIsErased := FALSE, inSession:= zfCalc_UserAdmin())