-- Function: gpSelect_Object_JuridicalDefermentPayment()

DROP FUNCTION IF EXISTS gpSelect_Object_JuridicalDefermentPayment (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_JuridicalDefermentPayment(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, JuridicalId Integer, ContractId Integer
             , PaidKindId Integer, PartnerId Integer
             , OperDate TDateTime, Amount TFloat
             , OperDateIn TDateTime, AmountIn TFloat
             ) AS
$BODY$
BEGIN
   

   RETURN QUERY 
       SELECT Object_JuridicalDefermentPayment.Id
            , ObjectLink_JuridicalDefermentPayment_Juridical.ChildObjectId AS JuridicalId
            , ObjectLink_JuridicalDefermentPayment_Contract.ChildObjectId  AS ContractId
            , ObjectLink_JuridicalDefermentPayment_PaidKind.ChildObjectId  AS PaidKindId
            , ObjectLink_JuridicalDefermentPayment_Partner.ChildObjectId   AS PartnerId
            , ObjectDate_JuridicalDefermentPayment_OperDate.ValueData      AS OperDate
            , ObjectFloat_JuridicalDefermentPayment_Amount.ValueData       AS Amount 
            , ObjectDate_JuridicalDefermentPayment_OperDateIn.ValueData    AS OperDateIn
            , ObjectFloat_JuridicalDefermentPayment_AmountIn.ValueData     AS AmountIn
       FROM Object AS Object_JuridicalDefermentPayment
             LEFT JOIN ObjectLink AS ObjectLink_JuridicalDefermentPayment_Juridical
                                  ON ObjectLink_JuridicalDefermentPayment_Juridical.ObjectId = Object_JuridicalDefermentPayment.Id
                                 AND ObjectLink_JuridicalDefermentPayment_Juridical.DescId = zc_ObjectLink_JuridicalDefermentPayment_Juridical()
       
             LEFT JOIN ObjectLink AS ObjectLink_JuridicalDefermentPayment_Contract
                                  ON ObjectLink_JuridicalDefermentPayment_Contract.ObjectId = Object_JuridicalDefermentPayment.Id
                                 AND ObjectLink_JuridicalDefermentPayment_Contract.DescId = zc_ObjectLink_JuridicalDefermentPayment_Contract()

             LEFT JOIN ObjectLink AS ObjectLink_JuridicalDefermentPayment_PaidKind
                                  ON ObjectLink_JuridicalDefermentPayment_PaidKind.ObjectId = Object_JuridicalDefermentPayment.Id
                                 AND ObjectLink_JuridicalDefermentPayment_PaidKind.DescId = zc_ObjectLink_JuridicalDefermentPayment_PaidKind()
     
             LEFT JOIN ObjectLink AS ObjectLink_JuridicalDefermentPayment_Partner
                                  ON ObjectLink_JuridicalDefermentPayment_Partner.ObjectId = Object_JuridicalDefermentPayment.Id
                                 AND ObjectLink_JuridicalDefermentPayment_Partner.DescId = zc_ObjectLink_JuridicalDefermentPayment_Partner()

            LEFT JOIN ObjectDate AS ObjectDate_JuridicalDefermentPayment_OperDate
                                 ON ObjectDate_JuridicalDefermentPayment_OperDate.ObjectId = Object_JuridicalDefermentPayment.Id
                                AND ObjectDate_JuridicalDefermentPayment_OperDate.DescId = zc_ObjectDate_JuridicalDefermentPayment_OperDate()
     
            LEFT JOIN ObjectFloat AS ObjectFloat_JuridicalDefermentPayment_Amount
                                  ON ObjectFloat_JuridicalDefermentPayment_Amount.ObjectId = Object_JuridicalDefermentPayment.Id
                                 AND ObjectFloat_JuridicalDefermentPayment_Amount.DescId = zc_ObjectFloat_JuridicalDefermentPayment_Amount()  
            --последний приход дата / сумма
            LEFT JOIN ObjectDate AS ObjectDate_JuridicalDefermentPayment_OperDateIn
                                 ON ObjectDate_JuridicalDefermentPayment_OperDateIn.ObjectId = Object_JuridicalDefermentPayment.Id
                                AND ObjectDate_JuridicalDefermentPayment_OperDateIn.DescId = zc_ObjectDate_JuridicalDefermentPayment_OperDateIn()
     
            LEFT JOIN ObjectFloat AS ObjectFloat_JuridicalDefermentPayment_AmountIn
                                  ON ObjectFloat_JuridicalDefermentPayment_AmountIn.ObjectId = Object_JuridicalDefermentPayment.Id
                                 AND ObjectFloat_JuridicalDefermentPayment_AmountIn.DescId = zc_ObjectFloat_JuridicalDefermentPayment_AmountIn()

       WHERE Object_JuridicalDefermentPayment.DescId = zc_Object_JuridicalDefermentPayment();
  
END;
$BODY$


LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.09.22         *
 02.12.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_JuridicalDefermentPayment('3')