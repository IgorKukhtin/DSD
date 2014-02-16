-- Function: lfGet_Object_ValueData (Integer) - ������������ ��� �������� � Get-���������� (�.�. ��������� ��� � �� ������ ������ �������)

DROP FUNCTION IF EXISTS lfGet_Object_ValueData (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_ValueData (IN inId Integer)
  RETURNS TVarChar
AS
$BODY$
BEGIN
     RETURN (SELECT ValueData FROM Object where Id = inId);
          
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfGet_Object_ValueData (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.10.13                                        *                            
*/

-- ����
-- SELECT * FROM lfGet_Object_ValueData (1)
