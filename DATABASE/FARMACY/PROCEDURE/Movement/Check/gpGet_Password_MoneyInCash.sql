-- Function: gpGet_Password_MoneyInCash()

DROP FUNCTION IF EXISTS gpGet_Password_MoneyInCash(TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Password_MoneyInCash(
   OUT outPassword   TVarChar,      -- ��������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TVarChar 
AS
$BODY$
BEGIN
  
  SELECT DefaultValue into outPassword
  FROM DefaultValue 
    JOIN DefaultKeys ON DefaultKeys.Id = DefaultValue.DefaultKeyId
  WHERE DefaultKeys.Key = 'zc_Password_MoneyInCash'
  LIMIT 1;
  if COALESCE(outPassword,'') = '' THEN
    outPassword := '0503202841'; -- 'qsxqsxw1';
  END IF;    
END;
$BODY$

LANGUAGE plpgsql IMMUTABLE;
ALTER FUNCTION gpGet_Password_MoneyInCash(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.02.14                         * add LEFT ��� ������������.
 20.12.13                         *

*/

-- ����
-- SELECT * FROM gpGet_Password_MoneyInCash('2')