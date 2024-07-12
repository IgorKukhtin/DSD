-- View: Constant_User_LevelMax01_View

-- DROP VIEW IF EXISTS Constant_User_LevelMax01_View CASCADE;

CREATE OR REPLACE VIEW Constant_User_LevelMax01_View
AS
  SELECT DISTINCT UserId
  FROM ObjectLink_UserRole_View
  WHERE RoleId IN (10898    -- Отчеты (руководство)
                 , 413075   -- ЗП просмотр ВСЕ
                 , 10597056 -- Только просмотр Аудитор
                  )
 UNION
  SELECT 5 AS UserId -- Админ"
  ;

ALTER TABLE Constant_User_LevelMax01_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 04.04.15                                        *
*/

-- LevelMax01
-- LevelHigh02
-- LevelMedium03
-- LevelNormal04
-- LevelLover05
-- LevelMin06

-- тест
-- SELECT * FROM Constant_User_LevelMax01_View LEFT JOIN Object ON Object.Id = Constant_User_LevelMax01_View.UserId ORDER BY 1
