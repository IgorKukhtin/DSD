-- Function: gpGet_Object_MedicForSale()

DROP FUNCTION IF EXISTS gpGet_Object_MedicForSale(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MedicForSale(
    IN inId          Integer,       -- ���� ������� <�������>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)     AS Id
           , lfGet_ObjectCode(0, zc_Object_MedicForSale()) AS Code
           , CAST ('' as TVarChar)   AS Name
           , CAST (FALSE AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_MedicForSale.Id                        AS Id
            , Object_MedicForSale.ObjectCode                AS Code
            , Object_MedicForSale.ValueData                 AS Name
            , Object_MedicForSale.isErased                  AS isErased
       FROM Object AS Object_MedicForSale
       WHERE Object_MedicForSale.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_MedicForSale(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.06.22                                                       *

*/

-- ����
-- SELECT * FROM gpGet_Object_MedicForSale (0, '3')