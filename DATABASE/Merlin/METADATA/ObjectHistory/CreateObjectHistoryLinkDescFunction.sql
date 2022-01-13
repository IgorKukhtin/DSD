CREATE OR REPLACE FUNCTION zc_ObjectHistoryLink_ServiceItem_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryLinkDesc WHERE Code = 'zc_ObjectHistoryLink_ServiceItem_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryLinkDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_ServiceItem(), 'zc_ObjectHistoryLink_ServiceItem_InfoMoney','Статьи Приход/расход' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryLinkDesc WHERE Id = zc_ObjectHistoryLink_ServiceItem_InfoMoney());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryLink_ServiceItem_CommentInfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryLinkDesc WHERE Code = 'zc_ObjectHistoryLink_ServiceItem_CommentInfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryLinkDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_ServiceItem(), 'zc_ObjectHistoryLink_ServiceItem_CommentInfoMoney','Примечание Приход/расход' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryLinkDesc WHERE Id = zc_ObjectHistoryLink_ServiceItem_CommentInfoMoney());


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.01.22         * zc_ObjectHistoryLink_ServiceItem_InfoMoney
                    zc_ObjectHistoryLink_ServiceItem_CommentInfoMoney
 28.08.20                                        * 
*/
