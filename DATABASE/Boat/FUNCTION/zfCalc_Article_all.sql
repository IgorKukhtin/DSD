-- Function: zfCalc_Article_all (TVarChar)

DROP FUNCTION IF EXISTS zfCalc_Article_all (TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_Article_all (inValueData TVarChar)
RETURNS TVarChar
AS
$BODY$
  DECLARE vbRetV TVarChar;
BEGIN
      vbRetV:= REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (inValueData, '.', ''), '-', ''), ' ', ''), '=', ''), ',', '');

      RETURN (CASE WHEN vbRetV <> inValueData THEN  vbRetV || '___' || inValueData ELSE inValueData END);

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.05.22                                        *
*/

-- ����
-- SELECT zfCalc_Article_all ('123')
