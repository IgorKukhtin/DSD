-- Function: gpSelect_Object_ReceiptGoods_Print ()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptGoods_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptGoods_Print(
    IN inReceiptGoodsId               Integer   ,   --    
    IN inSession                      TVarChar      -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbPriceWithVAT_pl    Boolean;
    DECLARE vbTaxKindValue_basis TFloat;

BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- ������� � ������� ������
     vbPriceWithVAT_pl:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());
     -- !!!������� % ���!!!
     vbTaxKindValue_basis:= (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = zc_Enum_TaxKind_Basis() AND OFl.DescId = zc_ObjectFloat_TaxKind_Value());


     -- ���������
     OPEN Cursor1 FOR
          WITH -- ������������ �������� Boat Structure
          tmpItems AS (SELECT Object_ReceiptGoodsChild.Id                     AS ReceiptGoodsChildId

                       FROM Object AS Object_ReceiptGoodsChild  
                            INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                  ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                                 AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                                 AND ObjectLink_ReceiptGoods.ChildObjectId = inReceiptGoodsId
                            INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                  ON ObjectLink_ProdColorPattern.ObjectId      = Object_ReceiptGoodsChild.Id
                                                 AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                                               --  AND ObjectLink_ProdColorPattern.ChildObjectId > 0
                            INNER JOIN ObjectLink AS ObjectLink_ObjectMain
                                                  ON ObjectLink_ObjectMain.ObjectId = ObjectLink_ReceiptGoods.ChildObjectId
                                                 AND ObjectLink_ObjectMain.DescId   = zc_ObjectLink_ReceiptGoods_Object() 
                            -- 	�������������
                            INNER JOIN ObjectLink AS ObjectLink_GoodsChild
                                                  ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                                 AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild() 
                                                 
                                                 
                       WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
                         AND Object_ReceiptGoodsChild.isErased = FALSE  
                       LIMIT 1  
                      )

     SELECT
           Object_ReceiptGoods.Id         AS Id
         , Object_ReceiptGoods.ObjectCode AS Code
         , Object_ReceiptGoods.ValueData  AS Name

         , ObjectString_Code.ValueData        ::TVarChar  AS UserCode
         , ObjectString_Comment.ValueData     ::TVarChar  AS Comment

         , Object_Goods.Id         ::Integer  AS GoodsId
         , Object_Goods.ObjectCode ::Integer  AS GoodsCode
         , Object_Goods.ValueData  ::TVarChar AS GoodsName
         
         , (COALESCE(ObjectString_Article.ValueData, '')||
            CASE WHEN COALESCE(ObjectString_Article.ValueData, '') <> '' AND COALESCE(Object_Goods.ValueData, '') <> '' THEN ' - ' ELSE '' END||
            COALESCE(Object_Goods.ValueData, '')):: TVarChar AS Title

         , Object_ColorPattern.Id             ::Integer  AS ColorPatternId
         , Object_ColorPattern.ValueData      ::TVarChar AS ColorPatternName

            --
         , ObjectString_GoodsGroupFull.ValueData ::TVarChar  AS GoodsGroupNameFull
         , Object_GoodsGroup.ValueData           ::TVarChar  AS GoodsGroupName
         , Object_ProdColor.ValueData            :: TVarChar AS ProdColorName

         , ObjectString_GoodsGroupFull.ValueData ::TVarChar AS ModelName
         , Object_ProdColor.ValueData            ::TVarChar AS BrandName
         , ''    ::TVarChar AS EngineName


         , '' ::TVarChar AS ModelGroupName
         , 0  ::TFloat   AS EnginePower
         , 0  ::TFloat   AS EngineVolume

         , tmpInfo.Footer1        ::TVarChar AS Footer1
         , tmpInfo.Footer2        ::TVarChar AS Footer2
         , tmpInfo.Footer3        ::TVarChar AS Footer3
         , tmpInfo.Footer4        ::TVarChar AS Footer4
         
         , COALESCE (tmpItems.ReceiptGoodsChildId, 0) <> 0  AS isGoodsChild
         
     FROM Object AS Object_ReceiptGoods
          LEFT JOIN ObjectString AS ObjectString_Code
                                 ON ObjectString_Code.ObjectId = Object_ReceiptGoods.Id
                                AND ObjectString_Code.DescId = zc_ObjectString_ReceiptGoods_Code()
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ReceiptGoods.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptGoods_Comment()

          LEFT JOIN ObjectLink AS ObjectLink_Goods
                               ON ObjectLink_Goods.ObjectId = Object_ReceiptGoods.Id
                              AND ObjectLink_Goods.DescId = zc_ObjectLink_ReceiptGoods_Object()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Article
                                 ON ObjectString_Article.ObjectId = Object_Goods.Id
                                AND ObjectString_Article.DescId = zc_ObjectString_Article()

          LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                 ON ObjectString_GoodsGroupFull.ObjectId = Object_Goods.Id
                                AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                               ON ObjectLink_ColorPattern.ObjectId = Object_ReceiptGoods.Id
                              AND ObjectLink_ColorPattern.DescId = zc_ObjectLink_ReceiptGoods_ColorPattern()
          LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = ObjectLink_ColorPattern.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                               ON ObjectLink_Goods_ProdColor.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
          LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

          LEFT JOIN Object_Product_PrintInfo_View AS tmpInfo ON 1=1

          LEFT JOIN tmpItems AS tmpItems ON 1=1

     WHERE Object_ReceiptGoods.DescId = zc_Object_ReceiptGoods()
       AND Object_ReceiptGoods.Id = inReceiptGoodsId

          ;

     RETURN NEXT Cursor1;

     -- ���������
     OPEN Cursor2 FOR
     
          WITH -- ���������� �������� Boat Structure
          tmpObject AS (SELECT ObjectLink_ReceiptGoods_ColorPattern.ObjectId   AS ReceiptGoodsId
                             , OL_ProdColorPattern_ColorPattern.ObjectId       AS ProdColorPatternId
                        FROM ObjectLink AS ObjectLink_ReceiptGoods_ColorPattern
                             -- �������� �������� Boat Structure
                             INNER JOIN ObjectLink AS OL_ProdColorPattern_ColorPattern
                                                   ON OL_ProdColorPattern_ColorPattern.ChildObjectId = ObjectLink_ReceiptGoods_ColorPattern.ChildObjectId
                                                  AND OL_ProdColorPattern_ColorPattern.DescId        = zc_ObjectLink_ProdColorPattern_ColorPattern() 
                             
                        WHERE ObjectLink_ReceiptGoods_ColorPattern.DescId = zc_ObjectLink_ReceiptGoods_ColorPattern()
                          AND ObjectLink_ReceiptGoods_ColorPattern.ObjectId = inReceiptGoodsId  
                          and 1 =0
                       )
          -- ������������ �������� Boat Structure
        , tmpItems AS (SELECT Object_ReceiptGoodsChild.Id                     AS ReceiptGoodsChildId
                            , ObjectLink_ReceiptGoods.ChildObjectId           AS ReceiptGoodsId
                              -- ����� ������
                            , ObjectLink_ObjectMain.ChildObjectId             AS GoodsMainId
                              -- ���� ������ �� ������ �����, �� ��� ��� � Boat Structure
                            , ObjectLink_Object.ChildObjectId                 AS ObjectId
                              -- ����� ������� Boat Structure
                            , ObjectLink_ProdColorPattern.ChildObjectId       AS ProdColorPatternId
                              -- ����� ���� ������
                            , ObjectLink_ReceiptLevel.ChildObjectId           AS ReceiptLevelId
                              -- ����� �������������
                            , ObjectLink_GoodsChild.ChildObjectId             AS GoodsChildId
                              -- ��������
                            , ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END AS Value
                              --
                            , Object_ReceiptGoodsChild.ValueData              AS Comment
                            , Object_ReceiptGoodsChild.isErased               AS isErased

                       FROM Object AS Object_ReceiptGoodsChild  
                            INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                 ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                                AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                                AND ObjectLink_ReceiptGoods.ChildObjectId = inReceiptGoodsId
                            LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                  ON ObjectLink_ProdColorPattern.ObjectId      = Object_ReceiptGoodsChild.Id
                                                 AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                                               --  AND ObjectLink_ProdColorPattern.ChildObjectId > 0
                            LEFT JOIN ObjectLink AS ObjectLink_ObjectMain
                                                 ON ObjectLink_ObjectMain.ObjectId = ObjectLink_ReceiptGoods.ChildObjectId
                                                AND ObjectLink_ObjectMain.DescId   = zc_ObjectLink_ReceiptGoods_Object() 

                            LEFT JOIN ObjectLink AS ObjectLink_Object
                                                 ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object() 
                            -- �������� � ������
                            LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                  ON ObjectFloat_Value.ObjectId = Object_ReceiptGoodsChild.Id
                                                 AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptGoodsChild_Value()
                            LEFT JOIN ObjectFloat AS ObjectFloat_ForCount
                                                  ON ObjectFloat_ForCount.ObjectId = Object_ReceiptGoodsChild.Id
                                                 AND ObjectFloat_ForCount.DescId = zc_ObjectFloat_ReceiptGoodsChild_ForCount()
                                                    
                            -- ���� ������
                            LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                                 ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptGoodsChild.Id
                                                AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptLevel() 
                            -- 	�������������
                            LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                                                 ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                                AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild() 
                                                 
                                                 
                       WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
                         AND Object_ReceiptGoodsChild.isErased = FALSE  
                         
                      )
          -- ���������� ��� �������� Boat Structure
        , tmpProdColorPattern AS
                      (SELECT tmpItems.ReceiptGoodsChildId                                         AS ReceiptGoodsChildId
                            , tmpItems.GoodsMainId                                                 AS GoodsMainId
                            , tmpItems.ObjectId                                                    AS ObjectId
                            , COALESCE (tmpItems.ReceiptGoodsId, tmpObject.ReceiptGoodsId)         AS ReceiptGoodsId

                            , COALESCE (tmpItems.ProdColorPatternId, tmpObject.ProdColorPatternId) AS ProdColorPatternId
                              -- ����� ���� ������
                            , tmpItems.ReceiptLevelId
                              -- ����� �������������
                            , tmpItems.GoodsChildId

                            , tmpItems.Value                                                       AS Value
                            , tmpItems.Comment                                                     AS Comment
                            , COALESCE (tmpItems.isErased, FALSE)                                  AS isErased
                            , CASE WHEN tmpItems.ProdColorPatternId > 0 THEN TRUE ELSE FALSE END   AS isEnabled

                       FROM tmpItems
                            FULL JOIN tmpObject ON tmpObject.ReceiptGoodsId     = tmpItems.ReceiptGoodsId
                                               AND tmpObject.ProdColorPatternId = tmpItems.ProdColorPatternId
                      )
     -- ���������
    , tmpResult AS (SELECT 
                          (ROW_NUMBER() OVER (PARTITION BY tmpProdColorPattern.ReceiptGoodsId ORDER BY Object_ProdColorPattern.ObjectCode ASC) 
                            + CASE WHEN Object_ProdColorPattern.Id IS NULL THEN 1000 ELSE 0 END)  :: Integer AS NPP
                 
                          , tmpProdColorPattern.Value  :: NUMERIC (16, 8) AS Value
                          --, CASE WHEN Object_Goods.DescId <> zc_Object_ReceiptService() THEN tmpProdColorPattern.Value ELSE 0 END ::TFloat   AS Value
                          --, CASE WHEN Object_Goods.DescId =  zc_Object_ReceiptService() THEN tmpProdColorPattern.Value ELSE 0 END ::TFloat   AS Value_service
                 
                           , Object_Goods.Id                    ::Integer  AS ObjectId
                           , Object_Goods.ObjectCode            ::Integer  AS ObjectCode
                           , CASE WHEN COALESCE (Object_Goods.ValueData,'') <> '' THEN Object_Goods.ValueData ELSE Object_ProdColorGroup.ValueData END ::TVarChar AS ObjectName
                        -- ,  Object_Goods.ValueData  ::TVarChar AS ObjectName
                 
                          , ObjectString_EAN.ValueData                AS EAN
                 
                          , ObjectString_GoodsGroupFull.ValueData ::TVarChar  AS GoodsGroupNameFull
                          , Object_GoodsGroup.ValueData           ::TVarChar  AS GoodsGroupName
                          , ObjectString_Article.ValueData        ::TVarChar  AS Article
                          --, Object_ProdColor.ValueData            :: TVarChar AS ProdColorName
                          , CASE WHEN ObjectLink_Goods.ChildObjectId IS NULL THEN ObjectString_Comment.ValueData ELSE Object_ProdColor.ValueData END :: TVarChar AS ProdColorName
                          , Object_Measure.ValueData              ::TVarChar  AS MeasureName
                          , Object_ProdColorGroup.ValueData       AS  ProdColorGroupName
                           -- ���� ������
                          , Object_ReceiptLevel.ValueData         ::TVarChar  AS ReceiptLevelName
                           -- �������������
                          , Object_GoodsChild.Id                              AS GoodsChildId
                          , Object_GoodsChild.ValueData           ::TVarChar  AS GoodsChildName
                          , ObjectString_ArticleChild.ValueData   ::TVarChar  AS ArticleChild 
                          , tmpProdColorPattern.ProdColorPatternId 
                          , Object_ProdColorPattern.ValueData     ::TVarChar  AS ProdColorPattern
                          
                          , Object_GoodsMain.ValueData           ::TVarChar  AS GoodsMainName
                 
                          , COALESCE(Object_GoodsChild.ValueData,
                                     Object_GoodsMain.ValueData)    ::TVarChar  AS GoodsNameShow
                 
                          , COALESCE(ObjectString_ArticleChild.ValueData,
                                     ObjectString_ArticleChildMain.ValueData)    ::TVarChar  AS ArticleShow
                 
                          , COALESCE(Object_GoodsChildGroup.ValueData,
                                     Object_GoodsMainGroup.ValueData)    ::TVarChar  AS GoodsGroupNameShow
                          
                          , CASE WHEN COALESCE (Object_ProdColorPattern.Id, 0) <> 0 THEN '��' ELSE '' END :: TVarChar  AS Replacement
                          , COALESCE (tmpProdColorPattern.ReceiptLevelId, 1000000000)  :: Integer AS GroupBy
                 
                          , CASE WHEN COALESCE(tmpProdColorPattern.GoodsChildId, 0) = 0
                                 THEN COALESCE(ObjectString_ArticleChildMain.ValueData, '')||
                                      CASE WHEN COALESCE(ObjectString_ArticleChildMain.ValueData, '') <> '' AND COALESCE(Object_GoodsMain.ValueData, '') <> '' THEN ' - ' ELSE '' END||
                                      COALESCE(Object_GoodsMain.ValueData, '')
                                 ELSE COALESCE(ObjectString_ArticleChild.ValueData, '')||
                                      CASE WHEN COALESCE(ObjectString_ArticleChild.ValueData, '') <> '' AND COALESCE(Object_GoodsChildGroup.ValueData, '') <> '' THEN ' - ' ELSE '' END||
                                      COALESCE(Object_GoodsChildGroup.ValueData, '')
                                 END:: TVarChar AS TitleGroup

                            -- ���� ��. ��� ��� - �����/������
                          , COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0) :: TFloat AS EKPrice
                            -- ����� ��. ��� ���, �� 2-� ������ - �����/������
                          , zfCalc_SummIn (tmpProdColorPattern.Value
                                         , COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData)
                                         , 1) AS EKPrice_summ
                      FROM tmpProdColorPattern
                           LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = tmpProdColorPattern.ProdColorPatternId
                 
                           LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = tmpProdColorPattern.ReceiptLevelId
                           LEFT JOIN Object AS Object_GoodsChild ON Object_GoodsChild.Id = tmpProdColorPattern.GoodsChildId
                           LEFT JOIN Object AS Object_GoodsMain ON Object_GoodsMain.Id = tmpProdColorPattern.GoodsMainId
                 
                           LEFT JOIN ObjectString AS ObjectString_ArticleChildMain
                                                  ON ObjectString_ArticleChildMain.ObjectId = tmpProdColorPattern.GoodsMainId
                                                 AND ObjectString_ArticleChildMain.DescId = zc_ObjectString_Article()
                 
                           LEFT JOIN ObjectString AS ObjectString_ArticleChild
                                                  ON ObjectString_ArticleChild.ObjectId = tmpProdColorPattern.GoodsChildId
                                                 AND ObjectString_ArticleChild.DescId = zc_ObjectString_Article()
                 
                           LEFT JOIN ObjectString AS ObjectString_Comment
                                                  ON ObjectString_Comment.ObjectId = Object_ProdColorPattern.Id
                                                 AND ObjectString_Comment.DescId = zc_ObjectString_ProdColorPattern_Comment()
                 
                           LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                                ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                               AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                           LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId
                           LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                                                ON ObjectLink_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                                               AND ObjectLink_ColorPattern.DescId = zc_ObjectLink_ProdColorPattern_ColorPattern()
                           LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = ObjectLink_ColorPattern.ChildObjectId
                 
                           LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                ON ObjectLink_Goods.ObjectId = Object_ProdColorPattern.Id
                                               AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdColorPattern_Goods()
                           -- !!!������!!!
                           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (tmpProdColorPattern.ObjectId, ObjectLink_Goods.ChildObjectId)   
                 
                           --
                           LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                                  ON ObjectString_GoodsGroupFull.ObjectId = Object_Goods.Id
                                                 AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                 
                           LEFT JOIN ObjectString AS ObjectString_Article
                                                  ON ObjectString_Article.ObjectId = Object_Goods.Id
                                                 AND ObjectString_Article.DescId = zc_ObjectString_Article()
                 
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
                 
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                ON ObjectLink_Goods_ProdColor.ObjectId = Object_Goods.Id
                                               AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
                           LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId
                 
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                           LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                 
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsMainGroup
                                                ON ObjectLink_Goods_GoodsMainGroup.ObjectId = tmpProdColorPattern.GoodsMainId
                                               AND ObjectLink_Goods_GoodsMainGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                           LEFT JOIN Object AS Object_GoodsMainGroup ON Object_GoodsMainGroup.Id = ObjectLink_Goods_GoodsMainGroup.ChildObjectId
                 
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsChildGroup
                                                ON ObjectLink_Goods_GoodsChildGroup.ObjectId = tmpProdColorPattern.GoodsChildId
                                               AND ObjectLink_Goods_GoodsChildGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                           LEFT JOIN Object AS Object_GoodsChildGroup ON Object_GoodsChildGroup.Id = ObjectLink_Goods_GoodsChildGroup.ChildObjectId
                 
                           LEFT JOIN ObjectString AS ObjectString_EAN
                                                  ON ObjectString_EAN.ObjectId = Object_Goods.Id
                                                 AND ObjectString_EAN.DescId = zc_ObjectString_EAN()

                           -- ���� ��. ��� ��� - �����
                           LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                 ON ObjectFloat_EKPrice.ObjectId = Object_Goods.Id
                                                AND ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
                           -- ���� ��. ��� ��� - ������
                           LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_EKPrice
                                                 ON ObjectFloat_ReceiptService_EKPrice.ObjectId = Object_Goods.Id
                                                AND ObjectFloat_ReceiptService_EKPrice.DescId   = zc_ObjectFloat_ReceiptService_EKPrice()

                     /* ORDER BY CASE WHEN COALESCE(Object_ReceiptLevel.ValueData, '') = '' THEN 1 ELSE 0 END
                             , Object_ReceiptLevel.ValueData
                             , Object_ProdColorPattern.ObjectCode ASC */   
              UNION 
              
                SELECT DISTINCT
                         1  :: Integer AS NPP
                 
                          , 1 :: NUMERIC (16, 8) AS Value
                          , Object_Goods.Id                    ::Integer  AS ObjectId 
                          , Object_Goods.ObjectCode            ::Integer  AS ObjectCode 
                           , Object_Goods.ValueData  ::TVarChar AS ObjectName
                                       
                          , ObjectString_EAN.ValueData                AS EAN
                 
                          , ObjectString_GoodsGroupFull.ValueData ::TVarChar  AS GoodsGroupNameFull
                          , Object_GoodsGroup.ValueData           ::TVarChar  AS GoodsGroupName
                          , ObjectString_Article.ValueData        ::TVarChar  AS Article
                          --, Object_ProdColor.ValueData            :: TVarChar AS ProdColorName
                          , Object_ProdColor.ValueData  :: TVarChar AS ProdColorName
                          , Object_Measure.ValueData              ::TVarChar  AS MeasureName
                          , ''     AS  ProdColorGroupName
                           -- ���� ������
                          , ''         ::TVarChar  AS ReceiptLevelName
                           -- �������������
                          , 0                  AS GoodsChildId
                          , ''           ::TVarChar  AS GoodsChildName
                          , ''   ::TVarChar  AS ArticleChild 
                          , 0 AS ProdColorPatternId 
                          , ''     ::TVarChar  AS ProdColorPattern
                          
                          , ''           ::TVarChar  AS GoodsMainName
                 
                          , COALESCE(Object_Goods.ValueData,'')    ::TVarChar  AS GoodsNameShow
                 
                          , COALESCE(ObjectString_Article.ValueData,'')    ::TVarChar  AS ArticleShow
                 
                          , COALESCE(Object_GoodsGroup.ValueData,'')    ::TVarChar  AS GoodsGroupNameShow
                          
                          , '' ::TVarChar  AS Replacement
                          ,  1000000000  :: Integer AS GroupBy
                 
                          , COALESCE(ObjectString_ArticleChildMain.ValueData, '')||
                                      CASE WHEN COALESCE(ObjectString_ArticleChildMain.ValueData, '') <> '' AND COALESCE(Object_GoodsMain.ValueData, '') <> '' THEN ' - ' ELSE '' END||
                                      COALESCE(Object_GoodsMain.ValueData, '')
                              /*   ELSE COALESCE(ObjectString_ArticleChild.ValueData, '')||
                                      CASE WHEN COALESCE(ObjectString_ArticleChild.ValueData, '') <> '' AND COALESCE(Object_GoodsChildGroup.ValueData, '') <> '' THEN ' - ' ELSE '' END||
                                      COALESCE(Object_GoodsChildGroup.ValueData, '')*/
                                 :: TVarChar AS TitleGroup

                            -- ���� ��. ��� ��� - �����/������
                          , COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0) :: TFloat AS EKPrice
                            -- ����� ��. ��� ���, �� 2-� ������ - �����/������
                          , zfCalc_SummIn (1
                                         , COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData)
                                         , 1) AS EKPrice_summ
                      FROM (SELECT  tmpProdColorPattern.* FROM tmpProdColorPattern WHERE tmpProdColorPattern.GoodsChildId > 0) AS tmpProdColorPattern
                                                      
                           LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = tmpProdColorPattern.ProdColorPatternId
                 
                           LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = tmpProdColorPattern.ReceiptLevelId
                           LEFT JOIN Object AS Object_GoodsChild ON Object_GoodsChild.Id = tmpProdColorPattern.GoodsChildId
                           LEFT JOIN Object AS Object_GoodsMain ON Object_GoodsMain.Id = tmpProdColorPattern.GoodsMainId
                 
                           LEFT JOIN ObjectString AS ObjectString_ArticleChildMain
                                                  ON ObjectString_ArticleChildMain.ObjectId = tmpProdColorPattern.GoodsMainId
                                                 AND ObjectString_ArticleChildMain.DescId = zc_ObjectString_Article()
                 
                           LEFT JOIN ObjectString AS ObjectString_ArticleChild
                                                  ON ObjectString_ArticleChild.ObjectId = tmpProdColorPattern.GoodsChildId
                                                 AND ObjectString_ArticleChild.DescId = zc_ObjectString_Article()
                 
                           LEFT JOIN ObjectString AS ObjectString_Comment
                                                  ON ObjectString_Comment.ObjectId = Object_ProdColorPattern.Id
                                                 AND ObjectString_Comment.DescId = zc_ObjectString_ProdColorPattern_Comment()
                 
                           LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                                ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                               AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                           LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId
                           LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                                                ON ObjectLink_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                                               AND ObjectLink_ColorPattern.DescId = zc_ObjectLink_ProdColorPattern_ColorPattern()
                           LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = ObjectLink_ColorPattern.ChildObjectId
                 
                           LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                ON ObjectLink_Goods.ObjectId = Object_ProdColorPattern.Id
                                               AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdColorPattern_Goods()
                           -- !!!������!!!
                           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpProdColorPattern.GoodsChildId  
                 
                           --
                           LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                                  ON ObjectString_GoodsGroupFull.ObjectId = Object_Goods.Id
                                                 AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                 
                           LEFT JOIN ObjectString AS ObjectString_Article
                                                  ON ObjectString_Article.ObjectId = Object_Goods.Id
                                                 AND ObjectString_Article.DescId = zc_ObjectString_Article()
                 
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
                 
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                ON ObjectLink_Goods_ProdColor.ObjectId = Object_Goods.Id
                                               AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
                           LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId
                 
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                           LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                 
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsMainGroup
                                                ON ObjectLink_Goods_GoodsMainGroup.ObjectId = tmpProdColorPattern.GoodsMainId
                                               AND ObjectLink_Goods_GoodsMainGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                           LEFT JOIN Object AS Object_GoodsMainGroup ON Object_GoodsMainGroup.Id = ObjectLink_Goods_GoodsMainGroup.ChildObjectId
                 
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsChildGroup
                                                ON ObjectLink_Goods_GoodsChildGroup.ObjectId = tmpProdColorPattern.GoodsChildId
                                               AND ObjectLink_Goods_GoodsChildGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                           LEFT JOIN Object AS Object_GoodsChildGroup ON Object_GoodsChildGroup.Id = ObjectLink_Goods_GoodsChildGroup.ChildObjectId
                 
                           LEFT JOIN ObjectString AS ObjectString_EAN
                                                  ON ObjectString_EAN.ObjectId = Object_Goods.Id
                                                 AND ObjectString_EAN.DescId = zc_ObjectString_EAN()

                           -- ���� ��. ��� ��� - �����
                           LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                 ON ObjectFloat_EKPrice.ObjectId = Object_Goods.Id
                                                AND ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
                           -- ���� ��. ��� ��� - ������
                           LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_EKPrice
                                                 ON ObjectFloat_ReceiptService_EKPrice.ObjectId = Object_Goods.Id
                                                AND ObjectFloat_ReceiptService_EKPrice.DescId   = zc_ObjectFloat_ReceiptService_EKPrice() 
                ) 

     ---
     SELECT tmpResult.NPP
          , tmpResult.Value  :: NUMERIC (16, 8) AS Value  
          , tmpResult.ObjectCode
          , tmpResult.ObjectName
          , tmpResult.EAN
          , tmpResult.GoodsGroupNameFull
          , tmpResult.GoodsGroupName
          , tmpResult.Article
          , tmpResult.ProdColorName
          , tmpResult.MeasureName
          , tmpResult.ProdColorGroupName
          , tmpResult.ReceiptLevelName
          , tmpResult.GoodsChildName
          , tmpResult.ArticleChild 
          , tmpResult.ProdColorPatternId 
          , tmpResult.ProdColorPattern
          , tmpResult.GoodsMainName
          , tmpResult.GoodsNameShow
          , tmpResult.ArticleShow
          , tmpResult.GoodsGroupNameShow
          , tmpResult.Replacement
          , tmpResult.GroupBy
          , tmpResult.TitleGroup
          , (SELECT COUNT(*) FROM tmpResult AS tmp WHERE tmp.TitleGroup = tmpResult.TitleGroup) ::Integer AS Count_Object
          , ROW_NUMBER() OVER (PARTITION BY tmpResult.TitleGroup
                               ORDER BY tmpResult.ReceiptLevelName
                                     , CASE WHEN tmpResult.ProdColorPatternId > 0
                                            THEN 0
                                            ELSE 1
                                       END
                                     , CASE WHEN tmpResult.Article ILIKE '%��'
                                            THEN 0
                                            ELSE 1
                                       END
                                     , tmpResult.ObjectName
                             ) :: Integer AS NPP_3
          , COALESCE (tmp.EKPrice, tmpResult.EKPrice)                            ::TFloat  AS EKPrice
          , COALESCE ((tmp.EKPrice * tmpResult.Value), tmpResult.EKPrice_summ)   ::NUMERIC (16, 2)  AS EKPrice_summ
     FROM tmpResult
         LEFT JOIN (SELECT tmpResult.GoodsChildId, SUM (COALESCE (tmpResult.EKPrice_summ,0)) AS EKPrice
                    FROM tmpResult WHERE COALESCE (tmpResult.GoodsChildId,0) <> 0
                    GROUP BY tmpResult.GoodsChildId
                    ) AS tmp ON tmp.GoodsChildId = tmpResult.ObjectId    
     ;        

     /*
     SELECT (ROW_NUMBER() OVER (ORDER BY Object_ReceiptGoodsChild.Id ASC)
           + CASE WHEN ObjectLink_ProdColorPattern.ChildObjectId IS NULL THEN 1000 ELSE 0 END)  :: Integer aASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END ELSE 0 END ::TFloat   AS Value
         , CASE WHEN Object_Goods.DescId = zc_Object_ReceiptService() THEN ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END ELSE 0 END ::TFloat   AS Value_service

         --, Object_ReceiptGoods.Id        ::Integer  AS ReceiptGoodsId
         --, Object_ReceiptGoods.ValueData ::TVarChar AS ReceiptGoodsName
         
         , Object_Object.ObjectCode       ::Integer  AS ObjectCode
         , CASE WHEN COALESCE (Object_Object.ValueData,'') <> '' THEN Object_Object.ValueData ELSE Object_ProdColorGroup.ValueData END ::TVarChar AS ObjectName
         --, ObjectDesc.ItemName            ::TVarChar AS DescName
         , ObjectString_EAN.ValueData                AS EAN

         , ObjectString_GoodsGroupFull.ValueData ::TVarChar  AS GoodsGroupNameFull
         , Object_GoodsGroup.ValueData           ::TVarChar  AS GoodsGroupName
         , ObjectString_Article.ValueData        ::TVarChar  AS Article
         --, Object_ProdColor.ValueData            :: TVarChar AS ProdColorName
         , CASE WHEN ObjectLink_Goods.ChildObjectId IS NULL THEN ObjectString_Comment.ValueData ELSE Object_ProdColor.ValueData END :: TVarChar AS ProdColorName
         , Object_Measure.ValueData              ::TVarChar  AS MeasureName
         , Object_ProdColorGroup.ValueData       AS  ProdColorGroupName     
         
           -- ���� ��. ��� ��� - �����/������
         , COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0) :: TFloat AS EKPrice
           -- ����� ��. ��� ���, �� 2-� ������ - �����/������
         , zfCalc_SummIn (ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END
                        , COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData)
                        , 1) AS EKPrice_summ

     FROM Object AS Object_ReceiptGoodsChild

          INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                               AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                               AND ObjectLink_ReceiptGoods.ChildObjectId = inReceiptGoodsId

          LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                               ON ObjectLink_ProdColorPattern.ObjectId = Object_ReceiptGoodsChild.Id
                              AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()

          LEFT JOIN ObjectLink AS ObjectLink_Goods
                               ON ObjectLink_Goods.ObjectId = ObjectLink_ProdColorPattern.ObjectId
                              AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdColorPattern_Goods()
                              
          LEFT JOIN ObjectLink AS ObjectLink_Object
                               ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                              AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptGoodsChild_Object()
          LEFT JOIN Object AS Object_Object ON Object_Object.Id = COALESCE (ObjectLink_Goods.ChildObjectId , ObjectLink_Object.ChildObjectId, ObjectLink_ProdColorPattern.ChildObjectId)
                         -- AND Object_Object.DescId = zc_Object_Goods()
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId

          -- �������� � ������
          LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                ON ObjectFloat_Value.ObjectId = Object_ReceiptGoodsChild.Id
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptGoodsChild_Value() 
          LEFT JOIN ObjectFloat AS ObjectFloat_ForCount
                                ON ObjectFloat_ForCount.ObjectId = Object_ReceiptGoodsChild.Id
                               AND ObjectFloat_ForCount.DescId = zc_ObjectFloat_ReceiptGoodsChild_ForCount()
                               
          --
          LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                 ON ObjectString_GoodsGroupFull.ObjectId = Object_Object.Id
                                AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectString AS ObjectString_Article
                                 ON ObjectString_Article.ObjectId = Object_Object.Id
                                AND ObjectString_Article.DescId = zc_ObjectString_Article()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Object.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                               ON ObjectLink_Goods_ProdColor.ObjectId = Object_Object.Id
                              AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
          LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Object.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_EAN
                                 ON ObjectString_EAN.ObjectId = Object_Object.Id
                                AND ObjectString_EAN.DescId = zc_ObjectString_EAN()

          LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                               ON ObjectLink_ProdColorGroup.ObjectId = ObjectLink_ProdColorPattern.ObjectId
                              AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
          LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = ObjectLink_ProdColorPattern.ObjectId
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdColorPattern_Comment()

          -- ���� ��. ��� ��� - �����
          LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                ON ObjectFloat_EKPrice.ObjectId = Object_Object.Id
                               AND ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
          -- ���� ��. ��� ��� - ������
          LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_EKPrice
                                ON ObjectFloat_ReceiptService_EKPrice.ObjectId = Object_Object.Id
                               AND ObjectFloat_ReceiptService_EKPrice.DescId   = zc_ObjectFloat_ReceiptService_EKPrice()
                               
     WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
       AND Object_ReceiptGoodsChild.isErased = FALSE
       AND ObjectLink_ReceiptGoods.ChildObjectId = inReceiptGoodsId
      -- ��� ���� ���������
      --AND ObjectLink_ProdColorPattern.ChildObjectId IS NULL
       */
  
                               
     
     RETURN NEXT Cursor2;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.05.22          *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ReceiptGoods_Print (inReceiptGoodsId:= 122175, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_ReceiptGoods_Print(inReceiptGoodsId := 252646 ,  inSession := '5');
