-- Function: gpSelect_Object_GoodsGroupPromo()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsGroupPromo(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsGroupPromo(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY 
     SELECT 
           Object.Id         AS Id 
         , Object.ObjectCode AS Code
         , Object.ValueData  AS Name
         , Object.isErased   AS isErased
     FROM Object
     WHERE Object.DescId = zc_Object_GoodsGroupPromo();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Object_GoodsGroupPromo(TVarChar)
  OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.07.19                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsGroupPromo('3')