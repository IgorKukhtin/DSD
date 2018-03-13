-- Function: lfGet_Object_ValueData_sh (Integer) - ������������ ��� �������� � Get-���������� (�.�. ��������� ��� � �� ������ ������ �������)

DROP FUNCTION IF EXISTS lfGet_Object_ValueData_sh (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_ValueData_sh (IN inId Integer)
  RETURNS TVarChar
AS
$BODY$
BEGIN
     RETURN COALESCE ((SELECT ValueData FROM Object where Id = inId), '');
          
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfGet_Object_ValueData_sh (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.01.18                                        *                            
*/

-- ����
-- SELECT * FROM lfGet_Object_ValueData_sh (1)
