-- Function: gpSelect_�alculation_PayrollGroupBoard()

DROP FUNCTION IF EXISTS gpSelect_Calculation_PayrollGroupBoard (Integer, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean);

CREATE OR REPLACE FUNCTION gpSelect_Calculation_PayrollGroupBoard(
    IN inPayrollTypeID    Integer,
    IN inPercent          TFloat,
    IN inMinAccrualAmount TFloat,

    IN inCountUserCS      Integer,
    IN inCountUserAS      Integer,
    IN inCountUserNS      Integer,
    IN inCountUserSCS     Integer,
    IN inCountUserS       Integer,
    IN inCountUserSAS     Integer,

    IN inSummCS           TFloat,
    IN inSummSCS          TFloat,
    IN inSummHS           TFloat,
    IN inPharmacyItem     Boolean
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

  IF inPharmacyItem = True AND inPayrollTypeID in (zc_Enum_PayrollType_WorkAS(), zc_Enum_PayrollType_WorkSAS())
  THEN
    vbSummaBase := CASE WHEN (COALESCE (inCountUserCS, 0) + COALESCE (inCountUserAS, 0) + COALESCE (inCountUserSCS, 0) + COALESCE (inCountUserSAS, 0)) > 0
                        THEN (COALESCE (inSummCS, 0) + COALESCE (inSummSCS, 0)) / (COALESCE (inCountUserCS, 0) + COALESCE (inCountUserAS, 0) + COALESCE (inCountUserSCS, 0) + COALESCE (inCountUserSAS, 0))
                        ELSE 0 END;
    vbSumma := ROUND(COALESCE (vbSummaBase * inPercent / 100, 0), 2);

    vbFormula   := '���� �������: '||TRIM(to_char(COALESCE (inSummCS, 0) + COALESCE (inSummSCS, 0), 'G999G999G999G999D99'))||' / ('||
                    CAST(COALESCE (inCountUserCS, 0) AS TVarChar)||' + '||
                    CAST(COALESCE (inCountUserAS, 0) AS TVarChar)||' + '||
                    CAST(COALESCE (inCountUserSCS, 0) AS TVarChar)||' + '||
                    CAST(COALESCE (inCountUserSAS, 0) AS TVarChar)||') = '||
                    TRIM(to_char(vbSummaBase, 'G999G999G999G999D99'))||'; '||
                    '���������: ���� ���� % '||CAST(COALESCE (inPercent, 0) AS TVarChar)||
                    ' = '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    ' < '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' �� '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' ����� '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    '; ���������: '||TRIM(to_char(CASE WHEN vbSumma < inMinAccrualAmount THEN inMinAccrualAmount ELSE vbSumma END, 'G999G999G999G999D99'));

    RETURN QUERY
        SELECT CASE WHEN vbSumma < inMinAccrualAmount THEN inMinAccrualAmount ELSE vbSumma END, vbSummaBase, vbFormula;

  ELSEIF inPayrollTypeID IN (zc_Enum_PayrollType_WorkCS(), zc_Enum_PayrollType_WorkSCS()) 
  THEN
    vbSummaBase := CASE WHEN (COALESCE (inCountUserCS, 0) + COALESCE (inCountUserSCS, 0) + COALESCE (inCountUserSAS, 0)) > 0
                        THEN COALESCE (inSummCS, 0) / (COALESCE (inCountUserCS, 0) + COALESCE (inCountUserSCS, 0) + COALESCE (inCountUserSAS, 0))
                        ELSE 0 END +
                   CASE WHEN (COALESCE (inCountUserCS, 0) + COALESCE (inCountUserAS, 0) + COALESCE (inCountUserSCS, 0) + COALESCE (inCountUserSAS, 0)) > 0
                        THEN COALESCE (inSummSCS, 0) / (COALESCE (inCountUserCS, 0) + COALESCE (inCountUserAS, 0) + COALESCE (inCountUserSCS, 0) + COALESCE (inCountUserSAS, 0))
                        ELSE 0 END;
    vbSumma := ROUND(COALESCE (vbSummaBase * inPercent / 100, 0), 2);

    vbFormula   := '���� �������: '||TRIM(to_char(COALESCE (inSummCS, 0), 'G999G999G999G999D99'))||' / ('||
                    CAST(COALESCE (inCountUserCS, 0) AS TVarChar)||' + '||
                    CAST(COALESCE (inCountUserSCS, 0) AS TVarChar)||' + '||
                    CAST(COALESCE (inCountUserSAS, 0) AS TVarChar)||') + '||
                    TRIM(to_char( COALESCE (inSummSCS, 0), 'G999G999G999G999D99'))||' / ('||
                    CAST(COALESCE (inCountUserCS, 0) AS TVarChar)||' + '||
                    CAST(COALESCE (inCountUserAS, 0) AS TVarChar)||' + '||
                    CAST(COALESCE (inCountUserSCS, 0) AS TVarChar)||' + '||
                    CAST(COALESCE (inCountUserSAS, 0) AS TVarChar)||') = '||
                    TRIM(to_char(vbSummaBase, 'G999G999G999G999D99'))||'; '||
                    '���������: ���� ���� % '||CAST(COALESCE (inPercent, 0) AS TVarChar)||
                    ' = '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    ' < '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' �� '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' ����� '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    '; ���������: '||TRIM(to_char(CASE WHEN vbSumma < inMinAccrualAmount THEN inMinAccrualAmount ELSE vbSumma END, 'G999G999G999G999D99'));

    RETURN QUERY
        SELECT CASE WHEN vbSumma < inMinAccrualAmount THEN inMinAccrualAmount ELSE vbSumma END, vbSummaBase, vbFormula;

  ELSEIF inPayrollTypeID in (zc_Enum_PayrollType_WorkAS(), zc_Enum_PayrollType_WorkSAS())
  THEN
    vbSummaBase := CASE WHEN (COALESCE (inCountUserCS, 0) + COALESCE (inCountUserAS, 0) + COALESCE (inCountUserSCS, 0) + COALESCE (inCountUserSAS, 0)) > 0
                        THEN COALESCE (inSummSCS, 0) / (COALESCE (inCountUserCS, 0) + COALESCE (inCountUserAS, 0) + COALESCE (inCountUserSCS, 0) + COALESCE (inCountUserSAS, 0))
                        ELSE 0 END;
    vbSumma := ROUND(COALESCE (vbSummaBase * inPercent / 100, 0), 2);

    vbFormula   := '���� �������: '||TRIM(to_char(COALESCE (inSummSCS, 0), 'G999G999G999G999D99'))||' / ('||
                    CAST(COALESCE (inCountUserCS, 0) AS TVarChar)||' + '||
                    CAST(COALESCE (inCountUserAS, 0) AS TVarChar)||' + '||
                    CAST(COALESCE (inCountUserSCS, 0) AS TVarChar)||' + '||
                    CAST(COALESCE (inCountUserSAS, 0) AS TVarChar)||') = '||
                    TRIM(to_char(vbSummaBase, 'G999G999G999G999D99'))||'; '||
                    '���������: ���� ���� % '||CAST(COALESCE (inPercent, 0) AS TVarChar)||
                    ' = '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    ' < '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' �� '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' ����� '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    '; ���������: '||TRIM(to_char(CASE WHEN vbSumma < inMinAccrualAmount THEN inMinAccrualAmount ELSE vbSumma END, 'G999G999G999G999D99'));

    RETURN QUERY
        SELECT CASE WHEN vbSumma < inMinAccrualAmount THEN inMinAccrualAmount ELSE vbSumma END, vbSummaBase, vbFormula;

  ELSEIF inPayrollTypeID = zc_Enum_PayrollType_WorkNS()
  THEN
    vbSummaBase := COALESCE (inSummHS, 0) / COALESCE (inCountUserNS, 0);
    vbSumma := ROUND(COALESCE (vbSummaBase * inPercent / 100, 0), 2);

    vbFormula   := '���� �������: '||TRIM(to_char(COALESCE (inSummHS, 0), 'G999G999G999G999D99'))||' / '||
                    CAST(COALESCE (inCountUserNS, 0) AS TVarChar)||' = '||
                    TRIM(to_char(vbSummaBase, 'G999G999G999G999D99'))||'; '||
                    '���������: ���� ���� % '||CAST(COALESCE (inPercent, 0) AS TVarChar)||
                    ' = '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    ' < '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' �� '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' ����� '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    '; ���������: '||TRIM(to_char(CASE WHEN vbSumma < inMinAccrualAmount THEN inMinAccrualAmount ELSE vbSumma END, 'G999G999G999G999D99'));

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
    vbSumma := ROUND(COALESCE (vbSummaBase * inPercent / 100, 0), 2);

    vbFormula   := '���� �������: '||TRIM(to_char(COALESCE (inSummCS, 0), 'G999G999G999G999D99'))||' / '||
                    CAST(COALESCE (inCountUserCS, 0) AS TVarChar)||' = '||
                    TRIM(to_char(vbSummaBase, 'G999G999G999G999D99'))||
                    '; ���������� ��������: '|| CAST(COALESCE (inCountUserAS, 0) AS TVarChar)||
                    '; ���������: ���� ���� % '||CAST(COALESCE (inPercent, 0) AS TVarChar)||
                    ' = '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    ' < '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' �� '||TRIM(to_char(inMinAccrualAmount, 'G999G999G999G999D99'))||
                    ' ����� '||TRIM(to_char(vbSumma, 'G999G999G999G999D99'))||
                    '; ���������: '||TRIM(to_char(CASE WHEN vbSumma < inMinAccrualAmount THEN inMinAccrualAmount ELSE vbSumma END, 'G999G999G999G999D99'));

    RETURN QUERY
        SELECT CASE WHEN vbSumma < inMinAccrualAmount THEN inMinAccrualAmount ELSE vbSumma END, vbSummaBase, vbFormula;

  ELSE

    RETURN QUERY
        SELECT Null::TFloat, Null::TFloat, '����������� ��� �������.'::TVarChar;
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Calculation_PayrollGroupBoard (Integer, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean) OWNER TO postgres;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.09.19                                                        *
 23.08.19                                                        *
*/

-- select * from gpSelect_Calculation_PayrollGroupBoard(zc_Enum_PayrollType_WorkS(), 3, 0, 1, 2, 2, 2, 2, 2, 1000, 10000, 2000);