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
           , MovementFloat_TotalSummChangePercent.ValueData  AS TotalSummChangePercent
           , MovementLinkObject_Unit.ObjectId           AS UnitId
           , Object_Unit.ValueData                      AS UnitName
           , MovementLinkObject_PaidKind.ObjectId       AS PaidKindId  
           , Object_PaidKind.ValueData                  AS PaidKindName 
           , MovementLinkObject_CashRegister.ObjectId   AS CashRegisterId
           , Object_CashRegister.ValueData              AS CashRegisterName
           , COALESCE(MovementBoolean_Deferred.ValueData,False) AS IsDeferred
           , MovementLinkObject_CheckMember.ObjectId    AS CashMemberId
		   , Object_CashMember.ValueData                AS CashMember
		   , MovementString_Bayer.ValueData             AS Bayer
		   , MovementLinkObject_PaidType.ObjectId       AS PaidTypeId  
           , Object_PaidType.ValueData                  AS PaidTypeName 
           , MovementString_FiscalCheckNumber.ValueData  AS FiscalCheckNumber
           , COALESCE(MovementBoolean_NotMCS.ValueData,FALSE) AS NotMCS

           , Object_DiscountCard.Id                     AS DiscountCardId 
           , Object_DiscountCard.ValueData              AS DiscountCardName
           
           , MovementString_BayerPhone.ValueData             AS BayerPhone
           , MovementString_InvNumberOrder.ValueData         AS InvNumberOrder
           , MovementLinkObject_ConfirmedKind.ObjectId       AS ConfirmedKindId
           , Object_ConfirmedKind.ValueData                  AS ConfirmedKindName
           , MovementLinkObject_ConfirmedKindClient.ObjectId AS ConfirmedKindId_Client
           , Object_ConfirmedKindClient.ValueData            AS ConfirmedKindClientName
       FROM Movement 
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
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

        WHERE Movement.DescId = zc_Movement_Check();

ALTER TABLE Movement_Check_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.05.15                        * 
*/

-- ����
-- SELECT * FROM Movement_Check_View where id = 805
