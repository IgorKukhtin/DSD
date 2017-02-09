-- Function: gpSelect_Object_Currency()

DROP FUNCTION IF EXISTS gpSelect_Object_Currency (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Currency(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, InternalName TVarChar) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT 
     Object_Currency_View.Id
   , Object_Currency_View.Code
   , Object_Currency_View.Name
   , Object_Currency_View.isErased
   , Object_Currency_View.InternalName
   FROM Object_Currency_View;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Currency (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.12.13                                        *Cyr1251
 18.12.13                         *
 11.06.13          *
 03.06.13          
*/

-- ����
-- SELECT * FROM gpSelect_Object_Currency('2')