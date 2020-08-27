-- Function: gpSelect_Object_Layout()

DROP FUNCTION IF EXISTS gpSelect_Object_Layout(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Layout(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Layout()());

   RETURN QUERY 
   SELECT Object_Layout.Id                     AS Id 
        , Object_Layout.ObjectCode             AS Code
        , Object_Layout.ValueData              AS Name
        , Object_Layout.isErased               AS isErased
   FROM Object AS Object_Layout
   WHERE Object_Layout.DescId = zc_Object_Layout();
  
END;
$BODY$


LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.08.20         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_Layout('2')