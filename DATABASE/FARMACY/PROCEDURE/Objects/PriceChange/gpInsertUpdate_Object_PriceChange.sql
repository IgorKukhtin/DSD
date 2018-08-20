-- Function: gpInsertUpdate_Object_PriceChange (Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceChange (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceChange (Integer, Integer, Integer, TDateTime, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PriceChange(
 INOUT ioId                       Integer   ,    -- ключ объекта < Цена >
    IN inGoodsId                  Integer   ,    -- Товар
    IN inRetailId                 Integer   ,    -- подразделение
 INOUT ioStartDate                TDateTime , 
   OUT outDateChange              TDateTime ,    -- Дата изменения цены
   OUT outStartDate               TDateTime ,    -- Дата
   OUT outPriceChange             TFloat    ,    -- цена
    IN inFixValue                 TFloat    ,    -- 
    IN inPercentMarkup            TFloat    ,    -- % наценки
    IN inSession                  TVarChar       -- сессия пользователя
)
AS
$BODY$
    DECLARE
        vbUserId Integer;
        vbPriceChange TFloat;
        vbFixValue TFloat;
        vbPercentMarkup TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    
/*    -- проверили корректность цены
    IF inPriceChange = 0
    THEN
        inPriceChange := null;
    END IF;
    IF inPriceChange is not null AND (inPriceChange < 0)
    THEN
        RAISE EXCEPTION 'Ошибка.Цена <%> должна быть больше 0.', inPriceChange;
    END IF;
*/
    

    -- Если такая запись есть - достаем её ключу торг.сеть - товар
    SELECT Id, 
           PriceChange, 
           FixValue, 
           DateChange, 
           PercentMarkup

      INTO ioId, 
           vbPriceChange, 
           vbFixValue, 
           outDateChange, 
           vbPercentMarkup
    FROM (WITH tmp1 AS (SELECT Object_PriceChange.Id                        AS Id
                             , ROUND(ObjectFloat_Value.ValueData,2)::TFloat AS PriceChange
                             , ObjectFloat_FixValue.ValueData               AS FixValue
                             , PriceChange_Goods.ChildObjectId              AS GoodsId
                             , ObjectLink_Retail.ChildObjectId  AS RetailId
                             , ObjectDate_DateChange.valuedata             AS DateChange
                             , COALESCE(ObjectFloat_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup
                           FROM Object AS Object_PriceChange
                               INNER JOIN ObjectLink AS PriceChange_Goods
                                                     ON PriceChange_Goods.ObjectId = Object_PriceChange.Id
                                                    AND PriceChange_Goods.DescId = zc_ObjectLink_PriceChange_Goods()
                                                    AND PriceChange_Goods.ChildObjectId = inGoodsId
                               INNER JOIN ObjectLink AS ObjectLink_Retail
                                                     ON ObjectLink_Retail.ObjectId = Object_PriceChange.Id
                                                    AND ObjectLink_Retail.DescId = zc_ObjectLink_PriceChange_Retail()
                                                    AND ObjectLink_Retail.ChildObjectId = inRetailId
                               LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                     ON ObjectFloat_Value.ObjectId = Object_PriceChange.Id
                                                    AND ObjectFloat_Value.DescId = zc_ObjectFloat_PriceChange_Value()
                               LEFT JOIN ObjectFloat AS ObjectFloat_FixValue
                                                     ON ObjectFloat_FixValue.ObjectId = Object_PriceChange.Id
                                                    AND ObjectFloat_FixValue.DescId = zc_ObjectFloat_PriceChange_FixValue()
                               LEFT JOIN ObjectFloat AS ObjectFloat_PercentMarkup
                                                     ON ObjectFloat_PercentMarkup.ObjectId = Object_PriceChange.Id
                                                    AND ObjectFloat_PercentMarkup.DescId = zc_ObjectFloat_PriceChange_PercentMarkup()
                               LEFT JOIN ObjectDate AS ObjectDate_DateChange
                                                    ON ObjectDate_DateChange.ObjectId = Object_PriceChange.Id
                                                   AND ObjectDate_DateChange.DescId = zc_ObjectDate_PriceChange_DateChange()
                           WHERE Object_PriceChange.DescId = zc_Object_PriceChange())
          SELECT * FROM tmp1) AS tmp;

    IF COALESCE (inFixValue, 0) <> 0
    THEN
        outPriceChange := inFixValue;
    ELSE 
        outPriceChange := vbPriceChange;
    END IF;

    -- проверили корректность записи по дате
    IF ioStartDate > zc_DateStart()
    THEN
        IF EXISTS (SELECT 1 FROM ObjectHistory WHERE ObjectHistory.ObjectId = @ioId AND ObjectHistory.StartDate > ioStartDate)
        THEN
            RAISE EXCEPTION 'Ошибка.Попытка изменить данные до <%>.Измените дату просмотра на более позднюю.', DATE ((SELECT MAX (ObjectHistory.StartDate) FROM ObjectHistory WHERE ObjectHistory.ObjectId = @ioId AND ObjectHistory.StartDate > ioStartDate));
        END IF;
    END IF;

    IF COALESCE(ioId,0)=0
    THEN
        -- сохранили/получили <Объект> по ИД
        ioId := lpInsertUpdate_Object (ioId, zc_Object_PriceChange(), 0, '');

        -- сохранили связь с <товар>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceChange_Goods(), ioId, inGoodsId);

        -- сохранили связь с <подразделение>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceChange_Retail(), ioId, inRetailId);
    END IF;
    
    -- сохранили св-во < Цена >
    IF (outPriceChange is not null) AND (outPriceChange <> COALESCE(vbPriceChange,0))
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceChange_Value(), ioId, outPriceChange);
        -- сохранили св-во < Дата изменения >
        outDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_PriceChange_DateChange(), ioId, outDateChange);
    END IF;

    -- сохранили св-во < Неснижаемый товарный запас >
    IF (inFixValue is not null) AND (inFixValue <> COALESCE(vbFixValue,0))
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceChange_FixValue(), ioId, inFixValue);
        -- сохранили св-во < Дата изменения>
        outDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_PriceChange_DateChange(), ioId, outDateChange);
    END IF;

    -- сохранили св-во < % наценки >
    IF (inPercentMarkup is not null) AND (inPercentMarkup <> COALESCE(vbPercentMarkup,0))
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceChange_PercentMarkup(), ioId, inPercentMarkup);
        -- сохранили св-во < Дата изменения >
        outDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_PriceChange_DateChange(), ioId, outDateChange);
    END IF;


    -- сохранили историю
    IF ((outPriceChange is not null) /* AND (outPriceChange <> COALESCE(vbPriceChange,0)) */ ) 
       OR
       ((inFixValue is not null) AND (inFixValue <> COALESCE(vbFixValue,0)))
       
    THEN
        -- сохранили историю
        PERFORM gpInsertUpdate_ObjectHistory_PriceChange(ioId             := 0 :: Integer,    -- ключ объекта <Элемент истории>
                                                         inPriceChangeId  := ioId,    -- Прайс
                                                         inOperDate       := CURRENT_TIMESTAMP                       :: TDateTime, -- Дата действия прайса
                                                         inPriceChange    := COALESCE (outPriceChange, vbPriceChange) :: TFloat,    -- Цена
                                                         inFixValue       := COALESCE (inFixValue, vbFixValue)       :: TFloat,
                                                         inPercentMarkup  := COALESCE (inPercentMarkup, 0)           :: TFloat,
                                                         inSession        := inSession);
       -- определили
       ioStartDate:= (SELECT MAX (StartDate) FROM ObjectHistory WHERE ObjectHistory.ObjectId = ioId AND DescId = zc_ObjectHistory_PriceChange());
       outStartDate:= ioStartDate;

    END IF;

    -- сохранили протокол
    PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
    
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 16.08.18         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_PriceChange()
