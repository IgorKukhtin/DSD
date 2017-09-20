-- Function: gpUpdate_Object_Price_MCS_byReport (Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Price_MCS_byReport (Integer, Integer, TFloat, TFloat,  Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Price_MCS_byReport(
    IN inUnitId                   Integer   ,    -- подразделение
    IN inGoodsId                  Integer   ,    -- Товар
    IN inMCSValue                 TFloat    ,    -- Неснижаемый товарный запас
    IN inDays                     TFloat    ,    -- кол-во дней периода НТЗ
    IN inisMCSAuto                Boolean   ,    -- Режим - НТЗ выставил фармацевт на период
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE
        vbUserId       Integer;
        vbMCSValue     TFloat;
        vbMCSValueOld  TFloat;
        vbMCSIsClose   Boolean;
        vbMCSNotRecalc Boolean;
        vbDate               TDateTime;
        vbEndDateMCSAuto     TDateTime;
    DECLARE vbIsMCSAuto_old  Boolean;
    DECLARE vbPrice   TFloat;
    DECLARE vbPriceId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    IF COALESCE (inMCSValue, 0) = 0
    THEN
        Return;
    END IF;
    
    -- проверили корректность НТЗ
    IF inMCSValue is not null AND (inMCSValue<0)
    THEN
        RAISE EXCEPTION 'Ошибка.Неснижаемый товарный запас <%> Не может быть меньше 0.', inMCSValue;
    END IF;

    IF COALESCE (inisMCSAuto,False) = True AND COALESCE (inDays,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Кол-во дней для периода должно быть больше 0.';
    END IF;    

    -- нашли элемент Цены
    vbPriceId:= (SELECT ObjectLink_Price_Unit.ObjectId AS Id
                 FROM ObjectLink AS ObjectLink_Price_Unit
                      INNER JOIN ObjectLink AS Price_Goods
                                            ON Price_Goods.ObjectId      = ObjectLink_Price_Unit.ObjectId
                                           AND Price_Goods.DescId        =  zc_ObjectLink_Price_Goods()
                                           AND Price_Goods.ChildObjectId = inGoodsId
                 WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                   AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                );
                
    -- Если такая запись есть - достаем её ключу подр.-товар
    SELECT Id, 
           Price, 
           MCSValue, 
           MCSNotRecalc,
           MCSValueOld,
           isMCSAuto
      INTO vbPriceId, 
           vbPrice, 
           vbMCSValue, 
           vbMCSNotRecalc,
           vbMCSValueOld,
           vbIsMCSAuto_old
    FROM (WITH tmp1 AS (SELECT Object_Price.Id                         AS Id
                             , ROUND(Price_Value.ValueData,2)::TFloat  AS Price
                             , MCS_Value.ValueData                     AS MCSValue
                             , COALESCE(MCS_NotRecalc.ValueData,False) AS MCSNotRecalc
                             , COALESCE(Price_MCSValueOld.ValueData,0)    ::TFloat     AS MCSValueOld
                             , COALESCE(Price_MCSAuto.ValueData,False)    :: Boolean   AS isMCSAuto
                           FROM Object AS Object_Price
                               INNER JOIN ObjectLink       AS Price_Goods
                                       ON Price_Goods.ObjectId = Object_Price.Id
                                      AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                      AND Price_Goods.ChildObjectId = inGoodsId
                               INNER JOIN ObjectLink       AS ObjectLink_Price_Unit
                                       ON ObjectLink_Price_Unit.ObjectId = Object_Price.Id
                                      AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                      AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                               LEFT JOIN ObjectFloat       AS Price_Value
                                      ON Price_Value.ObjectId = Object_Price.Id
                                     AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                               LEFT JOIN ObjectFloat       AS MCS_Value
                                      ON MCS_Value.ObjectId = Object_Price.Id
                                     AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                               LEFT JOIN ObjectFloat       AS Price_MCSValueOld
                                      ON Price_MCSValueOld.ObjectId = Object_Price.Id
                                     AND Price_MCSValueOld.DescId = zc_ObjectFloat_Price_MCSValueOld()
                                   LEFT JOIN ObjectBoolean     AS MCS_NotRecalc
                                      ON MCS_NotRecalc.ObjectId = Object_Price.Id
                                     AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
                               LEFT JOIN ObjectBoolean     AS Price_MCSAuto
                                      ON Price_MCSAuto.ObjectId = Object_Price.Id
                                     AND Price_MCSAuto.DescId = zc_ObjectBoolean_Price_MCSAuto()
                              WHERE Object_Price.Id = vbPriceId
                                AND Object_Price.DescId = zc_Object_Price()
                              )
          SELECT  * FROM tmp1) AS tmp;


    -- поиск значения НТЗ до тек.даты
    IF COALESCE (inisMCSAuto,False) = True
    THEN
        vbDate := CURRENT_DATE - INTERVAL '1 DAY';
        SELECT ObjectHistoryFloat_MCSValue.ValueData
      INTO vbMCSValueOld
        FROM ObjectHistory
             LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSValue
                                          ON ObjectHistoryFloat_MCSValue.ObjectHistoryId = ObjectHistory.Id
                                         AND ObjectHistoryFloat_MCSValue.DescId = zc_ObjectHistoryFloat_Price_MCSValue()                
        WHERE ObjectHistory.ObjectId = vbPriceId
          AND ObjectHistory.DescId   = zc_ObjectHistory_Price()
          AND vbDate >= ObjectHistory.StartDate AND CURRENT_DATE < ObjectHistory.EndDate
       ;
    END IF;

   
    IF COALESCE(vbPriceId,0) = 0
    THEN
        -- сохранили/получили <Объект> по ИД
        vbPriceId := lpInsertUpdate_Object (0, zc_Object_Price(), 0, '');

        -- сохранили связь с <товар>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Goods(), vbPriceId, inGoodsId);

        -- сохранили связь с <подразделение>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Unit(), vbPriceId, inUnitId);
    END IF;
    
    -- сохранили св-во < Неснижаемый товарный запас >
    IF COALESCE (inisMCSAuto, FALSE) = FALSE
    THEN
        IF (inMCSValue is not null) AND (inMCSValue <> COALESCE(vbMCSValue,0))
        THEN
            PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_MCSValue(), vbPriceId, inMCSValue);
            -- сохранили св-во < Дата изменения Неснижаемого товарного запаса>
            PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSDateChange(), vbPriceId, CURRENT_DATE);
        END IF;
    ELSE
        --  !!!всегда!!!
        IF 1=1
        THEN
            -- сохранили свойство <НТЗ для периода>
            PERFORM lpInsertUpdate_objectBoolean (zc_ObjectBoolean_Price_MCSAuto(), vbPriceId, inisMCSAuto);
 
            -- !!!только в этом случае!!!
            IF COALESCE (vbIsMCSAuto_old, FALSE) = FALSE
            THEN
                -- сохраняем старое значение НТЗ
                PERFORM lpInsertUpdate_objectFloat (zc_ObjectFloat_Price_MCSValueOld(), vbPriceId, vbMCSValueOld);
                -- меняем старое на текеущее и сохраняем
                PERFORM lpInsertUpdate_objectBoolean (zc_ObjectBoolean_Price_MCSNotRecalcOld(), vbPriceId, vbMCSNotRecalc);
            END IF;

            ---
            PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_MCSValue(), vbPriceId, inMCSValue);
            -- сохранили св-во < Дата изменения Неснижаемого товарного запаса>
            PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSDateChange(), vbPriceId, CURRENT_DATE);

            --
            PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_StartDateMCSAuto(), vbPriceId, CURRENT_DATE);
            --
            vbEndDateMCSAuto := CURRENT_DATE + ((inDays - 1) :: TVarChar || ' DAY') :: INTERVAL; 
            PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_EndDateMCSAuto(), vbPriceId, vbEndDateMCSAuto);

        END IF;
    END IF;

    -- сохранили историю
    IF (inMCSValue is not null) AND (inMCSValue <> COALESCE(vbMCSValue,0))
       
    THEN
        -- сохранили историю
        PERFORM gpInsertUpdate_ObjectHistory_Price(
                ioId       := 0 :: Integer,    -- ключ объекта <Элемент истории прайса>
                inPriceId  := vbPriceId,       -- Прайс
                inOperDate := CURRENT_TIMESTAMP                 :: TDateTime, -- Дата действия прайса
                inPrice    := COALESCE (vbPrice, 0)             :: TFloat,    -- Цена
                inMCSValue := COALESCE (inMCSValue, vbMCSValue) :: TFloat,    -- НТЗ
                inMCSPeriod:= 0                                 :: TFloat,    -- Количество дней для анализа НТЗ
                inMCSDay   := 0                                 :: TFloat,    -- Страховой запас дней НТЗ
                inSession  := inSession);
    END IF;
    
    -- сохранили протокол
    PERFORM lpInsert_ObjectProtocol (vbPriceId, vbUserId);
    
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 20.09.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Price_MCS_byReport()
