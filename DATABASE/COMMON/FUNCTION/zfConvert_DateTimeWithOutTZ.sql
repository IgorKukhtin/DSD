-- Function: zfConvert_DateTimeWithOutTZ

DROP FUNCTION IF EXISTS zfConvert_DateTimeWithOutTZ (TDateTime);

CREATE OR REPLACE FUNCTION zfConvert_DateTimeWithOutTZ (Value TDateTime)
RETURNS TIMESTAMP WITHOUT TIME ZONE
AS
$BODY$
BEGIN
  RETURN Value;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfConvert_DateTimeWithOutTZ (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.03.18                                        *
*/

-- ����
-- SELECT * FROM zfConvert_DateTimeWithOutTZ (CURRENT_TIMESTAMP)
