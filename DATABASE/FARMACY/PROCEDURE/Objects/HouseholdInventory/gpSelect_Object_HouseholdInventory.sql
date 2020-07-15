-- Function: gpSelect_Object_HouseholdInventory()

DROP FUNCTION IF EXISTS gpSelect_Object_HouseholdInventory(boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_HouseholdInventory(
    IN inisErased    boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , CountForPrice TFloat
             , isErased boolean) AS
$BODY$BEGIN


   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY
   SELECT
          Object_HouseholdInventory.Id                 AS Id
        , Object_HouseholdInventory.ObjectCode         AS Code
        , Object_HouseholdInventory.ValueData          AS Name
        
        , ObjectFloat_CountForPrice.ValueData          AS CountForPrice

        , Object_HouseholdInventory.isErased           AS isErased

   FROM Object AS Object_HouseholdInventory

        LEFT JOIN ObjectFloat AS ObjectFloat_CountForPrice
                              ON ObjectFloat_CountForPrice.ObjectId = Object_HouseholdInventory.Id
                             AND ObjectFloat_CountForPrice.DescId = zc_ObjectFloat_HouseholdInventory_CountForPrice()

   WHERE Object_HouseholdInventory.DescId = zc_Object_HouseholdInventory()
     AND (Object_HouseholdInventory.isErased = False or inIsErased = True);

END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_HouseholdInventory(boolean, TVarChar) OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.07.20                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_HouseholdInventory(False, '3')