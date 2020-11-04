-- Function: gpSelect_Object_Contract()

DROP FUNCTION IF EXISTS gpSelect_Object_ContractJuridical (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractJuridical(
    IN inJuridicalId    Integer, 
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               JuridicalBasisId Integer, JuridicalBasisName TVarChar,
               JuridicalId Integer, JuridicalName TVarChar,
               Deferment Integer, Percent TFloat,
               Comment TVarChar, isPartialPay Boolean, 
               isErased boolean
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_Contract());

   RETURN QUERY 
   SELECT
             Object_Contract.Id           AS Id
           , Object_Contract.ObjectCode   AS Code
           , Object_Contract.ValueData    AS Name
         
           , Object_JuridicalBasis.Id         AS JuridicalBasisId
           , Object_JuridicalBasis.ValueData  AS JuridicalBasisName 
                     
           , Object_Juridical.Id         AS JuridicalId
           , Object_Juridical.ValueData  AS JuridicalName 
           , ObjectFloat_Deferment.ValueData ::Integer AS Deferment
           , COALESCE(ObjectFloat_Percent.ValueData,0)   ::TFloat  AS Percent

           , ObjectString_Comment.ValueData AS Comment
           , COALESCE (ObjectBoolean_PartialPay.ValueData, FALSE)  :: Boolean   AS isPartialPay
           
           , Object_Contract.isErased       AS isErased
           
       
   FROM Object AS Object_Contract
           LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                ON ObjectLink_Contract_Juridical.ObjectId = Object_Contract.Id
                               AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()

           JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Contract_Juridical.ChildObjectId 
                                               AND  Object_Juridical.Id = inJuridicalId           

           LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                ON ObjectLink_Contract_JuridicalBasis.ObjectId = Object_Contract.Id
                               AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
           LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = ObjectLink_Contract_JuridicalBasis.ChildObjectId

           LEFT JOIN ObjectString AS ObjectString_Comment 
                                  ON ObjectString_Comment.ObjectId = Object_Contract.Id
                                 AND ObjectString_Comment.DescId = zc_ObjectString_Contract_Comment()                              

           LEFT JOIN ObjectFloat AS ObjectFloat_Deferment 
                                 ON ObjectFloat_Deferment.ObjectId = Object_Contract.Id
                                AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()

           LEFT JOIN ObjectFloat AS ObjectFloat_Percent 
                                 ON ObjectFloat_Percent.ObjectId = Object_Contract.Id
                                AND ObjectFloat_Percent.DescId = zc_ObjectFloat_Contract_Percent()
      
           LEFT JOIN ObjectBoolean AS ObjectBoolean_PartialPay
                                   ON ObjectBoolean_PartialPay.ObjectId = Object_Contract.Id
                                  AND ObjectBoolean_PartialPay.DescId = zc_ObjectBoolean_Contract_PartialPay()

   WHERE Object_Contract.isErased = FALSE
  ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractJuridical (Integer, TVarChar) OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 08.12.16         * Percent
 07.07.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractJuridical (inJuridicalId:= 140, inSession := '2')