-- Function:  gpReport_Check_SP_ForDPSS_Header()

DROP FUNCTION IF EXISTS gpReport_Check_SP_ForDPSS_Header (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_SP_ForDPSS_Header(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inJuridicalId      Integer  ,  -- Юр.лицо
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Title            TBlob
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbcbname TVarChar;
   DECLARE vbjuridicaladdress TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    
    IF inStartDate <> DATE_TRUNC ('DAY', inStartDate) OR
       inEndDate <> DATE_TRUNC ('DAY', inStartDate + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
    THEN
        RAISE EXCEPTION 'Ошибка.Период должен быть кратный месяцу.';
    END IF;
    
    SELECT cbname, juridicaladdress 
    INTO vbcbname, vbjuridicaladdress
    FROM gpSelect_Object_Juridical( inSession := '3') WHERE ID = inJuridicalId;
    
    -- Результат
    RETURN QUERY
      SELECT ('Інформація за '||zfCalc_MonthYearNameUkr (inStartDate)||
              ' року щодо застосування державних регульованих цін на лікарські засоби, які беруть участь у програмі "Доступні ліки", по аптечному закладу '||
              COALESCE(vbcbname, '')::Text||','||COALESCE(vbjuridicaladdress, ''))::TBlob;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.03.21                                                       *
*/

-- тест
-- 
select * from gpReport_Check_SP_ForDPSS_Header(inStartDate := ('01.02.2021')::TDateTime , inEndDate := ('28.02.2021')::TDateTime , inJuridicalId := 2886776 , inSession := '3');