-- Function: gpInsertUpdate_ObjectHistory_PriceListItem_sybase

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListItem_sybase (Integer, Integer, Integer, TDateTime, TDateTime, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceListItem_sybase(
 INOUT ioId                     Integer,    -- ключ объекта <Элемент ИСТОРИИ>
    IN inPriceListId            Integer,    -- Прайс-лист
    IN inGoodsId                Integer,    -- Товар
    IN inStartDate              TDateTime,  -- Дата действия цены
    IN inEndDate                TDateTime,  -- Дата действия цены
    IN inValue                  TFloat,     -- Цена
    IN inIsLast                 Boolean,    -- 
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
DECLARE
   DECLARE vbItemId Integer;
BEGIN
   -- !!!меняем значение!!!
   IF inIsLast = TRUE
   THEN 
        -- Ищем ioId - за тот же день, т.е. StartDate = inStartDate
        ioId:= (SELECT ObjectHistory.Id FROM ObjectHistory WHERE ObjectHistory.DescId = zc_ObjectHistory_PriceListItem()
                                                             AND ObjectHistory.ObjectId = vbItemId AND ObjectHistory.StartDate = inStartDate);
        --
        SELECT tmp.ioId INTO ioId
        FROM gpInsertUpdate_ObjectHistory_PriceListItemLast (ioId          := ioId
                                                           , inPriceListId := inPriceListId
                                                           , inGoodsId     := inGoodsId
                                                           , inOperDate    := inStartDate
                                                           , inValue       := inValue
                                                           , inIsLast      := inIsLast
                                                           , inSession     := inSession
                                                            ) AS tmp;
   ELSE
        -- Поиск <Элемент>
        vbItemId:= lpGetInsert_Object_PriceListItem (inPriceListId, inGoodsId, inSession :: Integer);
        
        -- Ищем ioId - за inEndDate
        ioId:= (SELECT ObjectHistory.Id FROM ObjectHistory WHERE ObjectHistory.DescId = zc_ObjectHistory_PriceListItem() AND ObjectHistory.ObjectId = vbItemId AND ObjectHistory.EndDate = inEndDate);

        IF ioId > 0
        THEN
            -- Проверка inValue
            IF NOT EXISTS (SELECT ValueData FROM ObjectHistoryFloat WHERE DescId = zc_ObjectHistoryFloat_PriceListItem_Value() AND ObjectHistoryId = ioId AND ValueData = inValue)
            THEN
                RAISE EXCEPTION 'NOT EXISTS VALUE on EndDate <%> <%>', inValue, (SELECT ValueData FROM ObjectHistoryFloat WHERE DescId = zc_ObjectHistoryFloat_PriceListItem_Value() AND ObjectHistoryId = ioId);
            END IF;

            -- оставляем inStartDate
            inStartDate:= (SELECT (tmp.StartDate) FROM (SELECT StartDate FROM ObjectHistory WHERE Id = ioId /*UNION SELECT inStartDate AS StartDate*/) AS tmp);
            
        ELSE
            -- Ищем ioId - за тот же день, т.е. StartDate = inStartDate
            ioId:= (SELECT ObjectHistory.Id FROM ObjectHistory WHERE ObjectHistory.DescId = zc_ObjectHistory_PriceListItem() AND ObjectHistory.ObjectId = vbItemId AND ObjectHistory.StartDate = inStartDate);

            IF ioId > 0
            THEN
                -- Проверка inValue
                IF NOT EXISTS (SELECT ValueData FROM ObjectHistoryFloat WHERE DescId = zc_ObjectHistoryFloat_PriceListItem_Value() AND ObjectHistoryId = ioId AND ValueData = inValue)
                THEN
                    RAISE EXCEPTION 'NOT EXISTS VALUE on StartDate <%> <%>', inValue, (SELECT ValueData FROM ObjectHistoryFloat WHERE DescId = zc_ObjectHistoryFloat_PriceListItem_Value() AND ObjectHistoryId = ioId);
                END IF;
    
                -- оставляем inEndDate
                inEndDate:= (SELECT (tmp.EndDate) FROM (SELECT EndDate FROM ObjectHistory WHERE Id = ioId /*UNION SELECT inEndDate AS EndDate*/) AS tmp);
            END IF; 

        END IF; 


        IF COALESCE (ioId, 0) = 0
        THEN
           -- дабавили текущий элемент: <ключ класса объекта> , <код объекта> , <данные> и вернули значение <ключа>
           INSERT INTO ObjectHistory (DescId, ObjectId, StartDate, EndDate)
                  VALUES (zc_ObjectHistory_PriceListItem(), vbItemId, inStartDate, inEndDate) RETURNING Id INTO ioId;
        ELSE
           -- изменили текущий элемент по значению <ключа>: <код объекта>, <данные>
           UPDATE ObjectHistory SET StartDate = inStartDate, EndDate = inEndDate, ObjectId = vbItemId WHERE Id = ioId;
           IF NOT FOUND THEN
              RAISE EXCEPTION 'NOT FOUND';
           END IF;
        END IF;

        -- Сохранили цену
        PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceListItem_Value(), ioId, inValue);

        -- сохранили протокол
        PERFORM lpInsert_ObjectHistoryProtocol (inObjectId:= vbItemId, inUserId:= inSession :: Integer, inStartDate:= inStartDate, inEndDate:= inEndDate, inPrice:= inValue, inIsUpdate:= TRUE, inIsErased:= FALSE);

   END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 20.08.15         * lpInsert_ObjectHistoryProtocol
 09.12.14                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_ObjectHistory_PriceListItem_sybase (ioId:= 0, inPriceListId:= 1154, inGoodsId:= 45766, inStartDate:= '06.03.2011', inEndDate:= '14.08.2011', inValue:= 90, inIsLast:= FALSE, inSession:= zfCalc_UserAdmin());
