-- Function: gpSelect_Movement_OrderClientChoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderClient_Item (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderClient_Item (TDateTime, TDateTime, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderClient_Item(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inClientId      Integer   ,
    IN inIsChildOnly   Boolean   , -- показать только  Узлы
    IN inIsErased      Boolean   ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumber_Full  TVarChar, InvNumberPartner TVarChar
             , BarCode TVarChar
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , NPP TFloat
             , FromId Integer, FromCode Integer, FromName TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ProductId Integer, ProductName TVarChar, ModelName TVarChar, BrandId Integer, BrandName TVarChar, CIN TVarChar, EngineNum TVarChar, EngineName TVarChar
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

             , Amount_basis     TFloat
             , isErased         Boolean
             , StateText TVarChar, StateColor Integer
              )

AS
$BODY$
   DECLARE vbObjectId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderClient());
     vbUserId:= lpGetUserBySession (inSession);


     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
          -- Заказ Клиента
        , tmpMovement_OrderClient AS (SELECT Movement_OrderClient.Id
                                           , Movement_OrderClient.InvNumber
                                           , MovementString_InvNumberPartner.ValueData    AS InvNumberPartner
                                           , Movement_OrderClient.OperDate                AS OperDate
                                           , Movement_OrderClient.StatusId                AS StatusId
                                           , MovementLinkObject_To.ObjectId               AS ToId
                                           , MovementLinkObject_From.ObjectId             AS FromId
                                           , MovementLinkObject_PaidKind.ObjectId         AS PaidKindId
                                           , MovementLinkObject_Product.ObjectId          AS ProductId
                                           , MovementLinkMovement_Invoice.MovementChildId AS MovementId_Invoice
                                      FROM tmpStatus
                                           INNER JOIN Movement AS Movement_OrderClient
                                                               ON Movement_OrderClient.StatusId = tmpStatus.StatusId
                                                              AND Movement_OrderClient.OperDate BETWEEN inStartDate AND inEndDate
                                                              AND Movement_OrderClient.DescId   = zc_Movement_OrderClient()

                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                        ON MovementLinkObject_To.MovementId = Movement_OrderClient.Id
                                                                       AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()

                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                        ON MovementLinkObject_From.MovementId = Movement_OrderClient.Id
                                                                       AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()

                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                                        ON MovementLinkObject_PaidKind.MovementId = Movement_OrderClient.Id
                                                                       AND MovementLinkObject_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()

                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                                                        ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                                                       AND MovementLinkObject_Product.DescId     = zc_MovementLinkObject_Product()

                                           LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                                    ON MovementString_InvNumberPartner.MovementId = Movement_OrderClient.Id
                                                                   AND MovementString_InvNumberPartner.DescId     = zc_MovementString_InvNumberPartner()

                                           LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Invoice
                                                                          ON MovementLinkMovement_Invoice.MovementId = Movement_OrderClient.Id
                                                                         AND MovementLinkMovement_Invoice.DescId     = zc_MovementLinkMovement_Invoice()
                                      WHERE MovementLinkObject_From.ObjectId = inClientId
                                         OR inClientId = 0
                                     )
   , tmpMI_all AS (--
                   SELECT MovementItem.Id
                        , MovementItem.MovementId
                        , MovementItem.DescId
                        , MovementItem.Amount
                          -- Узел / Комплектующие
                        , MovementItem.ObjectId
                          -- какой Узел собирается - только для zc_MI_Detail
                        , MILinkObject_Goods.ObjectId AS GoodsId
                          -- "базовый" или "виртуальный-ПФ" Узел
                        , MILinkObject_Goods_basis.ObjectId AS GoodsId_basis

                   FROM tmpMovement_OrderClient AS Movement
                        INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                               AND MovementItem.isErased   = FALSE
                                               AND MovementItem.DescId     IN (zc_MI_Child(), zc_MI_Detail())
                        -- какой Узел собирается
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                         ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                                                        -- для этого элемента
                                                        AND MovementItem.DescId               = zc_MI_Detail()
                        -- "базовый" или "виртуальный-ПФ" Узел
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods_basis
                                                         ON MILinkObject_Goods_basis.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_Goods_basis.DescId         = zc_MILinkObject_GoodsBasis()
                  )
       , tmpMI AS (-- только узлы
                   SELECT tmpMI_all.Id
                        , tmpMI_all.MovementId
                        , tmpMI_all.DescId
                          -- Узел
                        , tmpMI_all.ObjectId
                          -- тот же самый
                        , tmpMI_all.ObjectId AS ObjectId_orig
                          --
                        , tmpMI_all.Amount
                          -- "базовый" Узел
                        , tmpMI_all.GoodsId_basis
                   FROM tmpMI_all
                        -- если Узел собирается
                        JOIN (SELECT DISTINCT tmpMI_all.MovementId, tmpMI_all.GoodsId FROM tmpMI_all WHERE tmpMI_all.DescId = zc_MI_Detail()
                             ) AS tmpMI_Detail
                               ON tmpMI_Detail.MovementId = tmpMI_all.MovementId
                              AND tmpMI_Detail.GoodsId    = tmpMI_all.ObjectId
                   WHERE tmpMI_all.DescId = zc_MI_Child()
                     -- показать только  Узлы
                     AND inIsChildOnly = TRUE

                  UNION ALL
                   -- "виртуальный-ПФ" Узел
                   SELECT DISTINCT
                          tmpMI_all.Id
                        , tmpMI_all.MovementId
                        , tmpMI_all.DescId
                          -- "виртуальный-ПФ" Узел
                        , tmpMI_Detail.GoodsId_basis AS ObjectId
                          -- Узел
                        , tmpMI_all.ObjectId AS ObjectId_orig
                          --
                        , 1 :: TFloat AS Amount
                          -- "базовый" Узел
                        , tmpMI_all.GoodsId_basis
                   FROM tmpMI_all
                        -- если Узел собирается
                        JOIN (SELECT DISTINCT tmpMI_all.MovementId, tmpMI_all.GoodsId, tmpMI_all.GoodsId_basis FROM tmpMI_all
                              WHERE tmpMI_all.DescId = zc_MI_Detail()
                                -- установлен "виртуальный-ПФ"
                               AND  tmpMI_all.GoodsId_basis > 0
                             ) AS tmpMI_Detail
                               ON tmpMI_Detail.MovementId = tmpMI_all.MovementId
                              AND tmpMI_Detail.GoodsId    = tmpMI_all.ObjectId
                   WHERE tmpMI_all.DescId = zc_MI_Child()
                     -- показать только  Узлы
                     AND inIsChildOnly = TRUE

                  UNION ALL
                   -- Комплектующие для сборки
                   SELECT tmpMI_all.Id
                        , tmpMI_all.MovementId
                        , tmpMI_all.DescId
                          -- Комплектующие
                        , tmpMI_all.ObjectId
                          -- Узел
                        , CASE WHEN tmpMI_all.GoodsId_basis < 0 THEN tmpMI_all.GoodsId_basis ELSE tmpMI_all.GoodsId END AS ObjectId_orig
                          --
                        , tmpMI_all.Amount
                          -- "базовый" Узел
                        , tmpMI_Child.GoodsId_basis
                   FROM tmpMI_all
                        -- Узел
                        JOIN (SELECT DISTINCT tmpMI_all.MovementId, tmpMI_all.ObjectId, tmpMI_all.GoodsId_basis FROM tmpMI_all
                              WHERE tmpMI_all.DescId = zc_MI_Child()
                             ) AS tmpMI_Child
                               ON tmpMI_Child.MovementId = tmpMI_all.MovementId
                              AND tmpMI_Child.ObjectId   = tmpMI_all.GoodsId
                   WHERE tmpMI_all.DescId = zc_MI_Detail()
                     -- показать только НЕ Узлы
                     AND inIsChildOnly = FALSE
                  )

 , tmpItem AS (SELECT MovementItem.MovementId AS MovementId
                    , MovementItem.Id         AS MovementItemId
                    , MovementItem.DescId     AS DescId
                    , MovementItem.Amount     AS Amount
                      -- Узел или "виртуальный-ПФ" Узел или Комплектующие
                    , MovementItem.ObjectId
                      -- Узел
                    , MovementItem.ObjectId_orig
                      -- "базовый" Узел
                    , MovementItem.GoodsId_basis

                      -- только для zc_MI_Detail
                    , COALESCE (MILinkObject_ReceiptLevel.ObjectId, 0)      AS ReceiptLevelId
                    , COALESCE (MILinkObject_ProdOptions.ObjectId, 0)       AS ProdOptionsId
                    , COALESCE (MILinkObject_ColorPattern.ObjectId, 0)      AS ColorPatternId
                    , COALESCE (MILinkObject_ProdColorPattern.ObjectId, 0)  AS ProdColorPatternId

               FROM tmpMI AS MovementItem
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptLevel
                                                     ON MILinkObject_ReceiptLevel.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_ReceiptLevel.DescId         = zc_MILinkObject_ReceiptLevel()
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdOptions
                                                     ON MILinkObject_ProdOptions.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_ColorPattern
                                                     ON MILinkObject_ColorPattern.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_ColorPattern.DescId         = zc_MILinkObject_ColorPattern()
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdColorPattern
                                                     ON MILinkObject_ProdColorPattern.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_ProdColorPattern.DescId         = zc_MILinkObject_ProdColorPattern()
              )
     -- Шаблон сборки Узла
   , tmpReceiptGoods AS (SELECT tmpItem.ObjectId_orig  AS ObjectId_orig
                              , Object_ReceiptGoods.Id AS ReceiptGoodsId
                         FROM (SELECT DISTINCT tmpItem.ObjectId_orig FROM tmpItem) AS tmpItem
                              -- нашли его в сборке узлов
                              INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods_Object
                                                    ON ObjectLink_ReceiptGoods_Object.ChildObjectId = tmpItem.ObjectId_orig
                                                   AND ObjectLink_ReceiptGoods_Object.DescId        = zc_ObjectLink_ReceiptGoods_Object()
                              -- не удален
                              INNER JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id       = ObjectLink_ReceiptGoods_Object.ObjectId
                                                                      AND Object_ReceiptGoods.isErased = FALSE
                              -- это главный шаблон сборки узлов
                              INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                       ON ObjectBoolean_Main.ObjectId  = ObjectLink_ReceiptGoods_Object.ObjectId
                                                      AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_ReceiptGoods_Main()
                                                      AND ObjectBoolean_Main.ValueData = TRUE
                        )
            -- Проведенные Заказ производство и Производство-сборка
          , tmpMIFloat_MovementId AS (SELECT MIFloat_MovementId.ValueData :: Integer AS MovementId_OrderClient
                                           , Movement.DescId
                                           , MovementItem.ObjectId
                                           , Object.DescId AS ObjectDescId
                                           , MAX (Movement.Id) AS MovementId
                                      FROM MovementItemFloat AS MIFloat_MovementId
                                           JOIN MovementItem ON MovementItem.Id       = MIFloat_MovementId.MovementItemId
                                                            AND MovementItem.isErased = FALSE
                                                            AND MovementItem.DescId   = zc_MI_Master()
                                           LEFT JOIN Object ON Object.Id = MovementItem.ObjectId

                                           JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                                                        AND Movement.DescId   IN (zc_Movement_ProductionUnion(), zc_Movement_OrderInternal())

                                      WHERE MIFloat_MovementId.MovementItemId = MovementItem.Id
                                        AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                        AND MIFloat_MovementId.ValueData IN (SELECT DISTINCT tmpMovement_OrderClient.Id :: TFloat FROM tmpMovement_OrderClient)
                                      GROUP BY MIFloat_MovementId.ValueData
                                             , Movement.DescId
                                             , MovementItem.ObjectId
                                             , Object.DescId
                              )
        -- Результат
        SELECT tmpMovement_OrderClient.Id
             , zfConvert_StringToNumber (tmpMovement_OrderClient.InvNumber) AS InvNumber
             , zfCalc_InvNumber_isErased ('', tmpMovement_OrderClient.InvNumber, tmpMovement_OrderClient.OperDate, tmpMovement_OrderClient.StatusId) AS InvNumber_Full
             , tmpMovement_OrderClient.InvNumberPartner
             , zfFormat_BarCode (zc_BarCodePref_Movement(), tmpMovement_OrderClient.Id) AS BarCode
             , tmpMovement_OrderClient.OperDate
             , Object_Status.ObjectCode                   AS StatusCode
             , Object_Status.ValueData                    AS StatusName

             , COALESCE (MovementFloat_NPP.ValueData,0) ::TFloat AS NPP

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
             , Object_Model.ValueData                     AS ModelName
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

               -- Количество шаблон сборки
             , tmpItem.Amount                          AS Amount_basis

             , FALSE :: Boolean AS isErased

               -- Состояние
             , zfCalc_Order_State (CASE WHEN COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() THEN FALSE ELSE TRUE END
                                 , MovementFloat_NPP.ValueData :: Integer
                                 , COALESCE (tmpOrderInternal_1.MovementId, tmpOrderInternal_2.MovementId)
                                 , COALESCE (tmpProductionUnion_1.MovementId, tmpProductionUnion_2.MovementId)
                                 , COALESCE (tmpOrderInternal_1.ObjectDescId, tmpOrderInternal_2.ObjectDescId)
                                 , COALESCE (tmpProductionUnion_1.ObjectDescId, tmpProductionUnion_2.ObjectDescId)
                                  ) AS StateText
               -- все состояния подсветить
             , zfCalc_Order_State_color (CASE WHEN COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() THEN FALSE ELSE TRUE END
                                       , MovementFloat_NPP.ValueData :: Integer
                                       , COALESCE (tmpOrderInternal_1.MovementId, tmpOrderInternal_2.MovementId)
                                       , COALESCE (tmpProductionUnion_1.MovementId, tmpProductionUnion_2.MovementId)
                                       , COALESCE (tmpOrderInternal_1.ObjectDescId, tmpOrderInternal_2.ObjectDescId)
                                       , COALESCE (tmpProductionUnion_1.ObjectDescId, tmpProductionUnion_2.ObjectDescId)
                                        ) ::Integer AS StateColor

        FROM tmpMovement_OrderClient

             LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpMovement_OrderClient.StatusId
             LEFT JOIN Object AS Object_From   ON Object_From.Id   = tmpMovement_OrderClient.FromId
             LEFT JOIN Object AS Object_To     ON Object_To.Id     = tmpMovement_OrderClient.ToId
             LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpMovement_OrderClient.PaidKindId
             LEFT JOIN Object AS Object_Product  ON Object_Product.Id  = tmpMovement_OrderClient.ProductId
             LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = tmpMovement_OrderClient.MovementId_Invoice

             LEFT JOIN MovementString AS MovementString_Comment_Invoice
                                      ON MovementString_Comment_Invoice.MovementId = Movement_Invoice.Id
                                     AND MovementString_Comment_Invoice.DescId = zc_MovementString_Comment()

             LEFT JOIN MovementFloat AS MovementFloat_NPP
                                     ON MovementFloat_NPP.MovementId = tmpMovement_OrderClient.Id
                                    AND MovementFloat_NPP.DescId = zc_MovementFloat_NPP()

             LEFT JOIN MovementString AS MovementString_Comment
                                      ON MovementString_Comment.MovementId = tmpMovement_OrderClient.Id
                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()

             LEFT JOIN MovementDate AS MovementDate_Insert
                                    ON MovementDate_Insert.MovementId = tmpMovement_OrderClient.Id
                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
             LEFT JOIN MovementLinkObject AS MLO_Insert
                                          ON MLO_Insert.MovementId = tmpMovement_OrderClient.Id
                                         AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
             LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

             LEFT JOIN MovementDate AS MovementDate_Update
                                    ON MovementDate_Update.MovementId = tmpMovement_OrderClient.Id
                                   AND MovementDate_Update.DescId = zc_MovementDate_Update()
             LEFT JOIN MovementLinkObject AS MLO_Update
                                          ON MLO_Update.MovementId = tmpMovement_OrderClient.Id
                                         AND MLO_Update.DescId = zc_MovementLinkObject_Update()
             LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

             --
             LEFT JOIN ObjectDate AS ObjectDate_DateSale
                                  ON ObjectDate_DateSale.ObjectId = Object_Product.Id
                                 AND ObjectDate_DateSale.DescId   = zc_ObjectDate_Product_DateSale()
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

             LEFT JOIN ObjectLink AS ObjectLink_Model
                                  ON ObjectLink_Model.ObjectId = Object_Product.Id
                                 AND ObjectLink_Model.DescId = zc_ObjectLink_Product_Model()
             LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId

             --- строки
             INNER JOIN tmpItem  ON tmpItem.MovementId = tmpMovement_OrderClient.Id
             LEFT JOIN Object AS Object_Object ON Object_Object.Id = tmpItem.ObjectId

             LEFT JOIN tmpReceiptGoods ON tmpReceiptGoods.ObjectId_orig = tmpItem.ObjectId_orig
             LEFT JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id = tmpReceiptGoods.ReceiptGoodsId

             LEFT JOIN ObjectString AS ObjectString_Article_object
                                    ON ObjectString_Article_object.ObjectId = Object_Object.Id
                                   AND ObjectString_Article_object.DescId   = zc_ObjectString_Article()
             LEFT JOIN ObjectDesc AS ObjectDesc_Object ON ObjectDesc_Object.Id = Object_Object.DescId

             LEFT JOIN Object AS Object_Object_basis ON Object_Object_basis.Id = tmpItem.ObjectId_orig
             --LEFT JOIN Object AS Object_Object_basis ON Object_Object_basis.Id = tmpItem.GoodsId_basis

             LEFT JOIN ObjectString AS ObjectString_Article_basis
                                    ON ObjectString_Article_basis.ObjectId = Object_Object_basis.Id
                                   AND ObjectString_Article_basis.DescId   = zc_ObjectString_Article()

             LEFT JOIN ObjectString AS ObjectString_Goods_Comment
                                    ON ObjectString_Goods_Comment.ObjectId = Object_Object.Id
                                   AND ObjectString_Goods_Comment.DescId   = zc_ObjectString_Goods_Comment()

             LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                    ON ObjectString_GoodsGroupFull.ObjectId = tmpItem.ObjectId
                                   AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

             -- Заказ клиента - Лодка
             LEFT JOIN tmpMIFloat_MovementId AS tmpOrderInternal_1   ON tmpOrderInternal_1.MovementId_OrderClient   = tmpMovement_OrderClient.Id AND tmpOrderInternal_1.DescId   = zc_Movement_OrderInternal()   AND tmpOrderInternal_1.ObjectDescId   = zc_Object_Product()
                                                                    AND tmpOrderInternal_1.ObjectId                 = tmpItem.ObjectId
             -- Заказ клиента - Узлы
             LEFT JOIN tmpMIFloat_MovementId AS tmpOrderInternal_2   ON tmpOrderInternal_2.MovementId_OrderClient   = tmpMovement_OrderClient.Id AND tmpOrderInternal_2.DescId   = zc_Movement_OrderInternal()   AND tmpOrderInternal_2.ObjectDescId   = zc_Object_Goods()
                                                                    AND tmpOrderInternal_2.ObjectId                 = tmpItem.ObjectId
             -- Сборка - Узлы
             LEFT JOIN tmpMIFloat_MovementId AS tmpProductionUnion_1 ON tmpProductionUnion_1.MovementId_OrderClient = tmpMovement_OrderClient.Id AND tmpProductionUnion_1.DescId = zc_Movement_ProductionUnion() AND tmpProductionUnion_1.ObjectDescId = zc_Object_Product()
                                                                    AND tmpProductionUnion_1.ObjectId               = tmpItem.ObjectId
             -- Сборка - Лодка
             LEFT JOIN tmpMIFloat_MovementId AS tmpProductionUnion_2 ON tmpProductionUnion_2.MovementId_OrderClient = tmpMovement_OrderClient.Id AND tmpProductionUnion_2.DescId = zc_Movement_ProductionUnion() AND tmpProductionUnion_2.ObjectDescId = zc_Object_Goods()
                                                                    AND tmpProductionUnion_2.ObjectId               = tmpItem.ObjectId
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
