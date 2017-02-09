-- Function: gpGet_Object_ProfitLossGroup (Integer, TVarChar)

-- DROP FUNCTION gpGet_Object_ProfitLossGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProfitLossGroup(
    IN inId             Integer,       -- ���� ������� <������ ������ ������ � �������� � �������>
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Object_ProfitLossGroup());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (Object_ProfitLossGroup.ObjectCode), 0) + 1  AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
       FROM Object AS Object_ProfitLossGroup
       WHERE Object.DescId = zc_Object_ProfitLossGroup();
   ELSE
       RETURN QUERY 
       SELECT
             Object_ProfitLossGroup.Id         AS Id
           , Object_ProfitLossGroup.ObjectCode AS Code
           , Object_ProfitLossGroup.ValueData  AS Name
           , Object_ProfitLossGroup.isErased   AS isErased
       FROM Object AS Object_ProfitLossGroup
       WHERE Object_ProfitLossGroup.Id = inId;
   END IF;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_ProfitLossGroup (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.06.13          * zc_Enum_Process_Get_Object_ProfitLossGroup()
 18.06.13          *

*/

-- ����
-- SELECT * FROM gpGet_Object_ProfitLossGroup (2, '')
