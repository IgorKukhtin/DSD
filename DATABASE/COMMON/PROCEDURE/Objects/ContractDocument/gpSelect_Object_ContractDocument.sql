-- Function: gpSelect_Object_ContractDocument(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ContractDocument(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractDocument(
    IN inContractId      Integer,
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , FileName TVarChar
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ContractCondition());

   RETURN QUERY
     SELECT
           Object_ContractDocument.Id        AS Id
         , Object_ContractDocument.ValueData AS FileName

     FROM Object AS Object_ContractDocument
          JOIN ObjectLink AS ObjectLink_ContractDocument_Contract
                          ON ObjectLink_ContractDocument_Contract.ObjectId      = Object_ContractDocument.Id
                         AND ObjectLink_ContractDocument_Contract.DescId        = zc_ObjectLink_ContractDocument_Contract()
                         AND ObjectLink_ContractDocument_Contract.ChildObjectId = inContractId
     WHERE Object_ContractDocument.isErased = FALSE
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.12.13                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractDocument (5, '5')
