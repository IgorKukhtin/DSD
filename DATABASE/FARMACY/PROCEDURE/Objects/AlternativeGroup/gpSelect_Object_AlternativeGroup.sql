DROP FUNCTION IF EXISTS gpSelect_Object_AlternativeGroup(Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_AlternativeGroup(
    IN inIsShowDel   Boolean,       --���������� 0 - ������ ������� ������ / 1 - ��� �� ���������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Name TVarChar, isErased boolean) 
AS
$BODY$
DECLARE
  vbUserId Integer;
BEGIN
  vbUserId:= lpGetUserBySession (inSession);
  -- ���������
  RETURN QUERY
    SELECT
      Object_AlternativeGroup_View.Id
     ,Object_AlternativeGroup_View.Name
     ,Object_AlternativeGroup_View.isErased
    FROM Object_AlternativeGroup_View
	WHERE
	  (
	    inIsShowDel = True
		or
		Object_AlternativeGroup_View.isErased = False
	  )
    ORDER BY
      Name;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_AlternativeGroup(Boolean,TVarChar) OWNER TO postgres;
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 28.06.15                                                        *

*/

-- ����
-- SELECT * FROM gpSelect_Object_AlternativeGroup (True,'3');