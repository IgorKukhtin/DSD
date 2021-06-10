-- Function: gpInsertUpdate_Object_PriceSite (Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceSite (Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PriceSite(
 INOUT ioId                       Integer   ,    -- ключ объекта < Цена >
    IN inGoodsId                  Integer   ,    -- Товар
    IN inPrice                    TFloat    ,    -- цена
    IN inPercentMarkup            TFloat    ,    -- % наценки
    IN inFix                      Boolean   ,    -- Фиксированная цена
   OUT outDateChange              TDateTime ,    -- Дата изменения цены
   OUT outFixDateChange           TDateTime ,    -- Дата изменения признака "Фиксированная цена"
   OUT outPercentMarkupDateChange TDateTime ,    -- Дата изменения признака % наценки
   OUT outStartDate               TDateTime ,    -- Дата
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS record AS
$body$
    DECLARE
        vbUserId       Integer;
        vbPrice        TFloat;
        vbFix          Boolean;
        vbPercentMarkup TFloat;
        vbDate         TDateTime;
    DECLARE vbUpdateProtocol boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    -- проверили корректность цены
    IF COALESCE(inPrice, 0) <= 0
    THEN
        RAISE EXCEPTION 'Ошибка. Цена <%> должна быть больше 0.', inPrice;
    END IF;
        
    vbUpdateProtocol := False;
    
    -- Если такая запись есть - достаем её ключу подр.-товар
    SELECT Id, 
           Price, 
           Fix,
           PercentMarkup,
           DateChange
      INTO ioId, 
           vbPrice, 
           vbFix,
           vbPercentMarkup,
           outDateChange
    FROM (WITH tmp1 AS (SELECT Object_PriceSite.Id                                    AS Id
                             , ROUND(PriceSite_Value.ValueData,2)::TFloat             AS Price
                             , COALESCE(PriceSite_Fix.ValueData,False)                AS Fix
                             , COALESCE(PriceSite_PercentMarkup.ValueData, 0)::TFloat AS PercentMarkup
                             , PriceSite_datechange.valuedata                         AS DateChange
                           FROM Object AS Object_PriceSite
                               INNER JOIN ObjectLink AS PriceSite_Goods
                                                     ON PriceSite_Goods.ObjectId = Object_PriceSite.Id
                                                    AND PriceSite_Goods.DescId = zc_ObjectLink_PriceSite_Goods()
                                                    AND PriceSite_Goods.ChildObjectId = inGoodsId
                               LEFT JOIN ObjectFloat AS PriceSite_Value
                                                     ON PriceSite_Value.ObjectId = Object_PriceSite.Id
                                                    AND PriceSite_Value.DescId = zc_ObjectFloat_PriceSite_Value()
                               LEFT JOIN ObjectDate AS PriceSite_DateChange
                                                    ON PriceSite_DateChange.ObjectId = Object_PriceSite.Id
                                                   AND PriceSite_DateChange.DescId = zc_ObjectDate_PriceSite_DateChange()
                               LEFT JOIN ObjectBoolean AS PriceSite_Fix
                                                       ON PriceSite_Fix.ObjectId = Object_PriceSite.Id
                                                      AND PriceSite_Fix.DescId = zc_ObjectBoolean_PriceSite_Fix()
                               LEFT JOIN ObjectFloat AS PriceSite_PercentMarkup                                                   
                                                     ON PriceSite_PercentMarkup.ObjectId = Object_PriceSite.Id
                                                    AND PriceSite_PercentMarkup.DescId = zc_ObjectFloat_PriceSite_PercentMarkup()
                              WHERE  Object_PriceSite.DescId = zc_Object_PriceSite())
          SELECT  * FROM tmp1) AS tmp;
   
    IF COALESCE(ioId,0)=0
    THEN
        -- сохранили/получили <Объект> по ИД
        ioId := lpInsertUpdate_Object (ioId, zc_Object_PriceSite(), 0, '');

        -- сохранили связь с <товар>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceSite_Goods(), ioId, inGoodsId);

        vbUpdateProtocol := True;
    END IF;
    
    IF COALESCE(vbFix, False) <> COALESCE(inFix, FALSE)
    THEN
        -- сохранили свойство <фиксированная цена>
        PERFORM lpInsertUpdate_objectBoolean(zc_ObjectBoolean_PriceSite_Fix(), ioId, inFix);
        -- сохранили дату изменения <фиксированная цена>
        outFixDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_PriceSite_FixDateChange(), ioId, outFixDateChange);

        vbUpdateProtocol := True;
    END IF;    

    -- сохранили св-во < Цена >
    IF inPrice <> COALESCE(vbPrice,0)
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceSite_Value(), ioId, inPrice);
        -- сохранили св-во < Дата изменения >
        outDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_PriceSite_DateChange(), ioId, outDateChange);

        vbUpdateProtocol := True;
    END IF;

    -- сохранили св-во < % наценки >
    IF (inPercentMarkup is not null) AND (inPercentMarkup <> COALESCE(vbPercentMarkup,0))
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceSite_PercentMarkup(), ioId, inPercentMarkup);
        -- сохранили св-во < Дата изменения >
        outPercentMarkupDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_PriceSite_PercentMarkupDateChange(), ioId, outPercentMarkupDateChange);

        vbUpdateProtocol := True;
    END IF;

    -- сохранили историю
    IF inPrice <> COALESCE(vbPrice,0)
    THEN
        -- сохранили историю
        PERFORM gpInsertUpdate_ObjectHistory_PriceSite(
                ioId           := 0 :: Integer,                                    -- ключ объекта <Элемент истории прайса>
                inPriceSiteId  := ioId,                                        -- Прайс
                inOperDate     := CURRENT_TIMESTAMP                  :: TDateTime, -- Дата действия прайса
                inPrice        := COALESCE (inPrice, vbPrice):: TFloat,            -- Цена
                inSession      := inSession);
        outStartDate:= (SELECT MAX (StartDate) FROM ObjectHistory WHERE ObjectHistory.ObjectId = ioId AND DescId = zc_ObjectHistory_PriceSite());

    END IF;

    -- сохранили протокол
    IF vbUpdateProtocol = TRUE
    THEN
       PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
    END IF;
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.06.21                                                       *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_PriceSite()