-- Function: gpGet_Object_Education (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Education (Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Education(
    IN inId          Integer,        -- ���������
    IN inSession     TVarChar        -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Education());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Education()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
     SELECT 
           Object_Education.Id             AS Id
         , Object_Education.ObjectCode     AS Code
         , Object_Education.ValueData      AS Name
         , Object_Education.isErased       AS isErased
     FROM OBJECT AS Object_Education
     WHERE Object_Education.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Education(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.01.16         *

*/

-- ����
-- SELECT * FROM gpSelect_Education('2')