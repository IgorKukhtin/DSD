-- Function: gpSelect_Object_Goods()

DROP FUNCTION IF EXISTS gpSelect_Object_Sticker (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Sticker (Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Sticker(
    IN inShowErased  Boolean,
    IN inShowAll     Boolean,   
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Comment TVarChar -- , StickerName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar, ItemName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, TradeMarkName_Goods TVarChar
             , StickerGroupId Integer, StickerGroupName TVarChar
             , StickerTypeId Integer, StickerTypeName TVarChar
             , StickerTagId Integer, StickerTagName TVarChar
             , StickerSortId Integer, StickerSortName TVarChar
             , StickerNormId Integer, StickerNormName TVarChar
             , StickerFileId Integer, StickerFileName TVarChar, StickerFileName_inf TVarChar, TradeMarkName_StickerFile TVarChar
             , Info TBlob
             , Value1 TFloat, Value2 TFloat, Value3 TFloat, Value4 TFloat, Value5 TFloat
             , isErased Boolean
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
                                                  
                                , ObjectBlob_Info.ValueData         AS Info
                                                        
                                , ObjectFloat_Value1.ValueData      AS Value1
                                , ObjectFloat_Value2.ValueData      AS Value2
                                , ObjectFloat_Value3.ValueData      AS Value3
                                , ObjectFloat_Value4.ValueData      AS Value4
                                , ObjectFloat_Value5.ValueData      AS Value5
                    
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
                                 --LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Sticker_Goods.ChildObjectId
                    
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
                                 
                                 LEFT JOIN ObjectBlob AS ObjectBlob_Info
                                                      ON ObjectBlob_Info.ObjectId = Object_Sticker.Id 
                                                     AND ObjectBlob_Info.DescId = zc_ObjectBlob_Sticker_Info()
                    
                                 LEFT JOIN ObjectLink AS ObjectLink_StickerFile_TradeMark
                                                      ON ObjectLink_StickerFile_TradeMark.ObjectId = Object_StickerFile.Id
                                                     AND ObjectLink_StickerFile_TradeMark.DescId = zc_ObjectLink_StickerFile_TradeMark()
                                 LEFT JOIN Object AS Object_TradeMark_StickerFile ON Object_TradeMark_StickerFile.Id = ObjectLink_StickerFile_TradeMark.ChildObjectId
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
                              
            , COALESCE (Object_Sticker.Info, '')             :: TBlob     AS Info
                                    
            , COALESCE (Object_Sticker.Value1, 0)            :: TFloat    AS Value1
            , COALESCE (Object_Sticker.Value2, 0)            :: TFloat    AS Value2
            , COALESCE (Object_Sticker.Value3, 0)            :: TFloat    AS Value3
            , COALESCE (Object_Sticker.Value4, 0)            :: TFloat    AS Value4
            , COALESCE (Object_Sticker.Value5, 0)            :: TFloat    AS Value5

            , COALESCE (Object_Sticker.isErased, FALSE) :: Boolean           AS isErased

       FROM tmpSticker AS Object_Sticker
             FULL JOIN tmpGoods ON tmpGoods.GoodsId = Object_Sticker.GoodsId

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (Object_Sticker.GoodsId, tmpGoods.GoodsId)

             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                  ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id 
                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
             LEFT JOIN Object AS Object_TradeMark_Goods ON Object_TradeMark_Goods.Id = ObjectLink_Goods_TradeMark.ChildObjectId

             LEFT JOIN tmpStickerFile ON tmpStickerFile.TradeMarkId = ObjectLink_Goods_TradeMark.ChildObjectId
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

       -- Результат
       SELECT Object_Sticker.Id                 AS Id
            , Object_Sticker.ObjectCode         AS Code
            , Object_Sticker.ValueData          AS Comment
            -- , (Object_Juridical.ValueData||' / '||Object_Goods.ValueData||' / '||Object_Sticker.ValueData) ::TVarChar AS StickerName
            
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
                              
            , ObjectBlob_Info.ValueData         AS Info
                                    
            , ObjectFloat_Value1.ValueData      AS Value1
            , ObjectFloat_Value2.ValueData      AS Value2
            , ObjectFloat_Value3.ValueData      AS Value3
            , ObjectFloat_Value4.ValueData      AS Value4
            , ObjectFloat_Value5.ValueData      AS Value5

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
            
             LEFT JOIN tmpStickerFile ON tmpStickerFile.TradeMarkId = ObjectLink_Goods_TradeMark.ChildObjectId
      ;
    END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 23.10.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Sticker (inShowErased:=FALSE, inShowAll:=TRUE, inSession := zfCalc_UserAdmin())
