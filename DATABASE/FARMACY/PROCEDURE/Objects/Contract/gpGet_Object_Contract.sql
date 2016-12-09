-- Function: gpGet_Object_Contract()

DROP FUNCTION IF EXISTS gpGet_Object_Contract(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Contract(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,  
               JuridicalBasisId Integer, JuridicalBasisName TVarChar,
               JuridicalId Integer, JuridicalName TVarChar,
               Deferment Integer, Percent TFloat,
               Comment TVarChar,
               StartDate TDateTime, EndDate TDateTime,
               isErased boolean) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Contract());
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
           , lfGet_ObjectCode(0, zc_Object_Contract()) AS Code
           , CAST ('' as TVarChar) AS Name
           
           , CAST (0 as Integer)   AS JuridicalBasisId
           , CAST ('' as TVarChar) AS JuridicalBasisName 
           
           , CAST (0 as Integer)   AS JuridicalId
           , CAST ('' as TVarChar) AS JuridicalName
           , 0                     AS Deferment
           , CAST (0 AS TFloat)    AS Percent

           , CAST (NULL AS TVarChar) AS Comment  

           , CURRENT_DATE :: TDateTime AS StartDate
           , CURRENT_DATE :: TDateTime AS EndDate   
       
           , CAST (NULL AS Boolean) AS isErased;
   
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Contract_View.Id
           , Object_Contract_View.Code
           , Object_Contract_View.Name
         
           , Object_Contract_View.JuridicalBasisId
           , Object_Contract_View.JuridicalBasisName 
                     
           , Object_Contract_View.JuridicalId
           , Object_Contract_View.JuridicalName 
           , Object_Contract_View.Deferment
           , Object_Contract_View.Percent

           , Object_Contract_View.Comment

           , COALESCE (ObjectDate_Start.ValueData, CURRENT_DATE) :: TDateTime   AS StartDate 
           , COALESCE (ObjectDate_End.ValueData, CURRENT_DATE) :: TDateTime     AS EndDate   
           
           , Object_Contract_View.isErased
       FROM Object_Contract_View
            LEFT JOIN ObjectDate AS ObjectDate_Start
                                 ON ObjectDate_Start.ObjectId = Object_Contract_View.ContractId
                                AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
            LEFT JOIN ObjectDate AS ObjectDate_End
                                 ON ObjectDate_End.ObjectId = Object_Contract_View.ContractId
                                AND ObjectDate_End.DescId = zc_ObjectDate_Contract_End()      
      WHERE Object_Contract_View.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Contract (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.12.16         *
 01.07.14         *

*/

-- тест
-- SELECT * FROM gpGet_Object_Contract(0,'2')