-- Function: gpSelect_Movement_CheckLoadCashId()

DROP FUNCTION IF EXISTS gpSelect_Movement_CheckLoadCashId (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_CheckLoadCashId(
    IN inMovementId    Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  Id Integer,
  InvNumber TVarChar,
  OperDate TDateTime,
  StatusId Integer,
  StatusCode Integer,
  TotalCount TFloat,
  TotalSumm TFloat,
  UnitName TVarChar,
  CashRegisterName TVarChar,
  CashMemberId Integer,
  CashMember TVarCHar,
  Bayer TVarChar,
  BayerPhone TVarChar,
  InvNumberOrder TVarChar,
  ConfirmedKindName TVarChar,
  ConfirmedKindClientName TVarChar,
  DiscountExternalId Integer,
  DiscountExternalName TVarChar,
  DiscountCardNumber TVarChar,
  PartnerMedicalId Integer,
  PartnerMedicalName TVarChar,
  Ambulance TVarChar,
  MedicSP TVarChar,
  InvNumberSP TVarChar,
  OperDateSP TDateTime,
  SPKindId Integer,
  SPKindName TVarChar,
  SPTax TFloat,
  Color_CalcDoc Integer,
  ManualDiscount Integer,
  PromoCodeID Integer,
  PromoName TVarChar,
  PromoCodeGUID TVarChar,
  PromoCodeChangePercent TFloat,
  MemberSPId Integer,
  SiteDiscount TFloat,
  PartionDateKindId Integer,
  PartionDateKindName TVarChar, 
  AmountMonth TFloat,
  DateDelay TDateTime,
  LoyaltyChangeSumma TFloat,
  SummCard TFloat,
  isBanAdd boolean, 
  isDiscountCommit Boolean, 
  isAutoVIPforSales Boolean,
  MobileDiscount TFloat
 )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbSiteDiscount TFloat;
   DECLARE vbConfirmedKindId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH
        tmpMovementFloat AS (SELECT *
                             FROM MovementFloat
                             WHERE MovementFloat.MovementId = inMovementId
                             )
                      
       SELECT Movement.Id
            , Movement.InvNumber
            , Movement.OperDate
            , Movement.StatusId
            , Object_Status.ObjectCode                   AS StatusCode
            , MovementFloat_TotalCount.ValueData         AS TotalCount
            , MovementFloat_TotalSumm.ValueData          AS TotalSumm
            , Object_Unit.ValueData                      AS UnitName
            , Object_CashRegister.ValueData              AS CashRegisterName
            , COALESCE(MovementLinkObject_CheckMember.ObjectId, 0)    AS CashMemberId
            , CASE WHEN MovementString_InvNumberOrder.ValueData <> '' AND COALESCE (Object_CashMember.ValueData, '') = '' THEN zc_Member_Site() ELSE Object_CashMember.ValueData END :: TVarChar AS CashMember
	        , COALESCE(Object_BuyerForSite.ValueData,
                       MovementString_Bayer.ValueData)              AS Bayer

            , COALESCE (ObjectString_BuyerForSite_Phone.ValueData, 
                        MovementString_BayerPhone.ValueData)        AS BayerPhone
            , COALESCE(MovementString_InvNumberOrder.ValueData,
              CASE WHEN COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) = zc_Enum_CheckSourceKind_Tabletki() THEN MovementString_OrderId.ValueData
                   WHEN COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) <> 0 THEN Movement.Id::TVarChar END)::TVarChar   AS InvNumberOrder
            , Object_ConfirmedKind.ValueData             AS ConfirmedKindName
            , Object_ConfirmedKindClient.ValueData       AS ConfirmedKindClientName

	        , COALESCE(Object_DiscountExternal.Id, 0)    AS DiscountExternalId
	        , Object_DiscountExternal.ValueData          AS DiscountExternalName
	        , Object_DiscountCard.ValueData              AS DiscountCardNumber

            , COALESCE(Object_PartnerMedical.Id, 0)      AS PartnerMedicalId
            , Object_PartnerMedical.ValueData            AS PartnerMedicalName
            , MovementString_Ambulance.ValueData         AS Ambulance
            , MovementString_MedicSP.ValueData           AS MedicSP
            , MovementString_InvNumberSP.ValueData       AS InvNumberSP
            , COALESCE (MovementDate_OperDateSP.ValueData, zc_DateStart()) :: TDateTime AS OperDateSP

            , COALESCE(Object_SPKind.Id, 0)              AS SPKindId
            , Object_SPKind.ValueData                    AS SPKindName
            , COALESCE(ObjectFloat_SPTax.ValueData, 0)::TFloat   AS SPTax

            , zc_Color_White() AS Color_CalcDoc
            , COALESCE(MovementFloat_ManualDiscount.ValueData, 0)::Integer AS ManualDiscount

            , COALESCE(MI_PromoCode.Id, 0) AS PromoCodeID
            , Object_PromoCode.ValueData AS PromoName
            , MIString_GUID.ValueData AS PromoCodeGUID
            , CASE WHEN Movement_PromoCode.DescId <> zc_Movement_Loyalty() THEN 
                   COALESCE(MovementFloat_ChangePercent.ValueData,0) END::TFloat AS PromoCodeChangePercent
            , COALESCE(Object_MemberSP.Id, 0)                                    AS MemberSPId
            , CASE WHEN COALESCE(MovementBoolean_Site.ValueData, False) = True THEN vbSiteDiscount ELSE 0 END::TFloat  AS SiteDiscount

            , COALESCE(Object_PartionDateKind.ID, 0)            AS PartionDateKindId
            , Object_PartionDateKind.ValueData                  AS PartionDateKindName
            , COALESCE(ObjectFloat_Month.ValueData, 0)::TFloat  AS AmountMonth
            , MovementDate_Delay.ValueData                      AS DateDelay
            , CASE WHEN Movement_PromoCode.DescId = zc_Movement_Loyalty() THEN 
                   CASE WHEN COALESCE(MovementFloat_TotalSummChangePercent.ValueData, 0) < MI_PromoCode.Amount THEN
                      COALESCE(MovementFloat_TotalSummChangePercent.ValueData, 0) ELSE COALESCE(MI_PromoCode.Amount, 0) END ELSE 0 END::TFloat AS LoyaltyChangeSumma
            , COALESCE(MovementFloat_TotalSummCard.ValueData, 0)::TFloat                AS SummCard
            , CASE WHEN COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) in (zc_Enum_CheckSourceKind_Tabletki(), zc_Enum_CheckSourceKind_Liki24()) THEN TRUE ELSE FALSE END AS isBanAdd
            , COALESCE(MovementBoolean_DiscountCommit.ValueData, False)                 AS isDiscountCommit
            , COALESCE(MovementBoolean_AutoVIPforSales.ValueData, False)                AS isAutoVIPforSales
            , COALESCE(MovementFloat_MobileDiscount.ValueData, 0)::TFloat               AS MobileDiscount
        FROM Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

   	        INNER JOIN MovementBoolean AS MovementBoolean_Deferred
		                               ON MovementBoolean_Deferred.MovementId = Movement.Id
		                              AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCount
                                       ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                       ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummChangePercent
                                       ON MovementFloat_TotalSummChangePercent.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                         ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                        AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
            LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckMember
                                         ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                        AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
  	        LEFT JOIN Object AS Object_CashMember ON Object_CashMember.Id = MovementLinkObject_CheckMember.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DiscountCard
                                         ON MovementLinkObject_DiscountCard.MovementId = Movement.Id
                                        AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()
            LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                 ON ObjectLink_DiscountExternal.ObjectId = MovementLinkObject_DiscountCard.ObjectId
                                AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountCard_Object()
            LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = ObjectLink_DiscountExternal.ChildObjectId
            LEFT JOIN Object AS Object_DiscountCard ON Object_DiscountCard.Id = MovementLinkObject_DiscountCard.ObjectId

	        LEFT JOIN MovementString AS MovementString_Bayer
                                     ON MovementString_Bayer.MovementId = Movement.Id
                                    AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
             LEFT JOIN MovementString AS MovementString_BayerPhone
                                      ON MovementString_BayerPhone.MovementId = Movement.Id
                                     AND MovementString_BayerPhone.DescId = zc_MovementString_BayerPhone()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_BuyerForSite
                                          ON MovementLinkObject_BuyerForSite.MovementId = Movement.Id
                                         AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
             LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId
             LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                                    ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                                   AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()

             LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                      ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                     AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                          ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                         AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
             LEFT JOIN Object AS Object_ConfirmedKind ON Object_ConfirmedKind.Id = MovementLinkObject_ConfirmedKind.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKindClient
                                          ON MovementLinkObject_ConfirmedKindClient.MovementId = Movement.Id
                                         AND MovementLinkObject_ConfirmedKindClient.DescId = zc_MovementLinkObject_ConfirmedKindClient()
             LEFT JOIN Object AS Object_ConfirmedKindClient ON Object_ConfirmedKindClient.Id = MovementLinkObject_ConfirmedKindClient.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                          ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                         AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
             LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = MovementLinkObject_PartnerMedical.ObjectId

             LEFT JOIN MovementString AS MovementString_Ambulance
                                      ON MovementString_Ambulance.MovementId = Movement.Id
                                     AND MovementString_Ambulance.DescId = zc_MovementString_Ambulance()
             LEFT JOIN MovementString AS MovementString_MedicSP
                                      ON MovementString_MedicSP.MovementId = Movement.Id
                                     AND MovementString_MedicSP.DescId = zc_MovementString_MedicSP()
             LEFT JOIN MovementString AS MovementString_InvNumberSP
                                      ON MovementString_InvNumberSP.MovementId = Movement.Id
                                     AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
             LEFT JOIN MovementDate AS MovementDate_OperDateSP
                                    ON MovementDate_OperDateSP.MovementId = Movement.Id
                                   AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                         ON MovementLinkObject_SPKind.MovementId = Movement.Id
                                        AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
            LEFT JOIN Object AS Object_SPKind ON Object_SPKind.Id = MovementLinkObject_SPKind.ObjectId
            LEFT JOIN ObjectFloat AS ObjectFloat_SPTax
                                  ON ObjectFloat_SPTax.ObjectId = Object_SPKind.Id
                                 AND ObjectFloat_SPTax.DescId   = zc_ObjectFloat_SPKind_Tax()

            -- инфа из документа промо код
            LEFT JOIN tmpMovementFloat AS MovementFloat_MovementItemId
                                      ON MovementFloat_MovementItemId.MovementId = Movement.Id
                                     AND MovementFloat_MovementItemId.DescId     = zc_MovementFloat_MovementItemId()
            LEFT JOIN MovementItem AS MI_PromoCode
                                   ON MI_PromoCode.Id       = MovementFloat_MovementItemId.ValueData :: Integer
                                  AND MI_PromoCode.isErased = FALSE
            LEFT JOIN Movement AS Movement_PromoCode ON Movement_PromoCode.Id = MI_PromoCode.MovementId
            LEFT JOIN Object AS Object_Status_PromoCode ON Object_Status_PromoCode.Id = Movement_PromoCode.StatusId

            LEFT JOIN MovementItemString AS MIString_GUID
                                         ON MIString_GUID.MovementItemId = MI_PromoCode.Id
                                        AND MIString_GUID.DescId = zc_MIString_GUID()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PromoCode
                                         ON MovementLinkObject_PromoCode.MovementId = Movement_PromoCode.Id
                                        AND MovementLinkObject_PromoCode.DescId = zc_MovementLinkObject_PromoCode()
            LEFT JOIN Object AS Object_PromoCode ON Object_PromoCode.Id = MovementLinkObject_PromoCode.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId = Movement_PromoCode.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_ManualDiscount
                                    ON MovementFloat_ManualDiscount.MovementId =  Movement.Id
                                   AND MovementFloat_ManualDiscount.DescId = zc_MovementFloat_ManualDiscount()

            LEFT JOIN MovementFloat AS MovementFloat_MobileDiscount
                                    ON MovementFloat_MobileDiscount.MovementId =  Movement.Id
                                   AND MovementFloat_MobileDiscount.DescId = zc_MovementFloat_MobileDiscount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberSP
                                         ON MovementLinkObject_MemberSP.MovementId = Movement.Id
                                        AND MovementLinkObject_MemberSP.DescId = zc_MovementLinkObject_MemberSP()
            LEFT JOIN Object AS Object_MemberSP ON Object_MemberSP.Id = MovementLinkObject_MemberSP.ObjectId

   	        LEFT JOIN MovementBoolean AS MovementBoolean_Site
		                               ON MovementBoolean_Site.MovementId = Movement.Id
		                              AND MovementBoolean_Site.DescId = zc_MovementBoolean_Site()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                         ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
            LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MovementLinkObject_PartionDateKind.ObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                  ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                 AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()

            LEFT JOIN MovementDate AS MovementDate_Delay
                                   ON MovementDate_Delay.MovementId = Movement.Id
                                  AND MovementDate_Delay.DescId = zc_MovementDate_Delay()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCard
                                    ON MovementFloat_TotalSummCard.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummCard.DescId = zc_MovementFloat_TotalSummCard()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                         ON MovementLinkObject_CheckSourceKind.MovementId =  Movement.Id
                                        AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()
            LEFT JOIN Object AS Object_CheckSourceKind ON Object_CheckSourceKind.Id = MovementLinkObject_CheckSourceKind.ObjectId

            LEFT JOIN MovementString AS MovementString_OrderId
                                     ON MovementString_OrderId.MovementId = Movement.Id
                                    AND MovementString_OrderId.DescId = zc_MovementString_OrderId()

            LEFT JOIN MovementString AS MovementString_BookingId
                                     ON MovementString_BookingId.MovementId = Movement.Id
                                    AND MovementString_BookingId.DescId = zc_MovementString_BookingId()

            LEFT JOIN MovementBoolean AS MovementBoolean_DiscountCommit
                                      ON MovementBoolean_DiscountCommit.MovementId = Movement.Id
                                     AND MovementBoolean_DiscountCommit.DescId = zc_MovementBoolean_DiscountCommit()

            LEFT JOIN MovementBoolean AS MovementBoolean_AutoVIPforSales
                                      ON MovementBoolean_AutoVIPforSales.MovementId = Movement.Id
                                     AND MovementBoolean_AutoVIPforSales.DescId = zc_MovementBoolean_AutoVIPforSales()

       WHERE Movement.Id = inMovementId
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_CheckLoadCash (TVarChar, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 21.04.21                                                                                    * add BuyerForSite
 07.12.20                                                                                    *
*/

-- тест
-- 

select * from gpSelect_Movement_CheckLoadCashId(inMovementId := 23020122,  inSession := '3');