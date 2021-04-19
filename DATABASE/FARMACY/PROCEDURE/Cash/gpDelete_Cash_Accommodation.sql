-- Function: gpDelete_Cash_Accommodation()

DROP FUNCTION IF EXISTS gpDelete_Cash_Accommodation (Integer, TVarChar);



CREATE OR REPLACE FUNCTION gpDelete_Cash_Accommodation(
    IN inGoodsId               Integer   ,  -- ключ объекта <Товар> 
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
    
    
    IF COALESCE (inGoodsId, 0) = 0 THEN
        RAISE EXCEPTION 'Не заполнен медикамент';
    END IF;
    
      -- Удаляем связь с <Медикаментом> если есть
    IF EXISTS (SELECT * FROM AccommodationLincGoods WHERE UnitId = vbUnitId
                                                      AND GoodsId = inGoodsId)
    THEN
      UPDATE AccommodationLincGoods SET UserUpdateId = vbUserId, DateUpdate = CURRENT_TIMESTAMP, isErased = True
      WHERE UnitId = vbUnitId
        AND GoodsId = inGoodsId;
    END IF;
          
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 27.08.18         *
*/
