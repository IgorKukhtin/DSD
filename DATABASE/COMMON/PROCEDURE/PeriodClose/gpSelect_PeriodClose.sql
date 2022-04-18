-- Function: gpSelect_PeriodClose (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_PeriodClose (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_PeriodClose(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , RoleId Integer, RoleCode Integer, RoleName TVarChar, UserName_list TVarChar
             , UserId_excl Integer, UserCode_excl Integer, UserName_excl TVarChar
             , isUserName TVarChar

             , DescId Integer, DescName TVarChar
             , DescId_excl Integer, DescName_excl TVarChar

             , BranchId   Integer, BranchCode   Integer, BranchName TVarChar
             , PaidKindId Integer, PaidKindCode Integer, PaidKindName TVarChar

             , Period Integer, CloseDate TDateTime, CloseDate_excl TDateTime, CloseDate_store TDateTime
             , UserId Integer, UserName TVarChar, OperDate TDateTime

             , UserByGroupId_excl Integer, UserByGroupCode_excl Integer, UserByGroupName_excl TVarChar
              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- lpCheckRight (inSession, zc_Enum_Process_...());


     -- Результат
     RETURN QUERY 
        WITH tmpDesc AS (SELECT tmp.DescId
                              , STRING_AGG (tmp.DescName, '; ') :: TVarChar AS DescName
                         FROM lpSelect_PeriodClose_Desc (inUserId:= vbUserId) AS tmp
                         GROUP BY tmp.DescId
                        )
           , tmpUser_list AS (SELECT tmp.RoleId
                                   , STRING_AGG (tmp.UserName, '; ') :: TVarChar AS UserName
                              FROM (SELECT DISTINCT
                                           PeriodClose.RoleId
                                         , Object_User.ValueData AS UserName
                                    FROM PeriodClose
                                         INNER JOIN ObjectLink_UserRole_View AS View_UserRole ON View_UserRole.RoleId = PeriodClose.RoleId
                                         INNER JOIN Object AS Object_User ON Object_User.Id = View_UserRole.UserId
                                    ORDER BY Object_User.ValueData
                                   ) AS tmp
                              GROUP BY tmp.RoleId
                             )
        SELECT PeriodClose.Id              AS Id
             , PeriodClose.Code            AS Code
             , PeriodClose.Name            AS Name

             , Object_Role.Id              AS RoleId
             , Object_Role.ObjectCode      AS RoleCode
             , Object_Role.ValueData       AS RoleName
             , tmpUser_list.UserName       AS UserName_list
             , Object_User_excl.Id         AS UserId_excl
             , Object_User_excl.ObjectCode AS UserCode_excl
             , Object_User_excl.ValueData  AS UserName_excl
             , CASE WHEN Object_Branch.Id > 0 -- AND COALESCE (tmpUser_list.UserName, '') = ''
                         THEN 'нет, Филиал ...' || CASE WHEN Object_User_excl.Id > 0 THEN ' + ИСКЛЮЧЕНИЯ ...' ELSE '' END
                    WHEN tmpUser_list.UserName <> ''
                         THEN 'нет, только ...' || CASE WHEN Object_User_excl.Id > 0 THEN ' + ИСКЛЮЧЕНИЯ ...' ELSE '' END
                    ELSE 'да' || CASE WHEN tmpDesc.DescId > 0 THEN ', только ...' ELSE ', кроме ...' END || CASE WHEN Object_User_excl.Id > 0 THEN ' + ИСКЛЮЧЕНИЯ ...' ELSE '' END
               END :: TVarChar AS isUserName

             , tmpDesc.DescId
             , CASE WHEN tmpDesc_excl.DescId > 0 AND COALESCE (tmpDesc.DescId, 0) = 0 THEN 'Все, кроме ...' ELSE COALESCE (tmpDesc.DescName, 'Все') END :: TVarChar AS DescName
             , tmpDesc_excl.DescId         AS DescId_excl
             , tmpDesc_excl.DescName       AS DescName_excl

             , Object_Branch.Id              AS BranchId
             , Object_Branch.ObjectCode      AS BranchCode
             , Object_Branch.ValueData       AS BranchName
             , Object_PaidKind.Id            AS PaidKindId
             , Object_PaidKind.ObjectCode    AS PaidKindCode
             , Object_PaidKind.ValueData     AS PaidKindName

             , EXTRACT (DAY FROM PeriodClose.Period) :: Integer AS Period
             , PeriodClose.CloseDate
             , CASE WHEN Object_User_excl.Id > 0 THEN PeriodClose.CloseDate_excl ELSE NULL END :: TDateTime AS CloseDate_excl
             , PeriodClose.CloseDate_store

             , Object_User.Id        AS UserId
             , Object_User.ValueData AS UserName
             , PeriodClose.OperDate
             
             , PeriodClose.UserByGroupId_excl
             , Object_UserByGroup_excl.ObjectCode  AS UserByGroupCode_excl
             , Object_UserByGroup_excl.ValueData   AS UserByGroupName_excl

        FROM PeriodClose
             LEFT JOIN tmpDesc ON tmpDesc.DescId = PeriodClose.DescId
             LEFT JOIN tmpDesc AS tmpDesc_excl ON tmpDesc_excl.DescId = PeriodClose.DescId_excl
             LEFT JOIN tmpUser_list ON tmpUser_list.RoleId = PeriodClose.RoleId
             LEFT JOIN Object AS Object_User_excl ON Object_User_excl.Id = PeriodClose.UserId_excl
             LEFT JOIN Object AS Object_UserByGroup_excl ON Object_UserByGroup_excl.Id = PeriodClose.UserByGroupId_excl

             LEFT JOIN Object AS Object_Role ON Object_Role.Id = PeriodClose.RoleId

             LEFT JOIN Object AS Object_Branch   ON Object_Branch.Id   = PeriodClose.BranchId
             LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = PeriodClose.PaidKindId

             LEFT JOIN Object AS Object_User ON Object_User.Id = PeriodClose.UserId
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_PeriodClose (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.12.16         * add CloseDate_store
 24.04.16                                        *
 11.11.13                        *  
*/

-- тест
-- SELECT * FROM gpSelect_PeriodClose (inSession:= zfCalc_UserAdmin()); 
