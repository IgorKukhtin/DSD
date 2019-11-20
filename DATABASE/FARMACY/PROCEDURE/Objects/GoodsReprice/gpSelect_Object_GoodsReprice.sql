-- Function: gpSelect_Object_GoodsReprice()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsReprice(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsReprice(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , isEnabled Boolean
             , isErased boolean
             ) AS
$BODY$BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsReprice());

     RETURN QUERY  
       SELECT 
             Object_GoodsReprice.Id          AS Id
           , Object_GoodsReprice.ObjectCode  AS Code
           , Object_GoodsReprice.ValueData   AS Name
           , COALESCE (ObjectBoolean_Enabled.ValueData, FALSE) ::Boolean AS isEnabled
           , Object_GoodsReprice.isErased    AS isErased
           
       FROM Object AS Object_GoodsReprice
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Enabled
                                    ON ObjectBoolean_Enabled.ObjectId = Object_GoodsReprice.Id
                                   AND ObjectBoolean_Enabled.DescId = zc_ObjectBoolean_GoodsReprice_Enabled()
     WHERE Object_GoodsReprice.DescId = zc_Object_GoodsReprice()
         ;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.11.19         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsReprice('2')