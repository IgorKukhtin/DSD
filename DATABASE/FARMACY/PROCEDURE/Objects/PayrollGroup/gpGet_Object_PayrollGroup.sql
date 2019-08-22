-- Function: gpGet_Object_PayrollGroup()

DROP FUNCTION IF EXISTS gpGet_Object_PayrollGroup(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PayrollGroup(
    IN inId          Integer,       -- ���� ������� <>
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
           , lfGet_ObjectCode(0, zc_Object_PayrollGroup()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY
       SELECT
             Object_PayrollGroup.Id                       AS Id
           , Object_PayrollGroup.ObjectCode               AS Code
           , Object_PayrollGroup.ValueData                AS Name
           , Object_PayrollGroup.isErased                 AS isErased

       FROM Object AS Object_PayrollGroup
       WHERE Object_PayrollGroup.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.08.19                                                        *

*/

-- ����
-- SELECT * FROM gpGet_Object_PayrollGroup (1, '3')