-- Function: gpSelect_Google_APIKey()

DROP FUNCTION IF EXISTS gpSelect_Google_APIKey (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Google_APIKey (
 OUT outAPIKey          TVarChar,
  IN inSession          TVarChar    -- ������ ������������
)
RETURNS TVarChar 
AS
$BODY$
BEGIN
  outAPIKey := zc_Google_APIKey();
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.   ������ �.�.
 20.03.19                                                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Google_APIKey (inSession := '5');
