-- View: Employees

DROP VIEW IF EXISTS Employees;

CREATE OR REPLACE VIEW Employees
AS 
  WITH _tmpresult AS (SELECT extId
                           , Name 
                           , orgStructExtId
                           , groupId
                           , roles
                           , login
                           , email
                           , password
                           , activationDate
                           , phone
                           , personalNumber
                           , leadExtId
                           , notificationLanguage
                           , isDeleted
                      FROM dblink ('host=192.168.0.228 dbname=project port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                 , ('SELECT *
                                    FROM gpSelect_Object_Employees_effie(zfCalc_UserAdmin())'
                                    ) :: Text
                                  ) AS gpSelect (extId           TVarChar   -- Уникальный идентификатор сотрудника
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
                                                )
                     )
 --
 SELECT extId
      , Name 
      , orgStructExtId
      , groupId
      , roles
      , login
      , email
      , password
      , activationDate
      , phone
      , personalNumber
      , leadExtId
      , notificationLanguage
      , isDeleted
   FROM _tmpresult
  ;

ALTER TABLE Employees  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC.Employees TO admin;
GRANT ALL ON TABLE PUBLIC.Employees TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.03.26         *
*/

-- тест
-- SELECT * FROM Employees ORDER BY 1
