-- Function: gpSelect_Movement_Sale()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale(
    IN inStartDate         TDateTime , -- ���� ���. �������
    IN inEndDate           TDateTime , -- ���� �����. �������
    IN inIsErased          Boolean   , -- ���������� ��������� ��/���
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalSummBalance TFloat, TotalSummPriceList TFloat
             , TotalSummChange TFloat, TotalSummChangePay TFloat, TotalSummPay TFloat, TotalSummPayOth TFloat
             , TotalCountReturn TFloat, TotalSummReturn TFloat, TotalSummPayReturn TFloat
             , FromName TVarChar, ToName TVarChar
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY 
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode                    AS StatusCode
           , Object_Status.ValueData                     AS StatusName

           , MovementFloat_TotalCount.ValueData          AS TotalCount
           , MovementFloat_TotalSummBalance.ValueData    AS TotalSummBalance
           , MovementFloat_TotalSummPriceList.ValueData  AS TotalSummPriceList

           , MovementFloat_TotalSummChange.ValueData     AS TotalSummChange
           , MovementFloat_TotalSummChangePay.ValueData  AS TotalSummChangePay
           , MovementFloat_TotalSummPay.ValueData        AS TotalSummPay
           , MovementFloat_TotalSummPayOth.ValueData     AS TotalSummPayOth
           , MovementFloat_TotalCountReturn.ValueData    AS TotalCountReturn
           , MovementFloat_TotalSummReturn.ValueData     AS TotalSummReturn
           , MovementFloat_TotalSummPayReturn.ValueData  AS TotalSummPayReturn

           , Object_From.ValueData                       AS FromName
           , Object_To.ValueData                         AS ToName
           , MovementString_Comment.ValueData            AS Comment

           , Object_Insert.ValueData                     AS InsertName
           , MovementDate_Insert.ValueData               AS InsertDate
         
       FROM (SELECT Movement.id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate 
                               AND Movement.DescId = zc_Movement_Sale()
                               AND Movement.StatusId = tmpStatus.StatusId
             ) AS tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummBalance
                                    ON MovementFloat_TotalSummBalance.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummBalance.DescId = zc_MovementFloat_TotalSummBalance()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPriceList
                                    ON MovementFloat_TotalSummPriceList.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPriceList.DescId = zc_MovementFloat_TotalSummPriceList()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChange
                                    ON MovementFloat_TotalSummChange.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummChange.DescId = zc_MovementFloat_TotalSummChange()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePay
                                    ON MovementFloat_TotalSummChangePay.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummChangePay.DescId = zc_MovementFloat_TotalSummChangePay()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPay
                                    ON MovementFloat_TotalSummPay.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPay.DescId = zc_MovementFloat_TotalSummPay()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPayOth
                                    ON MovementFloat_TotalSummPayOth.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPayOth.DescId = zc_MovementFloat_TotalSummPayOth()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountReturn
                                    ON MovementFloat_TotalCountReturn.MovementId = Movement.Id
                                   AND MovementFloat_TotalCountReturn.DescId = zc_MovementFloat_TotalCountReturn()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummReturn
                                    ON MovementFloat_TotalSummReturn.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummReturn.DescId = zc_MovementFloat_TotalSummReturn()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPayReturn
                                    ON MovementFloat_TotalSummPayReturn.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPayReturn.DescId = zc_MovementFloat_TotalSummPayReturn()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
    
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId
     ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�. 
 09.05.17         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_Sale (inStartDate:= '01.01.2015', inEndDate:= '01.02.2015', inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
