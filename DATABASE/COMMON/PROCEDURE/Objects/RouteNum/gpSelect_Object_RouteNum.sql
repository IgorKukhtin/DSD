-- Function: gpSelect_Object_RouteNum()

DROP FUNCTION IF EXISTS gpSelect_Object_RouteNum (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_RouteNum(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar, isErased boolean
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
   , ObjectString_Comment.ValueData  AS Comment
   , Object.isErased                 AS isErased
   FROM Object
        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object.Id 
                              AND ObjectString_Comment.DescId = zc_ObjectString_RouteNum_Comment()
   WHERE Object.DescId = zc_Object_RouteNum();
  
END;
$BODY$


LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.09.24         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_RouteNum('2')