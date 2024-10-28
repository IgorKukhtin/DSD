-- Function: gpSelect_Object_PositionProperty()

DROP FUNCTION IF EXISTS gpSelect_Object_PositionProperty (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PositionProperty(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   
    -- �������� ���� ������������ �� ����� ���������
      vbUserId:= lpGetUserBySession (inSession);
   
   RETURN QUERY 
   SELECT 
     Object.Id                       AS Id 
   , Object.ObjectCode               AS Code
   , Object.ValueData                AS Name
   , Object.isErased                 AS isErased
   FROM Object
   WHERE Object.DescId = zc_Object_PositionProperty();
  
END;
$BODY$


LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.10.24         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_PositionProperty('2')