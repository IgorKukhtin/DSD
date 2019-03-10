CREATE OR REPLACE FUNCTION zc_MovementBlob_Comdoc() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_Comdoc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementBLOBDesc (Code ,itemname)
   SELECT 'zc_MovementBlob_Comdoc','Данные COMDOC' WHERE NOT EXISTS (SELECT * FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_Comdoc');

CREATE OR REPLACE FUNCTION zc_MovementBlob_Comment() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementBLOBDesc (Code ,itemname)
   SELECT 'zc_MovementBlob_Comment','Особливі відмітки' WHERE NOT EXISTS (SELECT * FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_Comment');

CREATE OR REPLACE FUNCTION zc_MovementBlob_Message() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_Message'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementBLOBDesc (Code ,itemname)
   SELECT 'zc_MovementBlob_Message','Текст сообщения' WHERE NOT EXISTS (SELECT * FROM MovementBlobDesc WHERE Code = 'zc_MovementBlob_Message');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.   Шаблий О.В.
 10.03.19                                                                      * zc_MovementBlob_Message
 09.02.15         												*
 05.08.14                         *
*/
