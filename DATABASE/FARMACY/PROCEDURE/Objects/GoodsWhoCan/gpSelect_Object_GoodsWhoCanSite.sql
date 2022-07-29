-- Function: gpSelect_Object_GoodsWhoCanSite(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsWhoCanSite(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsWhoCanSite(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Name TVarChar, NameUkr TVarChar, Status Integer) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsWhoCan());

   RETURN QUERY 
     SELECT Object_GoodsWhoCan.Id               AS Id
          , Object_GoodsWhoCan.ValueData                AS Name
          , ObjectString_GoodsWhoCan_NameUkr.ValueData  AS NameUkr
          , CASE WHEN COALESCE(Object_GoodsWhoCan.isErased,FALSE)=TRUE THEN 0::Integer ELSE 1::Integer END AS Status
     FROM OBJECT AS Object_GoodsWhoCan

          LEFT JOIN ObjectString AS ObjectString_GoodsWhoCan_NameUkr
                                 ON ObjectString_GoodsWhoCan_NameUkr.ObjectId = Object_GoodsWhoCan.Id
                                AND ObjectString_GoodsWhoCan_NameUkr.DescId = zc_ObjectString_GoodsWhoCan_NameUkr()   

     WHERE Object_GoodsWhoCan.DescId = zc_Object_GoodsWhoCan()
     ORDER BY Object_GoodsWhoCan.ID;
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsWhoCan(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.07.22                                                       *              

*/

-- ����
-- 
SELECT * FROM gpSelect_Object_GoodsWhoCanSite(zfCalc_UserSite())