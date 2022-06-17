-- Function: gpSelect_Object_StoragePlace()

DROP FUNCTION IF EXISTS gpSelect_Object_UnitCarMember (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_StoragePlace (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StoragePlace(
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
     SELECT Object_Car.Id
          , Object_Car.ObjectCode AS Code     
          , (Object_Car.ValueData || COALESCE ( ' ' || Object.ValueData, '')) :: TVarChar AS Name
          , ObjectDesc.ItemName
          , Object_Car.isErased
     FROM Object AS Object_Car
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Car.DescId
          LEFT JOIN ObjectLink AS ObjectLink_Car ON ObjectLink_Car.DescId = zc_ObjectLink_Asset_Car() AND ObjectLink_Car.ObjectId = Object_Car.Id
          LEFT JOIN Object  ON Object.Id = ObjectLink_Car.ChildObjectId

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                  ON ObjectBoolean_Guide_Irna.ObjectId = Object_Car.Id
                                 AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()

     WHERE Object_Car.DescId IN (zc_Object_Car()) -- , zc_Object_Asset()
       AND vbUserId NOT IN (SELECT UserId FROM tmpUserTransport)
       AND (COALESCE (vbIsIrna, FALSE) = FALSE
            OR (vbIsIrna = TRUE  AND ObjectBoolean_Guide_Irna.ValueData = TRUE)
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
   /*
    UNION ALL
     SELECT View_Personal.PersonalId AS Id       
          , View_Personal.PersonalCode     
          , View_Personal.PersonalName
          , ObjectDesc.ItemName
          , View_Personal.isErased
     FROM Object_Personal_View AS View_Personal
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = View_Personal.DescId
     WHERE vbUserId NOT IN (SELECT UserId FROM tmpUserTransport)
    UNION ALL
     SELECT View_Personal.PersonalId AS Id       
          , View_Personal.PersonalCode     
          , View_Personal.PersonalName
          , ObjectDesc.ItemName
          , View_Personal.isErased
     FROM lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection
          JOIN Object_Personal_View AS View_Personal ON View_Personal.UnitId = lfObject_Unit_byProfitLossDirection.UnitId
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = View_Personal.DescId
     WHERE vbUserId NOT IN (SELECT UserId FROM tmpUserTransport)
       AND (lfObject_Unit_byProfitLossDirection.ProfitLossDirectionId = zc_Enum_ProfitLossDirection_40100() -- Содержание транспорта
         OR lfObject_Unit_byProfitLossDirection.UnitCode IN (23020)) -- Отдел логистики
     */
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_StoragePlace (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.14                                        * add DROP FUNCTION gpSelect_Object_UnitCarMember
 26.01.14                                        * add zc_Object_Car
 07.12.13                                        * rename UserRole_View -> ObjectLink_UserRole_View
 09.11.13                                        * add tmpUserTransport
 09.11.13                                        * add ItemName
 28.10.13                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_StoragePlace (inSession := zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_StoragePlace (inSession := '9818')
