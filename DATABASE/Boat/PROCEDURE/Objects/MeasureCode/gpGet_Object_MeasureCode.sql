-- 
DROP FUNCTION IF EXISTS gpGet_Object_MeasureCode (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MeasureCode(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             )
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MeasureCode());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer            AS Id
           , lfGet_ObjectCode(0, zc_Object_MeasureCode())   AS Code
           , '' :: TVarChar           AS Name
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_MeasureCode.Id              AS Id
           , Object_MeasureCode.ObjectCode      AS Code
           , Object_MeasureCode.ValueData       AS Name
       FROM Object AS Object_MeasureCode
       WHERE Object_MeasureCode.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
 
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.02.22         *
*/

-- тест
-- SELECT * FROM gpGet_Object_MeasureCode (1 ::integer,'2'::TVarChar)
