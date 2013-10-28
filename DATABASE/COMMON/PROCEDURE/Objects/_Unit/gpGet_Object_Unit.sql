-- Function: gpGet_Object_Unit()

DROP FUNCTION IF EXISTS gpGet_Object_Unit(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Unit(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, 
               ParentId Integer, ParentName TVarChar,
               BusinessId Integer, BusinessName TVarChar, 
               BranchId Integer, BranchName TVarChar,
               JuridicalId Integer, JuridicalName TVarChar,
               AccountDirectionId Integer, AccountDirectionName TVarChar,
               ProfitLossDirectionId Integer, ProfitLossDirectionName TVarChar,
               isErased boolean, isLeaf boolean) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Unit());
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
           , lfGet_ObjectCode(0, zc_Object_Unit()) AS Code
           , CAST ('' as TVarChar) AS Name
           
           , CAST (0 as Integer)   AS ParentId
           , CAST ('' as TVarChar) AS ParentName 

           , CAST (0 as Integer)   AS BusinessId
           , CAST ('' as TVarChar) AS BusinessName 
           
           , CAST (0 as Integer)   AS BranchId
           , CAST ('' as TVarChar) AS BranchName
         
           , CAST (0 as Integer)   AS JuridicalId
           , CAST ('' as TVarChar) AS JuridicalName
         
           , CAST (0 as Integer)   AS AccountDirectionId
           , CAST ('' as TVarChar) AS AccountDirectionName
         
           , CAST (0 as Integer)   AS ProfitLossDirectionId
           , CAST ('' as TVarChar) AS ProfitLossDirectionName
         
           , CAST (NULL AS Boolean) AS isErased
           , CAST (NULL AS Boolean) AS isLeaf;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Unit_View.Id     
           , Object_Unit_View.Code   
           , Object_Unit_View.Name
         
           , Object_Unit_View.ParentId 
           , Object_Unit_View.ParentName 

           , Object_Unit_View.BusinessId
           , Object_Unit_View.BusinessName 
         
           , Object_Unit_View.BranchId
           , Object_Unit_View.BranchName
         
           , Object_Unit_View.JuridicalId
           , Object_Unit_View.JuridicalName
         
           , Object_Unit_View.AccountDirectionId
           , Object_Unit_View.AccountDirectionName
         
           , Object_Unit_View.ProfitLossDirectionId
           , Object_Unit_View.ProfitLossDirectionName
         
           , Object_Unit_View.isErased
           , Object_Unit_View.isLeaf
       FROM Object_Unit_View
      WHERE Object_Unit_View.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Unit(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.07.13          * + If...              
 11.06.13                        *

*/

-- тест
-- SELECT * FROM gpSelect_Unit('2')