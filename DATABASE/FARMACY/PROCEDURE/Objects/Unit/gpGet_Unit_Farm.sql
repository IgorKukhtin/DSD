-- Function: gpGet_Unit_Farm()

DROP FUNCTION IF EXISTS gpGet_Unit_Farm (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Unit_Farm(
    IN inUnitId        Integer  ,  -- Подразделение
    IN inIsFarm        Boolean,    -- 
   OUT outUnitId       Integer  ,  -- Подразделение
   OUT outUnitName     TVarChar ,  -- Подразделение
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!меняем параметр!!!
     IF inIsFarm = TRUE THEN inUnitId:= zfConvert_StringToNumber (COALESCE (lpGet_DefaultValue ('zc_Object_Unit', vbUserId), ''));
     END IF;

     SELECT Id, ValueData INTO outUnitId, outUnitName FROM Object WHERE Id = inUnitId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.02.17                        *
*/

-- тест
-- SELECT * FROM gpGet_Unit_Farm (inUnitId:= 0, inIsFarm:= TRUE, inSession:= '3')
