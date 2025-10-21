-- View: _bi_Guide_ProfitLoss_View

 DROP VIEW IF EXISTS _bi_Guide_ProfitLoss_View;

-- Справочник Статьи ОПиУ
/*
-- ОПиУ Статья
Id
Code
Name
Name_original
Name_all
-- Признак "Удален да/нет"
isErased
-- Группы ОПиУ
ProfitLossGroupId
ProfitLossGroupCode
ProfitLossGroupName
ProfitLossGroupName_original
-- назначения ОПиУ
ProfitLossDirectionId
ProfitLossDirectionCode
ProfitLossDirectionName
ProfitLossDirectionName_original
*/

CREATE OR REPLACE VIEW _bi_Guide_ProfitLoss_View
AS
      SELECT ProfitLossId                AS Id
           , ProfitLossCode              AS Code
           , ProfitLossName              AS Name
           , ProfitLossName_original     AS Name_original
           , ProfitLossName_all          AS Name_all
             -- Признак "Удален да/нет"
           , FALSE :: Boolean            AS isErased

            -- Группы управленческих назначений
           , ProfitLossGroupId
           , ProfitLossGroupCode
           , ProfitLossGroupName
           , ProfitLossGroupName_original
          
             -- назначения ОПиУ
           , ProfitLossDirectionId
           , ProfitLossDirectionCode
           , ProfitLossDirectionName
           , ProfitLossDirectionName_original


       FROM Object_ProfitLoss_View
      ;

ALTER TABLE _bi_Guide_ProfitLoss_View  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC._bi_Guide_ProfitLoss_View TO admin;
GRANT ALL ON TABLE PUBLIC._bi_Guide_ProfitLoss_View TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.10.25                                        *
*/

-- тест
-- SELECT * FROM _bi_Guide_ProfitLoss_View ORDER BY 1
