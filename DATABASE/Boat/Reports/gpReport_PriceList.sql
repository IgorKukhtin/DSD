-- Function: gpReport_PriceList)

DROP FUNCTION IF EXISTS gpReport_PriceList (TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PriceList (
    IN inOperDate     TDateTime ,
    IN inPartnerId    Integer   , -- Поставщик .
    IN inUnitId       Integer   , -- склад 
    IN inGoodsId      Integer   , -- товар
    IN inisRemains    Boolean   , --  остаток (да/нет - показываем или только если есть остаток или все MovementItem 
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE  (GoodsId         Integer
              , GoodsCode       Integer
              , GoodsName       TVarChar
              , Article         TVarChar
              , Article_all     TVarChar
              , GoodsGroupName  TVarChar
              , GoodsGroupNameFull TVarChar
              , MeasureName     TVarChar
              , PartnerName     TVarChar
              , Price           TFloat
              , Price_last      TFloat
              , Price_basis     TFloat
              , PriceTax        TFloat
              , PriceTax_last   TFloat
              , EKPrice         TFloat
              , EmpfPrice       TFloat
              , Remains         TFloat
)
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_Goods());
     vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY

   -- все что без заказа поставшику inIsEmpty = True
   -- все все и с заказом и без  inIsEmpty = False

    WITH
    -- все Прайсы
    tmpMovementALL AS (SELECT Movement.*
                            , MovementLinkObject_Partner.ObjectId AS PartnerId
                            , Row_Number() OVER (PARTITION BY MovementLinkObject_Partner.ObjectId ORDER BY Movement.OperDate) AS Ord_last
                       FROM Movement
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                        ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                       WHERE Movement.DescId = zc_Movement_PriceList()
                         AND Movement.StatusId <> zc_Enum_Status_Erased()  
                         AND (MovementLinkObject_Partner.ObjectId = inPartnerId OR inPartnerId = 0)
                       )

  , tmpMovement AS (SELECT tmp.*
                    FROM (SELECT Movement.*
                               , Row_Number() OVER (PARTITION BY Movement.PartnerId ORDER BY Movement.OperDate) AS Ord
                         FROM tmpMovementALL AS Movement
                         WHERE Movement.OperDate <= inOperDate
                         ) AS tmp
                   WHERE tmp.Ord = 1
                   )

  , tmpMovementLast AS (SELECT tmp.*
                        FROM tmpMovementALL AS tmp
                       WHERE tmp.Ord_last = 1
                       )


  , tmpGoodsAll AS (SELECT inGoodsId AS GoodsId
                    WHERE COALESCE (inGoodsId,0) <> 0
                   UNION
                    SELECT Object.Id  AS GoodsId
                    FROM Object
                    WHERE Object.DescId = zc_Object_Goods()
                      AND Object.isErased = FALSE
                      AND COALESCE (inGoodsId,0) = 0
                   )

    --Остатки на дату
  , tmpRemains AS (SELECT tmp.GoodsId
                        , SUM (tmp.Remains) AS Remains
                   FROM (SELECT Container.Id       AS ContainerId
                              , Container.ObjectId AS GoodsId
                              --, Container.Amount
                              , Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inOperDate
                                                                            THEN COALESCE (MIContainer.Amount, 0)
                                                                       ELSE 0
                                                                  END)
                                                           , 0) AS Remains
                         FROM Container
                              LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.ContainerId =  Container.Id
                                                             AND MIContainer.OperDate    >= inOperDate
                                                             --AND vbStatusId              =  zc_Enum_Status_Complete()
                         WHERE (Container.WhereObjectId = inUnitId OR inUnitId = 0)
                           AND Container.DescId        = zc_Container_Count()
                           AND Container.ObjectId IN (SELECT DISTINCT tmpGoodsAll.GoodsId FROM tmpGoodsAll)
                         GROUP BY Container.Id
                                , Container.ObjectId
                                , Container.Amount
                         HAVING Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inOperDate
                                                                            THEN COALESCE (MIContainer.Amount, 0)
                                                                       ELSE 0
                                                                  END)
                                                           , 0) <> 0
                        ) AS tmp
                   GROUP BY tmp.GoodsId 
                   HAVING SUM (tmp.Remains) <> 0
                   )
  , tmpGoods AS (SELECT tmpGoodsAll.*
                 FROM tmpGoodsAll
                 WHERE inisRemains = False
                UNION
                 SELECT tmpGoodsAll.*
                 FROM tmpGoodsAll
                     INNER JOIN tmpRemains ON tmpRemains.GoodsId = tmpGoodsAll.GoodsId
                 WHERE inisRemains = TRUE
                 )
/*
+ в гриде остаток
, цена на дату 
+ последняя цена (не на дату)                        
+ информативно цену из zc_PriceList_Basis(последнюю) 
+ zc_ObjectFloat_Goods_EmpfPrice 
+  zc_ObjectFloat_Goods_EKPrice 
+ % наценки (цена на дату и zc_PriceList_Basis)      -
+ % наценки (цена последняя и zc_PriceList_Basis)    -
*/
  , tmpMI AS (SELECT tmpMovement.PartnerId
                   , MovementItem.ObjectId  AS GoodsId
                   , MovementItem.Amount
              FROM tmpMovement
                   INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                          AND MovementItem.DescId     = zc_MI_Master()
                                          AND MovementItem.isErased   = FALSE
                   INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
             )

  , tmpMI_last AS (SELECT tmpMovement.PartnerId
                        , MovementItem.ObjectId  AS GoodsId
                        , MovementItem.Amount
                   FROM tmpMovementLast AS tmpMovement
                        INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                               AND MovementItem.DescId     = zc_MI_Master()
                                               AND MovementItem.isErased   = FALSE
                        INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                  )

    -- св-ва Комплектующих
  , tmpGoodsParams AS (SELECT Object_Goods.Id                    AS GoodsId
                            , Object_Goods.ObjectCode            AS GoodsCode
                            , Object_Goods.VAlueData             AS GoodsName
                            , ObjectString_Article.ValueData     AS Article
                            , Object_GoodsGroup.ValueData        AS GoodsGroupName
                            , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                            , Object_Measure.Id        AS MeasureId
                            , Object_Measure.ValueData AS MeasureName
                            , ObjectFloat_EKPrice.ValueData   ::TFloat   AS EKPrice    -- Цена вх. без НДС
                            , ObjectFloat_EmpfPrice.ValueData ::TFloat   AS EmpfPrice  -- Рекомендуемая цена без ндс
                       FROM (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmpGoods
                            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId
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

                            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.GoodsId
                                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                            LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                  ON ObjectFloat_EKPrice.ObjectId = tmpGoods.GoodsId
                                                 AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()
                            LEFT JOIN ObjectFloat AS ObjectFloat_EmpfPrice
                                                  ON ObjectFloat_EmpfPrice.ObjectId = tmpGoods.GoodsId
                                                 AND ObjectFloat_EmpfPrice.DescId = zc_ObjectFloat_Goods_EmpfPrice()

                      )

  , tmpPriceBasis AS (SELECT tmp.GoodsId
                           , tmp.ValuePrice
                      FROM tmpMI
                           INNER JOIN (SELECT tmp.GoodsId, tmp.ValuePrice
                                       FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                                , inOperDate   := CURRENT_DATE) AS tmp
                                       ) AS tmp ON tmp.GoodsId = tmpMI.GoodsId
                     )

      -- Результат
      SELECT tmpMI.GoodsId
           , tmpGoodsParams.GoodsCode
           , tmpGoodsParams.GoodsName
           , tmpGoodsParams.Article
           , zfCalc_Article_all (tmpGoodsParams.Article) ::TVarChar AS Article_all
           , tmpGoodsParams.GoodsGroupName
           , tmpGoodsParams.GoodsGroupNameFull
           , tmpGoodsParams.MeasureName
           , Object_Partner.ValueData                    ::TVarChar AS PartnerName
           , tmpMI.Amount                                ::TFloat   AS Price  
           , tmpMI_last.Amount                           ::TFloat   AS Price_last
           , tmpPriceBasis.ValuePrice                    ::TFloat   AS Price_basis 
           -- % наценки  (цена на дату и zc_PriceList_Basis)
           , CAST (CASE WHEN tmpMI.Amount <> 0
                        THEN (100 * tmpPriceBasis.ValuePrice / tmpMI.Amount - 100)
                        ELSE 0
                   END AS NUMERIC (16, 0)) :: TFloat AS PriceTax

           -- % наценки (цена последняя и zc_PriceList_Basis)
           , CAST (CASE WHEN tmpMI_last.Amount <> 0
                        THEN (100 *  tmpPriceBasis.ValuePrice/ tmpMI_last.Amount - 100)
                        ELSE 0
                   END AS NUMERIC (16, 0)) :: TFloat AS PriceTax_last

           , tmpGoodsParams.EKPrice                      ::TFloat
           , tmpGoodsParams.EmpfPrice                    ::TFloat
           , tmpRemains.Remains                          ::TFloat   AS Remains
      FROM tmpMI
           LEFT JOIN tmpGoodsParams ON tmpGoodsParams.GoodsId = tmpMI.GoodsId
           LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI.GoodsId

           LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpMI.PartnerId 
           LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = tmpMI.GoodsId 
           
           LEFT JOIN tmpMI_last ON tmpMI_last.GoodsId = tmpMI.GoodsId
                               AND tmpMI_last.PartnerId = tmpMI.PartnerId
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.01.23         *
*/

-- тест
--SELECT * FROM gpReport_PriceList(inOperDate := ('01.12.2023')::TDateTime , inPartnerId := 0 , inUnitId:=0, inGoodsId := 0 , inisRemains := true, inSession := '5');
