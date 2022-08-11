-- Function: gpUpdate_Object_Price_MCSAuto (Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Price_MCSAuto (TFloat, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Price_MCSAuto(
    IN inMCSValue                 TFloat    ,    -- Неснижаемый товарный запас
    IN inGoodsId                  Integer   ,    -- Товар
    IN inDays                     TFloat    ,    -- кол-во дней периода НТЗ

   OUT outMCSValueOld             TFloat    ,    -- НТЗ - значение которое вернется по окончании периода
   OUT outMCSDateChange           TDateTime ,    -- Дата изменения неснижаемого товарного запаса
   OUT outStartDateMCSAuto        TDateTime ,    -- Дата нач. действия НТЗ (Авто)
   OUT outEndDateMCSAuto          TDateTime ,    -- Дата оконч. действия НТЗ (Авто)
   OUT outMCSNotRecalcDateChange  TDateTime ,    -- Дата изменения признака "Спецконтроль кода"
   OUT outIsMCSNotRecalc          Boolean   ,    -- Спецконтроль кода - измененное значение
   OUT outIsMCSNotRecalcOld       Boolean   ,    -- Спецконтроль кода - значение которое вернется по окончании периода
   OUT outIsMCSAuto               Boolean   ,    -- Режим - НТЗ на период

    IN inSession                  TVarChar       -- сессия пользователя
)
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbUnitId  Integer;
    DECLARE vbPriceId Integer;
    DECLARE vbPrice   TFloat;

    DECLARE vbMCSValue       TFloat;
    DECLARE vbMCSNotRecalc   Boolean;
    DECLARE vbDate           TDateTime;
    DECLARE vbIsMCSAuto_old  Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
 
    IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
              WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- Для роли "Кассир аптеки"
       AND COALESCE (inDays, 0) > 7
    THEN
      RAISE EXCEPTION 'Ошибка. Кол-во дней для периода должно быть не более 7.';     
    END IF;         

    -- проверили 
    IF inMCSValue is not null AND (inMCSValue<0)
    THEN
        RAISE EXCEPTION 'Ошибка.Неснижаемый товарный запас <%> Не может быть меньше 0.', inMCSValue;
    END IF;

    IF COALESCE (inDays,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Кол-во дней для периода должно быть больше 0.';
    END IF;   

    IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
              WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- Для роли "Кассир аптеки"
       AND COALESCE (inDays, 0) > 7
    THEN
      RAISE EXCEPTION 'Ошибка. Кол-во дней для периода должно быть не более 7.';     
    END IF;         

    -- нашли UnitId
    vbUnitId:= COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '0') :: Integer;

    IF EXISTS (SELECT 1 FROM ObjectBoolean AS ObjectBoolean_NotCashMCS
               WHERE ObjectBoolean_NotCashMCS.ObjectId = vbUnitId
                 AND ObjectBoolean_NotCashMCS.DescId = zc_ObjectBoolean_Unit_NotCashMCS()
                 AND ObjectBoolean_NotCashMCS.ValueData = TRUE)
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение НТЗ по подразделению запрещено.';
    END IF;   
    
    -- нашли элемент Цены
    vbPriceId:= (SELECT ObjectLink_Price_Unit.ObjectId AS Id
                 FROM ObjectLink AS ObjectLink_Price_Unit
                      INNER JOIN ObjectLink AS Price_Goods
                                            ON Price_Goods.ObjectId      = ObjectLink_Price_Unit.ObjectId
                                           AND Price_Goods.DescId        =  zc_ObjectLink_Price_Goods()
                                           AND Price_Goods.ChildObjectId = inGoodsId
                 WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                   AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                );
    
    
    -- Если такая запись есть - достаем её ключу подр.-товар
    SELECT Id, 
           Price, 
           MCSValue, 
           MCSDateChange, 
           MCSNotRecalc,

           MCSValueOld,
           StartDateMCSAuto,
           EndDateMCSAuto,
           isMCSNotRecalcOld,
           isMCSAuto, isMCSAuto
      INTO vbPriceId, 
           vbPrice,
           vbMCSValue, 
           outMCSDateChange,
           vbMCSNotRecalc,

           outMCSValueOld,
           outStartDateMCSAuto,
           outEndDateMCSAuto,
           outisMCSNotRecalcOld,
           outisMCSAuto, vbIsMCSAuto_old
    FROM (WITH tmp1 AS (SELECT Object_Price.Id                         AS Id
                             , ROUND(Price_Value.ValueData,2)::TFloat  AS Price
                             , MCS_Value.ValueData                     AS MCSValue
                             , Price_Goods.ChildObjectId               AS GoodsId
                             , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                             , MCS_datechange.valuedata                AS MCSDateChange
                             , COALESCE(MCS_NotRecalc.ValueData,False) AS MCSNotRecalc
                             , COALESCE(Price_MCSValueOld.ValueData,0)    ::TFloat AS MCSValueOld
                             , MCS_StartDateMCSAuto.ValueData                      AS StartDateMCSAuto
                             , MCS_EndDateMCSAuto.ValueData                        AS EndDateMCSAuto
                             , COALESCE(Price_MCSAuto.ValueData,False)          :: Boolean   AS isMCSAuto
                             , COALESCE(Price_MCSNotRecalcOld.ValueData,False)  :: Boolean   AS isMCSNotRecalcOld
                           FROM Object AS Object_Price
                               INNER JOIN ObjectLink       AS Price_Goods
                                       ON Price_Goods.ObjectId = Object_Price.Id
                                      AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                      AND Price_Goods.ChildObjectId = inGoodsId
                               INNER JOIN ObjectLink       AS ObjectLink_Price_Unit
                                       ON ObjectLink_Price_Unit.ObjectId = Object_Price.Id
                                      AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                      AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                               LEFT JOIN ObjectFloat       AS Price_Value
                                      ON Price_Value.ObjectId = Object_Price.Id
                                     AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                               LEFT JOIN ObjectFloat       AS MCS_Value
                                      ON MCS_Value.ObjectId = Object_Price.Id
                                     AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                               LEFT JOIN ObjectFloat       AS Price_MCSValueOld
                                      ON Price_MCSValueOld.ObjectId = Object_Price.Id
                                     AND Price_MCSValueOld.DescId = zc_ObjectFloat_Price_MCSValueOld()
                               LEFT JOIN ObjectDate        AS MCS_DateChange
                                      ON MCS_DateChange.ObjectId = Object_Price.Id
                                     AND MCS_DateChange.DescId = zc_ObjectDate_Price_MCSDateChange()
                               LEFT JOIN ObjectDate        AS MCS_StartDateMCSAuto
                                      ON MCS_StartDateMCSAuto.ObjectId = Object_Price.Id
                                     AND MCS_StartDateMCSAuto.DescId = zc_ObjectDate_Price_StartDateMCSAuto()
                               LEFT JOIN ObjectDate        AS MCS_EndDateMCSAuto
                                      ON MCS_EndDateMCSAuto.ObjectId = Object_Price.Id
                                     AND MCS_EndDateMCSAuto.DescId = zc_ObjectDate_Price_EndDateMCSAuto()
                               LEFT JOIN ObjectBoolean     AS MCS_isClose
                                      ON MCS_isClose.ObjectId = Object_Price.Id
                                     AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
                               LEFT JOIN ObjectBoolean     AS MCS_NotRecalc
                                      ON MCS_NotRecalc.ObjectId = Object_Price.Id
                                     AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()

                               LEFT JOIN ObjectBoolean     AS Price_MCSAuto
                                      ON Price_MCSAuto.ObjectId = Object_Price.Id
                                     AND Price_MCSAuto.DescId = zc_ObjectBoolean_Price_MCSAuto()
                               LEFT JOIN ObjectBoolean     AS Price_MCSNotRecalcOld
                                      ON Price_MCSNotRecalcOld.ObjectId = Object_Price.Id
                                     AND Price_MCSNotRecalcOld.DescId = zc_ObjectBoolean_Price_MCSNotRecalcOld()
                              WHERE Object_Price.Id = vbPriceId
                                AND Object_Price.DescId = zc_Object_Price() )
          SELECT  * FROM tmp1) AS tmp;



      -- поиск значения НТЗ до тек.даты
      vbDate := CURRENT_DATE - INTERVAL '1 DAY';
      SELECT ObjectHistoryFloat_MCSValue.ValueData
             INTO outMCSValueOld
        FROM ObjectHistory
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSValue
                                             ON ObjectHistoryFloat_MCSValue.ObjectHistoryId = ObjectHistory.Id
                                            AND ObjectHistoryFloat_MCSValue.DescId = zc_ObjectHistoryFloat_Price_MCSValue()                
        WHERE ObjectHistory.ObjectId = vbPriceId
          AND ObjectHistory.DescId   = zc_ObjectHistory_Price()
          AND vbDate >= ObjectHistory.StartDate AND CURRENT_DATE < ObjectHistory.EndDate;


        -- сохранили свойство <НТЗ для периода>
        outisMCSAuto := TRUE;
        PERFORM lpInsertUpdate_objectBoolean(zc_ObjectBoolean_Price_MCSAuto(), vbPriceId, outisMCSAuto);
    

        -- !!!только в этом случае!!!
        IF COALESCE (vbIsMCSAuto_old, FALSE) = FALSE
        THEN
             -- сохраняем текущее значение НТЗ
             PERFORM lpInsertUpdate_objectFloat (zc_ObjectFloat_Price_MCSValueOld(), vbPriceId, outMCSValueOld);
             -- меняем старое на текеущее и сохраняем
             outisMCSNotRecalcOld := vbMCSNotRecalc;
             PERFORM lpInsertUpdate_objectBoolean (zc_ObjectBoolean_Price_MCSNotRecalcOld(), vbPriceId, outisMCSNotRecalcOld);
        END IF;
             

        ---
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_MCSValue(), vbPriceId, inMCSValue);
        -- сохранили св-во < Дата изменения Неснижаемого товарного запаса>
        outMCSDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSDateChange(), vbPriceId, outMCSDateChange);

        --
        outStartDateMCSAuto := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_StartDateMCSAuto(), vbPriceId, outStartDateMCSAuto);
        --
        outEndDateMCSAuto := outStartDateMCSAuto + ((inDays - 1) :: TVarChar || ' DAY') :: INTERVAL; 
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_EndDateMCSAuto(), vbPriceId, outEndDateMCSAuto);

        -- 
        outisMCSNotRecalc := TRUE;
        IF (COALESCE(vbMCSNotRecalc,False) <> outisMCSNotRecalc)
        THEN
          PERFORM lpInsertUpdate_objectBoolean(zc_ObjectBoolean_Price_MCSNotRecalc(), vbPriceId, outisMCSNotRecalc);
          outMCSNotRecalcDateChange := CURRENT_DATE;
          PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSNotRecalcDateChange(), vbPriceId, outMCSNotRecalcDateChange);
        END IF;


        -- сохранили историю
        IF (inMCSValue is not null) AND (inMCSValue <> COALESCE(vbMCSValue,0))
        THEN
            -- сохранили историю
            PERFORM gpInsertUpdate_ObjectHistory_Price(
                ioId       := 0 :: Integer,    -- ключ объекта <Элемент истории прайса>
                inPriceId  := vbPriceId   ,    -- Прайс
                inOperDate := CURRENT_TIMESTAMP                 :: TDateTime, -- Дата действия прайса
                inPrice    := COALESCE (vbPrice,0)              :: TFloat,    -- Цена
                inMCSValue := COALESCE (inMCSValue, vbMCSValue) :: TFloat,    -- НТЗ
                inMCSPeriod:= 0                                 :: TFloat,    -- Количество дней для анализа НТЗ
                inMCSDay   := 0                                 :: TFloat,    -- Страховой запас дней НТЗ
                inSession  := inSession);
           -- определили
           --outStartDate:= (SELECT MAX (StartDate) FROM ObjectHistory WHERE ObjectHistory.ObjectId = vbPriceId AND DescId = zc_ObjectHistory_Price());
 
        END IF;

    -- сохранили протокол
    PERFORM lpInsert_ObjectProtocol (vbPriceId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 21.01.20                                                                      * Кол-во дней для периода не более 7 для кассира
 19.06.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Price_MCSAuto()
--select * from gpUpdate_Object_Price_MCSAuto(inMCSValue := 4 ::TFloat , inGoodsId := 652, inDays := 3 ::TFloat,  inSession := '3'::TVarChar);
