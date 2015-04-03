-- View: Constant_User_LevelHigh02_View

-- DROP VIEW IF EXISTS Constant_User_LevelHigh02_View CASCADE;

CREATE OR REPLACE VIEW Constant_User_LevelHigh02_View
AS
  SELECT * FROM Constant_User_LevelMax01_View
  ;

ALTER TABLE Constant_User_LevelHigh02_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 04.04.15                                        *
*/

-- тест
-- SELECT * FROM Constant_User_LevelMax01_View LEFT JOIN Object ON Object.Id = Constant_User_LevelMax01_View.UserId ORDER BY 1
