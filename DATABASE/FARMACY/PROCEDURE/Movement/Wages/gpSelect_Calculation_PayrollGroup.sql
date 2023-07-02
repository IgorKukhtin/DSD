-- Function: gpSelect_Сalculation_PayrollGroup()

--DROP FUNCTION IF EXISTS gpSelect_Calculation_PayrollGroup (Integer, TFloat, TFloat, Integer, TFloat, Integer, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpSelect_Calculation_PayrollGroup (Integer, TFloat, TFloat, Integer, TFloat, TFloat, Integer, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpSelect_Calculation_PayrollGroup (TDateTime, Integer, TFloat, TFloat, Integer, TFloat, TFloat, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Calculation_PayrollGroup (TDateTime, Integer, TFloat, TFloat, Integer, TFloat, TFloat, Integer, TFloat, TVarChar, TFloat);


CREATE OR REPLACE FUNCTION gpSelect_Calculation_PayrollGroup(
    IN inOperDate         TDateTime,
    IN inPayrollTypeID    Integer,
    IN inPercent          TFloat,
    IN inMinAccrualAmount TFloat,
    IN inCountDoc         Integer,
    IN inSummBase         TFloat,
    IN inSummBaseSite     TFloat,
    IN inCountUser        Integer,
    IN inCorrPercentage   TFloat,
    IN inDetals           TVarChar,
    IN inSoldPlan         TFloat
)
RETURNS TABLE (Summa TFloat
             , SummaBase TFloat
             , SummaBaseSite TFloat
             , Formula TVarChar
             )
AS
$BODY$
   DECLARE vbSumma         TFloat;
   DECLARE vbSummaBase     TFloat;
   DECLARE vbSummaBaseSite TFloat;
   DECLARE vbSummaCalс     TFloat;
   DECLARE vbSummaSoldPlan TFloat;
   DECLARE vbFormula       TVarChar;
   DECLARE vbPercentSite   TFloat;
BEGIN

  IF inOperDate >= '01.07.2021'
  THEN
    vbPercentSite := 2;
  ELSE
    vbPercentSite := 1;
  END IF;

  IF inPayrollTypeID IN (zc_Enum_PayrollType_WorkCS(), zc_Enum_PayrollType_WorkSCS(), zc_Enum_PayrollType_WorkAS(), zc_Enum_PayrollType_WorkSAS(), zc_Enum_PayrollType_WorkI())
  THEN
    vbSummaBase := inSummBase;
    vbSummaBaseSite := inSummBaseSite;
    vbSumma := ROUND(COALESCE (vbSummaBase * inPercent / 100, 0), 2) + ROUND(COALESCE (vbSummaBaseSite * vbPercentSite / 100, 0), 2);
    
    IF inPayrollTypeID = zc_Enum_PayrollType_WorkCS() AND
       COALESCE (inSoldPlan, 0) > 0 AND
       COALESCE (inSoldPlan, 0) < COALESCE (vbSummaBase, 0) + COALESCE (vbSummaBaseSite, 0)
    THEN
      IF COALESCE (inCountUser, 0) = 0
      THEN
        vbSummaSoldPlan := ROUND((COALESCE (vbSummaBase, 0) + COALESCE (vbSummaBaseSite, 0) - COALESCE (inSoldPlan, 0)) * 0.03, 2);
      ELSE
        vbSummaSoldPlan := ROUND((COALESCE (vbSummaBase, 0) + COALESCE (vbSummaBaseSite, 0) - COALESCE (inSoldPlan, 0)) / inCountUser * 0.03, 2);
      END IF;
    ELSE
      vbSummaSoldPlan := 0;
    END IF;
    
    vbSummaCalс := CASE WHEN vbSumma < (inMinAccrualAmount + vbSummaSoldPlan) THEN inMinAccrualAmount + vbSummaSoldPlan ELSE vbSumma END;
    IF COALESCE (inCorrPercentage, 100) <> 100
    THEN
      vbSummaCalс := ROUND(vbSummaCalс * inCorrPercentage / 100, 2);
    END IF;


    vbFormula   := ('База расчета: '||inDetals||' = '||zfConvert_FloatToString(vbSummaBase + COALESCE (vbSummaBaseSite, 0))||
                    '; Начислено: Если база '||zfConvert_FloatToString(COALESCE (inPercent, 0))||' % '||CASE WHEN COALESCE (vbSummaBaseSite, 0) > 0 THEN ' + база сайта '||zfConvert_FloatToString(vbPercentSite)||' % ' ELSE '' END||
                    ' = '||zfConvert_FloatToString(vbSumma)||
                    ' < '||zfConvert_FloatToString(inMinAccrualAmount)||
                    CASE WHEN vbSummaSoldPlan > 0 THEN ' + '||zfConvert_FloatToString(vbSummaSoldPlan) ELSE '' END||
                    ' то '||zfConvert_FloatToString(inMinAccrualAmount)||
                    CASE WHEN vbSummaSoldPlan > 0 THEN ' + '||zfConvert_FloatToString(vbSummaSoldPlan) ELSE '' END||
                    ' иначе '||zfConvert_FloatToString(vbSumma)||
                    CASE WHEN COALESCE (inCorrPercentage, 100) <> 100 THEN '; Коэффициент  '||zfConvert_FloatToString(inCorrPercentage / 100) ELSE '' END
                    --'; Начислено: '||zfConvert_FloatToString(vbSummaCalс)
                    )::TVarChar;

    RETURN QUERY
        SELECT vbSummaCalс, (vbSummaBase + vbSummaBaseSite)::TFloat, vbSummaBaseSite, vbFormula;

  ELSEIF inPayrollTypeID = zc_Enum_PayrollType_WorkNS()
  THEN
    vbSummaBase := inSummBase;
    vbSummaBaseSite := inSummBaseSite;
    vbSumma := ROUND(COALESCE (vbSummaBase * inPercent / 100, 0), 2);
    vbSummaCalс := CASE WHEN vbSumma < inMinAccrualAmount THEN inMinAccrualAmount ELSE vbSumma END;
    IF COALESCE (inCorrPercentage, 100) <> 100
    THEN
      vbSummaCalс := ROUND(vbSummaCalс * inCorrPercentage / 100, 2);
    END IF;

    vbFormula   := 'База расчета: '||inDetals||' = '||
                    zfConvert_FloatToString(vbSummaBase)||'; '||
                    'Начислено: Если база '||zfConvert_FloatToString(COALESCE (inPercent, 0))||' % '||
                    ' = '||zfConvert_FloatToString(vbSumma)||
                    ' < '||zfConvert_FloatToString(inMinAccrualAmount)||
                    ' то '||zfConvert_FloatToString(inMinAccrualAmount)||
                    ' иначе '||zfConvert_FloatToString(vbSumma)||
                    CASE WHEN COALESCE (inCorrPercentage, 100) <> 100 THEN '; Коэффициент  '||zfConvert_FloatToString(inCorrPercentage / 100) ELSE '' END||
                    '; Начислено: '||zfConvert_FloatToString(vbSummaCalс);

    RETURN QUERY
        SELECT vbSummaCalс, vbSummaBase, vbSummaBaseSite, vbFormula;

  ELSEIF inPayrollTypeID in (zc_Enum_PayrollType_WorkS(), zc_Enum_PayrollType_WorkIS(), zc_Enum_PayrollType_WorkSSAS())
  THEN
    IF COALESCE (inCountUser, 0) = 0
    THEN
      vbSummaBase := COALESCE (inSummBase, 0);
      vbSummaBaseSite := COALESCE (inSummBaseSite, 0);
    ELSE
      vbSummaBase := COALESCE (inSummBase, 0) / COALESCE (inCountUser, 0);
      vbSummaBaseSite := COALESCE (inSummBaseSite, 0) / COALESCE (inCountUser, 0);
    END IF;

    vbSumma := ROUND(COALESCE (vbSummaBase * inPercent / 100, 0), 2);
    vbSummaCalс := CASE WHEN vbSumma < inMinAccrualAmount THEN inMinAccrualAmount ELSE vbSumma END;
    IF COALESCE (inCorrPercentage, 100) <> 100
    THEN
      vbSummaCalс := ROUND(vbSummaCalс * inCorrPercentage / 100, 2);
    END IF;

    vbFormula   := 'База расчета: '||zfConvert_FloatToString(COALESCE (inSummBase, 0))||' / ('||
                    zfConvert_FloatToString(COALESCE (inCountUser, 1))||') = '||
                    zfConvert_FloatToString(vbSummaBase)||'; '||
                    'Начислено: Если база '||zfConvert_FloatToString(COALESCE (inPercent, 0))||' % '||
                    ' = '||zfConvert_FloatToString(vbSumma)||
                    ' < '||zfConvert_FloatToString(inMinAccrualAmount)||
                    ' то '||zfConvert_FloatToString(inMinAccrualAmount)||
                    ' иначе '||zfConvert_FloatToString(vbSumma)||
                    CASE WHEN COALESCE (inCorrPercentage, 100) <> 100 THEN '; Коэффициент  '||zfConvert_FloatToString(inCorrPercentage / 100) ELSE '' END||
                    '; Начислено: '||zfConvert_FloatToString(vbSummaCalс);

    RETURN QUERY
        SELECT vbSummaCalс, vbSummaBase, vbSummaBaseSite, vbFormula;

  ELSEIF inPayrollTypeID in (zc_Enum_PayrollType_WorkBid(), zc_Enum_PayrollType_WorkSBid())
  THEN

    vbSummaBase := 0;
    vbSummaBaseSite := 0;
    vbSumma := inMinAccrualAmount;
    vbSummaCalс := inMinAccrualAmount;
    IF COALESCE (inCorrPercentage, 100) <> 100
    THEN
      vbSummaCalс := ROUND(vbSummaCalс * inCorrPercentage / 100, 2);
    END IF;

    vbFormula   := 'Ставка на день: '||zfConvert_FloatToString(vbSummaCalс);

    RETURN QUERY
        SELECT vbSummaCalс, vbSummaBase, vbSummaBaseSite, vbFormula;

  ELSE

    RETURN QUERY
        SELECT Null::TFloat, Null::TFloat, Null::TFloat, 'Неизвестный тип расчета.'::TVarChar;
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Calculation_PayrollGroup (TDateTime, Integer, TFloat, TFloat, Integer, TFloat, TFloat, Integer, TFloat, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.09.19                                                        *
 23.08.19                                                        *
*/

-- 
select * from gpSelect_Calculation_PayrollGroup('01.07.2023', zc_Enum_PayrollType_WorkCS(), 3, 1200, 3, 40813.63 - 3589.65, 3589.65, 0, 100, '', 16129.03);