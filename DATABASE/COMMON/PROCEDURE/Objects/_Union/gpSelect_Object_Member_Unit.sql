-- Function: gpSelect_Object_Member_Unit()

DROP FUNCTION IF EXISTS gpSelect_Object_Member_Unit (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Member_Unit(
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ItemName TVarChar, isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbIsIrna Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Ирна!!!
     vbIsIrna:= zfCalc_User_isIrna (vbUserId);

    RETURN QUERY
       WITH tmpUserTransport AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Transport() AND 1=0)
         , tmpPersonal AS (SELECT lfSelect.MemberId
                                , lfSelect.PersonalId
                                , lfSelect.UnitId
                                , lfSelect.PositionId
                                , lfSelect.BranchId
                           FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                           WHERE lfSelect.Ord = 1
                          )
     SELECT Object_Unit_View.Id
          , Object_Unit_View.Code     
          , Object_Unit_View.Name
          , ObjectDesc.ItemName
          , Object_Unit_View.isErased
     FROM Object_Unit_View
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Unit_View.DescId
          LEFT JOIN ObjectLink AS ObjectLink_Unit_Business
                               ON ObjectLink_Unit_Business.ObjectId = Object_Unit_View.Id
                              AND ObjectLink_Unit_Business.DescId   = zc_ObjectLink_Unit_Business()
     WHERE vbUserId NOT IN (SELECT UserId FROM tmpUserTransport)
       AND (COALESCE (vbIsIrna, FALSE) = FALSE
            OR (vbIsIrna = TRUE  AND ObjectLink_Unit_Business.ChildObjectId = zc_Business_Irna())
           )

    UNION ALL
     SELECT Object_Member.Id
          , Object_Member.ObjectCode AS Code     
          , Object_Member.ValueData AS Name
          , ObjectDesc.ItemName
          , Object_Member.isErased
     FROM Object AS Object_Member
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Member.DescId
          LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = Object_Member.Id
          LEFT JOIN ObjectLink AS ObjectLink_Unit_Business
                               ON ObjectLink_Unit_Business.ObjectId = tmpPersonal.UnitId
                              AND ObjectLink_Unit_Business.DescId   = zc_ObjectLink_Unit_Business()
     WHERE Object_Member.DescId = zc_Object_Member()
       AND vbUserId NOT IN (SELECT UserId FROM tmpUserTransport)
       AND (COALESCE (vbIsIrna, FALSE) = FALSE
            OR (vbIsIrna = TRUE  AND ObjectLink_Unit_Business.ChildObjectId = zc_Business_Irna())
           )
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.12.25         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Member_Unit (inSession := zfCalc_UserAdmin())