-- Function: gpSelect_Object_WorkTimeKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_WorkTimeKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_WorkTimeKind(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ShortName TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_WorkTimeKind());

   RETURN QUERY 
   SELECT
        Object_WorkTimeKind.Id           AS Id 
      , Object_WorkTimeKind.ObjectCode   AS Code
      , Object_WorkTimeKind.ValueData    AS NAME
      
      , ObjectString_ShortName.ValueData AS ShortName 
      
      , Object_WorkTimeKind.isErased     AS isErased
      
   FROM OBJECT AS Object_WorkTimeKind
   
        LEFT JOIN ObjectString AS ObjectString_ShortName
                               ON ObjectString_ShortName.ObjectId = Object_WorkTimeKind.Id
                              AND ObjectString_ShortName.DescId = zc_objectString_WorkTimeKind_ShortName()
                              
   WHERE Object_WorkTimeKind.DescId = zc_Object_WorkTimeKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_WorkTimeKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.10.13         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_WorkTimeKind('2')
