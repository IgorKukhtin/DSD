-- Function: gpSelect_Object_Unit (Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Unit (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit(
    IN inIsShowAll   Boolean,       -- признак показать удаленные да / нет
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
             Object_Unit.Id                  AS Id
           , Object_Unit.ObjectCode          AS Code
           , Object_Unit.ValueData           AS Name
           , TRIM (COALESCE (ObjectString_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS NameFull
           , ObjectString_Phone.ValueData    AS Phone
           , ObjectString_GroupNameFull.ValueData AS GroupNameFull
           , ObjectString_Comment.ValueData  AS Comment
           , COALESCE (Object_Parent.Id,0)   AS ParentId
           , Object_Parent.ValueData         AS ParentName

           , Object_Insert.ValueData         AS InsertName
           , ObjectDate_Insert.ValueData     AS InsertDate
           , Object_Update.ValueData         AS UpdateName
           , ObjectDate_Update.ValueData     AS UpdateDate
           
           , COALESCE (ObjectBoolean_isLeaf.ValueData,TRUE) ::Boolean  AS isLeaf
           , Object_Unit.isErased            AS isErased

       FROM Object AS Object_Unit

            LEFT JOIN ObjectString AS ObjectString_Phone
                                   ON ObjectString_Phone.ObjectId = Object_Unit.Id
                                  AND ObjectString_Phone.DescId = zc_ObjectString_Unit_Phone()
            LEFT JOIN ObjectString AS ObjectString_GroupNameFull
                                   ON ObjectString_GroupNameFull.ObjectId = Object_Unit.Id
                                  AND ObjectString_GroupNameFull.DescId = zc_ObjectString_Unit_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_Unit.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_Unit_Comment()

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                 ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
            LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_isLeaf 
                                    ON ObjectBoolean_isLeaf.ObjectId = Object_Unit.Id
                                   AND ObjectBoolean_isLeaf.DescId = zc_ObjectBoolean_isLeaf()

            LEFT JOIN ObjectLink AS ObjectLink_Insert
                                 ON ObjectLink_Insert.ObjectId = Object_Unit.Id
                                AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_Insert
                                 ON ObjectDate_Insert.ObjectId = Object_Unit.Id
                                AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

            LEFT JOIN ObjectLink AS ObjectLink_Update
                                 ON ObjectLink_Update.ObjectId = Object_Unit.Id
                                AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_Update
                                 ON ObjectDate_Update.ObjectId = Object_Unit.Id
                                AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()

     WHERE Object_Unit.DescId = zc_Object_Unit()
       AND (Object_Unit.isErased = FALSE OR inIsShowAll = TRUE)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.05.22         *
 11.01.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Unit (TRUE, zfCalc_UserAdmin())
