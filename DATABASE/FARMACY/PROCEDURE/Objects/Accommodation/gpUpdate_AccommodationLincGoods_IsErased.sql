-- Function: gpUpdate_AccommodationLincGoods_IsErased (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_AccommodationLincGoods_IsErased (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_AccommodationLincGoods_IsErased(
    IN inUnitId                Integer   ,  -- ключ объекта <Подразделение> 
    IN inGoodsId               Integer   ,  -- ключ объекта <Товар> 
    IN inSession               TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- НЕТ проверки прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (inUnitId, 0) = 0 OR  COALESCE (inGoodsId, 0) = 0
    THEN
        RAISE EXCEPTION 'Не заполнен медикамент или подразделение';
    END IF;
    
      -- Удаляем связь с <Медикаментом> если есть
    IF EXISTS (SELECT * FROM AccommodationLincGoods WHERE UnitId = inUnitId
                                                      AND GoodsId = inGoodsId)
    THEN
      UPDATE AccommodationLincGoods SET UserUpdateId = vbUserId, DateUpdate = CURRENT_TIMESTAMP, isErased = NOT isErased
      WHERE UnitId = inUnitId
        AND GoodsId = inGoodsId;

      -- Сохранили протокол
      PERFORM gpInsert_AccommodationLincGoodsLog(inUnitID           := AccommodationLincGoods.UnitId
                                               , inGoodsId          := AccommodationLincGoods.GoodsId
                                               , inAccommodationId  := AccommodationLincGoods.AccommodationID
                                               , inisErased         := AccommodationLincGoods.isErased
                                               , inSession          := inSession)
      FROM AccommodationLincGoods
      WHERE AccommodationLincGoods.UnitId = inUnitId
        AND AccommodationLincGoods.GoodsId = inGoodsId;    
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_AccommodationLincGoods_IsErased (Integer, Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 19.04.21                                                      * 
*/