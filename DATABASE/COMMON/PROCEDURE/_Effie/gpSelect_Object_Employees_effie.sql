-- Function: gpSelect_Object_Employees_effie

--zc_Object_Member.Id - НЕ ВСЕ СОТРУДНИКИ!!! - только zc_ObjectBoolean_User_ProjectMobile = TRUE

DROP FUNCTION IF EXISTS gpSelect_Object_Employees_effie ( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Employees_effie(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (extId           TVarChar   -- Уникальный идентификатор сотрудника
             , Name            TVarChar   -- ФИО сотрудника
             , orgStructExtId  TVarChar   -- Идентификатор орг структуры 
             , groupId         TVarChar   -- Идентификатор группы пользователей (перечень выдаёт бизнес аналитик IPland). Влияет на формат работы, на настройки в работе и т.п.
             , roles           TVarChar   -- Массив ролей, доступных сотруднику
             , login           TVarChar   -- Логин сотрудника, который будет использоваться для входа на мобильный клиент и портал Effie
             , email           TVarChar   -- Почта сотрудника 
             , password        TVarChar   -- Обязательное заполнение для нового сотрудника(пользователя в системе). При обновлении существующих пользователей значение в поле игнорируется и пароль у сотрудников не меняет.
             , activationDate  TVarChar   -- Дата активации учётки сотрудника 
             , phone           TVarChar   -- Телефон сотрудника
             , personalNumber  TVarChar   -- Табельный номер (доступно с 2022.11.10) 
             , leadExtId       TVarChar   -- Идентификатор руководителя 
             , notificationLanguage TVarChar  --Язык уведомлений согласно ISO 639-1 (Коды языков ). Если не указано, то будет использоваться украинский: “uk“. На текущий момент доступны следующие варианты: "uk", "kk", "mo", "ru", "az", "ky", "be", "en"
             , isDeleted       Boolean    -- Признак активности записи: 0 = активна / 1 = не активна
) AS

$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbR RECORD;
   DECLARE vbScript      TEXT;
   DECLARE vb1           TEXT;
 BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     CREATE TEMP TABLE _tmpEmployee ON COMMIT DROP AS
       WITH tmpList AS (SELECT DISTINCT gpSelect.employeeExtId :: Integer AS MemberId FROM gpSelect_Object_EmployeesTT_effie('') AS gpSelect
                       UNION
                        SELECT ObjectBoolean_Member_Effie.ObjectId AS MemberId
                        FROM ObjectBoolean AS ObjectBoolean_Member_Effie
                        WHERE ObjectBoolean_Member_Effie.ValueData = TRUE
                           AND ObjectBoolean_Member_Effie.DescId = zc_ObjectBoolean_Member_Effie()
                       )
       --
       SELECT tmpList.MemberId, MAX (Object_User.Id) AS UserId
       FROM tmpList
            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ChildObjectId = tmpList.MemberId
                                AND ObjectLink_User_Member.DescId       = zc_ObjectLink_User_Member()
            LEFT JOIN Object AS Object_User ON Object_User.Id = ObjectLink_User_Member.ObjectId  
            LEFT JOIN ObjectBoolean AS ObjectBoolean_ProjectMobile
                                    ON ObjectBoolean_ProjectMobile.ObjectId  = ObjectLink_User_Member.ObjectId
                                   AND ObjectBoolean_ProjectMobile.DescId    = zc_ObjectBoolean_User_ProjectMobile()
                                   AND ObjectBoolean_ProjectMobile.ValueData = TRUE
       -- WHERE ObjectBoolean_ProjectMobile.ObjectId IS NULL
       GROUP BY tmpList.MemberId
      ;
        

     -- Все кто есть больше не передаются
     UPDATE Object_Employees_effie SET isNew = FALSE;

     -- Новые для этой сессии
     INSERT INTO Object_Employees_effie (MemberId, isNew, InsertDate)
        SELECT _tmpEmployee.MemberId, TRUE, CURRENT_TIMESTAMP
        FROM _tmpEmployee
             LEFT JOIN Object_Employees_effie ON Object_Employees_effie.MemberId = _tmpEmployee.MemberId
        -- только новые     
        WHERE Object_Employees_effie.MemberId IS NULL
       ;
        
     -- Заливаем только новые в базу Effie
     FOR vbR IN (SELECT Object_Employees_effie.MemberId FROM Object_Employees_effie WHERE Object_Employees_effie.isNew = TRUE)
     LOOP
         vbScript:= 'INSERT INTO Employees_new (extId, isNew) SELECT ' || CHR (39) || vbR.MemberId :: TVarChar || CHR (39) || ', TRUE '
                 || ' WHERE NOT EXISTS (SELECT 1 FROM Employees_new WHERE Employees_new.extId = ' || CHR (39) || vbR.MemberId :: TVarChar || CHR (39) || ' ) '
                   ;
         -- Результат
         vb1:= (SELECT *
                FROM dblink_exec ('host=192.168.251.33 dbname=effie_api port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                   -- Результат
                                , vbScript
                                 ));
     END LOOP;


     -- Результат
     RETURN QUERY
     SELECT DISTINCT
            Object_Member.Id                             ::TVarChar AS extId
          , TRIM (Object_Member.ValueData)               ::TVarChar AS Name 
          , '1'                                          ::TVarChar AS orgStructExtId
          , '4ADBB652-F1EE-427E-AAE4-96C41A25C97B'       ::TVarChar AS groupId
          , 'AC86FF1D-78F8-4D0A-A0F9-3422C6BBA570'       ::TVarChar AS roles
          , ('User'||Object_Member.Id::TVarChar||'@alan.ua')  ::TVarChar AS login
          , ('User'||Object_Member.Id::TVarChar||'@alan.ua')  ::TVarChar AS email           --user+zc_Object_Member.Id@alan.ua
          , COALESCE (ObjectString_User_.ValueData||'SFA', 'sfa12345SFA')  ::TVarChar AS password
          , '01.01.2026'                                 ::TVarChar AS activationDate
          , ''                                           ::TVarChar AS phone
          , Object_Member.ObjectCode                     ::TVarChar AS personalNumber
          , NULL                                         ::TVarChar AS leadExtId
          , ''                                           ::TVarChar AS notificationLanguage

        --, CASE WHEN Object_Member.isErased = TRUE OR Object_User.isErased = TRUE THEN TRUE ELSE FALSE END ::Boolean  AS isDeleted
          , FALSE  ::Boolean  AS isDeleted

     FROM Object AS Object_Member 
          INNER JOIN _tmpEmployee ON _tmpEmployee.MemberId = Object_Member.Id

          LEFT JOIN ObjectString AS ObjectString_User_
                                 ON ObjectString_User_.ObjectId = _tmpEmployee.UserId
                                AND ObjectString_User_.DescId = zc_ObjectString_User_Password()

     WHERE Object_Member.DescId = zc_Object_Member() 
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.03.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Employees_effie (zfCalc_UserAdmin()::TVarChar) -- WHERE extId IN (13165, 1122130, 7015073)
