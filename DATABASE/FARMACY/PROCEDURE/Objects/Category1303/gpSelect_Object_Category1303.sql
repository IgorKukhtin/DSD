-- Function: gpSelect_Object_Category1303(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Category1303(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Category1303(
    IN inSession            TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_MemberSP());

   RETURN QUERY 
     SELECT Object_Category1303.Id                 AS Id
          , Object_Category1303.ObjectCode         AS Code
          , Object_Category1303.ValueData          AS Name
          , Object_Category1303.isErased           AS isErased
     FROM OBJECT AS Object_Category1303
     WHERE Object_Category1303.DescId = zc_Object_Category1303()
       AND Object_Category1303.isErased = False;
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.10.21                                                       *

*/

-- ����
-- 
SELECT * FROM gpSelect_Object_Category1303('3')