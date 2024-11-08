-- Function: gpGet_Object_BranchJuridical (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_BranchJuridical (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_BranchJuridical(
    IN inId                     Integer,       -- ключ объекта <>
    IN inSession                TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , BranchId Integer, BranchName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , UnitId Integer, UnitName TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_BranchJuridical());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           
           , CAST (0 as Integer)    AS BranchId
           , CAST ('' as TVarChar)  AS BranchName  

           , CAST (0 as Integer)    AS JuridicalId
           , CAST ('' as TVarChar)  AS JuridicalName

           , CAST (0 as Integer)    AS UnitId
           , CAST ('' as TVarChar)  AS UnitName

           , CAST (NULL AS Boolean) AS isErased

       ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_BranchJuridical.Id    AS Id
       
           , Object_Branch.Id             AS BranchId
           , Object_Branch.ValueData      AS BranchName

           , Object_Juridical.Id          AS JuridicalId
           , Object_Juridical.ValueData   AS JuridicalName

           , Object_Unit.Id         AS UnitId
           , Object_Unit.ValueData  AS UnitName
           
           , Object_BranchJuridical.isErased AS isErased
           
       FROM Object AS Object_BranchJuridical
       
            LEFT JOIN ObjectLink AS ObjectLink_Branch
                                 ON ObjectLink_Branch.ObjectId = Object_BranchJuridical.Id
                                AND ObjectLink_Branch.DescId = zc_ObjectLink_BranchJuridical_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Branch.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                 ON ObjectLink_Juridical.ObjectId = Object_BranchJuridical.Id
                                AND ObjectLink_Juridical.DescId = zc_ObjectLink_BranchJuridical_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Juridical.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit
                                 ON ObjectLink_Unit.ObjectId = Object_BranchJuridical.Id
                                AND ObjectLink_Unit.DescId = zc_ObjectLink_BranchJuridical_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId                                           
       WHERE Object_BranchJuridical.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.01.16         *         
*/

-- тест
-- SELECT * FROM gpGet_Object_BranchJuridical (0, inSession := '5')
