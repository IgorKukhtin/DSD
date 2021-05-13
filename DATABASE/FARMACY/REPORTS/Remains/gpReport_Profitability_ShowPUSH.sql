-- Function: gpReport_Profitability_ShowPUSH(TVarChar)

DROP FUNCTION IF EXISTS gpReport_Profitability_ShowPUSH(TDateTime,TDateTime,TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Profitability_ShowPUSH(
    IN inDateStart              TDateTime,  -- Дата начала
    IN inDateFinal              TDateTime,  -- Двта конца
   OUT outShowMessage           Boolean,    -- Показыват сообщение
   OUT outPUSHType              Integer,    -- Тип сообщения
   OUT outText                  Text,       -- Текст сообщения
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbName  TVarChar;
   DECLARE vbJuridical Integer;
BEGIN

    outShowMessage := False;

    outText := '';
    
    IF NOT EXISTS(SELECT 1
                  FROM AnalysisContainerItem AS ContainerItem
                  WHERE ContainerItem.Operdate = inDateFinal
                    AND ContainerItem.UnitId <> 0
                  LIMIT 1)
       AND DATE_TRUNC ('day', inDateFinal) >= CURRENT_DATE
    THEN
      outText := 'На конец периода не сформированы аналитические таблицы данные не достоверны.'||CHR(13)||'Попробуйте позже.';    
    END IF;
    
    IF DATE_TRUNC ('month', inDateFinal) + INTERVAL '1 MONTH' - INTERVAL  '1 DAY' <> DATE_TRUNC ('day', inDateFinal) OR
       DATE_TRUNC ('month', inDateStart) <> DATE_TRUNC ('day', inDateStart)
    THEN
      IF COALESCE(outText, '') <> ''
      THEN
        outText := outText||CHR(13)||CHR(13);
      ELSE  
        outText := '';
      END IF;
      outText := outText||'Период не кратный месяцу.';    
    END IF;

    IF COALESCE(outText, '') <> ''
    THEN
      outShowMessage := True;
      outPUSHType := 3;
      outText := outText;
     END IF;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.05.21                                                       *

*/

-- SELECT * FROM gpSelect_ShowPUSH_OrderInternal(183292,'3')

select * from gpReport_Profitability_ShowPUSH(inDateStart := ('02.05.2021')::TDateTime , inDateFinal := ('13.05.2021')::TDateTime  ,  inSession := '3');
