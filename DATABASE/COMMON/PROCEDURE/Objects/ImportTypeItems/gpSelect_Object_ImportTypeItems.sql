-- Function: gpSelect_Object_ImportTypeItems()

DROP FUNCTION IF EXISTS gpSelect_Object_ImportTypeItems(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ImportTypeItems(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               ImportTypeId Integer, ParamType TVarChar, ParamNumber Integer, 
               isErased boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ImportTypeItems());

   RETURN QUERY 
       SELECT 
             Object_ImportTypeItems_View.Id
           , Object_ImportTypeItems_View.Code
           , Object_ImportTypeItems_View.Name
           , Object_ImportTypeItems_View.ImportTypeId
           , Object_ImportTypeItems_View.ParamType
           , Object_ImportTypeItems_View.isErased
           
       FROM Object_ImportTypeItems_View;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ImportTypeItems(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.07.14         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_ImportTypeItems ('2')