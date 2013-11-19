-- View: Object_Contract_View

DROP VIEW IF EXISTS Object_Contract_View;

CREATE OR REPLACE VIEW Object_Contract_View AS
  SELECT Object_Contract.Id                          AS ContractId
       , Object_Contract.ObjectCode                  AS ContractCode  
       , Object_Contract.ValueData                   AS InvNumber
       , Object_Contract.isErased                    AS isErased
       , ObjectDate_Start.ValueData                  AS StartDate
       , ObjectDate_End.ValueData                    AS EndDate

       , ObjectLink_Contract_Juridical.ChildObjectId         AS JuridicalId
       , ObjectLink_Contract_PaidKind.ChildObjectId          AS PaidKindId
       , ObjectLink_Contract_InfoMoney.ChildObjectId         AS InfoMoneyId

         -- !!!¬–≈Ã≈ÕÕŒ ¬Œ——“¿ÕŒ¬»À!!!
       , ObjectFloat_ChangePercent.ValueData         AS ChangePercent
       , ObjectFloat_ChangePrice.ValueData           AS ChangePrice
       
  FROM Object AS Object_Contract
       LEFT JOIN ObjectDate AS ObjectDate_Start
                            ON ObjectDate_Start.ObjectId = Object_Contract.Id
                           AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
      
       LEFT JOIN ObjectDate AS ObjectDate_End
                            ON ObjectDate_End.ObjectId = Object_Contract.Id
                           AND ObjectDate_End.DescId = zc_ObjectDate_Contract_End()                               

       LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                            ON ObjectLink_Contract_Juridical.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()

       LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                            ON ObjectLink_Contract_PaidKind.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()

       LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                            ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                           
       -- !!!¬–≈Ã≈ÕÕŒ ¬Œ——“¿ÕŒ¬»À!!!
       LEFT JOIN ObjectFloat AS ObjectFloat_ChangePercent
                             ON ObjectFloat_ChangePercent.ObjectId = Object_Contract.Id
                            AND ObjectFloat_ChangePercent.DescId = zc_ObjectFloat_Contract_ChangePercent()  
       LEFT JOIN ObjectFloat AS ObjectFloat_ChangePrice
                             ON ObjectFloat_ChangePrice.ObjectId = Object_Contract.Id
                             AND ObjectFloat_ChangePrice.DescId = zc_ObjectFloat_Contract_ChangePrice()  

  WHERE Object_Contract.DescId = zc_Object_Contract();


ALTER TABLE Object_Contract_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 18.11.13                                        * !!!¬–≈Ã≈ÕÕŒ ¬Œ——“¿ÕŒ¬»À!!!
 14.11.13         * add ContractCode      
 20.10.13                                        *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_Contract_View