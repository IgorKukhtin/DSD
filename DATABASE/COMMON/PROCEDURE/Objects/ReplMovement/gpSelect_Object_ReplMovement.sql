-- Function: gpSelect_Object_ReplMovement()

DROP FUNCTION IF EXISTS gpSelect_Object_ReplMovement(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReplMovement(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean
) AS
$BODY$
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReplMovement()());

   RETURN QUERY 
   SELECT Object_ReplMovement.Id         AS Id 
        , Object_ReplMovement.ObjectCode AS Code
        , Object_ReplMovement.ValueData  AS Name
        , Object_ReplMovement.isErased   AS isErased
   FROM Object AS Object_ReplMovement
   WHERE Object_ReplMovement.DescId = zc_Object_ReplMovement();
  
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
-- SELECT * FROM gpSelect_Object_ReplMovement('2')