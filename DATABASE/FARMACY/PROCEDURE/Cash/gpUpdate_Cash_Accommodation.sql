-- Function: gpUpdate_Cash_Accommodation()

DROP FUNCTION IF EXISTS gpUpdate_Cash_Accommodation (Integer, Integer, TVarChar, TVarChar);



CREATE OR REPLACE FUNCTION gpUpdate_Cash_Accommodation(
    IN inGoodsId               Integer   ,  -- ключ объекта <Товар> 
 INOUT ioAccommodationID       Integer   ,  -- Код места
 INOUT ioAccommodationName     TVarChar  ,  -- Название места
    IN inSession               TVarChar     -- сессия пользователя
)
  RETURNS RECORD 
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
    
    IF COALESCE (ioAccommodationID, 0) = 0 THEN
        RAISE EXCEPTION 'Не заполнен код размещения товара';
    END IF;

    IF NOT Exists(SELECT ObjectId FROM ObjectLink AS ObjectLink_Accommodation_Unit
                  WHERE ObjectLink_Accommodation_Unit.ChildObjectId = vbUnitId
                    AND ObjectLink_Accommodation_Unit.ObjectId = ioAccommodationID 
                    AND ObjectLink_Accommodation_Unit.DescId = zc_Object_Accommodation_Unit()) THEN
        RAISE EXCEPTION 'Код размещения товара не найден или принаждежит другой аптеке';
    END IF;

      -- Если связь есть
    IF EXISTS (SELECT * FROM AccommodationLincGoods WHERE UnitId = vbUnitId
                                                      AND GoodsId = inGoodsId)
    THEN
      UPDATE AccommodationLincGoods SET AccommodationId = ioAccommodationID, UserUpdateId = vbUserId, DateUpdate = CURRENT_TIMESTAMP, isErased = False
      WHERE UnitId = vbUnitId
        AND GoodsId = inGoodsId;
    ELSE
        -- сохранили связь с <Медикаментом>
      INSERT INTO AccommodationLincGoods (AccommodationId, UnitId, GoodsId, UserUpdateId, DateUpdate, isErased)
      VALUES (ioAccommodationID, vbUnitId, inGoodsId, vbUserId, CURRENT_TIMESTAMP, False);
    END IF;
   
    SELECT 
      ValueData
    INTO
      ioAccommodationName
    FROM Object
    WHERE ID = ioAccommodationID;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 21.08.18         *
*/
