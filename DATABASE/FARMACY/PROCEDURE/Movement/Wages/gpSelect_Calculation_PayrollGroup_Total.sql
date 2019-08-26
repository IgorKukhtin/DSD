-- Function: gpSelect_Calculation_PayrollGroup_Total()

DROP FUNCTION IF EXISTS gpSelect_Calculation_PayrollGroup_Total (Integer, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION gpSelect_Calculation_PayrollGroup_Total(
    IN inPayrollTypeID    Integer,
    IN inPercent          TFloat,
    IN inMinAccrualAmount TFloat,

    IN inSummaBase        TFloat
)
RETURNS TABLE (Summa TFloat
             , SummaBase TFloat
             , Formula TVarChar
             )
AS
$BODY$
   DECLARE vbSumma     TFloat;
   DECLARE vbFormula   TVarChar;
BEGIN

  IF inPayrollTypeID = zc_Enum_PayrollType_WorkS()
  THEN
    vbSumma := ROUND(COALESCE (inSummaBase * inPercent / 100, 0), 2);

    vbFormula   := 'База расчета: '||TRIM(to_char(inSummaBase, 'G999G999G999G999D99'))||'; '||
                    'Начислено: Если база % '||CAST(COALESCE (inPercent, 0) AS TVarChar)||
                    ' = '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    ' < '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' то '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' иначе '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    '; Начислено: '||TRIM(to_char(CASE WHEN vbSumma < inMinAccrualAmount THEN inMinAccrualAmount ELSE vbSumma END, 'G999G999G999G999D99'));

    RETURN QUERY
        SELECT vbSumma, inSummaBase, vbFormula;

  ELSE

    RETURN QUERY
        SELECT Null::TFloat, Null::TFloat, 'Неизвестный тип расчета.'::TVarChar;
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Calculation_PayrollGroup_Total (Integer, TFloat, TFloat, TFloat) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.08.19                                                        *
*/

-- select * from gpSelect_Calculation_PayrollGroup_Total(zc_Enum_PayrollType_WorkS(), 0.55, 7000, 11000);