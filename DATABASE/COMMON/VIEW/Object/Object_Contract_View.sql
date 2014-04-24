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

         -- !!!¬–≈Ã≈ÕÕŒ ¬Œ——“¿ÕŒ¬»À!!!
       , ObjectFloat_ChangePercent.ValueData         AS ChangePercent
       , ObjectFloat_ChangePrice.ValueData           AS ChangePrice
       
  FROM Object_Contract_InvNumber_View
       LEFT JOIN ObjectDate AS ObjectDate_Start
                            ON ObjectDate_Start.ObjectId = Object_Contract_InvNumber_View.ContractId
                           AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
       LEFT JOIN ObjectDate AS ObjectDate_End
                            ON ObjectDate_End.ObjectId = Object_Contract_InvNumber_View.ContractId
                           AND ObjectDate_End.DescId = zc_ObjectDate_Contract_End()                               

       LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                            ON ObjectLink_Contract_Juridical.ObjectId = Object_Contract_InvNumber_View.ContractId 
                           AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
       LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                            ON ObjectLink_Contract_JuridicalBasis.ObjectId = Object_Contract_InvNumber_View.ContractId 
                           AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()

       LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                            ON ObjectLink_Contract_PaidKind.ObjectId = Object_Contract_InvNumber_View.ContractId 
                           AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()

       -- !!!¬–≈Ã≈ÕÕŒ ¬Œ——“¿ÕŒ¬»À!!!
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
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 24.04.14                                        * all
 13.02.14                                        * add Object_ContractStateKind...
 14.01.14                                        * add Object_Contract_InvNumber_View_InvNumber_View
 08.01.14                        * 
 18.11.13                                        * !!!¬–≈Ã≈ÕÕŒ ¬Œ——“¿ÕŒ¬»À!!!
 14.11.13         * add ContractCode      
 20.10.13                                        *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_Contract_View
