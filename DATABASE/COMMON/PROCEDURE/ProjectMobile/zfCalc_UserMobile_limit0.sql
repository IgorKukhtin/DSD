-- Function: zfCalc_UserMobile_limit0 ()

DROP FUNCTION IF EXISTS zfCalc_UserMobile_limit0 (Integer);
DROP FUNCTION IF EXISTS zfCalc_UserMobile_limit0 ();

CREATE OR REPLACE FUNCTION zfCalc_UserMobile_limit0()
RETURNS Integer
AS
$BODY$
BEGIN
      -- ���������
    -- RETURN 1160641;
    -- RETURN 4057829; 
    -- RETURN 1059546; -- ���� �.�.
    RETURN 0; -- 1058558

END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.04.17                                        *
*/

-- ����
-- SELECT * FROM Object WHERE Id = zfCalc_UserMobile_limit0()
