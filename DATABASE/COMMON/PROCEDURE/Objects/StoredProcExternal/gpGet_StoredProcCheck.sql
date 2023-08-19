-- Function: gpGet_StoredProcCheck()

DROP FUNCTION IF EXISTS gpGet_StoredProcCheck (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_StoredProcCheck(
    IN inStoredProc   TVarChar , -- Название процедуры
    IN inParam1       TVarChar , -- Название параметра
    IN inValue1       TVarChar , -- Параметр
    IN inParam2       TVarChar , -- Название параметра
    IN inValue2       TVarChar , -- Параметр
    IN inParam3       TVarChar , -- Название параметра
    IN inValue3       TVarChar , -- Параметр
    IN inParam4       TVarChar , -- Название параметра
    IN inValue4       TVarChar , -- Параметр
    IN inParam5       TVarChar , -- Название параметра
    IN inValue5       TVarChar , -- Параметр
    IN inParam6       TVarChar , -- Название параметра
    IN inValue6       TVarChar , -- Параметр
    IN inParam7       TVarChar , -- Название параметра
    IN inValue7       TVarChar , -- Параметр
    IN inParam8       TVarChar , -- Название параметра
    IN inValue8       TVarChar , -- Параметр
    IN inParam9       TVarChar , -- Название параметра
    IN inValue9       TVarChar , -- Параметр
    IN inParam10      TVarChar , -- Название параметра
    IN inValue10      TVarChar , -- Параметр
    IN inSession      TVarChar   -- сессия пользователя
)
RETURNS BOOLEAN
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      vbUserId:= lpGetUserBySession (inSession);
      
      RETURN False;
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
  18.08.23                                                      *
*/

-- тест
-- 
SELECT * FROM gpGet_StoredProcCheck (inStoredProc := 'gpSelect_Movement_Income', inParam1 := 'inStartDate', inValue1 := '25.07.2023', inParam2 := 'inEndDate', inValue2 := '25.07.2023', inParam3 := 'inIsErased', inValue3 := 'False', inParam4 := 'inJuridicalBasisId', inValue4 := '9399', inParam5 := '', inValue5 := '', inParam6 := '', inValue6 := '', inParam7 := '', inValue7 := '', inParam8 := '', inValue8 := '', inParam9 := '', inValue9 := '', inParam10 := '', inValue10 := '', inSession:= zfCalc_UserAdmin())
