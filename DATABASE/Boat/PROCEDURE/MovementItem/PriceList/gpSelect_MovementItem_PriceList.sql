-- Function: gpSelect_MovementItem_PriceList()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PriceList (Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_PriceList (Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PriceList (
    IN inMovementId  Integer      , -- ключ Документа
    IN inLanguageId  Integer,
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsName_translate TVarChar
             , Article TVarChar, Article_all TVarChar
             , GoodsGroupNameFull TVarChar
             , DiscountPartnerId Integer, DiscountPartnerName TVarChar
             , MeasureId Integer, MeasureName TVarChar, MeasureName_translate TVarChar
             , MeasureParentId Integer, MeasureParentName TVarChar, MeasureParentName_translate TVarChar
             , Amount        TFloat
             , MeasureMult   TFloat
             , PriceParent   TFloat
             , EmpfPriceParent TFloat
             , MinCount      TFloat
             , MinCountMult  TFloat
             , WeightParent  TFloat

             , CatalogPage TVarChar
             , Comment TVarChar
             , isOutlet Boolean
             , isErased Boolean
             , InsertName TVarChar, InsertDate TDateTime
           
             )
AS
$BODY$
  DECLARE vbUserId       Integer;
  DECLARE vbPartnerId    Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PriceList());
    vbUserId := lpGetUserBySession (inSession);

    SELECT MovementLinkObject_Partner.ObjectId AS PartnerId
           INTO vbPartnerId
    FROM Movement AS Movement_PriceList
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                     ON MovementLinkObject_Partner.MovementId = Movement_PriceList.Id
                                    AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
    WHERE Movement_PriceList.Id = inMovementId
      AND Movement_PriceList.DescId = zc_Movement_PriceList();


    IF inShowAll = TRUE
    THEN
        RETURN QUERY
          WITH tmpIsErased AS (SELECT FALSE AS isErased
                                UNION ALL
                               SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                              )
               -- Все Комплектующие Поставщика
             , tmpGoods AS (SELECT Object_Goods.Id               AS GoodsId
                                 , Object_Goods.ObjectCode       AS GoodsCode
                                 , Object_Goods.ValueData        AS GoodsName
                            FROM ObjectLink AS ObjectLink_Goods_Partner
                                 INNER JOIN Object AS Object_Goods
                                                   ON Object_Goods.Id = ObjectLink_Goods_Partner.ObjectId
                                                  AND Object_Goods.isErased = FALSE
                            WHERE ObjectLink_Goods_Partner.ChildObjectId = vbPartnerId
                              AND ObjectLink_Goods_Partner.DescId = zc_ObjectLink_Goods_Partner()
                           )
               -- св-ва Комплектующих
             , tmpGoodsParams AS (SELECT tmpGoods.GoodsId                   AS GoodsId
                                       , tmpGoods.GoodsCode                 AS GoodsCode
                                       , tmpGoods.GoodsName                 AS GoodsName
                                       , ObjectString_Article.ValueData     AS Article
                                       , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                                       , Object_Measure.Id        AS MeasureId
                                       , Object_Measure.ValueData AS MeasureName
                                  FROM tmpGoods
                                       LEFT JOIN ObjectString AS ObjectString_Article
                                                              ON ObjectString_Article.ObjectId = tmpGoods.GoodsId
                                                             AND ObjectString_Article.DescId = zc_ObjectString_Article()
                                       LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                                              ON ObjectString_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                                             AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                                       LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                            ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                       LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
             
                                )

      
             , tmpTranslate AS (SELECT Object.Id                        AS ObjectId
                                     , Object_TranslateObject.ValueData AS Value
                                FROM Object AS Object_TranslateObject
                                     INNER JOIN ObjectLink AS ObjectLink_Language
                                                           ON ObjectLink_Language.ObjectId = Object_TranslateObject.Id
                                                          AND ObjectLink_Language.DescId = zc_ObjectLink_TranslateObject_Language()
                                                          AND ObjectLink_Language.ChildObjectId = inLanguageId
        
                                     LEFT JOIN ObjectLink AS ObjectLink_Object
                                                          ON ObjectLink_Object.ObjectId = Object_TranslateObject.Id
                                                         AND ObjectLink_Object.DescId = zc_ObjectLink_TranslateObject_Object()
                                     INNER JOIN Object ON Object.Id = ObjectLink_Object.ChildObjectId
                                                      AND Object.DescId IN (zc_Object_Measure(), zc_Object_MeasureCode(), zc_Object_Goods())
                                WHERE Object_TranslateObject.DescId = zc_Object_TranslateObject()
                                  AND Object_TranslateObject.isErased = FALSE
                                )

                  -- Элементы
                , tmpMI AS (SELECT MovementItem.ObjectId   AS GoodsId
                                 , MovementItem.Amount
                                 , COALESCE (MIFloat_PriceParent.ValueData, 0)     AS PriceParent
                                 , COALESCE (MIFloat_EmpfPriceParent.ValueData, 0) AS EmpfPriceParent
                                 , COALESCE (MIFloat_MeasureMult.ValueData, 0)     AS MeasureMult
                                 , COALESCE (MIFloat_MinCount.ValueData, 0)        AS MinCount
                                 , COALESCE (MIFloat_MinCountMult.ValueData, 0)    AS MinCountMult
                                 , COALESCE (MIFloat_WeightParent.ValueData, 0)    AS WeightParent
                                   --
                                 , MovementItem.Id
                                 , MovementItem.isErased

                                 , MILO_DiscountPartner.ObjectId   AS DiscountPartnerId
                                 , MILO_Measure.ObjectId          AS MeasureId
                                 , MILO_MeasureParent.ObjectId    AS MeasureParentId
                                 , MIString_CatalogPage.ValueData AS CatalogPage
                                 , MIString_Comment.ValueData     AS Comment
                                 , MIBoolean_Outlet.ValueData     AS isOutlet

                                 , Object_Insert.ValueData        AS InsertName
                                 , MIDate_Insert.ValueData        AS InsertDate

                            FROM tmpIsErased
                                 JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = tmpIsErased.isErased

                                 LEFT JOIN MovementItemFloat AS MIFloat_EmpfPriceParent
                                                             ON MIFloat_EmpfPriceParent.MovementItemId = MovementItem.Id
                                                            AND MIFloat_EmpfPriceParent.DescId = zc_MIFloat_EmpfPriceParent()
                                 LEFT JOIN MovementItemFloat AS MIFloat_MeasureMult
                                                             ON MIFloat_MeasureMult.MovementItemId = MovementItem.Id
                                                            AND MIFloat_MeasureMult.DescId = zc_MIFloat_MeasureMult()
                                 LEFT JOIN MovementItemFloat AS MIFloat_PriceParent
                                                             ON MIFloat_PriceParent.MovementItemId = MovementItem.Id
                                                            AND MIFloat_PriceParent.DescId = zc_MIFloat_PriceParent()
                                 LEFT JOIN MovementItemFloat AS MIFloat_MinCount
                                                             ON MIFloat_MinCount.MovementItemId = MovementItem.Id
                                                            AND MIFloat_MinCount.DescId = zc_MIFloat_MinCount()
                                 LEFT JOIN MovementItemFloat AS MIFloat_MinCountMult
                                                             ON MIFloat_MinCountMult.MovementItemId = MovementItem.Id
                                                            AND MIFloat_MinCountMult.DescId = zc_MIFloat_MinCountMult()
                                 LEFT JOIN MovementItemFloat AS MIFloat_WeightParent
                                                             ON MIFloat_WeightParent.MovementItemId = MovementItem.Id
                                                            AND MIFloat_WeightParent.DescId = zc_MIFloat_WeightParent()

                                 LEFT JOIN MovementItemBoolean AS MIBoolean_Outlet
                                                               ON MIBoolean_Outlet.MovementItemId = MovementItem.Id
                                                              AND MIBoolean_Outlet.DescId = zc_MIBoolean_Outlet()

                                 LEFT JOIN MovementItemString AS MIString_Comment
                                                              ON MIString_Comment.MovementItemId = MovementItem.Id
                                                             AND MIString_Comment.DescId = zc_MIString_Comment()
                                 LEFT JOIN MovementItemString AS MIString_CatalogPage
                                                              ON MIString_CatalogPage.MovementItemId = MovementItem.Id
                                                             AND MIString_CatalogPage.DescId = zc_MIString_CatalogPage()

                                 LEFT JOIN MovementItemLinkObject AS MILO_DiscountPartner
                                                                  ON MILO_DiscountPartner.MovementItemId = MovementItem.Id
                                                                 AND MILO_DiscountPartner.DescId = zc_MILinkObject_DiscountPartner()
                                 LEFT JOIN MovementItemLinkObject AS MILO_Measure
                                                                  ON MILO_Measure.MovementItemId = MovementItem.Id
                                                                 AND MILO_Measure.DescId = zc_MILinkObject_Measure()
                                 LEFT JOIN MovementItemLinkObject AS MILO_MeasureParent
                                                                  ON MILO_MeasureParent.MovementItemId = MovementItem.Id
                                                                 AND MILO_MeasureParent.DescId = zc_MILinkObject_MeasureParent()

                                 LEFT JOIN MovementItemDate AS MIDate_Insert
                                                            ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                           AND MIDate_Insert.DescId = zc_MIDate_Insert()
                                 LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                                  ON MILO_Insert.MovementItemId = MovementItem.Id
                                                                 AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                                 LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId
                           )

            -- Результат
            SELECT
                0 :: Integer               AS Id
              , tmpGoodsParams.GoodsId     AS GoodsId
              , tmpGoodsParams.GoodsCode   AS GoodsCode
              , tmpGoodsParams.GoodsName   AS GoodsName
              , tmpTranslate_Goods.Value  AS GoodsName_translate
              , tmpGoodsParams.Article
              , zfCalc_Article_all (tmpGoodsParams.Article) AS Article_all
              , tmpGoodsParams.GoodsGroupNameFull

              , 0                          AS DiscountPartnerId
              , NULL::TVarChar             AS DiscountPartnerName
              , tmpGoodsParams.MeasureId   AS MeasureId
              , tmpGoodsParams.MeasureName AS MeasureName
              , tmpTranslate_Measure.Value AS MeasureName_translate
              , 0                          AS MeasureParentId
              , NULL::TVarChar             AS MeasureParentName
              , NULL::TVarChar             AS MeasureParentName_translate

              , CAST (NULL AS TFloat)      AS Amount

              , CAST (NULL AS TFloat)      AS MeasureMult
              , CAST (NULL AS TFloat)      AS PriceParent
              , CAST (NULL AS TFloat)      AS EmpfPriceParent
              , CAST (NULL AS TFloat)      AS MinCount
              , CAST (NULL AS TFloat)      AS MinCountMult
              , CAST (NULL AS TFloat)      AS WeightParent

              , NULL::TVarChar             AS CatalogPage
              , NULL::TVarChar             AS Comment
              , FALSE ::Boolean            AS isOutlet
              , FALSE ::Boolean            AS isErased

              , NULL::TVarChar             AS InsertName
              , NULL::TDateTime            AS InsertDate
            FROM tmpGoodsParams
                 LEFT JOIN tmpMI ON tmpMI.GoodsId = tmpGoodsParams.GoodsId
                 -- перевод Measure
                 LEFT JOIN tmpTranslate AS tmpTranslate_Measure ON tmpTranslate_Measure.ObjectId = tmpGoodsParams.MeasureId
                 --второй раз перевод Goods
                 LEFT JOIN tmpTranslate AS tmpTranslate_Goods ON tmpTranslate_Goods.ObjectId = tmpGoodsParams.GoodsId
            WHERE tmpMI.GoodsId IS NULL

          UNION ALL
            SELECT
                MovementItem.Id           AS Id
              , MovementItem.GoodsId      AS GoodsId
              , Object_Goods.ObjectCode   AS GoodsCode
              , Object_Goods.ValueData    AS GoodsName
              , tmpTranslate_Goods.Value  AS GoodsName_translate
              , ObjectString_Article.ValueData        AS Article     
              , zfCalc_Article_all (ObjectString_Article.ValueData) AS Article_all
              , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
              , Object_DiscountPartner.Id        AS DiscountPartnerId
              , Object_DiscountPartner.ValueData AS DiscountPartnerName
              , Object_Measure.Id                AS MeasureId
              , Object_Measure.ValueData         AS MeasureName
              , tmpTranslate_Measure.Value       AS MeasureName_translate
              , Object_MeasureParent.Id          AS MeasureParentId
              , Object_MeasureParent.ValueData   AS MeasureParentName
              , tmpTranslate_MeasureParner.Value AS MeasureParentName_translate
              , MovementItem.Amount          ::TFloat
              , MovementItem.MeasureMult     ::TFloat
              , MovementItem.PriceParent     ::TFloat
              , MovementItem.EmpfPriceParent ::TFloat
              , MovementItem.MinCount        ::TFloat
              , MovementItem.MinCountMult    ::TFloat
              , MovementItem.WeightParent    ::TFloat

              , MovementItem.CatalogPage     ::TVarChar
              , MovementItem.Comment         ::TVarChar
              , MovementItem.isOutlet        ::Boolean
              , MovementItem.isErased

              , MovementItem.InsertName
              , MovementItem.InsertDate
            FROM tmpMI AS MovementItem
                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
                 LEFT JOIN Object AS Object_DiscountPartner ON Object_DiscountPartner.Id = MovementItem.DiscountPartnerId
                 LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = MovementItem.MeasureId
                 LEFT JOIN Object AS Object_MeasureParent ON Object_MeasureParent.Id = MovementItem.MeasureParentId

                 LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                        ON ObjectString_GoodsGroupFull.ObjectId = MovementItem.GoodsId
                                       AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                 LEFT JOIN ObjectString AS ObjectString_Article
                                        ON ObjectString_Article.ObjectId = MovementItem.GoodsId
                                       AND ObjectString_Article.DescId = zc_ObjectString_Article()
            --первый раз перевод Measure
            LEFT JOIN tmpTranslate AS tmpTranslate_Measure ON tmpTranslate_Measure.ObjectId = Object_Measure.Id
            --второй раз перевод MeasureParent
            LEFT JOIN tmpTranslate AS tmpTranslate_MeasureParner ON tmpTranslate_MeasureParner.ObjectId = Object_MeasureParent.Id
            --третий раз перевод Goods
            LEFT JOIN tmpTranslate AS tmpTranslate_Goods ON tmpTranslate_Goods.ObjectId = MovementItem.GoodsId
            ;
    ELSE
       RETURN QUERY
          WITH tmpIsErased AS (SELECT FALSE AS isErased
                                UNION ALL
                               SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                              )

               -- Элементы
             , tmpMI AS (SELECT MovementItem.ObjectId   AS GoodsId
                              , MovementItem.Amount
                              , COALESCE (MIFloat_PriceParent.ValueData, 0)     AS PriceParent
                              , COALESCE (MIFloat_EmpfPriceParent.ValueData, 0) AS EmpfPriceParent
                              , COALESCE (MIFloat_MeasureMult.ValueData, 0)     AS MeasureMult
                              , COALESCE (MIFloat_MinCount.ValueData, 0)        AS MinCount
                              , COALESCE (MIFloat_MinCountMult.ValueData, 0)    AS MinCountMult
                              , COALESCE (MIFloat_WeightParent.ValueData, 0)    AS WeightParent
                                --
                              , MovementItem.Id
                              , MovementItem.isErased

                              , MILO_DiscountPartner.ObjectId   AS DiscountPartnerId
                              , MILO_Measure.ObjectId          AS MeasureId
                              , MILO_MeasureParent.ObjectId    AS MeasureParentId
                              , MIString_CatalogPage.ValueData AS CatalogPage
                              , MIString_Comment.ValueData     AS Comment
                              , MIBoolean_Outlet.ValueData     AS isOutlet

                              , Object_Insert.ValueData        AS InsertName
                              , MIDate_Insert.ValueData        AS InsertDate

                         FROM tmpIsErased
                              JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                               AND MovementItem.DescId     = zc_MI_Master()
                                               AND MovementItem.isErased   = tmpIsErased.isErased

                              LEFT JOIN MovementItemFloat AS MIFloat_EmpfPriceParent
                                                          ON MIFloat_EmpfPriceParent.MovementItemId = MovementItem.Id
                                                         AND MIFloat_EmpfPriceParent.DescId = zc_MIFloat_EmpfPriceParent()
                              LEFT JOIN MovementItemFloat AS MIFloat_MeasureMult
                                                          ON MIFloat_MeasureMult.MovementItemId = MovementItem.Id
                                                         AND MIFloat_MeasureMult.DescId = zc_MIFloat_MeasureMult()
                              LEFT JOIN MovementItemFloat AS MIFloat_PriceParent
                                                          ON MIFloat_PriceParent.MovementItemId = MovementItem.Id
                                                         AND MIFloat_PriceParent.DescId = zc_MIFloat_PriceParent()
                              LEFT JOIN MovementItemFloat AS MIFloat_MinCount
                                                          ON MIFloat_MinCount.MovementItemId = MovementItem.Id
                                                         AND MIFloat_MinCount.DescId = zc_MIFloat_MinCount()
                              LEFT JOIN MovementItemFloat AS MIFloat_MinCountMult
                                                          ON MIFloat_MinCountMult.MovementItemId = MovementItem.Id
                                                         AND MIFloat_MinCountMult.DescId = zc_MIFloat_MinCountMult()
                              LEFT JOIN MovementItemFloat AS MIFloat_WeightParent
                                                          ON MIFloat_WeightParent.MovementItemId = MovementItem.Id
                                                         AND MIFloat_WeightParent.DescId = zc_MIFloat_WeightParent()

                              LEFT JOIN MovementItemBoolean AS MIBoolean_Outlet
                                                            ON MIBoolean_Outlet.MovementItemId = MovementItem.Id
                                                           AND MIBoolean_Outlet.DescId = zc_MIBoolean_Outlet()

                              LEFT JOIN MovementItemString AS MIString_Comment
                                                           ON MIString_Comment.MovementItemId = MovementItem.Id
                                                          AND MIString_Comment.DescId = zc_MIString_Comment()
                              LEFT JOIN MovementItemString AS MIString_CatalogPage
                                                           ON MIString_CatalogPage.MovementItemId = MovementItem.Id
                                                          AND MIString_CatalogPage.DescId = zc_MIString_CatalogPage()

                              LEFT JOIN MovementItemLinkObject AS MILO_DiscountPartner
                                                               ON MILO_DiscountPartner.MovementItemId = MovementItem.Id
                                                              AND MILO_DiscountPartner.DescId = zc_MILinkObject_DiscountPartner()
                              LEFT JOIN MovementItemLinkObject AS MILO_Measure
                                                               ON MILO_Measure.MovementItemId = MovementItem.Id
                                                              AND MILO_Measure.DescId = zc_MILinkObject_Measure()
                              LEFT JOIN MovementItemLinkObject AS MILO_MeasureParent
                                                               ON MILO_MeasureParent.MovementItemId = MovementItem.Id
                                                              AND MILO_MeasureParent.DescId = zc_MILinkObject_MeasureParent()

                              LEFT JOIN MovementItemDate AS MIDate_Insert
                                                         ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                        AND MIDate_Insert.DescId = zc_MIDate_Insert()
                              LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                               ON MILO_Insert.MovementItemId = MovementItem.Id
                                                              AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                              LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId
                        )

             , tmpTranslate AS (SELECT Object.Id                        AS ObjectId
                                     , Object_TranslateObject.ValueData AS Value
                                FROM Object AS Object_TranslateObject
                                     INNER JOIN ObjectLink AS ObjectLink_Language
                                                           ON ObjectLink_Language.ObjectId = Object_TranslateObject.Id
                                                          AND ObjectLink_Language.DescId = zc_ObjectLink_TranslateObject_Language()
                                                          AND ObjectLink_Language.ChildObjectId = inLanguageId
        
                                     LEFT JOIN ObjectLink AS ObjectLink_Object
                                                          ON ObjectLink_Object.ObjectId = Object_TranslateObject.Id
                                                         AND ObjectLink_Object.DescId = zc_ObjectLink_TranslateObject_Object()
                                     INNER JOIN Object ON Object.Id = ObjectLink_Object.ChildObjectId
                                                      AND Object.DescId IN (zc_Object_Measure(), zc_Object_MeasureCode(), zc_Object_Goods())
                                WHERE Object_TranslateObject.DescId = zc_Object_TranslateObject()
                                  AND Object_TranslateObject.isErased = FALSE
                                )


            SELECT
                MovementItem.Id           AS Id
              , MovementItem.GoodsId      AS GoodsId
              , Object_Goods.ObjectCode   AS GoodsCode
              , Object_Goods.ValueData    AS GoodsName
              , tmpTranslate_Goods.Value  AS GoodsName_translate
              , ObjectString_Article.ValueData        AS Article
              , zfCalc_Article_all (ObjectString_Article.ValueData) ::TVarChar AS Article_all
              , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull

              , Object_DiscountPartner.Id        AS DiscountPartnerId
              , Object_DiscountPartner.ValueData AS DiscountPartnerName
              , Object_Measure.Id                AS MeasureId
              , Object_Measure.ValueData         AS MeasureName
              , tmpTranslate_Measure.Value       AS MeasureName_translate
              , Object_MeasureParent.Id          AS MeasureParentId
              , Object_MeasureParent.ValueData   AS MeasureParentName
              , tmpTranslate_MeasureParner.Value AS MeasureParentName_translate
              
              , MovementItem.Amount          ::TFloat
              , MovementItem.MeasureMult     ::TFloat
              , MovementItem.PriceParent     ::TFloat
              , MovementItem.EmpfPriceParent ::TFloat
              , MovementItem.MinCount        ::TFloat
              , MovementItem.MinCountMult    ::TFloat
              , MovementItem.WeightParent    ::TFloat

              , MovementItem.CatalogPage     ::TVarChar
              , MovementItem.Comment         ::TVarChar
              , MovementItem.isOutlet        ::Boolean
              , MovementItem.isErased

              , MovementItem.InsertName
              , MovementItem.InsertDate
            FROM tmpMI AS MovementItem
                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
                 LEFT JOIN Object AS Object_DiscountPartner ON Object_DiscountPartner.Id = MovementItem.DiscountPartnerId
                 LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = MovementItem.MeasureId
                 LEFT JOIN Object AS Object_MeasureParent ON Object_MeasureParent.Id = MovementItem.MeasureParentId

                 LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                        ON ObjectString_GoodsGroupFull.ObjectId = MovementItem.GoodsId
                                       AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                 LEFT JOIN ObjectString AS ObjectString_Article
                                        ON ObjectString_Article.ObjectId = MovementItem.GoodsId
                                       AND ObjectString_Article.DescId = zc_ObjectString_Article()

                --первый раз перевод Measure
                LEFT JOIN tmpTranslate AS tmpTranslate_Measure ON tmpTranslate_Measure.ObjectId = Object_Measure.Id
                --второй раз перевод MeasureParent
                LEFT JOIN tmpTranslate AS tmpTranslate_MeasureParner ON tmpTranslate_MeasureParner.ObjectId = Object_MeasureParent.Id
                --третий раз перевод Goods
                LEFT JOIN tmpTranslate AS tmpTranslate_Goods ON tmpTranslate_Goods.ObjectId = MovementItem.GoodsId
            ;
    END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.02.22         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_PriceList (inMovementId:= 0, inLanguageId:= 179, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
