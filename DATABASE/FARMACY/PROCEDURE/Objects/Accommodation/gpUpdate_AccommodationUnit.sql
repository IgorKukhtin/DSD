-- Function: gpUpdate_AccommodationUnit()

DROP FUNCTION IF EXISTS gpUpdate_AccommodationUnit (Integer, Integer, TVarChar, TVarChar);



CREATE OR REPLACE FUNCTION gpUpdate_AccommodationUnit(
    IN inGoodsId               Integer   ,  -- ключ объекта <Товар> 
    IN inUnitId                Integer   ,  -- ключ объекта <Подразделение> 
    IN inAccommodationName     TVarChar  ,  -- Название места
    IN inSession               TVarChar     -- сессия пользователя
)
  RETURNS VOID 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccommodationId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);    
    
    IF COALESCE (inGoodsId, 0) = 0 
    THEN
        RAISE EXCEPTION 'Не заполнен медикамент';
    END IF;
    
    IF COALESCE (TRIM(inAccommodationName), '') <> ''
    THEN
    
    
      IF NOT Exists( SELECT Object_Accommodation.Id               AS AccommodationID
                     FROM Object AS Object_Accommodation

                         INNER JOIN ObjectLink AS ObjectLink_Accommodation_Unit
                                               ON ObjectLink_Accommodation_Unit.ChildObjectId = inUnitId
                                              AND ObjectLink_Accommodation_Unit.ObjectId = Object_Accommodation.Id
                                              AND ObjectLink_Accommodation_Unit.DescId = zc_Object_Accommodation_Unit()

                     WHERE Object_Accommodation.DescId = zc_Object_Accommodation()
                       AND upper(TRIM(Object_Accommodation.ValueData)) = upper(TRIM(inAccommodationName))) 
      THEN
          RAISE EXCEPTION 'Код размещения товара не найден или принаждежит другой аптеке';
      END IF;

      SELECT Object_Accommodation.Id               AS AccommodationID
      INTO vbAccommodationID
      FROM Object AS Object_Accommodation

           INNER JOIN ObjectLink AS ObjectLink_Accommodation_Unit
                                 ON ObjectLink_Accommodation_Unit.ChildObjectId = inUnitId
                                AND ObjectLink_Accommodation_Unit.ObjectId = Object_Accommodation.Id
                                AND ObjectLink_Accommodation_Unit.DescId = zc_Object_Accommodation_Unit()

      WHERE Object_Accommodation.DescId = zc_Object_Accommodation()
        AND upper(TRIM(Object_Accommodation.ValueData)) = upper(TRIM(inAccommodationName));
                  
      IF NOT EXISTS (SELECT * FROM AccommodationLincGoods WHERE UnitId = inUnitId
                                                            AND GoodsId = inGoodsId
                                                            AND AccommodationId = vbAccommodationID
                                                            AND isErased = False)
      THEN
     
          -- Если связь есть
        IF EXISTS (SELECT * FROM AccommodationLincGoods WHERE UnitId = inUnitId
                                                          AND GoodsId = inGoodsId)
        THEN
          UPDATE AccommodationLincGoods SET AccommodationId = vbAccommodationID, UserUpdateId = vbUserId, DateUpdate = CURRENT_TIMESTAMP, isErased = False
          WHERE UnitId = inUnitId
            AND GoodsId = inGoodsId;
        ELSE
            -- сохранили связь с <Медикаментом>
          INSERT INTO AccommodationLincGoods (AccommodationId, UnitId, GoodsId, UserUpdateId, DateUpdate, isErased)
          VALUES (vbAccommodationID, inUnitId, inGoodsId, vbUserId, CURRENT_TIMESTAMP, False);
        END IF;

        -- Сохранили протокол
        PERFORM gpInsert_AccommodationLincGoodsLog(inUnitID           := inUnitId
                                                 , inGoodsId          := inGoodsId
                                                 , inAccommodationId  := vbAccommodationID
                                                 , inisErased         := False
                                                 , inSession          := inSession);    
      END IF;
       
    ELSE
        -- Удаляем связь с <Медикаментом> если есть
      IF EXISTS (SELECT * FROM AccommodationLincGoods WHERE UnitId = inUnitId
                                                        AND GoodsId = inGoodsId
                                                        AND isErased = False)
      THEN
        UPDATE AccommodationLincGoods SET UserUpdateId = vbUserId, DateUpdate = CURRENT_TIMESTAMP, isErased = True
        WHERE UnitId = inUnitId
          AND GoodsId = inGoodsId;

        -- Сохранили протокол
        PERFORM gpInsert_AccommodationLincGoodsLog(inUnitID           := AccommodationLincGoods.UnitId
                                                 , inGoodsId          := AccommodationLincGoods.GoodsId
                                                 , inAccommodationId  := AccommodationLincGoods.AccommodationID
                                                 , inisErased         := True
                                                 , inSession          := inSession)
        FROM AccommodationLincGoods
        WHERE AccommodationLincGoods.UnitId = inUnitId
          AND AccommodationLincGoods.GoodsId = inGoodsId;    

      END IF;    
    END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 21.08.18         *
*/