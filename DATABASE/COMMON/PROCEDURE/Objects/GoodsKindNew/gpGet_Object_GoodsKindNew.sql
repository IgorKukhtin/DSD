-- Function: gpGet_Object_GoodsKindNew()

DROP FUNCTION IF EXISTS gpGet_Object_GoodsKindNew(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsKindNew(
    IN inId          Integer,       -- Бизнесы 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsKindNew());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_GoodsKindNew()) AS Code
           , CAST ('' as TVarChar)  AS Name
       ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
       FROM Object
       WHERE Object.Id = inId;
   END IF;
     
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpGet_Object_GoodsKindNew(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.12.22         *     

*/

-- тест
-- select * from gpGet_Object_GoodsKindNew(inId := 0 ,  inSession := '9457'::tvarchar);