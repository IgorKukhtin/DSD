-- Function: gpSelect_Week()

DROP FUNCTION IF EXISTS gpSelect_Week(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Week(
    IN inSession     TVarChar    -- ������ ������������
)
  RETURNS TABLE (
     Id Integer, 
     Name TVarChar
     )
AS
$BODY$
BEGIN

  RETURN QUERY
  SELECT 1::Integer, '�����������'::TVarChar
  UNION ALL
  SELECT 2::Integer, '�������'::TVarChar
  UNION ALL
  SELECT 3::Integer, '�����'::TVarChar
  UNION ALL
  SELECT 4::Integer, '�������'::TVarChar
  UNION ALL
  SELECT 5::Integer, '�������'::TVarChar
  UNION ALL
  SELECT 6::Integer, '�������'::TVarChar
  UNION ALL
  SELECT 7::Integer, '�����������'::TVarChar;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Week (TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.12.18                                                       *
*/

-- ����
-- select * from gpSelect_Week(inSession := '3');