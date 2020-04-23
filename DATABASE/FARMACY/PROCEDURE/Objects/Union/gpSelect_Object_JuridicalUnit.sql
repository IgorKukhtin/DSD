-- Function: gpSelect_Object_JuridicalUnit()

DROP FUNCTION IF EXISTS gpSelect_Object_JuridicalUnit(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_JuridicalUnit(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , DescName TVarChar
             , JuridicalName TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Juridical());

   RETURN QUERY 
       SELECT 
             Object_Unit.Id              AS Id
           , Object_Unit.ObjectCode      AS Code
           , Object_Unit.ValueData       AS Name
           , ObjectDesc.ItemName         AS DescName
           , Object_Juridical.ValueData  AS JuridicalName
           , Object_Unit.isErased        AS isErased

       FROM Object AS Object_Unit
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Unit.DescId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

       WHERE Object_Unit.DescId = zc_Object_Unit()
      UNION
       SELECT 
             Object_Juridical.Id           AS Id
           , Object_Juridical.ObjectCode   AS Code
           , Object_Juridical.ValueData    AS Name
           , ObjectDesc.ItemName           AS DescName
           , '' :: TVarChar                AS JuridicalName
           , Object_Juridical.isErased     AS isErased
           
       FROM Object AS Object_Juridical
            INNER JOIN ObjectBoolean AS ObjectBoolean_isCorporate 
                                     ON ObjectBoolean_isCorporate.ObjectId = Object_Juridical.Id
                                    AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
                                    AND ObjectBoolean_isCorporate.ValueData = TRUE
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Juridical.DescId
            
       WHERE Object_Juridical.DescId = zc_Object_Juridical()
      ;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.12.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_JuridicalUnit ('2')