-- Function: gpSelect_Object_BranchJuridical (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_BranchJuridical (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BranchJuridical(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , BranchId Integer, BranchCode Integer, BranchName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar, JuridicalGroupName TVarChar 
             , RetailId Integer, RetailName TVarChar
             , OKPO TVarChar      
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , isErased Boolean
        
             ) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_BranchJuridical());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_BranchJuridical.Id          AS Id
           
           , Object_Branch.Id            AS BranchId
           , Object_Branch.ObjectCode    AS BranchCode
           , Object_Branch.ValueData     AS BranchName
     
           , Object_Juridical.Id         AS JuridicalId
           , Object_Juridical.ObjectCode AS JuridicalCode
           , Object_Juridical.ValueData  AS JuridicalName

           , Object_JuridicalGroup.ValueData  AS JuridicalGroupName
           , Object_Retail.Id                 AS RetailId
           , Object_Retail.ValueData          AS RetailName
           , ObjectHistory_JuridicalDetails_View.OKPO 

           , Object_Unit.Id         AS UnitId
           , Object_Unit.ObjectCode AS UnitCode
           , Object_Unit.ValueData  AS UnitName

           , Object_BranchJuridical.isErased     AS isErased

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

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                             ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id 
                            AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
            LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id 
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 

     WHERE Object_BranchJuridical.DescId = zc_Object_BranchJuridical()

    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_BranchJuridical (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.01.16         * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_BranchJuridical (zfCalc_UserAdmin())
