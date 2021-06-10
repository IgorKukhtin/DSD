 -- Function: lpInsertUpdate_Object_PriceSite (Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PriceSite (Integer, TFloat, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_PriceSite(
    IN inGoodsId        Integer  , -- ИД товара
    IN inPrice          tFloat,    -- Цена
    IN inDate           TDateTime, -- Дата документа
    IN inUserId         Integer    -- пользователь
)
RETURNS VOID
AS
$BODY$
    DECLARE vbId Integer;
    DECLARE vbPrice_Value TFloat;
    DECLARE vbDateChange TDateTime;

    -- DECLARE vbOperDate_StartBegin1 TDateTime;
    DECLARE vbOperDate_StartBegin2 TDateTime;
BEGIN

   -- Если такая запись есть - достаем её ключу подр.-товар
   SELECT Price_Goods.ObjectId                     AS Id
        , ROUND(Price_Value.ValueData,2)::TFloat   AS Price_Value
        , Price_DateChange.valuedata               AS DateChange
          INTO vbId
             , vbPrice_Value
             , vbDateChange
   FROM ObjectLink AS Price_Goods
        LEFT JOIN ObjectFloat AS Price_Value
                               ON Price_Value.ObjectId = Price_Goods.ObjectId
                              AND Price_Value.DescId   = zc_ObjectFloat_PriceSite_Value()
        LEFT JOIN ObjectDate AS Price_DateChange
                             ON Price_DateChange.ObjectId = Price_Goods.ObjectId
                            AND Price_DateChange.DescId   = zc_ObjectDate_PriceSite_DateChange()
   WHERE Price_Goods.DescId        = zc_ObjectLink_PriceSite_Goods()
     AND Price_Goods.ChildObjectId = inGoodsId;

    IF COALESCE(inPrice, 0) = COALESCE(vbPrice_Value, 0)
    THEN
      RETURN;
    END IF;

    IF COALESCE(vbId,0)=0
    THEN
        -- сохранили/получили <Объект> по ИД
        vbId := lpInsertUpdate_Object (vbId, zc_Object_PriceSite(), 0, '');

        -- сохранили связь с <товар>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceSite_Goods(), vbId, inGoodsId);

    END IF;

    -- сохранили св-во <Цена>
    PERFORM lpInsertUpdate_objectFloat (zc_ObjectFloat_PriceSite_Value(), vbId, inPrice);


    -- сохранили историю
    PERFORM gpInsertUpdate_ObjectHistory_PriceSite
                  (ioId           := 0                           :: Integer     -- ключ объекта <Элемент истории прайса>
                 , inPriceSiteId  := vbId                                       -- Прайс
                 , inOperDate     := CURRENT_TIMESTAMP           :: TDateTime   -- Дата действия прайса
                 , inPrice        := inPrice                     :: TFloat      -- Цена
                 , inSession      := inUserId :: TVarChar
                  );

    -- сохранили св-во < Дата изменения >
    PERFORM lpInsertUpdate_objectDate (zc_ObjectDate_PriceSite_DateChange(), vbId, inDate);

    -- сохранили протокол - !!!ВРЕМЕННО-вкл.
    PERFORM lpInsert_ObjectProtocol (vbId, inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.06.21                                                       *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Object_PriceSite (inGoodsId := 1, inUnitId := 1, inPrice := 10.0, inUserId := 3)
