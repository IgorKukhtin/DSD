-- Function: zfConvert_FIO ()

DROP FUNCTION IF EXISTS zfCalc_Position (TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION zfCalc_Position(
     inValue        Text,    -- ������ ������������
     inPos          TVarChar,
     inStartPos     Integer 
)
RETURNS Integer
AS
$BODY$
BEGIN
  IF TRIM (COALESCE (inValue, '')) = '' THEN  RETURN (0); END IF;

  RETURN
      POSITION ( inPos IN SUBSTRING(inValue, inStartPos, 255)::TVarChar) :: integer;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;



/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.07.20         *
*/

-- ����
-- SELECT zfCalc_Position('������� ���� ������������', '��', 4)
