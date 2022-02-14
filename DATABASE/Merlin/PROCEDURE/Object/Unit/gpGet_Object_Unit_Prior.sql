-- Function: gpGet_Object_Unit_Prior(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Unit_Prior (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Unit_Prior(
    IN inId          Integer,       -- Подразделения
    IN inSession     TVarChar       -- сессия пользователя
) 
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , GroupNameFull TVarChar, Phone TVarChar
             , Comment TVarChar
             , ParentId Integer, ParentName TVarChar
 ) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

  IF EXISTS(SELECT * FROM ObjectLink AS ObjectLink_Unit_Parent
            WHERE ObjectLink_Unit_Parent.ObjectId = inId
              AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
              AND COALESCE(ObjectLink_Unit_Parent.ChildObjectId, 0) <> 0)
  THEN
    SELECT COALESCE(ObjectLink_Unit_Parent.ChildObjectId, 0) 
    INTO inId
    FROM ObjectLink AS ObjectLink_Unit_Parent
    WHERE ObjectLink_Unit_Parent.ObjectId = inId
      AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent();

     RETURN QUERY
     SELECT 
           Object_Unit.Id                  AS Id
         , Object_Unit.ObjectCode          AS Code
         , Object_Unit.ValueData           AS Name
         , ObjectString_GroupNameFull.ValueData  AS GroupNameFull
         , ObjectString_Phone.ValueData    AS Phone
         , ObjectString_Comment.ValueData  AS Comment
         , Object_Parent.Id                AS ParentId
         , Object_Parent.ValueData         AS ParentName
     FROM Object AS Object_Unit
          LEFT JOIN ObjectString AS ObjectString_GroupNameFull
                                 ON ObjectString_GroupNameFull.ObjectId = Object_Unit.Id
                                AND ObjectString_GroupNameFull.DescId = zc_ObjectString_Unit_GroupNameFull()
          LEFT JOIN ObjectString AS ObjectString_Phone
                                 ON ObjectString_Phone.ObjectId = Object_Unit.Id
                                AND ObjectString_Phone.DescId = zc_ObjectString_Unit_Phone()
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_Unit.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_Unit_Comment()

          LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                               ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                              AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
          LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId
    WHERE Object_Unit.Id = inId;

  ELSE 

     RETURN QUERY
     SELECT 
           0                      AS Id
         , 0                      AS Code
         , ''::TVarChar           AS Name
         , ''::TVarChar           AS GroupNameFull
         , ''::TVarChar           AS Phone
         , ''::TVarChar           AS Comment
         , 0                      AS ParentId
         , ''::TVarChar           AS ParentName
     ;
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.02.22                                                       *
*/

-- тест
-- 
select * from gpGet_Object_Unit_Prior(inId := 52460 ,  inSession := '5');