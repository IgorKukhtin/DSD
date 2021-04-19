-- Function: gpDelete_Cash_Accommodation()

DROP FUNCTION IF EXISTS gpDelete_Cash_AccommodationAllId (Integer, TVarChar);



CREATE OR REPLACE FUNCTION gpDelete_Cash_AccommodationAllId(
    IN inAccommodationId       Integer   ,  -- ключ объекта <Код привязки> 
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
    
    
    IF COALESCE (inAccommodationId, 0) = 0 THEN
        RAISE EXCEPTION 'Не заполнен Код привязки';
    END IF;
    
      -- Удаляем связь с <Медикаментом> если есть
    IF EXISTS (SELECT * FROM AccommodationLincGoods WHERE UnitId = vbUnitId
                                                      AND AccommodationId = inAccommodationId)
    THEN
      UPDATE AccommodationLincGoods SET UserUpdateId = vbUserId, DateUpdate = CURRENT_TIMESTAMP, isErased = True
      WHERE UnitId = vbUnitId
        AND AccommodationId = inAccommodationId;
    END IF;
          
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 08.05.19         *
*/
