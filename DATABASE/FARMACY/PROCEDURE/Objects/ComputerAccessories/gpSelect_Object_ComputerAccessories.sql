-- Function: gpSelect_Object_ComputerAccessories()

DROP FUNCTION IF EXISTS gpSelect_Object_ComputerAccessories(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ComputerAccessories(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$BEGIN


   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY
   SELECT
          Object_ComputerAccessories.Id                 AS Id
        , Object_ComputerAccessories.ObjectCode         AS Code
        , Object_ComputerAccessories.ValueData          AS Name
        
        , Object_ComputerAccessories.isErased           AS isErased

   FROM Object AS Object_ComputerAccessories

   WHERE Object_ComputerAccessories.DescId = zc_Object_ComputerAccessories();

END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ComputerAccessories(TVarChar) OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 14.07.20                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ComputerAccessories( '3')