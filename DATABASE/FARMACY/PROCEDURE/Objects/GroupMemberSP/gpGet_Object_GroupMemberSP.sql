-- Function: gpGet_Object_GroupMemberSP (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_GroupMemberSP (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GroupMemberSP(
    IN inId          Integer,        -- 
    IN inSession     TVarChar        -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_GroupMemberSP());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_GroupMemberSP()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_GroupMemberSP.Id          AS Id
            , Object_GroupMemberSP.ObjectCode  AS Code
            , Object_GroupMemberSP.ValueData   AS Name
            , Object_GroupMemberSP.isErased    AS isErased
       FROM Object AS Object_GroupMemberSP
       WHERE Object_GroupMemberSP.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.02.17         *
*/

-- ����
-- SELECT * FROM gpGet_Object_GroupMemberSP(0,'2')