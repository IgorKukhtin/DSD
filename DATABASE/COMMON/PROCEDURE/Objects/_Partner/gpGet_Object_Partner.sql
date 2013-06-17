-- Function: gpGet_Object_Partner()

--DROP FUNCTION gpGet_Object_Partner();

CREATE OR REPLACE FUNCTION gpGet_Object_Partner(
    IN inId          Integer,        -- Касса 
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, GLNCode TVarChar,
               JuridicalName TVarChar, JuridicalId Integer) AS
$BODY$BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Partner());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , MAX (Object.ObjectCode) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
           , CAST ('' as TVarChar)  AS GLNCode
           , CAST ('' as TVarChar)  AS JuridicalName
           , CAST (0 as Integer)    AS JuridicalId
       FROM Object 
       WHERE Object.DescId = zc_Object_Partner();
   ELSE
       RETURN QUERY 
       SELECT 
             Object.Id              AS Id
           , Object.ObjectCode      AS Code
           , Object.ValueData       AS Name
           , Object.isErased        AS isErased
           , Partner_GLNCode.ValueData AS GLNCode
           , Juridical.ValueData    AS JuridicalName
           , Juridical.Id           AS JuridicalId
       FROM Object
  LEFT JOIN ObjectString AS Partner_GLNCode 
         ON Partner_GLNCode.ObjectId = Object.Id AND Partner_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()
  LEFT JOIN ObjectLink AS Partner_Juridical
         ON Partner_Juridical.ObjectId = Object.Id AND Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
  LEFT JOIN Object AS Juridical
         ON Juridical.Id = Partner_Juridical.ChildObjectId
       WHERE Object.Id = inId;
   END IF;
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Partner(integer, TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.06.13          *
 00.06.13          

*/

-- тест
-- SELECT * FROM gpSelect_Partner('2')