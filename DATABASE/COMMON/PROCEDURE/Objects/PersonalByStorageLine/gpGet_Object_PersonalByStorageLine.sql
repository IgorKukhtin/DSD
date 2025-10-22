-- Function: gpGet_Object_PersonalByStorageLine(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_PersonalByStorageLine (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PersonalByStorageLine(
    IN inId          Integer,       -- Составляющие рецептур 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , PersonalId Integer, PersonalName TVarChar                
             , StorageLineId Integer, StorageLineName TVarChar                
               ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_PersonalByStorageLine());
  
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
            
           , CAST (0 as Integer)   AS PersonalId
           , CAST ('' as TVarChar) AS PersonalName

           , CAST (0 as Integer)   AS StorageLineId
           , CAST ('' as TVarChar) AS StorageLineName
       ;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_PersonalByStorageLine.Id         AS Id
         
         , Object_Personal.Id          AS PersonalId
         , Object_Personal.ValueData   AS PersonalName

         , Object_StorageLine.Id         AS StorageLineId
         , Object_StorageLine.ValueData  AS StorageLineName

     FROM Object AS Object_PersonalByStorageLine
          LEFT JOIN ObjectLink AS ObjectLink_PersonalByStorageLine_Personal
                               ON ObjectLink_PersonalByStorageLine_Personal.ObjectId = Object_PersonalByStorageLine.Id
                              AND ObjectLink_PersonalByStorageLine_Personal.DescId = zc_ObjectLink_PersonalByStorageLine_Personal()
          LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_PersonalByStorageLine_Personal.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_PersonalByStorageLine_StorageLine
                               ON ObjectLink_PersonalByStorageLine_StorageLine.ObjectId = Object_PersonalByStorageLine.Id
                              AND ObjectLink_PersonalByStorageLine_StorageLine.DescId = zc_ObjectLink_PersonalByStorageLine_StorageLine()
          LEFT JOIN Object AS Object_StorageLine ON Object_StorageLine.Id = ObjectLink_PersonalByStorageLine_StorageLine.ChildObjectId
                               
     WHERE Object_PersonalByStorageLine.Id = inId
       AND Object_PersonalByStorageLine.DescId = zc_Object_PersonalByStorageLine();
     
  END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.10.25         *
*/

-- тест
-- SELECT * FROM gpGet_Object_PersonalByStorageLine (100, '2')