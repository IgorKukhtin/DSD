-- Function: gpSelect_MovementItem_SaleExternal()

 DROP FUNCTION IF EXISTS gpSelect_MovementItem_SaleExternal (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SaleExternal(
    IN inMovementId  Integer      , -- ключ Документа
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar             
             , Amount TFloat, Amount_kg TFloat
             , GoodsKindId Integer, GoodsKindName  TVarChar, MeasureName TVarChar
             , GoodsName_Juridical TVarChar
             , AmountInPack_Juridical TFloat
             , Article_Juridical TVarChar
             , BarCode_Juridical TVarChar
             , ArticleGLN_Juridical TVarChar
             , BarCodeGLN_Juridical TVarChar
             , NameExternal_Juridical TVarChar
           
             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbGoodsPropertyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_SaleExternal());
     vbUserId:= lpGetUserBySession (inSession);

     vbGoodsPropertyId := (SELECT MovementLinkObject_GoodsProperty.ObjectId AS GoodsPropertyId
                           FROM MovementLinkObject AS MovementLinkObject_GoodsProperty
                           WHERE MovementLinkObject_GoodsProperty.MovementId = inMovementId
                             AND MovementLinkObject_GoodsProperty.DescId = zc_MovementLinkObject_GoodsProperty()
                           );

     RETURN QUERY
       WITH 
           tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                          , MovementItem.Amount                           AS Amount
                          , MovementItem.ObjectId                         AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                          , MovementItem.isErased                         AS isErased
                     FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                          INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                 AND MovementItem.isErased   = tmpIsErased.isErased
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     )

         , tmpObject_GoodsPropertyValue AS(SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                 , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
                                                 , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                                 , Object_GoodsPropertyValue.ValueData  AS Name
                                                 , ObjectFloat_Amount.ValueData         AS Amount
                                                 , ObjectString_BarCode.ValueData       AS BarCode
                                                 , ObjectString_Article.ValueData       AS Article
                                                 , ObjectString_BarCodeGLN.ValueData    AS BarCodeGLN
                                                 , ObjectString_ArticleGLN.ValueData    AS ArticleGLN
                                                 , ObjectString_NameExternal.ValueData  AS NameExternal
                                            FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
                                                 ) AS tmpGoodsProperty
                                                 INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                                       ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                                      AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                                 LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                 LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                                                       ON ObjectFloat_Amount.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                      AND ObjectFloat_Amount.DescId = zc_ObjectFloat_GoodsPropertyValue_Amount()

                                                 LEFT JOIN ObjectString AS ObjectString_BarCode
                                                                        ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                       AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
                                                 LEFT JOIN ObjectString AS ObjectString_Article
                                                                        ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                       AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()

                                                 LEFT JOIN ObjectString AS ObjectString_BarCodeGLN
                                                                        ON ObjectString_BarCodeGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                       AND ObjectString_BarCodeGLN.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeGLN()
                                                 LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                                                                        ON ObjectString_ArticleGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                       AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()
                                                 LEFT JOIN ObjectString AS ObjectString_NameExternal
                                                                        ON ObjectString_NameExternal.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                       AND ObjectString_NameExternal.DescId = zc_ObjectString_GoodsPropertyValue_NameExternal()

                                                 LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                                      ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                     AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                 LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                                      ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                     AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()

                                           )

         , tmpObject_GoodsPropertyValueGroup AS (SELECT tmpObject_GoodsPropertyValue.GoodsId
                                                      , tmpObject_GoodsPropertyValue.Article
                                                      , tmpObject_GoodsPropertyValue.ArticleGLN
                                                      , tmpObject_GoodsPropertyValue.BarCode
                                                      , tmpObject_GoodsPropertyValue.BarCodeGLN
                                                 FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId
                                                            , tmpObject_GoodsPropertyValue.GoodsId 
                                                       FROM tmpObject_GoodsPropertyValue 
                                                       WHERE tmpObject_GoodsPropertyValue.Article <> ''
                                                          OR tmpObject_GoodsPropertyValue.ArticleGLN <> ''
                                                          OR tmpObject_GoodsPropertyValue.BarCodeGLN <> ''
                                                       GROUP BY tmpObject_GoodsPropertyValue.GoodsId
                                                      ) AS tmpGoodsProperty_find
                                                      LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
                                                )

        SELECT
             tmpMI.MovementItemId    :: Integer AS Id
           , Object_Goods.Id          		AS GoodsId
           , Object_Goods.ObjectCode  		AS GoodsCode
           , Object_Goods.ValueData   		AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , tmpMI.Amount            :: TFloat  AS Amount

           , CASE WHEN Object_Measure.Id = zc_Measure_Sh() 
                  THEN tmpMI.Amount * COALESCE (ObjectFloat_Weight.ValueData,1)
                  ELSE tmpMI.Amount
             END                     ::TFloat   AS Amount_kg
                                                                         
                                                                         
           , Object_GoodsKind.Id        	AS GoodsKindId
           , Object_GoodsKind.ValueData 	AS GoodsKindName
           , Object_Measure.ValueData           AS MeasureName

           , COALESCE (tmpObject_GoodsPropertyValue.Name, '')     :: TVarChar  AS GoodsName_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.Amount, 0)    :: TFloat    AS AmountInPack_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.Article,    COALESCE (tmpObject_GoodsPropertyValue.Article, ''))    :: TVarChar AS Article_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.BarCode,    COALESCE (tmpObject_GoodsPropertyValue.BarCode, ''))    :: TVarChar AS BarCode_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.ArticleGLN, COALESCE (tmpObject_GoodsPropertyValue.ArticleGLN, '')) :: TVarChar AS ArticleGLN_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.BarCodeGLN, COALESCE (tmpObject_GoodsPropertyValue.BarCodeGLN, '')) :: TVarChar AS BarCodeGLN_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.NameExternal, '') :: TVarChar AS NameExternal_Juridical

           , tmpMI.isErased                AS isErased

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = tmpMI.GoodsId
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = tmpMI.GoodsKindId
                                                  AND (tmpObject_GoodsPropertyValue.Article <> ''
                                                    OR tmpObject_GoodsPropertyValue.ArticleGLN <> ''
                                                    OR tmpObject_GoodsPropertyValue.Name <> '')
            LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = tmpMI.GoodsId
                                                       AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
           ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.10.20         *
*/

-- тест
-- select * from gpSelect_MovementItem_SaleExternal(inMovementId := 18298048 , inIsErased := 'False' ,  inSession := '5')
