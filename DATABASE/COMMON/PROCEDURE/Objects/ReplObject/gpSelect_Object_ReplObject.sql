-- Function: gpSelect_Object_ReplObject()

DROP FUNCTION IF EXISTS gpSelect_Object_ReplObject(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReplObject(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean
) AS
$BODY$
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReplObject()());

   RETURN QUERY 
   SELECT Object_ReplObject.Id         AS Id 
        , Object_ReplObject.ObjectCode AS Code
        , Object_ReplObject.ValueData  AS Name
        , Object_ReplObject.isErased   AS isErased
   FROM Object AS Object_ReplObject 
   WHERE Object_ReplObject.DescId = zc_Object_ReplObject();
  
END;
$BODY$


LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.06.18         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ReplObject('2')