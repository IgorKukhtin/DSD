-- доступ к act.....
select distinct userId, userName, UnitName, positionName
 from gpSelect_Object_UserRoleUnion( inSession := '5')
where RoleId in (

select RoleId  from
(
select* from gpSelect_Object_RoleUnion(inValue := 1 ,  inSession := '5')
where id in 

(
select id from gpSelect_Object_RoleUnion(inValue := 0 ,  inSession := '5')
where name ilike '%actProductionUnionTech%'
)
) as a
)
and iserased = false

union
-- admin
select distinct userId, userName, UnitName, positionName
 from gpSelect_Object_UserRoleUnion( inSession := '5')
where RoleId = zc_Enum_Role_Admin()
  and iserased = false
  -- and UserId NOT IN (SELECT gpSelect.UserId FROM gpSelect_Object_MemberPersonalServiceList (false, '2') AS gpSelect) -- where Id > 0
  -- and UserId NOT IN (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = 8813637) -- Ограничение - нет доступа к просмотру данных ЗП
  -- and UserId NOT IN (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = 11026035) -- Ограничение - нет доступа к просмотру ведомость Админ ЗП

order by 2




-- доступ к ЗП - Админ
SELECT * 
from Object where Id in (

SELECT Constant_User_LevelMax01_View.UserId
                           FROM Constant_User_LevelMax01_View
                                -- Ограниченние - только разрешенные ведомости ЗП
                                LEFT JOIN ObjectLink_UserRole_View ON ObjectLink_UserRole_View.UserId = Constant_User_LevelMax01_View.UserId AND ObjectLink_UserRole_View.RoleId = 10657326 

                           WHERE ObjectLink_UserRole_View.UserId IS NULL
and            Constant_User_LevelMax01_View.UserId not in (SELECT ObjectLink_UserRole_View.UserId  FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.RoleId = 11026035)
)
order by 4
