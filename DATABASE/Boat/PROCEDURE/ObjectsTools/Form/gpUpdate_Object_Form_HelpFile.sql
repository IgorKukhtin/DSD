-- Function: gpUpdate_Object_Form_HelpFile()

-- DROP FUNCTION gpUpdate_Object_Form_HelpFile();

CREATE OR REPLACE FUNCTION gpUpdate_Object_Form_HelpFile(
    IN inFormName    TVarChar  ,    -- главное Название объекта <Форма> 
    IN inHelpFile    TVarChar  ,    -- Путь к файлу помощи
    IN inSession     TVarChar       -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE Id integer;
   DECLARE vbUserId Integer;
BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Forms());
 
    -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
   
    SELECT Object.Id INTO Id 
    FROM Object 
    WHERE DescId = zc_Object_Form() AND ValueData = inFormName;

    IF COALESCE(Id, 0) = 0 THEN
        --RAISE EXCEPTION 'Ошибка! Элемент справочника не сохранен.';
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка! Элемент справочника не сохранен.' :: TVarChar
                                              , inProcedureName := 'gpUpdate_Object_Form_HelpFile' :: TVarChar
                                              , inUserId        := vbUserId
                                              );
    END IF;

    PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Form_HelpFile(), Id, inHelpFile);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpUpdate_Object_Form_HelpFile(TVarChar, TVarChar, TVarChar)
  OWNER TO postgres;
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 16.12.15                                                                      *
*/  