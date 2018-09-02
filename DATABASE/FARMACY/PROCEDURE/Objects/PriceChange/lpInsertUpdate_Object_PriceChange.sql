 -- Function: lpComplete_Movement_PriceChangeChange (Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PriceChange (Integer, Integer, TFloat, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_PriceChange(
    IN inGoodsId        Integer  , -- ИД товара
    IN inRetailId       Integer,   -- 
    IN inPriceChange    TFloat,    -- 
    IN inDate           TDateTime, -- 
    IN inUserId         Integer    -- пользователь
)
RETURNS VOID
AS
$BODY$
    DECLARE vbId            Integer;
    DECLARE vbPriceChange   TFloat;
    DECLARE vbDateChange    TDateTime;
    DECLARE vbFixValue      TFloat;
    DECLARE vbPercentMarkup TFloat;

    -- DECLARE vbOperDate_StartBegin1 TDateTime;
    DECLARE vbOperDate_StartBegin2 TDateTime;
BEGIN

   -- Если такая запись есть - достаем её ключу подр.-товар
   SELECT ObjectLink_PriceChange_Retail.ObjectId        AS Id
        , ROUND(PriceChange_Value.ValueData,2)::TFloat  AS PriceChange
        , PriceChange_DateChange.valuedata              AS DateChange
        , ObjectFloat_FixValue.ValueData                AS FixValue
        , ObjectFloat_PercentMarkup.ValueData           AS PercentMarkup
          INTO vbId
             , vbPriceChange
             , vbDateChange
             , vbFixValue
             , vbPercentMarkup
   FROM ObjectLink AS PriceChange_Goods
        INNER JOIN ObjectLink AS ObjectLink_PriceChange_Retail
                              ON ObjectLink_PriceChange_Retail.ObjectId      = PriceChange_Goods.ObjectId
                             AND ObjectLink_PriceChange_Retail.ChildObjectId = inRetailId
                             AND ObjectLink_PriceChange_Retail.DescId        = zc_ObjectLink_PriceChange_Retail()
        LEFT JOIN ObjectFloat AS PriceChange_Value
                              ON PriceChange_Value.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                             AND PriceChange_Value.DescId   = zc_ObjectFloat_PriceChange_Value()
        LEFT JOIN ObjectDate AS PriceChange_DateChange
                             ON PriceChange_DateChange.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                            AND PriceChange_DateChange.DescId   = zc_ObjectDate_PriceChange_DateChange()
        LEFT JOIN ObjectFloat AS ObjectFloat_FixValue
                              ON ObjectFloat_FixValue.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                             AND ObjectFloat_FixValue.DescId   = zc_ObjectFloat_PriceChange_FixValue()
        LEFT JOIN ObjectFloat AS ObjectFloat_PercentMarkup
                              ON ObjectFloat_PercentMarkup.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                             AND ObjectFloat_PercentMarkup.DescId   = zc_ObjectFloat_PriceChange_PercentMarkup()
   WHERE PriceChange_Goods.DescId        = zc_ObjectLink_PriceChange_Goods()
     AND PriceChange_Goods.ChildObjectId = inGoodsId;


    IF COALESCE(vbId,0)=0
    THEN
        -- сохранили/получили <Объект> по ИД
        vbId := lpInsertUpdate_Object (vbId, zc_Object_PriceChange(), 0, '');

        -- сохранили связь с <товар>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceChange_Goods(), vbId, inGoodsId);

        -- сохранили связь с <торг.сеть>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceChange_Retail(), vbId, inRetailId);
    END IF;

    IF (vbDateChange is null or inDate >= vbDateChange)
    THEN
        IF COALESCE (vbPriceChange,0) <> inPriceChange
        THEN
            -- сохранили св-во <Цена>
            PERFORM lpInsertUpdate_objectFloat (zc_ObjectFloat_PriceChange_Value(), vbId, inPriceChange);

            -- !!!Протокол - отладка Скорости!!!
            vbOperDate_StartBegin2:= CLOCK_TIMESTAMP();

            -- сохранили историю
            PERFORM gpInsertUpdate_ObjectHistory_PriceChange (ioId             := 0                           :: Integer     -- ключ объекта
                                                            , inPriceChangeId  := vbId                                       -- 
                                                            , inOperDate       := CURRENT_TIMESTAMP           :: TDateTime   -- Дата действия прайса
                                                            , inPriceChange    := inPriceChange               :: TFloat      -- Цена
                                                            , inFixValue       := vbFixValue                  :: TFloat
                                                            , inPercentMarkup  := COALESCE (vbPercentMarkup, 0)   :: TFloat
                                                            , inSession  := inUserId :: TVarChar
                                                             );

        END IF;

        -- сохранили св-во < Дата изменения >
        PERFORM lpInsertUpdate_objectDate (zc_ObjectDate_PriceChange_DateChange(), vbId, inDate);

        -- сохранили протокол - !!!ВРЕМЕННО-вкл.
        PERFORM lpInsert_ObjectProtocol (vbId, inUserId);

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 12.06.17         * убрали Object_PriceChange_View
 22.12.15                                                                      *
 11.02.14                        *
 05.02.14                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Object_PriceChange (inGoodsId := 1, inRetailId := 1, inPriceChange := 10.0, inUserId := 3)
