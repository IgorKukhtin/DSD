-- Function: gpSelect_LoadFReportFTPParams_cash(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_LoadFReportFTPParams_cash(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_LoadFReportFTPParams_cash(
    OUT outHost TVarChar,
    OUT outPort Integer,
    OUT outUsername TVarChar,
    OUT outPassword TVarChar,
    OUT outDaysStorage Integer,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS RECORD 
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_DiffKind());

    outHost := '134.249.138.177';
    outPort := 12021;
    outUsername := 'zreport';
    outPassword := 'ZAaYuMuDg3bv9ZHF';
    outDaysStorage := 31;
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.12.18                                                       *              

*/

-- тест
-- SELECT * FROM gpSelect_LoadFReportFTPParams_cash('3')