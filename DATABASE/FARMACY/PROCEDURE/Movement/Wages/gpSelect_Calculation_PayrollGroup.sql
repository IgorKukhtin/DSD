-- Function: gpSelect_Сalculation_PayrollGroup()

DROP FUNCTION IF EXISTS gpSelect_Calculation_PayrollGroup (Integer, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION gpSelect_Calculation_PayrollGroup(
    IN inPayrollTypeID    Integer,
    IN inPercent          TFloat,
    IN inMinAccrualAmount TFloat,

    IN inCountUserCS      Integer,
    IN inCountUserAS      Integer,
    IN inCountUserNS      Integer,
    IN inCountUserSCS     Integer,
    IN inCountUserS       Integer,

    IN inSummCS           TFloat,
    IN inSummSCS          TFloat,
    IN inSummHS           TFloat
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

  IF inPayrollTypeID IN (zc_Enum_PayrollType_WorkCS(), zc_Enum_PayrollType_WorkSCS())
  THEN
    vbSummaBase := CASE WHEN (COALESCE (inCountUserCS, 0) + COALESCE (inCountUserSCS, 0)) > 0
                        THEN COALESCE (inSummCS, 0) / (COALESCE (inCountUserCS, 0) + COALESCE (inCountUserSCS, 0))
                        ELSE 0 END +
                   CASE WHEN (COALESCE (inCountUserCS, 0) + COALESCE (inCountUserAS, 0) + COALESCE (inCountUserSCS, 0)) > 0
                        THEN COALESCE (inSummSCS, 0) / (COALESCE (inCountUserCS, 0) + COALESCE (inCountUserAS, 0) + COALESCE (inCountUserSCS, 0))
                        ELSE 0 END;
    vbSumma := ROUND(COALESCE (vbSummaBase * inPercent / 100, 0), 2);

    vbFormula   := 'База расчета: '||TRIM(to_char(COALESCE (inSummCS, 0), 'G999G999G999G999D99'))||' / ('||
                    CAST(COALESCE (inCountUserCS, 0) AS TVarChar)||' + '||
                    CAST(COALESCE (inCountUserSCS, 0) AS TVarChar)||') + '||
                    TRIM(to_char( COALESCE (inSummSCS, 0), 'G999G999G999G999D99'))||' / ('||
                    CAST(COALESCE (inCountUserCS, 0) AS TVarChar)||' + '||
                    CAST(COALESCE (inCountUserAS, 0) AS TVarChar)||' + '||
                    CAST(COALESCE (inCountUserSCS, 0) AS TVarChar)||') = '||
                    TRIM(to_char(vbSummaBase, 'G999G999G999G999D99'))||'; '||
                    'Начислено: Если база % '||CAST(COALESCE (inPercent, 0) AS TVarChar)||
                    ' = '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    ' < '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' то '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' иначе '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    '; Начислено: '||TRIM(to_char(CASE WHEN vbSumma < inMinAccrualAmount THEN inMinAccrualAmount ELSE vbSumma END, 'G999G999G999G999D99'));

    RETURN QUERY
        SELECT CASE WHEN vbSumma < inMinAccrualAmount THEN inMinAccrualAmount ELSE vbSumma END, vbSummaBase, vbFormula;

  ELSEIF inPayrollTypeID = zc_Enum_PayrollType_WorkAS()
  THEN
    vbSummaBase := CASE WHEN (COALESCE (inCountUserCS, 0) + COALESCE (inCountUserAS, 0) + COALESCE (inCountUserSCS, 0)) > 0
                        THEN COALESCE (inSummSCS, 0) / (COALESCE (inCountUserCS, 0) + COALESCE (inCountUserAS, 0) + COALESCE (inCountUserSCS, 0))
                        ELSE 0 END;
    vbSumma := ROUND(COALESCE (vbSummaBase * inPercent / 100, 0), 2);

    vbFormula   := 'База расчета: '||TRIM(to_char(COALESCE (inSummSCS, 0), 'G999G999G999G999D99'))||' / ('||
                    CAST(COALESCE (inCountUserCS, 0) AS TVarChar)||' + '||
                    CAST(COALESCE (inCountUserAS, 0) AS TVarChar)||' + '||
                    CAST(COALESCE (inCountUserSCS, 0) AS TVarChar)||') = '||
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
    vbSummaBase := COALESCE (inSummHS, 0) / COALESCE (inCountUserNS, 0);
    vbSumma := ROUND(COALESCE (vbSummaBase * inPercent / 100, 0), 2);

    vbFormula   := 'База расчета: '||TRIM(to_char(COALESCE (inSummHS, 0), 'G999G999G999G999D99'))||' / '||
                    CAST(COALESCE (inCountUserNS, 0) AS TVarChar)||' = '||
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
    IF COALESCE (inCountUserCS, 0) = 0
    THEN
      vbSummaBase := COALESCE (inSummCS, 0);
    ELSE
      vbSummaBase := COALESCE (inSummCS, 0) / COALESCE (inCountUserCS, 0);
    END IF;
    vbSumma := NULL;

    vbFormula   := 'База расчета: '||TRIM(to_char(COALESCE (inSummCS, 0), 'G999G999G999G999D99'))||' / '||
                    CAST(COALESCE (inCountUserCS, 0) AS TVarChar)||' = '||
                    TRIM(to_char(vbSummaBase, 'G999G999G999G999D99'))||
                    '; Количество приходов: '|| CAST(COALESCE (inCountUserAS, 0) AS TVarChar);

    RETURN QUERY
        SELECT vbSumma, vbSummaBase, vbFormula;

  ELSE

    RETURN QUERY
        SELECT Null::TFloat, Null::TFloat, 'Неизвестный тип расчета.'::TVarChar;
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Calculation_PayrollGroup (Integer, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.08.19                                                        *
*/

-- select * from gpSelect_Calculation_PayrollGroup(zc_Enum_PayrollType_WorkS(), 3, 0, 1, 2, 2, 2, 2, 1000, 10000, 2000);