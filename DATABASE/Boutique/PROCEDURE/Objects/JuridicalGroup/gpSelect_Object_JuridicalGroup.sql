-- Function: gpSelect_Object_JuridicalGroup (Bolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_JuridicalGroup (Bolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_JuridicalGroup(
    IN inIsShowAll   Boolean,       -- признак показать удаленные да / нет 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, JuridicalGroupName TVarChar, isErased boolean) 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_JuridicalGroup());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     -- vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_JuridicalGroup.Id               AS Id
           , Object_JuridicalGroup.ObjectCode       AS Code
           , Object_JuridicalGroup.ValueData        AS Name
           , Object_Parent.ValueData                AS JuridicalGroupName
           , Object_JuridicalGroup.isErased         AS isErased
           
       FROM Object AS Object_JuridicalGroup
            LEFT JOIN ObjectLink AS ObjectLink_JuridicalGroup_Parent
                                 ON ObjectLink_JuridicalGroup_Parent.ObjectId = Object_JuridicalGroup.Id
                                AND ObjectLink_JuridicalGroup_Parent.DescId = zc_ObjectLink_JuridicalGroup_Parent()
            LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_JuridicalGroup_Parent.ChildObjectId

     WHERE Object_JuridicalGroup.DescId = zc_Object_JuridicalGroup()
              AND (Object_JuridicalGroup.isErased = FALSE OR inIsShowAll = TRUE)

    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыкин А.А.
27.02.17                                                            *

        
*/

-- тест
-- SELECT * FROM gpSelect_Object_JuridicalGroup (TRUE, zfCalc_UserAdmin())