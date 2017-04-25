-- Function: zfConvert_IntToNull

DROP FUNCTION IF EXISTS zfConvert_IntToNull (Integer);

CREATE OR REPLACE FUNCTION zfConvert_IntToNull (inValue Integer)
RETURNS Integer
AS
$BODY$
BEGIN
    RETURN CASE WHEN inValue = 0 THEN NULL ELSE inValue END;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.04.17                                        *
*/

-- ����
-- SELECT zfConvert_IntToNull (0), zfConvert_IntToNull (-1), zfConvert_IntToNull (1)
