-- Function: gpSelect_Object_PersonalByStorageLine()

DROP FUNCTION IF EXISTS gpSelect_Object_PersonalByStorageLine_Personal (Integer,Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PersonalByStorageLine_Personal(
    IN inPersonalId  Integer,
    IN inIsShowAll   Boolean,       --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , PersonalId Integer
             , StorageLineId Integer, StorageLineCode Integer, StorageLineName TVarChar
             , Ord Integer                
             , isErased boolean
             ) AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_PersonalByStorageLine());
     vbUserId:= lpGetUserBySession (inSession);
 

   RETURN QUERY 
     SELECT 
           Object_PersonalByStorageLine.Id  AS Id

         , ObjectLink_PersonalByStorageLine_Personal.ChildObjectId AS PersonalId

         , Object_StorageLine.Id         AS StorageLineId
         , Object_StorageLine.ObjectCode AS StorageLineCode
         , Object_StorageLine.ValueData  AS StorageLineName 
         
         , ROW_NUMBER() OVER (ORDER BY Object_PersonalByStorageLine.Id) ::Integer AS Ord

         , Object_PersonalByStorageLine.isErased AS isErased
       
     FROM Object AS Object_PersonalByStorageLine
          INNER JOIN ObjectLink AS ObjectLink_PersonalByStorageLine_Personal
                                ON ObjectLink_PersonalByStorageLine_Personal.ObjectId = Object_PersonalByStorageLine.Id
                               AND ObjectLink_PersonalByStorageLine_Personal.DescId = zc_ObjectLink_PersonalByStorageLine_Personal()
                               AND (ObjectLink_PersonalByStorageLine_Personal.ChildObjectId = inPersonalId OR inPersonalId = 0)
                                
          LEFT JOIN ObjectLink AS ObjectLink_PersonalByStorageLine_StorageLine
                               ON ObjectLink_PersonalByStorageLine_StorageLine.ObjectId = Object_PersonalByStorageLine.Id
                              AND ObjectLink_PersonalByStorageLine_StorageLine.DescId = zc_ObjectLink_PersonalByStorageLine_StorageLine()
          LEFT JOIN Object AS Object_StorageLine ON Object_StorageLine.Id = ObjectLink_PersonalByStorageLine_StorageLine.ChildObjectId

     WHERE Object_PersonalByStorageLine.DescId = zc_Object_PersonalByStorageLine()
      AND (Object_PersonalByStorageLine.isErased = False OR inIsShowAll = True)
     ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.10.25         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PersonalByStorageLine ( False, '2')