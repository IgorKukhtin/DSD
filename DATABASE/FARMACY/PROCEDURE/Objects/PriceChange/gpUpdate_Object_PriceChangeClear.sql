-- Function: gpUpdate_Object_PriceChangeClear (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_PriceChangeClear (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PriceChangeClear(
    IN inId                       Integer   ,    -- ключ объекта < Цена >
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS VOID AS
$BODY$
    DECLARE
        vbUserId Integer;
        vbPriceChange TFloat;
        vbFixValue TFloat;
        vbFixPercent TFloat;
        vbFixDiscount TFloat;
        vbPercentMarkup TFloat;
        vbMultiplicity TFloat;
        vbFixEndDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    -- если не нашли - выходим
    IF COALESCE (inId, 0) = 0
    THEN
      RETURN;
    END IF;

    -- Если такая запись есть - достаем её ключу торг.сеть - товар или подразделение - товар
    SELECT Id, 
           PriceChange,
           FixValue,
           PercentMarkup,
           FixPercent,
           FixDiscount,
           Multiplicity,
           FixEndDate

      INTO inId,
           vbPriceChange,
           vbFixValue,
           vbPercentMarkup,
           vbFixPercent,
           vbFixDiscount,
           vbMultiplicity,
           vbFixEndDate
    FROM (WITH tmp1 AS (SELECT Object_PriceChange.Id                        AS Id
                             , ROUND(ObjectFloat_Value.ValueData,2)::TFloat AS PriceChange
                             , ObjectFloat_FixValue.ValueData               AS FixValue
                             , ObjectFloat_FixPercent.ValueData             AS FixPercent
                             , ObjectFloat_FixDiscount.ValueData            AS FixDiscount
                             , ObjectLink_Retail.ChildObjectId              AS RetailId
                             , ObjectDate_DateChange.valuedata              AS DateChange
                             , COALESCE(ObjectFloat_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup
                             , PriceChange_Multiplicity.ValueData           AS Multiplicity
                             , PriceChange_FixEndDate.ValueData             AS FixEndDate
                        FROM Object AS Object_PriceChange
                            LEFT JOIN ObjectLink AS ObjectLink_Retail
                                                 ON ObjectLink_Retail.ObjectId = Object_PriceChange.Id
                                                AND ObjectLink_Retail.DescId = zc_ObjectLink_PriceChange_Retail()
                            LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                 ON ObjectLink_Unit.ObjectId = Object_PriceChange.Id
                                                AND ObjectLink_Unit.DescId = zc_ObjectLink_PriceChange_Unit()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                  ON ObjectFloat_Value.ObjectId = Object_PriceChange.Id
                                                 AND ObjectFloat_Value.DescId = zc_ObjectFloat_PriceChange_Value()
                            LEFT JOIN ObjectFloat AS ObjectFloat_FixValue
                                                  ON ObjectFloat_FixValue.ObjectId = Object_PriceChange.Id
                                                 AND ObjectFloat_FixValue.DescId = zc_ObjectFloat_PriceChange_FixValue()
                            LEFT JOIN ObjectFloat AS ObjectFloat_FixPercent
                                                  ON ObjectFloat_FixPercent.ObjectId = Object_PriceChange.Id
                                                 AND ObjectFloat_FixPercent.DescId = zc_ObjectFloat_PriceChange_FixPercent()
                            LEFT JOIN ObjectFloat AS ObjectFloat_FixDiscount
                                                  ON ObjectFloat_FixDiscount.ObjectId = Object_PriceChange.Id
                                                 AND ObjectFloat_FixDiscount.DescId = zc_ObjectFloat_PriceChange_FixDiscount()
                            LEFT JOIN ObjectFloat AS ObjectFloat_PercentMarkup
                                                  ON ObjectFloat_PercentMarkup.ObjectId = Object_PriceChange.Id
                                                 AND ObjectFloat_PercentMarkup.DescId = zc_ObjectFloat_PriceChange_PercentMarkup()
                            LEFT JOIN ObjectFloat AS PriceChange_Multiplicity
                                                  ON PriceChange_Multiplicity.ObjectId = Object_PriceChange.Id
                                                 AND PriceChange_Multiplicity.DescId = zc_ObjectFloat_PriceChange_Multiplicity()
                            LEFT JOIN ObjectDate AS ObjectDate_DateChange
                                                 ON ObjectDate_DateChange.ObjectId = Object_PriceChange.Id
                                                AND ObjectDate_DateChange.DescId = zc_ObjectDate_PriceChange_DateChange()
                            LEFT JOIN ObjectDate AS PriceChange_FixEndDate
                                                 ON PriceChange_FixEndDate.ObjectId = Object_PriceChange.Id
                                                AND PriceChange_FixEndDate.DescId = zc_ObjectDate_PriceChange_FixEndDate()
                        WHERE Object_PriceChange.Id = inId
                       )
          --
          SELECT * FROM tmp1
         ) AS tmp;
         
    -- если нет скидки - выходим
    IF COALESCE (vbFixValue, 0) = 0 AND COALESCE (vbFixPercent, 0) = 0 AND COALESCE (vbFixDiscount, 0) = 0   
    THEN
      RETURN;
    END IF;
    
    -- сохранили св-во <расчетная цена>
    PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceChange_Value(), inId, 0);
    -- сохранили св-во <фиксированная цена>
    PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceChange_FixValue(), inId, 0);
    -- сохранили св-во <фиксированный % скидки>
    PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceChange_FixPercent(), inId, 0);
    -- сохранили св-во <фиксированная сумма скидки>
    PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceChange_FixDiscount(), inId, 0);
    

    -- сохранили св-во < Дата изменения >
    PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_PriceChange_DateChange(), inId, CURRENT_DATE);

    -- сохранили историю
    PERFORM gpInsertUpdate_ObjectHistory_PriceChange(ioId             := 0 
                                                   , inPriceChangeId  := inId
                                                   , inOperDate       := CURRENT_TIMESTAMP::TDateTime
                                                   , inPriceChange    := 0::TFloat
                                                   , inFixValue       := 0::TFloat
                                                   , inFixPercent     := 0::TFloat
                                                   , inFixDiscount    := 0::TFloat
                                                   , inPercentMarkup  := vbPercentMarkup
                                                   , inMultiplicity   := vbMultiplicity
                                                   , inFixEndDate     := vbFixEndDate
                                                   , inSession        := inSession
                                                   );

    -- сохранили протокол
    PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

    
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.10.21                                                       * 
*/

-- тест
-- SELECT * FROM gpUpdate_Object_PriceChangeClear(17180876, '3')