-- Function: gpSelect_Object_DivisionParties (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_DivisionParties (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DivisionParties(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , EnumName TVarChar
             , isBanFiscalSale Boolean
             , isErased Boolean
             ) AS
             
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_DivisionParties());

   RETURN QUERY 
   SELECT
        Object_DivisionParties.Id           AS Id 
      , Object_DivisionParties.ObjectCode   AS Code
      , Object_DivisionParties.ValueData    AS Name
      , ObjectString.ValueData              AS EnumName
      , COALESCE (ObjectBoolean_BanFiscalSale.ValueData, False) AS isBanFiscalSale
      , Object_DivisionParties.isErased     AS isErased
   FROM Object AS Object_DivisionParties
        LEFT JOIN ObjectString ON ObjectString.ObjectId = Object_DivisionParties.Id
                              AND ObjectString.DescId = zc_ObjectString_Enum()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_BanFiscalSale
                                ON ObjectBoolean_BanFiscalSale.ObjectId = Object_DivisionParties.Id
                               AND ObjectBoolean_BanFiscalSale.DescId = zc_ObjectBoolean_DivisionParties_BanFiscalSale()
   WHERE Object_DivisionParties.DescId = zc_Object_DivisionParties();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.07.19                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_DivisionParties('3')