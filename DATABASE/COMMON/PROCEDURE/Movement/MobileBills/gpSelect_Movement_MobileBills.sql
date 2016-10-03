-- Function: gpSelect_Movement_MobileBills()

DROP FUNCTION IF EXISTS gpSelect_Movement_MobileBills (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_MobileBills(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalSumm TFloat
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_MobileBills());
--     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
     
       SELECT
             Movement.Id                        AS Id
           , Movement.InvNumber                 AS InvNumber
           , Movement.OperDate                  AS OperDate
           , Object_Status.ObjectCode           AS StatusCode
           , Object_Status.ValueData            AS StatusName
           , MovementFloat_TotalSumm.ValueData  AS TotalSumm
     
       FROM tmpStatus
           JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate 
                        AND Movement.DescId = zc_Movement_MobileBills()
                        AND Movement.StatusId = tmpStatus.StatusId
           
           LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

           LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                   ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                  AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.09.16         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_MobileBills (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '2')
