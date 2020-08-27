-- Function: gpGet_Object_Layout()

DROP FUNCTION IF EXISTS gpGet_Object_Layout(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Layout(
    IN inId          Integer,       -- ���� ������� <�������>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Layout()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_Layout.Id                     AS Id
            , Object_Layout.ObjectCode             AS Code
            , Object_Layout.ValueData              AS Name
            , Object_Layout.isErased               AS isErased
       FROM Object AS Object_Layout
       WHERE Object_Layout.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.08.20         *
*/

-- ����
-- SELECT * FROM gpGet_Object_Layout (0, '2')