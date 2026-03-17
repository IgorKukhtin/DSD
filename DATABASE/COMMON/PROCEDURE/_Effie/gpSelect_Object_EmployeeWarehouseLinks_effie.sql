-- Function: gpSelect_Object_EmployeeWarehouseLinks_effie

DROP FUNCTION IF EXISTS gpSelect_Object_EmployeeWarehouseLinks_effie ( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_EmployeeWarehouseLinks_effie(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (employeeExtId       TVarChar   -- Идентификатор сотрудника
             , warehouseExtId      TVarChar   -- Идентификатор склада
             , linkItemTypeId      TFloat     -- "Тип связи : null - все товары, доступные на складе
             , linkItemExtId       TVarChar   -- "Идентификатор связи. В зависимости от типа связи соответствующий идентификатор."
             , isDefaultWarehouse  Boolean    -- Признак того, что текущий склад для сотрудника - склад по умолчанию. true - склад по умолчанию, false - обычный склад
             , isDeleted           Boolean    -- Признак активности: false = активна / true = не активна. По умолчанию false = активна.
) AS

$BODY$
   DECLARE vbUserId Integer;
 BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH
     tmpMember AS (SELECT ObjectLink_User_Member.ChildObjectId AS MemberId
              
                        , CASE WHEN ObjectLink_User_Member.ObjectId = 5866615 -- Матіюк В.Ю.
                                    THEN 8379 -- филиал Киев
                               WHEN ObjectLink_User_Member.ObjectId = 10105228  -- Трубін О.С.
                                    THEN 8381 -- филиал Харьков
                               WHEN ObjectLink_User_Member.ObjectId = 9957690 -- Свідзінська І.І.
                                    THEN 8374 -- филиал Одесса
                               WHEN ObjectLink_Unit_Branch.ChildObjectId = 8377 -- филиал Кр.Рог
                                    THEN zc_Branch_Basis()
                               WHEN ObjectLink_Unit_Branch.ChildObjectId = 301310 -- филиал Запорожье
                                    THEN zc_Branch_Basis()
                               ELSE COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())
                          END AS BranchId
              
                   FROM ObjectLink AS ObjectLink_User_Member
                        INNER JOIN ObjectBoolean AS ObjectBoolean_ProjectMobile
                                                 ON ObjectBoolean_ProjectMobile.ObjectId = ObjectLink_User_Member.ObjectId
                                                AND ObjectBoolean_ProjectMobile.DescId = zc_ObjectBoolean_User_ProjectMobile()
                                                AND COALESCE (ObjectBoolean_ProjectMobile.ValueData, FALSE) = TRUE

                        INNER JOIN Object AS Object_Member 
                                          ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId
                                         AND Object_Member.isErased = FALSE

                         LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                             ON ObjectLink_Unit_Branch.ObjectId = lfSelect.UnitId
                                            AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()
                   WHERE ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                   )
     --
     SELECT tmpMember.MemberId           ::TVarChar AS employeeExtId
          , CASE Object_Branch.ObjectCode
                 WHEN 1  THEN 8459    -- филиал zc_Branch_Basis - Склад Реализации
                 WHEN 2  THEN 8411    -- филиал Киев      - Склад ГП ф Киев
                 WHEN 3  THEN 8417    -- филиал Николаев (Херсон) - Склад ГП ф.Николаев (Херсон)
                 WHEN 4  THEN 346093  -- филиал Одесса    - Склад ГП ф.Одесса
                 WHEN 5  THEN 8415    -- филиал Черкассы (Кировоград) - Склад ГП ф.Черкассы (Кировоград)
                 WHEN 7  THEN 8413    -- филиал Кр.Рог    - Склад ГП ф.Кривой Рог
                 WHEN 9  THEN 8425    -- филиал Харьков   - Склад ГП ф.Харьков
                 WHEN 11 THEN 301309  -- филиал Запорожье - Склад ГП ф.Запорожье
                 WHEN 12 THEN 3080691 -- филиал Львов     - Склад ГП ф.Львов
                 WHEN 18 THEN 11921035-- Филиал Винница   - Склад ГП ф.Вінниця
                 ELSE 0
            END                          ::TVarChar AS warehouseExtId
          , NULL                         ::TFloat   AS linkItemTypeId
          , NULL                         ::TVarChar AS linkItemExtId
          , TRUE                         ::Boolean  AS isDefaultWarehouse
          , FALSE                        ::Boolean  AS isDeleted
     FROM tmpMember
         LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpMember.BranchId
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.03.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_EmployeeWarehouseLinks_effie (zfCalc_UserAdmin()::TVarChar);


/*

c_ObjectBoolean_User_ProjectMobile = TRUE + каждому найти склад 
- по аналогии как в gpGetMobile_Object_Const - здесь для 1ого пользователя : 1) сначала найти филиал взять CASE .... 2) по филиалу взять то что захардкожено - UnitId

*/