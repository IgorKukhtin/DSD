-- Function: gpSelect_Object_PersonalGroup(TVarChar)

--DROP FUNCTION IF EXISTSgpSelect_Object_PersonalGroup(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_PersonalGroup(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PersonalGroup(
    IN inUnitId      Integer ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , WorkHours TFloat
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , isErased boolean
             ) AS
$BODY$BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_PersonalGroup());

     RETURN QUERY
       SELECT
             Object_PersonalGroup.Id          AS Id
           , Object_PersonalGroup.ObjectCode  AS Code
           , Object_PersonalGroup.ValueData   AS Name

           , ObjectFloat_WorkHours.ValueData  AS WorkHours

           , Object_Unit.Id          AS UnitId
           , Object_Unit.ObjectCode  AS UnitCode
           , Object_Unit.ValueData   AS UnitName

           , Object_PersonalGroup.isErased AS isErased

       FROM Object AS Object_PersonalGroup
            LEFT JOIN ObjectLink AS ObjectLink_PersonalGroup_Unit
                                 ON ObjectLink_PersonalGroup_Unit.ObjectId = Object_PersonalGroup.Id
                                AND ObjectLink_PersonalGroup_Unit.DescId = zc_ObjectLink_PersonalGroup_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_PersonalGroup_Unit.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_WorkHours
                                  ON ObjectFloat_WorkHours.ObjectId = Object_PersonalGroup.Id
                                 AND ObjectFloat_WorkHours.DescId = zc_ObjectFloat_PersonalGroup_WorkHours()
       WHERE Object_PersonalGroup.DescId = zc_Object_PersonalGroup()
         AND (COALESCE (ObjectLink_PersonalGroup_Unit.ChildObjectId,0) = inUnitId OR inUnitId = 0)

      UNION
              -- Удалить
       SELECT 0 :: Integer                    AS Id
            , 0 :: Integer                    AS Code
            , 'Очистить значение' ::TVarChar  AS Name

           , 0 :: TFloat  AS WorkHours

           , 0  :: Integer          AS UnitId
           , 0  :: Integer  AS UnitCode
           , '' ::TVarChar   AS UnitName
            , TRUE  :: Boolean AS isErased
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.09.13         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_PersonalGroup(8385,'2')