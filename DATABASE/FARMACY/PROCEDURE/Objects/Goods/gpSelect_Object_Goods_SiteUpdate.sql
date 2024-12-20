-- Function: gpSelect_Object_Goods_SiteUpdate()

DROP FUNCTION IF EXISTS gpSelect_Object_Goods_SiteUpdate(Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_SiteUpdate(
    IN inisShowAll           Boolean,       -- 
    IN inisDiffNameUkr       Boolean,       -- 
    IN inisDiffMakerName     Boolean,       -- 
    IN inisDiffMakerNameUkr  Boolean,       -- 
    IN inSession             TVarChar       -- 
)
RETURNS TABLE (Id Integer, RetailId Integer, Code Integer, Name TVarChar
             , isPublishedSite Boolean
             , NameUkr TVarChar , NameUkrSite TVarChar, isNameUkrSite Boolean
             , MakerName TVarChar , MakerNameSite TVarChar, isMakerNameSite Boolean
             , MakerNameUkr TVarChar , MakerNameUkrSite TVarChar, isMakerNameUkrSite Boolean
             , DateDownloadsSite TDateTime
             , Color_NameUkr Integer, Color_MakerName Integer, Color_MakerNameUkr Integer
             , isErased Boolean
              ) AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbObjectId Integer;
  DECLARE vbAreaDneprId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);



     -- ���������
     RETURN QUERY
      SELECT Object_Goods_Main.Id
           , Object_Goods_Retail.Id
           , Object_Goods_Main.ObjectCode
           , Object_Goods_Main.Name
           , Object_Goods_Main.isPublishedSite
           , Object_Goods_Main.NameUkr
           , Object_Goods_Main.NameUkrSite
           , Object_Goods_Main.isNameUkrSite
           , Object_Goods_Main.MakerName
           , Object_Goods_Main.MakerNameSite
           , Object_Goods_Main.isMakerNameSite
           , Object_Goods_Main.MakerNameUkr
           , Object_Goods_Main.MakerNameUkrSite
           , Object_Goods_Main.isMakerNameUkrSite
           , Object_Goods_Main.DateDownloadsSite
           , CASE WHEN COALESCE(Object_Goods_Main.NameUkr, '') <> COALESCE(Object_Goods_Main.NameUkrSite, '')
                  THEN zc_Color_Yelow() 
                  ELSE zc_Color_White() END         AS Color_NameUkr
           , CASE WHEN COALESCE(Object_Goods_Main.MakerName, '') <> COALESCE(Object_Goods_Main.MakerNameSite, '')
                  THEN zc_Color_Yelow() 
                  ELSE zc_Color_White() END         AS Color_MakerName
           , CASE WHEN COALESCE(Object_Goods_Main.MakerNameUkr, '') <> COALESCE(Object_Goods_Main.MakerNameUkrSite, '')
                  THEN zc_Color_Yelow() 
                  ELSE zc_Color_White() END         AS Color_MakerNameUkr
           , Object_Goods_Main.isErased
      FROM  Object_Goods_Main 
      
            LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = Object_Goods_Main.Id
                                         AND Object_Goods_Retail.RetailId = 4
            
      WHERE COALESCE(Object_Goods_Main.isPublishedSite, False) = TRUE
        AND (COALESCE(Object_Goods_Main.NameUkr, '') <> COALESCE(Object_Goods_Main.NameUkrSite, '') AND inisDiffNameUkr = True OR
             COALESCE(Object_Goods_Main.MakerName, '') <> COALESCE(Object_Goods_Main.MakerNameSite, '') AND inisDiffMakerName = True OR
             COALESCE(Object_Goods_Main.MakerNameUkr, '') <> COALESCE(Object_Goods_Main.MakerNameUkrSite, '') AND inisDiffMakerNameUkr = True OR
             inisShowAll = True
            )
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Goods_SiteUpdate(TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 27.07.22                                                      *
*/

-- ����
--

select * from gpSelect_Object_Goods_SiteUpdate(FALSE, TRUE, TRUE, TRUE, '3');      :36)