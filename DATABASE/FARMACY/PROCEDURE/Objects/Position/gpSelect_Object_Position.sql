-- Function: gpSelect_Object_Position(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Position(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Position(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Position());

   RETURN QUERY 
     SELECT 
           Object_Position.Id             AS Id
         , Object_Position.ObjectCode     AS Code
         , Object_Position.ValueData      AS Name
         , Object_Position.isErased       AS isErased
     FROM OBJECT AS Object_Position
     WHERE Object_Position.DescId = zc_Object_Position();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Position(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.01.16         *              

*/

-- ����
-- SELECT * FROM gpSelect_Object_Position('2')