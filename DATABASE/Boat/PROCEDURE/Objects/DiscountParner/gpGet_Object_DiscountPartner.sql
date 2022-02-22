-- Торговая марка

DROP FUNCTION IF EXISTS gpGet_Object_DiscountPartner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_DiscountPartner(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             )
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountPartner());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer            AS Id
           , lfGet_ObjectCode(0, zc_Object_DiscountPartner())   AS Code
           , '' :: TVarChar           AS Name
           , '' :: TVarChar           AS Comment
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_DiscountPartner.Id              AS Id
           , Object_DiscountPartner.ObjectCode      AS Code
           , Object_DiscountPartner.ValueData       AS Name
           , ObjectString_Comment.ValueData   AS Comment
       FROM Object AS Object_DiscountPartner
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_DiscountPartner.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_DiscountPartner_Comment() 
       WHERE Object_DiscountPartner.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
 
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.11.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_DiscountPartner (1 ::integer,'2'::TVarChar)
