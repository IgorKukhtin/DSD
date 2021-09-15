-- Function: gpInsertUpdate_Object_Goods_MinimumLot()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_MinimumLot(Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_MinimumLot(TVarChar, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_MinimumLot(TVarChar, Integer, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_MinimumLot(
    IN inGoodsCode           TVarChar  ,    -- код объекта <Товар>
    IN inObjectId            Integer   ,    -- Ключ объекта <поставщик>
    IN inMinimumLot          TFloat    ,    -- Минимальное округление
    IN inAreaId              Integer   ,
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE text_var1 text;
   DECLARE vbMinimumLot TFloat;
BEGIN
    --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
    vbUserId := inSession;

    IF COALESCE(inObjectId,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Сначала выберите поставщика';
    END IF;
    IF COALESCE(inMinimumLot,0) < 0
    THEN
        RAISE EXCEPTION 'Ошибка.Минимальное округление <%> не может быть меньше нуля.', inMCSValue;
    END IF;
    
    
    IF COALESCE (inAreaId, 0) = 0 
    THEN
        inAreaId := zc_Area_Basis();      --Днепр
    END IF;
    
    IF inMinimumLot = 0 
    THEN 
        inMinimumLot := NULL;
    END IF;
    
    -- Ищем по коду и inObjectId  и регион    
    SELECT Object_Goods_View.Id, Object_Goods_View.MinimumLot 
    INTO vbGoodsId, vbMinimumLot
    FROM Object_Goods_View 
    WHERE Object_Goods_View.ObjectId = inObjectId
      AND Object_Goods_View.GoodsCode = inGoodsCode
      AND COALESCE (Object_Goods_View.AreaId, zc_Area_Basis()) = inAreaId;      -- zc_ObjectLink_Goods_Area = NULL, это значит что регион = Днепр = zc_Area_Basis() т.е. update эти товары тоже

    -- IF COALESCE(vbGoodsId,0) = 0
    -- THEN
        -- RAISE EXCEPTION 'Ошибка. В базе данных не найден товар с кодом <%>', inGoodsCode;
    -- END IF;
    IF COALESCE(vbGoodsId,0) <> 0
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Goods_MinimumLot(), vbGoodsId, inMinimumLot);    

        IF COALESCE(inMinimumLot,0) <> vbMinimumLot 
        THEN
           -- сохранили свойство <Дата корректировки>
          PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_UpdateMinimumLot(), vbGoodsId, CURRENT_TIMESTAMP);
          -- сохранили свойство <Пользователь (корректировка)>
          PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_UpdateMinimumLot(), vbGoodsId, vbUserId);
        END IF;

          -- Сохранили в плоскую таблицй
        BEGIN
          UPDATE Object_Goods_Juridical SET MinimumLot = NULLIF(inMinimumLot, 0)
                                          , UserUpdateId = vbUserId
                                          , DateUpdate   = CURRENT_TIMESTAMP
                                          , UserUpdateMinimumLotId = CASE WHEN COALESCE(inMinimumLot,0) <> vbMinimumLot THEN vbUserId ELSE UserUpdateMinimumLotId END
                                          , DateUpdateMinimumLot   = CASE WHEN COALESCE(inMinimumLot,0) <> vbMinimumLot THEN CURRENT_TIMESTAMP ELSE DateUpdateMinimumLot END
          WHERE Object_Goods_Juridical.Id = vbGoodsId
            AND COALESCE(Object_Goods_Juridical.MinimumLot, 0) <> COALESCE(inMinimumLot, 0);  
        EXCEPTION
           WHEN others THEN 
             GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
             PERFORM lpAddObject_Goods_Temp_Error('gpInsertUpdate_Object_Goods_MinimumLot', text_var1::TVarChar, vbUserId);
        END;
    END IF;
    
    -- сохранили протокол
    PERFORM lpInsert_ObjectProtocol (vbGoodsId, vbUserId);

END;
$BODY$
LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Шаблий О.В.
 03.03.20         * add Protocol - Любе нужно видеть когда есть изменения
 21.10.19                                                                      * 
 08.02.18         *
 15.08.15                                                          *

*/                                          

                                           