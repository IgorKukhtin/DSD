-- Function: gpSelect_Object_PartnerCode()

DROP FUNCTION IF EXISTS gpSelect_Object_PartnerCode(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartnerCode(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Juridical());

   RETURN QUERY 
       SELECT 
          Object_PartnerCode_View.Id,
          Object_PartnerCode_View.Code,
          Object_PartnerCode_View.PartnerCodeName
           
       FROM Object_PartnerCode_View;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PartnerCode(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
  22.10.14                        *

*/

-- ����
-- SELECT * FROM gpSelect_Object_PartnerCode ('2')