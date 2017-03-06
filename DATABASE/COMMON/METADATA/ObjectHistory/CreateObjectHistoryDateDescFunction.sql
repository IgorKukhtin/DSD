
CREATE OR REPLACE FUNCTION zc_ObjectHistoryDate_JuridicalDetails_Decision() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryDateDesc WHERE Code = 'zc_ObjectHistoryDate_JuridicalDetails_Decision'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryDateDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryDate_JuridicalDetails_Decision','Дата рішення про видачу ліцензії' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryDateDesc WHERE Id = zc_ObjectHistoryDate_JuridicalDetails_Decision());



/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 06.03.17         * 
*/
