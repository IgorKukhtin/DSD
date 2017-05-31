-- DROP FUNCTION lpInsert_ReportProtocol;

DROP FUNCTION IF EXISTS lpInsert_ReportProtocol (Integer, TBlob);

CREATE OR REPLACE FUNCTION lpInsert_ReportProtocol (
    IN inUserId       Integer,
    IN inProtocolData TBlob
)
RETURNS VOID
AS
$BODY$
BEGIN
 
      -- Сохранили
      INSERT INTO ReportProtocol (UserId, OperDate, ProtocolData)
      VALUES (inUserId, CURRENT_TIMESTAMP, inProtocolData);
   
END;           
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.
 31.05.17                                                       *
*/
