-- Function: gpGet_Object_KindOutSP (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_KindOutSP (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_KindOutSP(
    IN inId          Integer,        -- ���������
    IN inSession     TVarChar        -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_KindOutSP());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_KindOutSP()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_KindOutSP.Id          AS Id
            , Object_KindOutSP.ObjectCode  AS Code
            , Object_KindOutSP.ValueData   AS Name
            , Object_KindOutSP.isErased    AS isErased
       FROM Object AS Object_KindOutSP
       WHERE Object_KindOutSP.Id = inId;
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
-- SELECT * FROM gpGet_Object_KindOutSP(0,'2')