DROP VIEW IF EXISTS Movement_Sale_View;

CREATE OR REPLACE VIEW Movement_Sale_View AS 
    SELECT       
        Movement.Id
      , Movement.InvNumber
      , Movement.OperDate
      , Movement.StatusId
      , Object_Status.ObjectCode                                       AS StatusCode
      , Object_Status.ValueData                                        AS StatusName
      , COALESCE(MovementFloat_TotalCount.ValueData,0)::TFloat         AS TotalCount
      , COALESCE(MovementFloat_TotalSumm.ValueData,0)::TFloat          AS TotalSumm
      , COALESCE(MovementFloat_TotalSummSale.ValueData,0)::TFloat      AS TotalSummSale
      , COALESCE(MovementFloat_TotalSummPrimeCost.ValueData,0)::TFloat AS TotalSummPrimeCost
      , MovementLinkObject_Unit.ObjectId                               AS UnitId
      , Object_Unit.ValueData                                          AS UnitName
      , MovementLinkObject_Juridical.ObjectId                          AS JuridicalId
      , Object_Juridical.ValueData                                     AS JuridicalName
      , MovementLinkObject_PaidKind.ObjectId                           AS PaidKindId  
      , Object_PaidKind.ValueData                                      AS PaidKindName 
      , MovementString_Comment.ValueData                               AS Comment

      , MovementDate_OperDateSP.ValueData               AS OperDateSP
      , MovementString_InvNumberSP.ValueData            AS InvNumberSP

      , Object_MedicSP.Id                               AS MedicSPId
      , Object_MedicSP.ValueData                        AS MedicSPName
      , Object_MemberSP.Id                              AS MemberSPId
      , Object_MemberSP.ValueData                       AS MemberSPName

      , Object_PartnerMedical.Id                        AS PartnerMedicalId
      , Object_PartnerMedical.ValueData                 AS PartnerMedicalName

      , Object_GroupMemberSP.Id                         AS GroupMemberSPId
      , Object_GroupMemberSP.ValueData                  AS GroupMemberSPName

      , Object_SPKind.Id                                AS SPKindId
      , Object_SPKind.ValueData                         AS SPKindName

    FROM Movement 
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

        LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                ON MovementFloat_TotalCount.MovementId = Movement.Id
                               AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId = Movement.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummSale
                                ON MovementFloat_TotalSummSale.MovementId = Movement.Id
                               AND MovementFloat_TotalSummSale.DescId = zc_MovementFloat_TotalSummSale()
                                   
        LEFT JOIN MovementFloat AS MovementFloat_TotalSummPrimeCost
                                ON MovementFloat_TotalSummPrimeCost.MovementId = Movement.Id
                               AND MovementFloat_TotalSummPrimeCost.DescId = zc_MovementFloat_TotalSummPrimeCost()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
        LEFT JOIN Object AS Object_Unit 
                         ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                     ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                    AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
        LEFT JOIN Object AS Object_Juridical 
                         ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId
        
        LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                     ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                    AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
        LEFT JOIN Object AS Object_PaidKind 
                         ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId
        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementString AS MovementString_InvNumberSP
                                     ON MovementString_InvNumberSP.MovementId = Movement.Id
                                    AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
           /* LEFT JOIN MovementString AS MovementString_MedicSP
                                     ON MovementString_MedicSP.MovementId = Movement.Id
                                    AND MovementString_MedicSP.DescId = zc_MovementString_MedicSP()
            LEFT JOIN MovementString AS MovementString_MemberSP
                                     ON MovementString_MemberSP.MovementId = Movement.Id
                                    AND MovementString_MemberSP.DescId = zc_MovementString_MemberSP()
*/
            LEFT JOIN MovementDate AS MovementDate_OperDateSP
                                   ON MovementDate_OperDateSP.MovementId = Movement.Id
                                  AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                         ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                        AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
            LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = MovementLinkObject_PartnerMedical.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_GroupMemberSP
                                         ON MovementLinkObject_GroupMemberSP.MovementId = Movement.Id
                                        AND MovementLinkObject_GroupMemberSP.DescId = zc_MovementLinkObject_GroupMemberSP()
            LEFT JOIN Object AS Object_GroupMemberSP ON Object_GroupMemberSP.Id = MovementLinkObject_GroupMemberSP.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_MedicSP
                                         ON MovementLinkObject_MedicSP.MovementId = Movement.Id
                                        AND MovementLinkObject_MedicSP.DescId = zc_MovementLinkObject_MedicSP()
            LEFT JOIN Object AS Object_MedicSP ON Object_MedicSP.Id = MovementLinkObject_MedicSP.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberSP
                                         ON MovementLinkObject_MemberSP.MovementId = Movement.Id
                                        AND MovementLinkObject_MemberSP.DescId = zc_MovementLinkObject_MemberSP()
            LEFT JOIN Object AS Object_MemberSP ON Object_MemberSP.Id = MovementLinkObject_MemberSP.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                         ON MovementLinkObject_SPKind.MovementId = Movement.Id
                                        AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
            LEFT JOIN Object AS Object_SPKind ON Object_SPKind.Id = MovementLinkObject_SPKind.ObjectId

    WHERE Movement.DescId = zc_Movement_Sale();

ALTER TABLE Movement_Sale_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».   ¬ÓÓ·Í‡ÎÓ ¿.¿.
 08.02.17         * add SP
 31.10.15                                                         * 
*/

-- ÚÂÒÚ
-- SELECT * FROM Movement_Sale_View  where id = 805
