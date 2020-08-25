-- Function: gpSelect_Object_Composition (Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Composition (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Composition(
    IN inIsShowAll   Boolean,       --  признак показать удаленные да / нет 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Name_UKR TVarChar
             , CompositionGroupId Integer, CompositionGroupName TVarChar
             , isErased boolean) 
  AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Composition());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     -- vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_Composition.Id               AS Id
           , Object_Composition.ObjectCode       AS Code
           , Object_Composition.ValueData        AS Name
           , COALESCE (ObjectString_UKR.ValueData, NULL) :: TVarChar AS Name_UKR
           , Object_CompositionGroup.Id          AS CompositionGroupId
           , Object_CompositionGroup.ValueData   AS CompositionGroupName
           , Object_Composition.isErased         AS isErased
           
       FROM Object AS Object_Composition
            LEFT JOIN ObjectLink AS ObjectLink_Composition_CompositionGroup
                                ON ObjectLink_Composition_CompositionGroup.ObjectId = Object_Composition.Id
                               AND ObjectLink_Composition_CompositionGroup.DescId = zc_ObjectLink_Composition_CompositionGroup()
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = ObjectLink_Composition_CompositionGroup.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_UKR
                                   ON ObjectString_UKR.ObjectId = Object_Composition.Id
                                  AND ObjectString_UKR.DescId = zc_ObjectString_Composition_UKR()

     WHERE Object_Composition.DescId = zc_Object_Composition()
              AND (Object_Composition.isErased = FALSE OR inIsShowAll = TRUE)

    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыкин А.А.
25.08.20          *
20.02.17                                                           *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Composition (TRUE, zfCalc_UserAdmin())