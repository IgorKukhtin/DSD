-- Function: gpSelect_Object_Retail()

DROP FUNCTION IF EXISTS gpSelect_Object_Retail(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Retail(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , GLNCode TVarChar 
             , isErased boolean) AS
$BODY$BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Retail()());

   RETURN QUERY 
   SELECT 
     Object.Id         AS Id 
   , Object.ObjectCode AS Code
   , Object.ValueData  AS NAME
   , GLNCode.ValueData AS GLNCode
   , Object.isErased   AS isErased
   FROM Object
        LEFT JOIN ObjectString AS GLNCode
                               ON GLNCode.ObjectId = Object.Id 
                              AND GLNCode.DescId = zc_ObjectString_Retail_GLNCode()
   WHERE Object.DescId = zc_Object_Retail();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Retail(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.11.14         * add GLNCode
 23.05.14         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_Retail('2')