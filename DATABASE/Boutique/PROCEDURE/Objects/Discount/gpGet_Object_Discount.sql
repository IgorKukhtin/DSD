-- Function: gpGet_Object_Discount()

DROP FUNCTION IF EXISTS gpGet_Object_Discount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Discount(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, KindDiscount Integer) 
  AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Discount());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE(MAX (Object.ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (0 as Integer)  AS KindDiscount
       FROM Object
       WHERE Object.DescId = zc_Object_Discount();
   ELSE
       RETURN QUERY
       SELECT
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , OS_Discount_KindDiscount.ValueData::INTEGER  AS KindDiscount

       FROM Object
        LEFT JOIN Objectfloat AS OS_Discount_KindDiscount
                 ON OS_Discount_KindDiscount.ObjectId = Object.Id
                AND OS_Discount_KindDiscount.DescId = zc_ObjectFloat_Discount_KindDiscount()
       WHERE Object.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
22.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpSelect_Discount (1,'2')
