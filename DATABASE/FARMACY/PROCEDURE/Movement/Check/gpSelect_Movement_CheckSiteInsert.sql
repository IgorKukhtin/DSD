-- Function: gpSelect_Movement_CheckSiteInsert()

DROP FUNCTION IF EXISTS gpSelect_Movement_CheckSiteInsert (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_CheckSiteInsert(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, OperDateCreate TDateTime, StatusCode Integer
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
             , CheckSourceKindName TVarChar
             , SummCard TFloat
             , CancelReason TVarChar
             , isDeliverySite Boolean
             , SummaDelivery TFloat
             , CommentCustomer TVarChar
             , isErrorRRO Boolean 
             , isMobileApplication Boolean 
             , UserReferalsName TVarChar, isConfirmByPhone Boolean, DateComing TDateTime 
             , MobileDiscount TFloat
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
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         ),
            Movement_CheckAll AS (SELECT Movement.*
                                       , COALESCE(MovementBoolean_Deferred.ValueData, False) AS IsDeferred
                                  FROM Movement
                                       INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
 
                                       INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                                  ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                                 AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                                 AND MovementBoolean_Deferred.ValueData = TRUE
                                     
                                  WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate) - INTERVAL '10 DAY'
                                    AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '10 DAY'
                                    AND Movement.DescId = zc_Movement_Check()
                                ),
            Movement_Check AS (SELECT Movement.*
                                    , MovementLinkObject_Unit.ObjectId                    AS UnitId
                                    , MovementLinkObject_CheckMember.ObjectId             AS MemberId
                                    , MovementLinkObject_CheckSourceKind.ObjectId         AS CheckSourceKindId
                                    , MovementString_InvNumberOrder.ValueData             AS InvNumberOrder
                               FROM Movement_CheckAll AS Movement

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckMember
                                                                 ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                                                AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                                                 ON MovementLinkObject_CheckSourceKind.MovementId =  Movement.Id
                                                                AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()

                                    LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                                             ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                                            AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

                               WHERE (COALESCE(MovementLinkObject_CheckSourceKind.ObjectId, 0) <> 0 OR COALESCE (MovementString_InvNumberOrder.ValueData, '') <> '')
                             ),
            tmpMovementProtocol AS (SELECT MovementProtocol.MovementId               AS Id
                                         , MIN(MovementProtocol.OperDate)::TDateTime  AS OperDate
                                    FROM MovementProtocol 
                                    WHERE MovementProtocol.MovementId in (select Movement_Check.ID from Movement_Check)
                                    GROUP BY  MovementProtocol.MovementId),
            tmpMovementLinkObject AS (SELECT * FROM MovementLinkObject
                                      WHERE MovementLinkObject.MovementId in (select Movement_Check.ID from Movement_Check)),
            tmpMovementString AS (SELECT * FROM MovementString
                                  WHERE MovementString.MovementId in (select Movement_Check.ID from Movement_Check))
                             

         SELECT
             Movement_Check.Id
           , Movement_Check.InvNumber
           , Movement_Check.OperDate
           , tmpMovementProtocol.OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , MovementFloat_TotalSumm.ValueData                  AS TotalSumm
           , MovementFloat_TotalSummPayAdd.ValueData            AS TotalSummPatAdd
           , MovementFloat_TotalSummChangePercent.ValueData     AS TotalSummChangePercent
           , Object_Unit.ValueData                              AS UnitName
           , Object_CashRegister.ValueData                      AS CashRegisterName
           , Object_PaidType.ValueData                          AS PaidTypeName
           , CASE WHEN Movement_Check.InvNumberOrder <> '' AND COALESCE (Object_CashMember.ValueData, '') = '' THEN zc_Member_Site() ELSE Object_CashMember.ValueData END :: TVarChar AS CashMember
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
           , COALESCE(Movement_Check.InvNumberOrder,
             CASE WHEN COALESCE (Movement_Check.CheckSourceKindId, 0) = zc_Enum_CheckSourceKind_Tabletki() THEN MovementString_OrderId.ValueData
                  WHEN COALESCE (Movement_Check.CheckSourceKindId, 0) <> 0 THEN Movement_Check.Id::TVarChar END)::TVarChar   AS InvNumberOrder
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
           , Object_CheckSourceKind.ValueData                             AS CheckSourceKindName
           , MovementFloat_TotalSummCard.ValueData                        AS SummCard
           , CASE WHEN Movement_Check.StatusId = zc_Enum_Status_Erased()
                  THEN COALESCE(Object_CancelReason.ValueData, CancelReasonDefault.Name) END::TVarChar  AS CancelReason
           , COALESCE(MovementBoolean_DeliverySite.ValueData, False)      AS isDeliverySite
           , MovementFloat_SummaDelivery.ValueData                        AS SummaDelivery

           , MovementString_CommentCustomer.ValueData                     AS CommentCustomer
           , COALESCE(MovementBoolean_ErrorRRO.ValueData, False)          AS isErrorRRO
           
           , COALESCE (MovementBoolean_MobileApplication.ValueData, False)::Boolean   AS isMobileApplication
           , Object_UserReferals.ValueData                                            AS UserReferalsName
           , COALESCE(MovementBoolean_ConfirmByPhone.ValueData, False)::Boolean      AS isConfirmByPhone
           , MovementDate_Coming.ValueData                                AS DateComing
           , MovementFloat_MobileDiscount.ValueData                       AS MobileDiscount

        FROM Movement_Check
        
             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Check.StatusId
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement_Check.UnitId
             
             INNER JOIN tmpMovementProtocol ON tmpMovementProtocol.Id = Movement_Check.Id

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

	         LEFT JOIN tmpMovementString AS MovementString_Bayer
                                      ON MovementString_Bayer.MovementId = Movement_Check.Id
                                     AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
             LEFT JOIN tmpMovementString AS MovementString_BayerPhone
                                      ON MovementString_BayerPhone.MovementId = Movement_Check.Id
                                     AND MovementString_BayerPhone.DescId = zc_MovementString_BayerPhone()
             LEFT JOIN tmpMovementString AS MovementString_FiscalCheckNumber
                                      ON MovementString_FiscalCheckNumber.MovementId = Movement_Check.Id
                                     AND MovementString_FiscalCheckNumber.DescId = zc_MovementString_FiscalCheckNumber()

             LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_BuyerForSite
                                          ON MovementLinkObject_BuyerForSite.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
             LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId
             LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                                    ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                                   AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()

             LEFT JOIN tmpMovementString AS MovementString_MedicSP
                                      ON MovementString_MedicSP.MovementId = Movement_Check.Id
                                     AND MovementString_MedicSP.DescId = zc_MovementString_MedicSP()
             LEFT JOIN tmpMovementString AS MovementString_Ambulance
                                      ON MovementString_Ambulance.MovementId = Movement_Check.Id
                                     AND MovementString_Ambulance.DescId = zc_MovementString_Ambulance()

             LEFT JOIN tmpMovementString AS MovementString_OrderId
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

             LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CashRegister
                                          ON MovementLinkObject_CashRegister.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
             LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

   	         LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_PaidType
                                          ON MovementLinkObject_PaidType.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()
             LEFT JOIN Object AS Object_PaidType ON Object_PaidType.Id = MovementLinkObject_PaidType.ObjectId

             LEFT JOIN Object AS Object_CashMember ON Object_CashMember.Id = Movement_Check.MemberId

             LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_DiscountCard
                                          ON MovementLinkObject_DiscountCard.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()
             LEFT JOIN Object AS Object_DiscountCard ON Object_DiscountCard.Id = MovementLinkObject_DiscountCard.ObjectId

             LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_ConfirmedKind
                                          ON MovementLinkObject_ConfirmedKind.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
             LEFT JOIN Object AS Object_ConfirmedKind ON Object_ConfirmedKind.Id = MovementLinkObject_ConfirmedKind.ObjectId

             LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_ConfirmedKindClient
                                          ON MovementLinkObject_ConfirmedKindClient.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_ConfirmedKindClient.DescId = zc_MovementLinkObject_ConfirmedKindClient()
             LEFT JOIN Object AS Object_ConfirmedKindClient ON Object_ConfirmedKindClient.Id = MovementLinkObject_ConfirmedKindClient.ObjectId

             LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_PartnerMedical
                                          ON MovementLinkObject_PartnerMedical.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
             LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = MovementLinkObject_PartnerMedical.ObjectId

             LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_SPKind
                                          ON MovementLinkObject_SPKind.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
             LEFT JOIN Object AS Object_SPKind ON Object_SPKind.Id = MovementLinkObject_SPKind.ObjectId

             LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                  ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountCard.Id
                                 AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountCard_Object()
             LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = ObjectLink_DiscountExternal.ChildObjectId

             LEFT JOIN tmpMovementLinkObject AS MLO_Insert
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

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_MemberSP
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

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_BankPOSTerminal
                                         ON MovementLinkObject_BankPOSTerminal.MovementId =  Movement_Check.Id
                                        AND MovementLinkObject_BankPOSTerminal.DescId = zc_MovementLinkObject_BankPOSTerminal()
            LEFT JOIN Object AS Object_BankPOSTerminal ON Object_BankPOSTerminal.Id = MovementLinkObject_BankPOSTerminal.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_JackdawsChecks
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

            LEFT JOIN Object AS Object_CheckSourceKind ON Object_CheckSourceKind.Id = Movement_Check.CheckSourceKindId

            LEFT JOIN tmpMovementString AS MovementString_BookingId
                                     ON MovementString_BookingId.MovementId = Movement_Check.Id
                                    AND MovementString_BookingId.DescId = zc_MovementString_BookingId()

            LEFT JOIN tmpMovementString AS MovementString_CommentCustomer
                                     ON MovementString_CommentCustomer.MovementId = Movement_Check.Id
                                    AND MovementString_CommentCustomer.DescId = zc_MovementString_CommentCustomer()

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CancelReason
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

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_UserReferals
                                         ON MovementLinkObject_UserReferals.MovementId = Movement_Check.Id
                                        AND MovementLinkObject_UserReferals.DescId = zc_MovementLinkObject_UserReferals()
            LEFT JOIN Object AS Object_UserReferals ON Object_UserReferals.Id = MovementLinkObject_UserReferals.ObjectId
            
       WHERE tmpMovementProtocol.OperDate >= DATE_TRUNC ('DAY', inStartDate)
         AND tmpMovementProtocol.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_CheckSiteInsert (TDateTime, TDateTime, Boolean, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.09.22                                                       *
*/

-- тест
-- 

select * from gpSelect_Movement_CheckSiteInsert(inStartDate := ('31.08.2022')::TDateTime , inEndDate := ('31.08.2022')::TDateTime , inIsErased := 'False' ,  inSession := '3');