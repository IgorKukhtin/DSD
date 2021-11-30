-- Function: gpDelete_Cash_AccommodationAll()

DROP FUNCTION IF EXISTS gpDelete_Cash_AccommodationAll (TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Cash_AccommodationAll(
    IN inSession               TVarChar     -- сессия пользователя
)
  RETURNS Void 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
        RAISE EXCEPTION 'Не определено подразделение';
    END IF;
    vbUnitId := vbUnitKey::Integer;
    
    
      -- Удаляем связь с <Медикаментом> если есть
    IF EXISTS (SELECT * FROM AccommodationLincGoods WHERE UnitId = vbUnitId)
    THEN
      UPDATE AccommodationLincGoods SET UserUpdateId = vbUserId, DateUpdate = CURRENT_TIMESTAMP, isErased = True
      WHERE UnitId = vbUnitId;

      -- Сохранили протокол
      PERFORM gpInsert_AccommodationLincGoodsLog(inUnitID           := AccommodationLincGoods.UnitId
                                               , inGoodsId          := AccommodationLincGoods.GoodsId
                                               , inAccommodationId  := AccommodationLincGoods.AccommodationID
                                               , inisErased         := AccommodationLincGoods.isErased
                                               , inSession          := inSession)
      FROM AccommodationLincGoods
      WHERE AccommodationLincGoods.UnitId = vbUnitId;    

    END IF;
          
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 08.05.19         *
*/