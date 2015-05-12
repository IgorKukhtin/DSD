-- View: Container_Partner_View

-- DROP VIEW IF EXISTS Container_Partner_View;

CREATE OR REPLACE VIEW Container_Partner_View AS

  SELECT CLO_Partner.ContainerId
       , Container.ObjectId     AS AccountId
       , CLO_Partner.ObjectId   AS PartnerId
       , CLO_Juridical.ObjectId AS JuridicalId
       , CLO_Contract.ObjectId  AS ContractId
       , CLO_PaidKind.ObjectId  AS PaidKindId
       , CLO_Branch.ObjectId    AS BranchId
       , CLO_InfoMoney.ObjectId AS InfoMoneyId
       , ObjectFloat_MovementId.ValueData :: Integer AS MovementId_Partion
       , CLO_PartionMovement.ObjectId     AS PartionMovementId
       , Object_PartionMovement.ValueData AS PartionMovementName
       , ObjectDate_Payment.ValueData     AS PaymentDate
       , CASE WHEN Container.Amount > 0 THEN Container.Amount ELSE 0 END ::TFloat AS AmountDebet
       , CASE WHEN Container.Amount < 0 THEN -1 * Container.Amount ELSE 0 END ::TFloat AS AmountKredit
  FROM ContainerLinkObject AS CLO_Partner
       INNER JOIN Container ON Container.Id = CLO_Partner.ContainerId
                           AND Container.Amount <> 0
                           AND Container.DescId = zc_Container_Summ()
       INNER JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                             ON ObjectLink_Account_AccountGroup.ObjectId = Container.ObjectId
                            AND ObjectLink_Account_AccountGroup.ChildObjectId <> zc_Enum_AccountGroup_110000() -- “‡ÌÁËÚ
                            AND ObjectLink_Account_AccountGroup.DescId = zc_ObjectLink_Account_AccountGroup()
       LEFT JOIN ContainerLinkObject AS CLO_PaidKind
                                     ON CLO_PaidKind.ContainerId = CLO_Partner.ContainerId
                                    AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
       LEFT JOIN ContainerLinkObject AS CLO_Contract
                                     ON CLO_Contract.ContainerId = CLO_Partner.ContainerId
                                    AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
       LEFT JOIN ContainerLinkObject AS CLO_Juridical
                                     ON CLO_Juridical.ContainerId = CLO_Partner.ContainerId
                                    AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
       LEFT JOIN ContainerLinkObject AS CLO_Branch
                                     ON CLO_Branch.ContainerId = CLO_Partner.ContainerId
                                    AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
       LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                     ON CLO_InfoMoney.ContainerId = CLO_Partner.ContainerId
                                    AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
       LEFT JOIN ContainerLinkObject AS CLO_PartionMovement
                                     ON CLO_PartionMovement.ContainerId = CLO_Partner.ContainerId
                                    AND CLO_PartionMovement.DescId = zc_ContainerLinkObject_PartionMovement()
       LEFT JOIN Object AS Object_PartionMovement ON Object_PartionMovement.Id = CLO_PartionMovement.ObjectId
       LEFT JOIN ObjectDate AS ObjectDate_Payment ON ObjectDate_Payment.ObjectId = CLO_PartionMovement.ObjectId
                                                 AND ObjectDate_Payment.DescId = zc_ObjectDate_PartionMovement_Payment()
       LEFT JOIN ObjectFloat AS ObjectFloat_MovementId ON ObjectFloat_MovementId.ObjectId = CLO_PartionMovement.ObjectId
                                                      AND ObjectFloat_MovementId.DescId = zc_ObjectFloat_PartionMovement_MovementId()

  WHERE CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
 ;

ALTER TABLE Container_Partner_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 02.03.15                                        *
*/

-- ÚÂÒÚ
-- SELECT * FROM Container_Partner_View
