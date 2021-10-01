-- Function: gpGet_Object_FormDispensing (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_FormDispensing (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_FormDispensing(
    IN inId          Integer,        -- ���������
    IN inSession     TVarChar        -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_FormDispensing());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_FormDispensing()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , False                  AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_FormDispensing.Id          AS Id
            , Object_FormDispensing.ObjectCode  AS Code
            , Object_FormDispensing.ValueData   AS Name
            , Object_FormDispensing.isErased    AS isErased
       FROM Object AS Object_FormDispensing
       WHERE Object_FormDispensing.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.09.21                                                       *              
*/

-- ����
-- SELECT * FROM gpGet_Object_FormDispensing(0,'2')