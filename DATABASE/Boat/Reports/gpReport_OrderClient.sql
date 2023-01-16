-- Function: gpReport_OrderClient)

DROP FUNCTION IF EXISTS gpReport_OrderClient (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderClient (
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inPartnerId    Integer   , -- Поставщик
    IN inGoodsId      Integer   ,
    IN inIsEmpty      Boolean   , -- Нет заказа Поставщику (да) / Все (Нет)
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE  (
                MovementId Integer
              , OperDate TDateTime
              , InvNumber Integer
              , StatusCode Integer
              , InvNumberPartner TVarChar
              , FromId Integer
              , FromCode Integer
              , FromName TVarChar
              , ToId Integer
              , ToCode Integer
              , ToName TVarChar
              , PaidKindId    Integer
              , PaidKindName TVarChar
              , ProductId Integer
              , ProductName TVarChar
              , BrandId Integer
              , BrandName TVarChar
              , CIN              TVarChar
              , EngineNum        TVarChar
              , EngineName_boat  TVarChar
              , Comment    TVarChar
              , MovementId_Invoice  Integer
              , InvNumber_Invoice TVarChar
                -- заказ поставщику
              , MovementId_OrderPartner  Integer
              , OperDate_OrderPartner TDateTime
              , InvNumber_OrderPartner TVarChar
              , OperDatePartner_OrderPartner TDateTime
              , InvNumberPartner_OrderPartner TVarChar
              , StatusCode_OrderPartner Integer
              , FromId_OrderPartner Integer
              , FromCode_OrderPartner Integer
              , FromName_OrderPartner TVarChar
              , ToId_OrderPartner Integer
              , ToCode_OrderPartner Integer
              , ToName_OrderPartner TVarChar
              , PaidKindId_OrderPartner Integer
              , PaidKindName_OrderPartner TVarChar
                --
              , PartnerName        TVarChar
              , ProdOptionsName    TVarChar

                -- Количество шаблон сборки
              , AmountBasis        TFloat

                -- План Кол-во Заказ Поставщику
              , AmountPartner      TFloat
                -- Факт Кол-во Заказ Поставщику
              , AmountPartner_real TFloat
                -- Факт Кол-во Приход от Поставщика
              , AmountIncome_real  TFloat

                -- Итого Кол-во резерв остатка
              , Amount             TFloat
                -- Кол-во резерв Склад
              , Amount_sk_reserve  TFloat
                -- Кол-во резерв Производство
              , Amount_pr_reserve  TFloat
                -- Кол-во резерв Перемещение
              , AmountSend_reserve TFloat

              , OperPrice       TFloat
              , CountForPrice   TFloat    --
              , Summ TFloat
              , OperPrice_OpderPartner TFloat
              , GoodsId Integer
              , GoodsCode Integer
              , GoodsName TVarChar
              , Article TVarChar
              , Article_all TVarChar
              , GoodsGroupName TVarChar
              , GoodsGroupNameFull TVarChar
              , MeasureName TVarChar
              , GoodsTagName TVarChar
              , GoodsTypeName TVarChar
              , GoodsSizeName TVarChar
              , ProdColorName TVarChar
              , EngineName TVarChar
              , EKPrice     TFloat
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
    -- все заказы Клиентов за период
    tmpMovement AS (SELECT Movement.*
                    FROM Movement
                    WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                      AND Movement.DescId = zc_Movement_OrderClient()
                      AND Movement.StatusId <> zc_Enum_Status_Erased()
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

    -- Заказ Клиента - zc_MI_Child - детализация по Резервам
  , tmpMI_Child AS (SELECT tmpMovement.Id                AS MovementId
                         , tmpMovement.OperDate
                         , tmpMovement.Invnumber
                         , Object_Status.ObjectCode      AS StatusCode
                         , MovementItem.Id               AS MovementItemId
                         , MovementItem.ObjectId         AS GoodsId
                         , MovementItem.PartionId        AS PartionId
                           -- Количество резерв
                         , MovementItem.Amount
                           -- Количество шаблон сборки
                         , MIFloat_AmountBasis.ValueData AS AmountBasis
                         
                         , MILinkObject_Unit.ObjectId          AS UnitId
                         , MILinkObject_ProdOptions.ObjectId   AS ProdOptionsId
                           --
                         , MILinkObject_Partner.ObjectId AS PartnerId
                         , MIFloat_MovementId.ValueData :: Integer AS MovementId_OrderPartner
                    FROM tmpMovement
                         INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                AND MovementItem.DescId     = zc_MI_Child()
                                                AND MovementItem.isErased   = FALSE
                         INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                         LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpMovement.StatusId

                         LEFT JOIN MovementItemFloat AS MIFloat_AmountBasis
                                                     ON MIFloat_AmountBasis.MovementItemId = MovementItem.Id
                                                    AND MIFloat_AmountBasis.DescId         = zc_MIFloat_AmountBasis()
                         -- какой узел собирается
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                          ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                         -- Подразделение -  происходит резерв
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                          ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                         -- Опция
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdOptions
                                                          ON MILinkObject_ProdOptions.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()

                         LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                          ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_Partner.DescId         = zc_MILinkObject_Partner()
                         -- ValueData - MovementId заказ Поставщику
                         LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                     ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                    AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                    WHERE (-- Нет заказа Поставщику (да) / Все (Нет)
                           (inIsEmpty = TRUE AND COALESCE (MIFloat_MovementId.ValueData, 0) = 0)
                         OR inIsEmpty = FALSE -- или Все
                          )
                      AND (MILinkObject_Partner.ObjectId = inPartnerId OR inPartnerId = 0)
                      AND MILinkObject_Goods.ObjectId IS NULL
                   )
    -- св-ва
  , tmpMIFloat AS (SELECT MovementItemFloat.*
                   FROM MovementItemFloat
                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Child.MovementItemId FROM tmpMI_Child)
                     AND MovementItemFloat.DescId IN (zc_MIFloat_AmountPartner()
                                                    , zc_MIFloat_CountForPrice()
                                                    , zc_MIFloat_OperPrice()
                                                    )
                  )
    -- Заказ Клиента - Лодка
  , tmpMovement_OrderClient AS (SELECT tmp.MovementId
                                     , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
                                     , Object_From.Id                             AS FromId
                                     , Object_From.ObjectCode                     AS FromCode
                                     , Object_From.ValueData                      AS FromName
                                     , Object_To.Id                               AS ToId
                                     , Object_To.ObjectCode                       AS ToCode
                                     , Object_To.ValueData                        AS ToName
                                     , Object_PaidKind.Id                         AS PaidKindId
                                     , Object_PaidKind.ValueData                  AS PaidKindName
                                     , Object_Product.Id                          AS ProductId
                                     , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased)   AS ProductName
                                     , Object_Brand.Id                            AS BrandId
                                     , Object_Brand.ValueData                     AS BrandName
                                     , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData, Object_Product.isErased) AS CIN
                                     , zfCalc_ValueData_isErased (ObjectString_EngineNum.ValueData, Object_Product.isErased) AS EngineNum
                                     , Object_Engine.ValueData                    AS EngineName
                                     , MovementString_Comment.ValueData :: TVarChar AS Comment
                                       -- № док. Счет
                                     , Movement_Invoice.Id               AS MovementId_Invoice
                                     , ('№ ' || Movement_Invoice.InvNumber || ' от ' || zfConvert_DateToString (Movement_Invoice.OperDate) :: TVarChar ) :: TVarChar  AS InvNumber_Invoice

                                FROM (SELECT DISTINCT tmpMI_Child.MovementId FROM tmpMI_Child) AS tmp
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                 ON MovementLinkObject_To.MovementId = tmp.MovementId
                                                                AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = tmp.MovementId
                                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                                 ON MovementLinkObject_PaidKind.MovementId = tmp.MovementId
                                                                AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                                                 ON MovementLinkObject_Product.MovementId = tmp.MovementId
                                                                AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()

                                    LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                             ON MovementString_InvNumberPartner.MovementId = tmp.MovementId
                                                            AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

                                    LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Invoice
                                                                   ON MovementLinkMovement_Invoice.MovementId = tmp.MovementId
                                                                  AND MovementLinkMovement_Invoice.DescId = zc_MovementLinkMovement_Invoice()

                                    LEFT JOIN Object AS Object_From   ON Object_From.Id   = MovementLinkObject_From.ObjectId
                                    LEFT JOIN Object AS Object_To     ON Object_To.Id     = MovementLinkObject_To.ObjectId
                                    LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId
                                    LEFT JOIN Object AS Object_Product  ON Object_Product.Id  = MovementLinkObject_Product.ObjectId
                                    LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MovementLinkMovement_Invoice.MovementChildId

                                    LEFT JOIN MovementString AS MovementString_Comment
                                                             ON MovementString_Comment.MovementId = tmp.MovementId
                                                            AND MovementString_Comment.DescId = zc_MovementString_Comment()

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
    -- Заказ Поставщику
  , tmpMovement_OrderPartner AS (SELECT Movement.*
                                      , MovementDate_OperDatePartner.ValueData     AS OperDatePartner
                                      , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
                                      , Object_Status.ObjectCode                   AS StatusCode
                                      , Object_From.Id                             AS FromId
                                      , Object_From.ObjectCode                     AS FromCode
                                      , Object_From.ValueData                      AS FromName
                                      , Object_To.Id                               AS ToId
                                      , Object_To.ObjectCode                       AS ToCode
                                      , Object_To.ValueData                        AS ToName
                                      , Object_PaidKind.Id                         AS PaidKindId
                                      , Object_PaidKind.ValueData                  AS PaidKindName
                                 FROM (SELECT DISTINCT tmpMI_Child.MovementId_OrderPartner AS MovementId FROM tmpMI_Child) AS tmp
                                      LEFT JOIN Movement ON Movement.Id = tmp.MovementId
                                                        AND Movement.DescId = zc_Movement_OrderPartner()
                                      LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = tmp.MovementId
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                      LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = tmp.MovementId
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                      LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                                   ON MovementLinkObject_PaidKind.MovementId = tmp.MovementId
                                                                  AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                      LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

                                      LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                               ON MovementString_InvNumberPartner.MovementId = tmp.MovementId
                                                              AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

                                      LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                             ON MovementDate_OperDatePartner.MovementId = tmp.MovementId
                                                            AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                )

    -- Заказ Поставщику, цена по которой заказали
  , tmpMI_OpderPartner AS (SELECT MovementItem.MovementId
                                , MovementItem.ObjectId       AS GoodsId
                                , MIFloat_OperPrice.ValueData AS OperPrice
                                , MovementItem.Amount
                           FROM tmpMovement_OrderPartner AS Movement
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE
                                INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                                LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                            ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                           AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                           )
   -- ВСЕ Приходы от поставщика - zc_MI_Child - детализация по заказ Клиента
 , tmpIncomePartner AS (SELECT MIFloat_MovementId.ValueData :: Integer AS MovementId_order
                             , MovementItem.ObjectId
                               -- Кол-во - попало в Резерв
                             , SUM (MovementItem.Amount) AS Amount
                        FROM Movement
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Child()
                                                    AND MovementItem.isErased   = FALSE
                             -- zc_MI_Master не удален
                             INNER JOIN MovementItem AS MI_Master
                                                     ON MI_Master.MovementId = Movement.Id
                                                    AND MI_Master.DescId     = zc_MI_Master()
                                                    AND MI_Master.Id         = MovementItem.ParentId
                                                    AND MI_Master.isErased   = FALSE
                             -- ValueData - MovementId заказ Клиента
                             INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                          ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                         AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                                         -- ограничили только этими
                                                         AND MIFloat_MovementId.ValueData IN (SELECT DISTINCT tmpMovement_OrderClient.MovementId FROM tmpMovement_OrderClient)
                        WHERE Movement.DescId   = zc_Movement_Income()
                          -- Проведенные
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                        GROUP BY MIFloat_MovementId.ValueData
                               , MovementItem.ObjectId
                       )
            -- ВСЕ Перемещения - zc_MI_Child - детализация по заказ Клиента
          , tmpSend AS (SELECT MIFloat_MovementId.ValueData :: Integer AS MovementId_order
                             , MovementItem.ObjectId
                               -- Кол-во - попало в Резерв
                             , SUM (MovementItem.Amount) AS Amount
                        FROM Movement
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Child()
                                                    AND MovementItem.isErased   = FALSE
                             -- zc_MI_Master не удален
                             INNER JOIN MovementItem AS MI_Master
                                                     ON MI_Master.MovementId = Movement.Id
                                                    AND MI_Master.DescId     = zc_MI_Master()
                                                    AND MI_Master.Id         = MovementItem.ParentId
                                                    AND MI_Master.isErased   = FALSE
                             -- ValueData - MovementId заказ Клиента
                             INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                          ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                         AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                                         -- ограничили только этими
                                                         AND MIFloat_MovementId.ValueData IN (SELECT DISTINCT tmpMovement_OrderClient.MovementId FROM tmpMovement_OrderClient)
                        WHERE Movement.DescId   = zc_Movement_Send()
                          -- Проведенные
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                        GROUP BY MIFloat_MovementId.ValueData
                               , MovementItem.ObjectId
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
                       FROM (SELECT DISTINCT tmpMI_Child.GoodsId FROM tmpMI_Child) AS tmpGoods
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
      -- Результат
      SELECT tmpMI_Child.MovementId
           , tmpMI_Child.OperDate
           , tmpMI_Child.InvNumber :: Integer AS InvNumber
           , tmpMI_Child.StatusCode
           , tmpMovement_OrderClient.InvNumberPartner
           , tmpMovement_OrderClient.FromId
           , tmpMovement_OrderClient.FromCode
           , tmpMovement_OrderClient.FromName
           , tmpMovement_OrderClient.ToId
           , tmpMovement_OrderClient.ToCode
           , tmpMovement_OrderClient.ToName
           , tmpMovement_OrderClient.PaidKindId
           , tmpMovement_OrderClient.PaidKindName
           , tmpMovement_OrderClient.ProductId
           , tmpMovement_OrderClient.ProductName
           , tmpMovement_OrderClient.BrandId
           , tmpMovement_OrderClient.BrandName
           , tmpMovement_OrderClient.CIN       :: TVarChar
           , tmpMovement_OrderClient.EngineNum :: TVarChar
           , tmpMovement_OrderClient.EngineName:: TVarChar AS EngineName_boat
           , tmpMovement_OrderClient.Comment   :: TVarChar
           , tmpMovement_OrderClient.MovementId_Invoice
           , tmpMovement_OrderClient.InvNumber_Invoice AS InvNumber_Invoice
           -- заказ поставщику
           , tmpMovement_OrderPartner.Id           AS MovementId_OrderPartner
           , tmpMovement_OrderPartner.OperDate     AS OperDate_OrderPartner
           , zfCalc_InvNumber_isErased ('', tmpMovement_OrderPartner.InvNumber, tmpMovement_OrderPartner.OperDate, tmpMovement_OrderPartner.StatusId) AS InvNumber_OrderPartner
           , tmpMovement_OrderPartner.OperDatePartner   AS OperDatePartner_OrderPartner
           , tmpMovement_OrderPartner.InvNumberPartner AS InvNumberPartner_OrderPartner
           , tmpMovement_OrderPartner.StatusCode ::Integer AS StatusCode_OrderPartner
           , tmpMovement_OrderPartner.FromId       AS FromId_OrderPartner
           , tmpMovement_OrderPartner.FromCode     AS FromCode_OrderPartner
           , tmpMovement_OrderPartner.FromName     AS FromName_OrderPartner
           , tmpMovement_OrderPartner.ToId         AS ToId_OrderPartner
           , tmpMovement_OrderPartner.ToCode       AS ToCode_OrderPartner
           , tmpMovement_OrderPartner.ToName       AS ToName_OrderPartner
           , tmpMovement_OrderPartner.PaidKindId   AS PaidKindId_OrderPartner
           , tmpMovement_OrderPartner.PaidKindName AS PaidKindName_OrderPartner
           --
           , Object_Partner.ValueData              AS PartnerName
           , Object_ProdOptions.ValueData          AS ProdOptionsName

             -- Кол-во шаблон сборки
           , tmpMI_Child.AmountBasis

             -- План Кол-во Заказ Поставщику
           , MIFloat_AmountPartner.ValueData ::TFloat AS AmountPartner     
             -- Факт Кол-во Заказ Поставщику
           , tmpMI_OpderPartner.Amount :: TFloat AS AmountPartner_real
             -- Факт Кол-во Приход от Поставщика
           , tmpIncomePartner.Amount :: TFloat AS AmountIncome_real

             -- Итого Кол-во резерв остатка
           , tmpMI_Child_reserve.Amount :: TFloat AS Amount
             -- Кол-во резерв Склад
           , tmpMI_Child_reserve_sk.Amount :: TFloat AS Amount_sk_reserve
             -- Кол-во резерв Производство
           , tmpMI_Child_reserve_pr.Amount :: TFloat AS Amount_pr_reserve
             -- Кол-во резерв Перемещение
           , tmpSend.Amount :: TFloat AS AmountSend_reserve

             -- Цена вх без НДС
           , MIFloat_OperPrice.ValueData     ::TFloat AS OperPrice         
           , COALESCE (MIFloat_CountForPrice.ValueData,1) ::TFloat AS CountForPrice
             --
           , zfCalc_SummIn (MIFloat_AmountPartner.ValueData, MIFloat_OperPrice.ValueData, COALESCE (MIFloat_CountForPrice.ValueData,1))  ::TFloat AS Summ

           , tmpMI_OpderPartner.OperPrice ::TFloat AS OperPrice_OpderPartner

           , tmpMI_Child.GoodsId
           , tmpGoodsParams.GoodsCode
           , tmpGoodsParams.GoodsName
           , tmpGoodsParams.Article
           , zfCalc_Article_all (tmpGoodsParams.Article) ::TVarChar AS Article_all
           , tmpGoodsParams.GoodsGroupName
           , tmpGoodsParams.GoodsGroupNameFull
           , tmpGoodsParams.MeasureName
           , tmpGoodsParams.GoodsTagName
           , tmpGoodsParams.GoodsTypeName
           , tmpGoodsParams.GoodsSizeName
           , tmpGoodsParams.ProdColorName
           , tmpGoodsParams.EngineName
           , tmpGoodsParams.EKPrice             ::TFloat

      FROM tmpMI_Child
           LEFT JOIN tmpMovement_OrderClient  ON tmpMovement_OrderClient.MovementId = tmpMI_Child.MovementId
           LEFT JOIN tmpMovement_OrderPartner ON tmpMovement_OrderPartner.Id        = tmpMI_Child.MovementId_OrderPartner

           -- Заказы Поставщику - Факт
           LEFT JOIN tmpMI_OpderPartner ON tmpMI_OpderPartner.MovementId = tmpMI_Child.MovementId_OrderPartner
                                       AND tmpMI_OpderPartner.GoodsId    = tmpMI_Child.GoodsId
           -- Итого резервы в Заказах Клиента
           LEFT JOIN (SELECT tmpMI_Child.MovementId, tmpMI_Child.GoodsId, SUM (tmpMI_Child.Amount) AS Amount FROM tmpMI_Child GROUP BY tmpMI_Child.MovementId, tmpMI_Child.GoodsId
                     ) AS tmpMI_Child_reserve ON tmpMI_Child_reserve.MovementId = tmpMI_Child.MovementId
                                             AND tmpMI_Child_reserve.GoodsId    = tmpMI_Child.GoodsId
           
           -- Факт Приход от Поставщика
           LEFT JOIN tmpIncomePartner ON tmpIncomePartner.MovementId_order = tmpMI_Child.MovementId
                                     AND tmpIncomePartner.ObjectId         = tmpMI_Child.GoodsId

           -- Итого Кол-во резерв Производство
           LEFT JOIN (SELECT tmpMI_Child.MovementId, tmpMI_Child.GoodsId, SUM (tmpMI_Child.Amount) AS Amount
                      FROM tmpMI_Child
                      WHERE tmpMI_Child.UnitId = zc_Unit_Production()
                      GROUP BY tmpMI_Child.MovementId, tmpMI_Child.GoodsId
                     ) AS tmpMI_Child_reserve_pr ON tmpMI_Child_reserve_pr.MovementId = tmpMI_Child.MovementId
                                                AND tmpMI_Child_reserve_pr.GoodsId    = tmpMI_Child.GoodsId

           -- Итого Кол-во резерв Склад
           LEFT JOIN (SELECT tmpMI_Child.MovementId, tmpMI_Child.GoodsId, SUM (tmpMI_Child.Amount) AS Amount
                      FROM tmpMI_Child
                      WHERE tmpMI_Child.UnitId <> zc_Unit_Production()
                      GROUP BY tmpMI_Child.MovementId, tmpMI_Child.GoodsId
                     ) AS tmpMI_Child_reserve_sk ON tmpMI_Child_reserve_sk.MovementId = tmpMI_Child.MovementId
                                                AND tmpMI_Child_reserve_sk.GoodsId    = tmpMI_Child.GoodsId
           -- Факт Перемещение - резерв
           LEFT JOIN tmpSend ON tmpSend.MovementId_order = tmpMI_Child.MovementId
                            AND tmpSend.ObjectId         = tmpMI_Child.GoodsId


           LEFT JOIN tmpGoodsParams ON tmpGoodsParams.GoodsId = tmpMI_Child.GoodsId

           LEFT JOIN Object AS Object_Partner     ON Object_Partner.Id     = tmpMI_Child.PartnerId
           LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = tmpMI_Child.ProdOptionsId

           LEFT JOIN tmpMIFloat AS MIFloat_AmountPartner
                                ON MIFloat_AmountPartner.MovementItemId = tmpMI_Child.MovementItemId
                               AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
           LEFT JOIN tmpMIFloat AS MIFloat_OperPrice
                                ON MIFloat_OperPrice.MovementItemId = tmpMI_Child.MovementItemId
                               AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
           LEFT JOIN tmpMIFloat AS MIFloat_CountForPrice
                                ON MIFloat_CountForPrice.MovementItemId = tmpMI_Child.MovementItemId
                               AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
    --WHERE COALESCE (MIFloat_AmountPartner.ValueData,0) <> 0
     -- Количество шаблон сборки
     WHERE tmpMI_Child.AmountBasis > 0
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.04.21         *
*/

-- тест
-- SELECT * FROM gpReport_OrderClient(inStartDate := ('01.01.2020')::TDateTime , inEndDate := ('03.05.2021')::TDateTime , inPartnerId := 0 , inGoodsId := 0 , inIsEmpty := FALSE, inSession := '5');
