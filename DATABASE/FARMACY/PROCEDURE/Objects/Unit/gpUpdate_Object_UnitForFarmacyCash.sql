-- Function: gpUpdate_Object_UnitForFarmacyCash()

DROP FUNCTION IF EXISTS gpUpdate_Object_UnitForFarmacyCash (TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_UnitForFarmacyCash(
    IN inAmount     TFloat    ,    -- сколько чеков еще не перенеслось
    IN inSession    TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_...());
    vbUserId := lpGetUserBySession (inSession);

    -- нашли аптеку
    vbUnitId:= zfConvert_StringToNumber (lpGet_DefaultValue ('zc_Object_Unit', vbUserId));

    IF vbUnitId > 0
    THEN
        -- сохранили <Пользователь последнего сеанса с FarmacyCash >
        PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_UserFarmacyCash(), vbUnitId, vbUserId);
        -- сохранили <Дата/время последнего сеанса с FarmacyCash>
        PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_FarmacyCash(), vbUnitId, CURRENT_TIMESTAMP);
        -- сохранили <кол-во данных в синхронизации с FarmacyCash>
        PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Unit_TaxService(), vbUnitId, inAmount);
    END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.06.16                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_UnitForFarmacyCash ()                            
