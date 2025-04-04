-- Function: lfGet_Object_ValueData (Integer) - ������������ ��� �������� � Get-���������� (�.�. ��������� ��� � �� ������ ������ �������)

DROP FUNCTION IF EXISTS lfGet_Object_ValueData (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_ValueData (IN inId Integer)
RETURNS TVarChar
AS
$BODY$
BEGIN
     RETURN COALESCE ((SELECT CASE WHEN ObjectCode <> 0 AND DescId NOT IN (zc_Object_User()) THEN '(' || ObjectCode :: TVarChar || ')' ELSE '' END || ValueData
                       FROM Object
                       WHERE Id = inId
                      ), '');
          
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.10.13                                        *                            
*/

-- ����
-- SELECT * FROM lfGet_Object_ValueData (253246)
