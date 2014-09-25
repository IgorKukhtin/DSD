-- Function: gpSelect_Object_ImportTypeItems()

DROP FUNCTION IF EXISTS gpSelect_Object_ImportTypeItems(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ImportTypeItems(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, ParamNumber Integer, Name TVarChar,
               ImportTypeId Integer, ParamType TVarChar, UserParamName TVarChar, isErased boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ImportTypeItems());

   RETURN QUERY 
       SELECT 
             Object_ImportTypeItems_View.Id
           , Object_ImportTypeItems_View.ParamNumber
           , Object_ImportTypeItems_View.Name
           , Object_ImportTypeItems_View.ImportTypeId
           , Object_ImportTypeItems_View.ParamType
           , Object_ImportTypeItems_View.UserParamName
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
 25.09.14                         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_ImportTypeItems ('2')