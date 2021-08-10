-- Function: gpGet_Movement_Check()

DROP FUNCTION IF EXISTS gpGet_Movement_Check (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Check(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalSumm TFloat, TotalSummPayAdd TFloat
             , UnitId Integer, UnitName TVarChar
             , CashRegisterName TVarChar, PaidKindName TVarChar, PaidTypeName TVarChar
             , CashMember TVarChar, Bayer TVarChar, FiscalCheckNumber TVarChar
             , NotMCS Boolean
             , isSite Boolean
             , DiscountCardName TVarChar
             , BayerPhone TVarChar
             , InvNumberOrder TVarChar
             , ConfirmedKindName TVarChar
             , ConfirmedKindClientName TVarChar

             , OperDateSP TDateTime
             , PartnerMedicalId Integer, PartnerMedicalName TVarChar
             , InvNumberSP TVarChar
             , MedicSPName TVarChar
             , Ambulance TVarChar
             , SPKindId   Integer, SPKindName TVarChar
             
             , InvNumber_PromoCode_Full TVarChar
             , GUID_PromoCode TVarChar
             , ManualDiscount Integer
             
             , MemberSPId Integer, MemberSPName TVarChar
             , GroupMemberSPId Integer, GroupMemberSPName TVarChar
             , Address_MemberSP  TVarChar
             , INN_MemberSP      TVarChar
             , Passport_MemberSP TVarChar
             
             , BankPOSTerminalId Integer, BankPOSTerminalName TVarChar
             , JackdawsChecksId Integer, JackdawsChecksName TVarChar
             , PartionDateKindId Integer, PartionDateKindName TVarChar
             , Delay Boolean
             , BuyerPhone TVarChar, BuyerName TVarChar, LoyaltySMDiscount TFloat, LoyaltySMSumma TFloat
             , isCorrectMarketing Boolean , isCorrectIlliquidMarketing Boolean, isDoctors Boolean
)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Check());
     vbUserId := inSession;

     RETURN QUERY
         WITH tmpPromoCode AS (SELECT Movement_PromoCode.InvNumber
                                    , Movement_PromoCode.OperDate  
                                    , MIString_GUID.ValueData 
                                    FROM MovementFloat AS MovementFloat_MovementItemId
                                                              
                                       LEFT JOIN MovementItem AS MI_PromoCode 
                                                              ON MI_PromoCode.Id       = MovementFloat_MovementItemId.ValueData :: Integer
                                                             AND MI_PromoCode.isErased = FALSE
                                       LEFT JOIN Movement AS Movement_PromoCode ON Movement_PromoCode.Id = MI_PromoCode.MovementId
                            
                                       LEFT JOIN MovementItemString AS MIString_GUID
                                                                    ON MIString_GUID.MovementItemId = MI_PromoCode.Id
                                                                   AND MIString_GUID.DescId = zc_MIString_GUID()
                                    WHERE MovementFloat_MovementItemId.MovementId = inMovementId
                                      AND MovementFloat_MovementItemId.DescId     = zc_MovementFloat_MovementItemId())
              -- Программа лояльности накопительная                                      
             , tmpLoyaltySM AS (SELECT Object_Buyer.ValueData                                       AS BuyerPhone
                                     , ObjectString_Buyer_Name.ValueData                            AS BuyerName
                                     , MovementFloat_LoyaltySMDiscount.ValueData                    AS LoyaltySMDiscount
                                     , MovementFloat_LoyaltySMSumma.ValueData                       AS LoyaltySMSumma
           
                                FROM MovementFloat AS MovementFloat_LoyaltySMID
                                                          
                                 LEFT JOIN  MovementItem AS MovementItem_LoyaltySaveMoney
                                                         ON MovementItem_LoyaltySaveMoney.ID = COALESCE (MovementFloat_LoyaltySMID.ValueData, 0)::INTEGER
                                            LEFT JOIN Object AS Object_Buyer ON Object_Buyer.Id = MovementItem_LoyaltySaveMoney.ObjectId
                                            LEFT JOIN ObjectString AS ObjectString_Buyer_Name
                                                                   ON ObjectString_Buyer_Name.ObjectId = Object_Buyer.Id
                                                                  AND ObjectString_Buyer_Name.DescId = zc_ObjectString_Buyer_Name()
                                            LEFT JOIN MovementFloat AS MovementFloat_LoyaltySMDiscount
                                                                     ON MovementFloat_LoyaltySMDiscount.DescID = zc_MovementFloat_LoyaltySMDiscount()
                                                                    AND MovementFloat_LoyaltySMDiscount. MovementId = inMovementId
                                            LEFT JOIN MovementFloat AS MovementFloat_LoyaltySMSumma
                                                                     ON MovementFloat_LoyaltySMSumma.DescID = zc_MovementFloat_LoyaltySMSumma()
                                                                    AND MovementFloat_LoyaltySMSumma. MovementId = inMovementId
                                WHERE MovementFloat_LoyaltySMID.DescID = zc_MovementFloat_LoyaltySMID()
                                  AND MovementFloat_LoyaltySMID. MovementId = inMovementId) 
             , tmpMovementLinkObject AS (SELECT * FROM MovementLinkObject 
                                         WHERE MovementLinkObject.MovementId = inMovementId)

             , tmpMovement AS (SELECT       
                                       Movement.Id
                                     , Movement.InvNumber
                                     , Movement.OperDate
                                     , Movement.StatusId
                                     , Object_Status.ObjectCode                   AS StatusCode
                                     , Object_Status.ValueData                    AS StatusName
                                     , MovementFloat_TotalCount.ValueData         AS TotalCount
                                     , MovementFloat_TotalSumm.ValueData          AS TotalSumm
                                     , MovementFloat_TotalSummPayAdd.ValueData    AS TotalSummPayAdd
                                     , MovementFloat_TotalSummChangePercent.ValueData  AS TotalSummChangePercent
                                     , MovementLinkObject_Unit.ObjectId           AS UnitId
                                     , Object_Unit.ValueData                      AS UnitName
                                     , MovementLinkObject_PaidKind.ObjectId       AS PaidKindId  
                                     , Object_PaidKind.ValueData                  AS PaidKindName 
                                     , MovementLinkObject_CashRegister.ObjectId   AS CashRegisterId
                                     , Object_CashRegister.ValueData              AS CashRegisterName
                                     , COALESCE(MovementBoolean_Deferred.ValueData,False) AS IsDeferred
                                     , MovementLinkObject_CheckMember.ObjectId            AS CashMemberId
                                     , Object_CashMember.ValueData                AS CashMember
                                     , COALESCE(Object_BuyerForSite.ValueData,
                                                MovementString_Bayer.ValueData)    AS Bayer
                                     , MovementLinkObject_PaidType.ObjectId       AS PaidTypeId  
                                     , Object_PaidType.ValueData                          AS PaidTypeName 
                                     , MovementString_FiscalCheckNumber.ValueData         AS FiscalCheckNumber
                                     , COALESCE(MovementBoolean_NotMCS.ValueData,FALSE)   AS NotMCS

                                     , Object_DiscountCard.Id                          AS DiscountCardId 
                                     , Object_DiscountCard.ValueData                   AS DiscountCardName
                                       
                                     , COALESCE (ObjectString_BuyerForSite_Phone.ValueData, 
                                                 MovementString_BayerPhone.ValueData)  AS BayerPhone
                                     , MovementString_InvNumberOrder.ValueData         AS InvNumberOrder
                                     , MovementLinkObject_ConfirmedKind.ObjectId       AS ConfirmedKindId
                                     , Object_ConfirmedKind.ValueData                  AS ConfirmedKindName
                                     , MovementLinkObject_ConfirmedKindClient.ObjectId AS ConfirmedKindId_Client
                                     , Object_ConfirmedKindClient.ValueData            AS ConfirmedKindClientName

                                     , MovementDate_OperDateSP.ValueData               AS OperDateSP
                                     , MovementString_InvNumberSP.ValueData            AS InvNumberSP
                                     , MovementString_MedicSP.ValueData                AS MedicSPName
                                     , Object_PartnerMedical.Id                        AS PartnerMedicalId
                                     , Object_PartnerMedical.ValueData                 AS PartnerMedicalName
                                     , MovementString_Ambulance.ValueData              AS Ambulance
                                     , Object_SPKind.Id                                AS SPKindId
                                     , Object_SPKind.ValueData                         AS SPKindName
                                     , MovementFloat_ManualDiscount.ValueData::Integer AS ManualDiscount

                                     , Object_MemberSP.Id                              AS MemberSPId
                                     , Object_MemberSP.ValueData                       AS MemberSPName
                                 FROM Movement 
                                      LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

                                      LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                                              ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                                             AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

                                      LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                              ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                             AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                      LEFT JOIN MovementFloat AS MovementFloat_TotalSummPayAdd
                                                              ON MovementFloat_TotalSummPayAdd.MovementId =  Movement.Id
                                                             AND MovementFloat_TotalSummPayAdd.DescId = zc_MovementFloat_TotalSummPayAdd()
                                      LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                                              ON MovementFloat_TotalSummChangePercent.MovementId =  Movement.Id
                                                             AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()

                                      LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Unit
                                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                                      LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

                                      LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_PaidKind
                                                                      ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                                     AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

                                      LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

                                      LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CashRegister
                                                                      ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                                                     AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()

                                      LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

                                      LEFT OUTER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                                      ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                      LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CheckMember
                                                                      ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                                                     AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
                                      LEFT JOIN Object AS Object_CashMember ON Object_CashMember.Id = MovementLinkObject_CheckMember.ObjectId
                                      LEFT JOIN MovementString AS MovementString_Bayer
                                                                   ON MovementString_Bayer.MovementId = Movement.Id
                                                                  AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
                                      LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_PaidType
                                                                      ON MovementLinkObject_PaidType.MovementId = Movement.Id
                                                                     AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()
                                      LEFT JOIN Object AS Object_PaidType ON Object_PaidType.Id = MovementLinkObject_PaidType.ObjectId								  
                            			
                                      LEFT OUTER JOIN MovementString AS MovementString_FiscalCheckNumber
                                                                     ON MovementString_FiscalCheckNumber.MovementId = Movement.ID
                                                                    AND MovementString_FiscalCheckNumber.DescId = zc_MovementString_FiscalCheckNumber()
                                                                      
                                      LEFT OUTER JOIN MovementBoolean AS MovementBoolean_NotMCS
                                                                     ON MovementBoolean_NotMCS.MovementId = Movement.ID
                                                                    AND MovementBoolean_NotMCS.DescId = zc_MovementBoolean_NotMCS()

                                      LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_DiscountCard
                                                                      ON MovementLinkObject_DiscountCard.MovementId = Movement.Id
                                                                     AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()
                                      LEFT JOIN Object AS Object_DiscountCard ON Object_DiscountCard.Id = MovementLinkObject_DiscountCard.ObjectId

                                      LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_BuyerForSite
                                                                      ON MovementLinkObject_BuyerForSite.MovementId = Movement.Id
                                                                     AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
                                      LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId
                                      LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                                                             ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                                                            AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()

                                      LEFT JOIN MovementString AS MovementString_BayerPhone
                                                               ON MovementString_BayerPhone.MovementId = Movement.Id
                                                              AND MovementString_BayerPhone.DescId = zc_MovementString_BayerPhone()

                                      LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                                               ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                                              AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

                                      LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                                      ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                                     AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
                                      LEFT JOIN Object AS Object_ConfirmedKind ON Object_ConfirmedKind.Id = MovementLinkObject_ConfirmedKind.ObjectId
                                                   
                                      LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_ConfirmedKindClient
                                                                      ON MovementLinkObject_ConfirmedKindClient.MovementId = Movement.Id
                                                                     AND MovementLinkObject_ConfirmedKindClient.DescId = zc_MovementLinkObject_ConfirmedKindClient()
                                      LEFT JOIN Object AS Object_ConfirmedKindClient ON Object_ConfirmedKindClient.Id = MovementLinkObject_ConfirmedKindClient.ObjectId -- COALESCE (MovementLinkObject_ConfirmedKindClient.ObjectId, zc_Enum_ConfirmedKind_SmsNo())

                                      LEFT JOIN MovementString AS MovementString_InvNumberSP
                                                               ON MovementString_InvNumberSP.MovementId = Movement.Id
                                                              AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                                      LEFT JOIN MovementString AS MovementString_MedicSP
                                                               ON MovementString_MedicSP.MovementId = Movement.Id
                                                              AND MovementString_MedicSP.DescId = zc_MovementString_MedicSP()

                                      LEFT JOIN MovementString AS MovementString_Ambulance
                                                               ON MovementString_Ambulance.MovementId = Movement.Id
                                                              AND MovementString_Ambulance.DescId = zc_MovementString_Ambulance()

                                      LEFT JOIN MovementDate AS MovementDate_OperDateSP
                                                             ON MovementDate_OperDateSP.MovementId = Movement.Id
                                                            AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()

                                      LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_PartnerMedical
                                                                      ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                                                     AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
                                      LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = MovementLinkObject_PartnerMedical.ObjectId

                                      LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_SPKind
                                                                      ON MovementLinkObject_SPKind.MovementId = Movement.Id
                                                                     AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
                                      LEFT JOIN Object AS Object_SPKind ON Object_SPKind.Id = MovementLinkObject_SPKind.ObjectId

                                      LEFT JOIN MovementFloat AS MovementFloat_ManualDiscount
                                                              ON MovementFloat_ManualDiscount.MovementId = Movement.Id
                                                             AND MovementFloat_ManualDiscount.DescId = zc_MovementFloat_ManualDiscount()

                                      LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_MemberSP
                                                                      ON MovementLinkObject_MemberSP.MovementId = Movement.Id
                                                                     AND MovementLinkObject_MemberSP.DescId = zc_MovementLinkObject_MemberSP()
                                      LEFT JOIN Object AS Object_MemberSP ON Object_MemberSP.Id = MovementLinkObject_MemberSP.ObjectId

                             WHERE Movement.Id = inMovementId)


         SELECT       
             Movement_Check.Id
           , Movement_Check.InvNumber
           , Movement_Check.OperDate
           , Movement_Check.StatusCode
           , Movement_Check.StatusName
           , Movement_Check.TotalCount
           , Movement_Check.TotalSumm
           , Movement_Check.TotalSummPayAdd
           , Movement_Check.UnitId
           , Movement_Check.UnitName
           , Movement_Check.CashRegisterName
           , Movement_Check.PaidKindName
           , Movement_Check.PaidTypeName
           , CASE WHEN Movement_Check.InvNumberOrder <> '' AND COALESCE (Movement_Check.CashMember, '') = '' THEN zc_Member_Site() ELSE Movement_Check.CashMember END :: TVarChar AS CashMember
           , COALESCE( Movement_Check.Bayer, tmpLoyaltySM.BuyerName)
           , Movement_Check.FiscalCheckNumber
           , Movement_Check.NotMCS
           , COALESCE(MovementBoolean_Site.ValueData,FALSE) :: Boolean AS isSite
           , (Movement_Check.DiscountCardName || ' ' || COALESCE (Object_DiscountExternal.ValueData, '')) :: TVarChar AS DiscountCardName
           , COALESCE(Movement_Check.BayerPhone, tmpLoyaltySM.BuyerPhone)
           , Movement_Check.InvNumberOrder
           , Movement_Check.ConfirmedKindName
           , Movement_Check.ConfirmedKindClientName

           , Movement_Check.OperDateSP
           , Movement_Check.PartnerMedicalId
           , Movement_Check.PartnerMedicalName
           , Movement_Check.InvNumberSP
           , Movement_Check.MedicSPName
           , Movement_Check.Ambulance
           , Movement_Check.SPKindId
           , Movement_Check.SPKindName 

           , ('№ ' || tmpPromoCode.InvNumber || ' от ' || tmpPromoCode.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_PromoCode_Full
           , tmpPromoCode.ValueData                   ::TVarChar AS GUID_PromoCode
           , Movement_Check.ManualDiscount                      AS ManualDiscount
           
           , Movement_Check.MemberSPId
           , Movement_Check.MemberSPName
           , Object_GroupMemberSP.Id                                      AS GroupMemberSPId
           , Object_GroupMemberSP.ValueData                               AS GroupMemberSPName
           , COALESCE (ObjectString_Address.ValueData, '')   :: TVarChar  AS Address_MemberSP
           , COALESCE (ObjectString_INN.ValueData, '')       :: TVarChar  AS INN_MemberSP
           , COALESCE (ObjectString_Passport.ValueData, '')  :: TVarChar  AS Passport_MemberSP
           
           , Object_BankPOSTerminal.Id                                    AS BankPOSTerminalId
           , Object_BankPOSTerminal.ValueData                             AS BankPOSTerminalName

           , Object_JackdawsChecks.Id                                     AS JackdawsChecksId
           , Object_JackdawsChecks.ValueData                              AS JackdawsChecksName

           , Object_PartionDateKind.Id                                    AS PartionDateKindId
           , Object_PartionDateKind.ValueData                             AS PartionDateKindName

           , COALESCE (MovementBoolean_Delay.ValueData, False)::Boolean   AS Delay
           , tmpLoyaltySM.BuyerPhone                                      AS BuyerPhone
           , tmpLoyaltySM.BuyerName                                       AS BuyerName
           , tmpLoyaltySM.LoyaltySMDiscount                               AS LoyaltySMDiscount
           , tmpLoyaltySM.LoyaltySMSumma                                  AS LoyaltySMSumma
           , COALESCE(MovementBoolean_CorrectMarketing.ValueData, False)  AS isCorrectMarketing
           , COALESCE(MovementBoolean_CorrectIlliquidMarketing.ValueData, False)  AS isCorrectIlliquidMarketing
           , COALESCE(MovementBoolean_Doctors.ValueData, False)           AS isDoctors

        FROM tmpMovement AS Movement_Check
             LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                  ON ObjectLink_DiscountExternal.ObjectId = Movement_Check.DiscountCardId
                                 AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountCard_Object()
             LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = ObjectLink_DiscountExternal.ChildObjectId

             -- инфа из документа промо код
             LEFT JOIN tmpPromoCode ON 1 = 1
/*             LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                     ON MovementFloat_MovementItemId.MovementId = Movement_Check.Id
                                    AND MovementFloat_MovementItemId.DescId     = zc_MovementFloat_MovementItemId()
             LEFT JOIN MovementItem AS MI_PromoCode 
                                    ON MI_PromoCode.Id       = MovementFloat_MovementItemId.ValueData :: Integer
                                   AND MI_PromoCode.isErased = FALSE
             LEFT JOIN Movement AS Movement_PromoCode ON Movement_PromoCode.Id = MI_PromoCode.MovementId
  
             LEFT JOIN MovementItemString AS MIString_GUID
                                          ON MIString_GUID.MovementItemId = MI_PromoCode.Id
                                         AND MIString_GUID.DescId = zc_MIString_GUID()
*/
             LEFT JOIN ObjectString AS ObjectString_Address
                                    ON ObjectString_Address.ObjectId = Movement_Check.MemberSPId
                                   AND ObjectString_Address.DescId = zc_ObjectString_MemberSP_Address()
             LEFT JOIN ObjectString AS ObjectString_INN
                                    ON ObjectString_INN.ObjectId = Movement_Check.MemberSPId
                                   AND ObjectString_INN.DescId = zc_ObjectString_MemberSP_INN()
             LEFT JOIN ObjectString AS ObjectString_Passport
                                    ON ObjectString_Passport.ObjectId = Movement_Check.MemberSPId
                                   AND ObjectString_Passport.DescId = zc_ObjectString_MemberSP_Passport()

             LEFT JOIN MovementBoolean AS MovementBoolean_Site
                                       ON MovementBoolean_Site.MovementId = Movement_Check.Id
                                      AND MovementBoolean_Site.DescId = zc_MovementBoolean_Site()

             LEFT JOIN ObjectLink AS ObjectLink_MemberSP_GroupMemberSP
                                  ON ObjectLink_MemberSP_GroupMemberSP.ObjectId = Movement_Check.MemberSPId
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

             LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_PartionDateKind
                                             ON MovementLinkObject_PartionDateKind.MovementId = Movement_Check.Id
                                            AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
             LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MovementLinkObject_PartionDateKind.ObjectId

             LEFT JOIN MovementBoolean AS MovementBoolean_Delay
                                       ON MovementBoolean_Delay.MovementId = Movement_Check.Id
                                      AND MovementBoolean_Delay.DescId = zc_MovementBoolean_Delay()

             LEFT JOIN MovementBoolean AS MovementBoolean_CorrectMarketing
                                       ON MovementBoolean_CorrectMarketing.MovementId = Movement_Check.Id
                                      AND MovementBoolean_CorrectMarketing.DescId = zc_MovementBoolean_CorrectMarketing()

             LEFT JOIN MovementBoolean AS MovementBoolean_CorrectIlliquidMarketing
                                       ON MovementBoolean_CorrectIlliquidMarketing.MovementId = Movement_Check.Id
                                      AND MovementBoolean_CorrectIlliquidMarketing.DescId = zc_MovementBoolean_CorrectIlliquidMarketing()

             LEFT JOIN MovementBoolean AS MovementBoolean_Doctors
                                       ON MovementBoolean_Doctors.MovementId = Movement_Check.Id
                                      AND MovementBoolean_Doctors.DescId = zc_MovementBoolean_Doctors()

             -- Программа лояльности накопительная
             LEFT JOIN tmpLoyaltySM ON 1 = 1

       WHERE Movement_Check.Id = inMovementId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Check (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 02.10.19                                                                      * Оптимизация
 20.04.19         * PartionDateKind
 01.04.19                                                                      * add Delay
 25.02.19                                                                      * add JackdawsChecks
 16.02.19                                                                      * add BankPOSTerminal
 28.01.19         * add isSite
 11.01.19         * add MemberSP
 02.10.18                                                                      * add TotalSummPayAdd
 29.06.18                                                                      * add ManualDiscount
 14.12.17         * add PromoCode
 26.04.17         * add PartnerMedicalId
 07.04.17         *
 21.07.16         *
 23.05.15                         *                 
*/

-- тест
-- 
select * from gpGet_Movement_Check(inMovementId := 23093853  ,  inSession := '3');