-- Function: zfCalc_UserMobile_limit0 ()

DROP FUNCTION IF EXISTS zfCalc_UserMobile_limit0 (Integer);
DROP FUNCTION IF EXISTS zfCalc_UserMobile_limit0 ();

CREATE OR REPLACE FUNCTION zfCalc_UserMobile_limit0()
RETURNS Integer
AS
$BODY$
BEGIN
      -- ���������
    --RETURN 6120588;
      RETURN 0;
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
