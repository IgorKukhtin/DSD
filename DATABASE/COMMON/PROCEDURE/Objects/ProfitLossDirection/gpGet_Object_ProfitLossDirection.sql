-- Function: gpGet_Object_ProfitLossDirection (Integer, TVarChar)

-- DROP FUNCTION gpGet_Object_ProfitLossDirection (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProfitLossDirection(
    IN inId             Integer,       -- ���� ������� <��������� ������ ������ � �������� � ������� - �����������>
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Object_ProfitLossDirection());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (Object_ProfitLossDirection.ObjectCode), 0) + 1  AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
       FROM Object AS Object_ProfitLossDirection
       WHERE Object_ProfitLossDirection.DescId = zc_Object_ProfitLossDirection();
   ELSE
       RETURN QUERY 
       SELECT
             Object_ProfitLossDirection.Id         AS Id
           , Object_ProfitLossDirection.ObjectCode AS Code
           , Object_ProfitLossDirection.ValueData  AS Name
           , Object_ProfitLossDirection.isErased   AS isErased
       FROM Object AS Object_ProfitLossDirection
       WHERE Object_ProfitLossDirection.Id = inId;
   END IF;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_ProfitLossDirection (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.06.13          *   zc_Enum_Process_Get_Object_ProfitLossDirection()           
 18.06.13          *

*/

-- ����
-- SELECT * FROM gpGet_Object_ProfitLossDirection (2, '')
