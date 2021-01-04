-- Торговая марка

DROP FUNCTION IF EXISTS gpGet_Object_Client (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Client(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , DiscountTax TFloat
             , Comment TVarChar
             )
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Client());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer            AS Id
           , lfGet_ObjectCode(0, zc_Object_Client())   AS Code
           , '' :: TVarChar           AS Name
           , 0  :: TFloat             AS DiscountTax
           , '' :: TVarChar           AS Comment
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_Client.Id                 AS Id
           , Object_Client.ObjectCode         AS Code
           , Object_Client.ValueData          AS Name
           , COALESCE (ObjectFloat_DiscountTax.ValueData,0) ::TFloat AS DiscountTax
           , ObjectString_Comment.ValueData  AS Comment
       FROM Object AS Object_Client
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_Client.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_Client_Comment()
          LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTax
                                ON ObjectFloat_DiscountTax.ObjectId = Object_Client.Id
                               AND ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_Client_DiscountTax()
       WHERE Object_Client.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
 
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.01.21         *
 22.10.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Client (1 ::integer,'2'::TVarChar)
