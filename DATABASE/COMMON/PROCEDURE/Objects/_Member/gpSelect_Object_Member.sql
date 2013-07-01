-- Function: gpSelect_Object_Member(TVarChar)

--DROP FUNCTION gpSelect_Object_Member(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Member(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, INN TVarChar, isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Member());

   RETURN QUERY 
     SELECT 
           Object_Member.Id             AS Id
         , Object_Member.ObjectCode     AS Code
         , Object_Member.ValueData      AS Name
         
         , ObjectString_INN.ValueData   AS INN
         , Object_Member.isErased       AS isErased
         
     FROM OBJECT AS Object_Member
          LEFT JOIN ObjectString AS ObjectString_INN ON ObjectString_INN.ObjectId = Object_Member.Id 
                AND ObjectString_INN.DescId = zc_ObjectString_Member_INN()
      
     WHERE Object_Member.DescId = zc_Object_Member();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Member(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.07.13          *              

*/

-- тест
-- SELECT * FROM gpSelect_Object_Member('2')