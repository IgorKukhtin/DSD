CREATE OR REPLACE FUNCTION zc_MILinkObject_Insert() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Insert'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Insert', 'Пользователь (создание)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Insert');

CREATE OR REPLACE FUNCTION zc_MILinkObject_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_InfoMoney', 'Статья Приход/расход' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_InfoMoney');

CREATE OR REPLACE FUNCTION zc_MILinkObject_CommentInfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_CommentInfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_CommentInfoMoney', 'Примечание Приход/расход' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_CommentInfoMoney');

CREATE OR REPLACE FUNCTION zc_MILinkObject_InfoMoneyDetail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_InfoMoneyDetail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_InfoMoneyDetail', 'Детально Приход/расход ' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_InfoMoneyDetail');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.01.22         * zc_MILinkObject_InfoMoney
                    zc_MILinkObject_CommentInfoMoney
                    zc_MILinkObject_InfoMoneyDetail
 08.01.22                                        *
*/
