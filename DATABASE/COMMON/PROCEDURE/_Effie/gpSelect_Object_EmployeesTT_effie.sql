-- Function: gpSelect_Object_EmployeesTT_effie

DROP FUNCTION IF EXISTS gpSelect_Object_EmployeesTT_effie ( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_EmployeesTT_effie(
    IN inSession              TVarChar    -- сессия пользователя
)

---zc_ObjectLink_Partner_Personal union zc_ObjectLink_Partner_PersonalTrade union zc_ObjectLink_Partner_PersonalMerch
--zc_Object_Member.Id - НЕ ВСЕ СОТРУДНИКИ!!! - только zc_ObjectBoolean_User_ProjectMobile = TRUE

RETURNS TABLE (employeeExtId    TVarChar   -- Идентификатор сотрудника
             , ttExtId          TVarChar   -- Идентификатор торговой точки
             , isDeleted        Integer    -- Признак активности
) AS

$BODY$
   DECLARE vbUserId Integer;
 BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     --
     RETURN QUERY
     SELECT DISTINCT 
            ObjectLink_Personal_Member.ChildObjectId ::TVarChar AS employeeExtId
          , ObjectLink_Partner_Personal.ObjectId     ::TVarChar AS ttExtId
          , 0                                        ::Integer  AS isDeleted
     FROM ObjectLink AS ObjectLink_Partner_Personal
          INNER JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner_Personal.ObjectId
                                             AND Object_Partner.isErased = FALSE

          LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                               ON ObjectLink_Personal_Member.ObjectId = ObjectLink_Partner_Personal.ChildObjectId
                              AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
          INNER JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_Personal_Member.ChildObjectId
                                            AND Object_Member.isErased = FALSE

          LEFT JOIN ObjectLink AS ObjectLink_User_Member
                               ON ObjectLink_User_Member.ChildObjectId = ObjectLink_Personal_Member.ChildObjectId
                              AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

          INNER JOIN ObjectBoolean AS ObjectBoolean_ProjectMobile
                                   ON ObjectBoolean_ProjectMobile.ObjectId = ObjectLink_User_Member.ObjectId
                                  AND ObjectBoolean_ProjectMobile.DescId = zc_ObjectBoolean_User_ProjectMobile()
                                  AND COALESCE (ObjectBoolean_ProjectMobile.ValueData, FALSE) = TRUE

     WHERE ObjectLink_Partner_Personal.DescId IN (zc_ObjectLink_Partner_Personal()
                                                , zc_ObjectLink_Partner_PersonalTrade()
                                                , zc_ObjectLink_Partner_PersonalMerch()
                                                ) 
       AND ObjectLink_Personal_Member.ChildObjectId  > 0
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.03.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_EmployeesTT_effie (zfCalc_UserAdmin()::TVarChar);