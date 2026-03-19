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
 BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     SELECT Object_Member.Id                             ::TVarChar AS extId
          , TRIM (Object_Member.ValueData)               ::TVarChar AS Name 
          , '1'                                          ::TVarChar AS orgStructExtId
          , '4ADBB652-F1EE-427E-AAE4-96C41A25C97B'       ::TVarChar AS groupId
          , 'AC86FF1D-78F8-4D0A-A0F9-3422C6BBA570'       ::TVarChar AS roles
          , ('User'||Object_Member.Id::TVarChar||'@alan.ua')  ::TVarChar AS login
          , ('User'||Object_Member.Id::TVarChar||'@alan.ua')  ::TVarChar AS email           --user+zc_Object_Member.Id@alan.ua
          , (ObjectString_User_.ValueData||'SFA')            ::TVarChar AS password
          , '01.01.2026'                                 ::TVarChar AS activationDate
          , ''                                           ::TVarChar AS phone
          , Object_Member.ObjectCode                     ::TVarChar AS personalNumber
          , NULL                                         ::TVarChar AS leadExtId
          , ''                                           ::TVarChar AS notificationLanguage
          , Object_Member.isErased                       ::Boolean  AS isDeleted

     FROM Object AS Object_Member 
          LEFT JOIN ObjectLink AS ObjectLink_User_Member
                               ON ObjectLink_User_Member.ChildObjectId = Object_Member.Id
                              AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
          INNER JOIN Object AS Object_User ON Object_User.Id       = ObjectLink_User_Member.ObjectId  
                                          AND Object_User.isErased = FALSE
        
          INNER JOIN ObjectBoolean AS ObjectBoolean_ProjectMobile
                                   ON ObjectBoolean_ProjectMobile.ObjectId  = ObjectLink_User_Member.ObjectId
                                  AND ObjectBoolean_ProjectMobile.DescId    = zc_ObjectBoolean_User_ProjectMobile()
                                  AND ObjectBoolean_ProjectMobile.ValueData = TRUE

          LEFT JOIN ObjectString AS ObjectString_User_
                                 ON ObjectString_User_.ObjectId = Object_User.Id
                                AND ObjectString_User_.DescId = zc_ObjectString_User_Password()

     WHERE Object_Member.DescId = zc_Object_Member() 
       AND Object_Member.isErased = FALSE
       AND Object_Member.Id NOT IN (13165, 1122130, 7015073) -- "Махов Тарас Володимирович"
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
