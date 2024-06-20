-- Function: gpSelect_Object_Sticker_List()

DROP FUNCTION IF EXISTS gpSelect_Object_Sticker_List (Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Sticker_List(
    IN inShowErased  Boolean,
    IN inShowAll     Boolean,   
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer,Code Integer, Comment TVarChar 
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar, ItemName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, TradeMarkName_Goods TVarChar
             , StickerGroupId Integer, StickerGroupName TVarChar
             , StickerTypeId Integer, StickerTypeName TVarChar
             , StickerTagId Integer, StickerTagName TVarChar
             , StickerSortId Integer, StickerSortName TVarChar
             , StickerNormId Integer, StickerNormName TVarChar
             , StickerFileId Integer, StickerFileName TVarChar, StickerFileName_inf TVarChar, TradeMarkName_StickerFile TVarChar
             , StickerFileId_70_70 Integer, StickerFileName_70_70 TVarChar, TradeMarkName_StickerFile_70_70 TVarChar
             , Info TBlob
             , Value1 TFloat, Value2 TFloat, Value3 TFloat, Value4 TFloat, Value5 TFloat
             , Value6 TFloat, Value7 TFloat, Value8 TFloat
             , isErased_Sticker Boolean
 
             , StickerPropertyId     Integer
             , StickerPropertyCode   Integer
             , Comment_SP            TVarChar
             , GoodsKindId_SP        Integer
             , GoodsKindName_SP      TVarChar
             , StickerPackId_SP      Integer
             , StickerPackName_SP    TVarChar
             , StickerFileId_SP      Integer
             , StickerFileName_SP    TVarChar
             , TradeMarkName_StickerFile_SP TVarChar 
             , StickerFileId_70_70_SP Integer
             , StickerFileName_70_70_SP TVarChar
             , TradeMarkName_StickerFile_70_70_SP TVarChar
             , StickerSkinId_SP      Integer
             , StickerSkinName_SP    TVarChar
             , BarCode_SP            TVarChar
             , isFix_SP              Boolean
             , isCK_SP               Boolean  
             , isNormInDays_not_SP      Boolean
             
             , Value1_SP             TFloat
             , Value2_SP             TFloat
             , Value3_SP             TFloat
             , Value4_SP             TFloat
               -- Кількість діб -> ***срок в днях
             , Value5_SP             TFloat
             , Value5_SP_orig        TFloat
             , NormInDays_gk         TFloat
             , isDiff_NormInDays_gk  Boolean
               --
             , Value6_SP             TFloat
             , Value7_SP             TFloat
             , Value8_SP             TFloat
             , Value9_SP             TFloat
             , Value10_SP            TFloat
             , Value11_SP            TFloat
             , isErased_SP           Boolean
             , isErased              Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Object_Sticker());
     vbUserId:= lpGetUserBySession (inSession);

    IF inShowAll = TRUE   
    THEN
     -- Результат
     --показать все товары
     RETURN QUERY 
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowErased AS isErased WHERE inShowErased = TRUE)
            -- Шаблоны "по умолчанию" - для конкретной ТМ
          , tmpStickerFile AS (SELECT Object_StickerFile.ValueData                    AS Name
                                    , ObjectLink_StickerFile_TradeMark.ChildObjectId  AS TradeMarkId
                               FROM Object AS Object_StickerFile
                                    LEFT JOIN ObjectLink AS ObjectLink_StickerFile_Juridical
                                                         ON ObjectLink_StickerFile_Juridical.ObjectId = Object_StickerFile.Id
                                                        AND ObjectLink_StickerFile_Juridical.DescId   = zc_ObjectLink_StickerFile_Juridical()
                                    INNER JOIN ObjectLink AS ObjectLink_StickerFile_TradeMark
                                                          ON ObjectLink_StickerFile_TradeMark.ObjectId = Object_StickerFile.Id
                                                         AND ObjectLink_StickerFile_TradeMark.DescId = zc_ObjectLink_StickerFile_TradeMark()
                                    
                                    INNER JOIN ObjectBoolean AS ObjectBoolean_Default
                                                             ON ObjectBoolean_Default.ObjectId  = Object_StickerFile.Id
                                                            AND ObjectBoolean_Default.DescId    = zc_ObjectBoolean_StickerFile_Default()
                                                            AND ObjectBoolean_Default.ValueData = TRUE
                         
                               WHERE Object_StickerFile.DescId   = zc_Object_StickerFile()
                                 AND Object_StickerFile.isErased = FALSE
                                 AND ObjectLink_StickerFile_Juridical.ChildObjectId IS NULL -- !!!обязательно БЕЗ Покупателя!!!
                              )
                              
          , tmpGoods AS (SELECT Object_Goods.Id AS GoodsId 
                         FROM Object AS Object_Goods 
	                      INNER JOIN tmpIsErased on tmpIsErased.isErased= Object_Goods.isErased
                         WHERE Object_Goods.DescId = zc_Object_Goods()
                        )
                        
          , tmpSticker AS (SELECT Object_Sticker.Id                 AS Id
                                , Object_Sticker.ObjectCode         AS Code
                                , Object_Sticker.ValueData          AS Comment
                                
                                , Object_Juridical.Id               AS JuridicalId
                                , Object_Juridical.ObjectCode       AS JuridicalCode
                                , Object_Juridical.ValueData        AS JuridicalName 
                                , ObjectDesc.ItemName               AS ItemName
                    
                                , ObjectLink_Sticker_Goods.ChildObjectId AS GoodsId
                                                                
                                , Object_StickerGroup.Id            AS StickerGroupId
                                , Object_StickerGroup.ValueData     AS StickerGroupName 
                    
                                , Object_StickerType.Id             AS StickerTypeId
                                , Object_StickerType.ValueData      AS StickerTypeName
                    
                                , Object_StickerTag.Id              AS StickerTagId
                                , Object_StickerTag.ValueData       AS StickerTagName
                    
                                , Object_StickerSort.Id             AS StickerSortId
                                , Object_StickerSort.ValueData      AS StickerSortName
                                
                                , Object_StickerNorm.Id             AS StickerNormId
                                , Object_StickerNorm.ValueData      AS StickerNormName
                                
                                , Object_StickerFile.Id             AS StickerFileId
                                , Object_StickerFile.ValueData      AS StickerFileName
                                , Object_TradeMark_StickerFile.ValueData  AS TradeMarkName_StickerFile

                                , Object_StickerFile_70_70.Id             AS StickerFileId_70_70
                                , Object_StickerFile_70_70.ValueData      AS StickerFileName_70_70
                                , Object_TradeMark_StickerFile_70_70.ValueData  AS TradeMarkName_StickerFile_70_70
                                                  
                                , ObjectBlob_Info.ValueData         AS Info
                                                        
                                , ObjectFloat_Value1.ValueData      AS Value1
                                , ObjectFloat_Value2.ValueData      AS Value2
                                , ObjectFloat_Value3.ValueData      AS Value3
                                , ObjectFloat_Value4.ValueData      AS Value4
                                , ObjectFloat_Value5.ValueData      AS Value5

                                , ObjectFloat_Value6.ValueData      AS Value6
                                , ObjectFloat_Value7.ValueData      AS Value7
                                , ObjectFloat_Value8.ValueData      AS Value8

                                , Object_Sticker.isErased           AS isErased
                    
                           FROM (SELECT Object_Sticker.* 
                                 FROM Object AS Object_Sticker 
                    	         INNER JOIN tmpIsErased on tmpIsErased.isErased = Object_Sticker.isErased
                                 WHERE Object_Sticker.DescId = zc_Object_Sticker()
                                ) AS Object_Sticker
                                
                                 LEFT JOIN ObjectLink AS ObjectLink_Sticker_Juridical
                                                      ON ObjectLink_Sticker_Juridical.ObjectId = Object_Sticker.Id
                                                     AND ObjectLink_Sticker_Juridical.DescId = zc_ObjectLink_Sticker_Juridical()
                                 LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Sticker_Juridical.ChildObjectId
                                 LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Juridical.DescId
                    
                                 LEFT JOIN ObjectLink AS ObjectLink_Sticker_Goods
                                                      ON ObjectLink_Sticker_Goods.ObjectId = Object_Sticker.Id
                                                     AND ObjectLink_Sticker_Goods.DescId = zc_ObjectLink_Sticker_Goods()
                    
                                 LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerGroup
                                                      ON ObjectLink_Sticker_StickerGroup.ObjectId = Object_Sticker.Id
                                                     AND ObjectLink_Sticker_StickerGroup.DescId = zc_ObjectLink_Sticker_StickerGroup()
                                 LEFT JOIN Object AS Object_StickerGroup ON Object_StickerGroup.Id = ObjectLink_Sticker_StickerGroup.ChildObjectId
                    
                                 LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerType
                                                      ON ObjectLink_Sticker_StickerType.ObjectId = Object_Sticker.Id 
                                                     AND ObjectLink_Sticker_StickerType.DescId = zc_ObjectLink_Sticker_StickerType()
                                 LEFT JOIN Object AS Object_StickerType ON Object_StickerType.Id = ObjectLink_Sticker_StickerType.ChildObjectId
                    
                                 LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerTag
                                                      ON ObjectLink_Sticker_StickerTag.ObjectId = Object_Sticker.Id
                                                     AND ObjectLink_Sticker_StickerTag.DescId = zc_ObjectLink_Sticker_StickerTag()
                                 LEFT JOIN Object AS Object_StickerTag ON Object_StickerTag.Id = ObjectLink_Sticker_StickerTag.ChildObjectId
                    
                                 LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerSort
                                                      ON ObjectLink_Sticker_StickerSort.ObjectId = Object_Sticker.Id 
                                                     AND ObjectLink_Sticker_StickerSort.DescId = zc_ObjectLink_Sticker_StickerSort()
                                 LEFT JOIN Object AS Object_StickerSort ON Object_StickerSort.Id = ObjectLink_Sticker_StickerSort.ChildObjectId
                    
                                 LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerNorm
                                                      ON ObjectLink_Sticker_StickerNorm.ObjectId = Object_Sticker.Id 
                                                     AND ObjectLink_Sticker_StickerNorm.DescId = zc_ObjectLink_Sticker_StickerNorm()
                                 LEFT JOIN Object AS Object_StickerNorm ON Object_StickerNorm.Id = ObjectLink_Sticker_StickerNorm.ChildObjectId
                    
                                 LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerFile
                                                      ON ObjectLink_Sticker_StickerFile.ObjectId = Object_Sticker.Id 
                                                     AND ObjectLink_Sticker_StickerFile.DescId = zc_ObjectLink_Sticker_StickerFile()
                                 LEFT JOIN Object AS Object_StickerFile ON Object_StickerFile.Id = ObjectLink_Sticker_StickerFile.ChildObjectId 

                                 LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerFile_70_70
                                                      ON ObjectLink_Sticker_StickerFile_70_70.ObjectId = Object_Sticker.Id 
                                                     AND ObjectLink_Sticker_StickerFile.DescId = zc_ObjectLink_Sticker_StickerFile_70_70()
                                 LEFT JOIN Object AS Object_StickerFile_70_70 ON Object_StickerFile_70_70.Id = ObjectLink_Sticker_StickerFile_70_70.ChildObjectId
                    
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Value1
                                                       ON ObjectFloat_Value1.ObjectId = Object_Sticker.Id 
                                                      AND ObjectFloat_Value1.DescId = zc_ObjectFloat_Sticker_Value1()
                    
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Value2
                                                       ON ObjectFloat_Value2.ObjectId = Object_Sticker.Id 
                                                      AND ObjectFloat_Value2.DescId = zc_ObjectFloat_Sticker_Value2()
                    
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Value3
                                                       ON ObjectFloat_Value3.ObjectId = Object_Sticker.Id 
                                                      AND ObjectFloat_Value3.DescId = zc_ObjectFloat_Sticker_Value3()
                    
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Value4
                                                       ON ObjectFloat_Value4.ObjectId = Object_Sticker.Id 
                                                      AND ObjectFloat_Value4.DescId = zc_ObjectFloat_Sticker_Value4()
                    
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Value5
                                                       ON ObjectFloat_Value5.ObjectId = Object_Sticker.Id 
                                                      AND ObjectFloat_Value5.DescId = zc_ObjectFloat_Sticker_Value5()

                                 LEFT JOIN ObjectFloat AS ObjectFloat_Value6
                                                       ON ObjectFloat_Value6.ObjectId = Object_Sticker.Id 
                                                      AND ObjectFloat_Value6.DescId = zc_ObjectFloat_Sticker_Value6()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Value7
                                                       ON ObjectFloat_Value7.ObjectId = Object_Sticker.Id 
                                                      AND ObjectFloat_Value7.DescId = zc_ObjectFloat_Sticker_Value7()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Value8
                                                       ON ObjectFloat_Value8.ObjectId = Object_Sticker.Id 
                                                      AND ObjectFloat_Value8.DescId = zc_ObjectFloat_Sticker_Value8()

                                 LEFT JOIN ObjectBlob AS ObjectBlob_Info
                                                      ON ObjectBlob_Info.ObjectId = Object_Sticker.Id 
                                                     AND ObjectBlob_Info.DescId = zc_ObjectBlob_Sticker_Info()
                    
                                 LEFT JOIN ObjectLink AS ObjectLink_StickerFile_TradeMark
                                                      ON ObjectLink_StickerFile_TradeMark.ObjectId = Object_StickerFile.Id
                                                     AND ObjectLink_StickerFile_TradeMark.DescId = zc_ObjectLink_StickerFile_TradeMark()
                                 LEFT JOIN Object AS Object_TradeMark_StickerFile ON Object_TradeMark_StickerFile.Id = ObjectLink_StickerFile_TradeMark.ChildObjectId
                                 
                                 LEFT JOIN ObjectLink AS ObjectLink_StickerFile_TradeMark_70_70
                                                      ON ObjectLink_StickerFile_TradeMark_70_70.ObjectId = Object_StickerFile_70_70.Id
                                                     AND ObjectLink_StickerFile_TradeMark_70_70.DescId = zc_ObjectLink_StickerFile_TradeMark()
                                 LEFT JOIN Object AS Object_TradeMark_StickerFile_70_70 ON Object_TradeMark_StickerFile_70_70.Id = ObjectLink_StickerFile_TradeMark_70_70.ChildObjectId
                          )

          , tmpStickerProperty AS (SELECT Object_StickerProperty.Id          AS Id
                                        , Object_StickerProperty.ObjectCode  AS Code
                                        , Object_StickerProperty.ValueData   AS Comment
                            
                                        , ObjectLink_StickerProperty_Sticker.ChildObjectId AS StickerId
                            
                                        , Object_GoodsKind.Id                AS GoodsKindId
                                        , Object_GoodsKind.ValueData         AS GoodsKindName
                            
                                        , Object_StickerPack.Id              AS StickerPackId
                                        , Object_StickerPack.ValueData       AS StickerPackName
                            
                                        , Object_StickerFile.Id              AS StickerFileId
                                        , Object_StickerFile.ValueData       AS StickerFileName
                                        , Object_TradeMark_StickerFile.ValueData  AS TradeMarkName_StickerFile

                                        , Object_StickerFile_70_70.Id              AS StickerFileId_70_70
                                        , Object_StickerFile_70_70.ValueData       AS StickerFileName_70_70
                                        , Object_TradeMark_StickerFile_70_70.ValueData  AS TradeMarkName_StickerFile_70_70
                            
                                        , Object_StickerSkin.Id              AS StickerSkinId
                                        , Object_StickerSkin.ValueData       AS StickerSkinName
                            
                                        , ObjectString_BarCode.ValueData     AS BarCode
                                        , ObjectBoolean_Fix.ValueData        AS isFix
                                        , COALESCE (ObjectBoolean_CK.ValueData, FALSE) ::Boolean AS isCK
                                        , COALESCE (ObjectBoolean_NormInDays_not.ValueData, FALSE) ::Boolean AS isNormInDays_not
                            
                                        , ObjectFloat_Value1.ValueData       AS Value1
                                        , ObjectFloat_Value2.ValueData       AS Value2
                                        , ObjectFloat_Value3.ValueData       AS Value3
                                        , ObjectFloat_Value4.ValueData       AS Value4
                                        , ObjectFloat_Value5.ValueData       AS Value5
                                        , ObjectFloat_Value6.ValueData       AS Value6
                                        , ObjectFloat_Value7.ValueData       AS Value7
                                        , ObjectFloat_Value8.ValueData       AS Value8
                                        , ObjectFloat_Value9.ValueData       AS Value9
                                        , ObjectFloat_Value10.ValueData      AS Value10
                                        , ObjectFloat_Value11.ValueData      AS Value11

                                        , Object_StickerProperty.isErased    AS isErased
                            
                                   FROM (SELECT Object_StickerProperty.*
                                         FROM Object AS Object_StickerProperty
                            	         INNER JOIN tmpIsErased on tmpIsErased.isErased = Object_StickerProperty.isErased
                                         WHERE Object_StickerProperty.DescId = zc_Object_StickerProperty()
                                        ) AS Object_StickerProperty
                            
                                         LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_Sticker
                                                              ON ObjectLink_StickerProperty_Sticker.ObjectId = Object_StickerProperty.Id
                                                             AND ObjectLink_StickerProperty_Sticker.DescId = zc_ObjectLink_StickerProperty_Sticker()
                            
                                         LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_GoodsKind
                                                              ON ObjectLink_StickerProperty_GoodsKind.ObjectId = Object_StickerProperty.Id
                                                             AND ObjectLink_StickerProperty_GoodsKind.DescId = zc_ObjectLink_StickerProperty_GoodsKind()
                                         LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_StickerProperty_GoodsKind.ChildObjectId
                            
                                         LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerPack
                                                              ON ObjectLink_StickerProperty_StickerPack.ObjectId = Object_StickerProperty.Id
                                                             AND ObjectLink_StickerProperty_StickerPack.DescId = zc_ObjectLink_StickerProperty_StickerPack()
                                         LEFT JOIN Object AS Object_StickerPack ON Object_StickerPack.Id = ObjectLink_StickerProperty_StickerPack.ChildObjectId
                            
                                         LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerFile
                                                              ON ObjectLink_StickerProperty_StickerFile.ObjectId = Object_StickerProperty.Id
                                                             AND ObjectLink_StickerProperty_StickerFile.DescId = zc_ObjectLink_StickerProperty_StickerFile()
                                         LEFT JOIN Object AS Object_StickerFile ON Object_StickerFile.Id = ObjectLink_StickerProperty_StickerFile.ChildObjectId

                                         LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerFile_70_70
                                                              ON ObjectLink_StickerProperty_StickerFile_70_70.ObjectId = Object_StickerProperty.Id
                                                             AND ObjectLink_StickerProperty_StickerFile_70_70.DescId = zc_ObjectLink_StickerProperty_StickerFile_70_70()
                                         LEFT JOIN Object AS Object_StickerFile_70_70 ON Object_StickerFile_70_70.Id = ObjectLink_StickerProperty_StickerFile_70_70.ChildObjectId
                            
                                         LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerSkin
                                                              ON ObjectLink_StickerProperty_StickerSkin.ObjectId = Object_StickerProperty.Id
                                                             AND ObjectLink_StickerProperty_StickerSkin.DescId = zc_ObjectLink_StickerProperty_StickerSkin()
                                         LEFT JOIN Object AS Object_StickerSkin ON Object_StickerSkin.Id = ObjectLink_StickerProperty_StickerSkin.ChildObjectId
                            
                                         --  вологість мін
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Value1
                                                               ON ObjectFloat_Value1.ObjectId = Object_StickerProperty.Id
                                                              AND ObjectFloat_Value1.DescId = zc_ObjectFloat_StickerProperty_Value1()
                                         --  вологість макс
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Value2
                                                               ON ObjectFloat_Value2.ObjectId = Object_StickerProperty.Id
                                                              AND ObjectFloat_Value2.DescId = zc_ObjectFloat_StickerProperty_Value2()
                                         --  Т мін
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Value3
                                                               ON ObjectFloat_Value3.ObjectId = Object_StickerProperty.Id
                                                              AND ObjectFloat_Value3.DescId = zc_ObjectFloat_StickerProperty_Value3()
                                         --  Т макс
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Value4
                                                               ON ObjectFloat_Value4.ObjectId = Object_StickerProperty.Id
                                                              AND ObjectFloat_Value4.DescId = zc_ObjectFloat_StickerProperty_Value4()
                            
                                         -- кількість діб
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Value5
                                                               ON ObjectFloat_Value5.ObjectId = Object_StickerProperty.Id
                                                              AND ObjectFloat_Value5.DescId = zc_ObjectFloat_StickerProperty_Value5()
                                         -- вес
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Value6
                                                               ON ObjectFloat_Value6.ObjectId = Object_StickerProperty.Id
                                                              AND ObjectFloat_Value6.DescId = zc_ObjectFloat_StickerProperty_Value6()
                            
                                         -- % отклонения
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Value7
                                                               ON ObjectFloat_Value7.ObjectId = Object_StickerProperty.Id
                                                              AND ObjectFloat_Value7.DescId = zc_ObjectFloat_StickerProperty_Value7()
                                         --Т мін - второй срок
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Value8
                                                               ON ObjectFloat_Value8.ObjectId = Object_StickerProperty.Id
                                                              AND ObjectFloat_Value8.DescId = zc_ObjectFloat_StickerProperty_Value8()
                                         --Т макс - второй срок
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Value9
                                                               ON ObjectFloat_Value9.ObjectId = Object_StickerProperty.Id
                                                              AND ObjectFloat_Value9.DescId = zc_ObjectFloat_StickerProperty_Value9()
                                         -- кількість діб - второй срок
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Value10
                                                               ON ObjectFloat_Value10.ObjectId = Object_StickerProperty.Id
                                                              AND ObjectFloat_Value10.DescId = zc_ObjectFloat_StickerProperty_Value10()
                                         --вложенность
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Value11
                                                               ON ObjectFloat_Value11.ObjectId = Object_StickerProperty.Id
                                                              AND ObjectFloat_Value11.DescId = zc_ObjectFloat_StickerProperty_Value11()

                                         LEFT JOIN ObjectBoolean AS ObjectBoolean_Fix
                                                                 ON ObjectBoolean_Fix.ObjectId = Object_StickerProperty.Id
                                                                AND ObjectBoolean_Fix.DescId = zc_ObjectBoolean_StickerProperty_Fix()

                                         LEFT JOIN ObjectBoolean AS ObjectBoolean_CK
                                                                 ON ObjectBoolean_CK.ObjectId = Object_StickerProperty.Id
                                                                AND ObjectBoolean_CK.DescId = zc_ObjectBoolean_StickerProperty_CK()

                                         LEFT JOIN ObjectBoolean AS ObjectBoolean_NormInDays_not
                                                                 ON ObjectBoolean_NormInDays_not.ObjectId = Object_StickerProperty.Id
                                                                AND ObjectBoolean_NormInDays_not.DescId = zc_ObjectBoolean_StickerProperty_NormInDays_not()

                                         LEFT JOIN ObjectString AS ObjectString_BarCode
                                                                ON ObjectString_BarCode.ObjectId = Object_StickerProperty.Id
                                                               AND ObjectString_BarCode.DescId = zc_ObjectString_StickerProperty_BarCode()
                            
                                         LEFT JOIN ObjectLink AS ObjectLink_StickerFile_TradeMark
                                                              ON ObjectLink_StickerFile_TradeMark.ObjectId = Object_StickerFile.Id
                                                             AND ObjectLink_StickerFile_TradeMark.DescId = zc_ObjectLink_StickerFile_TradeMark()
                                         LEFT JOIN Object AS Object_TradeMark_StickerFile ON Object_TradeMark_StickerFile.Id = ObjectLink_StickerFile_TradeMark.ChildObjectId

                                         LEFT JOIN ObjectLink AS ObjectLink_StickerFile_TradeMark_70_70
                                                              ON ObjectLink_StickerFile_TradeMark_70_70.ObjectId = Object_StickerFile_70_70.Id
                                                             AND ObjectLink_StickerFile_TradeMark_70_70.DescId = zc_ObjectLink_StickerFile_TradeMark()
                                         LEFT JOIN Object AS Object_TradeMark_StickerFile_70_70 ON Object_TradeMark_StickerFile_70_70.Id = ObjectLink_StickerFile_TradeMark_70_70.ChildObjectId
                                   ) 
          , tmpGoodsByGoodsKind AS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ObjectId          AS GoodsByGoodsKindId
                                         , ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId     AS GoodsId
                                         , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId AS GoodsKindId
                                         , ObjectFloat_GK_NormInDays.ValueData                 AS NormInDays_gk
                                    FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                         JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                         ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                        AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                         LEFT JOIN ObjectBoolean AS ObjectBoolean_Order
                                                                 ON ObjectBoolean_Order.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                                AND ObjectBoolean_Order.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                                              --AND ObjectBoolean_Order.ValueData = TRUE
                                         INNER JOIN ObjectFloat AS ObjectFloat_GK_NormInDays
                                                                ON ObjectFloat_GK_NormInDays.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                               AND ObjectFloat_GK_NormInDays.DescId   = zc_ObjectFloat_GoodsByGoodsKind_NormInDays()
                                                               AND ObjectFloat_GK_NormInDays.ValueData <> 0
                                    WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                   )


       -- Результат
       SELECT COALESCE (Object_Sticker.Id, 0)       :: Integer   AS Id
            , COALESCE (Object_Sticker.Code, 0)     :: Integer   AS Code
            , COALESCE (Object_Sticker.Comment, '') :: TVarChar  AS Comment
            
            , COALESCE (Object_Sticker.JuridicalId, 0)     :: Integer  AS JuridicalId
            , COALESCE (Object_Sticker.JuridicalCode, 0)   :: Integer  AS JuridicalCode
            , COALESCE (Object_Sticker.JuridicalName, '')  :: TVarChar AS JuridicalName 
            , COALESCE (Object_Sticker.ItemName, '')       :: TVarChar AS ItemName

            , Object_Goods.Id                   AS GoodsId
            , Object_Goods.ObjectCode           AS GoodsCode
            , Object_Goods.ValueData            AS GoodsName
            , Object_TradeMark_Goods.ValueData  AS TradeMarkName_Goods
            
            , COALESCE (Object_Sticker.StickerGroupId, 0)    :: Integer   AS StickerGroupId
            , COALESCE (Object_Sticker.StickerGroupName, '') :: TVarChar  AS StickerGroupName 

            , COALESCE (Object_Sticker.StickerTypeId, 0)     :: Integer   AS StickerTypeId
            , COALESCE (Object_Sticker.StickerTypeName, '')  :: TVarChar  AS StickerTypeName

            , COALESCE (Object_Sticker.StickerTagId, 0)      :: Integer   AS StickerTagId
            , COALESCE (Object_Sticker.StickerTagName, '')   :: TVarChar  AS StickerTagName

            , COALESCE (Object_Sticker.StickerSortId, 0)     :: Integer   AS StickerSortId
            , COALESCE (Object_Sticker.StickerSortName, '')  :: TVarChar  AS StickerSortName
            
            , COALESCE (Object_Sticker.StickerNormId, 0)     :: Integer   AS StickerNormId
            , COALESCE (Object_Sticker.StickerNormName, '')  :: TVarChar  AS StickerNormName
            
            , COALESCE (Object_Sticker.StickerFileId, 0)     :: Integer   AS StickerFileId
            , COALESCE (Object_Sticker.StickerFileName, '')  :: TVarChar  AS StickerFileName
            , tmpStickerFile.Name                            :: TVarChar  AS StickerFileName_inf
            , COALESCE (Object_Sticker.TradeMarkName_StickerFile, '')  :: TVarChar  AS TradeMarkName_StickerFile

            , COALESCE (Object_Sticker.StickerFileId_70_70, 0)     :: Integer   AS StickerFileId_70_70
            , COALESCE (Object_Sticker.StickerFileName_70_70, '')  :: TVarChar  AS StickerFileName_70_70
            , COALESCE (Object_Sticker.TradeMarkName_StickerFile_70_70, '')  :: TVarChar  AS TradeMarkName_StickerFile_70_70
                              
            , COALESCE (Object_Sticker.Info, '')             :: TBlob     AS Info
                                    
            , COALESCE (Object_Sticker.Value1, 0)            :: TFloat    AS Value1
            , COALESCE (Object_Sticker.Value2, 0)            :: TFloat    AS Value2
            , COALESCE (Object_Sticker.Value3, 0)            :: TFloat    AS Value3
            , COALESCE (Object_Sticker.Value4, 0)            :: TFloat    AS Value4
            , COALESCE (Object_Sticker.Value5, 0)            :: TFloat    AS Value5
            , COALESCE (Object_Sticker.Value6, 0)            :: TFloat    AS Value6
            , COALESCE (Object_Sticker.Value7, 0)            :: TFloat    AS Value7
            , COALESCE (Object_Sticker.Value8, 0)            :: TFloat    AS Value8

            , COALESCE (Object_Sticker.isErased, FALSE) :: Boolean  AS isErased_Sticker

            , Object_StickerProperty.Id          AS StickerPropertyId
            , Object_StickerProperty.Code        AS StickerPropertyCode
            , Object_StickerProperty.Comment     AS Comment_SP

            , Object_StickerProperty.GoodsKindId
            , Object_StickerProperty.GoodsKindName
            , Object_StickerProperty.StickerPackId
            , Object_StickerProperty.StickerPackName
            , Object_StickerProperty.StickerFileId
            , Object_StickerProperty.StickerFileName
            , Object_StickerProperty.TradeMarkName_StickerFile AS TradeMarkName_StickerFile_SP
            
            , Object_StickerProperty.StickerFileId_70_70             AS StickerFileId_70_70_SP
            , Object_StickerProperty.StickerFileName_70_70           AS StickerFileName_70_70_SP
            , Object_StickerProperty.TradeMarkName_StickerFile_70_70 AS TradeMarkName_StickerFile_70_70_SP
            
            , Object_StickerProperty.StickerSkinId
            , Object_StickerProperty.StickerSkinName
            , Object_StickerProperty.BarCode
            , Object_StickerProperty.isFix
            , Object_StickerProperty.isCK 
            , Object_StickerProperty.isNormInDays_not 
            , Object_StickerProperty.Value1   AS Value1_SP
            , Object_StickerProperty.Value2   AS Value2_SP
            , Object_StickerProperty.Value3   AS Value3_SP
            , Object_StickerProperty.Value4   AS Value4_SP
              -- Кількість діб -> ***срок в днях
            , CASE WHEN tmpGoodsByGoodsKind.NormInDays_gk > 0 THEN tmpGoodsByGoodsKind.NormInDays_gk ELSE Object_StickerProperty.Value5 END :: TFloat AS Value5_SP
            , Object_StickerProperty.Value5               AS Value5_SP_orig
            , tmpGoodsByGoodsKind.NormInDays_gk :: TFloat AS NormInDays_gk
            , CASE WHEN COALESCE (tmpGoodsByGoodsKind.NormInDays_gk, 0) <> COALESCE (Object_StickerProperty.Value5, 0) THEN TRUE ELSE FALSE END :: Boolean AS isDiff_NormInDays_gk
              --
            , Object_StickerProperty.Value6   AS Value6_SP
            , Object_StickerProperty.Value7   AS Value7_SP
            , Object_StickerProperty.Value8   AS Value8_SP
            , Object_StickerProperty.Value9   AS Value9_SP
            , Object_StickerProperty.Value10  AS Value10_SP
            , Object_StickerProperty.Value11  AS Value11_SP
            , Object_StickerProperty.isErased AS isErased_SP

            , CASE WHEN Object_Sticker.isErased = TRUE OR Object_StickerProperty.isErased = TRUE THEN TRUE ELSE FALSE END :: Boolean AS isErased
            
       FROM tmpSticker AS Object_Sticker
             FULL JOIN tmpGoods ON tmpGoods.GoodsId = Object_Sticker.GoodsId

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (Object_Sticker.GoodsId, tmpGoods.GoodsId)

             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                  ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id 
                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
             LEFT JOIN Object AS Object_TradeMark_Goods ON Object_TradeMark_Goods.Id = ObjectLink_Goods_TradeMark.ChildObjectId

             LEFT JOIN tmpStickerFile ON tmpStickerFile.TradeMarkId = ObjectLink_Goods_TradeMark.ChildObjectId
             -- свойства этикетки
             LEFT JOIN tmpStickerProperty AS Object_StickerProperty ON Object_StickerProperty.StickerId = Object_Sticker.Id

             LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId     = Object_Goods.Id
                                          AND tmpGoodsByGoodsKind.GoodsKindId = Object_StickerProperty.GoodsKindId
             
      ;
    ELSE
     -- Результат
     RETURN QUERY 
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowErased AS isErased WHERE inShowErased = TRUE)
            -- Шаблоны "по умолчанию" - для конкретной ТМ
          , tmpStickerFile AS (SELECT Object_StickerFile.ValueData                    AS Name
                                    , ObjectLink_StickerFile_TradeMark.ChildObjectId  AS TradeMarkId
                               FROM Object AS Object_StickerFile
                                    LEFT JOIN ObjectLink AS ObjectLink_StickerFile_Juridical
                                                         ON ObjectLink_StickerFile_Juridical.ObjectId = Object_StickerFile.Id
                                                        AND ObjectLink_StickerFile_Juridical.DescId   = zc_ObjectLink_StickerFile_Juridical()
                                    INNER JOIN ObjectLink AS ObjectLink_StickerFile_TradeMark
                                                          ON ObjectLink_StickerFile_TradeMark.ObjectId = Object_StickerFile.Id
                                                         AND ObjectLink_StickerFile_TradeMark.DescId = zc_ObjectLink_StickerFile_TradeMark()
                                    
                                    INNER JOIN ObjectBoolean AS ObjectBoolean_Default
                                                             ON ObjectBoolean_Default.ObjectId  = Object_StickerFile.Id
                                                            AND ObjectBoolean_Default.DescId    = zc_ObjectBoolean_StickerFile_Default()
                                                            AND ObjectBoolean_Default.ValueData = TRUE
                         
                               WHERE Object_StickerFile.DescId   = zc_Object_StickerFile()
                                 AND Object_StickerFile.isErased = FALSE
                                 AND ObjectLink_StickerFile_Juridical.ChildObjectId IS NULL -- !!!обязательно БЕЗ Покупателя!!!
                              )
                              
          , tmpSticker AS (SELECT Object_Sticker.Id                 AS Id
                                , Object_Sticker.ObjectCode         AS Code
                                , Object_Sticker.ValueData          AS Comment
                                
                                , Object_Juridical.Id               AS JuridicalId
                                , Object_Juridical.ObjectCode       AS JuridicalCode
                                , Object_Juridical.ValueData        AS JuridicalName 
                                , ObjectDesc.ItemName               AS ItemName
                    
                                , Object_Goods.Id                   AS GoodsId
                                , Object_Goods.ObjectCode           AS GoodsCode
                                , Object_Goods.ValueData            AS GoodsName
                                , Object_TradeMark_Goods.ValueData  AS TradeMarkName_Goods
                                
                                , Object_StickerGroup.Id            AS StickerGroupId
                                , Object_StickerGroup.ValueData     AS StickerGroupName 
                    
                                , Object_StickerType.Id             AS StickerTypeId
                                , Object_StickerType.ValueData      AS StickerTypeName
                    
                                , Object_StickerTag.Id              AS StickerTagId
                                , Object_StickerTag.ValueData       AS StickerTagName
                    
                                , Object_StickerSort.Id             AS StickerSortId
                                , Object_StickerSort.ValueData      AS StickerSortName
                                
                                , Object_StickerNorm.Id             AS StickerNormId
                                , Object_StickerNorm.ValueData      AS StickerNormName
                                
                                , Object_StickerFile.Id             AS StickerFileId
                                , Object_StickerFile.ValueData      AS StickerFileName
                                , tmpStickerFile.Name               AS StickerFileName_inf
                                , Object_TradeMark_StickerFile.ValueData  AS TradeMarkName_StickerFile
                                                  
                                , Object_StickerFile_70_70.Id        AS StickerFileId_70_70
                                , Object_StickerFile_70_70.ValueData AS StickerFileName_70_70
                                , Object_TradeMark_StickerFile_70_70.ValueData AS TradeMarkName_StickerFile_70_70

                                , ObjectBlob_Info.ValueData         AS Info
                                                        
                                , ObjectFloat_Value1.ValueData      AS Value1
                                , ObjectFloat_Value2.ValueData      AS Value2
                                , ObjectFloat_Value3.ValueData      AS Value3
                                , ObjectFloat_Value4.ValueData      AS Value4
                                , ObjectFloat_Value5.ValueData      AS Value5

                                , ObjectFloat_Value6.ValueData      AS Value6
                                , ObjectFloat_Value7.ValueData      AS Value7
                                , ObjectFloat_Value8.ValueData      AS Value8

                                , Object_Sticker.isErased           AS isErased
                    
                           FROM (SELECT Object_Sticker.* 
                                 FROM Object AS Object_Sticker 
                    	         INNER JOIN tmpIsErased on tmpIsErased.isErased = Object_Sticker.isErased
                                 WHERE Object_Sticker.DescId = zc_Object_Sticker()
                                ) AS Object_Sticker
                                
                                 LEFT JOIN ObjectLink AS ObjectLink_Sticker_Juridical
                                                      ON ObjectLink_Sticker_Juridical.ObjectId = Object_Sticker.Id
                                                     AND ObjectLink_Sticker_Juridical.DescId = zc_ObjectLink_Sticker_Juridical()
                                 LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Sticker_Juridical.ChildObjectId
                                 LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Juridical.DescId
                    
                                 LEFT JOIN ObjectLink AS ObjectLink_Sticker_Goods
                                                      ON ObjectLink_Sticker_Goods.ObjectId = Object_Sticker.Id
                                                     AND ObjectLink_Sticker_Goods.DescId = zc_ObjectLink_Sticker_Goods()
                                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Sticker_Goods.ChildObjectId
                    
                                 LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerGroup
                                                      ON ObjectLink_Sticker_StickerGroup.ObjectId = Object_Sticker.Id
                                                     AND ObjectLink_Sticker_StickerGroup.DescId = zc_ObjectLink_Sticker_StickerGroup()
                                 LEFT JOIN Object AS Object_StickerGroup ON Object_StickerGroup.Id = ObjectLink_Sticker_StickerGroup.ChildObjectId
                    
                                 LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerType
                                                      ON ObjectLink_Sticker_StickerType.ObjectId = Object_Sticker.Id 
                                                     AND ObjectLink_Sticker_StickerType.DescId = zc_ObjectLink_Sticker_StickerType()
                                 LEFT JOIN Object AS Object_StickerType ON Object_StickerType.Id = ObjectLink_Sticker_StickerType.ChildObjectId
                    
                                 LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerTag
                                                      ON ObjectLink_Sticker_StickerTag.ObjectId = Object_Sticker.Id
                                                     AND ObjectLink_Sticker_StickerTag.DescId = zc_ObjectLink_Sticker_StickerTag()
                                 LEFT JOIN Object AS Object_StickerTag ON Object_StickerTag.Id = ObjectLink_Sticker_StickerTag.ChildObjectId
                    
                                 LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerSort
                                                      ON ObjectLink_Sticker_StickerSort.ObjectId = Object_Sticker.Id 
                                                     AND ObjectLink_Sticker_StickerSort.DescId = zc_ObjectLink_Sticker_StickerSort()
                                 LEFT JOIN Object AS Object_StickerSort ON Object_StickerSort.Id = ObjectLink_Sticker_StickerSort.ChildObjectId
                    
                                 LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerNorm
                                                      ON ObjectLink_Sticker_StickerNorm.ObjectId = Object_Sticker.Id 
                                                     AND ObjectLink_Sticker_StickerNorm.DescId = zc_ObjectLink_Sticker_StickerNorm()
                                 LEFT JOIN Object AS Object_StickerNorm ON Object_StickerNorm.Id = ObjectLink_Sticker_StickerNorm.ChildObjectId
                    
                                 LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerFile
                                                      ON ObjectLink_Sticker_StickerFile.ObjectId = Object_Sticker.Id 
                                                     AND ObjectLink_Sticker_StickerFile.DescId = zc_ObjectLink_Sticker_StickerFile()
                                 LEFT JOIN Object AS Object_StickerFile ON Object_StickerFile.Id = ObjectLink_Sticker_StickerFile.ChildObjectId 
                    
                                 LEFT JOIN ObjectLink AS ObjectLink_Sticker_StickerFile_70_70
                                                      ON ObjectLink_Sticker_StickerFile_70_70.ObjectId = Object_Sticker.Id
                                                     AND ObjectLink_Sticker_StickerFile_70_70.DescId = zc_ObjectLink_Sticker_StickerFile_70_70()
                                 LEFT JOIN Object AS Object_StickerFile_70_70 ON Object_StickerFile_70_70.Id = ObjectLink_Sticker_StickerFile_70_70.ChildObjectId

                                 LEFT JOIN ObjectFloat AS ObjectFloat_Value1
                                                       ON ObjectFloat_Value1.ObjectId = Object_Sticker.Id 
                                                      AND ObjectFloat_Value1.DescId = zc_ObjectFloat_Sticker_Value1()
                    
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Value2
                                                       ON ObjectFloat_Value2.ObjectId = Object_Sticker.Id 
                                                      AND ObjectFloat_Value2.DescId = zc_ObjectFloat_Sticker_Value2()
                    
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Value3
                                                       ON ObjectFloat_Value3.ObjectId = Object_Sticker.Id 
                                                      AND ObjectFloat_Value3.DescId = zc_ObjectFloat_Sticker_Value3()
                    
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Value4
                                                       ON ObjectFloat_Value4.ObjectId = Object_Sticker.Id 
                                                      AND ObjectFloat_Value4.DescId = zc_ObjectFloat_Sticker_Value4()
                    
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Value5
                                                       ON ObjectFloat_Value5.ObjectId = Object_Sticker.Id 
                                                      AND ObjectFloat_Value5.DescId = zc_ObjectFloat_Sticker_Value5()

                                 LEFT JOIN ObjectFloat AS ObjectFloat_Value6
                                                       ON ObjectFloat_Value6.ObjectId = Object_Sticker.Id 
                                                      AND ObjectFloat_Value6.DescId = zc_ObjectFloat_Sticker_Value6()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Value7
                                                       ON ObjectFloat_Value7.ObjectId = Object_Sticker.Id 
                                                      AND ObjectFloat_Value7.DescId = zc_ObjectFloat_Sticker_Value7()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Value8
                                                       ON ObjectFloat_Value8.ObjectId = Object_Sticker.Id 
                                                      AND ObjectFloat_Value8.DescId = zc_ObjectFloat_Sticker_Value8()

                                 LEFT JOIN ObjectBlob AS ObjectBlob_Info
                                                      ON ObjectBlob_Info.ObjectId = Object_Sticker.Id 
                                                     AND ObjectBlob_Info.DescId = zc_ObjectBlob_Sticker_Info()
                    
                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                                      ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id 
                                                     AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                                 LEFT JOIN Object AS Object_TradeMark_Goods ON Object_TradeMark_Goods.Id = ObjectLink_Goods_TradeMark.ChildObjectId
                    
                                 LEFT JOIN ObjectLink AS ObjectLink_StickerFile_TradeMark
                                                      ON ObjectLink_StickerFile_TradeMark.ObjectId = Object_StickerFile.Id
                                                     AND ObjectLink_StickerFile_TradeMark.DescId = zc_ObjectLink_StickerFile_TradeMark()
                                 LEFT JOIN Object AS Object_TradeMark_StickerFile ON Object_TradeMark_StickerFile.Id = ObjectLink_StickerFile_TradeMark.ChildObjectId
 
                                 LEFT JOIN ObjectLink AS ObjectLink_StickerFile_TradeMark_70_70
                                                      ON ObjectLink_StickerFile_TradeMark_70_70.ObjectId = Object_StickerFile_70_70.Id
                                                     AND ObjectLink_StickerFile_TradeMark_70_70.DescId = zc_ObjectLink_StickerFile_TradeMark()
                                 LEFT JOIN Object AS Object_TradeMark_StickerFile_70_70 ON Object_TradeMark_StickerFile_70_70.Id = ObjectLink_StickerFile_TradeMark_70_70.ChildObjectId
                               
                                 LEFT JOIN tmpStickerFile ON tmpStickerFile.TradeMarkId = ObjectLink_Goods_TradeMark.ChildObjectId
                                 )
                                 
          , tmpStickerProperty AS (SELECT Object_StickerProperty.Id          AS Id
                                        , Object_StickerProperty.ObjectCode  AS Code
                                        , Object_StickerProperty.ValueData   AS Comment
                            
                                        , ObjectLink_StickerProperty_Sticker.ChildObjectId AS StickerId
                            
                                        , Object_GoodsKind.Id                AS GoodsKindId
                                        , Object_GoodsKind.ValueData         AS GoodsKindName
                            
                                        , Object_StickerPack.Id              AS StickerPackId
                                        , Object_StickerPack.ValueData       AS StickerPackName
                            
                                        , Object_StickerFile.Id              AS StickerFileId
                                        , Object_StickerFile.ValueData       AS StickerFileName
                                        , Object_TradeMark_StickerFile.ValueData  AS TradeMarkName_StickerFile

                                        , Object_StickerFile_70_70.Id              AS StickerFileId_70_70
                                        , Object_StickerFile_70_70.ValueData       AS StickerFileName_70_70
                                        , Object_TradeMark_StickerFile_70_70.ValueData  AS TradeMarkName_StickerFile_70_70
                            
                                        , Object_StickerSkin.Id              AS StickerSkinId
                                        , Object_StickerSkin.ValueData       AS StickerSkinName
                            
                                        , ObjectString_BarCode.ValueData     AS BarCode
                                        , ObjectBoolean_Fix.ValueData        AS isFix
                                        , COALESCE (ObjectBoolean_CK.ValueData, FALSE) ::Boolean AS isCK
                                        , COALESCE (ObjectBoolean_NormInDays_not.ValueData, FALSE) ::Boolean AS isNormInDays_not
                            
                                        , ObjectFloat_Value1.ValueData       AS Value1
                                        , ObjectFloat_Value2.ValueData       AS Value2
                                        , ObjectFloat_Value3.ValueData       AS Value3
                                        , ObjectFloat_Value4.ValueData       AS Value4
                                        , ObjectFloat_Value5.ValueData       AS Value5
                                        , ObjectFloat_Value6.ValueData       AS Value6
                                        , ObjectFloat_Value7.ValueData       AS Value7
                                        , ObjectFloat_Value8.ValueData       AS Value8
                                        , ObjectFloat_Value9.ValueData       AS Value9
                                        , ObjectFloat_Value10.ValueData      AS Value10
                                        , ObjectFloat_Value11.ValueData      AS Value11
                            
                                        , Object_StickerProperty.isErased    AS isErased
                            
                                   FROM (SELECT Object_StickerProperty.*
                                         FROM Object AS Object_StickerProperty
                            	         INNER JOIN tmpIsErased on tmpIsErased.isErased = Object_StickerProperty.isErased
                                         WHERE Object_StickerProperty.DescId = zc_Object_StickerProperty()
                                        ) AS Object_StickerProperty
                            
                                         LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_Sticker
                                                              ON ObjectLink_StickerProperty_Sticker.ObjectId = Object_StickerProperty.Id
                                                             AND ObjectLink_StickerProperty_Sticker.DescId = zc_ObjectLink_StickerProperty_Sticker()
                            
                                         LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_GoodsKind
                                                              ON ObjectLink_StickerProperty_GoodsKind.ObjectId = Object_StickerProperty.Id
                                                             AND ObjectLink_StickerProperty_GoodsKind.DescId = zc_ObjectLink_StickerProperty_GoodsKind()
                                         LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_StickerProperty_GoodsKind.ChildObjectId
                            
                                         LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerPack
                                                              ON ObjectLink_StickerProperty_StickerPack.ObjectId = Object_StickerProperty.Id
                                                             AND ObjectLink_StickerProperty_StickerPack.DescId = zc_ObjectLink_StickerProperty_StickerPack()
                                         LEFT JOIN Object AS Object_StickerPack ON Object_StickerPack.Id = ObjectLink_StickerProperty_StickerPack.ChildObjectId
                            
                                         LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerFile
                                                              ON ObjectLink_StickerProperty_StickerFile.ObjectId = Object_StickerProperty.Id
                                                             AND ObjectLink_StickerProperty_StickerFile.DescId = zc_ObjectLink_StickerProperty_StickerFile()
                                         LEFT JOIN Object AS Object_StickerFile ON Object_StickerFile.Id = ObjectLink_StickerProperty_StickerFile.ChildObjectId

                                         LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerFile_70_70
                                                              ON ObjectLink_StickerProperty_StickerFile_70_70.ObjectId = Object_StickerProperty.Id
                                                             AND ObjectLink_StickerProperty_StickerFile_70_70.DescId = zc_ObjectLink_StickerProperty_StickerFile_70_70()
                                         LEFT JOIN Object AS Object_StickerFile_70_70 ON Object_StickerFile_70_70.Id = ObjectLink_StickerProperty_StickerFile_70_70.ChildObjectId
                            
                           
                                         LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_StickerSkin
                                                              ON ObjectLink_StickerProperty_StickerSkin.ObjectId = Object_StickerProperty.Id
                                                             AND ObjectLink_StickerProperty_StickerSkin.DescId = zc_ObjectLink_StickerProperty_StickerSkin()
                                         LEFT JOIN Object AS Object_StickerSkin ON Object_StickerSkin.Id = ObjectLink_StickerProperty_StickerSkin.ChildObjectId
                            
                                         --  вологість мін
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Value1
                                                               ON ObjectFloat_Value1.ObjectId = Object_StickerProperty.Id
                                                              AND ObjectFloat_Value1.DescId = zc_ObjectFloat_StickerProperty_Value1()
                                         --  вологість макс
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Value2
                                                               ON ObjectFloat_Value2.ObjectId = Object_StickerProperty.Id
                                                              AND ObjectFloat_Value2.DescId = zc_ObjectFloat_StickerProperty_Value2()
                                         --  Т мін
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Value3
                                                               ON ObjectFloat_Value3.ObjectId = Object_StickerProperty.Id
                                                              AND ObjectFloat_Value3.DescId = zc_ObjectFloat_StickerProperty_Value3()
                                         --  Т макс
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Value4
                                                               ON ObjectFloat_Value4.ObjectId = Object_StickerProperty.Id
                                                              AND ObjectFloat_Value4.DescId = zc_ObjectFloat_StickerProperty_Value4()
                            
                                         -- кількість діб
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Value5
                                                               ON ObjectFloat_Value5.ObjectId = Object_StickerProperty.Id
                                                              AND ObjectFloat_Value5.DescId = zc_ObjectFloat_StickerProperty_Value5()
                                         -- вес
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Value6
                                                               ON ObjectFloat_Value6.ObjectId = Object_StickerProperty.Id
                                                              AND ObjectFloat_Value6.DescId = zc_ObjectFloat_StickerProperty_Value6()
                            
                                         -- % отклонения
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Value7
                                                               ON ObjectFloat_Value7.ObjectId = Object_StickerProperty.Id
                                                              AND ObjectFloat_Value7.DescId = zc_ObjectFloat_StickerProperty_Value7()
                                         -- Т мін - второй срок
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Value8
                                                               ON ObjectFloat_Value8.ObjectId = Object_StickerProperty.Id
                                                              AND ObjectFloat_Value8.DescId = zc_ObjectFloat_StickerProperty_Value8()
                                         -- Т макс - второй срок
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Value9
                                                               ON ObjectFloat_Value9.ObjectId = Object_StickerProperty.Id
                                                              AND ObjectFloat_Value9.DescId = zc_ObjectFloat_StickerProperty_Value9()
                                         -- кількість діб - второй срок
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Value10
                                                               ON ObjectFloat_Value10.ObjectId = Object_StickerProperty.Id
                                                              AND ObjectFloat_Value10.DescId = zc_ObjectFloat_StickerProperty_Value10()
                                         -- вложенность
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Value11
                                                               ON ObjectFloat_Value11.ObjectId = Object_StickerProperty.Id
                                                              AND ObjectFloat_Value11.DescId = zc_ObjectFloat_StickerProperty_Value11()
                                                              
                                         LEFT JOIN ObjectBoolean AS ObjectBoolean_Fix
                                                                 ON ObjectBoolean_Fix.ObjectId = Object_StickerProperty.Id
                                                                AND ObjectBoolean_Fix.DescId = zc_ObjectBoolean_StickerProperty_Fix()

                                         LEFT JOIN ObjectBoolean AS ObjectBoolean_CK
                                                                 ON ObjectBoolean_CK.ObjectId = Object_StickerProperty.Id
                                                                AND ObjectBoolean_CK.DescId = zc_ObjectBoolean_StickerProperty_CK()

                                         LEFT JOIN ObjectBoolean AS ObjectBoolean_NormInDays_not
                                                                 ON ObjectBoolean_NormInDays_not.ObjectId = Object_StickerProperty.Id
                                                                AND ObjectBoolean_NormInDays_not.DescId = zc_ObjectBoolean_StickerProperty_NormInDays_not()

                                         LEFT JOIN ObjectString AS ObjectString_BarCode
                                                                ON ObjectString_BarCode.ObjectId = Object_StickerProperty.Id
                                                               AND ObjectString_BarCode.DescId = zc_ObjectString_StickerProperty_BarCode()
                            
                                         LEFT JOIN ObjectLink AS ObjectLink_StickerFile_TradeMark
                                                              ON ObjectLink_StickerFile_TradeMark.ObjectId = Object_StickerFile.Id
                                                             AND ObjectLink_StickerFile_TradeMark.DescId = zc_ObjectLink_StickerFile_TradeMark()
                                         LEFT JOIN Object AS Object_TradeMark_StickerFile ON Object_TradeMark_StickerFile.Id = ObjectLink_StickerFile_TradeMark.ChildObjectId

                                         LEFT JOIN ObjectLink AS ObjectLink_StickerFile_TradeMark_70_70
                                                              ON ObjectLink_StickerFile_TradeMark_70_70.ObjectId = Object_StickerFile_70_70.Id
                                                             AND ObjectLink_StickerFile_TradeMark_70_70.DescId = zc_ObjectLink_StickerFile_TradeMark()
                                         LEFT JOIN Object AS Object_TradeMark_StickerFile_70_70 ON Object_TradeMark_StickerFile_70_70.Id = ObjectLink_StickerFile_TradeMark_70_70.ChildObjectId

                                   )                    
          , tmpGoodsByGoodsKind AS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ObjectId          AS GoodsByGoodsKindId
                                         , ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId     AS GoodsId
                                         , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId AS GoodsKindId
                                         , ObjectFloat_GK_NormInDays.ValueData                 AS NormInDays_gk
                                    FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                         JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                         ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                        AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                         LEFT JOIN ObjectBoolean AS ObjectBoolean_Order
                                                                 ON ObjectBoolean_Order.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                                AND ObjectBoolean_Order.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                                              --AND ObjectBoolean_Order.ValueData = TRUE
                                         INNER JOIN ObjectFloat AS ObjectFloat_GK_NormInDays
                                                                ON ObjectFloat_GK_NormInDays.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                               AND ObjectFloat_GK_NormInDays.DescId   = zc_ObjectFloat_GoodsByGoodsKind_NormInDays()
                                                               AND ObjectFloat_GK_NormInDays.ValueData <> 0
                                    WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                   )
       -- Результат
       SELECT Object_Sticker.Id
            , Object_Sticker.Code
            , Object_Sticker.Comment
            , Object_Sticker.JuridicalId
            , Object_Sticker.JuridicalCode
            , Object_Sticker.JuridicalName 
            , Object_Sticker.ItemName
            , Object_Sticker.GoodsId
            , Object_Sticker.GoodsCode
            , Object_Sticker.GoodsName
            , Object_Sticker.TradeMarkName_Goods
            , Object_Sticker.StickerGroupId
            , Object_Sticker.StickerGroupName 
            , Object_Sticker.StickerTypeId
            , Object_Sticker.StickerTypeName
            , Object_Sticker.StickerTagId
            , Object_Sticker.StickerTagName
            , Object_Sticker.StickerSortId
            , Object_Sticker.StickerSortName
            , Object_Sticker.StickerNormId
            , Object_Sticker.StickerNormName
            , Object_Sticker.StickerFileId
            , Object_Sticker.StickerFileName
            , Object_Sticker.StickerFileName_inf
            , Object_Sticker.TradeMarkName_StickerFile  
            , Object_Sticker.StickerFileId_70_70
            , Object_Sticker.StickerFileName_70_70
            , Object_Sticker.TradeMarkName_StickerFile_70_70
            
            , Object_Sticker.Info
            , Object_Sticker.Value1
            , Object_Sticker.Value2
            , Object_Sticker.Value3
            , Object_Sticker.Value4
            , Object_Sticker.Value5
            , Object_Sticker.Value6
            , Object_Sticker.Value7
            , Object_Sticker.Value8
            , Object_Sticker.isErased  AS isErased_Sticker
            
            , Object_StickerProperty.Id          AS StickerPropertyId
            , Object_StickerProperty.Code        AS StickerPropertyCode
            , Object_StickerProperty.Comment     AS Comment_SP

            , Object_StickerProperty.GoodsKindId
            , Object_StickerProperty.GoodsKindName
            , Object_StickerProperty.StickerPackId
            , Object_StickerProperty.StickerPackName
            , Object_StickerProperty.StickerFileId
            , Object_StickerProperty.StickerFileName
            , Object_StickerProperty.TradeMarkName_StickerFile AS TradeMarkName_StickerFile_SP 
            , Object_StickerProperty.StickerFileId_70_70             AS StickerFileId_70_70_SP
            , Object_StickerProperty.StickerFileName_70_70           AS StickerFileName_70_70_SP
            , Object_StickerProperty.TradeMarkName_StickerFile_70_70 AS TradeMarkName_StickerFile_70_70_SP
            
            , Object_StickerProperty.StickerSkinId
            , Object_StickerProperty.StickerSkinName
            , Object_StickerProperty.BarCode
            , Object_StickerProperty.isFix
            , Object_StickerProperty.isCK
            , Object_StickerProperty.isNormInDays_not
            , Object_StickerProperty.Value1   AS Value1_SP
            , Object_StickerProperty.Value2   AS Value2_SP
            , Object_StickerProperty.Value3   AS Value3_SP
            , Object_StickerProperty.Value4   AS Value4_SP
              -- Кількість діб -> ***срок в днях
            , CASE WHEN tmpGoodsByGoodsKind.NormInDays_gk > 0 THEN tmpGoodsByGoodsKind.NormInDays_gk ELSE Object_StickerProperty.Value5 END :: TFloat AS Value5_SP
            , Object_StickerProperty.Value5               AS Value5_SP_orig
            , tmpGoodsByGoodsKind.NormInDays_gk :: TFloat AS NormInDays_gk
            , CASE WHEN COALESCE (tmpGoodsByGoodsKind.NormInDays_gk, 0) <> COALESCE (Object_StickerProperty.Value5, 0) THEN TRUE ELSE FALSE END :: Boolean AS isDiff_NormInDays_gk
              --
            , Object_StickerProperty.Value6   AS Value6_SP
            , Object_StickerProperty.Value7   AS Value7_SP
            , Object_StickerProperty.Value8   AS Value8_SP
            , Object_StickerProperty.Value9   AS Value9_SP
            , Object_StickerProperty.Value10  AS Value10_SP
            , Object_StickerProperty.Value11  AS Value11_SP
            , Object_StickerProperty.isErased AS isErased_SP

            , CASE WHEN Object_Sticker.isErased = TRUE OR Object_StickerProperty.isErased = TRUE THEN TRUE ELSE FALSE END :: Boolean AS isErased

       FROM tmpSticker AS Object_Sticker
           LEFT JOIN tmpStickerProperty AS Object_StickerProperty ON Object_StickerProperty.StickerId = Object_Sticker.Id
           LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId     = Object_Sticker.GoodsId
                                        AND tmpGoodsByGoodsKind.GoodsKindId = Object_StickerProperty.GoodsKindId
     ;
    END IF;
  
END;

$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.06.24         * isNormInDays_not
 01.09.23         *
 26.04.21         * isCK
 14.02.20         *
 20.12.17         *
*/

-- тест
--SELECT * FROM gpSelect_Object_Sticker_List (inShowErased:=FALSE, inShowAll:=FALSE, inSession := zfCalc_UserAdmin())
--select * from gpSelect_Object_Sticker_List(inShowErased := 'False' , inShowAll := 'False' ,  inSession := '5');