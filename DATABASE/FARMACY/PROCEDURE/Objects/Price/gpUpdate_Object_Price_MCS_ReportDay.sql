-- Function: gpUpdate_Object_Price_MCS_ReportDay (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Price_MCS_ReportDay (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Price_MCS_ReportDay(
    IN inUnitId                   Integer   ,    -- подразделение
    IN inGoodsId                  Integer   ,    -- Товар
    IN inMCSValue                 TFloat    ,    -- Неснижаемый товарный запас
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    
    IF COALESCE (inMCSValue, 0) > 0
    THEN
      
      PERFORM gpUpdate_Object_Price_MCS_byReport(inUnitId     := inUnitId     -- подразделение
                                               , inGoodsId    := inGoodsId    -- Товар
                                               , inMCSValue   := inMCSValue   -- Неснижаемый товарный запас
                                               , inDays       := 7            -- кол-во дней периода НТЗ
                                               , inisMCSAuto  := True         -- Режим - НТЗ выставил фармацевт на период
                                               , inSession    := inSession    -- сессия пользователя
                                                );
                                                
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 27.09.22                                                      *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Price_MCS_ReportDay()
