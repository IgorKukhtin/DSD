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
        Object.Id
      , Object.ObjectCode
      , Object.ValueData
      , Object.isErased
      , Juridical.Id        AS JuridicalId
      , Juridical.ValueData AS JuridicalName
      , MFO.ValueData       AS MFO
     FROM Object
LEFT JOIN ObjectLink AS Bank_Juridical
       ON Bank_Juridical.ObjectId = Object.Id AND Bank_Juridical.DescId = zc_ObjectLink_Bank_Juridical()
LEFT JOIN Object AS Juridical
       ON Juridical.Id = Bank_Juridical.ChildObjectId
LEFT JOIN ObjectSring AS MFO 
       ON MFO.ObjectId = Object.Id AND MFO.DescId = zc_ObjectString_Bank_MFO()
    WHERE Object.Id = inId;
  
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