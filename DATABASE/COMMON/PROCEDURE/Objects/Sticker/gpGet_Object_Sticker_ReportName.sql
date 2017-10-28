-- Function: gpGet_Object_Sticker_ReportName()

DROP FUNCTION IF EXISTS gpGet_Object_Sticker_ReportName (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Object_Sticker_ReportName (
    IN inObjectId           Integer  , -- ключ спарвочника
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbStickerFileName TVarChar;
BEGIN
       -- проверка прав пользователя на вызов процедуры
       -- PERFORM lpCheckRight (inSession, zc_Enum_Process_...());

     vbStickerFileName := (SELECT Object_StickerFile.ValueData      AS StickerFileName
                           FROM Object AS Object_StickerProperty 
                                LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_Sticker
                                                     ON ObjectLink_StickerProperty_Sticker.ObjectId = Object_StickerProperty.Id
                                                    AND ObjectLink_StickerProperty_Sticker.DescId = zc_ObjectLink_StickerProperty_Sticker()
  
                                LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerFile
                                                     ON ObjectLink_StickerProperty_StickerFile.ObjectId = Object_StickerProperty.Id 
                                                    AND ObjectLink_StickerProperty_StickerFile.DescId = zc_ObjectLink_StickerProperty_StickerFile()
  
                                LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerFile
                                                     ON ObjectLink_Sticker_StickerFile.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                    AND ObjectLink_Sticker_StickerFile.DescId = zc_ObjectLink_Sticker_StickerFile()
                                                    
                                LEFT JOIN Object AS Object_StickerFile ON Object_StickerFile.Id = COALESCE (ObjectLink_StickerProperty_StickerFile.ChildObjectId, ObjectLink_Sticker_StickerFile.ChildObjectId)
                           WHERE Object_StickerProperty.Id = inObjectId
                          );

     IF COALESCE (vbStickerFileName, '') = '' 
     THEN 
          RAISE EXCEPTION 'Ошибка.Шаблон не установлен';
     END IF;
     /*
       -- поиск формы
       SELECT COALESCE (PrintForms_View.PrintFormName, 'PrintObject_Sticker')
              INTO vbPrintFormName
       FROM Object AS Object_Sticker
            LEFT JOIN PrintForms_View ON PrintForms_View.DescId = Object_Sticker.DescId
       WHERE Object_Sticker.Id = inObjectId
       ;
*/
       -- Результат
       RETURN (vbStickerFileName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 26.10.17         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Sticker_ReportName (inObjectId:= 1005830 , inSession:= '5'); -- все
