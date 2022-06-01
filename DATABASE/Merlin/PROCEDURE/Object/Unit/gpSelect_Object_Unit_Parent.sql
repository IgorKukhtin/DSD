-- Function: gpSelect_Object_Unit_Parent (Integer, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Unit_Parent (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_Parent(
    IN inParentId    Integer,       -- Подразделения владельца
    IN inIsShowAll   Boolean,       -- признак показать удаленные да / нет
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Phone TVarChar, GroupNameFull TVarChar
             , Comment TVarChar
             , ParentId Integer, ParentName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             , isPositionFixed Boolean, Left Integer, Top Integer, Width Integer, Height Integer
             , isRootTree Boolean, isLetterTree Boolean, Color Integer, Color_Text Integer 
             , isErased boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbStartId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Unit());
     vbUserId:= lpGetUserBySession (inSession);
     vbStartId := (SELECT tmp.ID FROM gpGet_Object_Unit_Start (0, inSession) AS tmp);  

     
     IF EXISTS(SELECT * FROM ObjectLink AS ObjectLink_Unit_Parent
               WHERE ObjectLink_Unit_Parent.ChildObjectId = inParentId
                 AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent())
     THEN
       vbId := 0;
     ELSE
       vbId := inParentId;
     END IF;
  
     -- Результат
     RETURN QUERY
     WITH tmpUnitAll AS (SELECT Object_Unit.Id                  AS Id
                              , COALESCE (Object_Parent.Id,0)   AS ParentId

                         FROM Object AS Object_Unit

                              LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                                   ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                                  AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                              LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId

                         WHERE Object_Unit.DescId = zc_Object_Unit()
                         )
        , tmpUnitLast AS (SELECT tmpUnitAll.Id                  AS Id
                          FROM tmpUnitAll
                          WHERE tmpUnitAll.ID not in (SELECT tmpUnitAll.ParentId FROM tmpUnitAll))
     
     
     
       SELECT
             Object_Unit.Id                  AS Id
           , Object_Unit.ObjectCode          AS Code
           , (Object_Unit.ValueData||chr(13)||'Н:0'||chr(13)||'О:0'||chr(13)||'Д:0')::TVarChar AS Name
           , ObjectString_Phone.ValueData    AS Phone
           , ObjectString_GroupNameFull.ValueData AS GroupNameFull
           , ObjectString_Comment.ValueData  AS Comment
           , COALESCE (Object_Parent.Id,0)   AS ParentId
           , Object_Parent.ValueData         AS ParentName

           , Object_Insert.ValueData         AS InsertName
           , ObjectDate_Insert.ValueData     AS InsertDate
           , Object_Update.ValueData         AS UpdateName
           , ObjectDate_Update.ValueData     AS UpdateDate
           
           , COALESCE(ObjectBoolean_PositionFixed.ValueData, FALSE) AS isPositionFixed
           , ObjectFloat_Left.ValueData::Integer   AS Left
           , ObjectFloat_Top.ValueData::Integer    AS Top
           , ObjectFloat_Width.ValueData::Integer  AS Width
           , ObjectFloat_Height.ValueData::Integer AS Height
           
           , COALESCE (Object_Parent.Id,0) = vbStartId AS isRootTree 
           , COALESCE (tmpUnitLast.Id, 0) > 0          AS isLetterTree 

           , zc_Color_Yelow()                          AS Color       
           , zc_Color_Blue()                           AS Color_Text 
           
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

            LEFT JOIN ObjectBoolean AS ObjectBoolean_PositionFixed
                                    ON ObjectBoolean_PositionFixed.ObjectId = Object_Unit.Id
                                   AND ObjectBoolean_PositionFixed.DescId = zc_ObjectBoolean_Unit_PositionFixed()

            LEFT JOIN ObjectFloat AS ObjectFloat_Left
                                  ON ObjectFloat_Left.ObjectId = Object_Unit.Id
                                 AND ObjectFloat_Left.DescId = zc_ObjectFloat_Unit_Left()
            LEFT JOIN ObjectFloat AS ObjectFloat_Top
                                  ON ObjectFloat_Top.ObjectId = Object_Unit.Id
                                 AND ObjectFloat_Top.DescId = zc_ObjectFloat_Unit_Top()
            LEFT JOIN ObjectFloat AS ObjectFloat_Width
                                  ON ObjectFloat_Width.ObjectId = Object_Unit.Id
                                 AND ObjectFloat_Width.DescId = zc_ObjectFloat_Unit_Width()
            LEFT JOIN ObjectFloat AS ObjectFloat_Height
                                  ON ObjectFloat_Height.ObjectId = Object_Unit.Id
                                 AND ObjectFloat_Height.DescId = zc_ObjectFloat_Unit_Height()
                                 
            LEFT JOIN tmpUnitLast ON tmpUnitLast.Id = Object_Unit.Id

     WHERE Object_Unit.DescId = zc_Object_Unit()
       AND (Object_Unit.isErased = FALSE OR inIsShowAll = TRUE)
       AND (COALESCE (Object_Parent.Id, 0) = COALESCE (inParentId, 0) OR Object_Unit.Id = vbId)
     ORDER BY Object_Unit.ObjectCode
       
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.02.22                                                       *
*/

-- тест
--            SELECT * FROM gpSelect_Object_Unit_byParent (52460, FALSE, zfCalc_UserAdmin())