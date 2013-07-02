-- Function: gpGet_Object_Branch(Integer,TVarChar)

--DROP FUNCTION gpGet_Object_Branch(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Branch(
    IN inId          Integer,       -- ключ объекта <Бизнесы>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, JuridicalId Integer, JuridicalName TVarChar) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
  
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (Object.ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
           , CAST (0 as Integer)    AS JuridicalId
           , CAST ('' as TVarChar)  AS JuridicalName
       FROM Object 
       WHERE Object.DescId = zc_Object_Branch();
   ELSE
       RETURN QUERY 
       SELECT 
             Object.Id
           , Object.ObjectCode
           , Object.ValueData
           , Object.isErased
           , Juridical.Id        AS JuridicalId
           , Juridical.ValueData AS JuridicalName
       FROM Object
            LEFT JOIN ObjectLink AS Branch_Juridical
                                 ON Branch_Juridical.ObjectId = Object.Id AND Branch_Juridical.DescId = zc_ObjectLink_Branch_Juridical()
            LEFT JOIN Object AS Juridical ON Juridical.Id = Branch_Juridical.ChildObjectId
      WHERE Object.Id = inId;
   END IF;
     
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Branch (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.06.13          *
 05.06.13           
*/

-- тест
-- SELECT * FROM gpGet_Object_Branch(1,'2')