-- Function: gpSelect_Movement_Check()

DROP FUNCTION IF EXISTS gpSelect_Movement_Check (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Check (TDateTime, TDateTime, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Check (TDateTime, TDateTime, Boolean, Boolean, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Check(IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inIsSP          Boolean ,   -- �������� ������ ������
    IN inIsVip         Boolean ,   -- �������� ������ �������
    IN inUnitId        Integer,    -- �������������
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer
             , TotalCount TFloat, TotalSumm TFloat, TotalSummPayAdd TFloat, TotalSummChangePercent TFloat
             , UnitName TVarChar, CashRegisterName TVarChar, PaidTypeName TVarChar
             , CashMember TVarChar, Bayer TVarChar, ZReport Integer, FiscalCheckNumber TVarChar
             , NotMCS Boolean, IsDeferred Boolean
             , isSite Boolean
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
             , ConfirmationCodeSP TVarChar
             , MedicSPName TVarChar
             , Ambulance TVarChar
             , SPKindName TVarChar
             , MedicalProgramSPName TVarChar
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
             , PartionDateKindName TVarChar
             , Delay Boolean, DateDelay TDateTime
             , CheckSourceKindName TVarChar
             , MedicForSaleName TVarChar
             , BuyerForSaleName TVarChar
             , isCorrectMarketing Boolean
             , isCorrectIlliquidMarketing Boolean
             , isDeliverySite Boolean
             , SummaDelivery TFloat
             , isDoctors Boolean
             , isDiscountCommit Boolean
             , CommentCustomer TVarChar
             , isManual Boolean
             , isOffsetVIP Boolean
             , isErrorRRO Boolean
             , isAutoVIPforSales Boolean
             , isPaperRecipeSP Boolean 
             , isMobileApplication Boolean, isConfirmByPhone Boolean, DateComing TDateTime 
             , MobileDiscount TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbRetailId Integer;   
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������� ������������� �������������
     inUnitId := gpGet_CheckingUser_Unit(inUnitId, inSession);

     -- ������������ <�������� ����>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     -- ���������� �������� ���� ��������� �������������
     vbRetailId:= CASE WHEN vbUserId IN (3, 183242, 375661) -- ����� + ���� + ���
                          OR vbUserId IN (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId IN (393039)) -- ������� ��������
                       THEN vbObjectId
                  ELSE
                  (SELECT ObjectLink_Juridical_Retail.ChildObjectId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                      INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                            ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                           AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = inUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                   )
                   END;

     -- ���������
     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
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
           , MovementFloat_ZReport.ValueData::Integer           AS ZReport
           , MovementString_FiscalCheckNumber.ValueData         AS FiscalCheckNumber
           , COALESCE(MovementBoolean_NotMCS.ValueData,FALSE)   AS NotMCS
           , Movement_Check.IsDeferred                          AS IsDeferred
           , COALESCE(MovementBoolean_Site.ValueData,FALSE) :: Boolean AS isSite
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
           , Movement_Check.ConfirmationCodeSP
           , COALESCE(Object_MedicKashtan.ValueData, MovementString_MedicSP.ValueData):: TVarChar AS MedicSPName
           , MovementString_Ambulance.ValueData                 AS Ambulance
           , Object_SPKind.ValueData                            AS SPKindName
           , Object_MedicalProgramSP.ValueData                  AS MedicalProgramSPName
           , ('� ' || Movement_Invoice.InvNumber || ' �� ' || Movement_Invoice.OperDate  :: Date :: TVarChar )     :: TVarChar  AS InvNumber_Invoice_Full 
           
           , Object_Status_PromoCode.ObjectCode                 AS StatusCode_PromoCode
           , ('� ' || Movement_PromoCode.InvNumber || ' �� ' || Movement_PromoCode.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_PromoCode_Full
           , MIString_GUID.ValueData                 ::TVarChar AS GUID_PromoCode

           , Object_MemberSP.Id                                           AS MemberSPId
           , COALESCE(Object_MemberSP.ValueData, Object_MemberKashtan.ValueData):: TVarChar AS MemberSPName

           
           , Object_GroupMemberSP.Id                                      AS GroupMemberSPId
           , COALESCE (Object_GroupMemberSP.ValueData, Object_Category1303.ValueData) :: TVarChar  AS GroupMemberSPName
           , COALESCE (ObjectString_Address.ValueData, '')   :: TVarChar  AS Address_MemberSP
           , COALESCE (ObjectString_INN.ValueData, '')       :: TVarChar  AS INN_MemberSP
           , COALESCE (ObjectString_Passport.ValueData, '')  :: TVarChar  AS Passport_MemberSP
           , Object_BankPOSTerminal.ValueData                             AS BankPOSTerminalName
           , Object_JackdawsChecks.ValueData                              AS JackdawsChecksName
           , Object_PartionDateKind.ValueData                :: TVarChar  AS PartionDateKindName
           , COALESCE (MovementBoolean_Delay.ValueData, False)::Boolean   AS Delay
           , MovementDate_Delay.ValueData                                 AS DateDelay
           , Object_CheckSourceKind.ValueData                             AS CheckSourceKindName
           
           , Object_MedicForSale.ValueData                                AS MedicForSaleName
           , Object_BuyerForSale.ValueData                                AS BuyerForSaleName
           , COALESCE(MovementBoolean_CorrectMarketing.ValueData, False)  AS isCorrectMarketing
           , COALESCE(MovementBoolean_CorrectIlliquidMarketing.ValueData, False)  AS isCorrectIlliquidMarketing
           
           , COALESCE(MovementBoolean_DeliverySite.ValueData, False)      AS isDeliverySite
           , MovementFloat_SummaDelivery.ValueData                        AS SummaDelivery
           , COALESCE(MovementBoolean_Doctors.ValueData, False)           AS isDoctors
           , COALESCE(MovementBoolean_DiscountCommit.ValueData, False)    AS isDiscountCommit

           , MovementString_CommentCustomer.ValueData                     AS CommentCustomer
           , COALESCE(MovementBoolean_Manual.ValueData, False)            AS isManual
           
           , COALESCE(MovementBoolean_OffsetVIP.ValueData, False)         AS isOffsetVIP
           , COALESCE(MovementBoolean_ErrorRRO.ValueData, False)          AS isErrorRRO
           , COALESCE(MovementBoolean_AutoVIPforSales.ValueData, False)   AS isAutoVIPforSales
           , COALESCE(MovementBoolean_PaperRecipeSP.ValueData, False)     AS isPaperRecipeSP
           , COALESCE(MovementBoolean_MobileApplication.ValueData, False)::Boolean   AS isMobileApplication
           , COALESCE(MovementBoolean_ConfirmByPhone.ValueData, False)::Boolean      AS isConfirmByPhone
           , MovementDate_Coming.ValueData                                AS DateComing
           , MovementFloat_MobileDiscount.ValueData                       AS MobileDiscount
           
        FROM (SELECT Movement.*
                   , MovementLinkObject_Unit.ObjectId                    AS UnitId
                   , MovementString_CommentError.ValueData               AS CommentError
                   , MovementString_InvNumberSP.ValueData                AS InvNumberSP
                   , MovementString_ConfirmationCodeSP.ValueData         AS ConfirmationCodeSP
                   , MovementLinkObject_CheckMember.ObjectId             AS MemberId
                   , MovementLinkObject_PartionDateKind.ObjectId         AS PartionDateKindId
                   , COALESCE(MovementBoolean_Deferred.ValueData, False) AS IsDeferred
              FROM Movement
                   INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId

                   LEFT JOIN MovementString AS MovementString_CommentError
                                            ON MovementString_CommentError.MovementId = Movement.Id
                                           AND MovementString_CommentError.DescId = zc_MovementString_CommentError()
                   LEFT JOIN MovementString AS MovementString_InvNumberSP
                                            ON MovementString_InvNumberSP.MovementId = Movement.Id
                                           AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP() 
                   LEFT JOIN MovementString AS MovementString_ConfirmationCodeSP
                                            ON MovementString_ConfirmationCodeSP.MovementId = Movement.Id
                                           AND MovementString_ConfirmationCodeSP.DescId = zc_MovementString_ConfirmationCodeSP() 
                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                ON MovementLinkObject_Unit.MovementId = Movement.Id
                                               AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    
                                                                         
                   LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckMember
                                                ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                               AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()

                   LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                                ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                               AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()

                   LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                             ON MovementBoolean_Deferred.MovementId = Movement.Id
                                            AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
   		                      
              WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate) 
                AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                AND Movement.DescId = zc_Movement_Check()
                AND (MovementLinkObject_Unit.ObjectId = inUnitId 
                     OR (inUnitId = 0 AND inIsSP = FALSE AND inIsVip = FALSE AND (MovementString_CommentError.ValueData <> '' 
                                                                               OR MovementString_InvNumberSP.ValueData <> '' 
                                                                               OR MovementLinkObject_CheckMember.ObjectId > 0
                                                                                  )
                         )
                     OR (inUnitId = 0 AND inIsSP = TRUE  AND MovementString_InvNumberSP.ValueData <> '')
                     OR (inUnitId = 0 AND inIsVip = TRUE AND (MovementLinkObject_CheckMember.ObjectId > 0 OR COALESCE(MovementBoolean_Deferred.ValueData, False) = TRUE))
                     )
                AND vbRetailId = vbObjectId
           ) AS Movement_Check 
             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Check.StatusId
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement_Check.UnitId

             LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = Movement_Check.PartionDateKindId

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
             LEFT JOIN MovementFloat AS MovementFloat_ZReport
                                     ON MovementFloat_ZReport.MovementId =  Movement_Check.Id
                                    AND MovementFloat_ZReport.DescId = zc_MovementFloat_ZReport()
 
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

             LEFT JOIN MovementLinkObject AS MovementLinkObject_MedicalProgramSP
                                          ON MovementLinkObject_MedicalProgramSP.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
             LEFT JOIN Object AS Object_MedicalProgramSP ON Object_MedicalProgramSP.Id = MovementLinkObject_MedicalProgramSP.ObjectId

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

            -- ���� �� ��������� ����� ���
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
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberKashtan
                                         ON MovementLinkObject_MemberKashtan.MovementId =  Movement_Check.Id
                                        AND MovementLinkObject_MemberKashtan.DescId = zc_MovementLinkObject_MemberKashtan()
            LEFT JOIN Object AS Object_MemberKashtan ON Object_MemberKashtan.Id = MovementLinkObject_MemberKashtan.ObjectId
            

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                         ON MovementLinkObject_CheckSourceKind.MovementId =  Movement_Check.Id
                                        AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()
            LEFT JOIN Object AS Object_CheckSourceKind ON Object_CheckSourceKind.Id = MovementLinkObject_CheckSourceKind.ObjectId

            LEFT JOIN MovementString AS MovementString_BookingId
                                     ON MovementString_BookingId.MovementId = Movement_Check.Id
                                    AND MovementString_BookingId.DescId = zc_MovementString_BookingId()

            LEFT JOIN MovementString AS MovementString_CommentCustomer
                                     ON MovementString_CommentCustomer.MovementId = Movement_Check.Id
                                    AND MovementString_CommentCustomer.DescId = zc_MovementString_CommentCustomer()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_MedicForSale
                                         ON MovementLinkObject_MedicForSale.MovementId =  Movement_Check.Id
                                        AND MovementLinkObject_MedicForSale.DescId = zc_MovementLinkObject_MedicForSale()
            LEFT JOIN Object AS Object_MedicForSale ON Object_MedicForSale.Id = MovementLinkObject_MedicForSale.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_MedicKashtan
                                         ON MovementLinkObject_MedicKashtan.MovementId =  Movement_Check.Id
                                        AND MovementLinkObject_MedicKashtan.DescId = zc_MovementLinkObject_MedicKashtan()
            LEFT JOIN Object AS Object_MedicKashtan ON Object_MedicKashtan.Id = MovementLinkObject_MedicKashtan.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_BuyerForSale
                                         ON MovementLinkObject_BuyerForSale.MovementId =  Movement_Check.Id
                                        AND MovementLinkObject_BuyerForSale.DescId = zc_MovementLinkObject_BuyerForSale()
            LEFT JOIN Object AS Object_BuyerForSale ON Object_BuyerForSale.Id = MovementLinkObject_BuyerForSale.ObjectId

            LEFT JOIN MovementBoolean AS MovementBoolean_CorrectMarketing
                                      ON MovementBoolean_CorrectMarketing.MovementId = Movement_Check.Id
                                     AND MovementBoolean_CorrectMarketing.DescId = zc_MovementBoolean_CorrectMarketing()
                                     
            LEFT JOIN MovementBoolean AS MovementBoolean_CorrectIlliquidMarketing
                                      ON MovementBoolean_CorrectIlliquidMarketing.MovementId = Movement_Check.Id
                                     AND MovementBoolean_CorrectIlliquidMarketing.DescId = zc_MovementBoolean_CorrectIlliquidMarketing()

            LEFT JOIN MovementBoolean AS MovementBoolean_Doctors
                                      ON MovementBoolean_Doctors.MovementId = Movement_Check.Id
                                     AND MovementBoolean_Doctors.DescId = zc_MovementBoolean_Doctors()

            LEFT JOIN MovementBoolean AS MovementBoolean_DiscountCommit
                                      ON MovementBoolean_DiscountCommit.MovementId = Movement_Check.Id
                                     AND MovementBoolean_DiscountCommit.DescId = zc_MovementBoolean_DiscountCommit()

            LEFT JOIN MovementBoolean AS MovementBoolean_Manual
                                      ON MovementBoolean_Manual.MovementId = Movement_Check.Id
                                     AND MovementBoolean_Manual.DescId = zc_MovementBoolean_Manual()

            LEFT JOIN MovementBoolean AS MovementBoolean_MobileApplication
                                      ON MovementBoolean_MobileApplication.MovementId = Movement_Check.Id
                                     AND MovementBoolean_MobileApplication.DescId = zc_MovementBoolean_MobileApplication()
            LEFT JOIN MovementBoolean AS MovementBoolean_ConfirmByPhone
                                      ON MovementBoolean_ConfirmByPhone.MovementId = Movement_Check.Id
                                     AND MovementBoolean_ConfirmByPhone.DescId = zc_MovementBoolean_ConfirmByPhone()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Category1303
                                         ON MovementLinkObject_Category1303.MovementId =  Movement_Check.Id
                                        AND MovementLinkObject_Category1303.DescId = zc_MovementLinkObject_Category1303()
            LEFT JOIN Object AS Object_Category1303 ON Object_Category1303.Id = MovementLinkObject_Category1303.ObjectId

            LEFT JOIN MovementBoolean AS MovementBoolean_OffsetVIP
                                      ON MovementBoolean_OffsetVIP.MovementId = Movement_Check.Id
                                     AND MovementBoolean_OffsetVIP.DescId = zc_MovementBoolean_OffsetVIP()

            LEFT JOIN MovementBoolean AS MovementBoolean_ErrorRRO
                                      ON MovementBoolean_ErrorRRO.MovementId = Movement_Check.Id
                                     AND MovementBoolean_ErrorRRO.DescId = zc_MovementBoolean_ErrorRRO()

            LEFT JOIN MovementBoolean AS MovementBoolean_AutoVIPforSales
                                      ON MovementBoolean_AutoVIPforSales.MovementId = Movement_Check.Id
                                     AND MovementBoolean_AutoVIPforSales.DescId = zc_MovementBoolean_AutoVIPforSales()

            LEFT JOIN MovementBoolean AS MovementBoolean_PaperRecipeSP
                                      ON MovementBoolean_PaperRecipeSP.MovementId = Movement_Check.Id
                                     AND MovementBoolean_PaperRecipeSP.DescId = zc_MovementBoolean_PaperRecipeSP()
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_Check (TDateTime, TDateTime, Boolean, Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������ �.�. +
 23.05.19                                                                                    *
 01.04.19                                                                                    * add Delay
 25.02.19                                                                                    * add JackdawsChecks
 16.02.19                                                                                    * add BankPOSTerminal
 28.01.19         * add isSite
 02.10.18                                                                                    * add TotalSummPayAdd
 14.12.17         * add PromoCode
 11.09.17         *
 04.08.17         * ��� �����
 18.04.17         * add Movement_Invoice
 06.10.16         * add InsertName, InsertDate
 25.08.16         *
 21.07.16         *
 05.05.16         *
 07.08.15                                                                        *
 08.05.15                         * 
*/

-- ����
-- select * from gpSelect_Movement_Check(inStartDate := ('20.04.2021')::TDateTime , inEndDate := ('20.04.2021')::TDateTime , inIsErased := 'False' , inIsSP := 'False' , inIsVip := 'False' , inUnitId := 377605 ,  inSession := '3');

select * from gpSelect_Movement_Check(inStartDate := ('22.10.2021')::TDateTime , inEndDate := ('22.10.2021')::TDateTime , inIsErased := 'False' , inIsSP := 'False' , inIsVip := 'False' , inUnitId := 377605 ,  inSession := '3')
where spkindname = '������������� 1303';