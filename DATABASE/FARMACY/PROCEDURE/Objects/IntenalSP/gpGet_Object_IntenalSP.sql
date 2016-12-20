-- Function: gpGet_Object_IntenalSP (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_IntenalSP (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_IntenalSP(
    IN inId          Integer,        -- ���������
    IN inSession     TVarChar        -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_IntenalSP());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_IntenalSP()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_IntenalSP.Id          AS Id
            , Object_IntenalSP.ObjectCode  AS Code
            , Object_IntenalSP.ValueData   AS Name
            , Object_IntenalSP.isErased    AS isErased
       FROM Object AS Object_IntenalSP
       WHERE Object_IntenalSP.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.12.16         *
*/

-- ����
-- SELECT * FROM gpGet_Object_IntenalSP(0,'2')