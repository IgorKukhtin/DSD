-- Function: gpInsertUpdate_Object_PriceChange (Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceChange (Integer, Integer, Integer, TDateTime, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceChange (Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceChange (Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceChange (Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceChange (Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceChange (Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PriceChange(
 INOUT ioId                       Integer   ,    -- ключ объекта < Цена >
    IN inGoodsId                  Integer   ,    -- Товар
    IN inRetailId                 Integer   ,    -- торг. сеть
    IN inUnitId                   Integer   ,    -- подразделение
 INOUT ioStartDate                TDateTime , 
   OUT outDateChange              TDateTime ,    -- Дата изменения цены
   OUT outStartDate               TDateTime ,    -- Дата
   OUT outPriceChange             TFloat    ,    -- цена
    IN inFixValue                 TFloat    ,    -- 
    IN inFixPercent               TFloat    ,    -- 
    IN inFixDiscount              TFloat    ,    -- 
    IN inPercentMarkup            TFloat    ,    -- % наценки
    IN inMultiplicity             TFloat    ,    -- кратность
    IN inFixEndDate               TDateTime ,    -- Дата окончания действия скидки
    IN inSession                  TVarChar       -- сессия пользователя
)
AS
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
    -- проверка
    IF COALESCE (inRetailId, 0) <> 0 AND COALESCE (inUnitId, 0) <> 0
    THEN
         RAISE EXCEPTION 'Ошибка.ДОлжен быть выбран один из параметров торг.сеть или подразделение';
    END IF;

     -- Разрешаем только сотрудникам с правами админа и маркетологов   
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), 12084491))
    THEN
      RAISE EXCEPTION 'Изменение цен со скидкой вам запрещено.';
    END IF;
    
    -- Если такая запись есть - достаем её ключу торг.сеть - товар или подразделение - товар
    SELECT Id, 
           PriceChange,
           FixValue,
           DateChange,
           PercentMarkup,
           FixPercent,
           vbFixDiscount,
           Multiplicity,
           FixEndDate

      INTO ioId,
           vbPriceChange,
           vbFixValue,
           outDateChange,
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
                             , PriceChange_Goods.ChildObjectId              AS GoodsId
                             , ObjectLink_Retail.ChildObjectId              AS RetailId
                             , ObjectDate_DateChange.valuedata              AS DateChange
                             , COALESCE(ObjectFloat_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup
                             , PriceChange_Multiplicity.ValueData           AS Multiplicity
                             , PriceChange_FixEndDate.ValueData             AS FixEndDate
                        FROM Object AS Object_PriceChange
                            INNER JOIN ObjectLink AS PriceChange_Goods
                                                  ON PriceChange_Goods.ObjectId = Object_PriceChange.Id
                                                 AND PriceChange_Goods.DescId = zc_ObjectLink_PriceChange_Goods()
                                                 AND PriceChange_Goods.ChildObjectId = inGoodsId
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
                        WHERE Object_PriceChange.DescId = zc_Object_PriceChange()
                          AND ((ObjectLink_Retail.ChildObjectId = inRetailId AND inRetailId <> 0)
                            OR (ObjectLink_Unit.ChildObjectId = inUnitId AND inUnitId <> 0)
                              )
                       )
          --
          SELECT * FROM tmp1
         ) AS tmp;

    -- Расчет Цены со скидкой
    IF COALESCE (inFixDiscount,0)<> 0
    THEN
        -- Приоритет - Фикс. сумма скидки (ск)
        outPriceChange := 0;
        inFixValue := 0;
        inFixPercent := 0;
    ELSEIF COALESCE (inFixPercent,0)<> 0
    THEN
        -- Приоритет - фиксированный % ск.
        outPriceChange := 0;
        inFixValue := 0;
    ELSEIF COALESCE (inFixValue, 0) <> 0
    THEN
        -- Приоритет - фиксированная цена
        outPriceChange := inFixValue;
    ELSEIF COALESCE (inFixValue, 0) = 0 AND COALESCE (inPercentMarkup, 0) = 0 AND COALESCE (inFixPercent,0) = 0
    THEN
        -- в этом случае - обнуляем, типа удалили
        outPriceChange := 0;
    ELSE
        -- иначе оставляем значение какое было
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

    -- если не нашли - создание
    IF COALESCE (ioId, 0) = 0
    THEN
        -- создание
        ioId := lpInsertUpdate_Object (ioId, zc_Object_PriceChange(), 0, '');

        -- сохранили связь с <товар>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceChange_Goods(), ioId, inGoodsId);

        -- сохраняем одно из свойств 
        IF COALESCE(inRetailId, 0) <> 0
        THEN
            -- сохранили связь с <Торговая сеть >
            PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceChange_Retail(), ioId, inRetailId);
        END IF;
        IF COALESCE(inUnitId, 0) <> 0
        THEN
            -- сохранили связь с <Подразделение>
            PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceChange_Unit(), ioId, inUnitId);
        END IF;
    END IF;
    
    -- сохранили св-во <расчетная цена>
    PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceChange_Value(), ioId, outPriceChange);
    -- сохранили св-во <фиксированная цена>
    PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceChange_FixValue(), ioId, inFixValue);
    -- сохранили св-во <фиксированный % скидки>
    PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceChange_FixPercent(), ioId, inFixPercent);
    -- сохранили св-во <фиксированная сумма скидки>
    PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceChange_FixDiscount(), ioId, inFixDiscount);
    -- сохранили св-во <% наценки >
    PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceChange_PercentMarkup(), ioId, inPercentMarkup);

    -- сохранили св-во <Кратность>
    PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceChange_Multiplicity(), ioId, inMultiplicity);
    -- сохранили св-во <Дата окончания действия скидки>
    PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_PriceChange_FixEndDate(), ioId, inFixEndDate);
    

    -- сохранили историю
    IF  COALESCE (inPercentMarkup, 0) <> COALESCE (vbPercentMarkup, 0)
     OR COALESCE (inFixValue, 0)      <> COALESCE (vbFixValue, 0)
     OR COALESCE (inFixPercent, 0)    <> COALESCE (vbFixPercent, 0)
     OR COALESCE (inFixDiscount, 0)   <> COALESCE (vbFixDiscount, 0)
     OR COALESCE (inMultiplicity, 0)  <> COALESCE (vbMultiplicity, 0)
     OR inFixEndDate                  <> vbFixEndDate
     OR (inFixEndDate IS NULL)        <> (vbFixEndDate IS NULL)
    THEN
        -- сохранили св-во < Дата изменения >
        outDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_PriceChange_DateChange(), ioId, outDateChange);

        -- сохранили историю
        PERFORM gpInsertUpdate_ObjectHistory_PriceChange(ioId             := 0 :: Integer,    -- ключ объекта <Элемент истории>
                                                         inPriceChangeId  := ioId,    -- Прайс
                                                         inOperDate       := CURRENT_TIMESTAMP                        :: TDateTime, -- Дата действия прайса
                                                         inPriceChange    := COALESCE (outPriceChange, vbPriceChange) :: TFloat,    -- Цена
                                                         inFixValue       := COALESCE (inFixValue, vbFixValue)        :: TFloat,
                                                         inFixPercent     := COALESCE (inFixPercent, vbFixPercent)    :: TFloat,
                                                         inFixDiscount    := COALESCE (inFixDiscount, vbFixDiscount)  :: TFloat,
                                                         inPercentMarkup  := COALESCE (inPercentMarkup, 0)            :: TFloat,
                                                         inMultiplicity   := COALESCE (inMultiplicity, 0)             :: TFloat,
                                                         inFixEndDate     := inFixEndDate,
                                                         inSession        := inSession
                                                        );

        -- сохранили протокол
        PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

    END IF;

    -- определили
    ioStartDate:= (SELECT MAX (StartDate) FROM ObjectHistory WHERE ObjectHistory.ObjectId = ioId AND DescId = zc_ObjectHistory_PriceChange());
    outStartDate:= ioStartDate;

    
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.04.21                                                       * 
 13.03.19         * inMultiplicity
 08.02.19         *
 16.08.18         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_PriceChange()
