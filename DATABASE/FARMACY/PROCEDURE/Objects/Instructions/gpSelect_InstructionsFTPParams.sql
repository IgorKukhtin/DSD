-- Function: gpSelect_InstructionsFTPParams(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_InstructionsFTPParams(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_InstructionsFTPParams(
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
        RAISE EXCEPTION 'Ошибка. Загружать файлы можно только после сохранения инструкции.';
    END IF;

    outHost := 'ftp.neboley.dp.ua';
    outPort := 13021;
    outUsername := 'instruction';
    outPassword := 'lhu1xHqoi21I2qsG';
    outDir := '';
    outFileNameFTP := 'Instruction_'||inID::Integer;
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.02.21                                                       *              

*/

-- тест
-- SELECT * FROM gpSelect_InstructionsFTPParams(0133, '3')