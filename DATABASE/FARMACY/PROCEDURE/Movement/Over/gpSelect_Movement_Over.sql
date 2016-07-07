-- Function: gpSelect_Movement_Over()

DROP FUNCTION IF EXISTS gpSelect_Movement_Over (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Over(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalSummFrom TFloat, TotalSummTo TFloat
             , UnitId Integer, UnitName TVarChar
             , Comment TVarChar
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);
     -- ������������ <�������� ����>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);
     
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUnit  AS  (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                        WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                        )

       SELECT
             Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber
           , Movement.OperDate                          AS OperDate
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName
           , MovementFloat_TotalCount.ValueData         AS TotalCount
           , MovementFloat_TotalSummFrom.ValueData      AS TotalSumFrom
           , MovementFloat_TotalSummTo.ValueData        AS TotalSumTo
           , Object_Unit.Id                             AS UnitId
           , Object_Unit.ValueData                      AS UnitName
           , MovementString_Comment.ValueData           AS Comment

       FROM (SELECT Movement.id
                  , MovementLinkObject_Unit.ObjectId AS UnitId
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate 
                               AND Movement.DescId = zc_Movement_Over() AND Movement.StatusId = tmpStatus.StatusId
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                  INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
            ) AS tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMovement.UnitId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
 
            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummFrom
                                    ON MovementFloat_TotalSummFrom.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummFrom.DescId = zc_MovementFloat_TotalSummFrom()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummTo
                                    ON MovementFloat_TotalSummTo.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummTo.DescId = zc_MovementFloat_TotalSummTo()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.07.16         *

*/

-- ����
-- SELECT * FROM gpSelect_Movement_Over (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '2')