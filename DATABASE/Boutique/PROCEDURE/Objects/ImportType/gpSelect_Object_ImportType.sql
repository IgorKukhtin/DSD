-- Function: gpSelect_Object_ImportType()

DROP FUNCTION IF EXISTS gpSelect_Object_ImportType(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ImportType(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ProcedureName TVarChar, EnumName TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ImportType());

   RETURN QUERY 
       SELECT 
             Object_ImportType.Id           AS Id
           , Object_ImportType.ObjectCode   AS Code
           , Object_ImportType.ValueData    AS Name
         
           , ObjectString_ProcedureName.ValueData AS ProcedureName
           , ObjectString_EnumName.ValueData      AS EnumName
           
           , Object_ImportType.isErased           AS isErased

       FROM Object AS Object_ImportType
           LEFT JOIN ObjectString AS ObjectString_ProcedureName 
                                  ON ObjectString_ProcedureName.ObjectId = Object_ImportType.Id
                                 AND ObjectString_ProcedureName.DescId = zc_ObjectString_ImportType_ProcedureName()
           LEFT JOIN ObjectString AS ObjectString_EnumName
                                  ON ObjectString_EnumName.ObjectId = Object_ImportType.Id
                                 AND ObjectString_EnumName.DescId = zc_ObjectString_Enum()
       WHERE Object_ImportType.DescId = zc_Object_ImportType();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ImportType(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Подмогильный В.В.
 29.03.19         *
 09.02.18                                                           *               
 02.07.14         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ImportType ('2')
