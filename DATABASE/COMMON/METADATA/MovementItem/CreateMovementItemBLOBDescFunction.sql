CREATE OR REPLACE FUNCTION zc_MIBLOB_Question() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBlobDesc WHERE Code = 'zc_MIBLOB_Question'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBLOBDesc (Code ,itemname)
   SELECT 'zc_MIBLOB_Question','Вопрос' WHERE NOT EXISTS (SELECT * FROM MovementItemBlobDesc WHERE Code = 'zc_MIBLOB_Question');

CREATE OR REPLACE FUNCTION zc_MIBLOB_PossibleAnswer() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBlobDesc WHERE Code = 'zc_MIBLOB_PossibleAnswer'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBLOBDesc (Code ,itemname)
   SELECT 'zc_MIBLOB_PossibleAnswer','Вариант ответа' WHERE NOT EXISTS (SELECT * FROM MovementItemBlobDesc WHERE Code = 'zc_MIBLOB_PossibleAnswer');



/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.   Шаблий О.В.
 06.07.21                                                                      * zc_MIBLOB_Question, zc_MIBLOB_PossibleAnswer
*/
