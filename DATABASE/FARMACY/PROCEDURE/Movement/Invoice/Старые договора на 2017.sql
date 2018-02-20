   
WITH
-- договора мед учреждений
        tmpContract AS (SELECT ObjectLink_PartnerMedical_Juridical.ObjectId                  AS PartnerMedicalId
                              , ObjectLink_PartnerMedical_Juridical.ChildObjectId             AS PartnerMedical_JuridicalId
                              , COALESCE(ObjectLink_Contract_Juridical.ObjectId,0)            AS PartnerMedical_ContractId
                              , COALESCE(ObjectFloat_PercentSP.ValueData,0) :: TFloat         AS PercentSP
                              , COALESCE(ObjectLink_Contract_JuridicalBasis.ChildObjectId,0)  AS Contract_JuridicalBasisId
                              , COALESCE(ObjectLink_Contract_GroupMemberSP.ChildObjectId,0)   AS Contract_GroupMemberSPId

                              , ObjectDate_Start.ValueData                                    AS StartDate_Contract
                              , ObjectDate_End.ValueData                                      AS EndDate_Contract

                         FROM ObjectLink AS ObjectLink_PartnerMedical_Juridical 
                              INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                     ON ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_PartnerMedical_Juridical.ChildObjectId
                                    AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                              LEFT JOIN ObjectFloat AS ObjectFloat_PercentSP
                                     ON ObjectFloat_PercentSP.ObjectId = ObjectLink_Contract_Juridical.ObjectId
                                    AND ObjectFloat_PercentSP.DescId = zc_ObjectFloat_Contract_PercentSP()
                                    
                              LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                     ON ObjectLink_Contract_JuridicalBasis.ObjectId = ObjectLink_Contract_Juridical.ObjectId
                                    AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
                              LEFT JOIN ObjectLink AS ObjectLink_Contract_GroupMemberSP
                                     ON ObjectLink_Contract_GroupMemberSP.ObjectId = ObjectLink_Contract_Juridical.ObjectId
                                    AND ObjectLink_Contract_GroupMemberSP.DescId = zc_ObjectLink_Contract_GroupMemberSP()
                                    
                              LEFT JOIN ObjectDate AS ObjectDate_Start
                                                   ON ObjectDate_Start.ObjectId = ObjectLink_Contract_Juridical.ObjectId
                                                  AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
                              LEFT JOIN ObjectDate AS ObjectDate_End
                                                   ON ObjectDate_End.ObjectId = ObjectLink_Contract_Juridical.ObjectId
                                                  AND ObjectDate_End.DescId = zc_ObjectDate_Contract_End()

                         WHERE ObjectLink_PartnerMedical_Juridical.DescId = zc_ObjectLink_PartnerMedical_Juridical()
                           and COALESCE(ObjectFloat_PercentSP.ValueData,0) <> 50
                        )

    SELECT Movement.Id, tmpContract.PartnerMedical_ContractId
       -- сохранили связь с <>
       -- lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), Movement.Id, tmpContract.PartnerMedical_ContractId);
    FROM Movement 
      
        LEFT JOIN MovementDate AS MovementDate_OperDateStart
                               ON MovementDate_OperDateStart.MovementId = Movement.Id
                              AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
        LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                               ON MovementDate_OperDateEnd.MovementId = Movement.Id
                              AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                     ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                    AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
        
        LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                     ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                    AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
  
        LEFT JOIN ObjectLink AS ObjectLink_PartnerMedical_Juridical 
                             ON ObjectLink_PartnerMedical_Juridical.ObjectId = MovementLinkObject_PartnerMedical.ObjectId
                            AND ObjectLink_PartnerMedical_Juridical.DescId = zc_ObjectLink_PartnerMedical_Juridical()

        LEFT JOIN MovementFloat AS MovementFloat_SP
                                ON MovementFloat_SP.MovementId = Movement.Id
                               AND MovementFloat_SP.DescId = zc_MovementFloat_SP()

        INNER JOIN tmpContract ON tmpContract.PartnerMedicalId = MovementLinkObject_PartnerMedical.ObjectId
                              AND tmpContract.PartnerMedical_JuridicalId = ObjectLink_PartnerMedical_Juridical.ChildObjectId 
                              AND tmpContract.Contract_JuridicalBasisId = MovementLinkObject_Juridical.ObjectId
                              AND COALESCE (tmpContract.Contract_GroupMemberSPId,0) = CASE WHEN COALESCE(MovementFloat_SP.ValueData,0) = 1 THEN 4515699  -- соц.проект
                                                                                           /*WHEN COALESCE(MovementFloat_SP.ValueData,0) = 2 THEN 0*/
                                                                                           else 0
                                                                                      END
                              --выбираем дог. согласно датам , по дате нач.периода отчета
                              --AND tmpContract.StartDate_Contract <= MovementDate_OperDateStart.ValueData AND tmpContract.EndDate_Contract >= MovementDate_OperDateStart.ValueData 
                              AND tmpContract.StartDate_Contract <= MovementDate_OperDateEnd.ValueData AND tmpContract.EndDate_Contract >= MovementDate_OperDateEnd.ValueData 
            
    WHERE Movement.StatusId <> zc_Enum_Status_Erased()
                           AND Movement.DescId = zc_Movement_Invoice()
                           AND Movement.OperDate < '01.01.2018'

--эти 5 счетов остаются без договора 
/*select * from Movement where id in (5298386,
5307916,
5298802,
5298804,
5298803
)*/