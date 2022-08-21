-- Function: gpSelect_Object_GoodsWhoCan_Active(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsWhoCan_Active(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsWhoCan_Active(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, NameUkr TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsWhoCan());

   RETURN QUERY 
     SELECT Object_GoodsWhoCan.Id                       AS Id
          , Object_GoodsWhoCan.ObjectCode               AS Code
          , Object_GoodsWhoCan.ValueData                AS Name
          , ObjectString_GoodsWhoCan_NameUkr.ValueData  AS NameUkr
          , Object_GoodsWhoCan.isErased                 AS isErased
     FROM OBJECT AS Object_GoodsWhoCan

          LEFT JOIN ObjectString AS ObjectString_GoodsWhoCan_NameUkr
                                 ON ObjectString_GoodsWhoCan_NameUkr.ObjectId = Object_GoodsWhoCan.Id
                                AND ObjectString_GoodsWhoCan_NameUkr.DescId = zc_ObjectString_GoodsWhoCan_NameUkr()   

     WHERE Object_GoodsWhoCan.DescId = zc_Object_GoodsWhoCan()
       AND Object_GoodsWhoCan.isErased = False
     ORDER BY Object_GoodsWhoCan.ObjectCode;
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsWhoCan_Active(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.08.22                                                       *              

*/

-- ����
-- 
SELECT * FROM gpSelect_Object_GoodsWhoCan_Active('3')