-- Function: gpSelect_Object_Education(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Education(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Education(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Education());

   RETURN QUERY 
     SELECT 
           Object_Education.Id             AS Id
         , Object_Education.ObjectCode     AS Code
         , Object_Education.ValueData      AS Name
         , Object_Education.isErased       AS isErased
     FROM OBJECT AS Object_Education
     WHERE Object_Education.DescId = zc_Object_Education();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Education(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.01.16         *              

*/

-- ����
-- SELECT * FROM gpSelect_Object_Education('2')