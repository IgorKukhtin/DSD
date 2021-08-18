-- Function: gpReport_CheckSUNItog()

DROP FUNCTION IF EXISTS gpReport_CheckSUNItog (Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckSUNItog(
    IN inUnitId              Integer  ,  -- Подразделение
    IN inRetailId            Integer  ,  -- ссылка на торг.сеть
    IN inJuridicalId         Integer  ,  -- юр.лицо
    IN inStartDate           TDateTime,  -- Дата начала
    IN inEndDate             TDateTime,  -- Дата окончания
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId         Integer
             , UnitName       TVarChar
             , Amount         TFloat
             , AmountSend_In  TFloat
             , AmountSend_Out TFloat
             , SumSale        TFloat
             , SumSend_In     TFloat
             , SumSend_Out    TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
        -- результат
        SELECT tmpData.UnitId
             , tmpData.UnitName

             , SUM(tmpData.Amount)          ::TFloat AS Amount
             , SUM(tmpData.AmountSend_In)   ::TFloat AS AmountSend_In
             , SUM(tmpData.AmountSend_Out)  ::TFloat AS AmountSend_Out
             , SUM(tmpData.SumSale)         ::TFloat AS SumSale
             , SUM(tmpData.SumSend_In)      ::TFloat AS SumSend_In
             , SUM(tmpData.SumSend_Out)     ::TFloat AS SumSend_Out
 
        FROM gpReport_CheckSUN (inUnitId := inUnitId, inRetailId := inRetailId, inJuridicalId := inJuridicalId, inStartDate := inStartDate, inEndDate := inEndDate, inisUnitList := false, inisMovement := false, inSession := inSession) AS tmpData
        GROUP BY tmpData.UnitId
               , tmpData.UnitName 
        ORDER BY tmpData.UnitName             
        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 18.08.21                                                      * 
*/

-- тест

SELECT * FROM gpReport_CheckSUNItog (inUnitId := 13338606, inRetailId:= 0, inJuridicalId:=0, inStartDate := ('01.08.2021')::TDateTime , inEndDate := ('18.08.2021')::TDateTime, inSession := '3' :: TVarChar);