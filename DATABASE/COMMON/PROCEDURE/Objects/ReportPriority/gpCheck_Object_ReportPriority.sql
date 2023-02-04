-- Function: gpCheck_Object_ReportPriority()

DROP FUNCTION IF EXISTS gpCheck_Object_ReportPriority (TVarChar);

CREATE OR REPLACE FUNCTION gpCheck_Object_ReportPriority(
    IN inProcName    TVarChar,           --
    IN inSession     TVarChar            -- ������ ������������
)
RETURNS TABLE (Second_pause   Integer
             , Message_pause  Text
              )
AS
$BODY$
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReportPriority());

      RETURN QUERY
        WITH tmpProcess AS (SELECT * FROM pg_stat_activity WHERE state ILIKE 'active')
            , tmpSecond AS (SELECT CASE WHEN 25 < (SELECT COUNT(*) FROM tmpProcess)
                                             THEN 60
                                        WHEN 1 < (SELECT COUNT (*) AS Res FROM tmpProcess WHERE query ILIKE ('%' || inProcName || '%'))
                                             THEN 25
                                        ELSE 0
                                   END :: Integer AS Value
                           )
        -- ���������
        SELECT
               -- ���-�� ������ ��������
               tmpSecond.Value AS Second_pause
               -- ��������� �� ����� ��������
             , CASE tmpSecond.Value

                    WHEN 60 THEN '��� ������ �� ����� ���� ��������. �������� ��������� = '
                              || ' <' || (SELECT COUNT (*) AS Res FROM tmpProcess WHERE query ILIKE ('%' || inProcName || '%')) :: TVarChar || '>.'
                              || CHR (13)
                              || '����� �������� = <' || tmpSecond.Value :: TVarChar || '> ������.'

                    WHEN 25 THEN '��� ������ �� ����� ���� ��������, �.�. ����������� ������ ��� ����������� ������ �������������.'
                              || CHR (13)
                              || '����� �������� = <' || tmpSecond.Value :: TVarChar || '> ������.'

                    ELSE ''
               END :: Text AS Message_pause
        FROM tmpSecond
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
  28.04.17                                                       *
*/

-- ����
-- SELECT * FROM gpCheck_Object_ReportPriority (inProcName:= '', inSession:= zfCalc_UserAdmin())
