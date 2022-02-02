
CREATE OR REPLACE FUNCTION zc_ObjectBoolean_InfoMoney_Service() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_InfoMoney_Service'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_InfoMoney(), 'zc_ObjectBoolean_InfoMoney_Service', 'По начислению' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_InfoMoney_Service');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_InfoMoney_UserAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_InfoMoney_UserAll'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_InfoMoney(), 'zc_ObjectBoolean_InfoMoney_UserAll', 'Доступ Всем' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_InfoMoney_UserAll');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_User_Sign() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_User_Sign'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectBoolean_User_Sign', 'Подписание корректировок' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_User_Sign');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_InfoMoneyDetail_UserAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_InfoMoneyDetail_UserAll'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_InfoMoneyDetail(), 'zc_ObjectBoolean_InfoMoneyDetail_UserAll', 'Доступ Всем' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_InfoMoneyDetail_UserAll');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_CommentInfoMoney_UserAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CommentInfoMoney_UserAll'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_CommentInfoMoney(), 'zc_ObjectBoolean_CommentInfoMoney_UserAll', 'Доступ Всем' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CommentInfoMoney_UserAll');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_CommentMoveMoney_UserAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CommentMoveMoney_UserAll'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_CommentMoveMoney(), 'zc_ObjectBoolean_CommentMoveMoney_UserAll', 'Доступ Всем' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_CommentMoveMoney_UserAll');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.02.22         * zc_ObjectBoolean_InfoMoneyDetail_UserAll
                    zc_ObjectBoolean_CommentMoveMoney_UserAll
                    zc_ObjectBoolean_CommentInfoMoney_UserAll
 12.01.22         * zc_ObjectBoolean_InfoMoney_Service
                    zc_ObjectBoolean_InfoMoney_UserAll
                    zc_ObjectBoolean_User_Sign
 10.01.22                                        * 
*/
