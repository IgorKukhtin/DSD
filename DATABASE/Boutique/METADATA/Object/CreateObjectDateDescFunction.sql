
CREATE OR REPLACE FUNCTION zc_ObjectDate_Personal_In() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_In'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Personal(), 'zc_ObjectDate_Personal_In', 'Дата принятия у сотрудника' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_In');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Personal_Out() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_Out'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Personal(), 'zc_ObjectDate_Personal_Out', 'Дата увольнения у сотрудника' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_Out');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Client_LastDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Client_LastDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Client(), 'zc_ObjectDate_Client_LastDate', 'Последняя дата покупки' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Client_LastDate');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Client_HappyDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Client_HappyDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Client(), 'zc_ObjectDate_Client_HappyDate', 'День рождения' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Client_HappyDate');



/*-------------------------------------------------------------------------------
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.  Воробкало А.А.
28.02.2017                                                         *
*/
