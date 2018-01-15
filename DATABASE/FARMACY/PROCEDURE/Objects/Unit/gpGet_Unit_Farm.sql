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
   DECLARE vbUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!меняем параметр!!!
     IF inIsFarm = TRUE THEN vbUnitId:= zfConvert_StringToNumber (COALESCE (lpGet_DefaultValue ('zc_Object_Unit', vbUserId), ''));
     END IF;
     
     IF COALESCE (vbUnitId, 0) = 0 THEN vbUnitId:= inUnitId; END IF;

     SELECT Id, ValueData INTO outUnitId, outUnitName FROM Object WHERE Id = COALESCE (vbUnitId, inUnitId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.01.17         *
 09.02.17                        *
*/

-- тест
-- SELECT * FROM gpGet_Unit_Farm (inUnitId:= 0, inIsFarm:= TRUE, inSession:= '3')
--select * from gpGet_Unit_Farm(inUnitId := 472116 , inIsFarm := 'True' ,  inSession := '183242');