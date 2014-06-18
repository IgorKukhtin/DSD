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
       Object_Bank_View.Id
     , Object_Bank_View.Code
     , Object_Bank_View.BankName
     , Object_Bank_View.MFO
     , Object_Bank_View.isErased
     FROM Object_Bank_View;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Bank (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 17.06.14                         *
 19.02.14                                        *
 10.06.13          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Bank('2')
