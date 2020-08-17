-- Function: gpSelect_ScaleCeh_PersonalGroup()

DROP FUNCTION IF EXISTS gpSelect_ScaleCeh_PersonalGroup (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_ScaleCeh_PersonalGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ScaleCeh_PersonalGroup(
    IN inUnitId           Integer,
    IN inSession          TVarChar      -- сессия пользователя
)
RETURNS TABLE (PersonalGroupId   Integer
             , PersonalGroupCode Integer
             , PersonalGroupName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , isErased        Boolean
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
       SELECT Object_PersonalGroup.Id         AS PersonalGroupId
            , Object_PersonalGroup.ObjectCode AS PersonalGroupCode
            , Object_PersonalGroup.ValueData  AS PersonalGroupName
            , Object_Unit.Id          AS UnitId
            , Object_Unit.ObjectCode  AS UnitCode
            , Object_Unit.ValueData   AS UnitName
            , Object_PersonalGroup.isErased   AS isErased
       FROM Object AS Object_PersonalGroup
            LEFT JOIN ObjectLink AS ObjectLink_PersonalGroup_Unit
                                 ON ObjectLink_PersonalGroup_Unit.ObjectId = Object_PersonalGroup.Id
                                AND ObjectLink_PersonalGroup_Unit.DescId  = zc_ObjectLink_PersonalGroup_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_PersonalGroup_Unit.ChildObjectId
       WHERE Object_PersonalGroup.DescId = zc_Object_PersonalGroup()
         AND Object_PersonalGroup.ObjectCode <> 0
         AND Object_PersonalGroup.isErased = FALSE
         AND (ObjectLink_PersonalGroup_Unit.ChildObjectId = inUnitId OR inUnitId = 0)
       ORDER BY 3
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.08.20                                        *
*/

-- тест
-- SELECT * FROM gpSelect_ScaleCeh_PersonalGroup (inUnitId:= 0, inSession:=zfCalc_UserAdmin())
