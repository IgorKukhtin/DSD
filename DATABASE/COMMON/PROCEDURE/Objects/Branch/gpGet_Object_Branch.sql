-- Function: gpGet_Object_Branch(Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Branch(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Branch(
    IN inId          Integer,       -- ключ объекта <Бизнесы>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , InvNumber TVarChar
             , PersonalBookkeeperId Integer, PersonalBookkeeperName TVarChar
             , UnitId Integer, UnitName TVarChar
             , UnitReturnId Integer, UnitReturnName TVarChar
             , IsMedoc boolean, IsPartionDoc boolean
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
           
           , CAST ('' as TVarChar)   AS InvNumber
           , CAST (0 as Integer)     AS PersonalBookkeeperId
           , CAST ('' as TVarChar)   AS PersonalBookkeeperName

           , CAST (0 as Integer)     AS UnitId
           , CAST ('' as TVarChar)   AS UnitName
 
           , CAST (0 as Integer)     AS UnitReturnId
           , CAST ('' as TVarChar)   AS UnitReturnName

           , CAST (False AS Boolean) AS IsMedoc
           , CAST (False AS Boolean) AS IsPartionDoc
           , CAST (NULL AS Boolean)  AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Branch.Id
           , Object_Branch.ObjectCode
           , Object_Branch.ValueData

           , ObjectString_InvNumber.ValueData  AS InvNumber
           , Object_Personal_View.PersonalId    AS PersonalBookkeeperId
           , Object_Personal_View.PersonalName  AS PersonalBookkeeperName

           , Object_Unit.Id         AS UnitId
           , Object_Unit.ValueData  AS UnitName

           , Object_UnitReturn.Id         AS UnitReturnId
           , Object_UnitReturn.ValueData  AS UnitReturnName

           , COALESCE (ObjectBoolean_Medoc.ValueData, False)      AS IsMedoc     
           , COALESCE (ObjectBoolean_PartionDoc.ValueData, False) AS IsPartionDoc 
           , Object_Branch.isErased
   
       FROM Object AS Object_Branch
            LEFT JOIN ObjectString AS ObjectString_InvNumber
                                   ON ObjectString_InvNumber.ObjectId = Object_Branch.Id
                                  AND ObjectString_InvNumber.DescId = zc_objectString_Branch_InvNumber()                                  

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Medoc
                                    ON ObjectBoolean_Medoc.ObjectId = Object_Branch.Id
                                   AND ObjectBoolean_Medoc.DescId = zc_ObjectBoolean_Branch_Medoc()   

            LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDoc
                                    ON ObjectBoolean_PartionDoc.ObjectId = Object_Branch.Id
                                   AND ObjectBoolean_PartionDoc.DescId = zc_ObjectBoolean_Branch_PartionDoc() 

            LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalBookkeeper
                            ON ObjectLink_Branch_PersonalBookkeeper.ObjectId = Object_Branch.Id
                           AND ObjectLink_Branch_PersonalBookkeeper.DescId = zc_ObjectLink_Branch_PersonalBookkeeper()
            LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = ObjectLink_Branch_PersonalBookkeeper.ChildObjectId               
       
            LEFT JOIN ObjectLink AS ObjectLink_Branch_Unit
                                 ON ObjectLink_Branch_Unit.ObjectId = Object_Branch.Id
                                AND ObjectLink_Branch_Unit.DescId = zc_ObjectLink_Branch_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Branch_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Branch_UnitReturn
                                 ON ObjectLink_Branch_UnitReturn.ObjectId = Object_Branch.Id
                                AND ObjectLink_Branch_UnitReturn.DescId = zc_ObjectLink_Branch_UnitReturn()
            LEFT JOIN Object AS Object_UnitReturn ON Object_UnitReturn.Id = ObjectLink_Branch_UnitReturn.ChildObjectId

      WHERE Object_Branch.Id = inId;
   END IF;
     
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Branch (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.12.15         * add Unit, UnitReturn
 17.04.15         * add IsMedoc
 18.03.15         * add InvNumber, PersonalBookkeeper
 14.12.13                                        * Cyr1251
 10.06.13         *
 05.06.13           
 01.07.13                        * remove Juridical 
*/

-- тест
-- SELECT * FROM gpGet_Object_Branch(1,'2')