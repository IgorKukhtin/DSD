-- Function: gpGet_Object_UKTZED()

DROP FUNCTION IF EXISTS gpGet_Object_UKTZED(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_UKTZED(
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
           , lfGet_ObjectCode(0, zc_Object_UKTZED()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_UKTZED.Id                     AS Id
            , Object_UKTZED.ObjectCode             AS Code
            , Object_UKTZED.ValueData              AS Name
            , Object_UKTZED.isErased               AS isErased
       FROM Object AS Object_UKTZED
       WHERE Object_UKTZED.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.10.23                                                       *
*/

-- ����
-- SELECT * FROM gpGet_Object_UKTZED (0, '2')