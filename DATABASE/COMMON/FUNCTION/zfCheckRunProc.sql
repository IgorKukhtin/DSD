-- Function: zfCheckRunProc

DROP FUNCTION IF EXISTS zfCheckRunProc (TVarChar, Integer);

CREATE OR REPLACE FUNCTION zfCheckRunProc(
    IN inProcedureName   TVarChar, -- Имя процедуры
    IN inMaxCountRun     Integer   -- Допустимое количество копий
)
RETURNS VOID
AS
$BODY$
BEGIN

  IF COALESCE((SELECT count(*) as CountProc  
               FROM pg_stat_activity
               WHERE state = 'active'
                 AND query ilike '%'||inProcedureName||'%'), 0) > inMaxCountRun
  THEN
    RAISE EXCEPTION 'Ошибка. Запуск более <%> копий процедуры <%> запрещен.', inMaxCountRun, inProcedureName;
  END IF;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 04.09.19                                                      *
*/

-- тест
-- SELECT zfCheckRunProc (inProcedureName := 'gpSelect_CashRemains_Diff_ver2', inMaxCountRun := 1)
