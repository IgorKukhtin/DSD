-- Function: gpSelect_Object_GoodsByGoodsKind_VMC(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsByGoodsKind_VMC (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_GoodsByGoodsKind_VMC (Integer,Integer,Integer,Integer,Integer,Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsByGoodsKind_VMC(
    IN inRetail1Id       Integer,
    IN inRetail2Id       Integer,
    IN inRetail3Id       Integer,
    IN inRetail4Id       Integer,
    IN inRetail5Id       Integer,
    IN inRetail6Id       Integer,
    IN inSession       TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, GoodsId Integer, Code Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsGroupAnalystName TVarChar
             , TradeMarkName TVarChar
             , GoodsTagName TVarChar
             , GoodsPlatformName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , Weight TFloat
             , WeightPackage TFloat, WeightPackageSticker TFloat
             , WeightTotal TFloat, ChangePercentAmount TFloat
             , WeightMin TFloat, WeightMax TFloat, WeightAvg TFloat
             , Height TFloat, Length TFloat, Width TFloat
             , NormInDays TFloat
             , isOrder Boolean, isScaleCeh Boolean, isNotMobile Boolean
             , GoodsSubId Integer, GoodsSubCode Integer, GoodsSubName TVarChar, MeasureSubName TVarChar
             , GoodsKindSubId Integer, GoodsKindSubName TVarChar
             , GoodsPackId Integer, GoodsPackCode Integer, GoodsPackName TVarChar, MeasurePackName TVarChar
             , GoodsKindPackId Integer, GoodsKindPackName TVarChar
             , ReceiptId Integer, ReceiptCode TVarChar, ReceiptName TVarChar
             , GoodsCode_basis Integer, GoodsName_basis TVarChar
             , GoodsCode_main Integer, GoodsName_main TVarChar
             , GoodsBrandName TVarChar
             , isCheck_basis Boolean, isCheck_main Boolean
             , isGoodsTypeKind_Sh Boolean
             , isGoodsTypeKind_Nom Boolean
             , isGoodsTypeKind_Ves Boolean
             , CodeCalc_Sh TVarChar      -- ��� ��� ��.
             , CodeCalc_Nom TVarChar     -- ��� ��� �������
             , CodeCalc_Ves TVarChar     -- ��� ��� ���������
             , isCodeCalc_Diff Boolean   -- ������ ���� ���

             , WmsCellNum        Integer     -- � ������ �� ������ ���
             , WmsCode           Integer     -- ����� ��� ���*
             , WmsCodeCalc_Sh    TVarChar    -- ����� ��� ���* ��.
             , WmsCodeCalc_Nom   TVarChar    -- ����� ��� ���* �������
             , WmsCodeCalc_Ves   TVarChar    -- ����� ��� ���* ���������
             --
             , GoodsPropertyBoxId Integer
             , BoxId Integer, BoxCode Integer, BoxName TVarChar -- ���� (E2/E3)
             , WeightOnBox TFloat                               -- ���-�� ��. � ��. (E2/E3)
             , CountOnBox TFloat                                -- ���-�� ��. � ��. (E2/E3)
             , BoxVolume TFloat
             , BoxWeight TFloat
             , BoxHeight TFloat
             , BoxLength TFloat
             , BoxWidth TFloat
             , WeightGross TFloat                               -- ��� ������ ������� ����� "�� ???" (E2/E3)
             , WeightAvgGross TFloat                            -- ��� ������ ������� ����� "�� �������� ����" (E2/E3)
             , WeightAvgNet TFloat                              -- ��� ����� ������� ����� "�� �������� ����" (E2/E3)
             , BoxId_2 Integer, BoxCode_2 Integer, BoxName_2 TVarChar
             , WeightOnBox_2 TFloat, CountOnBox_2 TFloat
             , BoxVolume_2 TFloat, BoxWeight_2 TFloat
             , BoxHeight_2 TFloat, BoxLength_2 TFloat, BoxWidth_2 TFloat
             , WeightGross_2 TFloat                             -- ��� ������ ������� ����� "�� ???" (�����)
             , WeightAvgGross_2 TFloat                          -- ��� ������ ������� ����� "�� �������� ����" (�����)
             , WeightAvgNet_2 TFloat                            -- ��� ����� ������� ����� "�� �������� ����" (�����)

             , BoxId_Retail1 Integer, BoxName_Retail1 TVarChar  -- ���� ��� ���� 1
             , BoxId_Retail2 Integer, BoxName_Retail2 TVarChar  -- ���� ��� ���� 2
             , BoxId_Retail3 Integer, BoxName_Retail3 TVarChar  -- ���� ��� ���� 3
             , BoxId_Retail4 Integer, BoxName_Retail4 TVarChar  -- ���� ��� ���� 4
             , BoxId_Retail5 Integer, BoxName_Retail5 TVarChar  -- ���� ��� ���� 5
             , BoxId_Retail6 Integer, BoxName_Retail6 TVarChar  -- ���� ��� ���� 6
             , WeightOnBox_Retail1 TFloat                       -- ���������� ��. � ��. ��� ���� 1
             , WeightOnBox_Retail2 TFloat                       -- ���������� ��. � ��. ��� ���� 2
             , WeightOnBox_Retail3 TFloat                       -- ���������� ��. � ��. ��� ���� 3
             , WeightOnBox_Retail4 TFloat                       -- ���������� ��. � ��. ��� ���� 4
             , WeightOnBox_Retail5 TFloat                       -- ���������� ��. � ��. ��� ���� 5
             , WeightOnBox_Retail6 TFloat                       -- ���������� ��. � ��. ��� ���� 6
             , CountOnBox_Retail1 TFloat                        -- ���������� ��. � ��. ��� ���� 1
             , CountOnBox_Retail2 TFloat                        -- ���������� ��. � ��. ��� ���� 2
             , CountOnBox_Retail3 TFloat                        -- ���������� ��. � ��. ��� ���� 3
             , CountOnBox_Retail4 TFloat                        -- ���������� ��. � ��. ��� ���� 4
             , CountOnBox_Retail5 TFloat                        -- ���������� ��. � ��. ��� ���� 5
             , CountOnBox_Retail6 TFloat                        -- ���������� ��. � ��. ��� ���� 6
              )
AS
$BODY$
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Account());

     RETURN QUERY
     WITH
     tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.*
                                  , Object_Goods_basis.ObjectCode     AS GoodsCode_basis
                                  , Object_Goods_basis.ValueData      AS GoodsName_basis
                                  , Object_Goods_main.ObjectCode      AS GoodsCode_main
                                  , Object_Goods_main.ValueData       AS GoodsName_main
                                  , Object_GoodsBrand.ObjectCode      AS GoodsBrandCode
                                  , Object_GoodsBrand.ValueData       AS GoodsBrandName

                                  , CASE WHEN Object_Goods_basis.Id > 0 AND Object_Goods_basis.Id <> COALESCE (Object_Goods_main.Id,                 0) THEN TRUE ELSE FALSE END :: Boolean AS isCheck_basis
                                  , CASE WHEN Object_Goods_main.Id  > 0 AND Object_Goods_main. Id <> COALESCE (Object_GoodsByGoodsKind_View.GoodsId, 0) THEN TRUE ELSE FALSE END :: Boolean AS isCheck_main

                                  , CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.ChildObjectId, 0)  <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind_Sh
                                  , CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.ChildObjectId, 0) <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind_Nom
                                  , CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves.ChildObjectId, 0) <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind_Ves

                                  , CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.ChildObjectId, 0)  <> 0
                                         THEN (''||COALESCE (Object_Goods_main.ObjectCode,0)||'.'||COALESCE (Object_GoodsByGoodsKind_View.GoodsKindCode,0)||'.'||COALESCE (Object_GoodsBrand.ObjectCode,0)||'.'||CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.ChildObjectId, 0)  <> 0 THEN 1 ELSE 0 END)
                                         ELSE NULL
                                    END  :: TVarChar AS CodeCalc_Sh
                                  , CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.ChildObjectId, 0) <> 0
                                         THEN (''||COALESCE (Object_Goods_main.ObjectCode,0)||'.'||COALESCE (Object_GoodsByGoodsKind_View.GoodsKindCode,0)||'.'||COALESCE (Object_GoodsBrand.ObjectCode,0)||'.'||CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.ChildObjectId, 0) <> 0 THEN 2 ELSE 0 END)
                                         ELSE NULL
                                    END  :: TVarChar AS CodeCalc_Nom
                                  , CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves.ChildObjectId, 0) <> 0
                                         THEN (''||COALESCE (Object_Goods_main.ObjectCode,0)||'.'||COALESCE (Object_GoodsByGoodsKind_View.GoodsKindCode,0)||'.'||COALESCE (Object_GoodsBrand.ObjectCode,0)||'.'||CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves.ChildObjectId, 0) <> 0 THEN 3 ELSE 0 END)
                                         ELSE NULL
                                    END  :: TVarChar AS CodeCalc_Ves
                                  --
                                  , ObjectFloat_WmsCellNum.ValueData  AS WmsCellNum
                                  , ObjectFloat_WmsCode.ValueData     AS WmsCode

                                  , CASE WHEN ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.ChildObjectId <> 0
                                         THEN REPEAT ('', 3 - LENGTH ((ObjectFloat_WmsCode.ValueData :: Integer) :: TVarChar))
                                           || (COALESCE (ObjectFloat_WmsCode.ValueData, 0) :: Integer) :: TVarChar
                                        -- || '.'
                                           || '1'
                                         ELSE ''
                                    END :: TVarChar AS WmsCodeCalc_Sh

                                  , CASE WHEN ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.ChildObjectId <> 0
                                         THEN REPEAT ('', 3 - LENGTH ((ObjectFloat_WmsCode.ValueData :: Integer) :: TVarChar))
                                            || (COALESCE (ObjectFloat_WmsCode.ValueData, 0) :: Integer) :: TVarChar
                                        --  || '.'
                                            || '2'
                                         ELSE ''
                                    END :: TVarChar AS WmsCodeCalc_Nom

                                  , CASE WHEN ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves.ChildObjectId  <> 0
                                         THEN REPEAT ('', 3 - LENGTH ((ObjectFloat_WmsCode.ValueData :: Integer) :: TVarChar))
                                            || (COALESCE (ObjectFloat_WmsCode.ValueData, 0) :: Integer) :: TVarChar
                                         -- || '.'
                                            || '3'
                                         ELSE ''
                                    END :: TVarChar AS WmsCodeCalc_Ves

                             FROM Object_GoodsByGoodsKind_View
                                  LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsBasis
                                                       ON ObjectLink_GoodsByGoodsKind_GoodsBasis.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                      AND ObjectLink_GoodsByGoodsKind_GoodsBasis.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsBasis()
                                  LEFT JOIN Object AS Object_Goods_basis ON Object_Goods_basis.Id = ObjectLink_GoodsByGoodsKind_GoodsBasis.ChildObjectId
                                  LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsMain
                                                       ON ObjectLink_GoodsByGoodsKind_GoodsMain.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                      AND ObjectLink_GoodsByGoodsKind_GoodsMain.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsMain()
                                  LEFT JOIN Object AS Object_Goods_main ON Object_Goods_main.Id = ObjectLink_GoodsByGoodsKind_GoodsMain.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsBrand
                                                       ON ObjectLink_GoodsByGoodsKind_GoodsBrand.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                      AND ObjectLink_GoodsByGoodsKind_GoodsBrand.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsBrand()
                                  LEFT JOIN Object AS Object_GoodsBrand ON Object_GoodsBrand.Id = ObjectLink_GoodsByGoodsKind_GoodsBrand.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh
                                                       ON ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                      AND ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh()
                                  LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom
                                                       ON ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                      AND ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom()
                                  LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves
                                                       ON ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                      AND ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves()

                                  LEFT JOIN ObjectFloat AS ObjectFloat_WmsCode
                                                        ON ObjectFloat_WmsCode.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                       AND ObjectFloat_WmsCode.DescId = zc_ObjectFloat_GoodsByGoodsKind_WmsCode()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_WmsCellNum
                                                        ON ObjectFloat_WmsCellNum.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                       AND ObjectFloat_WmsCellNum.DescId = zc_ObjectFloat_GoodsByGoodsKind_WmsCellNum()
                          -- WHERE Object_GoodsByGoodsKind_View.isErased = FALSE 
                            )
   , tmpCodeCalc AS (SELECT tmp.CodeCalc_Sh, tmp.CodeCalc_Nom, tmp.CodeCalc_Ves
                          , COUNT (*) OVER (PARTITION BY tmp.CodeCalc_Sh) AS Count1
                          , COUNT (*) OVER (PARTITION BY tmp.CodeCalc_Nom) AS Count2
                          , COUNT (*) OVER (PARTITION BY tmp.CodeCalc_Ves) AS Count3
                     FROM tmpGoodsByGoodsKind AS tmp
                     WHERE tmp.isGoodsTypeKind_Sh  <> False
                        OR tmp.isGoodsTypeKind_Nom <> False
                        OR tmp.isGoodsTypeKind_Ves <> False
                     GROUP BY tmp.CodeCalc_Sh, tmp.CodeCalc_Nom, tmp.CodeCalc_Ves
                     )

   , tmpGoodsPropertyBox AS (SELECT ObjectLink_GoodsPropertyBox_Goods.ChildObjectId     AS GoodsId
                                  , ObjectLink_GoodsPropertyBox_GoodsKind.ChildObjectId AS GoodsKindId

                                  , Object_GoodsPropertyBox.Id           AS GoodsPropertyBoxId
                                  , Object_Box.Id                        AS BoxId
                                  , Object_Box.ObjectCode                AS BoxCode
                                  , Object_Box.ValueData                 AS BoxName

                                  , ObjectFloat_WeightOnBox.ValueData    AS WeightOnBox
                                  , ObjectFloat_CountOnBox.ValueData     AS CountOnBox

                                  , ObjectFloat_Volume.ValueData         AS BoxVolume
                                  , ObjectFloat_Weight.ValueData         AS BoxWeight
                                  , ObjectFloat_Height.ValueData         AS BoxHeight
                                  , ObjectFloat_Length.ValueData         AS BoxLength
                                  , ObjectFloat_Width.ValueData          AS BoxWidth

                              FROM Object AS Object_GoodsPropertyBox
                                   LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_GoodsKind
                                                        ON ObjectLink_GoodsPropertyBox_GoodsKind.ObjectId = Object_GoodsPropertyBox.Id
                                                       AND ObjectLink_GoodsPropertyBox_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyBox_GoodsKind()

                                   LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_Goods
                                                        ON ObjectLink_GoodsPropertyBox_Goods.ObjectId = Object_GoodsPropertyBox.Id
                                                       AND ObjectLink_GoodsPropertyBox_Goods.DescId = zc_ObjectLink_GoodsPropertyBox_Goods()

                                   LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_Box
                                                        ON ObjectLink_GoodsPropertyBox_Box.ObjectId = Object_GoodsPropertyBox.Id
                                                       AND ObjectLink_GoodsPropertyBox_Box.DescId = zc_ObjectLink_GoodsPropertyBox_Box()
                                   LEFT JOIN Object AS Object_Box ON Object_Box.Id = ObjectLink_GoodsPropertyBox_Box.ChildObjectId

                                   LEFT JOIN ObjectFloat AS ObjectFloat_WeightOnBox
                                                         ON ObjectFloat_WeightOnBox.ObjectId = Object_GoodsPropertyBox.Id
                                                        AND ObjectFloat_WeightOnBox.DescId = zc_ObjectFloat_GoodsPropertyBox_WeightOnBox()

                                   LEFT JOIN ObjectFloat AS ObjectFloat_CountOnBox
                                                         ON ObjectFloat_CountOnBox.ObjectId = Object_GoodsPropertyBox.Id
                                                        AND ObjectFloat_CountOnBox.DescId = zc_ObjectFloat_GoodsPropertyBox_CountOnBox()

                                   LEFT JOIN ObjectFloat AS ObjectFloat_Volume
                                                         ON ObjectFloat_Volume.ObjectId = ObjectLink_GoodsPropertyBox_Box.ChildObjectId
                                                        AND ObjectFloat_Volume.DescId = zc_ObjectFloat_Box_Volume()
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                         ON ObjectFloat_Weight.ObjectId = ObjectLink_GoodsPropertyBox_Box.ChildObjectId
                                                        AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Box_Weight()
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Height
                                                         ON ObjectFloat_Height.ObjectId = ObjectLink_GoodsPropertyBox_Box.ChildObjectId
                                                        AND ObjectFloat_Height.DescId = zc_ObjectFloat_Box_Height()
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Length
                                                         ON ObjectFloat_Length.ObjectId = ObjectLink_GoodsPropertyBox_Box.ChildObjectId
                                                        AND ObjectFloat_Length.DescId = zc_ObjectFloat_Box_Length()
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Width
                                                         ON ObjectFloat_Width.ObjectId = ObjectLink_GoodsPropertyBox_Box.ChildObjectId
                                                        AND ObjectFloat_Width.DescId = zc_ObjectFloat_Box_Width()

                              WHERE Object_GoodsPropertyBox.DescId = zc_Object_GoodsPropertyBox()
                                AND Object_GoodsPropertyBox.isErased = FALSE
             )

   , tmpRetail AS (SELECT tmp.RetailId, tmp.GoodsPropertyId
                   FROM (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                              , ObjectLink_Juridical_GoodsProperty.ChildObjectId   AS GoodsPropertyId
                              , ROW_NUMBER() OVER(PARTITION BY ObjectLink_Juridical_Retail.ChildObjectId ORDER BY ObjectLink_Juridical_GoodsProperty.ChildObjectId) as Ord
                         FROM ObjectLink AS ObjectLink_Juridical_Retail
                                 INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                      ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                                     AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                         WHERE ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                           AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                           AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                         ) AS tmp
                   WHERE Ord = 1)

   , tmpGoodsPropertyValue AS (SELECT tmpRetail.RetailId                                    AS RetailId
                                    , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId     AS GoodsId
                                    , ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId AS GoodsKindId
                                    , Object_Box.Id                                         AS BoxId
                                    , Object_Box.ObjectCode                                 AS BoxCode
                                    , Object_Box.ValueData                                  AS BoxName
                                    , ObjectFloat_WeightOnBox.ValueData                     AS WeightOnBox
                                    , ObjectFloat_CountOnBox.ValueData                      AS CountOnBox
                               FROM ObjectLink AS ObjectLink_GoodsPropertyValue_Box
                                    LEFT JOIN Object AS Object_Box ON Object_Box.Id = ObjectLink_GoodsPropertyValue_Box.ChildObjectId

                                    LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                         ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_Box.ObjectId
                                                        AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()

                                    LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                         ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_Box.ObjectId
                                                        AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()

                                    LEFT JOIN ObjectFloat AS ObjectFloat_WeightOnBox
                                                          ON ObjectFloat_WeightOnBox.ObjectId = ObjectLink_GoodsPropertyValue_Box.ObjectId
                                                         AND ObjectFloat_WeightOnBox.DescId = zc_ObjectFloat_GoodsPropertyValue_WeightOnBox()
                                                         AND COALESCE (ObjectFloat_WeightOnBox.ValueData,0) <> 0
                                    LEFT JOIN ObjectFloat AS ObjectFloat_CountOnBox
                                                          ON ObjectFloat_CountOnBox.ObjectId = ObjectLink_GoodsPropertyValue_Box.ObjectId
                                                         AND ObjectFloat_CountOnBox.DescId = zc_ObjectFloat_GoodsPropertyValue_CountOnBox()
                                                         AND COALESCE (ObjectFloat_CountOnBox.ValueData,0) <> 0

                                    LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                         ON ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId = ObjectLink_GoodsPropertyValue_Box.ObjectId
                                                        AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()

                                    LEFT JOIN tmpRetail ON tmpRetail.GoodsPropertyId = ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId

                               WHERE ObjectLink_GoodsPropertyValue_Box.DescId = zc_ObjectLink_GoodsPropertyValue_Box()
                                 AND COALESCE (ObjectLink_GoodsPropertyValue_Box.ChildObjectId,0) <> 0
                               )
       -- ���������
       SELECT
             Object_GoodsByGoodsKind_View.Id
           , Object_GoodsByGoodsKind_View.GoodsId
           , Object_GoodsByGoodsKind_View.GoodsCode
           , Object_GoodsByGoodsKind_View.GoodsName
           , Object_GoodsByGoodsKind_View.GoodsKindId
           , Object_GoodsByGoodsKind_View.GoodsKindCode
           , Object_GoodsByGoodsKind_View.GoodsKindName

           , Object_GoodsGroup.Id                        AS GoodsGroupId
           , Object_GoodsGroup.ValueData                 AS GoodsGroupName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , Object_GoodsGroupAnalyst.ValueData AS GoodsGroupAnalystName
           , Object_TradeMark.ValueData      AS TradeMarkName
           , Object_GoodsTag.ValueData       AS GoodsTagName
           , Object_GoodsPlatform.ValueData  AS GoodsPlatformName

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , Object_Measure.Id               AS MeasureId
           , Object_Measure.ValueData        AS MeasureName

           , ObjectFloat_Weight.ValueData    AS Weight

           , COALESCE (ObjectFloat_WeightPackage.ValueData,0)       ::TFloat  AS WeightPackage
           , COALESCE (ObjectFloat_WeightPackageSticker.ValueData,0)::TFloat  AS WeightPackageSticker
           , COALESCE (ObjectFloat_WeightTotal.ValueData,0)         ::TFloat  AS WeightTotal
           , COALESCE (ObjectFloat_ChangePercentAmount.ValueData,0) ::TFloat  AS ChangePercentAmount

           , COALESCE (ObjectFloat_WeightMin.ValueData,0)       ::TFloat  AS WeightMin
           , COALESCE (ObjectFloat_WeightMax.ValueData,0)       ::TFloat  AS WeightMax
           , ((COALESCE (ObjectFloat_WeightMin.ValueData,0) + COALESCE (ObjectFloat_WeightMax.ValueData,0)) / 2) :: TFloat AS WeightAvg
           , COALESCE (ObjectFloat_Height.ValueData,0)          ::TFloat  AS Height
           , COALESCE (ObjectFloat_Length.ValueData,0)          ::TFloat  AS Length
           , COALESCE (ObjectFloat_Width.ValueData,0)           ::TFloat  AS Width
           , COALESCE (ObjectFloat_NormInDays.ValueData,0)      ::TFloat  AS NormInDays

           , COALESCE (ObjectBoolean_Order.ValueData, False)           AS isOrder
           , COALESCE (ObjectBoolean_ScaleCeh.ValueData, False)        AS isScaleCeh
           , COALESCE (ObjectBoolean_NotMobile.ValueData, False)       AS isNotMobile

           , Object_GoodsSub.Id               AS GoodsSubId
           , Object_GoodsSub.ObjectCode       AS GoodsSubCode
           , Object_GoodsSub.ValueData        AS GoodsSubName
           , Object_MeasureSub.ValueData      AS MeasureSubName
           , Object_GoodsKindSub.Id           AS GoodsKindSubId
           , Object_GoodsKindSub.ValueData    AS GoodsKindSubName

           , Object_GoodsPack.Id              AS GoodsPackId
           , Object_GoodsPack.ObjectCode      AS GoodsPackCode
           , Object_GoodsPack.ValueData       AS GoodsPackName
           , Object_MeasurePack.ValueData     AS MeasurePackName
           , Object_GoodsKindPack.Id          AS GoodsKindPackId
           , Object_GoodsKindPack.ValueData   AS GoodsKindPackName

           , Object_Receipt.Id                AS ReceiptId
           , ObjectString_Code.ValueData      AS ReceiptCode
           , Object_Receipt.ValueData         AS ReceiptName

           , Object_GoodsByGoodsKind_View.GoodsCode_basis
           , Object_GoodsByGoodsKind_View.GoodsName_basis
           , Object_GoodsByGoodsKind_View.GoodsCode_main
           , Object_GoodsByGoodsKind_View.GoodsName_main
           , Object_GoodsByGoodsKind_View.GoodsBrandName

           , Object_GoodsByGoodsKind_View.isCheck_basis
           , Object_GoodsByGoodsKind_View.isCheck_main

           , Object_GoodsByGoodsKind_View.isGoodsTypeKind_Sh                 -- �������
           , Object_GoodsByGoodsKind_View.isGoodsTypeKind_Nom                -- �����������
           , Object_GoodsByGoodsKind_View.isGoodsTypeKind_Ves                -- �������������

           , Object_GoodsByGoodsKind_View.CodeCalc_Sh  :: TVarChar           -- ��. - ������: ��� �� ����+���+�����+���������
           , Object_GoodsByGoodsKind_View.CodeCalc_Nom  :: TVarChar          -- ������� - ������: ��� �� ����+���+�����+���������
           , Object_GoodsByGoodsKind_View.CodeCalc_Ves  :: TVarChar          -- ��������� - ������: ��� �� ����+���+�����+���������

             -- ������ ���� ��� - ������: ��� �� ����+���+�����+���������
           , CASE WHEN Object_GoodsByGoodsKind_View.isGoodsTypeKind_Sh = FALSE AND Object_GoodsByGoodsKind_View.isGoodsTypeKind_Nom = FALSE AND Object_GoodsByGoodsKind_View.isGoodsTypeKind_Ves = FALSE THEN FALSE
                  WHEN (COALESCE (tmpCodeCalc_1.Count1, 1) + COALESCE (tmpCodeCalc_2.Count2, 1) + COALESCE (tmpCodeCalc_3.Count3, 1)) <= 3 THEN FALSE
                  ELSE TRUE
             END  AS isCodeCalc_Diff                                         -- ������ ���� ���

           , Object_GoodsByGoodsKind_View.WmsCellNum       :: Integer        -- 
           , Object_GoodsByGoodsKind_View.WmsCode          :: Integer        -- ��� ���* ��� ��������
           , Object_GoodsByGoodsKind_View.WmsCodeCalc_Sh   :: TVarChar       -- ��. - ��� ���* ��� ��������
           , Object_GoodsByGoodsKind_View.WmsCodeCalc_Nom  :: TVarChar       -- ������� - ��� ���* ��� ��������
           , Object_GoodsByGoodsKind_View.WmsCodeCalc_Ves  :: TVarChar       -- ��������� - ��� ���* ��� ��������

            -- ���� (E2/E3)
            , tmpGoodsPropertyBox.GoodsPropertyBoxId
            , tmpGoodsPropertyBox.BoxId
            , tmpGoodsPropertyBox.BoxCode
            , tmpGoodsPropertyBox.BoxName

              -- ���-�� ��. � ��. (E2/E3)
            , CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND ObjectFloat_WeightMin.ValueData > 0 AND  ObjectFloat_WeightMax.ValueData > 0
                        THEN tmpGoodsPropertyBox.CountOnBox * (ObjectFloat_WeightMin.ValueData + ObjectFloat_WeightMax.ValueData) / 2
                   ELSE tmpGoodsPropertyBox.WeightOnBox
              END :: TFloat AS WeightOnBox
              -- ���-�� ��. � ��. (E2/E3)
            , tmpGoodsPropertyBox.CountOnBox

            , tmpGoodsPropertyBox.BoxVolume
            , tmpGoodsPropertyBox.BoxWeight
            , tmpGoodsPropertyBox.BoxHeight
            , tmpGoodsPropertyBox.BoxLength
            , tmpGoodsPropertyBox.BoxWidth

              -- ��� ������ ������� ����� "�� ???" (E2/E3)
            , (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND ObjectFloat_WeightMin.ValueData > 0 AND  ObjectFloat_WeightMax.ValueData > 0
                         THEN tmpGoodsPropertyBox.CountOnBox * (ObjectFloat_WeightMin.ValueData + ObjectFloat_WeightMax.ValueData) / 2
                    ELSE tmpGoodsPropertyBox.WeightOnBox
               END
             + tmpGoodsPropertyBox.BoxWeight
              ) :: TFloat AS WeightGross

             -- ��� ������ ������� ����� "�� �������� ����" (E2/E3)
            , (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND ObjectFloat_WeightMin.ValueData > 0 AND  ObjectFloat_WeightMax.ValueData > 0
                         THEN tmpGoodsPropertyBox.CountOnBox * (ObjectFloat_WeightMin.ValueData + ObjectFloat_WeightMax.ValueData) / 2
                    ELSE 0
               END
             + tmpGoodsPropertyBox.BoxWeight
              ) :: TFloat AS WeightAvgGross

              -- ��� ����� �� �������� ���� ����� (E2/E3)
            , (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND ObjectFloat_WeightMin.ValueData > 0 AND  ObjectFloat_WeightMax.ValueData > 0
                         THEN tmpGoodsPropertyBox.CountOnBox * (ObjectFloat_WeightMin.ValueData + ObjectFloat_WeightMax.ValueData) / 2
                    ELSE 0
               END
              ) :: TFloat AS WeightAvgNet

            -- ���� (�����)
            , tmpGoodsPropertyBox_2.BoxId       AS BoxId_2
            , tmpGoodsPropertyBox_2.BoxCode     AS BoxCode_2
            , tmpGoodsPropertyBox_2.BoxName     AS BoxName_2

              -- ���-�� ��. � ��. (�����)
            , CASE WHEN tmpGoodsPropertyBox_2.CountOnBox > 0 AND ObjectFloat_WeightMin.ValueData > 0 AND  ObjectFloat_WeightMax.ValueData > 0
                        THEN tmpGoodsPropertyBox_2.CountOnBox * (ObjectFloat_WeightMin.ValueData + ObjectFloat_WeightMax.ValueData) / 2
                   ELSE tmpGoodsPropertyBox_2.WeightOnBox
              END :: TFloat AS WeightOnBox_2
              -- ���-�� ��. � ��. (�����)
            , tmpGoodsPropertyBox_2.CountOnBox  AS CountOnBox_2

            , tmpGoodsPropertyBox_2.BoxVolume   AS BoxVolume_2
            , tmpGoodsPropertyBox_2.BoxWeight   AS BoxWeight_2
            , tmpGoodsPropertyBox_2.BoxHeight   AS BoxHeight_2
            , tmpGoodsPropertyBox_2.BoxLength   AS BoxLength_2
            , tmpGoodsPropertyBox_2.BoxWidth    AS BoxWidth_2

              -- ��� ������ ������� ����� "�� ???" (�����)
            , (CASE WHEN tmpGoodsPropertyBox_2.CountOnBox > 0 AND ObjectFloat_WeightMin.ValueData > 0 AND  ObjectFloat_WeightMax.ValueData > 0
                         THEN tmpGoodsPropertyBox_2.CountOnBox * (ObjectFloat_WeightMin.ValueData + ObjectFloat_WeightMax.ValueData) / 2
                    ELSE tmpGoodsPropertyBox_2.WeightOnBox
               END
             + tmpGoodsPropertyBox_2.BoxWeight
              ) :: TFloat AS WeightGross_2

             -- ��� ������ ������� ����� "�� �������� ����" (�����)
            , (CASE WHEN tmpGoodsPropertyBox_2.CountOnBox > 0 AND ObjectFloat_WeightMin.ValueData > 0 AND  ObjectFloat_WeightMax.ValueData > 0
                         THEN tmpGoodsPropertyBox_2.CountOnBox * (ObjectFloat_WeightMin.ValueData + ObjectFloat_WeightMax.ValueData) / 2
                    ELSE 0
               END
             + tmpGoodsPropertyBox_2.BoxWeight
              ) :: TFloat AS WeightAvgGross_2

              -- ��� ����� ������� ����� "�� �������� ����" (�����)
            , (CASE WHEN tmpGoodsPropertyBox_2.CountOnBox > 0 AND ObjectFloat_WeightMin.ValueData > 0 AND  ObjectFloat_WeightMax.ValueData > 0
                         THEN tmpGoodsPropertyBox_2.CountOnBox * (ObjectFloat_WeightMin.ValueData + ObjectFloat_WeightMax.ValueData) / 2
                    ELSE 0
               END
              ) :: TFloat AS WeightAvgNet_2

              -- ����� �������� ���� 1-6
            , tmpRetail1.BoxId AS BoxId_Retail1, tmpRetail1.BoxName AS BoxName_Retail1
            , tmpRetail2.BoxId AS BoxId_Retail2, tmpRetail2.BoxName AS BoxName_Retail2
            , tmpRetail3.BoxId AS BoxId_Retail3, tmpRetail3.BoxName AS BoxName_Retail3
            , tmpRetail4.BoxId AS BoxId_Retail4, tmpRetail4.BoxName AS BoxName_Retail4
            , tmpRetail5.BoxId AS BoxId_Retail5, tmpRetail5.BoxName AS BoxName_Retail5
            , tmpRetail6.BoxId AS BoxId_Retail6, tmpRetail6.BoxName AS BoxName_Retail6
            -- ���������� ��. � ��. ��� ����� 1-6
            , tmpRetail1.WeightOnBox AS WeightOnBox_Retail1
            , tmpRetail2.WeightOnBox AS WeightOnBox_Retail2
            , tmpRetail3.WeightOnBox AS WeightOnBox_Retail3
            , tmpRetail4.WeightOnBox AS WeightOnBox_Retail4
            , tmpRetail5.WeightOnBox AS WeightOnBox_Retail5
            , tmpRetail6.WeightOnBox AS WeightOnBox_Retail6
            -- ���������� ��. � ��. ��� ����� 1-6
            , tmpRetail1.CountOnBox AS CountOnBox_Retail1
            , tmpRetail2.CountOnBox AS CountOnBox_Retail2
            , tmpRetail3.CountOnBox AS CountOnBox_Retail3
            , tmpRetail4.CountOnBox AS CountOnBox_Retail4
            , tmpRetail5.CountOnBox AS CountOnBox_Retail5
            , tmpRetail6.CountOnBox AS CountOnBox_Retail6

       FROM tmpGoodsByGoodsKind AS Object_GoodsByGoodsKind_View
            LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                  ON ObjectFloat_WeightPackage.ObjectId = Object_GoodsByGoodsKind_View.Id
                                 AND ObjectFloat_WeightPackage.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightPackage()

            LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackageSticker
                                  ON ObjectFloat_WeightPackageSticker.ObjectId = Object_GoodsByGoodsKind_View.Id
                                 AND ObjectFloat_WeightPackageSticker.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker()

            LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                  ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id
                                 AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()

            LEFT JOIN ObjectFloat AS ObjectFloat_ChangePercentAmount
                                  ON ObjectFloat_ChangePercentAmount.ObjectId = Object_GoodsByGoodsKind_View.Id
                                 AND ObjectFloat_ChangePercentAmount.DescId = zc_ObjectFloat_GoodsByGoodsKind_ChangePercentAmount()
 --
            LEFT JOIN ObjectFloat AS ObjectFloat_WeightMin
                                  ON ObjectFloat_WeightMin.ObjectId = Object_GoodsByGoodsKind_View.Id
                                 AND ObjectFloat_WeightMin.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightMin()

            LEFT JOIN ObjectFloat AS ObjectFloat_WeightMax
                                  ON ObjectFloat_WeightMax.ObjectId = Object_GoodsByGoodsKind_View.Id
                                 AND ObjectFloat_WeightMax.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightMax()

            LEFT JOIN ObjectFloat AS ObjectFloat_Height
                                  ON ObjectFloat_Height.ObjectId = Object_GoodsByGoodsKind_View.Id
                                 AND ObjectFloat_Height.DescId = zc_ObjectFloat_GoodsByGoodsKind_Height()

            LEFT JOIN ObjectFloat AS ObjectFloat_Length
                                  ON ObjectFloat_Length.ObjectId = Object_GoodsByGoodsKind_View.Id
                                 AND ObjectFloat_Length.DescId = zc_ObjectFloat_GoodsByGoodsKind_Length()

            LEFT JOIN ObjectFloat AS ObjectFloat_Width
                                  ON ObjectFloat_Width.ObjectId = Object_GoodsByGoodsKind_View.Id
                                 AND ObjectFloat_Width.DescId = zc_ObjectFloat_GoodsByGoodsKind_Width()
            LEFT JOIN ObjectFloat AS ObjectFloat_NormInDays
                                  ON ObjectFloat_NormInDays.ObjectId = Object_GoodsByGoodsKind_View.Id
                                 AND ObjectFloat_NormInDays.DescId = zc_ObjectFloat_GoodsByGoodsKind_NormInDays()
 --
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Order
                                    ON ObjectBoolean_Order.ObjectId = Object_GoodsByGoodsKind_View.Id
                                   AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_ScaleCeh
                                    ON ObjectBoolean_ScaleCeh.ObjectId = Object_GoodsByGoodsKind_View.Id
                                   AND ObjectBoolean_ScaleCeh.DescId = zc_ObjectBoolean_GoodsByGoodsKind_ScaleCeh()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_NotMobile
                                    ON ObjectBoolean_NotMobile.ObjectId = Object_GoodsByGoodsKind_View.Id
                                   AND ObjectBoolean_NotMobile.DescId = zc_ObjectBoolean_GoodsByGoodsKind_NotMobile()

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_GoodsByGoodsKind_View.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_GoodsByGoodsKind_View.GoodsId
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                 ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = Object_GoodsByGoodsKind_View.GoodsId
                                AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
            LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                 ON ObjectLink_Goods_GoodsTag.ObjectId = Object_GoodsByGoodsKind_View.GoodsId
                                AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
            LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_GoodsByGoodsKind_View.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_GoodsByGoodsKind_View.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                 ON ObjectLink_Goods_TradeMark.ObjectId = Object_GoodsByGoodsKind_View.GoodsId
                                AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                                 ON ObjectLink_Goods_GoodsPlatform.ObjectId = Object_GoodsByGoodsKind_View.GoodsId
                                AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
            LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_Goods_GoodsPlatform.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_GoodsByGoodsKind_View.GoodsId
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsSub
                                 ON ObjectLink_GoodsByGoodsKind_GoodsSub.ObjectId = Object_GoodsByGoodsKind_View.Id
                                AND ObjectLink_GoodsByGoodsKind_GoodsSub.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsSub()
            LEFT JOIN Object AS Object_GoodsSub ON Object_GoodsSub.Id = ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsSub_Measure
                                 ON ObjectLink_GoodsSub_Measure.ObjectId = Object_GoodsSub.Id
                                AND ObjectLink_GoodsSub_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_MeasureSub ON Object_MeasureSub.Id = ObjectLink_GoodsSub_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindSub
                                 ON ObjectLink_GoodsByGoodsKind_GoodsKindSub.ObjectId = Object_GoodsByGoodsKind_View.Id
                                AND ObjectLink_GoodsByGoodsKind_GoodsKindSub.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub()
            LEFT JOIN Object AS Object_GoodsKindSub ON Object_GoodsKindSub.Id = ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsPack
                                 ON ObjectLink_GoodsByGoodsKind_GoodsPack.ObjectId = Object_GoodsByGoodsKind_View.Id
                                AND ObjectLink_GoodsByGoodsKind_GoodsPack.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsPack()
            LEFT JOIN Object AS Object_GoodsPack ON Object_GoodsPack.Id = ObjectLink_GoodsByGoodsKind_GoodsPack.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsPack_Measure
                                 ON ObjectLink_GoodsPack_Measure.ObjectId = Object_GoodsPack.Id
                                AND ObjectLink_GoodsPack_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_MeasurePack ON Object_MeasurePack.Id = ObjectLink_GoodsPack_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindPack
                                 ON ObjectLink_GoodsByGoodsKind_GoodsKindPack.ObjectId = Object_GoodsByGoodsKind_View.Id
                                AND ObjectLink_GoodsByGoodsKind_GoodsKindPack.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKindPack()
            LEFT JOIN Object AS Object_GoodsKindPack ON Object_GoodsKindPack.Id = ObjectLink_GoodsByGoodsKind_GoodsKindPack.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Receipt
                                 ON ObjectLink_GoodsByGoodsKind_Receipt.ObjectId = Object_GoodsByGoodsKind_View.Id
                                AND ObjectLink_GoodsByGoodsKind_Receipt.DescId = zc_ObjectLink_GoodsByGoodsKind_Receipt()
            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_GoodsByGoodsKind_Receipt.ChildObjectId
            LEFT JOIN ObjectString AS ObjectString_Code
                                   ON ObjectString_Code.ObjectId = Object_Receipt.Id
                                  AND ObjectString_Code.DescId   = zc_ObjectString_Receipt_Code()

            LEFT JOIN (SELECT DISTINCT tmpCodeCalc.CodeCalc_Sh , tmpCodeCalc.Count1 FROM tmpCodeCalc WHERE tmpCodeCalc.CodeCalc_Sh  IS NOT NULL) AS tmpCodeCalc_1 ON tmpCodeCalc_1.CodeCalc_Sh = Object_GoodsByGoodsKind_View.CodeCalc_Sh
            LEFT JOIN (SELECT DISTINCT tmpCodeCalc.CodeCalc_Nom, tmpCodeCalc.Count2 FROM tmpCodeCalc WHERE tmpCodeCalc.CodeCalc_Nom IS NOT NULL) AS tmpCodeCalc_2 ON tmpCodeCalc_2.CodeCalc_Nom = Object_GoodsByGoodsKind_View.CodeCalc_Nom
            LEFT JOIN (SELECT DISTINCT tmpCodeCalc.CodeCalc_Ves, tmpCodeCalc.Count3 FROM tmpCodeCalc WHERE tmpCodeCalc.CodeCalc_Ves IS NOT NULL) AS tmpCodeCalc_3 ON tmpCodeCalc_3.CodeCalc_Ves = Object_GoodsByGoodsKind_View.CodeCalc_Ves

            LEFT JOIN tmpGoodsPropertyBox ON tmpGoodsPropertyBox.GoodsId     = Object_GoodsByGoodsKind_View.GoodsId
                                         AND tmpGoodsPropertyBox.GoodsKindId = Object_GoodsByGoodsKind_View.GoodsKindId
                                         AND tmpGoodsPropertyBox.BoxId IN (zc_Box_E2(), zc_Box_E3())

            LEFT JOIN tmpGoodsPropertyBox AS tmpGoodsPropertyBox_2
                                          ON tmpGoodsPropertyBox_2.GoodsId     = Object_GoodsByGoodsKind_View.GoodsId
                                         AND tmpGoodsPropertyBox_2.GoodsKindId = Object_GoodsByGoodsKind_View.GoodsKindId
                                         AND tmpGoodsPropertyBox_2.BoxId NOT IN (zc_Box_E2(), zc_Box_E3())

            LEFT JOIN tmpGoodsPropertyValue AS tmpRetail1
                                            ON tmpRetail1.RetailId    = inRetail1Id
                                           AND tmpRetail1.GoodsId     = Object_GoodsByGoodsKind_View.GoodsId
                                           AND tmpRetail1.GoodsKindId = Object_GoodsByGoodsKind_View.GoodsKindId
            LEFT JOIN tmpGoodsPropertyValue AS tmpRetail2
                                            ON tmpRetail2.RetailId    = inRetail2Id
                                           AND tmpRetail2.GoodsId     = Object_GoodsByGoodsKind_View.GoodsId
                                           AND tmpRetail2.GoodsKindId = Object_GoodsByGoodsKind_View.GoodsKindId
            LEFT JOIN tmpGoodsPropertyValue AS tmpRetail3
                                            ON tmpRetail3.RetailId    = inRetail3Id
                                           AND tmpRetail3.GoodsId     = Object_GoodsByGoodsKind_View.GoodsId
                                           AND tmpRetail3.GoodsKindId = Object_GoodsByGoodsKind_View.GoodsKindId
            LEFT JOIN tmpGoodsPropertyValue AS tmpRetail4
                                            ON tmpRetail4.RetailId    = inRetail4Id
                                           AND tmpRetail4.GoodsId     = Object_GoodsByGoodsKind_View.GoodsId
                                           AND tmpRetail4.GoodsKindId = Object_GoodsByGoodsKind_View.GoodsKindId
            LEFT JOIN tmpGoodsPropertyValue AS tmpRetail5
                                            ON tmpRetail5.RetailId    = inRetail5Id
                                           AND tmpRetail5.GoodsId     = Object_GoodsByGoodsKind_View.GoodsId
                                           AND tmpRetail5.GoodsKindId = Object_GoodsByGoodsKind_View.GoodsKindId
            LEFT JOIN tmpGoodsPropertyValue AS tmpRetail6
                                            ON tmpRetail6.RetailId    = inRetail6Id
                                           AND tmpRetail6.GoodsId     = Object_GoodsByGoodsKind_View.GoodsId
                                           AND tmpRetail6.GoodsKindId = Object_GoodsByGoodsKind_View.GoodsKindId
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
              ������� �.�.   ������ �.�.   ���������� �.�.
 11.04.19        *
 22.03.19        *
 13.03.19        * NormInDays
 22.06.18        *
 18.02.18        * add WeightPackageSticker
 21.12.17        * add GoodsSPack, GoodsKindPack
 09.06.17        * add NotMobile
 22.02.17        * add ChangePercentAmount
 08.12.16        * add isScaleCeh
 27.10.16        * add zc_ObjectLink_GoodsByGoodsKind_Receipt
 26.07.16        *
 17.06.15                                       * all
 18.03.15        * add redmine 17.03.2015
 29.01.14                        *
*/
/*
select BarCodeShort from (
select GoodsName, BarCodeShort from gpSelect_Object_GoodsPropertyValue(inGoodsPropertyId := 0 , inShowAll := 'False' ,  inSession := '5') as a
where BarCodeShort <> ''
group by GoodsName, BarCodeShort
) aS A
group by BarCodeShort
having count (*) > 1
*/
-- ����
-- SELECT * FROM gpSelect_Object_GoodsByGoodsKind_VMC (0,0,0,0,0,0,zfCalc_UserAdmin())  limit 10
