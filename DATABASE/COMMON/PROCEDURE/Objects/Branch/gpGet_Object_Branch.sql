-- Function: gpGet_Object_Branch(Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Branch(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Branch(
    IN inId          Integer,       -- ключ объекта <Бизнесы>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , InvNumber TVarChar
             , PersonalBookkeeperId Integer, PersonalBookkeeperName TVarChar
             , isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
  
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode (0, zc_Object_Branch()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST ('' as TVarChar)  AS InvNumber
           , CAST (0 as Integer)    AS PersonalBookkeeperId
           , CAST ('' as TVarChar)  AS PersonalBookkeeperName
           
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Branch.Id
           , Object_Branch.ObjectCode
           , Object_Branch.ValueData

           , ObjectString_InvNumber.ValueData  AS InvNumber
           , Object_Personal_View.PersonalId    AS PersonalBookkeeperId
           , Object_Personal_View.PersonalName  AS PersonalBookkeeperName
      
           , Object_Branch.isErased
       FROM Object AS Object_Branch
            LEFT JOIN ObjectString AS ObjectString_InvNumber
                                   ON ObjectString_InvNumber.ObjectId = Object_Branch.Id
                                  AND ObjectString_InvNumber.DescId = zc_objectString_Branch_InvNumber()                                  

            LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalBookkeeper
                            ON ObjectLink_Branch_PersonalBookkeeper.ObjectId = Object_Branch.Id
                           AND ObjectLink_Branch_PersonalBookkeeper.DescId = zc_ObjectLink_Branch_PersonalBookkeeper()
            LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = ObjectLink_Branch_PersonalBookkeeper.ChildObjectId               
       
      WHERE Object_Branch.Id = inId;
   END IF;
     
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Branch (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.03.15         * add InvNumber, PersonalBookkeeper
 14.12.13                                        * Cyr1251
 10.06.13         *
 05.06.13           
 01.07.13                        * remove Juridical 
*/

-- тест
-- SELECT * FROM gpGet_Object_Branch(1,'2')