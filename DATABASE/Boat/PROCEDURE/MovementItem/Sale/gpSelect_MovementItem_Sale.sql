-- Function: gpSelect_MovementItem_Sale()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Sale (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Sale (
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, DescName TVarChar
             , Amount TFloat
             , CountForPrice TFloat

               -- ИТОГО Сумма продажи без НДС - без Скидки (Basis)
             , BasisPrice TFloat
               -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options)
             , OperPrice TFloat
               -- ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками (Basis+options)
             , OperPriceWithVAT TFloat
                -- ИТОГО Сумма продажи без НДС - без Скидки (Basis+options)
             , OperPriceList TFloat
               -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options)
             , Summ TFloat
               -- ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками (Basis+options)
             , SummWithVAT TFloat
               -- ИТОГО Сумма продажи без НДС - без Скидки (Basis+options)
             , SummPriceList TFloat

             , Comment TVarChar
             , isErased Boolean
             , InsertName TVarChar, InsertDate TDateTime

             , Article TVarChar
             , GoodsGroupId Integer
             , GoodsGroupName TVarChar
             , GoodsGroupNameFull TVarChar
             , MeasureId Integer
             , MeasureName TVarChar
             , CIN TVarChar, EngineNum TVarChar, EngineName TVarChar
             )
AS
$BODY$
  DECLARE vbUserId       Integer;
  DECLARE vbDiscountTax TFloat;
  DECLARE vbVATPercent   TFloat;
  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbToId         Integer;
  DECLARE vbFromId       Integer; 
  DECLARE vbOperDate     TDateTime;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId := lpGetUserBySession (inSession);

    SELECT MovementBoolean_PriceWithVAT.ValueData  AS PriceWithVAT
         , MovementFloat_VATPercent.ValueData      AS VATPercent
         , MovementFloat_DiscountTax.ValueData     AS DiscountTax
         , MovementLinkObject_From.ObjectId        AS FromId
         , MovementLinkObject_To.ObjectId          AS ToId
         , Movement_Sale.OperDate
    INTO
        vbPriceWithVAT
      , vbVATPercent
      , vbDiscountTax
      , vbFromId
      , vbToId 
      , vbOperDate
    FROM Movement AS Movement_Sale
        LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                  ON MovementBoolean_PriceWithVAT.MovementId = Movement_Sale.Id
                                 AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

        LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                ON MovementFloat_VATPercent.MovementId = Movement_Sale.Id
                               AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

        LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                ON MovementFloat_DiscountTax.MovementId = Movement_Sale.Id
                               AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement_Sale.Id
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                     ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

    WHERE Movement_Sale.Id = inMovementId
      AND Movement_Sale.DescId = zc_Movement_Sale();



    IF inShowAll = TRUE
    THEN
        RETURN QUERY
        WITH
       tmpIsErased AS (SELECT FALSE AS isErased
                        UNION ALL
                       SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                      )

     , tmpPriceBasis AS (SELECT tmp.GoodsId
                              , tmp.ValuePrice
                              , tmp.StartDate
                         FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                  , inOperDate   := vbOperDate) AS tmp
                        )

        -- Товары тек поставщика
     , tmpGoods AS (SELECT Object_Goods.Id               AS GoodsId
                         , Object_Goods.ObjectCode       AS GoodsCode
                         , Object_Goods.ValueData        AS GoodsName
                         , ObjectDesc.ItemName           AS DescName
                    FROM Object AS Object_Goods
                         LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Goods.DescId
                    WHERE Object_Goods.DescId IN (zc_Object_Goods(), zc_Object_ReceiptService())
                      AND Object_Goods.isErased = FALSE
                    )

     , tmpMI AS   (SELECT MovementItem.ObjectId   AS GoodsId
                        , MovementItem.Amount
                          -- ИТОГО Сумма продажи без НДС - без Скидки (Basis)
                        , COALESCE (MIFloat_BasisPrice.ValueData,0)       AS BasisPrice
                          -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options)
                        , MIFloat_OperPrice.ValueData                     AS OperPrice
                         -- ИТОГО Сумма продажи без НДС - без Скидки (Basis+options)
                        , MIFloat_OperPriceList.ValueData                 AS OperPriceList
                          --
                        , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice

                          -- ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками (Basis+options)
                        , CASE WHEN vbPriceWithVAT = TRUE
                                    THEN MIFloat_OperPrice.ValueData
                               ELSE zfCalc_SummWVAT (MIFloat_OperPrice.ValueData, vbVATPercent)
                          END                                             AS OperPriceWithVAT

                        , MovementItem.Id
                        , MovementItem.isErased

                        , MIString_Comment.ValueData  AS Comment

                        , Object_Insert.ValueData     AS InsertName
                        , MIDate_Insert.ValueData     AS InsertDate

                   FROM tmpIsErased
                      JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND MovementItem.isErased   = tmpIsErased.isErased

                      LEFT JOIN MovementItemFloat AS MIFloat_BasisPrice
                                                  ON MIFloat_BasisPrice.MovementItemId = MovementItem.Id
                                                 AND MIFloat_BasisPrice.DescId = zc_MIFloat_BasisPrice()

                       LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                  ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                 AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()

                      LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                  ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                 AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()

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
       --
     , tmpGoodsParams AS (SELECT tmpGoods.GoodsId
                               , ObjectString_Article.ValueData     AS Article
                               , Object_GoodsGroup.Id               AS GoodsGroupId
                               , Object_GoodsGroup.ValueData        AS GoodsGroupName
                               , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                               , Object_Measure.Id                  AS MeasureId
                               , Object_Measure.ValueData           AS MeasureName

                                 -- Цена вх. без НДС
                               , ObjectFloat_EKPrice.ValueData      AS EKPrice
                               -- цена из прайса
                               , COALESCE (tmpPriceBasis.ValuePrice, 0) AS BasisPrice

                               , ObjectString_CIN.ValueData         AS CIN
                               , ObjectString_EngineNum.ValueData   AS EngineNum
                               , Object_Engine.ValueData            AS EngineName

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

                              LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                    ON ObjectFloat_EKPrice.ObjectId = tmpGoods.GoodsId
                                                   AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()
                              --
                              LEFT JOIN ObjectString AS ObjectString_CIN
                                                     ON ObjectString_CIN.ObjectId = tmpGoods.GoodsId
                                                    AND ObjectString_CIN.DescId   = zc_ObjectString_Product_CIN()
                              LEFT JOIN ObjectString AS ObjectString_EngineNum
                                                     ON ObjectString_EngineNum.ObjectId = tmpGoods.GoodsId
                                                    AND ObjectString_EngineNum.DescId   = zc_ObjectString_Product_EngineNum()
                              LEFT JOIN ObjectLink AS ObjectLink_Engine
                                                   ON ObjectLink_Engine.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Engine.DescId   = zc_ObjectLink_Product_Engine()
                              LEFT JOIN Object AS Object_Engine ON Object_Engine.Id = ObjectLink_Engine.ChildObjectId

                              LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = tmpGoods.GoodsId
                          )
            -- Результат
            SELECT
                0                          AS Id
              , tmpGoods.GoodsId           AS GoodsId
              , tmpGoods.GoodsCode         AS GoodsCode
              , tmpGoods.GoodsName         AS GoodsName
              , tmpGoods.DescName          AS DescName
              , CAST (NULL AS TFloat)      AS Amount
              , CAST (1 AS TFloat)         AS CountForPrice

                -- ИТОГО Сумма продажи без НДС - без Скидки (Basis)
              , CAST (tmpGoodsParams.BasisPrice AS TFloat)      AS BasisPrice
                -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options)
              , tmpGoodsParams.BasisPrice     ::TFloat AS OperPrice
                -- ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками (Basis+options)
              , tmpGoodsParams.BasisPrice     ::TFloat AS OperPriceWithVAT
                -- ИТОГО Сумма продажи без НДС - без Скидки (Basis+options)
              , CAST (NULL AS TFloat)      AS OperPriceList

                -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options)
              , CAST (NULL AS TFloat)      AS Summ
                -- ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками (Basis+options)
              , CAST (NULL AS TFloat)      AS SummWithVAT
                -- ИТОГО Сумма продажи без НДС - без Скидки (Basis+options)
              , CAST (NULL AS TFloat)      AS SummPriceList

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
              , tmpGoodsParams.CIN
              , tmpGoodsParams.EngineNum
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
              , MovementItem.CountForPrice    ::TFloat

                -- ИТОГО Сумма продажи без НДС - без Скидки (Basis)
              , MovementItem.BasisPrice       ::TFloat
                -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options)
              , MovementItem.OperPrice        ::TFloat
                -- ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками (Basis+options)
              , MovementItem.OperPriceWithVAT ::TFloat
                -- ИТОГО Сумма продажи без НДС - без Скидки (Basis+options)
              , MovementItem.OperPriceList        ::TFloat

                -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options)
              , zfCalc_SummIn (COALESCE (MovementItem.Amount, 0), MovementItem.OperPrice, MovementItem.CountForPrice)        AS Summ
                -- ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками (Basis+options)
              , zfCalc_SummIn (COALESCE (MovementItem.Amount, 0), MovementItem.OperPriceWithVAT, MovementItem.CountForPrice) AS SummWithVAT
                -- ИТОГО Сумма продажи без НДС - без Скидки (Basis+options)
              , zfCalc_SummPriceList (COALESCE (MovementItem.Amount, 0), MovementItem.OperPriceList)                         AS SummPriceList

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
              , tmpGoodsParams.CIN
              , tmpGoodsParams.EngineNum
              , tmpGoodsParams.EngineName

            FROM tmpMI AS MovementItem
                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
                 LEFT JOIN tmpGoodsParams AS tmpGoodsParams ON tmpGoodsParams.GoodsId = MovementItem.GoodsId
                 LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Goods.DescId
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
                          -- ИТОГО Сумма продажи без НДС - без Скидки (Basis)
                        , COALESCE (MIFloat_BasisPrice.ValueData,0)       AS BasisPrice
                          -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options)
                        , MIFloat_OperPrice.ValueData                     AS OperPrice
                         -- ИТОГО Сумма продажи без НДС - без Скидки (Basis+options)
                        , MIFloat_OperPriceList.ValueData                 AS OperPriceList
                          --
                        , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice

                          -- ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками (Basis+options)
                        , CASE WHEN vbPriceWithVAT = TRUE
                                    THEN MIFloat_OperPrice.ValueData
                               ELSE zfCalc_SummWVAT (MIFloat_OperPrice.ValueData, vbVATPercent)
                          END                                             AS OperPriceWithVAT


                        , MovementItem.Id
                        , MovementItem.isErased
                        , MIString_Comment.ValueData  AS Comment

                        , Object_Insert.ValueData             AS InsertName
                        , MIDate_Insert.ValueData             AS InsertDate

                   FROM tmpIsErased
                      JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND MovementItem.isErased   = tmpIsErased.isErased

                      LEFT JOIN MovementItemFloat AS MIFloat_BasisPrice
                                                  ON MIFloat_BasisPrice.MovementItemId = MovementItem.Id
                                                 AND MIFloat_BasisPrice.DescId = zc_MIFloat_BasisPrice()

                      LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                  ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                 AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()

                      LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                  ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                 AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()

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
     , tmpGoodsParams AS (SELECT tmpGoods.GoodsId
                               , ObjectString_Article.ValueData     AS Article
                               , Object_GoodsGroup.Id               AS GoodsGroupId
                               , Object_GoodsGroup.ValueData        AS GoodsGroupName
                               , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                               , Object_Measure.Id                  AS MeasureId
                               , Object_Measure.ValueData           AS MeasureName

                                 -- Цена вх. без НДС
                               , ObjectFloat_EKPrice.ValueData      AS EKPrice

                               , ObjectString_CIN.ValueData         AS CIN
                               , ObjectString_EngineNum.ValueData   AS EngineNum
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

                              LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                    ON ObjectFloat_EKPrice.ObjectId = tmpGoods.GoodsId
                                                   AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()
                              --
                              LEFT JOIN ObjectString AS ObjectString_CIN
                                                     ON ObjectString_CIN.ObjectId = tmpGoods.GoodsId
                                                    AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()
                              LEFT JOIN ObjectString AS ObjectString_EngineNum
                                                     ON ObjectString_EngineNum.ObjectId = tmpGoods.GoodsId
                                                    AND ObjectString_EngineNum.DescId   = zc_ObjectString_Product_EngineNum()
                              LEFT JOIN ObjectLink AS ObjectLink_Engine
                                                   ON ObjectLink_Engine.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Engine.DescId   = zc_ObjectLink_Product_Engine()
                              LEFT JOIN Object AS Object_Engine ON Object_Engine.Id = ObjectLink_Engine.ChildObjectId
                          )
            -- Результат
            SELECT
                MovementItem.Id           AS Id
              , MovementItem.GoodsId      AS GoodsId
              , Object_Goods.ObjectCode   AS GoodsCode
              , Object_Goods.ValueData    AS GoodsName
              , ObjectDesc.ItemName       AS DescName
              , MovementItem.Amount           ::TFloat
              , MovementItem.CountForPrice    ::TFloat

                -- ИТОГО Сумма продажи без НДС - без Скидки (Basis)
              , MovementItem.BasisPrice       ::TFloat
                -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options)
              , MovementItem.OperPrice        ::TFloat
                -- ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками (Basis+options)
              , MovementItem.OperPriceWithVAT ::TFloat
                -- ИТОГО Сумма продажи без НДС - без Скидки (Basis+options)
              , MovementItem.OperPriceList        ::TFloat

                -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options)
              , zfCalc_SummIn (COALESCE (MovementItem.Amount, 0), MovementItem.OperPrice, MovementItem.CountForPrice)        AS Summ
                -- ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками (Basis+options)
              , zfCalc_SummIn (COALESCE (MovementItem.Amount, 0), MovementItem.OperPriceWithVAT, MovementItem.CountForPrice) AS SummWithVAT
                -- ИТОГО Сумма продажи без НДС - без Скидки (Basis+options)
              , zfCalc_SummPriceList (COALESCE (MovementItem.Amount, 0), MovementItem.OperPriceList)                         AS SummPriceList

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
              , tmpGoodsParams.CIN
              , tmpGoodsParams.EngineNum
              , tmpGoodsParams.EngineName
            FROM tmpMI AS MovementItem
                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
                 LEFT JOIN tmpGoodsParams AS tmpGoodsParams ON tmpGoodsParams.GoodsId = MovementItem.GoodsId
                 LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Goods.DescId
            ;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.08.21         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Sale (inMovementId:= 218 , inShowAll:= TRUE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
