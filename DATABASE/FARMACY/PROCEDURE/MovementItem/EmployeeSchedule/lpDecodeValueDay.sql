-- Function: lpGetEmployeeScheduleDay()

DROP FUNCTION IF EXISTS lpDecodeValueDay(Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpDecodeValueDay(
    IN inId  Integer,       -- ���� ���������
    IN inValue TVarChar
)
  RETURNS TVarChar 
AS
$BODY$
BEGIN
  RETURN(CASE SUBSTRING(inValue, inId, 1)::Integer
                    WHEN 1 THEN '8:00'
                    WHEN 2 THEN '9:00'
                    WHEN 3 THEN '10:00'
                    ELSE NULL END);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpDecodeValueDay (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.12.18                                                       *
*/

-- ����
-- select * from lpDecodeValueDay(inId := 2, inValue := '0100000000000000000000000000000');