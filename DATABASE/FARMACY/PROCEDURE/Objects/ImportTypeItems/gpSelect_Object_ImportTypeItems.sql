-- Function: gpSelect_Object_ImportTypeItems()

DROP FUNCTION IF EXISTS gpSelect_Object_ImportTypeItems(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ImportTypeItems(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               ImportTypeId Integer, ImportTypeName TVarChar,
               isErased boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ImportTypeItems());

   RETURN QUERY 
       SELECT 
             Object_ImportTypeItems.Id           AS Id
           , Object_ImportTypeItems.ObjectCode   AS Code
           , Object_ImportTypeItems.ValueData    AS Name
         
           , Object_ImportType.Id         AS ImportTypeId
           , Object_ImportType.ValueData  AS ImportTypeName 
     
           , Object_ImportTypeItems.isErased           AS isErased
           
       FROM Object AS Object_ImportTypeItems
           LEFT JOIN ObjectLink AS ObjectLink_ImportTypeItems_ImportType
                                ON ObjectLink_ImportTypeItems_ImportType.ObjectId = Object_ImportTypeItems.Id
                               AND ObjectLink_ImportTypeItems_ImportType.DescId = zc_ObjectLink_ImportTypeItems_ImportType()
           LEFT JOIN Object AS Object_ImportType ON Object_ImportType.Id = ObjectLink_ImportTypeItems_ImportType.ChildObjectId

       WHERE Object_ImportTypeItems.DescId = zc_Object_ImportTypeItems();
  
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