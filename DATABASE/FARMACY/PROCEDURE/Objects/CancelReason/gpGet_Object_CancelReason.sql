-- Function: gpGet_Object_CancelReason()

DROP FUNCTION IF EXISTS gpGet_Object_CancelReason(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_CancelReason(
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
             CAST (0 as Integer)     AS Id
           , lfGet_ObjectCode(0, zc_Object_CancelReason()) AS Code
           , CAST ('' as TVarChar)   AS Name
           , CAST (FALSE AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_CancelReason.Id                                              AS Id
            , Object_CancelReason.ObjectCode                                      AS Code
            , Object_CancelReason.ValueData                                       AS Name
            , Object_CancelReason.isErased                                        AS isErased
       FROM Object AS Object_CancelReason
       WHERE Object_CancelReason.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_CancelReason(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.09.20                                                       *

*/

-- ����
-- SELECT * FROM gpGet_Object_CancelReason (1, '3')