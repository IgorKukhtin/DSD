-- Function: gpGet_Object_Bank(Integer,TVarChar)

--DROP FUNCTION gpGet_Object_Bank(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Bank(
    IN inId          Integer,       -- ключ объекта <Банки>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               JuridicalId Integer, JuridicalName TVarChar, MFO TVarChar) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT
         Object_Bank.Id
       , Object_Bank.ObjectCode     AS Code
       , Object_Bank.ValueData      AS Name
       , Object_Bank.isErased 
       , Object_Juridical.Id        AS JuridicalId
       , Object_Juridical.ValueData AS JuridicalName
       , ObjectString_MFO.ValueData AS MFO
   FROM Object AS Object_Bank
        LEFT JOIN ObjectLink AS ObjectLink_Bank_Juridical
                 ON ObjectLink_Bank_Juridical.ObjectId = Object_Bank.Id
                AND ObjectLink_Bank_Juridical.DescId = zc_ObjectLink_Bank_Juridical()
        LEFT JOIN ObjectString AS ObjectString_MFO
                 ON ObjectString_MFO.ObjectId = Object_Bank.Id
                AND ObjectString_MFO.DescId = zc_ObjectString_Bank_MFO()
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Bank_Juridical.ChildObjectId
   WHERE Object_Bank.Id = inId;
     
 
END;$BODY$

  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_Bank(integer, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_User('2')

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.06.13          

*/

-- тест
-- SELECT * FROM  gpGet_Object_Bank (2, '')