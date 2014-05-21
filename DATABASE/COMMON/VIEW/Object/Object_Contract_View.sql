-- View: Object_Contract_View

DROP VIEW IF EXISTS Object_Contract_View CASCADE;

CREATE OR REPLACE VIEW Object_Contract_View AS
  SELECT Object_Contract_InvNumber_View.ContractId
       , Object_Contract_InvNumber_View.ContractCode  
       , Object_Contract_InvNumber_View.InvNumber
       , Object_Contract_InvNumber_View.isErased
       , ObjectDate_Start.ValueData                  AS StartDate
       , ObjectDate_End.ValueData                    AS EndDate

       , ObjectLink_Contract_Juridical.ChildObjectId         AS JuridicalId
       , ObjectLink_Contract_JuridicalBasis.ChildObjectId    AS JuridicalBasisId
       , ObjectLink_Contract_PaidKind.ChildObjectId          AS PaidKindId
       , Object_Contract_InvNumber_View.InfoMoneyId

       , Object_Contract_InvNumber_View.ContractStateKindId
       , Object_Contract_InvNumber_View.ContractStateKindCode
       , Object_Contract_InvNumber_View.ContractStateKindName

       , Object_Contract_InvNumber_View.ContractTagId
       , Object_Contract_InvNumber_View.ContractTagCode
       , Object_Contract_InvNumber_View.ContractTagName

       , Object_ContractKind.Id              AS ContractKindId
       , Object_ContractKind.ObjectCode      AS ContractKindCode
       , Object_ContractKind.ValueData       AS ContractKindName

         -- !!!�������� �����������!!!
       , ObjectFloat_ChangePercent.ValueData         AS ChangePercent
       , ObjectFloat_ChangePrice.ValueData           AS ChangePrice
       
  FROM Object_Contract_InvNumber_View
       LEFT JOIN ObjectDate AS ObjectDate_Start
                            ON ObjectDate_Start.ObjectId = Object_Contract_InvNumber_View.ContractId
                           AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
                           AND Object_Contract_InvNumber_View.InvNumber <> '-'
       LEFT JOIN ObjectDate AS ObjectDate_End
                            ON ObjectDate_End.ObjectId = Object_Contract_InvNumber_View.ContractId
                           AND ObjectDate_End.DescId = zc_ObjectDate_Contract_End()
                           AND Object_Contract_InvNumber_View.InvNumber <> '-'
       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                            ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract_InvNumber_View.ContractId 
                           AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
                           AND Object_Contract_InvNumber_View.InvNumber <> '-'
       LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId

       LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                            ON ObjectLink_Contract_Juridical.ObjectId = Object_Contract_InvNumber_View.ContractId 
                           AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
       LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                            ON ObjectLink_Contract_JuridicalBasis.ObjectId = Object_Contract_InvNumber_View.ContractId 
                           AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()

       LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                            ON ObjectLink_Contract_PaidKind.ObjectId = Object_Contract_InvNumber_View.ContractId 
                           AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()


       -- !!!�������� �����������!!!
       LEFT JOIN ObjectFloat AS ObjectFloat_ChangePercent
                             ON ObjectFloat_ChangePercent.ObjectId = Object_Contract_InvNumber_View.ContractId
                            AND ObjectFloat_ChangePercent.DescId = zc_ObjectFloat_Contract_ChangePercent()  
       LEFT JOIN ObjectFloat AS ObjectFloat_ChangePrice
                             ON ObjectFloat_ChangePrice.ObjectId = Object_Contract_InvNumber_View.ContractId
                            AND ObjectFloat_ChangePrice.DescId = zc_ObjectFloat_Contract_ChangePrice()  
  ;


ALTER TABLE Object_Contract_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.05.14                                        * add InvNumber <> '-'
 20.05.14                                        * add ContractKind...
 26.04.14                                        * del ContractKeyId
 25.04.14                                        * add ContractKeyId
 24.04.14                                        * all
 13.02.14                                        * add Object_ContractStateKind...
 14.01.14                                        * add Object_Contract_InvNumber_View_InvNumber_View
 08.01.14                        * 
 18.11.13                                        * !!!�������� �����������!!!
 14.11.13         * add ContractCode      
 20.10.13                                        *
*/

-- ����
-- SELECT * FROM Object_Contract_View
