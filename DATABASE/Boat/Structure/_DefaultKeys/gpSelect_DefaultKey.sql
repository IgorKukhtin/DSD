-- Function: gpSelect_DefaultKey(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_DefaultKey (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_DefaultKey(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Key TVarChar, FormClassName TVarChar, DescName TVarChar)
AS
$BODY$
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Account());
   
     RETURN QUERY 
       SELECT DefaultKeys.Id,
              DefaultKeys.Key, 
              ((DefaultKeys.KeyData::json)->>'FormClassName')::TVarChar AS FormClassName, 
              ((DefaultKeys.KeyData::json)->>'DescName')::TVarChar AS DescName 
         FROM DefaultKeys;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_DefaultKey (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.12.13                        *
*/

-- ����
-- SELECT * FROM gpSelect_DefaultKey (zfCalc_UserAdmin())