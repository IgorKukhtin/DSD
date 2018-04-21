 -- Function: lpComplete_Movement_Income (Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Price (Integer, Integer, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Price (Integer, Integer, TFloat, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Price(
    IN inGoodsId        Integer  , -- ИД товара
    IN inUnitId         Integer,   -- ИД подразделения
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
    DECLARE vbMCSValue TFloat;

    DECLARE vbOperDate_StartBegin1 TDateTime;
    DECLARE vbOperDate_StartBegin2 TDateTime;
BEGIN

   vbOperDate_StartBegin1:= CLOCK_TIMESTAMP();
   
   -- Если такая запись есть - достаем её ключу подр.-товар
   SELECT ObjectLink_Price_Unit.ObjectId          AS Id
        , ROUND(Price_Value.ValueData,2)::TFloat  AS Price_Value
        , Price_DateChange.valuedata              AS DateChange
        , MCS_Value.ValueData                     AS MCSValue
          INTO vbId
             , vbPrice_Value
             , vbDateChange
             , vbMCSValue
   FROM ObjectLink AS ObjectLink_Price_Unit
        INNER JOIN ObjectLink AS Price_Goods
                              ON Price_Goods.ObjectId      = ObjectLink_Price_Unit.ObjectId
                             AND Price_Goods.DescId        = zc_ObjectLink_Price_Goods()
                             AND Price_Goods.ChildObjectId = inGoodsId
        LEFT JOIN ObjectFloat AS Price_Value
                               ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                              AND Price_Value.DescId   = zc_ObjectFloat_Price_Value()
        LEFT JOIN ObjectDate AS Price_DateChange
                             ON Price_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                            AND Price_DateChange.DescId   = zc_ObjectDate_Price_DateChange()
        LEFT JOIN ObjectFloat AS MCS_Value
                              ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                             AND MCS_Value.DescId   = zc_ObjectFloat_Price_MCSValue()
   WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
     AND ObjectLink_Price_Unit.ChildObjectId = inUnitId;


    -- !!!Протокол - отладка Скорости!!!
    INSERT INTO Log_Reprice (InsertDate, StartDate, EndDate, MovementId, UserId, TextValue)
      VALUES (CURRENT_TIMESTAMP, vbOperDate_StartBegin1, CLOCK_TIMESTAMP(), inUnitId, inUserId
            , 'lpInsertUpdate_Object_Price'
    || ' ' || inGoodsId             :: TVarChar
    || ',' || inUnitId              :: TVarChar
    || ',' || zfConvert_FloatToString (inPrice)
    || ',' || CHR (39) || zfConvert_DateToString (inDate) || CHR (39)
    || ',' || inUserId              :: TVarChar
             );

    IF COALESCE(vbId,0)=0
    THEN
        -- сохранили/получили <Объект> по ИД
        vbId := lpInsertUpdate_Object (vbId, zc_Object_Price(), 0, '');

        -- сохранили связь с <товар>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Goods(), vbId, inGoodsId);

        -- сохранили связь с <подразделение>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Unit(), vbId, inUnitId);
    END IF;

    IF (vbDateChange is null or inDate >= vbDateChange)
    THEN
        IF COALESCE (vbPrice_Value,0) <> inPrice
        THEN
            -- сохранили св-во <Цена>
            PERFORM lpInsertUpdate_objectFloat (zc_ObjectFloat_Price_Value(), vbId, inPrice);

            -- !!!Протокол - отладка Скорости!!!
            vbOperDate_StartBegin2:= CLOCK_TIMESTAMP();

            -- сохранили историю
            PERFORM
                gpInsertUpdate_ObjectHistory_Price(
                    ioId       := 0                           :: Integer     -- ключ объекта <Элемент истории прайса>
                  , inPriceId  := vbId                                       -- Прайс
                  , inOperDate := CURRENT_TIMESTAMP           :: TDateTime   -- Дата действия прайса
                  , inPrice    := inPrice                     :: TFloat      -- Цена
                  , inMCSValue := vbMCSValue                  :: TFloat      -- НТЗ
                  , inMCSPeriod:= COALESCE (tmp.MCSPeriod, 0) :: TFloat      -- Количество дней для анализа НТЗ
                  , inMCSDay   := COALESCE (tmp.MCSDay, 0)    :: TFloat      -- Страховой запас дней НТЗ
                  , inSession  := inUserId :: TVarChar
                   )
            FROM (WITH tmpObjectHistory AS (SELECT ObjectHistory.ObjectId
                                                 , OHF_MCSPeriod.ValueData AS MCSPeriod
                                                 , OHF_MCSDay.ValueData    AS MCSDay
                                            FROM ObjectHistory
                                                 LEFT JOIN ObjectHistoryFloat AS OHF_MCSPeriod
                                                                              ON OHF_MCSPeriod.ObjectHistoryId = ObjectHistory.Id
                                                                             AND OHF_MCSPeriod.DescId          = zc_ObjectHistoryFloat_Price_MCSPeriod()
                                                 LEFT JOIN ObjectHistoryFloat AS OHF_MCSDay
                                                                              ON OHF_MCSDay.ObjectHistoryId = ObjectHistory.Id
                                                                             AND OHF_MCSDay.DescId          = zc_ObjectHistoryFloat_Price_MCSDay()
                                            WHERE ObjectHistory.ObjectId = vbId
                                               AND ObjectHistory.EndDate  = zc_DateEnd() -- !!!криво, но берем последнюю!!!
                                               AND ObjectHistory.DescId   = zc_ObjectHistory_Price()
                                           )
                       -- Результат
                       SELECT tmpObjectHistory.MCSPeriod, tmpObjectHistory.MCSDay
                       FROM (SELECT vbId AS Id) AS tmp
                            LEFT JOIN tmpObjectHistory ON tmpObjectHistory.ObjectId = tmp.Id
                 ) AS tmp

           ;

          -- !!!Протокол - отладка Скорости!!!
          INSERT INTO Log_Reprice (InsertDate, StartDate, EndDate, MovementId, UserId, TextValue)
            VALUES (CURRENT_TIMESTAMP, vbOperDate_StartBegin2, CLOCK_TIMESTAMP(), inUnitId, inUserId
                  , 'gpInsertUpdate_ObjectHistory_Price'
          || ' ' || inGoodsId             :: TVarChar
          || ',' || inUnitId              :: TVarChar
          || ',' || zfConvert_FloatToString (inPrice)
          || ',' || CHR (39) || zfConvert_DateToString (inDate) || CHR (39)
          || ',' || inUserId              :: TVarChar
                   );

        END IF;

        -- сохранили св-во < Дата изменения >
        PERFORM lpInsertUpdate_objectDate (zc_ObjectDate_Price_DateChange(), vbId, inDate);

        -- сохранили протокол
        PERFORM lpInsert_ObjectProtocol (vbId, inUserId);

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 12.06.17         * убрали Object_Price_View
 22.12.15                                                                      *
 11.02.14                        *
 05.02.14                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Object_Price (inGoodsId := 1, inUnitId := 1, inPrice := 10.0, inUserId := 3)
