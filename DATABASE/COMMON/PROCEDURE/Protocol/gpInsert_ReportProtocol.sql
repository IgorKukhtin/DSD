-- DROP FUNCTION gpInsert_ReportProtocol;

DROP FUNCTION IF EXISTS gpInsert_ReportProtocol (TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_ReportProtocol (
    IN inProtocolData TBlob,
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
return;
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_());
     vbUserId:= lpGetUserBySession (inSession);

     -- запишем 
     PERFORM lpInsert_ReportProtocol (inUserId       := vbUserId
                                    , inProtocolData := inProtocolData
                                     );
   
END;           
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.
 31.05.17                                                       *
*/
