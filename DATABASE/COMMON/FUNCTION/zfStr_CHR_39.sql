-- Function: zfStr_CHR_39 (TVarChar)

DROP FUNCTION IF EXISTS zfStr_CHR_39 (TVarChar);
DROP FUNCTION IF EXISTS zfStr_CHR_39 (Text);

CREATE OR REPLACE FUNCTION zfStr_CHR_39 (inValue Text)
RETURNS Text AS
$BODY$
BEGIN

     RETURN (CHR (39) || inValue || CHR (39)) ;

END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.07.20                                        * 
*/

-- ����
-- SELECT * FROM zfStr_CHR_39 ('2')
