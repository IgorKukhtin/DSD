-- Function: gpUpdate_Object_Form_HelpFile()

-- DROP FUNCTION gpUpdate_Object_Form_HelpFile();

CREATE OR REPLACE FUNCTION gpUpdate_Object_Form_HelpFile(
    IN inFormName    TVarChar  ,    -- главное Название объекта <Форма> 
    IN inHelpFile    TVarChar  ,    -- Путь к файлу помощи
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
DECLARE vbId integer;
BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Forms());
   
    vbId:= (SELECT Object.Id FROM Object WHERE DescId = zc_Object_Form() AND ValueData = inFormName);

    IF COALESCE (vbId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка! Форма не найдена <%>.', inFormName;
    END IF;

    PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Form_HelpFile(), vbId, inHelpFile);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 16.12.15                                                                      *
*/  

-- тест
-- SELECT * FROM gpUpdate_Object_Form_HelpFile ('TMainForm', 'https://docs.google.com/document/d/1edc3L4KV2c0zKdUbuBOXRTXHJ1kS4Xv0HanVZhjl3-s/edit', '5')
