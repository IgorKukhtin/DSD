-- Function: zfCalc_FromHex 

DROP FUNCTION IF EXISTS zfCalc_FromHex  (Text);

CREATE FUNCTION zfCalc_FromHex (inValue Text)
RETURNS BIGINT AS
$BODY$
DECLARE
  vbRetV BIGINT;
BEGIN
  EXECUTE('SELECT CAST(x'''||inValue||''' AS BIGINT)') INTO vbRetV;
  RETURN vbRetV;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.08.14                        *
*/

-- ����
-- SELECT * FROM zfCalc_FromHex (inValue:= '123')
