-- Function: gpSelect_Object_PersonalByStorageLine()

DROP FUNCTION IF EXISTS gpSelect_Object_PersonalByStorageLine (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PersonalByStorageLine(
    IN inIsShowAll   Boolean,       --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , PositionId Integer, PositionCode Integer, PositionName TVarChar
             , PositionLevelId Integer, PositionLevelCode Integer, PositionLevelName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar   
             , StorageLineId Integer, StorageLineCode Integer, StorageLineName TVarChar                
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

         , Object_Personal_View.PersonalId
         , Object_Personal_View.PersonalCode
         , Object_Personal_View.PersonalName

         , Object_Personal_View.PositionId
         , Object_Personal_View.PositionCode
         , Object_Personal_View.PositionName

         , Object_Personal_View.PositionLevelId
         , Object_Personal_View.PositionLevelCode
         , Object_Personal_View.PositionLevelName

         , Object_Personal_View.UnitId
         , Object_Personal_View.UnitCode
         , Object_Personal_View.UnitName

         , Object_StorageLine.Id         AS StorageLineId
         , Object_StorageLine.ObjectCode AS StorageLineCode
         , Object_StorageLine.ValueData  AS StorageLineName

         , Object_PersonalByStorageLine.isErased AS isErased
       
     FROM Object AS Object_PersonalByStorageLine
          LEFT JOIN ObjectLink AS ObjectLink_PersonalByStorageLine_Personal
                               ON ObjectLink_PersonalByStorageLine_Personal.ObjectId = Object_PersonalByStorageLine.Id
                              AND ObjectLink_PersonalByStorageLine_Personal.DescId = zc_ObjectLink_PersonalByStorageLine_Personal()
          LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = ObjectLink_PersonalByStorageLine_Personal.ChildObjectId
                                
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