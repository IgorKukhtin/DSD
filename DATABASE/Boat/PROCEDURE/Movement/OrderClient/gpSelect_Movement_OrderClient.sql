-- Function: gpSelect_Movement_OrderClientChoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderClient (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderClientChoice (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderClient (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderClient(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inClientId      Integer  ,
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumber_full  TVarChar, InvNumber_all TVarChar
             , InvNumberPartner TVarChar
             , BarCode TVarChar
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
               --
             , PriceWithVAT Boolean, VATPercent TFloat
               --
             , DiscountTax TFloat, DiscountNextTax TFloat
               --
             , TotalCount TFloat
             , TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat, TotalSummVAT TFloat
             , SummDiscount_total TFloat
               -- Цена продажи с сайта - без НДС, Basis+options
             , OperPrice_load TFloat
               -- Базовая цена продажи модели с сайта
             , BasisPrice_load TFloat
               -- load Сумма транспорт с сайта
             , TransportSumm_load TFloat
               --
             , NPP Integer, NPP_2 Integer
               --
             , FromId Integer, FromCode Integer, FromName TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ProductId Integer, ProductName TVarChar, ProductName_Full TVarChar, DateBegin TDateTime
             , ReceiptProdModelId Integer, ReceiptProdModelCode Integer, ReceiptProdModelName TVarChar
             , BrandId Integer, BrandName TVarChar, CIN TVarChar, EngineNum TVarChar, EngineName TVarChar
             , Comment TVarChar
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar, Comment_Invoice TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
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

    , Movement_OrderClient_all AS (-- за период
                                   SELECT Movement_OrderClient.*
                                        , COALESCE (MovementFloat_NPP.ValueData, 0) :: Integer AS NPP
                                   FROM tmpStatus
                                        INNER JOIN Movement AS Movement_OrderClient
                                                            ON Movement_OrderClient.StatusId = tmpStatus.StatusId
                                                           AND Movement_OrderClient.OperDate BETWEEN inStartDate AND inEndDate
                                                           AND Movement_OrderClient.DescId   = zc_Movement_OrderClient()
                                        LEFT JOIN MovementFloat AS MovementFloat_NPP
                                                                ON MovementFloat_NPP.MovementId = Movement_OrderClient.Id
                                                               AND MovementFloat_NPP.DescId     = zc_MovementFloat_NPP()
                                  UNION
                                   -- любые с № п/п
                                   SELECT Movement_OrderClient.*
                                        , MovementFloat_NPP.ValueData :: Integer AS NPP
                                   FROM MovementFloat AS MovementFloat_NPP
                                        INNER JOIN Movement AS Movement_OrderClient
                                                            ON Movement_OrderClient.Id       = MovementFloat_NPP.MovementId
                                                           AND Movement_OrderClient.DescId   = zc_Movement_OrderClient()
                                                           AND Movement_OrderClient.StatusId <> zc_Enum_Status_Erased()
                                      --INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement_OrderClient.StatusId
                                   WHERE MovementFloat_NPP.ValueData > 0
                                     AND MovementFloat_NPP.DescId    = zc_MovementFloat_NPP()
                                  )

        , Movement_OrderClient AS (SELECT Movement_OrderClient.Id
                                        , Movement_OrderClient.InvNumber
                                        , MovementString_InvNumberPartner.ValueData    AS InvNumberPartner
                                        , Movement_OrderClient.OperDate                AS OperDate
                                        , Movement_OrderClient.StatusId                AS StatusId
                                        , MovementLinkObject_To.ObjectId               AS ToId
                                        , MovementLinkObject_From.ObjectId             AS FromId
                                        , MovementLinkObject_PaidKind.ObjectId         AS PaidKindId
                                        , MovementLinkObject_Product.ObjectId          AS ProductId
                                        , MovementLinkMovement_Invoice.MovementChildId AS MovementId_Invoice

                                        , Movement_OrderClient.NPP
                                        , ROW_NUMBER() OVER (ORDER BY CASE WHEN Movement_OrderClient.NPP > 0 AND Movement_OrderClient.StatusId <> zc_Enum_Status_Erased() THEN 0 ELSE 1 END 
                                                                    , ObjectDate_DateBegin.ValueData
                                                                    , Movement_OrderClient.NPP
                                                                    , Movement_OrderClient.OperDate
                                                            ) :: Integer AS NPP_2
                                        , ObjectDate_DateBegin.ValueData               AS DateBegin

                                   FROM Movement_OrderClient_all AS Movement_OrderClient

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

                                        LEFT JOIN ObjectDate AS ObjectDate_DateBegin
                                                             ON ObjectDate_DateBegin.ObjectId = MovementLinkObject_Product.ObjectId
                                                            AND ObjectDate_DateBegin.DescId   = zc_ObjectDate_Product_DateBegin()

                                   WHERE MovementLinkObject_From.ObjectId = inClientId
                                     OR COALESCE (inClientId, 0) = 0
                                  )
            -- Проведенные Заказ производство и Производство-сборка
          , tmpMIFloat_MovementId AS (SELECT MIFloat_MovementId.ValueData :: Integer AS MovementId_OrderClient
                                           , Movement.DescId
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
                                        AND MIFloat_MovementId.ValueData IN (SELECT DISTINCT Movement_OrderClient.Id :: TFloat FROM Movement_OrderClient)
                                      GROUP BY MIFloat_MovementId.ValueData
                                             , Movement.DescId
                                             , Object.DescId
                              )
       /* --проведенные док. заказ производство
        , tmpOrderInternal AS (SELECT DISTINCT MIFloat_MovementId.ValueData :: Integer AS MovementId_OrderClient
                               FROM MovementItemFloat AS MIFloat_MovementId
                                    JOIN MovementItem ON MovementItem.Id = MIFloat_MovementId.MovementItemId
                                                     AND MovementItem.isErased = FALSE
                                                     AND MovementItem.DescId = zc_MI_Master()

                                    JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                               WHERE MIFloat_MovementId.MovementItemId = MovementItem.Id
                                 AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                 AND MIFloat_MovementId.ValueData :: Integer IN (SELECT DISTINCT Movement_OrderClient.Id FROM Movement_OrderClient)
                               )
          --проведенные zc_Movement_ProductionUnion
        , tmpProductionUnion AS (SELECT DISTINCT Movement.ParentId AS MovementId_OrderClient
                                 FROM Movement
                                 WHERE Movement.DescId = zc_Movement_ProductionUnion()
                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                   AND Movement.ParentId IN (SELECT DISTINCT Movement_OrderClient.Id FROM Movement_OrderClient)
                                )
         */

        -- Результат
        SELECT Movement_OrderClient.Id
             , zfConvert_StringToNumber (Movement_OrderClient.InvNumber) AS InvNumber
             , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId)  AS InvNumber_full
             , (zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) || ' / ' || Object_From.ValueData) :: TVarChar  AS InvNumber_all
             , Movement_OrderClient.InvNumberPartner
             , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement_OrderClient.Id) AS BarCode
             , Movement_OrderClient.OperDate
             , Object_Status.ObjectCode                     AS StatusCode
             , Object_Status.ValueData                      AS StatusName

             , MovementBoolean_PriceWithVAT.ValueData       AS PriceWithVAT
             , MovementFloat_VATPercent.ValueData           AS VATPercent
             , MovementFloat_DiscountTax.ValueData          AS DiscountTax
             , MovementFloat_DiscountNextTax.ValueData      AS DiscountNextTax
             , MovementFloat_TotalCount.ValueData           AS TotalCount
             , MovementFloat_TotalSummMVAT.ValueData        AS TotalSummMVAT
             , MovementFloat_TotalSummPVAT.ValueData        AS TotalSummPVAT
             , MovementFloat_TotalSumm.ValueData            AS TotalSumm
               --
             , (COALESCE (MovementFloat_TotalSummPVAT.ValueData,0) - COALESCE (MovementFloat_TotalSumm.ValueData,0)) :: TFloat AS TotalSummVAT
             , (COALESCE (MovementFloat_TotalSummMVAT.ValueData,0) - COALESCE (MovementFloat_TotalSumm.ValueData,0)) :: TFloat AS SummDiscount_total
               -- Цена продажи с сайта - без НДС, Basis+options
             , MovementFloat_OperPrice_load.ValueData      AS OperPrice_load
               -- Базовая цена продажи модели с сайта
             , MIFloat_BasisPrice_load.ValueData           AS BasisPrice_load
               -- load Сумма транспорт с сайта
             , MovementFloat_TransportSumm_load.ValueData  AS TransportSumm_load
               --
             , Movement_OrderClient.NPP
             , CASE WHEN Movement_OrderClient.NPP > 0 AND Movement_OrderClient.StatusId <> zc_Enum_Status_Erased() THEN Movement_OrderClient.NPP_2 ELSE 0 END  :: Integer AS NPP_2

             , Object_From.Id                               AS FromId
             , Object_From.ObjectCode                       AS FromCode
             , Object_From.ValueData                        AS FromName
             , Object_To.Id                                 AS ToId
             , Object_To.ObjectCode                         AS ToCode
             , Object_To.ValueData                          AS ToName
             , Object_PaidKind.Id                           AS PaidKindId
             , Object_PaidKind.ValueData                    AS PaidKindName
             , Object_Product.Id                            AS ProductId
             , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName
             , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName_Full
             , Movement_OrderClient.DateBegin               AS DateBegin

             , Object_ReceiptProdModel.Id                   AS ReceiptProdModelId
             , Object_ReceiptProdModel.ObjectCode           AS ReceiptProdModelCode
             , Object_ReceiptProdModel.ValueData            AS ReceiptProdModelName

             , Object_Brand.Id                              AS BrandId
             , Object_Brand.ValueData                       AS BrandName
             , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,       Object_Product.isErased) AS CIN
             , zfCalc_ValueData_isErased (ObjectString_EngineNum.ValueData, Object_Product.isErased) AS EngineNum
             , Object_Engine.ValueData                      AS EngineName
             , MovementString_Comment.ValueData :: TVarChar AS Comment

             , Movement_Invoice.Id                          AS MovementId_Invoice
             , zfCalc_InvNumber_isErased ('', Movement_Invoice.InvNumber, Movement_Invoice.OperDate, Movement_Invoice.StatusId) AS InvNumber_Invoice
             , MovementString_Comment_Invoice.ValueData     AS Comment_Invoice

             , Object_Insert.ValueData                      AS InsertName
             , MovementDate_Insert.ValueData                AS InsertDate
             , Object_Update.ValueData                      AS UpdateName
             , MovementDate_Update.ValueData                AS UpdateDate

               -- Состояние
             , zfCalc_Order_State (CASE WHEN COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() THEN FALSE ELSE TRUE END
                                 , Movement_OrderClient.NPP
                                 , COALESCE (tmpOrderInternal_1.MovementId, tmpOrderInternal_2.MovementId)
                                 , COALESCE (tmpProductionUnion_1.MovementId, tmpProductionUnion_2.MovementId)
                                 , COALESCE (tmpOrderInternal_1.ObjectDescId, tmpOrderInternal_2.ObjectDescId)
                                 , COALESCE (tmpProductionUnion_1.ObjectDescId, tmpProductionUnion_2.ObjectDescId)
                                  ) AS StateText
               -- все состояния подсветить
             , zfCalc_Order_State_color (CASE WHEN COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() THEN FALSE ELSE TRUE END
                                       , Movement_OrderClient.NPP
                                       , COALESCE (tmpOrderInternal_1.MovementId, tmpOrderInternal_2.MovementId)
                                       , COALESCE (tmpProductionUnion_1.MovementId, tmpProductionUnion_2.MovementId)
                                       , COALESCE (tmpOrderInternal_1.ObjectDescId, tmpOrderInternal_2.ObjectDescId)
                                       , COALESCE (tmpProductionUnion_1.ObjectDescId, tmpProductionUnion_2.ObjectDescId)
                                        ) ::Integer AS StateColor

        FROM Movement_OrderClient

             LEFT JOIN Object AS Object_Status   ON Object_Status.Id   = Movement_OrderClient.StatusId
             LEFT JOIN Object AS Object_From     ON Object_From.Id     = Movement_OrderClient.FromId
             LEFT JOIN Object AS Object_To       ON Object_To.Id       = Movement_OrderClient.ToId
             LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Movement_OrderClient.PaidKindId
             LEFT JOIN Object AS Object_Product  ON Object_Product.Id  = Movement_OrderClient.ProductId

             LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = Movement_OrderClient.MovementId_Invoice

             LEFT JOIN MovementString AS MovementString_Comment_Invoice
                                      ON MovementString_Comment_Invoice.MovementId = Movement_Invoice.Id
                                     AND MovementString_Comment_Invoice.DescId     = zc_MovementString_Comment()

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
                                    AND MovementFloat_TotalSummMVAT.DescId     = zc_MovementFloat_TotalSummMVAT()

             -- Цена продажи с сайта - без НДС, Basis+options
             LEFT JOIN MovementFloat AS MovementFloat_OperPrice_load
                                     ON MovementFloat_OperPrice_load.MovementId = Movement_OrderClient.Id
                                    AND MovementFloat_OperPrice_load.DescId     = zc_MovementFloat_OperPrice_load()
             -- load Сумма транспорт с сайта
             LEFT JOIN MovementFloat AS MovementFloat_TransportSumm_load
                                     ON MovementFloat_TransportSumm_load.MovementId = Movement_OrderClient.Id
                                    AND MovementFloat_TransportSumm_load.DescId     = zc_MovementFloat_TransportSumm_load()

             -- Заказ клиента - Лодка
             LEFT JOIN MovementItem ON MovementItem.MovementId = Movement_OrderClient.Id
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = FALSE
             -- Базовая цена продажи модели с сайта
             LEFT JOIN MovementItemFloat AS MIFloat_BasisPrice_load
                                         ON MIFloat_BasisPrice_load.MovementItemId = MovementItem.Id
                                        AND MIFloat_BasisPrice_load.DescId         = zc_MIFloat_BasisPrice_load()

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

             LEFT JOIN ObjectDate AS ObjectDate_DateSale
                                  ON ObjectDate_DateSale.ObjectId = Object_Product.Id
                                 AND ObjectDate_DateSale.DescId = zc_ObjectDate_Product_DateSale()

             LEFT JOIN ObjectLink AS ObjectLink_Product_ReceiptProdModel
                                  ON ObjectLink_Product_ReceiptProdModel.ObjectId = Object_Product.Id
                                 AND ObjectLink_Product_ReceiptProdModel.DescId   = zc_ObjectLink_Product_ReceiptProdModel()
             LEFT JOIN Object AS Object_ReceiptProdModel ON Object_ReceiptProdModel.Id = ObjectLink_Product_ReceiptProdModel.ChildObjectId

             LEFT JOIN tmpMIFloat_MovementId AS tmpOrderInternal_1   ON tmpOrderInternal_1.MovementId_OrderClient   = Movement_OrderClient.Id AND tmpOrderInternal_1.DescId   = zc_Movement_OrderInternal()   AND tmpOrderInternal_1.ObjectDescId   = zc_Object_Product()
             LEFT JOIN tmpMIFloat_MovementId AS tmpOrderInternal_2   ON tmpOrderInternal_2.MovementId_OrderClient   = Movement_OrderClient.Id AND tmpOrderInternal_2.DescId   = zc_Movement_OrderInternal()   AND tmpOrderInternal_2.ObjectDescId   = zc_Object_Goods()
             LEFT JOIN tmpMIFloat_MovementId AS tmpProductionUnion_1 ON tmpProductionUnion_1.MovementId_OrderClient = Movement_OrderClient.Id AND tmpProductionUnion_1.DescId = zc_Movement_ProductionUnion() AND tmpProductionUnion_1.ObjectDescId = zc_Object_Product()
             LEFT JOIN tmpMIFloat_MovementId AS tmpProductionUnion_2 ON tmpProductionUnion_2.MovementId_OrderClient = Movement_OrderClient.Id AND tmpProductionUnion_2.DescId = zc_Movement_ProductionUnion() AND tmpProductionUnion_2.ObjectDescId = zc_Object_Goods()
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.02.23         *
 25.12.22         *
 23.02.21         *
 15.02.21         *
*/


/*
1) Итого сумма по документу (без НДС без учета скидок)                     TotalSummMVAT
2) Итого сумма по документу (без НДС с учетом скидки)                      TotalSumm
3) Итого сумма по документу (с учетом НДС и скидки)                        TotalSummPVAT
4) итого сумма скидки
*/
-- тест
-- SELECT * FROM gpSelect_Movement_OrderClient (inStartDate:= '01.10.2022', inEndDate:= '31.12.2023', inClientId:=0 , inIsErased := true, inSession:= zfCalc_UserAdmin())
