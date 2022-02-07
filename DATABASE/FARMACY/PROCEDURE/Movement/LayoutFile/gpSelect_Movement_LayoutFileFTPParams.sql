-- Function: gpSelect_Movement_LayoutFileFTPParams(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Movement_LayoutFileFTPParams(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_LayoutFileFTPParams(
     IN inID           Integer,
    OUT outHost        TVarChar,
    OUT outPort        Integer,
    OUT outUsername    TVarChar,
    OUT outPassword    TVarChar,
    OUT outDir         TVarChar,
    OUT outFileNameFTP TVarChar,
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS RECORD 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

    IF COALESCE (inID, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Загружать файлы можно только после сохранения документа.';
    END IF;

    outHost := 'ftp.neboley.dp.ua';
    outPort := 13021;
    outUsername := 'instruction';
    outPassword := 'lhu1xHqoi21I2qsG';
    outDir := '';
    outFileNameFTP := 'LayoutFile_'||inID::Integer;
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.02.22                                                       *              

*/

-- тест
-- SELECT * FROM gpSelect_Movement_LayoutFileFTPParams(26734892, '3')