-- Function: gpSelect_Object_Unit_StaffList()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit_StaffList (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_StaffList(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, 
               ParentId Integer, ParentCode Integer, ParentName TVarChar,
               BranchId Integer, BranchCode Integer, BranchName TVarChar,
               isErased Boolean
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
    SELECT Object_Unit.Id           AS Id
         , Object_Unit.ObjectCode   AS Code
         , Object_Unit.ValueData    AS Name

         , Object_Parent.Id         AS ParentId
         , Object_Parent.ObjectCode AS ParentCode
         , Object_Parent.ValueData  AS ParentName 

         , Object_Branch.Id         AS BranchId
         , Object_Branch.ObjectCode AS BranchCode
         , Object_Branch.ValueData  AS BranchName

         , Object_Unit.isErased     AS isErased
    FROM (SELECT * 
           FROM Object 
           WHERE Object.DescId = zc_Object_Unit() 
             AND Object.Id IN (8017753, 12640072, 12640073, 3377424, 3377419, 954062) 
          ) AS Object_Unit
         LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                              ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                             AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
         LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId
 
         LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                              ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                             AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
         LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
    ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.04.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Unit_StaffList (zfCalc_UserAdmin())
