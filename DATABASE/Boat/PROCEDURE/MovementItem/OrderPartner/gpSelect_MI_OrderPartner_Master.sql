-- Function: gpSelect_MI_OrderPartner_Master()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderPartner (Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MI_OrderPartner_Master (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderPartner_Master (
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, DescName TVarChar
             , Amount TFloat
             , TotalAmountPartner TFloat
             , CountForPrice TFloat
             , OperPrice TFloat, OperPriceWithVAT TFloat
             , Summ TFloat, SummWithVAT TFloat
             , Comment TVarChar
             , isErased Boolean
             , InsertName TVarChar, InsertDate TDateTime

             , Article TVarChar
             , GoodsGroupId Integer
             , GoodsGroupName TVarChar
             , GoodsGroupNameFull TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , GoodsTagId Integer, GoodsTagName TVarChar
             , GoodsTypeId  Integer, GoodsTypeName TVarChar
             , GoodsSizeId  Integer, GoodsSizeName TVarChar
             , ProdColorId Integer, ProdColorName TVarChar
             , EngineId Integer, EngineName TVarChar
             )
AS
$BODY$
  DECLARE vbUserId       Integer;
  DECLARE vbDiscountTax TFloat;
  DECLARE vbVATPercent   TFloat;
  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbToId         Integer;
  DECLARE vbFromId       Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderPartner());
    vbUserId := lpGetUserBySession (inSession);

    SELECT MovementBoolean_PriceWithVAT.ValueData  AS PriceWithVAT
         , MovementFloat_VATPercent.ValueData      AS VATPercent
         , MovementFloat_DiscountTax.ValueData     AS DiscountTax
         , MovementLinkObject_From.ObjectId        AS FromId
         , MovementLinkObject_To.ObjectId          AS ToId
    INTO
        vbPriceWithVAT
      , vbVATPercent
      , vbDiscountTax
      , vbFromId
      , vbToId
    FROM Movement AS Movement_OrderPartner
        LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                  ON MovementBoolean_PriceWithVAT.MovementId = Movement_OrderPartner.Id
                                 AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

        LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                ON MovementFloat_VATPercent.MovementId = Movement_OrderPartner.Id
                               AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

        LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                ON MovementFloat_DiscountTax.MovementId = Movement_OrderPartner.Id
                               AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement_OrderPartner.Id
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                     ON MovementLinkObject_To.MovementId = Movement_OrderPartner.Id
                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

    WHERE Movement_OrderPartner.Id = inMovementId
      AND Movement_OrderPartner.DescId = zc_Movement_OrderPartner();


                   
    IF inShowAll
    THEN
        RETURN QUERY
        WITH
       tmpIsErased AS (SELECT FALSE AS isErased
                        UNION ALL
                       SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                      )

        -- Товары тек поставщика
     , tmpGoods AS (SELECT Object_Goods.Id               AS GoodsId
                         , Object_Goods.ObjectCode       AS GoodsCode
                         , Object_Goods.ValueData        AS GoodsName
                         , ObjectDesc.ItemName           AS DescName
                    FROM ObjectLink AS ObjectLink_Goods_Partner
                         INNER JOIN Object AS Object_Goods
                                           ON Object_Goods.Id = ObjectLink_Goods_Partner.ObjectId
                                          AND Object_Goods.isErased = FALSE
                         LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Goods.DescId
                    WHERE ObjectLink_Goods_Partner.ChildObjectId = vbToId
                      AND ObjectLink_Goods_Partner.DescId = zc_ObjectLink_Goods_Partner()
                    )


     , tmpMI AS   (SELECT MovementItem.ObjectId   AS GoodsId
                        , MovementItem.Amount
                        , MIFloat_OperPrice.ValueData     AS OperPrice
                        , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                        , CASE WHEN vbPriceWithVAT THEN MIFloat_OperPrice.ValueData
                                                   ELSE zfCalc_SummWVAT (MIFloat_OperPrice.ValueData, vbVATPercent) 
                          END ::TFloat AS OperPriceWithVAT
                         -- Цена без скидки
                       
                        , MovementItem.Id
                        , MovementItem.isErased
                        
                        , MIString_Comment.ValueData  AS Comment
 
                        , Object_Insert.ValueData     AS InsertName
                        , MIDate_Insert.ValueData     AS InsertDate
 
                   FROM tmpIsErased
                      JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND MovementItem.isErased   = tmpIsErased.isErased

                      LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                  ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                 AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()

                      LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                  ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                 AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                      LEFT JOIN MovementItemString AS MIString_Comment
                                                   ON MIString_Comment.MovementItemId = MovementItem.Id
                                                  AND MIString_Comment.DescId = zc_MIString_Comment()

                      LEFT JOIN MovementItemDate AS MIDate_Insert
                                                 ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                AND MIDate_Insert.DescId = zc_MIDate_Insert()
                      LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                       ON MILO_Insert.MovementItemId = MovementItem.Id
                                                      AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                      LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId
                     )

     , tmpMI_Child AS (SELECT MovementItem.ObjectId
                            , SUM (COALESCE (MIFloat_AmountPartner.ValueData,0)) AS AmountPartner
                       FROM MovementItemFloat
                            INNER JOIN MovementItem ON MovementItem.Id = MovementItemFloat.MovementItemId
                                                   AND MovementItem.DescId = zc_MI_Child()
                                                   AND (MovementItem.isErased = False OR inIsErased = TRUE)
                            INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                               AND Movement.DescId= zc_Movement_OrderClient()

                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                       WHERE MovementItemFloat.DescId = zc_MIFloat_MovementId()
                         AND MovementItemFloat.ValueData ::Integer = inMovementId
                       GROUP BY MovementItem.ObjectId
                       )

     , tmpGoodsParams AS (SELECT tmpGoods.GoodsId
                               , ObjectString_Article.ValueData     AS Article
                               , Object_GoodsGroup.Id               AS GoodsGroupId
                               , Object_GoodsGroup.ValueData        AS GoodsGroupName
                               , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                               , Object_Measure.Id                  AS MeasureId
                               , Object_Measure.ValueData           AS MeasureName
                               , Object_GoodsTag.Id                 AS GoodsTagId
                               , Object_GoodsTag.ValueData          AS GoodsTagName
                               , Object_GoodsType.Id                AS GoodsTypeId
                               , Object_GoodsType.ValueData         AS GoodsTypeName
                               , Object_GoodsSize.Id                AS GoodsSizeId
                               , Object_GoodsSize.ValueData         AS GoodsSizeName
                               , Object_ProdColor.Id                AS ProdColorId
                               , Object_ProdColor.ValueData         AS ProdColorName
                               , Object_Engine.Id                   AS EngineId
                               , Object_Engine.ValueData            AS EngineName
                                 -- Цена вх. без НДС
                               , ObjectFloat_EKPrice.ValueData   ::TFloat   AS EKPrice
                                 -- Цена вх. с НДС
                               , zfCalc_SummWVAT ( COALESCE (ObjectFloat_EKPrice.ValueData, 0), COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0))  ::TFloat AS EKPriceWVAT

                          FROM (SELECT DISTINCT tmpGoods.GoodsId FROM tmpGoods UNION SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmpGoods
                              LEFT JOIN ObjectString AS ObjectString_Article
                                                     ON ObjectString_Article.ObjectId = tmpGoods.GoodsId
                                                    AND ObjectString_Article.DescId = zc_ObjectString_Article()

                              LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                                     ON ObjectString_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                                    AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                   ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                              LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                   ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                              LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                                   ON ObjectLink_Goods_GoodsTag.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
                              LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId
                 
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsType
                                                   ON ObjectLink_Goods_GoodsType.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_GoodsType.DescId   = zc_ObjectLink_Goods_GoodsType()
                              LEFT JOIN Object AS Object_GoodsType ON Object_GoodsType.Id = ObjectLink_Goods_GoodsType.ChildObjectId
                 
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsSize
                                                   ON ObjectLink_Goods_GoodsSize.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_GoodsSize.DescId = zc_ObjectLink_Goods_GoodsSize()
                              LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = ObjectLink_Goods_GoodsSize.ChildObjectId
                 
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                   ON ObjectLink_Goods_ProdColor.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
                              LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_Engine
                                                   ON ObjectLink_Goods_Engine.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_Engine.DescId = zc_ObjectLink_Goods_Engine()
                              LEFT JOIN Object AS Object_Engine ON Object_Engine.Id = ObjectLink_Goods_Engine.ChildObjectId

                              LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                    ON ObjectFloat_EKPrice.ObjectId = tmpGoods.GoodsId
                                                   AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                                   ON ObjectLink_Goods_TaxKind.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
                              LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                    ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_Goods_TaxKind.ChildObjectId
                                                   AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
                          )
                                      
            SELECT
                0                          AS Id
              , tmpGoods.GoodsId           AS GoodsId
              , tmpGoods.GoodsCode         AS GoodsCode
              , tmpGoods.GoodsName         AS GoodsName
              , tmpGoods.DescName          AS DescName
              , CAST (NULL AS TFloat)      AS Amount
              , CAST (NULL AS TFloat)      AS TotalAmountPartner
              , CAST (1 AS TFloat)         AS CountForPrice
              , tmpGoodsParams.EKPrice     ::TFloat AS OperPrice
              , tmpGoodsParams.EKPriceWVAT ::TFloat AS OperPriceWithVAT
              , CAST (NULL AS TFloat)      AS Summ
              , CAST (NULL AS TFloat)      AS SummWithVAT
              
              , NULL::TVarChar             AS Comment
              
              , FALSE ::Boolean            AS isErased

              , NULL::TVarChar             AS InsertName
              , NULL::TDateTime            AS InsertDate
              --
              , tmpGoodsParams.Article
              , tmpGoodsParams.GoodsGroupId
              , tmpGoodsParams.GoodsGroupName
              , tmpGoodsParams.GoodsGroupNameFull
              , tmpGoodsParams.MeasureId
              , tmpGoodsParams.MeasureName
              , tmpGoodsParams.GoodsTagId
              , tmpGoodsParams.GoodsTagName
              , tmpGoodsParams.GoodsTypeId
              , tmpGoodsParams.GoodsTypeName
              , tmpGoodsParams.GoodsSizeId
              , tmpGoodsParams.GoodsSizeName
              , tmpGoodsParams.ProdColorId
              , tmpGoodsParams.ProdColorName
              , tmpGoodsParams.EngineId
              , tmpGoodsParams.EngineName
            FROM tmpGoods
                LEFT JOIN tmpMI ON tmpMI.GoodsId = tmpGoods.GoodsId
                LEFT JOIN tmpGoodsParams AS tmpGoodsParams ON tmpGoodsParams.GoodsId = tmpGoods.GoodsId
            WHERE tmpMI.GoodsId IS NULL
          UNION ALL
            SELECT
                MovementItem.Id           AS Id
              , MovementItem.GoodsId      AS GoodsId
              , Object_Goods.ObjectCode   AS GoodsCode
              , Object_Goods.ValueData    AS GoodsName
              , ObjectDesc.ItemName       AS DescName
              , MovementItem.Amount           ::TFloat
              , COALESCE (tmpMI_Child.AmountPartner,0) ::TFloat AS TotalAmountPartner
              , MovementItem.CountForPrice    ::TFloat
              , MovementItem.OperPrice        ::TFloat
              , MovementItem.OperPriceWithVAT ::TFloat

              , zfCalc_SummIn (COALESCE (MovementItem.Amount, 0), MovementItem.OperPrice, MovementItem.CountForPrice) :: TFloat AS Summ
              , zfCalc_SummIn (COALESCE (MovementItem.Amount, 0), MovementItem.OperPriceWithVAT, MovementItem.CountForPrice) :: TFloat AS SummWithVAT

              , MovementItem.Comment    :: TVarChar
              , MovementItem.isErased
              
              , MovementItem.InsertName
              , MovementItem.InsertDate
              
              --
              , tmpGoodsParams.Article
              , tmpGoodsParams.GoodsGroupId
              , tmpGoodsParams.GoodsGroupName
              , tmpGoodsParams.GoodsGroupNameFull
              , tmpGoodsParams.MeasureId
              , tmpGoodsParams.MeasureName
              , tmpGoodsParams.GoodsTagId
              , tmpGoodsParams.GoodsTagName
              , tmpGoodsParams.GoodsTypeId
              , tmpGoodsParams.GoodsTypeName
              , tmpGoodsParams.GoodsSizeId
              , tmpGoodsParams.GoodsSizeName
              , tmpGoodsParams.ProdColorId
              , tmpGoodsParams.ProdColorName
              , tmpGoodsParams.EngineId
              , tmpGoodsParams.EngineName
            FROM tmpMI AS MovementItem
                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
                 LEFT JOIN tmpGoodsParams AS tmpGoodsParams ON tmpGoodsParams.GoodsId = MovementItem.GoodsId
                 LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Goods.DescId
                 LEFT JOIN tmpMI_Child ON tmpMI_Child.ObjectId = MovementItem.GoodsId
            ;
    ELSE
       RETURN QUERY
       WITH
       tmpIsErased AS (SELECT FALSE AS isErased
                        UNION ALL
                       SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                      )
     , tmpMI AS   (SELECT MovementItem.ObjectId                           AS GoodsId
                        , MovementItem.Amount
                        , MIFloat_OperPrice.ValueData                     AS OperPrice
                        , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice

                        , CASE WHEN vbPriceWithVAT THEN MIFloat_OperPrice.ValueData
                                                   ELSE zfCalc_SummWVAT (MIFloat_OperPrice.ValueData, vbVATPercent) 
                          END ::TFloat AS OperPriceWithVAT
                          
                        , MovementItem.Id
                        , MovementItem.isErased
                        , MIString_Comment.ValueData  AS Comment
 
                        , Object_Insert.ValueData             AS InsertName
                        , MIDate_Insert.ValueData             AS InsertDate
 
                   FROM tmpIsErased
                      JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND MovementItem.isErased   = tmpIsErased.isErased

                      LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                  ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                 AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
 
                      LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                  ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                 AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                      LEFT JOIN MovementItemString AS MIString_Comment
                                                   ON MIString_Comment.MovementItemId = MovementItem.Id
                                                  AND MIString_Comment.DescId = zc_MIString_Comment()

                      LEFT JOIN MovementItemDate AS MIDate_Insert
                                                 ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                AND MIDate_Insert.DescId = zc_MIDate_Insert()
                      LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                       ON MILO_Insert.MovementItemId = MovementItem.Id
                                                      AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                      LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId
                     )

     , tmpMI_Child AS (SELECT MovementItem.ObjectId
                            , SUM (COALESCE (MIFloat_AmountPartner.ValueData,0)) AS AmountPartner
                       FROM MovementItemFloat
                            INNER JOIN MovementItem ON MovementItem.Id = MovementItemFloat.MovementItemId
                                                   AND MovementItem.DescId = zc_MI_Child()
                                                   AND (MovementItem.isErased = False OR inIsErased = TRUE)
                            INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                               AND Movement.DescId= zc_Movement_OrderClient()

                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                       WHERE MovementItemFloat.DescId = zc_MIFloat_MovementId()
                         AND MovementItemFloat.ValueData ::Integer = inMovementId
                       GROUP BY MovementItem.ObjectId
                       )

     , tmpGoodsParams AS (SELECT tmpGoods.GoodsId
                               , ObjectString_Article.ValueData     AS Article
                               , Object_GoodsGroup.Id               AS GoodsGroupId
                               , Object_GoodsGroup.ValueData        AS GoodsGroupName
                               , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                               , Object_Measure.Id                  AS MeasureId
                               , Object_Measure.ValueData           AS MeasureName
                               , Object_GoodsTag.Id                 AS GoodsTagId
                               , Object_GoodsTag.ValueData          AS GoodsTagName
                               , Object_GoodsType.Id                AS GoodsTypeId
                               , Object_GoodsType.ValueData         AS GoodsTypeName
                               , Object_GoodsSize.Id                AS GoodsSizeId
                               , Object_GoodsSize.ValueData         AS GoodsSizeName
                               , Object_ProdColor.Id                AS ProdColorId
                               , Object_ProdColor.ValueData         AS ProdColorName
                               , Object_Engine.Id                   AS EngineId
                               , Object_Engine.ValueData            AS EngineName
                          FROM (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmpGoods
                              LEFT JOIN ObjectString AS ObjectString_Article
                                                     ON ObjectString_Article.ObjectId = tmpGoods.GoodsId
                                                    AND ObjectString_Article.DescId = zc_ObjectString_Article()

                              LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                                     ON ObjectString_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                                    AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                   ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                              LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                   ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                              LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                                   ON ObjectLink_Goods_GoodsTag.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
                              LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId
                 
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsType
                                                   ON ObjectLink_Goods_GoodsType.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_GoodsType.DescId   = zc_ObjectLink_Goods_GoodsType()
                              LEFT JOIN Object AS Object_GoodsType ON Object_GoodsType.Id = ObjectLink_Goods_GoodsType.ChildObjectId
                 
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsSize
                                                   ON ObjectLink_Goods_GoodsSize.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_GoodsSize.DescId = zc_ObjectLink_Goods_GoodsSize()
                              LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = ObjectLink_Goods_GoodsSize.ChildObjectId
                 
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                   ON ObjectLink_Goods_ProdColor.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
                              LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_Engine
                                                   ON ObjectLink_Goods_Engine.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_Engine.DescId = zc_ObjectLink_Goods_Engine()
                              LEFT JOIN Object AS Object_Engine ON Object_Engine.Id = ObjectLink_Goods_Engine.ChildObjectId
                          )


         -- результат
            SELECT
                MovementItem.Id           AS Id
              , MovementItem.GoodsId      AS GoodsId
              , Object_Goods.ObjectCode   AS GoodsCode
              , Object_Goods.ValueData    AS GoodsName
              , ObjectDesc.ItemName       AS DescName
              , MovementItem.Amount           ::TFloat
              , COALESCE (tmpMI_Child.AmountPartner,0) ::TFloat AS TotalAmountPartner
              , MovementItem.CountForPrice    ::TFloat
              , MovementItem.OperPrice        ::TFloat
              , MovementItem.OperPriceWithVAT ::TFloat

              , zfCalc_SummIn (COALESCE (MovementItem.Amount, 0), MovementItem.OperPrice, MovementItem.CountForPrice)        ::TFloat AS Summ
              , zfCalc_SummIn (COALESCE (MovementItem.Amount, 0), MovementItem.OperPriceWithVAT, MovementItem.CountForPrice) ::TFloat AS SummWithVAT

              , MovementItem.Comment ::TVarChar
              , MovementItem.isErased
              
              , MovementItem.InsertName
              , MovementItem.InsertDate

              --
              , tmpGoodsParams.Article
              , tmpGoodsParams.GoodsGroupId
              , tmpGoodsParams.GoodsGroupName
              , tmpGoodsParams.GoodsGroupNameFull
              , tmpGoodsParams.MeasureId
              , tmpGoodsParams.MeasureName
              , tmpGoodsParams.GoodsTagId
              , tmpGoodsParams.GoodsTagName
              , tmpGoodsParams.GoodsTypeId
              , tmpGoodsParams.GoodsTypeName
              , tmpGoodsParams.GoodsSizeId
              , tmpGoodsParams.GoodsSizeName
              , tmpGoodsParams.ProdColorId
              , tmpGoodsParams.ProdColorName
              , tmpGoodsParams.EngineId
              , tmpGoodsParams.EngineName
            FROM tmpMI AS MovementItem
                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
                 LEFT JOIN tmpGoodsParams AS tmpGoodsParams ON tmpGoodsParams.GoodsId = MovementItem.GoodsId
                 LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Goods.DescId
                 LEFT JOIN tmpMI_Child ON tmpMI_Child.ObjectId = MovementItem.GoodsId
            ;
    END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.09.21         * TotalAmountPartner --итого по нижнему гриду
 12.04.21         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_OrderPartner_Master (inMovementId:= 0, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MI_OrderPartner_Master(inMovementId := 218 , inShowAll := ' TRUE' , inIsErased := 'False' ,  inSession := '5');
