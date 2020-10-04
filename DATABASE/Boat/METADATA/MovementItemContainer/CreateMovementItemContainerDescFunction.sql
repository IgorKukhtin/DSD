CREATE OR REPLACE FUNCTION zc_MIContainer_Count() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_Count'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemContainerDesc(Code, ItemName)
  SELECT 'zc_MIContainer_Count', 'Количественный учет' WHERE NOT EXISTS (SELECT * FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_Count');

CREATE OR REPLACE FUNCTION zc_MIContainer_Summ() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_Summ'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemContainerDesc(Code, ItemName)
  SELECT 'zc_MIContainer_Summ', 'Суммовой учет' WHERE NOT EXISTS (SELECT * FROM MovementItemContainerDesc WHERE Code = 'zc_MIContainer_Summ');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.08.20                                        * 
*/

