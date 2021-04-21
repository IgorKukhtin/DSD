-- View: Object_Unit_View

DROP VIEW IF EXISTS Movement_Check_View;

CREATE OR REPLACE VIEW Movement_Check_View AS 
SELECT       
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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                         ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                        AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()

            LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

	    LEFT OUTER JOIN MovementBoolean AS MovementBoolean_Deferred
	                                    ON MovementBoolean_Deferred.MovementId = Movement.Id
                                           AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckMember
                                         ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                        AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
	    LEFT JOIN Object AS Object_CashMember ON Object_CashMember.Id = MovementLinkObject_CheckMember.ObjectId
	    LEFT JOIN MovementString AS MovementString_Bayer
                                     ON MovementString_Bayer.MovementId = Movement.Id
                                    AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
	    LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidType
                                         ON MovementLinkObject_PaidType.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()
            LEFT JOIN Object AS Object_PaidType ON Object_PaidType.Id = MovementLinkObject_PaidType.ObjectId								  
			
            LEFT OUTER JOIN MovementString AS MovementString_FiscalCheckNumber
                                           ON MovementString_FiscalCheckNumber.MovementId = Movement.ID
                                          AND MovementString_FiscalCheckNumber.DescId = zc_MovementString_FiscalCheckNumber()
                                          
            LEFT OUTER JOIN MovementBoolean AS MovementBoolean_NotMCS
                                           ON MovementBoolean_NotMCS.MovementId = Movement.ID
                                          AND MovementBoolean_NotMCS.DescId = zc_MovementBoolean_NotMCS()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DiscountCard
                                         ON MovementLinkObject_DiscountCard.MovementId = Movement.Id
                                        AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()
            LEFT JOIN Object AS Object_DiscountCard ON Object_DiscountCard.Id = MovementLinkObject_DiscountCard.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_BuyerForSite
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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                         ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                        AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
            LEFT JOIN Object AS Object_ConfirmedKind ON Object_ConfirmedKind.Id = MovementLinkObject_ConfirmedKind.ObjectId
                       
            LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKindClient
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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                         ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                        AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
            LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = MovementLinkObject_PartnerMedical.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                         ON MovementLinkObject_SPKind.MovementId = Movement.Id
                                        AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
            LEFT JOIN Object AS Object_SPKind ON Object_SPKind.Id = MovementLinkObject_SPKind.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_ManualDiscount
                                    ON MovementFloat_ManualDiscount.MovementId = Movement.Id
                                   AND MovementFloat_ManualDiscount.DescId = zc_MovementFloat_ManualDiscount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberSP
                                         ON MovementLinkObject_MemberSP.MovementId = Movement.Id
                                        AND MovementLinkObject_MemberSP.DescId = zc_MovementLinkObject_MemberSP()
            LEFT JOIN Object AS Object_MemberSP ON Object_MemberSP.Id = MovementLinkObject_MemberSP.ObjectId

        WHERE Movement.DescId = zc_Movement_Check();

ALTER TABLE Movement_Check_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------

 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».   ÿ‡·ÎËÈ Œ.¬.
 21.04.21                                                       * add BuyerForSite
 11.01.19         *
 02.10.18                                                       * add TotalSummPayAdd
 29.06.18                                                       * 
 23.05.17         *
 07.04.17         *
 07.05.15                        * 
*/

-- ÚÂÒÚ
-- SELECT * FROM Movement_Check_View where id = 23017636 