-- Function: gpSelect_Object_Unit_byReportBadm()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit_byReportBadm(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_byReportBadm(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,  ParentName TVarChar
             , NumUnit integer
             , isErased Boolean
) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

   RETURN QUERY 
    SELECT 
        Object_Unit.Id                                     AS Id
      , Object_Unit.ObjectCode                             AS Code
      , Object_Unit.ValueData                              AS Name
      , Object_Parent.ValueData                            AS ParentName
      , ROW_NUMBER() OVER (ORDER BY Object_Unit.Id)  ::integer      AS NumUnit
      , Object_Unit.isErased

    FROM ObjectBoolean AS ObjectBoolean_UploadBadm
        LEFT JOIN Object AS Object_Unit
                         ON Object_Unit.Id = ObjectBoolean_UploadBadm.ObjectId
                        AND  Object_Unit.DescId = zc_Object_Unit()
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                             ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
        LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId
    WHERE ObjectBoolean_UploadBadm.DescId = zc_ObjectBoolean_Unit_UploadBadm()
      AND ObjectBoolean_UploadBadm.ValueData = TRUE;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.01.17         * add isUploadBadm
*/

-- тест
-- SELECT * FROM gpSelect_Object_Unit_byReportBadm ('2')