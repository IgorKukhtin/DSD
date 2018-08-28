-- Function: gpGet_Object_Overdraft (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Overdraft (Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Overdraft(
    IN inId          Integer,        --
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Education());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Overdraft()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
     RETURN QUERY
     SELECT
           Object_Overdraft.Id             AS Id
         , Object_Overdraft.ObjectCode     AS Code
         , Object_Overdraft.ValueData      AS Name
         , Object_Overdraft.isErased       AS isErased
     FROM OBJECT AS Object_Overdraft
     WHERE Object_Overdraft.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Overdraft(integer, TVarChar) OWNER TO postgres;


------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 27.08.18         *

*/

-- тест
-- SELECT * FROM gpGet_Object_Overdraft(0, '3')