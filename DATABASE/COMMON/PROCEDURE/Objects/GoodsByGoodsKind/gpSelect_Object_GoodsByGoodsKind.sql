-- Function: gpSelect_Object_Account(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsByGoodsKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsByGoodsKind(
    IN inSession     TVarChar       -- сессия пользователя
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
             , WeightPackageKorob TFloat, WeightPackage TFloat, WeightPackageSticker TFloat
             , WeightTotal TFloat, ChangePercentAmount TFloat
             , WeightMin TFloat, WeightMax TFloat
             , Height TFloat, Length TFloat, Width TFloat
             , NormInDays TFloat
             , DaysQ TFloat
             , Value1_gk TVarChar, Value11_gk TVarChar

             , NormRem TFloat, NormOut TFloat
             , NormPack TFloat 
             , PackLimit TFloat
             , isPackLimit Boolean
             , isOrder Boolean, isScaleCeh Boolean, isNotMobile Boolean
             , isNewQuality Boolean
             , isTop Boolean
             , isNotPack Boolean
             , isRK Boolean     
             , isPackOrder Boolean 
             , isEtiketka  Boolean
             , GoodsSubId Integer, GoodsSubCode Integer, GoodsSubName TVarChar, MeasureSubName TVarChar
             , GoodsKindSubId Integer, GoodsKindSubName TVarChar
             , GoodsSubSendId Integer, GoodsSubSendCode Integer, GoodsSubSendName TVarChar, MeasureSubSendName TVarChar
             , GoodsKindSubSendId Integer, GoodsKindSubSendName TVarChar
             , GoodsSubId_Br Integer, GoodsSubCode_Br Integer, GoodsSubName_Br TVarChar, MeasureSubName_Br TVarChar 
             , GoodsKindSubSendId_Br Integer , GoodsKindSubSendName_Br TVarChar
             , GoodsPackId Integer, GoodsPackCode Integer, GoodsPackName TVarChar, MeasurePackName TVarChar
             , GoodsKindPackId Integer, GoodsKindPackName TVarChar
             , GoodsRealId Integer, GoodsRealCode Integer, GoodsRealName TVarChar, MeasureRealName TVarChar
             , GoodsKindRealId Integer, GoodsKindRealName TVarChar 
             , GoodsKindNewId Integer, GoodsKindNewName TVarChar
             , GoodsIncomeId Integer, GoodsIncomeCode Integer, GoodsIncomeName TVarChar, MeasureIncomeName TVarChar
             , GoodsKindIncomeId Integer, GoodsKindIncomeName TVarChar             
             , ReceiptId Integer, ReceiptCode TVarChar, ReceiptName TVarChar
             , ReceiptGPId Integer, ReceiptGPCode TVarChar, ReceiptGPName TVarChar
             , GoodsCode_basis Integer, GoodsName_basis TVarChar
             , GoodsCode_main Integer, GoodsName_main TVarChar
             , GoodsBrandName TVarChar
             , isCheck_basis Boolean, isCheck_main Boolean
             , isGoodsTypeKind_Sh Boolean, isGoodsTypeKind_Nom Boolean, isGoodsTypeKind_Ves Boolean
             , CodeCalc_Sh TVarChar
             , CodeCalc_Nom TVarChar
             , CodeCalc_Ves TVarChar
             , isCodeCalc_Diff Boolean
             , WmsCode           Integer
             , WmsCodeCalc_Sh    TVarChar 
             , WmsCodeCalc_Nom   TVarChar 
             , WmsCodeCalc_Ves   TVarChar
             , GoodsCode_basis_old Integer  
             , GoodsName_basis_old TVarChar 
             , GoodsCode_main_old  Integer  
             , GoodsName_main_old  TVarChar 
             , EndDate_old  TDateTime
             , GoodsSubDate TDateTime 
             , isNotDate    Boolean
             
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
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
                                  , ObjectFloat_WmsCode.ValueData AS WmsCode
                                  
                                  , CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.ChildObjectId, 0)  <> 0 
                                         THEN (''||COALESCE (ObjectFloat_WmsCode.ValueData,0)::Integer||'.'||CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.ChildObjectId, 0) <> 0 THEN 1 ELSE 0 END)
                                         ELSE NULL
                                    END  :: TVarChar AS WmsCodeCalc_Sh
                                  , CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.ChildObjectId, 0)  <> 0 
                                         THEN (''||COALESCE (ObjectFloat_WmsCode.ValueData,0)::Integer||'.'||CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.ChildObjectId, 0) <> 0 THEN 2 ELSE 0 END)
                                         ELSE NULL
                                    END  :: TVarChar AS WmsCodeCalc_Nom
                                  , CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves.ChildObjectId, 0)  <> 0 
                                         THEN (''||COALESCE (ObjectFloat_WmsCode.ValueData,0)::Integer||'.'||CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves.ChildObjectId, 0) <> 0 THEN 3 ELSE 0 END)
                                         ELSE NULL
                                    END  :: TVarChar AS WmsCodeCalc_Ves

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

           , COALESCE (ObjectFloat_WeightPackageKorob.ValueData,0)  ::TFloat  AS WeightPackageKorob
           , COALESCE (ObjectFloat_WeightPackage.ValueData,0)       ::TFloat  AS WeightPackage
           , COALESCE (ObjectFloat_WeightPackageSticker.ValueData,0)::TFloat  AS WeightPackageSticker
           , COALESCE (ObjectFloat_WeightTotal.ValueData,0)         ::TFloat  AS WeightTotal
           , COALESCE (ObjectFloat_ChangePercentAmount.ValueData,0) ::TFloat  AS ChangePercentAmount

           , COALESCE (ObjectFloat_WeightMin.ValueData,0)       ::TFloat  AS WeightMin
           , COALESCE (ObjectFloat_WeightMax.ValueData,0)       ::TFloat  AS WeightMax
           , COALESCE (ObjectFloat_Height.ValueData,0)          ::TFloat  AS Height
           , COALESCE (ObjectFloat_Length.ValueData,0)          ::TFloat  AS Length
           , COALESCE (ObjectFloat_Width.ValueData,0)           ::TFloat  AS Width

             -- срок годности в днях
           , COALESCE (ObjectFloat_NormInDays.ValueData,0)      ::TFloat  AS NormInDays
             -- Уменьшение на N дней от даты покупателя в качественном
           , COALESCE (ObjectFloat_DaysQ.ValueData,0)           ::TFloat  AS DaysQ
             -- Вид оболонки, №4
           , ObjectString_GK_Value1.ValueData                             AS Value1_gk
             -- Вид пакування/стан продукції 
           , ObjectString_GK_Value11.ValueData                            AS Value11_gk
           
           , COALESCE (ObjectFloat_NormRem.ValueData,0)         ::TFloat  AS NormRem
           , COALESCE (ObjectFloat_NormOut.ValueData,0)         ::TFloat  AS NormOut
           , COALESCE (ObjectFloat_NormPack.ValueData,0)        ::TFloat  AS NormPack 
           , COALESCE (ObjectFloat_PackLimit.ValueData,0)       ::TFloat  AS PackLimit

           , COALESCE (ObjectBoolean_PackLimit.ValueData, FALSE) ::Boolean AS isPackLimit
           , COALESCE (ObjectBoolean_Order.ValueData, False)           AS isOrder
           , COALESCE (ObjectBoolean_ScaleCeh.ValueData, False)        AS isScaleCeh
           , COALESCE (ObjectBoolean_NotMobile.ValueData, False)       AS isNotMobile
           , COALESCE (ObjectBoolean_NewQuality.ValueData, False)      AS isNewQuality
           , COALESCE (ObjectBoolean_Top.ValueData, False)             AS isTop
           , COALESCE (ObjectBoolean_NotPack.ValueData, False)   ::Boolean AS isNotPack
           , COALESCE (ObjectBoolean_RK.ValueData, FALSE)        ::Boolean AS isRK      
           , COALESCE (ObjectBoolean_PackOrder.ValueData, False) ::Boolean AS isPackOrder
           , COALESCE (ObjectBoolean_Etiketka.ValueData, False)  ::Boolean AS isEtiketka

           , Object_GoodsSub.Id               AS GoodsSubId
           , Object_GoodsSub.ObjectCode       AS GoodsSubCode
           , Object_GoodsSub.ValueData        AS GoodsSubName
           , Object_MeasureSub.ValueData      AS MeasureSubName
           , Object_GoodsKindSub.Id           AS GoodsKindSubId
           , Object_GoodsKindSub.ValueData    AS GoodsKindSubName

           , Object_GoodsSubSend.Id               AS GoodsSubSendId
           , Object_GoodsSubSend.ObjectCode       AS GoodsSubSendCode
           , Object_GoodsSubSend.ValueData        AS GoodsSubSendName
           , Object_MeasureSubSend.ValueData      AS MeasureSubSendName
           , Object_GoodsKindSubSend.Id           AS GoodsKindSubSendId
           , Object_GoodsKindSubSend.ValueData    AS GoodsKindSubSendName

           , Object_GoodsSub_Br.Id                   AS GoodsSubId_Br
           , Object_GoodsSub_Br.ObjectCode           AS GoodsSubCode_Br
           , Object_GoodsSub_Br.ValueData            AS GoodsSubName_Br
           , Object_MeasureSub_Br.ValueData          AS MeasureSubName_Br
           , Object_GoodsKindSubSend_Br.Id           AS GoodsKindSubSendId_Br
           , Object_GoodsKindSubSend_Br.ValueData    AS GoodsKindSubSendName_Br

           , Object_GoodsPack.Id               AS GoodsPackId
           , Object_GoodsPack.ObjectCode       AS GoodsPackCode
           , Object_GoodsPack.ValueData        AS GoodsPackName
           , Object_MeasurePack.ValueData      AS MeasurePackName
           , Object_GoodsKindPack.Id           AS GoodsKindPackId
           , Object_GoodsKindPack.ValueData    AS GoodsKindPackName

           , Object_GoodsReal.Id               AS GoodsRealId
           , Object_GoodsReal.ObjectCode       AS GoodsRealCode
           , Object_GoodsReal.ValueData        AS GoodsRealName
           , Object_MeasureReal.ValueData      AS MeasureRealName
           , Object_GoodsKindReal.Id           AS GoodsKindRealId
           , Object_GoodsKindReal.ValueData    AS GoodsKindRealName

           , Object_GoodsKindNew.Id           AS GoodsKindNewId
           , Object_GoodsKindNew.ValueData    AS GoodsKindNewName

           , Object_GoodsIncome.Id               AS GoodsIncomeId
           , Object_GoodsIncome.ObjectCode       AS GoodsIncomeCode
           , Object_GoodsIncome.ValueData        AS GoodsIncomeName
           , Object_MeasureIncome.ValueData      AS MeasureIncomeName
           , Object_GoodsKindIncome.Id           AS GoodsKindIncomeId
           , Object_GoodsKindIncome.ValueData    AS GoodsKindIncomeName

           , Object_Receipt.Id                AS ReceiptId
           , ObjectString_Code.ValueData      AS ReceiptCode
           , Object_Receipt.ValueData         AS ReceiptName

           , Object_ReceiptGP.Id              AS ReceiptGPId
           , ObjectString_CodeGP.ValueData    AS ReceiptGPCode
           , Object_ReceiptGP.ValueData       AS ReceiptGPName

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

           , Object_GoodsByGoodsKind_View.WmsCode          :: Integer
           , Object_GoodsByGoodsKind_View.WmsCodeCalc_Sh   :: TVarChar 
           , Object_GoodsByGoodsKind_View.WmsCodeCalc_Nom  :: TVarChar 
           , Object_GoodsByGoodsKind_View.WmsCodeCalc_Ves  :: TVarChar

           , Object_Goods_basis_old.ObjectCode      ::Integer    AS GoodsCode_basis_old
           , Object_Goods_basis_old.ValueData       ::TVarChar   AS GoodsName_basis_old
           , Object_Goods_main_old.ObjectCode       ::Integer    AS GoodsCode_main_old
           , Object_Goods_main_old.ValueData        ::TVarChar   AS GoodsName_main_old
           , ObjectDate_End_old.ValueData           ::TDateTime  AS EndDate_old
           , ObjectDate_GoodsSub.ValueData          ::TDateTime  AS GoodsSubDate
           , TRUE                                   ::Boolean    AS isNotDate
       FROM tmpGoodsByGoodsKind AS Object_GoodsByGoodsKind_View
            /*LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsBasis
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
            */
            LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackageKorob
                                  ON ObjectFloat_WeightPackageKorob.ObjectId = Object_GoodsByGoodsKind_View.Id
                                 AND ObjectFloat_WeightPackageKorob.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightPackageKorob()

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
            LEFT JOIN ObjectFloat AS ObjectFloat_DaysQ
                                  ON ObjectFloat_DaysQ.ObjectId = Object_GoodsByGoodsKind_View.Id
                                 AND ObjectFloat_DaysQ.DescId = zc_ObjectFloat_GoodsByGoodsKind_DaysQ()

            LEFT JOIN ObjectString AS ObjectString_GK_Value1
                                   ON ObjectString_GK_Value1.ObjectId = Object_GoodsByGoodsKind_View.Id
                                  AND ObjectString_GK_Value1.DescId   = zc_ObjectString_GoodsByGoodsKind_Quality1()
            LEFT JOIN ObjectString AS ObjectString_GK_Value11
                                   ON ObjectString_GK_Value11.ObjectId = Object_GoodsByGoodsKind_View.Id
                                  AND ObjectString_GK_Value11.DescId   = zc_ObjectString_GoodsByGoodsKind_Quality11()


            LEFT JOIN ObjectFloat AS ObjectFloat_NormRem
                                  ON ObjectFloat_NormRem.ObjectId = Object_GoodsByGoodsKind_View.Id
                                 AND ObjectFloat_NormRem.DescId = zc_ObjectFloat_GoodsByGoodsKind_NormRem()
            LEFT JOIN ObjectFloat AS ObjectFloat_NormOut
                                  ON ObjectFloat_NormOut.ObjectId = Object_GoodsByGoodsKind_View.Id
                                 AND ObjectFloat_NormOut.DescId = zc_ObjectFloat_GoodsByGoodsKind_NormOut()
            LEFT JOIN ObjectFloat AS ObjectFloat_NormPack
                                  ON ObjectFloat_NormPack.ObjectId = Object_GoodsByGoodsKind_View.Id
                                 AND ObjectFloat_NormPack.DescId = zc_ObjectFloat_GoodsByGoodsKind_NormPack()
                                 
            LEFT JOIN ObjectFloat AS ObjectFloat_PackLimit
                                  ON ObjectFloat_PackLimit.ObjectId = Object_GoodsByGoodsKind_View.Id
                                 AND ObjectFloat_PackLimit.DescId = zc_ObjectFloat_GoodsByGoodsKind_PackLimit()
 --
            LEFT JOIN ObjectBoolean AS ObjectBoolean_PackLimit
                                    ON ObjectBoolean_PackLimit.ObjectId = Object_GoodsByGoodsKind_View.Id
                                   AND ObjectBoolean_PackLimit.DescId = zc_ObjectBoolean_GoodsByGoodsKind_PackLimit()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Order
                                    ON ObjectBoolean_Order.ObjectId = Object_GoodsByGoodsKind_View.Id
                                   AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_ScaleCeh
                                    ON ObjectBoolean_ScaleCeh.ObjectId = Object_GoodsByGoodsKind_View.Id
                                   AND ObjectBoolean_ScaleCeh.DescId = zc_ObjectBoolean_GoodsByGoodsKind_ScaleCeh()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_NotMobile
                                    ON ObjectBoolean_NotMobile.ObjectId = Object_GoodsByGoodsKind_View.Id
                                   AND ObjectBoolean_NotMobile.DescId = zc_ObjectBoolean_GoodsByGoodsKind_NotMobile()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_NewQuality
                                    ON ObjectBoolean_NewQuality.ObjectId = Object_GoodsByGoodsKind_View.Id
                                   AND ObjectBoolean_NewQuality.DescId = zc_ObjectBoolean_GoodsByGoodsKind_NewQuality()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                    ON ObjectBoolean_Top.ObjectId = Object_GoodsByGoodsKind_View.Id
                                   AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Top()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_NotPack
                                    ON ObjectBoolean_NotPack.ObjectId = Object_GoodsByGoodsKind_View.Id
                                   AND ObjectBoolean_NotPack.DescId = zc_ObjectBoolean_GoodsByGoodsKind_NotPack()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_RK
                                    ON ObjectBoolean_RK.ObjectId = Object_GoodsByGoodsKind_View.Id
                                   AND ObjectBoolean_RK.DescId = zc_ObjectBoolean_GoodsByGoodsKind_RK()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_PackOrder
                                    ON ObjectBoolean_PackOrder.ObjectId = Object_GoodsByGoodsKind_View.Id
                                   AND ObjectBoolean_PackOrder.DescId = zc_ObjectBoolean_GoodsByGoodsKind_PackOrder()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Etiketka
                                    ON ObjectBoolean_Etiketka.ObjectId = Object_GoodsByGoodsKind_View.Id
                                   AND ObjectBoolean_Etiketka.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Etiketka()

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
            --
            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsSubSend
                                 ON ObjectLink_GoodsByGoodsKind_GoodsSubSend.ObjectId = Object_GoodsByGoodsKind_View.Id
                                AND ObjectLink_GoodsByGoodsKind_GoodsSubSend.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsSubSend()
            LEFT JOIN Object AS Object_GoodsSubSend ON Object_GoodsSubSend.Id = ObjectLink_GoodsByGoodsKind_GoodsSubSend.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsSubSend_Measure
                                 ON ObjectLink_GoodsSubSend_Measure.ObjectId = Object_GoodsSubSend.Id
                                AND ObjectLink_GoodsSubSend_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_MeasureSubSend ON Object_MeasureSubSend.Id = ObjectLink_GoodsSubSend_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindSubSend
                                 ON ObjectLink_GoodsByGoodsKind_GoodsKindSubSend.ObjectId = Object_GoodsByGoodsKind_View.Id
                                AND ObjectLink_GoodsByGoodsKind_GoodsKindSubSend.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKindSubSend()
            LEFT JOIN Object AS Object_GoodsKindSubSend ON Object_GoodsKindSubSend.Id = ObjectLink_GoodsByGoodsKind_GoodsKindSubSend.ChildObjectId
            --
            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsSub_Br
                                 ON ObjectLink_GoodsByGoodsKind_GoodsSub_Br.ObjectId = Object_GoodsByGoodsKind_View.Id
                                AND ObjectLink_GoodsByGoodsKind_GoodsSub_Br.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsSub_Br()
            LEFT JOIN Object AS Object_GoodsSub_Br ON Object_GoodsSub_Br.Id = ObjectLink_GoodsByGoodsKind_GoodsSub_Br.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsSub_Measure_Br
                                 ON ObjectLink_GoodsSub_Measure_Br.ObjectId = Object_GoodsSub_Br.Id
                                AND ObjectLink_GoodsSub_Measure_Br.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_MeasureSub_Br ON Object_MeasureSub_Br.Id = ObjectLink_GoodsSub_Measure_Br.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindSubSend_Br
                                 ON ObjectLink_GoodsByGoodsKind_GoodsKindSubSend_Br.ObjectId = Object_GoodsByGoodsKind_View.Id
                                AND ObjectLink_GoodsByGoodsKind_GoodsKindSubSend_Br.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKindSubSend_Br()
            LEFT JOIN Object AS Object_GoodsKindSubSend_Br ON Object_GoodsKindSubSend_Br.Id = ObjectLink_GoodsByGoodsKind_GoodsKindSubSend_Br.ChildObjectId
            
            --
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

            --
            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsReal
                                 ON ObjectLink_GoodsByGoodsKind_GoodsReal.ObjectId = Object_GoodsByGoodsKind_View.Id
                                AND ObjectLink_GoodsByGoodsKind_GoodsReal.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsReal()
            LEFT JOIN Object AS Object_GoodsReal ON Object_GoodsReal.Id = ObjectLink_GoodsByGoodsKind_GoodsReal.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsReal_Measure
                                 ON ObjectLink_GoodsReal_Measure.ObjectId = Object_GoodsReal.Id
                                AND ObjectLink_GoodsReal_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_MeasureReal ON Object_MeasureReal.Id = ObjectLink_GoodsReal_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindReal
                                 ON ObjectLink_GoodsByGoodsKind_GoodsKindReal.ObjectId = Object_GoodsByGoodsKind_View.Id
                                AND ObjectLink_GoodsByGoodsKind_GoodsKindReal.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKindReal()
            LEFT JOIN Object AS Object_GoodsKindReal ON Object_GoodsKindReal.Id = ObjectLink_GoodsByGoodsKind_GoodsKindReal.ChildObjectId

            --
            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsIncome
                                 ON ObjectLink_GoodsByGoodsKind_GoodsIncome.ObjectId = Object_GoodsByGoodsKind_View.Id
                                AND ObjectLink_GoodsByGoodsKind_GoodsIncome.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsIncome()
            LEFT JOIN Object AS Object_GoodsIncome ON Object_GoodsIncome.Id = ObjectLink_GoodsByGoodsKind_GoodsIncome.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsIncome_Measure
                                 ON ObjectLink_GoodsIncome_Measure.ObjectId = Object_GoodsIncome.Id
                                AND ObjectLink_GoodsIncome_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_MeasureIncome ON Object_MeasureIncome.Id = ObjectLink_GoodsIncome_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindIncome
                                 ON ObjectLink_GoodsByGoodsKind_GoodsKindIncome.ObjectId = Object_GoodsByGoodsKind_View.Id
                                AND ObjectLink_GoodsByGoodsKind_GoodsKindIncome.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKindIncome()
            LEFT JOIN Object AS Object_GoodsKindIncome ON Object_GoodsKindIncome.Id = ObjectLink_GoodsByGoodsKind_GoodsKindIncome.ChildObjectId
            --

            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindNew
                                 ON ObjectLink_GoodsByGoodsKind_GoodsKindNew.ObjectId = Object_GoodsByGoodsKind_View.Id
                                AND ObjectLink_GoodsByGoodsKind_GoodsKindNew.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKindNew()
            LEFT JOIN Object AS Object_GoodsKindNew ON Object_GoodsKindNew.Id = ObjectLink_GoodsByGoodsKind_GoodsKindNew.ChildObjectId

            --old
            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsBasis_old
                                 ON ObjectLink_GoodsByGoodsKind_GoodsBasis_old.ObjectId = Object_GoodsByGoodsKind_View.Id
                                AND ObjectLink_GoodsByGoodsKind_GoodsBasis_old.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsBasis_old()
            LEFT JOIN Object AS Object_Goods_basis_old ON Object_Goods_basis_old.Id = ObjectLink_GoodsByGoodsKind_GoodsBasis_old.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsMain_old
                                 ON ObjectLink_GoodsByGoodsKind_GoodsMain_old.ObjectId = Object_GoodsByGoodsKind_View.Id
                                AND ObjectLink_GoodsByGoodsKind_GoodsMain_old.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsMain_old()
            LEFT JOIN Object AS Object_Goods_main_old ON Object_Goods_main_old.Id = ObjectLink_GoodsByGoodsKind_GoodsMain_old.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_End_old
                                 ON ObjectDate_End_old.ObjectId = Object_GoodsByGoodsKind_View.Id
                                AND ObjectDate_End_old.DescId = zc_ObjectDate_GoodsByGoodsKind_End_old()

            LEFT JOIN ObjectDate AS ObjectDate_GoodsSub
                                 ON ObjectDate_GoodsSub.ObjectId = Object_GoodsByGoodsKind_View.Id
                                AND ObjectDate_GoodsSub.DescId = zc_ObjectDate_GoodsByGoodsKind_GoodsSub()
            --
            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Receipt
                                 ON ObjectLink_GoodsByGoodsKind_Receipt.ObjectId = Object_GoodsByGoodsKind_View.Id
                                AND ObjectLink_GoodsByGoodsKind_Receipt.DescId = zc_ObjectLink_GoodsByGoodsKind_Receipt()
            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_GoodsByGoodsKind_Receipt.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Code
                                   ON ObjectString_Code.ObjectId = Object_Receipt.Id
                                  AND ObjectString_Code.DescId   = zc_ObjectString_Receipt_Code()

            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_ReceiptGP
                                 ON ObjectLink_GoodsByGoodsKind_ReceiptGP.ObjectId = Object_GoodsByGoodsKind_View.Id
                                AND ObjectLink_GoodsByGoodsKind_ReceiptGP.DescId = zc_ObjectLink_GoodsByGoodsKind_ReceiptGP()
            LEFT JOIN Object AS Object_ReceiptGP ON Object_ReceiptGP.Id = ObjectLink_GoodsByGoodsKind_ReceiptGP.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_CodeGP
                                   ON ObjectString_CodeGP.ObjectId = Object_Receipt.Id
                                  AND ObjectString_CodeGP.DescId   = zc_ObjectString_Receipt_Code()

            LEFT JOIN (SELECT DISTINCT tmpCodeCalc.CodeCalc_Sh , tmpCodeCalc.Count1 FROM tmpCodeCalc WHERE tmpCodeCalc.CodeCalc_Sh  IS NOT NULL) AS tmpCodeCalc_1 ON tmpCodeCalc_1.CodeCalc_Sh = Object_GoodsByGoodsKind_View.CodeCalc_Sh
            LEFT JOIN (SELECT DISTINCT tmpCodeCalc.CodeCalc_Nom, tmpCodeCalc.Count2 FROM tmpCodeCalc WHERE tmpCodeCalc.CodeCalc_Nom IS NOT NULL) AS tmpCodeCalc_2 ON tmpCodeCalc_2.CodeCalc_Nom = Object_GoodsByGoodsKind_View.CodeCalc_Nom
            LEFT JOIN (SELECT DISTINCT tmpCodeCalc.CodeCalc_Ves, tmpCodeCalc.Count3 FROM tmpCodeCalc WHERE tmpCodeCalc.CodeCalc_Ves IS NOT NULL) AS tmpCodeCalc_3 ON tmpCodeCalc_3.CodeCalc_Ves = Object_GoodsByGoodsKind_View.CodeCalc_Ves
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsByGoodsKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.03.25        * WeightPackageKorob 
 20.01.25        * isEtiketka
 11.11.24        * GoodsSubDate
 04.11.24        * GoodsIncomeId, GoodsKindIncomeId
 16.02.24        * PackLimit, isPackLimit
 22.01.24        * isPackOrder
 20.12.22        * GoodsKindNew
 07.12.22        * isRK
 30.09.22        * GoodsReal
 07.06.22        *
 03.03.22        *
 18.04.21        *
 25.03.21        *
 19.02.21        * DaysQ
 10.04.20        *
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
-- тест
-- SELECT * FROM gpSelect_Object_GoodsByGoodsKind (zfCalc_UserAdmin())  limit 10
