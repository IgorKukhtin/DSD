-- Function: gpGet_Object_Unit()

--DROP FUNCTION gpGet_Object_Unit(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Unit(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               ParentId Integer, ParentName TVarChar, 
               JuridicalId Integer, JuridicalName TVarChar) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

     RETURN QUERY 
     SELECT 
           Object.Id                  AS Id
         , Object.ObjectCode          AS Code
         , Object.ValueData           AS Name
         , Object.isErased            AS isErased
         , Parent.Id                  AS ParentId
         , Parent.ValueData           AS ParentName 
         , Juridical.Id               AS JuridicalId
         , Juridical.ValueData        AS JuridicalName
     FROM Object
LEFT JOIN ObjectLink AS Unit_Parent
       ON Unit_Parent.ObjectId = Object.Id
      AND Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
LEFT JOIN Object AS Parent
       ON Parent.Id = Unit_Parent.ChildObjectId
LEFT JOIN ObjectLink AS Unit_Juridical
       ON Unit_Juridical.ObjectId = Object.Id
      AND Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
LEFT JOIN Object AS Juridical
       ON Juridical.Id = Unit_Juridical.ChildObjectId
    WHERE Object.Id = inId;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Unit(integer, TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.06.13                        *

*/

-- тест
-- SELECT * FROM gpSelect_Unit('2')