-- Function: gpGet_Movement_IncomePharmacy_Visible()

DROP FUNCTION IF EXISTS gpGet_Movement_IncomePharmacy_Visible (TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_IncomePharmacy_Visible(
   OUT outisVisiableTotalSumm  BOOLEAN,  
    IN inSession               TVarChar   -- сессия пользователя
)
RETURNS  Boolean
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitKey TVarChar;
  DECLARE vbUnitId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);
     vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;
     vbUnitId := vbUnitKey::Integer;

    outisVisiableTotalSumm := vbUnitId = 394426;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_IncomePharmacy_Visible (TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.08.22                                                       *
*/

-- тест
-- SELECT * FROM gpGet_Movement_IncomePharmacy_Visible (inSession:= '9818')