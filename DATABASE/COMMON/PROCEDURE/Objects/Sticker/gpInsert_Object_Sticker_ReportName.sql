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
   
   -- 
   inReportName:= TRIM (inReportName);
   
   -- если такого Шаблона еще нет
   IF NOT EXISTS (SELECT 1 FROM Object WHERE Object.DescId = zc_Object_Form() AND TRIM (Object.ValueData) = inReportName)
      OR (inReportName ILIKE '%ТМ Favore%' AND 1=0)
   THEN

       IF inReportName ILIKE '%ТМ Favore%'
       THEN vbId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Form() AND TRIM (Object.ValueData) = inReportName);
       END IF;
       
       IF vbId > 0
       THEN
           -- сохранили <Объект>
           UPDATE ObjectBlob SET ValueData = tmp_find.ValueData
           FROM (SELECT ObjectBlob.ValueData
                 FROM Object
                       INNER JOIN ObjectBlob ON ObjectId = Object.Id
                 WHERE Object.DescId    = zc_Object_Form()
                   AND Object.ValueData ILIKE ('%' || CASE WHEN inReportName ILIKE '%_70_70%' THEN 'ШАБЛОН + ТМ ВАРТО (Варус) - Український_70_70' ELSE '' END|| '.Sticker%')
                 ORDER BY Object.Id
                 LIMIT 1
                ) AS tmp_find
           WHERE ObjectId = vbId AND DescId =zc_objectBlob_form_Data()
          ;
       ELSE
           -- сохранили <Объект>
           vbId:= lpInsertUpdate_Object (0, zc_Object_Form(), 0, inReportName);
           
           -- сохранили <Объект>
           INSERT INTO ObjectBlob (DescId, ObjectId, ValueData )
             SELECT zc_objectBlob_form_Data(), vbId , ObjectBlob.ValueData
             FROM Object
                   INNER JOIN ObjectBlob ON ObjectId = Object.Id
             WHERE Object.DescId    = zc_Object_Form()
               AND Object.ValueData ILIKE ('%' || CASE WHEN inReportName ILIKE '%_70_70%' THEN 'ШАБЛОН + ТМ ВАРТО (Варус) - Український_70_70' ELSE '' END|| '.Sticker%')
             ORDER BY Object.Id
             LIMIT 1
            ;
       END IF;

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
