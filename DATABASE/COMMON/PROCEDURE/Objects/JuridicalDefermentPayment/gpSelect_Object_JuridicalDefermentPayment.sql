-- Function: gpSelect_Object_JuridicalDefermentPayment()

DROP FUNCTION IF EXISTS gpSelect_Object_JuridicalDefermentPayment (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_JuridicalDefermentPayment(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, JuridicalId Integer, ContractId Integer, OperDate TDateTime, Amount TFloat) AS
$BODY$
BEGIN
   

   RETURN QUERY 
       SELECT Object_JuridicalDefermentPayment.Id
            , ObjectLink_JuridicalDefermentPayment_Juridical.ChildObjectId AS JuridicalId
            , ObjectLink_JuridicalDefermentPayment_Contract.ChildObjectId  AS ContractId
            , ObjectDate_JuridicalDefermentPayment_OperDate.ValueData      AS OperDate
            , ObjectFloat_JuridicalDefermentPayment_Amount.ValueData       AS Amount
       FROM Object AS Object_JuridicalDefermentPayment
             LEFT JOIN ObjectLink AS ObjectLink_JuridicalDefermentPayment_Juridical
                                  ON ObjectLink_JuridicalDefermentPayment_Juridical.ObjectId = Object_JuridicalDefermentPayment.Id
                                 AND ObjectLink_JuridicalDefermentPayment_Juridical.DescId = zc_ObjectLink_JuridicalDefermentPayment_Juridical()
       
             LEFT JOIN ObjectLink AS ObjectLink_JuridicalDefermentPayment_Contract
                                  ON ObjectLink_JuridicalDefermentPayment_Contract.ObjectId = Object_JuridicalDefermentPayment.Id
                                 AND ObjectLink_JuridicalDefermentPayment_Contract.DescId = zc_ObjectLink_JuridicalDefermentPayment_Contract()
        
            LEFT JOIN ObjectDate AS ObjectDate_JuridicalDefermentPayment_OperDate
                                 ON ObjectDate_JuridicalDefermentPayment_OperDate.ObjectId = Object_JuridicalDefermentPayment.Id
                                AND ObjectDate_JuridicalDefermentPayment_OperDate.DescId = zc_ObjectDate_JuridicalDefermentPayment_OperDate()
     
            LEFT JOIN ObjectFloat AS ObjectFloat_JuridicalDefermentPayment_Amount
                                  ON ObjectFloat_JuridicalDefermentPayment_Amount.ObjectId = Object_JuridicalDefermentPayment.Id
                                 AND ObjectFloat_JuridicalDefermentPayment_Amount.DescId = zc_ObjectFloat_JuridicalDefermentPayment_Amount()
       WHERE Object_JuridicalDefermentPayment.DescId = zc_Object_JuridicalDefermentPayment();
  
END;
$BODY$


LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.12.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_JuridicalDefermentPayment('3')