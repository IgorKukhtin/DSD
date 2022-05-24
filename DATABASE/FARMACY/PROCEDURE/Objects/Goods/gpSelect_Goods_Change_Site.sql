-- Function: gpSelect_Goods_Change_Site()

DROP FUNCTION IF EXISTS gpSelect_Goods_Change_Site(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Goods_Change_Site(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , article Integer
             , NameUkr TVarChar
             , Id_Site Integer
             , published Integer
             , isHideOnTheSite boolean
             , deleted Integer
              ) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY
      SELECT Object_Goods_Retail.Id
           , Object_Goods_Main.ObjectCode            AS article
           , Object_Goods_Main.NameUkr
           , Object_Goods_Main.SiteKey               AS Id_Site
           , CASE WHEN COALESCE(Object_Goods_Main.isPublished, FALSE) = TRUE THEN 1::Integer ELSE 0::Integer END AS published
           , COALESCE(Object_Goods_Main.isHideOnTheSite, FALSE)                                  AS isHideOnTheSite
           , CASE WHEN Object_Goods_Retail.isErased = TRUE THEN 1::Integer ELSE 0::Integer END   AS deleted
      FROM Object_Goods_Main

           LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = Object_Goods_Main.Id
                                        AND Object_Goods_Retail.RetailId = 4 


      WHERE Object_Goods_Main.DateUpdateSite >= CURRENT_TIMESTAMP - INTERVAL '4 HOUR'
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 24.05.22                                                      *
*/

-- ����

SELECT * FROM gpSelect_Goods_Change_Site(zfCalc_UserSite())