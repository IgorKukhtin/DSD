-- Function: gpSelect_Object_GoodsByGoodsKind_VMC(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsByGoodsKind_VMC (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsByGoodsKind_VMC(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, GoodsId Integer, Code Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsGroupAnalystName TVarChar
             , TradeMarkName TVarChar
             , GoodsTagName TVarChar
             , GoodsPlatformName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , MeasureName TVarChar
             , Weight TFloat
             , WeightPackage TFloat, WeightPackageSticker TFloat
             , WeightTotal TFloat, ChangePercentAmount TFloat
             , WeightMin TFloat, WeightMax TFloat
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
             , isGoodsTypeKind_Sh Boolean, isGoodsTypeKind_Nom Boolean, isGoodsTypeKind_Ves Boolean
             , CodeCalc_Sh TVarChar
             , CodeCalc_Nom TVarChar
             , CodeCalc_Ves TVarChar
             , isCodeCalc_Diff Boolean
             --
             --, GoodsPropertyBoxId Integer
             , BoxId Integer, BoxCode Integer, BoxName TVarChar
             , WeightOnBox TFloat, CountOnBox TFloat
             , BoxVolume TFloat, BoxWeight TFloat
             , BoxHeight TFloat, BoxLength TFloat, BoxWidth TFloat
             , WeightGross TFloat
             , BoxId_2 Integer, BoxCode_2 Integer, BoxName_2 TVarChar
             , WeightOnBox_2 TFloat, CountOnBox_2 TFloat
             , BoxVolume_2 TFloat, BoxWeight_2 TFloat
             , BoxHeight_2 TFloat, BoxLength_2 TFloat, BoxWidth_2 TFloat
             , WeightGross_2 TFloat
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
       --
       SELECT
             Object_GoodsByGoodsKind_View.Id
           , Object_GoodsByGoodsKind_View.GoodsId
           , Object_GoodsByGoodsKind_View.GoodsCode
           , Object_GoodsByGoodsKind_View.GoodsName
           , Object_GoodsByGoodsKind_View.GoodsKindId
           , Object_GoodsByGoodsKind_View.GoodsKindName

           , Object_GoodsGroup.ValueData     AS GoodsGroupName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , Object_GoodsGroupAnalyst.ValueData AS GoodsGroupAnalystName
           , Object_TradeMark.ValueData      AS TradeMarkName
           , Object_GoodsTag.ValueData       AS GoodsTagName
           , Object_GoodsPlatform.ValueData  AS GoodsPlatformName

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , Object_Measure.ValueData        AS MeasureName

           , ObjectFloat_Weight.ValueData    AS Weight

           , COALESCE (ObjectFloat_WeightPackage.ValueData,0)       ::TFloat  AS WeightPackage
           , COALESCE (ObjectFloat_WeightPackageSticker.ValueData,0)::TFloat  AS WeightPackageSticker
           , COALESCE (ObjectFloat_WeightTotal.ValueData,0)         ::TFloat  AS WeightTotal
           , COALESCE (ObjectFloat_ChangePercentAmount.ValueData,0) ::TFloat  AS ChangePercentAmount

           , COALESCE (ObjectFloat_WeightMin.ValueData,0)       ::TFloat  AS WeightMin
           , COALESCE (ObjectFloat_WeightMax.ValueData,0)       ::TFloat  AS WeightMax
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

           , Object_GoodsPack.Id               AS GoodsPackId
           , Object_GoodsPack.ObjectCode       AS GoodsPackCode
           , Object_GoodsPack.ValueData        AS GoodsPackName
           , Object_MeasurePack.ValueData      AS MeasurePackName
           , Object_GoodsKindPack.Id           AS GoodsKindPackId
           , Object_GoodsKindPack.ValueData    AS GoodsKindPackName

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
           
           , Object_GoodsByGoodsKind_View.isGoodsTypeKind_Sh
           , Object_GoodsByGoodsKind_View.isGoodsTypeKind_Nom
           , Object_GoodsByGoodsKind_View.isGoodsTypeKind_Ves
           
           , Object_GoodsByGoodsKind_View.CodeCalc_Sh  :: TVarChar 
           , Object_GoodsByGoodsKind_View.CodeCalc_Nom  :: TVarChar 
           , Object_GoodsByGoodsKind_View.CodeCalc_Ves  :: TVarChar 
             
           , CASE WHEN Object_GoodsByGoodsKind_View.isGoodsTypeKind_Sh = FALSE AND Object_GoodsByGoodsKind_View.isGoodsTypeKind_Nom = FALSE AND Object_GoodsByGoodsKind_View.isGoodsTypeKind_Ves = FALSE THEN FALSE
                  WHEN (COALESCE (tmpCodeCalc_1.Count1, 1) + COALESCE (tmpCodeCalc_2.Count2, 1) + COALESCE (tmpCodeCalc_3.Count3, 1)) <= 3 THEN FALSE 
                  ELSE TRUE
             END  AS isCodeCalc_Diff

            -- ���� 1
            , tmpGoodsPropertyBox.BoxId
            , tmpGoodsPropertyBox.BoxCode
            , tmpGoodsPropertyBox.BoxName
            , tmpGoodsPropertyBox.WeightOnBox
            , tmpGoodsPropertyBox.CountOnBox
            , tmpGoodsPropertyBox.BoxVolume
            , tmpGoodsPropertyBox.BoxWeight
            , tmpGoodsPropertyBox.BoxHeight
            , tmpGoodsPropertyBox.BoxLength
            , tmpGoodsPropertyBox.BoxWidth
            , (tmpGoodsPropertyBox.WeightOnBox + tmpGoodsPropertyBox.BoxWeight) :: TFloat AS WeightGross
            -- ���� 2
            , tmpGoodsPropertyBox_2.BoxId       AS BoxId_2
            , tmpGoodsPropertyBox_2.BoxCode     AS BoxCode_2
            , tmpGoodsPropertyBox_2.BoxName     AS BoxName_2
            , tmpGoodsPropertyBox_2.WeightOnBox AS WeightOnBox_2
            , tmpGoodsPropertyBox_2.CountOnBox  AS CountOnBox_2
            , tmpGoodsPropertyBox_2.BoxVolume   AS BoxVolume_2
            , tmpGoodsPropertyBox_2.BoxWeight   AS BoxWeight_2
            , tmpGoodsPropertyBox_2.BoxHeight   AS BoxHeight_2
            , tmpGoodsPropertyBox_2.BoxLength   AS BoxLength_2
            , tmpGoodsPropertyBox_2.BoxWidth    AS BoxWidth_2
            , (tmpGoodsPropertyBox_2.WeightOnBox + tmpGoodsPropertyBox_2.BoxWeight) :: TFloat AS WeightGross_2

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
                                         
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
              ������� �.�.   ������ �.�.   ���������� �.�.
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
-- SELECT * FROM gpSelect_Object_GoodsByGoodsKind_VMC (zfCalc_UserAdmin())  limit 10
