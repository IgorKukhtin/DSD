-- Function: gpSelect_Movement_OrderClientChoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderClient_Item (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderClient_Item (TDateTime, TDateTime, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderClient_Item(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inClientId      Integer  , 
    IN inIsChildOnly   Boolean  ,  -- показать только  zc_MI_Child
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumber_Full  TVarChar, InvNumberPartner TVarChar
             , BarCode TVarChar
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , PriceWithVAT Boolean
             , VATPercent TFloat, DiscountTax TFloat, DiscountNextTax TFloat
             , TotalCount TFloat
             , TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat, TotalSummVAT TFloat
             , SummDiscount_total TFloat
             , FromId Integer, FromCode Integer, FromName TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ProductId Integer, ProductName TVarChar, BrandId Integer, BrandName TVarChar, CIN TVarChar, EngineNum TVarChar, EngineName TVarChar
             , Comment TVarChar
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar, Comment_Invoice TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime   
 
              -- строки
             , MovementItemId Integer
             , ObjectId  Integer
             , ObjectCode  Integer
             , Article_Object  TVarChar
             , ObjectName  TVarChar
             , DescName  TVarChar
             , Comment_goods  TVarChar

             , GoodsId_basis    Integer
             , GoodsCode_basis  Integer
             , GoodsName_basis  TVarChar
             , Article_basis    TVarChar

             , ReceiptGoodsId   Integer
             , ReceiptGoodsCode Integer
             , ReceiptGoodsName TVarChar

             , PartnerId        Integer
             , PartnerName      TVarChar
             , Amount_basis     TFloat
             , Value_service    TFloat
             , Amount_partner   TFloat
             , isErased         Boolean             
              )

AS
$BODY$
   DECLARE vbObjectId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN
     --inIsChildOnly:= TRUE;
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderClient());

     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        , Movement_OrderClient AS ( SELECT Movement_OrderClient.Id
                                    , Movement_OrderClient.InvNumber
                                    , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
                                    , Movement_OrderClient.OperDate             AS OperDate
                                    , Movement_OrderClient.StatusId             AS StatusId
                                    , MovementLinkObject_To.ObjectId            AS ToId
                                    , MovementLinkObject_From.ObjectId          AS FromId
                                    , MovementLinkObject_PaidKind.ObjectId      AS PaidKindId
                                    , MovementLinkObject_Product.ObjectId       AS ProductId
                                    , MovementLinkMovement_Invoice.MovementChildId AS MovementId_Invoice
                               FROM tmpStatus
                                    INNER JOIN Movement AS Movement_OrderClient
                                                        ON Movement_OrderClient.StatusId = tmpStatus.StatusId
                                                       AND Movement_OrderClient.OperDate BETWEEN inStartDate AND inEndDate
                                                       AND Movement_OrderClient.DescId = zc_Movement_OrderClient()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                 ON MovementLinkObject_To.MovementId = Movement_OrderClient.Id
                                                                AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = Movement_OrderClient.Id
                                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                                 ON MovementLinkObject_PaidKind.MovementId = Movement_OrderClient.Id
                                                                AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                                                 ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                                                AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()

                                    LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                             ON MovementString_InvNumberPartner.MovementId = Movement_OrderClient.Id
                                                            AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

                                    LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Invoice
                                                                   ON MovementLinkMovement_Invoice.MovementId = Movement_OrderClient.Id
                                                                  AND MovementLinkMovement_Invoice.DescId = zc_MovementLinkMovement_Invoice()
                               WHERE MovementLinkObject_From.ObjectId = inClientId
                                  OR inClientId = 0
                              )
   , tmpMI_all AS (--
                   SELECT MovementItem.Id
                        , MovementItem.MovementId
                        , MovementItem.ParentId
                        , MovementItem.DescId
                        , MovementItem.ObjectId
                        , MovementItem.Amount
                        , MovementItem.isErased
                          -- узел
                        , MILinkObject_Goods.ObjectId AS GoodsId
                          -- "виртуальный" узел
                        , MILinkObject_Goods_basis.ObjectId AS GoodsId_basis
    
                   FROM Movement_OrderClient AS Movement
                        INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                               AND MovementItem.isErased   = FALSE
                                               AND MovementItem.DescId     IN (zc_MI_Child(), zc_MI_Detail())
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                         ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods_basis
                                                         ON MILinkObject_Goods_basis.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_Goods_basis.DescId         = zc_MILinkObject_GoodsBasis()
                  )
       , tmpMI AS (--
                   SELECT tmpMI_all.Id
                        , tmpMI_all.MovementId
                        , tmpMI_all.DescId
                        , tmpMI_all.ParentId
                        , tmpMI_all.ObjectId
                        , tmpMI_all.Amount
                        , tmpMI_all.isErased
                          -- узел
                        , tmpMI_all.GoodsId
                          -- "виртуальный" узел
                        , tmpMI_all.GoodsId_basis
                   FROM tmpMI_all
                  UNION ALL
                   SELECT DISTINCT
                          tmpMI_parent.Id
                        , tmpMI_all.MovementId
                        , zc_MI_Child() AS DescId
                        , 0 AS ParentId
                        , tmpMI_all.GoodsId_basis AS ObjectId
                        , 1 :: TFloat AS Amount
                        , tmpMI_all.isErased
                          -- узел
                        , tmpMI_all.GoodsId_basis AS GoodsId
                          -- "виртуальный" узел
                        , 0 AS GoodsId_basis
                   FROM tmpMI_all
                        JOIN tmpMI_all AS tmpMI_parent ON tmpMI_parent.ObjectId = tmpMI_all.GoodsId
                   WHERE tmpMI_all.DescId = zc_MI_Detail()
                     AND inIsChildOnly = TRUE
                  )

 , tmpItem AS (SELECT Movement.Id                                                         AS MovementId
                    , MovementItem.DescId                                                 AS DescId_mi
                    , MovementItem.Id                                                     AS MovementItemId
                    , COALESCE (MovementItem.ParentId, 0)                                 AS ParentId
                    , 0                                                                   AS PartionId
                    , MILinkObject_Unit.ObjectId                                          AS UnitId
                    , MILinkObject_Partner.ObjectId                                       AS PartnerId
                                                                                          
                      -- 
                    , COALESCE (MILinkObject_Goods.ObjectId, 0)                           AS GoodsId
                      -- какой Узел собирается
                    , MovementItem.ObjectId                                               AS ObjectId
       
                      -- какой узел был в ReceiptProdModel или какой "Виртуальный" Узел собирается
                    , COALESCE (MILinkObject_Goods_basis.ObjectId, 0)                     AS ObjectId_basis
       
                      -- только для zc_MI_Detail
                    , COALESCE (MILinkObject_ReceiptLevel.ObjectId, 0)                    AS ReceiptLevelId
       
                      --
                    , MILinkObject_ProdOptions.ObjectId                                   AS ProdOptionsId
                    , MILinkObject_ColorPattern.ObjectId                                  AS ColorPatternId
                    , MILinkObject_ProdColorPattern.ObjectId                              AS ProdColorPatternId
                                                                                          
                    , MovementItem.Amount                                                 AS Amount
                    , MIFloat_AmountPartner.ValueData                                     AS AmountPartner
                    , MIFloat_OperPrice.ValueData                                         AS OperPrice
                    , MIFloat_OperPricePartner.ValueData                                  AS OperPricePartner
       
                    , MovementItem.isErased
       
               FROM Movement_OrderClient AS Movement
                    INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND ((MovementItem.DescId = zc_MI_Detail() AND inIsChildOnly = FALSE)
                                                      OR (MovementItem.DescId = zc_MI_Child()  AND inIsChildOnly = TRUE)
                                                        )
                      -- !!! временно для отладки
                    --LEFT JOIN MovementString AS MS ON MS.MovementId = inMovementId AND MS.DescId = zc_MovementString_Comment()
                    LEFT JOIN (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmpMI_group ON tmpMI_group.GoodsId = MovementItem.ObjectId
       
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                     ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_Partner.DescId         = zc_MILinkObject_Partner()
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                     ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                     ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods_basis
                                                     ON MILinkObject_Goods_basis.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_Goods_basis.DescId         = zc_MILinkObject_GoodsBasis()
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdOptions
                                                     ON MILinkObject_ProdOptions.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_ColorPattern
                                                     ON MILinkObject_ColorPattern.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_ColorPattern.DescId         = zc_MILinkObject_ColorPattern()
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdColorPattern
                                                     ON MILinkObject_ProdColorPattern.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_ProdColorPattern.DescId         = zc_MILinkObject_ProdColorPattern()
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptLevel
                                                     ON MILinkObject_ReceiptLevel.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_ReceiptLevel.DescId         = zc_MILinkObject_ReceiptLevel()
                    LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                               AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                    LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                               AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()
                    LEFT JOIN MovementItemFloat AS MIFloat_OperPricePartner
                                                ON MIFloat_OperPricePartner.MovementItemId = MovementItem.Id
                                               AND MIFloat_OperPricePartner.DescId         = zc_MIFloat_OperPricePartner()
               WHERE (MILinkObject_ProdOptions.ObjectId IS NULL AND tmpMI_group.GoodsId > 0 AND inIsChildOnly = TRUE)
                  OR inIsChildOnly = FALSE
              )

   , tmpReceiptGoods AS (SELECT tmpItem.ObjectId         AS GoodsId
                              , Object_ReceiptGoods.Id   AS ReceiptGoodsId
                         FROM tmpItem
                              -- нашли его в сборке узлов
                              INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods_Object
                                                    ON ObjectLink_ReceiptGoods_Object.ChildObjectId = tmpItem.ObjectId
                                                   AND ObjectLink_ReceiptGoods_Object.DescId        = zc_ObjectLink_ReceiptGoods_Object()
                              -- не удален
                              INNER JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id       = ObjectLink_ReceiptGoods_Object.ObjectId
                                                                      AND Object_ReceiptGoods.isErased = FALSE
                              -- это главный шаблон сборки узлов
                              INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                       ON ObjectBoolean_Main.ObjectId  = ObjectLink_ReceiptGoods_Object.ObjectId
                                                      AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_ReceiptGoods_Main()
                                                      AND ObjectBoolean_Main.ValueData = TRUE
                        UNION
                         SELECT DISTINCT
                                ObjectLink_GoodsChild.ChildObjectId AS GoodsId
                              , Object_ReceiptGoods.Id              AS ReceiptGoodsId
                         FROM Object AS Object_ReceiptGoods
                              -- это главный шаблон сборки узлов
                              INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                       ON ObjectBoolean_Main.ObjectId  = Object_ReceiptGoods.Id
                                                      AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_ReceiptGoods_Main()
                                                      AND ObjectBoolean_Main.ValueData = TRUE

                              -- из чего состоит
                              INNER JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_ReceiptGoods
                                                    ON ObjectLink_ReceiptGoodsChild_ReceiptGoods.ChildObjectId = Object_ReceiptGoods.Id
                                                   AND ObjectLink_ReceiptGoodsChild_ReceiptGoods.DescId        = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                              -- не удален
                              INNER JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id       = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                                           AND Object_ReceiptGoodsChild.isErased = FALSE
                              -- GoodsChild
                              INNER JOIN ObjectLink AS ObjectLink_GoodsChild
                                                    ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                                   AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
                              -- значение в сборке
                              LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                    ON ObjectFloat_Value.ObjectId = Object_ReceiptGoodsChild.Id
                                                   AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptGoodsChild_Value()

                         WHERE Object_ReceiptGoods.DescId   = zc_Object_ReceiptGoods()
                           -- не удален
                           AND Object_ReceiptGoods.isErased = FALSE
                        )
        -- Результат
        SELECT Movement_OrderClient.Id
             , zfConvert_StringToNumber (Movement_OrderClient.InvNumber) AS InvNumber
             , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumber_Full
             , Movement_OrderClient.InvNumberPartner
             , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement_OrderClient.Id) AS BarCode
             , Movement_OrderClient.OperDate
             , Object_Status.ObjectCode                   AS StatusCode
             , Object_Status.ValueData                    AS StatusName

             , MovementBoolean_PriceWithVAT.ValueData     AS PriceWithVAT
             , MovementFloat_VATPercent.ValueData         AS VATPercent
             , MovementFloat_DiscountTax.ValueData        AS DiscountTax
             , MovementFloat_DiscountNextTax.ValueData    AS DiscountNextTax
             , MovementFloat_TotalCount.ValueData         AS TotalCount
             , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
             , MovementFloat_TotalSummPVAT.ValueData      AS TotalSummPVAT
             , MovementFloat_TotalSumm.ValueData          AS TotalSumm
             , (COALESCE (MovementFloat_TotalSummPVAT.ValueData,0) - COALESCE (MovementFloat_TotalSumm.ValueData,0)) :: TFloat AS TotalSummVAT
             --, (zfCalc_SummDiscount (COALESCE (MovementFloat_TotalSummMVAT.ValueData,0), COALESCE (MovementFloat_DiscountTax.ValueData,0) + COALESCE (MovementFloat_DiscountNextTax.ValueData,0) ) ) :: TFloat AS SummDiscount_total
             , (COALESCE (MovementFloat_TotalSummMVAT.ValueData,0) - COALESCE (MovementFloat_TotalSumm.ValueData,0)) :: TFloat AS SummDiscount_total

             , Object_From.Id                             AS FromId
             , Object_From.ObjectCode                     AS FromCode
             , Object_From.ValueData                      AS FromName
             , Object_To.Id                               AS ToId
             , Object_To.ObjectCode                       AS ToCode
             , Object_To.ValueData                        AS ToName
             , Object_PaidKind.Id                         AS PaidKindId
             , Object_PaidKind.ValueData                  AS PaidKindName
             , Object_Product.Id                          AS ProductId
             , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName
             , Object_Brand.Id                            AS BrandId
             , Object_Brand.ValueData                     AS BrandName
             , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,       Object_Product.isErased) AS CIN
             , zfCalc_ValueData_isErased (ObjectString_EngineNum.ValueData, Object_Product.isErased) AS EngineNum
             , Object_Engine.ValueData                    AS EngineName
             , MovementString_Comment.ValueData :: TVarChar AS Comment

             , Movement_Invoice.Id               AS MovementId_Invoice
             , zfCalc_InvNumber_isErased ('', Movement_Invoice.InvNumber, Movement_Invoice.OperDate, Movement_Invoice.StatusId) AS InvNumber_Invoice
             , MovementString_Comment_Invoice.ValueData AS Comment_Invoice

             , Object_Insert.ValueData              AS InsertName
             , MovementDate_Insert.ValueData        AS InsertDate
             , Object_Update.ValueData              AS UpdateName
             , MovementDate_Update.ValueData        AS UpdateDate

             -- строки
            , tmpItem.MovementItemId       :: Integer AS MovementItemId
           --, tmpItem.ObjectId                       AS KeyId

           , Object_Object.Id                         AS ObjectId
           , Object_Object.ObjectCode                 AS ObjectCode
           , ObjectString_Article_Object.ValueData    AS Article_Object
           , Object_Object.ValueData                  AS ObjectName
           , ObjectDesc_Object.ItemName               AS DescName
           , ObjectString_Goods_Comment.ValueData     AS Comment_goods

           , Object_Object_basis.Id                   AS GoodsId_basis
           , Object_Object_basis.ObjectCode           AS GoodsCode_basis
           , Object_Object_basis.ValueData            AS GoodsName_basis
           , ObjectString_Article_basis.ValueData     AS Article_basis

           , Object_ReceiptGoods.Id                   AS ReceiptGoodsId
           , Object_ReceiptGoods.ObjectCode           AS ReceiptGoodsCode
           , Object_ReceiptGoods.ValueData            AS ReceiptGoodsName

           , Object_Partner.Id                        AS PartnerId
           , Object_Partner.ValueData                 AS PartnerName

             -- Количество шаблон сборки
           , tmpItem.Amount                          AS Amount_basis
             -- работы/услуги
           , CASE WHEN ObjectDesc_Object.Id = zc_Object_ReceiptService() THEN tmpItem.Amount ELSE 0 END ::TFloat   AS Value_service
             -- Количество заказ поставщику
           , tmpItem.AmountPartner                   AS Amount_partner

           , tmpItem.isErased

        FROM Movement_OrderClient

             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_OrderClient.StatusId
             LEFT JOIN Object AS Object_From   ON Object_From.Id   = Movement_OrderClient.FromId
             LEFT JOIN Object AS Object_To     ON Object_To.Id     = Movement_OrderClient.ToId
             LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Movement_OrderClient.PaidKindId
             LEFT JOIN Object AS Object_Product  ON Object_Product.Id  = Movement_OrderClient.ProductId
             LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = Movement_OrderClient.MovementId_Invoice

             LEFT JOIN MovementString AS MovementString_Comment_Invoice
                                      ON MovementString_Comment_Invoice.MovementId = Movement_Invoice.Id
                                     AND MovementString_Comment_Invoice.DescId = zc_MovementString_Comment()

             LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                     ON MovementFloat_TotalCount.MovementId = Movement_OrderClient.Id
                                    AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

             LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                     ON MovementFloat_TotalSumm.MovementId = Movement_OrderClient.Id
                                    AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

             LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                     ON MovementFloat_VATPercent.MovementId = Movement_OrderClient.Id
                                    AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

             LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                     ON MovementFloat_DiscountTax.MovementId = Movement_OrderClient.Id
                                    AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()
             LEFT JOIN MovementFloat AS MovementFloat_DiscountNextTax
                                     ON MovementFloat_DiscountNextTax.MovementId = Movement_OrderClient.Id
                                    AND MovementFloat_DiscountNextTax.DescId = zc_MovementFloat_DiscountNextTax()

             LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                     ON MovementFloat_TotalSummPVAT.MovementId = Movement_OrderClient.Id
                                    AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

             LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                     ON MovementFloat_TotalSummMVAT.MovementId = Movement_OrderClient.Id
                                    AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

             LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                       ON MovementBoolean_PriceWithVAT.MovementId = Movement_OrderClient.Id
                                      AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

             LEFT JOIN MovementString AS MovementString_Comment
                                      ON MovementString_Comment.MovementId = Movement_OrderClient.Id
                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()

             LEFT JOIN MovementDate AS MovementDate_Insert
                                    ON MovementDate_Insert.MovementId = Movement_OrderClient.Id
                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
             LEFT JOIN MovementLinkObject AS MLO_Insert
                                          ON MLO_Insert.MovementId = Movement_OrderClient.Id
                                         AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
             LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

             LEFT JOIN MovementDate AS MovementDate_Update
                                    ON MovementDate_Update.MovementId = Movement_OrderClient.Id
                                   AND MovementDate_Update.DescId = zc_MovementDate_Update()
             LEFT JOIN MovementLinkObject AS MLO_Update
                                          ON MLO_Update.MovementId = Movement_OrderClient.Id
                                         AND MLO_Update.DescId = zc_MovementLinkObject_Update()
             LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

             --
             LEFT JOIN ObjectString AS ObjectString_CIN
                                    ON ObjectString_CIN.ObjectId = Object_Product.Id
                                   AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()
             LEFT JOIN ObjectString AS ObjectString_EngineNum
                                    ON ObjectString_EngineNum.ObjectId = Object_Product.Id
                                   AND ObjectString_EngineNum.DescId   = zc_ObjectString_Product_EngineNum()
             LEFT JOIN ObjectLink AS ObjectLink_Engine
                                  ON ObjectLink_Engine.ObjectId = Object_Product.Id
                                 AND ObjectLink_Engine.DescId   = zc_ObjectLink_Product_Engine()
             LEFT JOIN Object AS Object_Engine ON Object_Engine.Id = ObjectLink_Engine.ChildObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Brand
                                  ON ObjectLink_Brand.ObjectId = Object_Product.Id
                                 AND ObjectLink_Brand.DescId = zc_ObjectLink_Product_Brand()
             LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId       

             --- строки
             INNER JOIN tmpItem  ON tmpItem.MovementId = Movement_OrderClient.Id
             LEFT JOIN Object AS Object_Object ON Object_Object.Id = tmpItem.ObjectId
             
             LEFT JOIN tmpReceiptGoods ON tmpReceiptGoods.GoodsId = tmpItem.ObjectId
             LEFT JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id = tmpReceiptGoods.ReceiptGoodsId
 
            LEFT JOIN ObjectString AS ObjectString_Article_object
                                   ON ObjectString_Article_object.ObjectId = Object_Object.Id
                                  AND ObjectString_Article_object.DescId   = zc_ObjectString_Article()
            LEFT JOIN ObjectDesc AS ObjectDesc_Object ON ObjectDesc_Object.Id = Object_Object.DescId

            LEFT JOIN Object AS Object_Object_basis ON Object_Object_basis.Id = tmpItem.ObjectId_basis
            LEFT JOIN ObjectString AS ObjectString_Article_basis
                                   ON ObjectString_Article_basis.ObjectId = Object_Object_basis.Id
                                  AND ObjectString_Article_basis.DescId   = zc_ObjectString_Article()

            LEFT JOIN ObjectString AS ObjectString_Goods_Comment
                                   ON ObjectString_Goods_Comment.ObjectId = Object_Object.Id
                                  AND ObjectString_Goods_Comment.DescId   = zc_ObjectString_Goods_Comment()

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpItem.UnitId

            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                   ON ObjectString_GoodsGroupFull.ObjectId = tmpItem.ObjectId
                                  AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
            
            LEFT JOIN Object AS Object_Partner     ON Object_Partner.Id     = tmpItem.PartnerId
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.12.22         *
*/


-- тест
-- SELECT * FROM gpSelect_Movement_OrderClient_Item (inStartDate:= '01.01.2022', inEndDate:= '31.12.2022', inClientId:=0 , inIsChildOnly:=FALSE, inIsErased := FALSE, inSession:= zfCalc_UserAdmin())
