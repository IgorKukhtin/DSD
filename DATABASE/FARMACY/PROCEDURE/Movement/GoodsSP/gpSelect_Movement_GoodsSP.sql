-- Function: gpSelect_Movement_GoodsSP()

DROP FUNCTION IF EXISTS gpSelect_Movement_GoodsSP (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_GoodsSP(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , OperDateStart TDateTime
             , OperDateEnd TDateTime
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_GoodsSP());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
 
       SELECT Movement.Id                           AS Id
            , Movement.InvNumber                    AS InvNumber
            , Movement.OperDate                     AS OperDate
            , Object_Status.ObjectCode              AS StatusCode
            , Object_Status.ValueData               AS StatusName
            , MovementDate_OperDateStart.ValueData  AS OperDateStart
            , MovementDate_OperDateEnd.ValueData    AS OperDateEnd

       FROM tmpStatus
            LEFT JOIN Movement ON Movement.DescId = zc_Movement_GoodsSP()
                              AND Movement.StatusId = tmpStatus.StatusId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                   ON MovementDate_OperDateStart.MovementId = Movement.Id
                                  AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()

            LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                   ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                  AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
       WHERE MovementDate_OperDateStart.ValueData <=inEndDate
         AND MovementDate_OperDateEnd.ValueData >= inStartDate 
            
            ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.02.19         * ������ ������������ ���/����� �������� ��
 13.08.18         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_GoodsSP (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '3')