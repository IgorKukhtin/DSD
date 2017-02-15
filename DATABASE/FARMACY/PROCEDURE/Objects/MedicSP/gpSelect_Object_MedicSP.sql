-- Function: gpSelect_Object_MedicSP(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MedicSP(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MedicSP(
    IN inSession     TVarChar       -- ������ ������������
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
     FROM OBJECT AS Object_MedicSP
     WHERE Object_MedicSP.DescId = zc_Object_MedicSP();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_MedicSP(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.02.17         *              

*/

-- ����
-- SELECT * FROM gpSelect_Object_MedicSP('2')