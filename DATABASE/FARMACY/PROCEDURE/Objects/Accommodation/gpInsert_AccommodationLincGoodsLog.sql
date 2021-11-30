-- Function: gpInsert_AccommodationLincGoodsLog()

DROP FUNCTION IF EXISTS gpInsert_AccommodationLincGoodsLog (Integer, Integer, Integer, Boolean, TVarChar);



CREATE OR REPLACE FUNCTION gpInsert_AccommodationLincGoodsLog(
    IN inUnitID                Integer   ,  -- ключ объекта <Аптека> 
    IN inGoodsId               Integer   ,  -- ключ объекта <Товар> 
    IN inAccommodationId       Integer   ,  -- ключ объекта <Место> 
    IN inisErased              Boolean   ,  -- Удалено
    IN inSession               TVarChar     -- сессия пользователя
)
  RETURNS VOID 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);
    
        -- сохранили протокол
    INSERT INTO AccommodationLincGoodsLog (OperDate, UserId, UnitId, GoodsId, AccommodationId, isErased)
    VALUES (CURRENT_TIMESTAMP, vbUserId, inUnitID, inGoodsId, inAccommodationId, inisErased);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 30.11.21                                                       *
*/