-- Function: gpSelect_Movement_Sale()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Sale (TDateTime, TDateTime, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Sale (Integer, TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale(
    IN inUnitId            Integer   , -- �������������
    IN inStartDate         TDateTime , -- ���� ���. �������
    IN inEndDate           TDateTime , -- ���� �����. �������
    IN inStartProtocol     TDateTime , -- ���� ���. ��� ���������
    IN inEndProtocol       TDateTime , -- ���� �����. ��� ���������
    IN inIsProtocol        Boolean   , -- ���������� �������� ��/���
    IN inIsErased          Boolean   , -- ���������� ��������� ��/���
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalSummBalance TFloat, TotalSummPriceList TFloat
             , TotalSummChange TFloat, TotalSummPay TFloat

             , TotalSumm_curr TFloat
             , TotalSummPriceList_curr TFloat
             , TotalSummChange_curr TFloat
             , TotalSummChangePay_curr TFloat
             , TotalSummPay_curr TFloat

             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , CurrencyId_Client Integer, CurrencyName_Client TVarChar
             , Comment TVarChar
             , isOffer Boolean
             , InsertName TVarChar, InsertDate TDateTime
             , isProtocol Boolean

             , isDisableSMS Boolean
             , KeySMS TFloat
             , DiscountTaxSMS TFloat
             , PhoneSMS TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAdmin Boolean;
   
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);
     
     vbAdmin := EXISTS (SELECT 1 FROM ObjectLink_UserRole_View as tmp WHERE tmp.UserId = vbUserId AND tmp.RoleId IN (zc_Enum_Role_Admin())) ;
          
     -- ���������
     RETURN QUERY 
     WITH 
          tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        , tmpMovement AS (SELECT Movement.*
                               , MovementLinkObject_From.ObjectId AS FromId
                          FROM tmpStatus
                               JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate 
                                            AND Movement.DescId = zc_Movement_Sale()
                                            AND Movement.StatusId = tmpStatus.StatusId
                               INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                            AND (MovementLinkObject_From.ObjectId = inUnitId OR inUnitId = 0)
                         )
        , tmpMI AS (SELECT MovementItem.MovementId
                         , MovementItem.Id
                    FROM tmpMovement
                         INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE
                    WHERE inIsProtocol = TRUE
                   )
        , tmpProtocol_MI AS (SELECT DISTINCT tmpMI.MovementId
                             FROM tmpMI
                                  INNER JOIN (SELECT DISTINCT MovementItemProtocol.MovementItemId
                                              FROM MovementItemProtocol
                                              WHERE MovementItemProtocol.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                                AND MovementItemProtocol.OperDate >= inStartProtocol AND MovementItemProtocol.OperDate < inEndProtocol + INTERVAL '1 DAY'
                                                AND inIsProtocol = TRUE
                                             ) AS tmp ON tmp.MovementItemId = tmpMI.Id
                            )
        , tmpProtocol_Mov AS (SELECT DISTINCT MovementProtocol.MovementId
                              FROM MovementProtocol
                              WHERE MovementProtocol.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                AND MovementProtocol.OperDate >= inStartProtocol AND MovementProtocol.OperDate < inEndProtocol + INTERVAL '1 DAY'
                                AND inIsProtocol = TRUE
                             )
        , tmpProtocol AS (SELECT tmp.MovementId
                          FROM tmpProtocol_MI AS tmp
                         UNION 
                          SELECT tmp.MovementId
                          FROM tmpProtocol_Mov AS tmp
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
           , MovementFloat_TotalSummPay.ValueData        AS TotalSummPay
           
           , MovementFloat_TotalSumm_curr.ValueData           ::TFloat AS TotalSumm_curr
           , MovementFloat_TotalSummPriceList_curr.ValueData  ::TFloat AS TotalSummPriceList_curr
           , MovementFloat_TotalSummChange_curr.ValueData     ::TFloat AS TotalSummChange_curr
           , MovementFloat_TotalSummChangePay_curr.ValueData  ::TFloat AS TotalSummChangePay_curr
           , MovementFloat_TotalSummPay_curr.ValueData        ::TFloat AS TotalSummPay_curr

           , Object_From.Id                              AS FromId
           , Object_From.ValueData                       AS FromName
           , Object_To.Id                                AS ToId
           , Object_To.ValueData                         AS ToName
           , Object_CurrencyClient.Id                    AS CurrencyId_Client
           , Object_CurrencyClient.ValueData             AS CurrencyName_Client
           , MovementString_Comment.ValueData            AS Comment
           
           , COALESCE (MovementBoolean_Offer.ValueData, FALSE) ::Boolean AS isOffer

           , Object_Insert.ValueData                     AS InsertName
           , MovementDate_Insert.ValueData               AS InsertDate

           , CASE WHEN tmpProtocol.MovementId > 0 THEN TRUE ELSE FALSE END AS isProtocol
           
           , COALESCE (MovementBoolean_DisableSMS.ValueData, FALSE) ::Boolean AS isDisableSMS
           , CASE WHEN vbAdmin = TRUE THEN MovementFloat_KeySMS.ValueData ELSE NULL END ::TFloat AS KeySMS
           , MovementFloat_DiscountTaxSMS.ValueData ::TFloat   AS DiscountTaxSMS
           , MovementString_PhoneSMS.ValueData      ::TVarChar AS TotalSummChangePhoneSMS

       FROM tmpMovement AS Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_Offer
                                      ON MovementBoolean_Offer.MovementId = Movement.Id
                                     AND MovementBoolean_Offer.DescId = zc_MovementBoolean_Offer()

            LEFT JOIN MovementBoolean AS MovementBoolean_DisableSMS
                                      ON MovementBoolean_DisableSMS.MovementId = Movement.Id
                                     AND MovementBoolean_DisableSMS.DescId = zc_MovementBoolean_DisableSMS()

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
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPay
                                    ON MovementFloat_TotalSummPay.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPay.DescId = zc_MovementFloat_TotalSummPay()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm_curr
                                    ON MovementFloat_TotalSumm_curr.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm_curr.DescId = zc_MovementFloat_TotalSumm_curr()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPriceList_curr
                                    ON MovementFloat_TotalSummPriceList_curr.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPriceList_curr.DescId = zc_MovementFloat_TotalSummPriceList_curr()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChange_curr
                                    ON MovementFloat_TotalSummChange_curr.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummChange_curr.DescId = zc_MovementFloat_TotalSummChange_curr()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePay_curr
                                    ON MovementFloat_TotalSummChangePay_curr.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummChangePay_curr.DescId = zc_MovementFloat_TotalSummChangePay_curr()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPay_curr
                                    ON MovementFloat_TotalSummPay_curr.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPay_curr.DescId = zc_MovementFloat_TotalSummPay_curr()

            LEFT JOIN MovementFloat AS MovementFloat_KeySMS
                                    ON MovementFloat_KeySMS.MovementId = Movement.Id
                                   AND MovementFloat_KeySMS.DescId = zc_MovementFloat_KeySMS()
            LEFT JOIN MovementFloat AS MovementFloat_DiscountTaxSMS
                                    ON MovementFloat_DiscountTaxSMS.MovementId = Movement.Id
                                   AND MovementFloat_DiscountTaxSMS.DescId = zc_MovementFloat_DiscountTaxSMS()

            LEFT JOIN MovementString AS MovementString_PhoneSMS
                                     ON MovementString_PhoneSMS.MovementId = Movement.Id
                                    AND MovementString_PhoneSMS.DescId = zc_MovementString_PhoneSMS()

           /* LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()*/
            LEFT JOIN Object AS Object_From ON Object_From.Id = Movement.FromId --MovementLinkObject_From.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyClient
                                         ON MovementLinkObject_CurrencyClient.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyClient.DescId = zc_MovementLinkObject_CurrencyClient()
            LEFT JOIN Object AS Object_CurrencyClient ON Object_CurrencyClient.Id = MovementLinkObject_CurrencyClient.ObjectId
            
            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
    
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            --
            LEFT JOIN tmpProtocol ON tmpProtocol.MovementId = Movement.Id
     ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.06.21         *
 22.04.21         * isOffer
 13.05.20         * 
 19.02.18         * add inUnitId
 09.05.17         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_Sale ( inUnitId:=0, inStartDate:= CURRENT_DATE - INTERVAL '1 MONTH', inEndDate:= CURRENT_DATE, inStartProtocol:= '01.03.2017', inEndProtocol:= '01.03.2017', inIsProtocol:= FALSE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
