-- Function: gpSelect_Object_Unit (Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Unit (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit(
    IN inIsShowAll   Boolean,       -- признак показать удаленные да / нет
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Address TVarChar, Phone TVarChar
             , Comment TVarChar
             , JuridicalName TVarChar, ParentName TVarChar, ChildName TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
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
           , ObjectString_Address.ValueData  AS Address
           , ObjectString_Phone.ValueData    AS Phone
           , ObjectString_Comment.ValueData  AS Comment
           , Object_Juridical.ValueData      AS JuridicalName
           , Object_Parent.ValueData         AS ParentName
           , Object_Child.ValueData          AS ChildName

           , Object_Insert.ValueData         AS InsertName
           , ObjectDate_Insert.ValueData     AS InsertDate

           , Object_Unit.isErased            AS isErased

       FROM Object AS Object_Unit
            LEFT JOIN ObjectString AS ObjectString_Address
                                   ON ObjectString_Address.ObjectId = Object_Unit.Id
                                  AND ObjectString_Address.DescId = zc_ObjectString_Unit_Address()
            LEFT JOIN ObjectString AS ObjectString_Phone
                                   ON ObjectString_Phone.ObjectId = Object_Unit.Id
                                  AND ObjectString_Phone.DescId = zc_ObjectString_Unit_Phone()
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_Unit.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_Unit_Comment()

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                 ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
            LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Child
                                 ON ObjectLink_Unit_Child.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Child.DescId = zc_ObjectLink_Unit_Child()
            LEFT JOIN Object AS Object_Child ON Object_Child.Id = ObjectLink_Unit_Child.ChildObjectId


            LEFT JOIN ObjectLink AS ObjectLink_Insert
                                 ON ObjectLink_Insert.ObjectId = Object_Unit.Id
                                AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_Insert
                                 ON ObjectDate_Insert.ObjectId = Object_Unit.Id
                                AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

     WHERE Object_Unit.DescId = zc_Object_Unit()
       AND (Object_Unit.isErased = FALSE OR inIsShowAll = TRUE)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.10.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Unit (TRUE, zfCalc_UserAdmin())



