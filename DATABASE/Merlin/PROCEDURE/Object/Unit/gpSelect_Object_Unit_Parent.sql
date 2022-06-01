-- Function: gpSelect_Object_Unit (Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Unit_Parent (Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_Parent(
    IN inIsShowAll   Boolean,       -- признак показать удаленные да / нет   
    IN inisLeaf      Boolean ,      -- показывать или нет только группы
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, NameFull TVarChar
             , Phone TVarChar, GroupNameFull TVarChar
             , Comment TVarChar
             , ParentId Integer, ParentName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             , isLeaf Boolean
             , isErased boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Unit());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY

       SELECT
             Object_Unit.Id
           , Object_Unit.Code
           , Object_Unit.Name
           , Object_Unit.NameFull ::TVarChar
           , Object_Unit.Phone
           , Object_Unit.GroupNameFull
           , Object_Unit.Comment
           , Object_Unit.ParentId
           , Object_Unit.ParentName

           , Object_Unit.InsertName
           , Object_Unit.InsertDate
           , Object_Unit.UpdateName
           , Object_Unit.UpdateDate
           
           , Object_Unit.isLeaf
           , Object_Unit.isErased

       FROM gpSelect_Object_Unit (inIsShowAll, inSession) AS Object_Unit
       WHERE Object_Unit.Id IN (SELECT DISTINCT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Unit_Parent())
          OR inisLeaf = TRUE   --только "Группы"   или все 
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.06.22         *
 26.05.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Unit_Parent (TRUE, false, zfCalc_UserAdmin())
