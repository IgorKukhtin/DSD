-- View: Object_Unit_View

DROP VIEW IF EXISTS Movement_ReturnOut_View;

CREATE OR REPLACE VIEW Movement_ReturnOut_View AS 
SELECT       Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber
           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
           , Movement.OperDate                          AS OperDate
           , MovementDate_OperDatePartner.ValueData     AS OperDatePartner
           , Movement.StatusId                          AS StatusId
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName
           , MovementFloat_TotalCount.ValueData         AS TotalCount
           , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
           , MovementFloat_TotalSumm.ValueData          AS TotalSumm
           , MovementBoolean_PriceWithVAT.ValueData     AS PriceWithVAT
           , MovementLinkObject_From.ObjectId           AS FromId
           , Object_From.Name                           AS FromName
           , MovementLinkObject_To.ObjectId             AS ToId
           , Object_To.ValueData                        AS ToName
           , MovementLinkObject_NDSKind.ObjectId        AS NDSKindId
           , Object_NDSKind.ValueData                   AS NDSKindName
           , ObjectFloat_NDSKind_NDS.ValueData          AS NDS
           , Movement.ParentId                          AS MovementIncomeId
           , MovementIncome.OperDate                    AS IncomeOperDate
           , MovementIncome.InvNumber                   AS IncomeInvNumber
           , MovementLinkObject_ReturnType.ObjectId     AS ReturnTypeId
           , Object_ReturnType.ValueData                AS ReturnTypeName
           , MovementIncome.JuridicalId                 AS JuridicalId
           , MovementIncome.JuridicalName               AS JuridicalName
           , MovementLinkObject_LegalAddress.ObjectId   AS LegalAddressId
           , Object_AddressLegal.ValueData              AS LegalAddressName
           , MovementLinkObject_ActualAddress.ObjectId  AS ActualAddressId
           , Object_AddressActual.ValueData             AS ActualAddressName
       FROM Movement 
            LEFT JOIN Movement_Income_View AS MovementIncome ON MovementIncome.Id = Movement.ParentId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

            LEFT JOIN Object_Unit_View AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                         ON MovementLinkObject_NDSKind.MovementId = Movement.Id
                                        AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()

            LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = MovementLinkObject_NDSKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReturnType
                                         ON MovementLinkObject_ReturnType.MovementId = Movement.Id
                                        AND MovementLinkObject_ReturnType.DescId = zc_MovementLinkObject_ReturnType()

            LEFT JOIN Object AS Object_ReturnType ON Object_ReturnType.Id = MovementLinkObject_ReturnType.ObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                  ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                 AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()   


            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementDate    AS MovementDate_OperDatePartner
                                      ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementString  AS MovementString_InvNumberPartner
                                      ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                     AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_LegalAddress
                                         ON MovementLinkObject_LegalAddress.MovementId = Movement.Id
                                        AND MovementLinkObject_LegalAddress.DescId = zc_MovementLinkObject_LegalAddress()

            LEFT JOIN Object AS Object_LegalAddress ON Object_LegalAddress.Id = MovementLinkObject_LegalAddress.ObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_JuridicalLegalAddress_ActualAddress
                                 ON ObjectLink_JuridicalLegalAddress_ActualAddress.ObjectId = Object_LegalAddress.Id 
                                AND ObjectLink_JuridicalLegalAddress_ActualAddress.DescId = zc_ObjectLink_JuridicalLegalAddress_Address()
            LEFT JOIN Object AS Object_AddressLegal ON Object_AddressLegal.Id = ObjectLink_JuridicalLegalAddress_ActualAddress.ChildObjectId                     
            

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ActualAddress
                                         ON MovementLinkObject_ActualAddress.MovementId = Movement.Id
                                        AND MovementLinkObject_ActualAddress.DescId = zc_MovementLinkObject_ActualAddress()

            LEFT JOIN Object AS Object_ActualAddress ON Object_ActualAddress.Id = MovementLinkObject_ActualAddress.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_JuridicalActualAddress_ActualAddress
                                 ON ObjectLink_JuridicalActualAddress_ActualAddress.ObjectId = Object_ActualAddress.Id 
                                AND ObjectLink_JuridicalActualAddress_ActualAddress.DescId = zc_ObjectLink_JuridicalActualAddress_Address()
            LEFT JOIN Object AS Object_AddressActual ON Object_AddressActual.Id = ObjectLink_JuridicalActualAddress_ActualAddress.ChildObjectId                     

           WHERE Movement.DescId = zc_Movement_ReturnOut();

ALTER TABLE Movement_ReturnOut_View
  OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».   ÿ‡·ÎËÈ Œ.¬.
 28.05.18                                                       * 
 06.02.15                        * 
*/

-- ÚÂÒÚ
-- SELECT * FROM Movement_ReturnOut_View where id = 7753659
