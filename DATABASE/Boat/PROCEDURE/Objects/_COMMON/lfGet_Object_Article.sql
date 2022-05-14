-- Function: lfGet_Object_Article (Integer) - ������������ ��� �������� � Get-���������� (�.�. ��������� ��� � �� ������ ������ �������)

DROP FUNCTION IF EXISTS lfGet_Object_Article (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_Article (IN inObjectId Integer)
RETURNS TVarChar
AS
$BODY$
BEGIN
     RETURN COALESCE ((SELECT ValueData FROM ObjectString where ObjectId = inObjectId AND DescId = zc_ObjectString_Article()), '');
          
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.05.22                                        *                            
*/

-- ����
-- SELECT * FROM lfGet_Object_Article (1)
