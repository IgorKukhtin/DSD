-- Function: gpReport_CheckMobile()

DROP FUNCTION IF EXISTS gpReport_CheckMobile (TDateTime, TDateTime, Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckMobile(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inUnitId             Integer ,
    IN inIsUnComplete       Boolean ,
    IN inIsErased           Boolean ,
    IN inisEmployeeMessage  Boolean ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer
             , TotalCount TFloat, TotalSumm TFloat, TotalSummPayAdd TFloat, TotalSummChangePercent TFloat
             , UnitName TVarChar, CashRegisterName TVarChar, PaidTypeName TVarChar
             , CashMember TVarChar, Bayer TVarChar, FiscalCheckNumber TVarChar
             , NotMCS Boolean, IsDeferred Boolean
             , isSite Boolean, isCallOrder Boolean
             , DiscountCardName TVarChar, DiscountExternalName TVarChar
             , BayerPhone TVarChar
             , InvNumberOrder TVarChar
             , ConfirmedKindName TVarChar
             , ConfirmedKindClientName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , OperDateSP TDateTime
             , PartnerMedicalName TVarChar
             , MedicSPName TVarChar
             , Ambulance TVarChar
             , SPKindName TVarChar
             , InvNumber_Invoice_Full TVarChar
             , StatusCode_PromoCode Integer
             , InvNumber_PromoCode_Full TVarChar
             , GUID_PromoCode TVarChar
             , MemberSPId Integer, MemberSPName TVarChar
             , GroupMemberSPId Integer, GroupMemberSPName TVarChar
             , Address_MemberSP  TVarChar
             , INN_MemberSP      TVarChar
             , Passport_MemberSP TVarChar
             , BankPOSTerminalName TVarChar
             , JackdawsChecksName TVarChar
             , Delay Boolean, DateDelay TDateTime
             , SummCard TFloat
             , CancelReason TVarChar
             , isDeliverySite Boolean
             , SummaDelivery TFloat
             , CommentCustomer TVarChar
             , isErrorRRO Boolean 
             , isMobileApplication Boolean, isMobileFirstOrder Boolean
             , UserReferalsName TVarChar, isConfirmByPhone Boolean, DateComing TDateTime 
             , MobileDiscount TFloat, ApplicationAward TFloat, isEmployeeMessage Boolean
             , Color_UserReferals Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbRetailId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId WHERE inIsUnComplete = TRUE
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         ),
            tmpMovementAll AS (SELECT MovementLinkObject.ObjectId                                     AS UserId
                                    , MovementLinkObject.MovementId
                               FROM MovementLinkObject
                               WHERE MovementLinkObject.DescId = zc_MovementLinkObject_UserReferals()),
            tmpMovement AS (SELECT MovementLinkObject.MovementId
                                 , ROW_NUMBER() OVER (PARTITION BY COALESCE (ObjectString_BuyerForSite_Phone.ValueData, 
                                                                            MovementString_BayerPhone.ValueData) ORDER BY Movement.ID DESC) AS Ord
                            FROM tmpMovementAll AS MovementLinkObject
 
                                 INNER JOIN Movement ON Movement.Id = MovementLinkObject.MovementId
                                                    AND Movement.StatusId = zc_Enum_Status_Complete()
                                    
                                 LEFT JOIN MovementString AS MovementString_BayerPhone
                                                          ON MovementString_BayerPhone.MovementId = Movement.Id
                                                         AND MovementString_BayerPhone.DescId = zc_MovementString_BayerPhone()

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_BuyerForSite
                                                              ON MovementLinkObject_BuyerForSite.MovementId = Movement.Id
                                                             AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
                                 LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                                                        ON ObjectString_BuyerForSite_Phone.ObjectId = MovementLinkObject_BuyerForSite.ObjectId
                                                       AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()
                            )
                            
         SELECT
             Movement_Check.Id
           , Movement_Check.InvNumber
           , Movement_Check.OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , MovementFloat_TotalSumm.ValueData                  AS TotalSumm
           , MovementFloat_TotalSummPayAdd.ValueData            AS TotalSummPatAdd
           , MovementFloat_TotalSummChangePercent.ValueData     AS TotalSummChangePercent
           , Object_Unit.ValueData                              AS UnitName
           , Object_CashRegister.ValueData                      AS CashRegisterName
           , Object_PaidType.ValueData                          AS PaidTypeName
           , CASE WHEN MovementString_InvNumberOrder.ValueData <> '' AND COALESCE (Object_CashMember.ValueData, '') = '' THEN zc_Member_Site() ELSE Object_CashMember.ValueData END :: TVarChar AS CashMember
           , COALESCE(Object_BuyerForSite.ValueData,
                      MovementString_Bayer.ValueData)           AS Bayer
           , MovementString_FiscalCheckNumber.ValueData         AS FiscalCheckNumber
           , COALESCE(MovementBoolean_NotMCS.ValueData,FALSE)   AS NotMCS
           , Movement_Check.IsDeferred                          AS IsDeferred
           , COALESCE(MovementBoolean_Site.ValueData,FALSE) :: Boolean AS isSite
           , COALESCE(MovementBoolean_CallOrder.ValueData,FALSE) :: Boolean AS isCallOrder
           , Object_DiscountCard.ValueData                      AS DiscountCardName
           , Object_DiscountExternal.ValueData                  AS DiscountExternalName
           , COALESCE (ObjectString_BuyerForSite_Phone.ValueData, 
                       MovementString_BayerPhone.ValueData)     AS BayerPhone
           , MovementString_InvNumberOrder.ValueData            AS InvNumberOrder
           , Object_ConfirmedKind.ValueData                     AS ConfirmedKindName
           , Object_ConfirmedKindClient.ValueData               AS ConfirmedKindClientName

           , Object_Insert.ValueData                            AS InsertName
           , MovementDate_Insert.ValueData                      AS InsertDate

           , MovementDate_OperDateSP.ValueData                  AS OperDateSP
           , Object_PartnerMedical.ValueData                    AS PartnerMedicalName
           , MovementString_MedicSP.ValueData                   AS MedicSPName
           , MovementString_Ambulance.ValueData                 AS Ambulance
           , Object_SPKind.ValueData                            AS SPKindName
           , ('№ ' || Movement_Invoice.InvNumber || ' от ' || Movement_Invoice.OperDate  :: Date :: TVarChar )     :: TVarChar  AS InvNumber_Invoice_Full

           , Object_Status_PromoCode.ObjectCode                 AS StatusCode_PromoCode
           , ('№ ' || Movement_PromoCode.InvNumber || ' от ' || Movement_PromoCode.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_PromoCode_Full
           , MIString_GUID.ValueData                 ::TVarChar AS GUID_PromoCode

           , Object_MemberSP.Id                                           AS MemberSPId
           , Object_MemberSP.ValueData                                    AS MemberSPName
           , Object_GroupMemberSP.Id                                      AS GroupMemberSPId
           , Object_GroupMemberSP.ValueData                               AS GroupMemberSPName
           , COALESCE (ObjectString_Address.ValueData, '')   :: TVarChar  AS Address_MemberSP
           , COALESCE (ObjectString_INN.ValueData, '')       :: TVarChar  AS INN_MemberSP
           , COALESCE (ObjectString_Passport.ValueData, '')  :: TVarChar  AS Passport_MemberSP
           , Object_BankPOSTerminal.ValueData                             AS BankPOSTerminalName
           , Object_JackdawsChecks.ValueData                              AS JackdawsChecksName
           , COALESCE (MovementBoolean_Delay.ValueData, False)::Boolean   AS Delay
           , MovementDate_Delay.ValueData                                 AS DateDelay
           , MovementFloat_TotalSummCard.ValueData                        AS SummCard
           , CASE WHEN Movement_Check.StatusId = zc_Enum_Status_Erased()
                  THEN COALESCE(Object_CancelReason.ValueData, CancelReasonDefault.Name) END::TVarChar  AS CancelReason
           , COALESCE(MovementBoolean_DeliverySite.ValueData, False)      AS isDeliverySite
           , MovementFloat_SummaDelivery.ValueData                        AS SummaDelivery

           , MovementString_CommentCustomer.ValueData                     AS CommentCustomer
           , COALESCE(MovementBoolean_ErrorRRO.ValueData, False)          AS isErrorRRO
           
           , COALESCE (MovementBoolean_MobileApplication.ValueData, False)::Boolean   AS isMobileApplication
           , COALESCE (MovementBoolean_MobileFirstOrder.ValueData, False)::Boolean    AS isMobileFirstOrder
           
           , Object_UserReferals.ValueData                                            AS UserReferalsName
           , COALESCE(MovementBoolean_ConfirmByPhone.ValueData, False)::Boolean      AS isConfirmByPhone
           , MovementDate_Coming.ValueData                                AS DateComing
           , CASE WHEN Movement_Check.StatusId = zc_Enum_Status_Complete() THEN MovementFloat_MobileDiscount.ValueData END::TFloat AS MobileDiscount
           
           , CASE WHEN COALESCE (tmpMovement.MovementId, 0) <> 0 THEN 20 END::TFloat  AS ApplicationAward
           
           , Movement_Check.isEmployeeMessage                             AS isEmployeeMessage
           
           , zc_Color_Yelow()                                             AS Color_UserReferals

        FROM (SELECT Movement.*
                   , MovementLinkObject_Unit.ObjectId                    AS UnitId
                   , MovementLinkObject_CheckMember.ObjectId             AS MemberId
                   , COALESCE(MovementBoolean_Deferred.ValueData, False) AS IsDeferred
                   , COALESCE (MovementBoolean_EmployeeMessage.ValueData, False)::Boolean     AS isEmployeeMessage
              FROM Movement
                   INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId

                   INNER JOIN MovementBoolean AS MovementBoolean_MobileApplication
                                              ON MovementBoolean_MobileApplication.MovementId = Movement.Id
                                             AND MovementBoolean_MobileApplication.DescId = zc_MovementBoolean_MobileApplication()
                                             AND MovementBoolean_MobileApplication.ValueData = True

                   LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                                ON MovementLinkObject_CheckSourceKind.MovementId =  Movement.Id
                                               AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()

                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                ON MovementLinkObject_Unit.MovementId = Movement.Id
                                               AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                   LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckMember
                                                ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                               AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()

                   LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                             ON MovementBoolean_Deferred.MovementId = Movement.Id
                                            AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                   
                   LEFT JOIN MovementBoolean AS MovementBoolean_EmployeeMessage
                                             ON MovementBoolean_EmployeeMessage.MovementId = Movement.Id
                                            AND MovementBoolean_EmployeeMessage.DescId = zc_MovementBoolean_EmployeeMessage()

              WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                AND Movement.DescId = zc_Movement_Check()
                AND COALESCE(MovementBoolean_Deferred.ValueData, FALSE) = TRUE
                AND COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) = 0
                AND (MovementLinkObject_Unit.ObjectId = inUnitId OR COALESCE(inUnitId, 0) = 0)
                AND (COALESCE (MovementBoolean_EmployeeMessage.ValueData, False) = TRUE OR COALESCE(inisEmployeeMessage, False) = False)
           ) AS Movement_Check
             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Check.StatusId
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement_Check.UnitId

             LEFT JOIN MovementDate AS MovementDate_OperDateSP
                                    ON MovementDate_OperDateSP.MovementId = Movement_Check.Id
                                   AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()

             LEFT JOIN MovementDate AS MovementDate_Insert
                                    ON MovementDate_Insert.MovementId = Movement_Check.Id
                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

             LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                     ON MovementFloat_TotalCount.MovementId = Movement_Check.Id
                                    AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

             LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                     ON MovementFloat_TotalSumm.MovementId =  Movement_Check.Id
                                    AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

             LEFT JOIN MovementFloat AS MovementFloat_TotalSummCard
                                     ON MovementFloat_TotalSummCard.MovementId = Movement_Check.Id
                                    AND MovementFloat_TotalSummCard.DescId = zc_MovementFloat_TotalSummCard()

             LEFT JOIN MovementFloat AS MovementFloat_TotalSummPayAdd
                                     ON MovementFloat_TotalSummPayAdd.MovementId =  Movement_Check.Id
                                    AND MovementFloat_TotalSummPayAdd.DescId = zc_MovementFloat_TotalSummPayAdd()
             LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                     ON MovementFloat_TotalSummChangePercent.MovementId =  Movement_Check.Id
                                    AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()

             LEFT JOIN MovementFloat AS MovementFloat_SummaDelivery
                                     ON MovementFloat_SummaDelivery.MovementId =  Movement_Check.Id
                                    AND MovementFloat_SummaDelivery.DescId = zc_MovementFloat_SummaDelivery()

             LEFT JOIN MovementFloat AS MovementFloat_MobileDiscount
                                     ON MovementFloat_MobileDiscount.MovementId =  Movement_Check.Id
                                    AND MovementFloat_MobileDiscount.DescId = zc_MovementFloat_MobileDiscount()

             LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                      ON MovementString_InvNumberOrder.MovementId = Movement_Check.Id
                                     AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
	         LEFT JOIN MovementString AS MovementString_Bayer
                                      ON MovementString_Bayer.MovementId = Movement_Check.Id
                                     AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
             LEFT JOIN MovementString AS MovementString_BayerPhone
                                      ON MovementString_BayerPhone.MovementId = Movement_Check.Id
                                     AND MovementString_BayerPhone.DescId = zc_MovementString_BayerPhone()
             LEFT JOIN MovementString AS MovementString_FiscalCheckNumber
                                      ON MovementString_FiscalCheckNumber.MovementId = Movement_Check.Id
                                     AND MovementString_FiscalCheckNumber.DescId = zc_MovementString_FiscalCheckNumber()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_BuyerForSite
                                          ON MovementLinkObject_BuyerForSite.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
             LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId
             LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                                    ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                                   AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()

             LEFT JOIN MovementString AS MovementString_MedicSP
                                      ON MovementString_MedicSP.MovementId = Movement_Check.Id
                                     AND MovementString_MedicSP.DescId = zc_MovementString_MedicSP()
             LEFT JOIN MovementString AS MovementString_Ambulance
                                      ON MovementString_Ambulance.MovementId = Movement_Check.Id
                                     AND MovementString_Ambulance.DescId = zc_MovementString_Ambulance()

             LEFT JOIN MovementString AS MovementString_OrderId
                                      ON MovementString_OrderId.MovementId = Movement_Check.Id
                                     AND MovementString_OrderId.DescId = zc_MovementString_OrderId()

             LEFT JOIN MovementBoolean AS MovementBoolean_NotMCS
                                       ON MovementBoolean_NotMCS.MovementId = Movement_Check.Id
                                      AND MovementBoolean_NotMCS.DescId = zc_MovementBoolean_NotMCS()

             LEFT JOIN MovementBoolean AS MovementBoolean_Site
                                       ON MovementBoolean_Site.MovementId = Movement_Check.Id
                                      AND MovementBoolean_Site.DescId = zc_MovementBoolean_Site()
             LEFT JOIN MovementBoolean AS MovementBoolean_CallOrder
                                       ON MovementBoolean_CallOrder.MovementId = Movement_Check.Id
                                      AND MovementBoolean_CallOrder.DescId = zc_MovementBoolean_CallOrder()

	         LEFT JOIN MovementBoolean AS MovementBoolean_DeliverySite
                                       ON MovementBoolean_DeliverySite.MovementId = Movement_Check.Id
                                      AND MovementBoolean_DeliverySite.DescId = zc_MovementBoolean_DeliverySite()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                          ON MovementLinkObject_CashRegister.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
             LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

   	         LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidType
                                          ON MovementLinkObject_PaidType.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()
             LEFT JOIN Object AS Object_PaidType ON Object_PaidType.Id = MovementLinkObject_PaidType.ObjectId

             LEFT JOIN Object AS Object_CashMember ON Object_CashMember.Id = Movement_Check.MemberId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_DiscountCard
                                          ON MovementLinkObject_DiscountCard.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()
             LEFT JOIN Object AS Object_DiscountCard ON Object_DiscountCard.Id = MovementLinkObject_DiscountCard.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                          ON MovementLinkObject_ConfirmedKind.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
             LEFT JOIN Object AS Object_ConfirmedKind ON Object_ConfirmedKind.Id = MovementLinkObject_ConfirmedKind.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKindClient
                                          ON MovementLinkObject_ConfirmedKindClient.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_ConfirmedKindClient.DescId = zc_MovementLinkObject_ConfirmedKindClient()
             LEFT JOIN Object AS Object_ConfirmedKindClient ON Object_ConfirmedKindClient.Id = MovementLinkObject_ConfirmedKindClient.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                          ON MovementLinkObject_PartnerMedical.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
             LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = MovementLinkObject_PartnerMedical.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                          ON MovementLinkObject_SPKind.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
             LEFT JOIN Object AS Object_SPKind ON Object_SPKind.Id = MovementLinkObject_SPKind.ObjectId

             LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                  ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountCard.Id
                                 AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountCard_Object()
             LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = ObjectLink_DiscountExternal.ChildObjectId

             LEFT JOIN MovementLinkObject AS MLO_Insert
                                          ON MLO_Insert.MovementId = Movement_Check.Id
                                         AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
             LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

             LEFT JOIN MovementLinkMovement AS MLM_Child
                                            ON MLM_Child.MovementId = Movement_Check.Id
                                           AND MLM_Child.descId = zc_MovementLinkMovement_Child()
             LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MLM_Child.MovementChildId

            -- инфа из документа промо код
            LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                    ON MovementFloat_MovementItemId.MovementId = Movement_Check.Id
                                   AND MovementFloat_MovementItemId.DescId     = zc_MovementFloat_MovementItemId()
            LEFT JOIN MovementItem AS MI_PromoCode
                                   ON MI_PromoCode.Id       = MovementFloat_MovementItemId.ValueData :: Integer
                                  AND MI_PromoCode.isErased = FALSE
            LEFT JOIN Movement AS Movement_PromoCode ON Movement_PromoCode.Id = MI_PromoCode.MovementId
            LEFT JOIN Object AS Object_Status_PromoCode ON Object_Status_PromoCode.Id = Movement_PromoCode.StatusId

            LEFT JOIN MovementItemString AS MIString_GUID
                                         ON MIString_GUID.MovementItemId = MI_PromoCode.Id
                                        AND MIString_GUID.DescId = zc_MIString_GUID()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberSP
                                         ON MovementLinkObject_MemberSP.MovementId = Movement_Check.Id
                                        AND MovementLinkObject_MemberSP.DescId = zc_MovementLinkObject_MemberSP()
            LEFT JOIN Object AS Object_MemberSP ON Object_MemberSP.Id = MovementLinkObject_MemberSP.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Address
                                   ON ObjectString_Address.ObjectId = MovementLinkObject_MemberSP.ObjectId
                                  AND ObjectString_Address.DescId = zc_ObjectString_MemberSP_Address()
            LEFT JOIN ObjectString AS ObjectString_INN
                                   ON ObjectString_INN.ObjectId = MovementLinkObject_MemberSP.ObjectId
                                  AND ObjectString_INN.DescId = zc_ObjectString_MemberSP_INN()
            LEFT JOIN ObjectString AS ObjectString_Passport
                                   ON ObjectString_Passport.ObjectId = MovementLinkObject_MemberSP.ObjectId
                                  AND ObjectString_Passport.DescId = zc_ObjectString_MemberSP_Passport()
            LEFT JOIN ObjectLink AS ObjectLink_MemberSP_GroupMemberSP
                                 ON ObjectLink_MemberSP_GroupMemberSP.ObjectId = MovementLinkObject_MemberSP.ObjectId
                                AND ObjectLink_MemberSP_GroupMemberSP.DescId = zc_ObjectLink_MemberSP_GroupMemberSP()
            LEFT JOIN Object AS Object_GroupMemberSP ON Object_GroupMemberSP.Id = ObjectLink_MemberSP_GroupMemberSP.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_BankPOSTerminal
                                         ON MovementLinkObject_BankPOSTerminal.MovementId =  Movement_Check.Id
                                        AND MovementLinkObject_BankPOSTerminal.DescId = zc_MovementLinkObject_BankPOSTerminal()
            LEFT JOIN Object AS Object_BankPOSTerminal ON Object_BankPOSTerminal.Id = MovementLinkObject_BankPOSTerminal.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_JackdawsChecks
                                         ON MovementLinkObject_JackdawsChecks.MovementId =  Movement_Check.Id
                                        AND MovementLinkObject_JackdawsChecks.DescId = zc_MovementLinkObject_JackdawsChecks()
            LEFT JOIN Object AS Object_JackdawsChecks ON Object_JackdawsChecks.Id = MovementLinkObject_JackdawsChecks.ObjectId

            LEFT JOIN MovementBoolean AS MovementBoolean_Delay
                                      ON MovementBoolean_Delay.MovementId = Movement_Check.Id
                                     AND MovementBoolean_Delay.DescId = zc_MovementBoolean_Delay()

            LEFT JOIN MovementDate AS MovementDate_Delay
                                   ON MovementDate_Delay.MovementId = Movement_Check.Id
                                  AND MovementDate_Delay.DescId = zc_MovementDate_Delay()
            LEFT JOIN MovementDate AS MovementDate_Coming
                                   ON MovementDate_Coming.MovementId = Movement_Check.Id
                                  AND MovementDate_Coming.DescId = zc_MovementDate_Coming()

            LEFT JOIN MovementString AS MovementString_CommentCustomer
                                     ON MovementString_CommentCustomer.MovementId = Movement_Check.Id
                                    AND MovementString_CommentCustomer.DescId = zc_MovementString_CommentCustomer()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CancelReason
                                         ON MovementLinkObject_CancelReason.MovementId = Movement_Check.Id
                                        AND MovementLinkObject_CancelReason.DescId = zc_MovementLinkObject_CancelReason()
            LEFT JOIN Object AS Object_CancelReason ON Object_CancelReason.Id = MovementLinkObject_CancelReason.ObjectId
                                     
            LEFT JOIN (SELECT * FROM gpSelect_Object_CancelReason('3') AS CR ORDER BY CR.Code LIMIT 1) AS CancelReasonDefault ON 1 = 1 

            LEFT JOIN MovementBoolean AS MovementBoolean_ErrorRRO
                                      ON MovementBoolean_ErrorRRO.MovementId = Movement_Check.Id
                                     AND MovementBoolean_ErrorRRO.DescId = zc_MovementBoolean_ErrorRRO()

            LEFT JOIN MovementBoolean AS MovementBoolean_MobileApplication
                                      ON MovementBoolean_MobileApplication.MovementId = Movement_Check.Id
                                     AND MovementBoolean_MobileApplication.DescId = zc_MovementBoolean_MobileApplication()
            LEFT JOIN MovementBoolean AS MovementBoolean_ConfirmByPhone
                                      ON MovementBoolean_ConfirmByPhone.MovementId = Movement_Check.Id
                                     AND MovementBoolean_ConfirmByPhone.DescId = zc_MovementBoolean_ConfirmByPhone()
            LEFT JOIN MovementBoolean AS MovementBoolean_MobileFirstOrder
                                      ON MovementBoolean_MobileFirstOrder.MovementId = Movement_Check.Id
                                     AND MovementBoolean_MobileFirstOrder.DescId = zc_MovementBoolean_MobileFirstOrder()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_UserReferals
                                         ON MovementLinkObject_UserReferals.MovementId = Movement_Check.Id
                                        AND MovementLinkObject_UserReferals.DescId = zc_MovementLinkObject_UserReferals()
            LEFT JOIN Object AS Object_UserReferals ON Object_UserReferals.Id = MovementLinkObject_UserReferals.ObjectId
            
            LEFT JOIN tmpMovement ON tmpMovement.MovementId = Movement_Check.Id
                                 AND tmpMovement.Ord = 1
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_Check (TDateTime, TDateTime, Boolean, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.04.21                                                       * add BuyerForSite
 01.07.20                                                       *
*/

-- тест
-- 


select * from gpReport_CheckMobile(inStartDate := ('01.08.2022')::TDateTime , inEndDate := ('30.09.2022')::TDateTime , inUnitId := 0 , inIsUnComplete := 'True' , inIsErased := 'True' , inisEmployeeMessage := 'False' ,  inSession := '3');

