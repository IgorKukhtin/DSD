-- Function: gpSelect_Object_Bank(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Bank(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Bank(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, MFO TVarChar, isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY 
     SELECT 
       Object.Id
     , Object.ObjectCode
     , Object.ValueData
     , ObjectString_MFO.ValueData AS MFO
     , Object.isErased
     FROM Object
        LEFT JOIN ObjectString AS ObjectString_MFO
                 ON ObjectString_MFO.ObjectId = Object.Id
                AND ObjectString_MFO.DescId = zc_ObjectString_Bank_MFO()
     WHERE Object.DescId = zc_Object_Bank();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Bank (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 19.02.14                                        *
 10.06.13          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Bank('2')
