-- Function: gpSelect_Object_ClientPartner()

DROP FUNCTION IF EXISTS gpSelect_Object_ClientPartner (Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ClientPartner(
    IN inisShowAll         Boolean,     -- �������� ���
    IN inSession           TVarChar     -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , DescId Integer, DescName TVarChar
             , isErased Boolean
)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
       
        SELECT 
            Object_ClientPartner.Id
          , Object_ClientPartner.ObjectCode AS Code
          , Object_ClientPartner.ValueData  AS Name
          , Object_ClientPartner.DescId     AS DescId
          , ObjectDesc.ItemName             AS DescName
          , Object_ClientPartner.isErased
        FROM Object AS Object_ClientPartner
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_ClientPartner.DescId
        WHERE Object_ClientPartner.DescId in (zc_Object_Partner(),zc_Object_Client())
          AND (Object_ClientPartner.isErased = FALSE OR inisShowAll = TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.02.21         *
 */

-- ����
-- SELECT * FROM gpSelect_Object_ClientPartner (inisShowAll := FALSE, inSession := zfCalc_UserAdmin())
