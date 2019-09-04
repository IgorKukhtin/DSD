-- Function: zfCheckRunProc

DROP FUNCTION IF EXISTS zfCheckRunProc (TVarChar, Integer);

CREATE OR REPLACE FUNCTION zfCheckRunProc(
    IN inProcedureName   TVarChar, -- ��� ���������
    IN inMaxCountRun     Integer   -- ���������� ���������� �����
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
    RAISE EXCEPTION '������. ������ ����� <%> ����� ��������� <%> ��������.', inMaxCountRun, inProcedureName;
  END IF;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 04.09.19                                                      *
*/

-- ����
-- SELECT zfCheckRunProc (inProcedureName := 'gpSelect_CashRemains_Diff_ver2', inMaxCountRun := 1)
