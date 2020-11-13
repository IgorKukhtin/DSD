-- Function: gpGet_Object_ContractTradeMark (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_ContractTradeMark (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ContractTradeMark(
    IN inId                     Integer,       -- ключ объекта <>
    IN inSession                TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code INTEGER
             , ContractId Integer, ContractName TVarChar
             , TradeMarkId Integer, TradeMarkName TVarChar
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ContractTradeMark());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_ContractTradeMark()) AS Code
           , CAST (0 as Integer)    AS ContractId
           , CAST ('' as TVarChar)  AS ContractName  

           , CAST (0 as Integer)    AS TradeMarkId
           , CAST ('' as TVarChar)  AS TradeMarkName
       ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_ContractTradeMark.Id          AS Id
           , Object_ContractTradeMark.ObjectCode  AS Code
          
           , Object_Contract.Id                   AS ContractId
           , Object_Contract.ValueData            AS ContractName

           , Object_TradeMark.Id                  AS TradeMarkId
           , Object_TradeMark.ValueData           AS TradeMarkName
         
       FROM Object AS Object_ContractTradeMark

            LEFT JOIN ObjectLink AS ContractTradeMark_Contract
                                 ON ContractTradeMark_Contract.ObjectId = Object_ContractTradeMark.Id
                                AND ContractTradeMark_Contract.DescId = zc_ObjectLink_ContractTradeMark_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ContractTradeMark_Contract.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_ContractTradeMark_TradeMark
                                 ON ObjectLink_ContractTradeMark_TradeMark.ObjectId = Object_ContractTradeMark.Id
                                AND ObjectLink_ContractTradeMark_TradeMark.DescId = zc_ObjectLink_ContractTradeMark_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_ContractTradeMark_TradeMark.ChildObjectId

       WHERE Object_ContractTradeMark.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.11.20         *         
*/

-- тест
-- SELECT * FROM gpGet_Object_ContractTradeMark (0, inSession := '5')
