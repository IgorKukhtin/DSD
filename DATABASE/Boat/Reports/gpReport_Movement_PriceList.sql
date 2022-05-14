-- Function: gpReport_PriceList)

DROP FUNCTION IF EXISTS gpReport_Movement_PriceList (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_PriceList (
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inPartnerId    Integer   , -- Поставщик
    IN inGoodsId      Integer   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE  (
                MovementId Integer
              , OperDate TDateTime
              , InvNumber Integer
              , StatusCode Integer
              , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             
              , DiscountPartnerId Integer, DiscountPartnerName TVarChar
              , MeasureId Integer, MeasureName TVarChar
              , MeasureParentId Integer, MeasureParentName TVarChar
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

              , GoodsId Integer
              , GoodsCode Integer
              , GoodsName TVarChar
              , Article TVarChar
              , GoodsGroupName TVarChar
              , GoodsGroupNameFull TVarChar
              , GoodsTagName TVarChar
              , GoodsTypeName TVarChar
              , GoodsSizeName TVarChar
              , ProdColorName TVarChar
              , EngineName TVarChar
              , EKPrice     TFloat
              , myCount_pl Integer

)
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY


    WITH
    -- 
    tmpMovement AS (SELECT Movement.*
                         , MovementLinkObject_Partner.ObjectId AS PartnerId 
                         , Object_Status.ObjectCode      AS StatusCode
                    FROM Movement
                         INNER JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                       ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                      AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner() 
                         LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
                    WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                      AND Movement.DescId = zc_Movement_PriceList()
                      AND Movement.StatusId <> zc_Enum_Status_Erased()     
                      AND (MovementLinkObject_Partner.ObjectId = inPartnerId OR inPartnerId = 0)
                    )

  , tmpGoods AS (SELECT inGoodsId AS GoodsId
                 WHERE COALESCE (inGoodsId,0) <> 0
                UNION
                 SELECT Object.Id  AS GoodsId
                 FROM Object
                 WHERE Object.DescId = zc_Object_Goods()
                   AND Object.isErased = FALSE
                   AND COALESCE (inGoodsId,0) = 0
                )

  , tmpMI AS (SELECT tmpMovement.Id                AS MovementId
                   , tmpMovement.OperDate
                   , tmpMovement.Invnumber
                   , tmpMovement.StatusCode
                   , tmpMovement.PartnerId
                   , MovementItem.Id               AS MovementItemId
                   , MovementItem.ObjectId         AS GoodsId
                   , MovementItem.Amount
              FROM tmpMovement
                   INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                          AND MovementItem.DescId     = zc_MI_Master()
                                          AND MovementItem.isErased   = FALSE
                   INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
             )

    -- св-ва
  , tmpMIFloat AS (SELECT MovementItemFloat.*
                   FROM MovementItemFloat
                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                     AND MovementItemFloat.DescId IN (zc_MIFloat_EmpfPriceParent()
                                                    , zc_MIFloat_MeasureMult()
                                                    , zc_MIFloat_PriceParent() 
                                                    , zc_MIFloat_MinCount()
                                                    , zc_MIFloat_MinCountMult()
                                                    , zc_MIFloat_WeightParent()
                                                    )
                  )  

  , tmpMIBoolean AS (SELECT MovementItemBoolean.*
                     FROM MovementItemBoolean
                     WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                       AND MovementItemBoolean.DescId IN (zc_MIBoolean_Outlet())
                    )

  , tmpMIString AS (SELECT MovementItemString.*
                    FROM MovementItemString
                    WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                      AND MovementItemString.DescId IN (zc_MIString_Comment()
                                                      , zc_MIString_CatalogPage()
                                                      )
                  )

  , tmpMILO AS (SELECT MovementItemLinkObject.*
                FROM MovementItemLinkObject
                WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                  AND MovementItemLinkObject.DescId IN (zc_MILinkObject_DiscountPartner()
                                                      , zc_MILinkObject_Measure()  
                                                      , zc_MILinkObject_MeasureParent()
                                                      )
              )

  , tmpData AS (SELECT tmpMI.MovementId
                     , tmpMI.OperDate
                     , tmpMI.Invnumber
                     , tmpMI.StatusCode
                     , tmpMI.PartnerId
                     , tmpMI.MovementItemId
                     , tmpMI.GoodsId 
                     , tmpMI.Amount
  
                     , COALESCE (MIFloat_PriceParent.ValueData, 0)     AS PriceParent
                     , COALESCE (MIFloat_EmpfPriceParent.ValueData, 0) AS EmpfPriceParent
                     , COALESCE (MIFloat_MeasureMult.ValueData, 0)     AS MeasureMult
                     , COALESCE (MIFloat_MinCount.ValueData, 0)        AS MinCount
                     , COALESCE (MIFloat_MinCountMult.ValueData, 0)    AS MinCountMult
                     , COALESCE (MIFloat_WeightParent.ValueData, 0)    AS WeightParent 
                     , MILO_DiscountPartner.ObjectId                   AS DiscountPartnerId
                     , MILO_Measure.ObjectId                           AS MeasureId
                     , MILO_MeasureParent.ObjectId                     AS MeasureParentId
                     , MIString_CatalogPage.ValueData                  AS CatalogPage
                     , MIString_Comment.ValueData                      AS Comment
                     , MIBoolean_Outlet.ValueData                      AS isOutlet
                FROM tmpMI
                         LEFT JOIN tmpMIFloat AS MIFloat_EmpfPriceParent
                                              ON MIFloat_EmpfPriceParent.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_EmpfPriceParent.DescId = zc_MIFloat_EmpfPriceParent()
                         LEFT JOIN tmpMIFloat AS MIFloat_MeasureMult
                                              ON MIFloat_MeasureMult.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_MeasureMult.DescId = zc_MIFloat_MeasureMult()
                         LEFT JOIN tmpMIFloat AS MIFloat_PriceParent
                                              ON MIFloat_PriceParent.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_PriceParent.DescId = zc_MIFloat_PriceParent()
                         LEFT JOIN tmpMIFloat AS MIFloat_MinCount
                                              ON MIFloat_MinCount.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_MinCount.DescId = zc_MIFloat_MinCount()
                         LEFT JOIN tmpMIFloat AS MIFloat_MinCountMult
                                              ON MIFloat_MinCountMult.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_MinCountMult.DescId = zc_MIFloat_MinCountMult()
                         LEFT JOIN tmpMIFloat AS MIFloat_WeightParent
                                              ON MIFloat_WeightParent.MovementItemId = tmpMI.MovementItemId
                                             AND MIFloat_WeightParent.DescId = zc_MIFloat_WeightParent()

                         LEFT JOIN tmpMIBoolean AS MIBoolean_Outlet
                                                ON MIBoolean_Outlet.MovementItemId = tmpMI.MovementItemId
                                               AND MIBoolean_Outlet.DescId = zc_MIBoolean_Outlet()

                         LEFT JOIN tmpMIString AS MIString_Comment
                                               ON MIString_Comment.MovementItemId = tmpMI.MovementItemId
                                              AND MIString_Comment.DescId = zc_MIString_Comment()
                         LEFT JOIN tmpMIString AS MIString_CatalogPage
                                               ON MIString_CatalogPage.MovementItemId = tmpMI.MovementItemId
                                              AND MIString_CatalogPage.DescId = zc_MIString_CatalogPage()

                         LEFT JOIN tmpMILO AS MILO_DiscountPartner
                                           ON MILO_DiscountPartner.MovementItemId = tmpMI.MovementItemId
                                          AND MILO_DiscountPartner.DescId = zc_MILinkObject_DiscountPartner()
                         LEFT JOIN tmpMILO AS MILO_Measure
                                           ON MILO_Measure.MovementItemId = tmpMI.MovementItemId
                                          AND MILO_Measure.DescId = zc_MILinkObject_Measure()
                         LEFT JOIN tmpMILO AS MILO_MeasureParent
                                           ON MILO_MeasureParent.MovementItemId = tmpMI.MovementItemId
                                          AND MILO_MeasureParent.DescId = zc_MILinkObject_MeasureParent()
                   )


    -- Параметры - Комплектующие
  , tmpGoodsParams AS (SELECT tmpGoods.GoodsId
                            , Object_Goods.ObjectCode            AS GoodsCode
                            , Object_Goods.ValueData             AS GoodsName
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
                            , ObjectFloat_EKPrice.ValueData   ::TFloat   AS EKPrice  -- Цена вх. без НДС
                       FROM (SELECT DISTINCT tmpData.GoodsId FROM tmpData) AS tmpGoods
                           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId
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

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                                ON ObjectLink_Goods_TaxKind.ObjectId = tmpGoods.GoodsId
                                               AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
                           LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                 ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_Goods_TaxKind.ChildObjectId
                                                AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

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


  , tmpmyCount_pl AS (SELECT tmpMovementPL_count.GoodsId, MAX (tmpMovementPL_count.myCount) AS myCount
                      FROM (SELECT tmpData.MovementId, tmpData.GoodsId, COUNT(*) AS myCount
                            FROM tmpData
                            GROUP BY tmpData.MovementId, tmpData.GoodsId
                            HAVING COUNT(*) > 1
                           ) AS tmpMovementPL_count
                      GROUP BY tmpMovementPL_count.GoodsId
                      ) 

         -- Результат
         SELECT tmpData.MovementId
              , tmpData.OperDate
              , tmpData.InvNumber :: Integer AS InvNumber
              , tmpData.StatusCode  
              , Object_Partner.Id                AS PartnerId
              , Object_Partner.ObjectCode        AS PartnerCode
              , Object_Partner.ValueData         AS PartnerName 

              , Object_DiscountPartner.Id        AS DiscountPartnerId
              , Object_DiscountPartner.ValueData AS DiscountPartnerName
              , Object_Measure.Id                AS MeasureId
              , Object_Measure.ValueData         AS MeasureName
              , Object_MeasureParent.Id          AS MeasureParentId
              , Object_MeasureParent.ValueData   AS MeasureParentName
              
              , tmpData.Amount          ::TFloat
              , tmpData.MeasureMult     ::TFloat
              , tmpData.PriceParent     ::TFloat
              , tmpData.EmpfPriceParent ::TFloat
              , tmpData.MinCount        ::TFloat
              , tmpData.MinCountMult    ::TFloat
              , tmpData.WeightParent    ::TFloat

              , tmpData.CatalogPage     ::TVarChar
              , tmpData.Comment         ::TVarChar
              , tmpData.isOutlet        ::Boolean

              , tmpGoodsParams.GoodsId
              , tmpGoodsParams.GoodsCode
              , tmpGoodsParams.GoodsName
              
              , tmpGoodsParams.Article
              , tmpGoodsParams.GoodsGroupName
              , tmpGoodsParams.GoodsGroupNameFull
              , tmpGoodsParams.GoodsTagName
              , tmpGoodsParams.GoodsTypeName
              , tmpGoodsParams.GoodsSizeName
              , tmpGoodsParams.ProdColorName
              , tmpGoodsParams.EngineName
              , tmpGoodsParams.EKPrice             ::TFloat  

              , tmpmyCount_pl.myCount :: Integer  AS myCount_pl

         FROM tmpData
              LEFT JOIN Object AS Object_Partner ON Object_Partner.Id   = tmpData.PartnerId
              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
              LEFT JOIN Object AS Object_DiscountPartner ON Object_DiscountPartner.Id = tmpData.DiscountPartnerId
              LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpData.MeasureId
              LEFT JOIN Object AS Object_MeasureParent ON Object_MeasureParent.Id = tmpData.MeasureParentId

              LEFT JOIN tmpGoodsParams ON tmpGoodsParams.GoodsId = tmpData.GoodsId
              
              LEFT JOIN tmpmyCount_pl ON tmpmyCount_pl.GoodsId = tmpData.GoodsId

 
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.05.22         *
*/

-- тест
-- select * from gpReport_Movement_PriceList(inStartDate := ('01.01.2022')::TDateTime , inEndDate := ('02.01.2022')::TDateTime , inPartnerId := 0 , inGoodsId := 16248 , inSession := '5');
