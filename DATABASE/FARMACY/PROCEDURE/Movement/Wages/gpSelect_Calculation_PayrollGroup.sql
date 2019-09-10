-- Function: gpSelect_Сalculation_PayrollGroup()

DROP FUNCTION IF EXISTS gpSelect_Calculation_PayrollGroup (Integer, TFloat, TFloat, Integer, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Calculation_PayrollGroup(
    IN inPayrollTypeID    Integer,
    IN inPercent          TFloat,
    IN inMinAccrualAmount TFloat,

    IN inCountDoc         Integer,
    IN inSummBase         TFloat,
    IN inCountUser        Integer,
    IN inDetals           TVarChar
)
RETURNS TABLE (Summa TFloat
             , SummaBase TFloat
             , Formula TVarChar
             )
AS
$BODY$
   DECLARE vbSumma     TFloat;
   DECLARE vbSummaBase TFloat;
   DECLARE vbFormula   TVarChar;
BEGIN

  IF inPayrollTypeID IN (zc_Enum_PayrollType_WorkCS(), zc_Enum_PayrollType_WorkSCS(), zc_Enum_PayrollType_WorkAS(), zc_Enum_PayrollType_WorkSAS())
  THEN
    vbSummaBase := inSummBase;
    vbSumma := ROUND(COALESCE (vbSummaBase * inPercent / 100, 0), 2);

    vbFormula   := 'База расчета: '||inDetals||' = '||
                    TRIM(to_char(vbSummaBase, 'G999G999G999G999D99'))||'; '||
                    'Начислено: Если база % '||CAST(COALESCE (inPercent, 0) AS TVarChar)||
                    ' = '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    ' < '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' то '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' иначе '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    '; Начислено: '||TRIM(to_char(CASE WHEN vbSumma < inMinAccrualAmount THEN inMinAccrualAmount ELSE vbSumma END, 'G999G999G999G999D99'));

    RETURN QUERY
        SELECT CASE WHEN vbSumma < inMinAccrualAmount THEN inMinAccrualAmount ELSE vbSumma END, vbSummaBase, vbFormula;

  ELSEIF inPayrollTypeID = zc_Enum_PayrollType_WorkNS()
  THEN
    vbSummaBase := inSummBase;
    vbSumma := ROUND(COALESCE (vbSummaBase * inPercent / 100, 0), 2);

    vbFormula   := 'База расчета: '||inDetals||' = '||
                    TRIM(to_char(vbSummaBase, 'G999G999G999G999D99'))||'; '||
                    'Начислено: Если база % '||CAST(COALESCE (inPercent, 0) AS TVarChar)||
                    ' = '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    ' < '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' то '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' иначе '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    '; Начислено: '||TRIM(to_char(CASE WHEN vbSumma < inMinAccrualAmount THEN inMinAccrualAmount ELSE vbSumma END, 'G999G999G999G999D99'));

    RETURN QUERY
        SELECT vbSumma, vbSummaBase, vbFormula;

  ELSEIF inPayrollTypeID = zc_Enum_PayrollType_WorkS()
  THEN
    IF COALESCE (inCountUser, 0) = 0
    THEN
      vbSummaBase := COALESCE (inSummBase, 0);
    ELSE
      vbSummaBase := COALESCE (inSummBase, 0) / COALESCE (inCountUser, 0);
    END IF;
    vbSumma := NULL;

    vbFormula   := 'База расчета: '||TRIM(to_char(COALESCE (inSummBase, 0), 'G999G999G999G999D99'))||' / '||
                    CAST(COALESCE (inCountUser, 0) AS TVarChar)||' = '||
                    TRIM(to_char(inSummBase, 'G999G999G999G999D99'))||
                    '; Количество приходов: '|| CAST(COALESCE (inCountDoc, 0) AS TVarChar);

    RETURN QUERY
        SELECT vbSumma, vbSummaBase, vbFormula;

  ELSE

    RETURN QUERY
        SELECT Null::TFloat, Null::TFloat, 'Неизвестный тип расчета.'::TVarChar;
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Calculation_PayrollGroup (Integer, TFloat, TFloat, Integer, TFloat, Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.09.19                                                        *
 23.08.19                                                        *
*/

-- select * from gpSelect_Calculation_PayrollGroup(zc_Enum_PayrollType_WorkNS(), 3, 0, 3, 1000, 0, 'dddd');