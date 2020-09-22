CREATE OR REPLACE FUNCTION zc_Container_Count() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ContainerDesc WHERE Code = 'zc_Container_Count'); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO ContainerDesc(Code, ItemName)
  SELECT 'zc_Container_Count', 'Остатки количественного учета' WHERE NOT EXISTS (SELECT * FROM ContainerDesc WHERE Code = 'zc_Container_Count');

CREATE OR REPLACE FUNCTION zc_Container_Summ() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ContainerDesc WHERE Code = 'zc_Container_Summ'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerDesc(Code, ItemName)
  SELECT 'zc_Container_Summ', 'Остатки суммового учета' WHERE NOT EXISTS (SELECT * FROM ContainerDesc WHERE Code = 'zc_Container_Summ');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.08.20                                        *
*/
