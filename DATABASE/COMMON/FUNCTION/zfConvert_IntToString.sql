-- Function: zfConvert_IntToString

DROP FUNCTION IF EXISTS zfConvert_IntToString (Integer, Integer);

CREATE OR REPLACE FUNCTION zfConvert_IntToString (Value Integer, Len Integer = 0)
RETURNS TVarChar
AS
$BODY$
  DECLARE vbRes TVarChar;
BEGIN
  vbRes := Value :: TVarChar;
  
  WHILE length(vbRes) <= Len
  LOOP
      vbRes := ' '||vbRes;
  END LOOP;  

  RETURN vbRes;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfConvert_IntToString (Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.02.16                                        *
*/

-- ����
-- 
SELECT * FROM zfConvert_IntToString (1, 2)