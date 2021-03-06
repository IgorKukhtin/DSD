-- Function: gpSelect_Object_MedicKashtan(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MedicKashtan(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MedicKashtan(
    IN inSession            TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_MedicSP());

   RETURN QUERY 
     SELECT Object_MedicSP.Id                 AS Id
          , Object_MedicSP.ObjectCode         AS Code
          , Object_MedicSP.ValueData          AS Name
          , Object_MedicSP.isErased           AS isErased
     FROM Object AS Object_MedicSP
     WHERE Object_MedicSP.DescId = zc_Object_MedicKashtan();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.03.21                                                       *

*/

-- ����
-- 
SELECT * FROM gpSelect_Object_MedicKashtan('3')