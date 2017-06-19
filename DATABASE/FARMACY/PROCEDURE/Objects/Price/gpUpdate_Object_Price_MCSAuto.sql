-- Function: gpUpdate_Object_Price_MCSAuto (Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Price_MCSAuto (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Price_MCSAuto(
    IN inMCSValue                 TFloat    ,    -- Неснижаемый товарный запас
    IN inGoodsId                  Integer   ,    -- Товар
    IN inDays                     TFloat    ,    -- кол-во дней периода НТЗ

   OUT outMCSValueOld             TFloat    ,    -- НТЗ - значение которое вернется по окончании периода
   OUT outStartDateMCSAuto        TDateTime ,    -- Дата нач. действия НТЗ (Авто)
   OUT outEndDateMCSAuto          TDateTime ,    -- Дата оконч. действия НТЗ (Авто)
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
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;


    -- нашли UnitId
    vbUnitId:= COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '0') :: Integer;

    
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
    
    
    
    -- сохранили протокол
    PERFORM lpInsert_ObjectProtocol (vbPriceId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 19.06.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Price_MCSAuto()
