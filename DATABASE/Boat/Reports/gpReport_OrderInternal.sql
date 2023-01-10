-- Function: gpReport_OrderInternal)

DROP FUNCTION IF EXISTS gpReport_OrderInternal (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderInternal (
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inGoodsId      Integer   ,
    --IN inIsEmpty      Boolean   , -- Нет заказа Поставщику (да) / Все (Нет)
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE  (
             MovementId Integer
           , OperDate   TDateTime
           , InvNumber  Integer
           , StatusCode Integer
           --Master
           , GoodsId      Integer
           , GoodsCode    Integer
           , GoodsName    TVarChar
           , DescName     TVarChar
           , Amount       TFloat 
           
           , EAN                TVarChar
           , Article            TVarChar
           , Article_all        TVarChar
           , GoodsGroupName     TVarChar
           , GoodsGroupNameFull TVarChar
           , MeasureName        TVarChar

           , UnitId             Integer
           , UnitName           TVarChar
           --заказ клиента
           , MovementId_OrderClient     Integer
           , InvNumber_OrderClient      TVarChar
           , InvNumberFull_OrderClient  TVarChar
           , OperDate_OrderClient       TDateTime
           , FromName_OrderClient       TVarChar
           , ProductId          Integer
           , ProductName        TVarChar
           , BrandId            Integer
           , BrandName          TVarChar
           , CIN                TVarChar
           , EngineNum          TVarChar
           , EngineName_boat    TVarChar
            --Child
           , UnitId_child                Integer
           , UnitName_child              TVarChar
           , ReceiptLevelId_child        Integer
           , ReceiptLevelName_child      TVarChar
           , ColorPatternId_child        Integer
           , ColorPatternName_child      TVarChar
           , ProdColorPatternId_child    Integer
           , ProdColorPatternName_child  TVarChar
           , GoodsId_child            Integer
           , GoodsCode_child          Integer
           , GoodsName_child          TVarChar
           , Article_child            TVarChar
           , Article_all_child        TVarChar
           , GoodsGroupName_child     TVarChar
           , GoodsGroupNameFull_child TVarChar
           , MeasureName_child        TVarChar
           , ProdColorName_child      TVarChar
           
           , Amount_child             TFloat
           , AmountReserv_child       TFloat
           , AmountSend_child         TFloat
           
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
    -- все заказы на производство за период
    tmpMovement AS (SELECT Movement.*
                    FROM Movement
                    WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                      AND Movement.DescId = zc_Movement_OrderInternal()
                      AND Movement.StatusId <> zc_Enum_Status_Erased()
                    )

  /*, tmpGoods AS (SELECT inGoodsId AS GoodsId
                 WHERE COALESCE (inGoodsId,0) <> 0
                UNION
                 SELECT Object.Id  AS GoodsId
                 FROM Object
                 WHERE Object.DescId = zc_Object_Goods()
                   AND Object.isErased = FALSE
                   AND COALESCE (inGoodsId,0) = 0
                ) 
        */

    --
  , tmpMI AS (SELECT MovementItem.*
              FROM tmpMovement
                   INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                          AND MovementItem.isErased   = FALSE
                                         -- AND (MovementItem.ObjectId = inGoodsId OR COALESCE (inGoodsId,0) = 0)
              )

    -- Заказ Клиента - zc_MI_Child - детализация по Резервам
  , tmpMI_Master AS (SELECT MovementItem.MovementId
                          , MovementItem.Id               AS MovementItemId
                          , MovementItem.ObjectId         AS GoodsId
                          , MovementItem.Amount
                          , MILinkObject_Unit.ObjectId          AS UnitId
                          , MIFloat_MovementId.ValueData :: Integer AS MovementId_OrderClient
                     FROM tmpMovement
                          INNER JOIN tmpMI AS MovementItem
                                           ON MovementItem.MovementId = tmpMovement.Id
                                          AND MovementItem.DescId     = zc_MI_Master()
                                          AND (MovementItem.ObjectId = inGoodsId OR COALESCE (inGoodsId,0) = 0)
                          --INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId      --узел / лодка
                          --Место сборки
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                           ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                          --Заказ Клиента
                          LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                      ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                     AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                     )
     -- Заказ Клиента - zc_MI_Child - детализация по Резервам
  , tmpMI_Child AS (SELECT MovementItem.MovementId
                         , MovementItem.ParentId
                         , MovementItem.Id               AS MovementItemId
                         , MovementItem.ObjectId         AS GoodsId
                         , MovementItem.Amount
                    FROM tmpMI_Master
                         INNER JOIN tmpMI AS MovementItem
                                          ON MovementItem.MovementId = tmpMI_Master.MovementId
                                         AND MovementItem.ParentId = tmpMI_Master.MovementItemId
                                         AND MovementItem.DescId     = zc_MI_Child()
                    )
  , tmpMI_Float AS (SELECT MovementItemFloat.*
                    FROM MovementItemFloat
                    WHERE MovementItemFloat.DescId IN (zc_MIFloat_AmountReserv()
                                                     , zc_MIFloat_AmountSend()
                                                     , zc_MIFloat_ForCount()
                                                      )
                      AND MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Child.MovementItemId FROM tmpMI_Child)
                    ) 
  , tmpMI_LO AS (SELECT MovementItemLinkObject.*
                 FROM MovementItemLinkObject
                 WHERE MovementItemLinkObject.DescId IN (zc_MILinkObject_Unit()
                                                       , zc_MILinkObject_ReceiptLevel()
                                                       , zc_MILinkObject_ColorPattern()
                                                       , zc_MILinkObject_ProdColorPattern()
                                                        )
                   AND MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_Child.MovementItemId FROM tmpMI_Child)
                 )   

    -- Заказы Клиента 
  , tmpMovement_OrderClient AS (SELECT tmp.MovementId
                                     , Movement_OrderClient.Id                                   AS MovementId_OrderClient
                                     , zfConvert_StringToNumber (Movement_OrderClient.InvNumber):: TVarChar AS InvNumber_OrderClient 
                                     , ('№ ' || Movement_OrderClient.InvNumber || ' от ' || zfConvert_DateToString (Movement_OrderClient.OperDate) :: TVarChar ) :: TVarChar  AS InvNumberFull_OrderClient
                                     , Movement_OrderClient.OperDate                             AS OperDate_OrderClient
                                     , Object_From.ValueData                      AS FromName 
, Object_Product.Id                          AS ProductId                                    
, zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName

                                     , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData, Object_Product.isErased) AS CIN
                                     , zfCalc_ValueData_isErased (ObjectString_EngineNum.ValueData, Object_Product.isErased) AS EngineNum
                                     , Object_Engine.ValueData                    AS EngineName

                                     , Object_Brand.Id                            AS BrandId
                                     , Object_Brand.ValueData                     AS BrandName

                                FROM (SELECT DISTINCT tmpMI_Master.MovementId, tmpMI_Master.MovementId_OrderClient FROM tmpMI_Master) AS tmp
                                   LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = tmp.MovementId_OrderClient

                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                ON MovementLinkObject_From.MovementId = Movement_OrderClient.Id
                                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                   LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                  
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                                                ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                                               AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                                   LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId  
                  
                                   LEFT JOIN ObjectString AS ObjectString_CIN
                                                          ON ObjectString_CIN.ObjectId = Object_Product.Id
                                                         AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()
                  
                                   LEFT JOIN ObjectLink AS ObjectLink_Brand
                                                        ON ObjectLink_Brand.ObjectId = Object_Product.Id
                                                       AND ObjectLink_Brand.DescId = zc_ObjectLink_Product_Brand()
                                   LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId
                                   
                                   LEFT JOIN ObjectString AS ObjectString_EngineNum
                                                          ON ObjectString_EngineNum.ObjectId = Object_Product.Id
                                                         AND ObjectString_EngineNum.DescId   = zc_ObjectString_Product_EngineNum()
                                   LEFT JOIN ObjectLink AS ObjectLink_Engine
                                                        ON ObjectLink_Engine.ObjectId = Object_Product.Id
                                                       AND ObjectLink_Engine.DescId   = zc_ObjectLink_Product_Engine()
                                   LEFT JOIN Object AS Object_Engine ON Object_Engine.Id = ObjectLink_Engine.ChildObjectId
                                )
 

    -- Параметры - Комплектующие
  , tmpGoodsParams AS (SELECT tmpGoods.GoodsId
                            , Object_Goods.ObjectCode            AS GoodsCode
                            , Object_Goods.ValueData             AS GoodsName
                            , ObjectString_EAN.ValueData         AS EAN
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
                       FROM (SELECT DISTINCT tmpMI.ObjectId AS GoodsId FROM tmpMI) AS tmpGoods
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
 
                           LEFT JOIN ObjectString AS ObjectString_EAN
                                                  ON ObjectString_EAN.ObjectId = tmpGoods.GoodsId
                                                 AND ObjectString_EAN.DescId = zc_ObjectString_EAN()
                                                    
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


      -- Результат
      SELECT Movement.Id AS MovementId
           , Movement.OperDate
           , Movement.InvNumber :: Integer AS InvNumber
           , Object_Status.ObjectCode      AS StatusCode
            
           --Master
           , tmpMI_Master.GoodsId      AS GoodsId
           , Object_Goods.ObjectCode   AS GoodsCode
           , Object_Goods.ValueData    AS GoodsName
           , ObjectDesc.ItemName       AS DescName
           , tmpMI_Master.Amount           ::TFloat 
           
           , tmpGoodsParams.EAN
           , tmpGoodsParams.Article 
           , zfCalc_Article_all (tmpGoodsParams.Article) ::TVarChar AS Article_all
           , tmpGoodsParams.GoodsGroupName
           , tmpGoodsParams.GoodsGroupNameFull
           , tmpGoodsParams.MeasureName

           , Object_Unit.Id                      AS UnitId
           , Object_Unit.ValueData               AS UnitName
           --заказ клиента
           , tmpMovement_OrderClient.MovementId_OrderClient
           , tmpMovement_OrderClient.InvNumber_OrderClient
           , tmpMovement_OrderClient.InvNumberFull_OrderClient
           , tmpMovement_OrderClient.OperDate_OrderClient
           , tmpMovement_OrderClient.FromName AS FromName_OrderClient
           , tmpMovement_OrderClient.ProductId
           , tmpMovement_OrderClient.ProductName
           , tmpMovement_OrderClient.BrandId
           , tmpMovement_OrderClient.BrandName
           , tmpMovement_OrderClient.CIN       :: TVarChar
           , tmpMovement_OrderClient.EngineNum :: TVarChar
           , tmpMovement_OrderClient.EngineName:: TVarChar

            --Child
            
           , Object_Unit_child.Id                 AS UnitId_child
           , Object_Unit_child.ValueData          AS UnitName_child
           , Object_ReceiptLevel.Id               AS ReceiptLevelId_child
           , Object_ReceiptLevel.ValueData        AS ReceiptLevelName_child
           , Object_ColorPattern.Id               AS ColorPatternId_child
           , Object_ColorPattern.ValueData        AS ColorPatternName_child
           , Object_ProdColorPattern.Id           AS ProdColorPatternId_child
           , Object_ProdColorPattern.ValueData    AS ProdColorPatternName_child
           , tmpMI_Child.GoodsId                  AS GoodsId_child
           , tmpGoodsParams_Child.GoodsCode       AS GoodsCode_child
           , tmpGoodsParams_Child.GoodsName       AS GoodsName_child
           , tmpGoodsParams_Child.Article         AS Article_child
           , zfCalc_Article_all (tmpGoodsParams_Child.Article) ::TVarChar AS Article_all_child
           , tmpGoodsParams_Child.GoodsGroupName     AS GoodsGroupName_child
           , tmpGoodsParams_Child.GoodsGroupNameFull AS GoodsGroupNameFull_child
           , tmpGoodsParams_Child.MeasureName        AS MeasureName_child
           , tmpGoodsParams_Child.ProdColorName      AS ProdColorName_child
           
           , zfCalc_Value_ForCount (tmpMI_Child.Amount,             MIFloat_ForCount.ValueData) ::TFloat AS Amount_child
           , zfCalc_Value_ForCount (MIFloat_AmountReserv.ValueData, MIFloat_ForCount.ValueData) ::TFloat AS AmountReserv_child
           , zfCalc_Value_ForCount (MIFloat_AmountSend.ValueData,   MIFloat_ForCount.ValueData) ::TFloat AS AmountSend_child

      FROM tmpMovement AS Movement
           LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
           
           INNER JOIN tmpMI_Master ON tmpMI_Master.MovementId = Movement.Id
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_Master.GoodsId
           LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Goods.DescId
           LEFT JOIN tmpGoodsParams AS tmpGoodsParams ON tmpGoodsParams.GoodsId = tmpMI_Master.GoodsId           
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMI_Master.UnitId
           
           LEFT JOIN tmpMovement_OrderClient ON tmpMovement_OrderClient.MovementId_OrderClient = tmpMI_Master.MovementId_OrderClient
           

           LEFT JOIN tmpMI_Child ON tmpMI_Child.MovementId = Movement.Id
                                AND tmpMI_Child.ParentId = tmpMI_Master.MovementItemId
           LEFT JOIN Object AS Object_Goods_Child ON Object_Goods_Child.Id = tmpMI_Child.GoodsId
           LEFT JOIN tmpGoodsParams AS tmpGoodsParams_Child ON tmpGoodsParams_Child.GoodsId = tmpMI_Child.GoodsId
           
           LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                            ON MILinkObject_Unit.MovementItemId = tmpMI_Child.MovementItemId
                                           AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
           LEFT JOIN Object AS Object_Unit_child ON Object_Unit_child.Id = MILinkObject_Unit.ObjectId
 
           LEFT JOIN MovementItemLinkObject AS MILO_ReceiptLevel
                                            ON MILO_ReceiptLevel.MovementItemId = tmpMI_Child.MovementItemId
                                           AND MILO_ReceiptLevel.DescId = zc_MILinkObject_ReceiptLevel()
           LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = MILO_ReceiptLevel.ObjectId

           LEFT JOIN MovementItemLinkObject AS MILO_ColorPattern
                                            ON MILO_ColorPattern.MovementItemId = tmpMI_Child.MovementItemId
                                           AND MILO_ColorPattern.DescId = zc_MILinkObject_ColorPattern()
           LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = MILO_ColorPattern.ObjectId

           LEFT JOIN MovementItemLinkObject AS MILO_ProdColorPattern
                                            ON MILO_ProdColorPattern.MovementItemId = tmpMI_Child.MovementItemId
                                           AND MILO_ProdColorPattern.DescId = zc_MILinkObject_ProdColorPattern()
           LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = MILO_ProdColorPattern.ObjectId
 
           LEFT JOIN tmpMI_Float AS MIFloat_AmountReserv
                                 ON MIFloat_AmountReserv.MovementItemId = tmpMI_Child.MovementItemId
                                AND MIFloat_AmountReserv.DescId = zc_MIFloat_AmountReserv()
           LEFT JOIN tmpMI_Float AS MIFloat_AmountSend
                                 ON MIFloat_AmountSend.MovementItemId = tmpMI_Child.MovementItemId
                                AND MIFloat_AmountSend.DescId = zc_MIFloat_AmountSend()
           LEFT JOIN tmpMI_Float AS MIFloat_ForCount
                                 ON MIFloat_ForCount.MovementItemId = tmpMI_Child.MovementItemId
                                AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.01.23         *
*/

-- тест
-- select * from gpReport_OrderInternal(inStartDate := ('01.01.2020')::TDateTime , inEndDate := ('03.05.2023')::TDateTime , inGoodsId := 253246 , inSession := '5');
