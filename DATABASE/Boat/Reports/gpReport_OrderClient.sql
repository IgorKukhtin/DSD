-- Function: gpReport_OrderClient)

DROP FUNCTION IF EXISTS gpReport_OrderClient (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderClient (
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inPartnerId    Integer   ,
    IN inGoodsId      Integer   ,
    IN inisEmpty      Boolean   ,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE  (  
                MovementId Integer
              , OperDate TDateTime
              , InvNumber TVarChar
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
              , CIN        TVarChar
              , Comment    TVarChar
              , MovementId_Invoice  Integer
              , InvNumber_Invoice TVarChar
              -- заказ поставщику
              , MovementId_OrderPartner  Integer
              , OperDate_OrderPartner TDateTime
              , InvNumber_OrderPartner  TVarChar
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
              , PartnerName TVarChar
              , Amount TFloat
              , AmountPartner   TFloat
              , OperPrice       TFloat
              , CountForPrice   TFloat    --
              , Summ TFloat
              , OperPrice_OpderPartner TFloat
              , GoodsId Integer
              , GoodsCode Integer
              , GoodsName TVarChar
              , Article TVarChar
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
           
   -- все что без заказа поставшику inisEmpty = True
   -- все все и с заказом и без  inisEmpty = False

    WITH
    --выбираем за период все заказы от клиентов
    tmpMovement AS (SELECT Movement.*
                    FROM Movement
                    WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                      AND Movement.DescId = zc_Movement_OrderClient()
                      AND Movement.StatusId <> zc_Enum_Status_Erased()
                    )
  , tmpGoods AS (SELECT inGoodsId AS GoodsId
                 WHERE COALESCE (inGoodsId,0) <> 0
                UNION
                 SELECT Object.Id  AS LocationId
                 FROM Object
                 WHERE Object.DescId = zc_Object_Goods()
                   AND Object.isErased = FALSE
                   AND COALESCE (inGoodsId,0) = 0
                )

    --чайлды
  , tmpMI_Child AS (SELECT tmpMovement.Id                AS MovementId
                         , tmpMovement.OperDate
                         , tmpMovement.Invnumber
                         , Object_Status.ObjectCode      AS StatusCode
                         , MovementItem.Id               AS MovementItemId
                         , MovementItem.ObjectId         AS GoodsId
                         , MovementItem.Amount
                         , MILinkObject_Partner.ObjectId AS PartnerId
                         , MIFloat_MovementId.ValueData :: Integer AS MovementId_OrderPartner
                    FROM tmpMovement
                         INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                AND MovementItem.DescId     = zc_MI_Child()
                                                AND MovementItem.isErased   = FALSE
                         INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                         INNER JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                           ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_Partner.DescId         = zc_MILinkObject_Partner()
                                                          AND (MILinkObject_Partner.ObjectId = inPartnerId OR inPartnerId = 0)
                         LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                     ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                    AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                         LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpMovement.StatusId
                    WHERE (COALESCE (MIFloat_MovementId.ValueData,0) = 0 AND inisEmpty = TRUE)
                        OR inisEmpty = FALSE
                   )

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
                                     , CASE WHEN Object_Product.isErased = TRUE THEN '--- ' || Object_Product.ValueData ELSE Object_Product.ValueData END :: TVarChar AS ProductName
                                     , Object_Brand.Id                            AS BrandId
                                     , Object_Brand.ValueData                     AS BrandName
                                     , ObjectString_CIN.ValueData                 AS CIN
                                     , MovementString_Comment.ValueData :: TVarChar AS Comment

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
                                )

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

  -- из заказа поставщику, цена по которой заказали
  , tmpMI_OpderPartner AS (SELECT MovementItem.MovementId
                                , MovementItem.ObjectId       AS GoodsId
                                , MIFloat_OperPrice.ValueData AS OperPrice
                           FROM tmpMovement_OrderPartner AS Movement
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE
                                INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
 
                                LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                            ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                           AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                           )

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
                       
  , tmpMIFloat AS (SELECT MovementItemFloat.*
                   FROM MovementItemFloat
                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Child.MovementItemId FROM tmpMI_Child)
                     AND MovementItemFloat.DescId IN (zc_MIFloat_AmountPartner()
                                                    , zc_MIFloat_CountForPrice()
                                                    , zc_MIFloat_OperPrice()
                                                    )
                  )

      -- Результат
      SELECT tmpMI_Child.MovementId
           , tmpMI_Child.OperDate
           , tmpMI_Child.InvNumber
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
           , tmpMovement_OrderClient.Comment   :: TVarChar
           , tmpMovement_OrderClient.MovementId_Invoice
           , tmpMovement_OrderClient.InvNumber_Invoice
           -- заказ поставщику
           , tmpMovement_OrderPartner.Id           AS MovementId_OrderPartner
           , tmpMovement_OrderPartner.OperDate     AS OperDate_OrderPartner
           , tmpMovement_OrderPartner.InvNumber    AS InvNumber_OrderPartner
           , tmpMovement_OrderPartner.OperDatePartner   AS OperDatePartner_OrderPartner
           , tmpMovement_OrderPartner.InvNumberPartner  AS InvNumberPartner_OrderPartner
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
           , Object_Partner.ValueData AS PartnerName
           , tmpMI_Child.Amount
           , MIFloat_AmountPartner.ValueData ::TFloat AS AmountPartner     -- Количество заказ поставщику
           , MIFloat_OperPrice.ValueData     ::TFloat AS OperPrice         -- Цена вх без НДС
           , COALESCE (MIFloat_CountForPrice.ValueData,1) ::TFloat AS CountForPrice     --
           , zfCalc_SummIn (MIFloat_AmountPartner.ValueData, MIFloat_OperPrice.ValueData, COALESCE (MIFloat_CountForPrice.ValueData,1))  ::TFloat AS Summ
           , tmpMI_OpderPartner.OperPrice ::TFloat AS OperPrice_OpderPartner
           , tmpMI_Child.GoodsId
           , tmpGoodsParams.GoodsCode
           , tmpGoodsParams.GoodsName
           , tmpGoodsParams.Article
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
           LEFT JOIN tmpMovement_OrderClient ON tmpMovement_OrderClient.MovementId = tmpMI_Child.MovementId
           LEFT JOIN tmpMovement_OrderPartner ON tmpMovement_OrderPartner.Id = tmpMI_Child.MovementId_OrderPartner
           LEFT JOIN tmpMI_OpderPartner ON tmpMI_OpderPartner.MovementId = tmpMovement_OrderPartner.Id
                                       AND tmpMI_OpderPartner.GoodsId = tmpMI_Child.GoodsId
           LEFT JOIN tmpGoodsParams ON tmpGoodsParams.GoodsId = tmpMI_Child.GoodsId

           LEFT JOIN Object AS Object_Partner ON Object_Partner.Id   = tmpMI_Child.PartnerId

           LEFT JOIN tmpMIFloat AS MIFloat_AmountPartner
                                ON MIFloat_AmountPartner.MovementItemId = tmpMI_Child.MovementItemId
                               AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
           LEFT JOIN tmpMIFloat AS MIFloat_OperPrice
                                ON MIFloat_OperPrice.MovementItemId = tmpMI_Child.MovementItemId
                               AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
           LEFT JOIN tmpMIFloat AS MIFloat_CountForPrice
                                ON MIFloat_CountForPrice.MovementItemId = tmpMI_Child.MovementItemId
                               AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
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
-- select * from gpReport_OrderClient(inStartDate := ('01.01.2020')::TDateTime , inEndDate := ('03.05.2021')::TDateTime , inPartnerId := 0 , inGoodsId := 0 , inisEmpty := FALSE, inSession := '5');