-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_Movement_Income (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Income(
    IN inStartDate         TDateTime , -- ���� ���. �������
    IN inEndDate           TDateTime , -- ���� �����. �������
    IN inIsErased          Boolean   , -- ���������� ��������� ��/���
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalSumm TFloat, TotalSummBalance TFloat, TotalSummPriceList TFloat
             , CurrencyValue TFloat, ParValue TFloat
             , FromName TVarChar, ToName TVarChar
             , CurrencyDocumentName TVarChar
             , Comment TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
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

           , MF_TotalCount.ValueData                     AS TotalCount
           , MF_TotalSumm.ValueData                      AS TotalSumm
           , MovementFloat_TotalSummBalance.ValueData    AS TotalSummBalance
           , MF_TotalSummPriceList.ValueData             AS TotalSummPriceList
                                                         
           , MF_CurrencyValue.ValueData                  AS CurrencyValue
           , MF_ParValue.ValueData                       AS ParValue

           , Object_From.ValueData                       AS FromName
           , Object_To.ValueData                         AS ToName
           , Object_CurrencyDocument.ValueData           AS CurrencyDocumentName
           , MS_Comment.ValueData                        AS Comment
         
       FROM (SELECT Movement.Id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate 
                               AND Movement.DescId   = zc_Movement_Income()
                               AND Movement.StatusId = tmpStatus.StatusId
             ) AS tmpMovement

            LEFT JOIN Movement ON Movement.Id = tmpMovement.Id
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MS_Comment 
                                     ON MS_Comment.MovementId = Movement.Id
                                    AND MS_Comment.DescId = zc_MovementString_Comment()
            LEFT JOIN MovementFloat AS MF_TotalCount
                                    ON MF_TotalCount.MovementId = Movement.Id
                                   AND MF_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MF_TotalSumm
                                    ON MF_TotalSumm.MovementId = Movement.Id
                                   AND MF_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummBalance
                                    ON MovementFloat_TotalSummBalance.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummBalance.DescId = zc_MovementFloat_TotalSummBalance()
            LEFT JOIN MovementFloat AS MF_TotalSummPriceList
                                    ON MF_TotalSummPriceList.MovementId = Movement.Id
                                   AND MF_TotalSummPriceList.DescId = zc_MovementFloat_TotalSummPriceList()

            LEFT JOIN MovementFloat AS MF_ParValue
                                    ON MF_ParValue.MovementId = Movement.Id
                                   AND MF_ParValue.DescId = zc_MovementFloat_ParValue()
            LEFT JOIN MovementFloat AS MF_CurrencyValue
                                    ON MF_CurrencyValue.MovementId =  Movement.Id
                                   AND MF_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()

            LEFT JOIN MovementLinkObject AS MLO_From
                                         ON MLO_From.MovementId = Movement.Id
                                        AND MLO_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
            LEFT JOIN MovementLinkObject AS MLO_To
                                         ON MLO_To.MovementId = Movement.Id
                                        AND MLO_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId

            LEFT JOIN MovementLinkObject AS MLO_CurrencyDocument
                                         ON MLO_CurrencyDocument.MovementId = Movement.Id
                                        AND MLO_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
            LEFT JOIN Object AS Object_CurrencyDocument ON Object_CurrencyDocument.Id = MLO_CurrencyDocument.ObjectId
           ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�. 
 10.04.17         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_Income (inStartDate:= '01.03.2017', inEndDate:= '01.03.2017', inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
