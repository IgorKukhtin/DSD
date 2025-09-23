-- Function: gpSelect_Object_PromoDiscountKind(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PromoDiscountKind(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PromoDiscountKind(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , EnumName TVarChar
             , isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY
     SELECT
       Object.Id                    AS Id
     , Object.ObjectCode            AS Code
     , Object.ValueData             AS Name 
     , ObjectString_Enum.ValueData  AS EnumName
     , Object.isErased
     FROM Object
        LEFT JOIN ObjectString AS ObjectString_Enum
                               ON ObjectString_Enum.ObjectId = Object.Id
                              AND ObjectString_Enum.DescId = zc_ObjectString_Enum()
     WHERE Object.DescId = zc_Object_PromoDiscountKind();
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.25         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PromoDiscountKind('2')