-- Function: gpSelect_Movement_Check_DiscountExternal()

DROP FUNCTION IF EXISTS gpSelect_Movement_Check_DiscountExternal (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Check_DiscountExternal(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inUnitId           Integer,    -- Подразделение
    IN inDiscountExternal Integer,    -- Подразделение
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer
             , TotalCount TFloat, TotalSumm TFloat, TotalSummPayAdd TFloat, TotalSummChangePercent TFloat
             , UnitName TVarChar, CashRegisterName TVarChar, PaidTypeName TVarChar
             , CashMember TVarChar, Bayer TVarChar, FiscalCheckNumber TVarChar, NotMCS Boolean, IsDeferred Boolean
             , DiscountCardName TVarChar, DiscountExternalName TVarChar
             , BayerPhone TVarChar
             , InvNumberOrder TVarChar
             , ConfirmedKindName TVarChar
             , ConfirmedKindClientName TVarChar
             , CommentError TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , OperDateSP TDateTime
             , PartnerMedicalName TVarChar
             , InvNumberSP TVarChar
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

     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     -- определяем Торговую сеть входящего подразделения
     vbRetailId:= CASE WHEN vbUserId IN (3, 183242, 375661) -- Админ + Люба + Юра
                          OR vbUserId IN (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId IN (393039)) -- Старший менеджер
                       THEN vbObjectId
                  ELSE
                  (SELECT ObjectLink_Juridical_Retail.ChildObjectId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                      INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                            ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                           AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE (ObjectLink_Unit_Juridical.ObjectId = inUnitId or COALESCE(inUnitId, 0) = 0)
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                   )
                   END;

     -- Результат
     RETURN QUERY
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
           , Object_DiscountCard.ValueData                      AS DiscountCardName
           , Object_DiscountExternal.ValueData                  AS DiscountExternalName
           , COALESCE (ObjectString_BuyerForSite_Phone.ValueData, 
                       MovementString_BayerPhone.ValueData)     AS BayerPhone
           , COALESCE(MovementString_InvNumberOrder.ValueData,
             CASE WHEN COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) = zc_Enum_CheckSourceKind_Tabletki() THEN MovementString_OrderId.ValueData
                  WHEN COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) <> 0 THEN Movement_Check.Id::TVarChar END)::TVarChar   AS InvNumberOrder
           , Object_ConfirmedKind.ValueData                     AS ConfirmedKindName
           , Object_ConfirmedKindClient.ValueData               AS ConfirmedKindClientName

           , Movement_Check.CommentError                        AS CommentError
           , Object_Insert.ValueData                            AS InsertName
           , MovementDate_Insert.ValueData                      AS InsertDate

           , MovementDate_OperDateSP.ValueData                  AS OperDateSP
           , Object_PartnerMedical.ValueData                    AS PartnerMedicalName
           , Movement_Check.InvNumberSP                         AS InvNumberSP
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

        FROM (SELECT Movement.*
                   , MovementLinkObject_Unit.ObjectId                    AS UnitId
                   , MovementString_CommentError.ValueData               AS CommentError
                   , MovementString_InvNumberSP.ValueData                AS InvNumberSP
                   , MovementLinkObject_CheckMember.ObjectId             AS MemberId
                   , COALESCE(MovementBoolean_Deferred.ValueData, False) AS IsDeferred
              FROM Movement


                   INNER JOIN MovementLinkObject AS MovementLinkObject_DiscountCard
                                                 ON MovementLinkObject_DiscountCard.MovementId = Movement.ID
                                                AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()

                   INNER JOIN ObjectLink AS ObjectLink_DiscountExternal
                                         ON ObjectLink_DiscountExternal.ObjectId = MovementLinkObject_DiscountCard.ObjectId
                                        AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountCard_Object()

                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                ON MovementLinkObject_Unit.MovementId = Movement.Id
                                               AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                   LEFT JOIN MovementString AS MovementString_CommentError
                                            ON MovementString_CommentError.MovementId = Movement.Id
                                           AND MovementString_CommentError.DescId = zc_MovementString_CommentError()
                   LEFT JOIN MovementString AS MovementString_InvNumberSP
                                            ON MovementString_InvNumberSP.MovementId = Movement.Id
                                           AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()

                   LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckMember
                                                ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                               AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
                   LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                             ON MovementBoolean_Deferred.MovementId = Movement.Id
                                            AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

              WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                AND Movement.DescId = zc_Movement_Check()
                AND (ObjectLink_DiscountExternal.ChildObjectId = inDiscountExternal 
                 OR COALESCE (ObjectLink_DiscountExternal.ChildObjectId, 0) <> 0 AND COALESCE (inDiscountExternal, 0) = 0)
                AND (MovementLinkObject_Unit.ObjectId = inUnitId OR COALESCE (inUnitId, 0) = 0)
                AND  Movement.StatusId = zc_Enum_Status_Complete()
--                AND vbRetailId = vbObjectId
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
             LEFT JOIN MovementFloat AS MovementFloat_TotalSummPayAdd
                                     ON MovementFloat_TotalSummPayAdd.MovementId =  Movement_Check.Id
                                    AND MovementFloat_TotalSummPayAdd.DescId = zc_MovementFloat_TotalSummPayAdd()
             LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                     ON MovementFloat_TotalSummChangePercent.MovementId =  Movement_Check.Id
                                    AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                         ON MovementLinkObject_CheckSourceKind.MovementId =  Movement_Check.Id
                                        AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()
            LEFT JOIN Object AS Object_CheckSourceKind ON Object_CheckSourceKind.Id = MovementLinkObject_CheckSourceKind.ObjectId

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
            LEFT JOIN Object AS Object_GroupMemberSP ON Object_GroupMemberSP.Id = ObjectLink_MemberSP_GroupMemberSP.ChildObjectId;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 21.04.21                                                                                    * add BuyerForSite
 25.01.19                                                                                    *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Check_DiscountExternal (inStartDate := ('01.01.2021')::TDateTime , inEndDate := ('25.01.2021')::TDateTime, inUnitId:= 0 , inDiscountExternal := 2807930, inSession:= '3')
