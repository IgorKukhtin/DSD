-- Function: gpInsert_Object_Sticker_ReportName()

DROP FUNCTION IF EXISTS gpInsert_Object_Sticker_ReportName(TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_Sticker_ReportName(
    IN inReportName          TVarChar  , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbId         Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Sticker());
   vbUserId:= lpGetUserBySession (inSession);
   
   inReportName:= TRIM(inReportName);
   
   IF NOT EXISTS (SELECT Id FROM Object WHERE DescId = zc_Object_Form() AND TRIM(ValueData) = TRIM(inReportName))   ---'PrintObject_Sticker'
   THEN
       -- сохранили <Объект>
       vbId:= lpInsertUpdate_Object (0, zc_Object_Form(), 0, inReportName);
       
       INSERT INTO ObjectBlob (DescId, ObjectId, ValueData )
              SELECT zc_objectBlob_form_Data(), vbId , '' ;
   END IF;
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
 
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.10.17         *
*/

-- тест
-- SELECT * FROM gpInsert_Object_Sticker_ReportName (inReportName:= 'PrintObject_Sticker', inSession:= '2')
