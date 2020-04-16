--Function: gpSelect_Object_MarginCategoryLink (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MarginCategoryLink (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_MarginCategoryLink (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MarginCategoryLink(
    IN inShowAll          Boolean,       --
    IN inSession          TVarChar       -- сессия пользователя
)

RETURNS TABLE (Id Integer, MarginCategoryId Integer, MarginCategoryName TVarChar
             , UnitId Integer, UnitName TVarChar, JuridicalId Integer, JuridicalName TVarChar
             , JuridicalName_our TVarChar
             , RetailId Integer, RetailName TVarChar
             , isSite Boolean
             , isErased boolean
              )
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MarginCategory());

   RETURN QUERY  
    
   SELECT 
        Object_MarginCategoryLink.Id, 
        Object_MarginCategoryLink.MarginCategoryId, 
        Object_MarginCategoryLink.MarginCategoryName, 
        Object_MarginCategoryLink.UnitId, 
        Object_MarginCategoryLink.UnitName,
        Object_MarginCategoryLink.JuridicalId, 
        Object_MarginCategoryLink.JuridicalName,
        
        Object_Juridical.ValueData  AS JuridicalName_our,
        Object_Retail.Id            AS RetailId,
        Object_Retail.ValueData     AS RetailName,
        
        COALESCE(ObjectBoolean_Site.ValueData, FALSE) AS isSite,
        MarginCategoryLink.isErased

        
    FROM Object_MarginCategoryLink_View AS Object_MarginCategoryLink
          INNER JOIN Object AS MarginCategoryLink 
                            ON MarginCategoryLink.Id = Object_MarginCategoryLink.Id
                           AND (MarginCategoryLink.IsErased = inShowAll OR inShowAll = True)
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Site 	
                                  ON ObjectBoolean_Site.ObjectId = Object_MarginCategoryLink.MarginCategoryId
                                 AND ObjectBoolean_Site.DescId = zc_ObjectBoolean_MarginCategory_Site()
          LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                               ON ObjectLink_Unit_Juridical.ObjectId = Object_MarginCategoryLink.UnitId
                              AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_MarginCategoryLink (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.04.20         *
 10.04.19         *
 31.08.16         * 
 13.04.16         *
 09.04.15                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MarginCategoryLink ('2')
