-- Function: gpGet_MySQL_Site_Param()

DROP FUNCTION IF EXISTS gpGet_MySQL_Site_Param (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MySQL_Site_Param(
    OUT outHost TVarChar,
    OUT outPort Integer,
    OUT outDataBase TVarChar,
    OUT outUsername TVarChar,
    OUT outPassword TVarChar,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Send());
    vbUserId := inSession;
    
    outHost := '172.17.2.13';
    outPort := 3306;
    outDataBase := 'neboley';
    outUsername := 'neboley';
    outPassword := 'H4i7Lohx';
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.09.21                                                       *  
*/

-- тест
-- 
SELECT * FROM gpGet_MySQL_Site_Param (inSession:= '3')

