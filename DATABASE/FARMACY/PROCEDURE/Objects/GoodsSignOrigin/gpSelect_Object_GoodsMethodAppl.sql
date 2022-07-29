-- Function: gpSelect_Object_GoodsSignOrigin(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsSignOrigin(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsSignOrigin(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, NameUkr TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsSignOrigin());

   RETURN QUERY 
     SELECT Object_GoodsSignOrigin.Id                       AS Id
          , Object_GoodsSignOrigin.ObjectCode               AS Code
          , Object_GoodsSignOrigin.ValueData                AS Name
          , ObjectString_GoodsSignOrigin_NameUkr.ValueData  AS NameUkr
          , Object_GoodsSignOrigin.isErased                 AS isErased
     FROM OBJECT AS Object_GoodsSignOrigin

          LEFT JOIN ObjectString AS ObjectString_GoodsSignOrigin_NameUkr
                                 ON ObjectString_GoodsSignOrigin_NameUkr.ObjectId = Object_GoodsSignOrigin.Id
                                AND ObjectString_GoodsSignOrigin_NameUkr.DescId = zc_ObjectString_GoodsSignOrigin_NameUkr()   

     WHERE Object_GoodsSignOrigin.DescId = zc_Object_GoodsSignOrigin();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsSignOrigin(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.07.22                                                       *              

*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsSignOrigin('2')