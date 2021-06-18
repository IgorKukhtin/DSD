-- Function: gpSelect_�alculation_PayrollGroup()

--DROP FUNCTION IF EXISTS gpSelect_Calculation_PayrollGroup (Integer, TFloat, TFloat, Integer, TFloat, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Calculation_PayrollGroup (Integer, TFloat, TFloat, Integer, TFloat, TFloat, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Calculation_PayrollGroup(
    IN inPayrollTypeID    Integer,
    IN inPercent          TFloat,
    IN inMinAccrualAmount TFloat,
    IN inCountDoc         Integer,
    IN inSummBase         TFloat,
    IN inSummBaseSite     TFloat,
    IN inCountUser        Integer,
    IN inCorrPercentage   TFloat,
    IN inDetals           TVarChar
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
   DECLARE vbSummaCal�     TFloat;
   DECLARE vbFormula       TVarChar;
BEGIN

  IF inPayrollTypeID IN (zc_Enum_PayrollType_WorkCS(), zc_Enum_PayrollType_WorkSCS(), zc_Enum_PayrollType_WorkAS(), zc_Enum_PayrollType_WorkSAS(), zc_Enum_PayrollType_WorkI())
  THEN
    vbSummaBase := inSummBase;
    vbSummaBaseSite := inSummBaseSite;
    vbSumma := ROUND(COALESCE (vbSummaBase * inPercent / 100, 0), 2) + ROUND(COALESCE (vbSummaBaseSite * 1 / 100, 0), 2);
    vbSummaCal� := CASE WHEN vbSumma < inMinAccrualAmount THEN inMinAccrualAmount ELSE vbSumma END;
    IF COALESCE (inCorrPercentage, 100) <> 100
    THEN
      vbSummaCal� := ROUND(vbSummaCal� * inCorrPercentage / 100, 2);
    END IF;


    vbFormula   := ('���� �������: '||inDetals||' = '||
                    TRIM(to_char(vbSummaBase + COALESCE (vbSummaBaseSite, 0), 'G999G999G999G999D99'))||
                    '; ���������: ���� ���� % '||CAST(COALESCE (inPercent, 0) AS TVarChar)||CASE WHEN COALESCE (vbSummaBaseSite, 0) > 0 THEN ' + ���� ����� 1 % ' ELSE '' END||
                    ' = '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    ' < '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' �� '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' ����� '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    CASE WHEN COALESCE (inCorrPercentage, 100) <> 100 THEN '; �����������  '||TRIM(to_char(inCorrPercentage / 100, 'G999G999G999G990D99')) ELSE '' END
                    --'; ���������: '||TRIM(to_char(vbSummaCal�, 'G999G999G999G999D99'))
                    )::TVarChar;

    RETURN QUERY
        SELECT vbSummaCal�, (vbSummaBase + vbSummaBaseSite)::TFloat, vbSummaBaseSite, vbFormula;

  ELSEIF inPayrollTypeID = zc_Enum_PayrollType_WorkNS()
  THEN
    vbSummaBase := inSummBase;
    vbSummaBaseSite := inSummBaseSite;
    vbSumma := ROUND(COALESCE (vbSummaBase * inPercent / 100, 0), 2);
    vbSummaCal� := CASE WHEN vbSumma < inMinAccrualAmount THEN inMinAccrualAmount ELSE vbSumma END;
    IF COALESCE (inCorrPercentage, 100) <> 100
    THEN
      vbSummaCal� := ROUND(vbSummaCal� * inCorrPercentage / 100, 2);
    END IF;

    vbFormula   := '���� �������: '||inDetals||' = '||
                    TRIM(to_char(vbSummaBase, 'G999G999G999G999D99'))||'; '||
                    '���������: ���� ���� % '||CAST(COALESCE (inPercent, 0) AS TVarChar)||
                    ' = '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    ' < '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' �� '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' ����� '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    CASE WHEN COALESCE (inCorrPercentage, 100) <> 100 THEN '; �����������  '||TRIM(to_char(inCorrPercentage / 100, 'G999G999G999G990D99')) ELSE '' END||
                    '; ���������: '||TRIM(to_char(vbSummaCal�, 'G999G999G999G999D99'));

    RETURN QUERY
        SELECT vbSummaCal�, vbSummaBase, vbSummaBaseSite, vbFormula;

  ELSEIF inPayrollTypeID in (zc_Enum_PayrollType_WorkS(), zc_Enum_PayrollType_WorkIS())
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
    vbSummaCal� := CASE WHEN vbSumma < inMinAccrualAmount THEN inMinAccrualAmount ELSE vbSumma END;
    IF COALESCE (inCorrPercentage, 100) <> 100
    THEN
      vbSummaCal� := ROUND(vbSummaCal� * inCorrPercentage / 100, 2);
    END IF;

    vbFormula   := '���� �������: '||TRIM(to_char(COALESCE (inSummBase, 0), 'G999G999G999G999D99'))||' / ('||
                    CAST(COALESCE (inCountUser, 1) AS TVarChar)||') = '||
                    TRIM(to_char(vbSummaBase, 'G999G999G999G999D99'))||'; '||
                    '���������: ���� ���� % '||CAST(COALESCE (inPercent, 0) AS TVarChar)||
                    ' = '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    ' < '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' �� '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' ����� '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    CASE WHEN COALESCE (inCorrPercentage, 100) <> 100 THEN '; �����������  '||TRIM(to_char(inCorrPercentage / 100, 'G999G999G999G990D99')) ELSE '' END||
                    '; ���������: '||TRIM(to_char(vbSummaCal�, 'G999G999G999G999D99'));

    RETURN QUERY
        SELECT vbSummaCal�, vbSummaBase, vbSummaBaseSite, vbFormula;

  ELSE

    RETURN QUERY
        SELECT Null::TFloat, Null::TFloat, Null::TFloat, '����������� ��� �������.'::TVarChar;
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Calculation_PayrollGroup (Integer, TFloat, TFloat, Integer, TFloat, TFloat, Integer, TFloat, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.09.19                                                        *
 23.08.19                                                        *
*/

-- select * from gpSelect_Calculation_PayrollGroup(zc_Enum_PayrollType_WorkS(), 3, 0, 3, 1000, 0, '');