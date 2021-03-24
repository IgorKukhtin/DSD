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
             , isCorrectMarketing Boolean
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

        FROM Movement_Check_View AS Movement_Check
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

             LEFT JOIN MovementLinkObject AS MovementLinkObject_BankPOSTerminal
                                          ON MovementLinkObject_BankPOSTerminal.MovementId =  Movement_Check.Id
                                         AND MovementLinkObject_BankPOSTerminal.DescId = zc_MovementLinkObject_BankPOSTerminal()
             LEFT JOIN Object AS Object_BankPOSTerminal ON Object_BankPOSTerminal.Id = MovementLinkObject_BankPOSTerminal.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_JackdawsChecks
                                          ON MovementLinkObject_JackdawsChecks.MovementId =  Movement_Check.Id
                                         AND MovementLinkObject_JackdawsChecks.DescId = zc_MovementLinkObject_JackdawsChecks()
             LEFT JOIN Object AS Object_JackdawsChecks ON Object_JackdawsChecks.Id = MovementLinkObject_JackdawsChecks.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                          ON MovementLinkObject_PartionDateKind.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
             LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MovementLinkObject_PartionDateKind.ObjectId

             LEFT JOIN MovementBoolean AS MovementBoolean_Delay
                                       ON MovementBoolean_Delay.MovementId = Movement_Check.Id
                                      AND MovementBoolean_Delay.DescId = zc_MovementBoolean_Delay()

             LEFT JOIN MovementBoolean AS MovementBoolean_CorrectMarketing
                                       ON MovementBoolean_CorrectMarketing.MovementId = Movement_Check.Id
                                      AND MovementBoolean_CorrectMarketing.DescId = zc_MovementBoolean_CorrectMarketing()

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
-- select * from gpGet_Movement_Check(inMovementId := 15241125 ,  inSession := '3');