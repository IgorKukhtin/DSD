-- Function: gpGetObject_byCode()
-- for Scale only

DROP FUNCTION IF EXISTS gpGetObject_byCode(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGetObject_byCode(
    IN inCode        Integer,
    IN inDescId      Integer,
   OUT outId         Integer,
   OUT outName       TVarChar,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inCode, 0) = 0
   THEN
       SELECT
             CAST (0 as Integer)
           , CAST ('' as TVarChar)
       INTO outId, outName ;
   ELSE
       SELECT Object.Id, Object.ValueData INTO outId, outName
       FROM Object
       WHERE Object.ObjectCode = inCode AND (DescId = inDescId OR inDescId=0);
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGetObject_byCode(Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.03.14                                                         *    + inDescId
 18.03.14                                                         *

*/

-- тест
-- SELECT * FROM gpGetObject_byCode (4765, zc_Object_Goods(), '2')