-- Function: gpSelect_Movement_GoodsSPInform_1303()

DROP FUNCTION IF EXISTS gpSelect_Movement_GoodsSPInform_1303 (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_GoodsSPInform_1303(
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
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_GoodsSPInform_1303());
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
            LEFT JOIN Movement ON Movement.DescId = zc_Movement_GoodsSPInform_1303()
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
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.04.23                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_GoodsSPInform_1303 (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '3')

select * from gpSelect_Movement_GoodsSPInform_1303(instartdate := ('23.06.2022')::TDateTime , inenddate := ('23.06.2022')::TDateTime , inIsErased := 'False' ,  inSession := '3');
