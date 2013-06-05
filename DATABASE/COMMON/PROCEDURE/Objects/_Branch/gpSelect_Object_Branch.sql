-- Function: gpSelect_Object_Branch(TVarChar)

--DROP FUNCTION gpSelect_Object_Branch(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Branch(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, JuridicalName TVarChar) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY 
     SELECT 
       Object.Id
     , Object.ObjectCode
     , Object.ValueData
     , Object.isErased
     , Juridical.ValueData AS JuridicalName
     FROM Object
LEFT JOIN ObjectLink AS Branch_Juridical
       ON Branch_Juridical.ObjectId = Object.Id AND Branch_Juridical.DescId = zc_ObjectLink_Branch_Juridical()
LEFT JOIN Object AS Juridical
       ON Juridical.Id = Branch_Juridical.ChildObjectId
    WHERE Object.DescId = zc_Object_Branch();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Object_Branch(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.06.13          

*/

-- тест
-- SELECT * FROM gpSelect_Object_Branch('2')