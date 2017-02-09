-- Function: gpGet_Object_PromoKind(Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_PromoKind(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PromoKind(
    IN inId          Integer,       -- ключ объекта <Банки>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
    IF COALESCE (inId, 0) = 0
    THEN
    RETURN QUERY
        SELECT
            CAST (0 as Integer)                AS Id
          , lfGet_ObjectCode(0, zc_Object_PromoKind()) AS Code
          , CAST ('' as TVarChar)              AS Name
          , CAST (NULL AS Boolean)             AS isErased;
    ELSE
        RETURN QUERY
        SELECT
            Object_PromoKind.Id                     AS Id
          , Object_PromoKind.ObjectCode             AS Code
          , Object_PromoKind.ValueData              AS Name
          , Object_PromoKind.isErased               AS isErased
        FROM Object AS Object_PromoKind
        WHERE Object_PromoKind.Id = inId;
   END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_PromoKind (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 31.10.15                                                                       *
*/

-- тест
-- SELECT * FROM  gpGet_Object_PromoKind (2, '')
