-- Function: gpSelect_Movement_OrderClientChoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderClient (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderClientChoice (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderClient (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderClient (TDateTime, TDateTime, Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderClient(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inClientId      Integer   ,
    IN inSummDebet     TFloat    , -- сумма оплаты
    IN inIsErased      Boolean   ,
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
             , TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat, TotalSumm_transport TFloat, TotalSummVAT TFloat
             , SummDiscount_total TFloat
               -- Цена продажи с сайта - без НДС, Basis+options
             , OperPrice_load TFloat
               -- Базовая цена продажи модели с сайта
             , BasisPrice_load TFloat
               -- load Сумма транспорт с сайта
             , TransportSumm_load TFloat

             , SummTax TFloat
             , SummReal TFloat
             , TotalSumm_calc TFloat
               --
             , NPP Integer, NPP_2 Integer
               --
             , FromId Integer, FromCode Integer, FromName TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ProductId Integer, ProductName TVarChar, ProductName_Full TVarChar, DateBegin TDateTime
             , ReceiptProdModelId Integer, ReceiptProdModelCode Integer, ReceiptProdModelName TVarChar
             , BrandId Integer, BrandName TVarChar
             , ModelId Integer, ModelName TVarChar
             , CIN TVarChar, EngineNum TVarChar, EngineName TVarChar
             , Comment TVarChar
             , MovementId_Invoice Integer, InvNumberFull_Invoice TVarChar, InvNumber_Invoice Integer, ReceiptNumber_Invoice Integer, Comment_Invoice TVarChar
             , InvoiceKindId Integer, InvoiceKindName  TVarChar
               -- Итого Сумма по счету (у лодки)
             , Amount_Invoice     TFloat
               -- Итого Оплата по счету (у лодки)
             , Amount_Invoice_pay TFloat
               -- Итого Оплата по заказу
             , Amount_Order_pay TFloat
               -- Оплачен полностью счет (у лодки) - да/нет
             , isPay Boolean
               -- Если Найден ДРУГОЙ счет для оплаты, не тот что у заказа
             , isInvoice_oth Boolean
               -- поиск для контрола
             , MovementId_Invoice_find Integer, InvNumberFull_Invoice_find TVarChar
             , InvoiceKindId_find Integer, InvoiceKindName_find TVarChar
             , Amount_Invoice_find     TFloat
             , Amount_Invoice_pay_find TFloat

             , Value_TaxKind TFloat, TaxKindName TVarChar, TaxKindName_info TVarChar

             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar

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

     -- !!!Временно замена!!!
     IF inEndDate < CURRENT_DATE THEN inEndDate:= CURRENT_DATE; END IF;


     -- Результат
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
            -- Все счета
          , tmpMovement_Invoice AS (SELECT Movement.Id                    AS MovementId_Invoice
                                         , Movement.ParentId              AS MovementId_OrderClient
                                         , Movement.OperDate              AS OperDate
                                         , MovementFloat_Amount.ValueData AS Amount
                                    FROM Movement
                                         -- Сумма по счету
                                         INNER JOIN MovementFloat AS MovementFloat_Amount
                                                                  ON MovementFloat_Amount.MovementId = Movement.Id
                                                                 AND MovementFloat_Amount.DescId     = zc_MovementFloat_Amount()
                                                                 AND MovementFloat_Amount.ValueData  <> 0
                                    WHERE Movement.ParentId IN (SELECT DISTINCT Movement_OrderClient.Id FROM Movement_OrderClient)
                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                      AND Movement.DescId   = zc_Movement_Invoice()
                                   )
       -- оплаты по ВСЕМ счетам
     , tmpMovement_BankAccount AS (SELECT MovementLinkMovement.MovementChildId AS MovementId_Invoice
                                        , SUM (MovementItem.Amount)            AS Amount
                              FROM MovementLinkMovement
                                   INNER JOIN Movement AS Movement_BankAccount
                                                       ON Movement_BankAccount.Id       = MovementLinkMovement.MovementId
                                                      AND Movement_BankAccount.StatusId = zc_Enum_Status_Complete()
                                                      AND Movement_BankAccount.DescId   = zc_Movement_BankAccount()
                                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement_BankAccount.Id
                                                          AND MovementItem.DescId     = zc_MI_Master()
                                                          AND MovementItem.isErased   = FALSE
                                                          AND MovementItem.Amount     <> 0
                              WHERE MovementLinkMovement.MovementChildId IN (SELECT DISTINCT tmpMovement_Invoice.MovementId_Invoice FROM tmpMovement_Invoice)
                                AND MovementLinkMovement.DescId          = zc_MovementLinkMovement_Invoice()
                              GROUP BY MovementLinkMovement.MovementChildId
                             )
       -- Остаток к оплате по ВСЕМ счетам
    , tmpInvoicePay AS (SELECT tmpMovement_Invoice.MovementId_Invoice
                             , tmpMovement_Invoice.MovementId_OrderClient
                             , tmpMovement_Invoice.OperDate
                             , tmpMovement_Invoice.Amount AS Amount_Invoice
                             , tmpMovement_Invoice.Amount - COALESCE (tmpMovement_BankAccount.Amount, 0) AS Amount_Invoice_rem
                             , COALESCE (tmpMovement_BankAccount.Amount, 0) AS Amount_pay
                        FROM tmpMovement_Invoice
                             -- Все оплаты
                             LEFT JOIN tmpMovement_BankAccount ON tmpMovement_BankAccount.MovementId_Invoice = tmpMovement_Invoice.MovementId_Invoice
                       )

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
             , COALESCE (MovementFloat_VATPercent.ValueData, 0) :: TFloat AS VATPercent
             , MovementFloat_DiscountTax.ValueData          AS DiscountTax
             , MovementFloat_DiscountNextTax.ValueData      AS DiscountNextTax
             , MovementFloat_TotalCount.ValueData           AS TotalCount

               -- ИТОГО БЕЗ учета скидки и Транспорта, Сумма продажи без НДС
             , MovementFloat_TotalSummMVAT.ValueData        AS TotalSummMVAT

               -- ИТОГО с учетом всех скидок и Транспорта, Сумма продажи с НДС
             , (MovementFloat_TotalSummPVAT.ValueData
               -- минус откорректированная скидка
             - zfCalc_SummWVAT (MovementFloat_SummTax.ValueData, MovementFloat_VATPercent.ValueData)
               -- плюс Транспорт
             + zfCalc_SummWVAT (MovementFloat_TransportSumm_load.ValueData, MovementFloat_VATPercent.ValueData)
               ) :: TFloat AS TotalSummPVAT

               -- ИТОГО с учетом всех % скидок, без Транспорта, Сумма продажи без НДС
             , MovementFloat_TotalSumm.ValueData            AS TotalSumm
               -- ИТОГО с учетом всех скидок и Транспорта, Сумма продажи без НДС
             , (COALESCE (MovementFloat_TotalSumm.ValueData, 0)
                -- минус откорректированная скидка
              - COALESCE (MovementFloat_SummTax.ValueData, 0)
                -- плюс Транспорт
              + COALESCE (MovementFloat_TransportSumm_load.ValueData, 0)
               ) :: TFloat AS TotalSumm_transport

               -- Сумма НДС
             , (-- основная
              + COALESCE (MovementFloat_TotalSummPVAT.ValueData,0) - COALESCE (MovementFloat_TotalSumm.ValueData,0)
                -- минус откорректированная скидка
              - zfCalc_SummWVAT (MovementFloat_SummTax.ValueData, MovementFloat_VATPercent.ValueData) + COALESCE (MovementFloat_SummTax.ValueData, 0)
                -- плюс Транспорт
              + zfCalc_SummWVAT (MovementFloat_TransportSumm_load.ValueData, MovementFloat_VATPercent.ValueData) - COALESCE (MovementFloat_TransportSumm_load.ValueData, 0)
               ) :: TFloat AS TotalSummVAT

               -- Итоговая сумма скидки по всем % скидки
             , (COALESCE (MovementFloat_TotalSummMVAT.ValueData,0) - COALESCE (MovementFloat_TotalSumm.ValueData,0)) :: TFloat AS SummDiscount_total

               -- Цена продажи с сайта - без НДС, Basis+options
             , MovementFloat_OperPrice_load.ValueData      AS OperPrice_load
               -- Базовая цена продажи модели с сайта
             , MIFloat_BasisPrice_load.ValueData           AS BasisPrice_load
               -- load Сумма транспорт с сайта
             , MovementFloat_TransportSumm_load.ValueData  AS TransportSumm_load

               -- Cумма откорректированной скидки, без НДС
             , MovementFloat_SummTax.ValueData  ::TFloat AS SummTax
               -- ИТОГО откорректированная сумма, с учетом всех скидок, без Транспорта, Сумма продажи без НДС
             , MovementFloat_SummReal.ValueData ::TFloat AS SummReal
               -- ИТОГО расчетная сумма, с учетом всех скидок, без Транспорта, Сумма продажи без НДС
             , CASE WHEN MovementFloat_SummReal.ValueData > 0
                         THEN MovementFloat_SummReal.ValueData
                    ELSE
                         -- ИТОГО с учетом всех скидок, без Транспорта, Сумма продажи без НДС
                         COALESCE (MovementFloat_TotalSumm.ValueData, 0)
                       - COALESCE (MovementFloat_SummTax.ValueData, 0)
               END ::TFloat AS TotalSumm_calc

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
             , Object_Model.Id                              AS ModelId
             , Object_Model.ValueData                       AS ModelName
             , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,       Object_Product.isErased) AS CIN
             , zfCalc_ValueData_isErased (ObjectString_EngineNum.ValueData, Object_Product.isErased) AS EngineNum
             , Object_Engine.ValueData                      AS EngineName
             , MovementString_Comment.ValueData :: TVarChar AS Comment

             , Movement_Invoice.Id                             AS MovementId_Invoice
             , zfCalc_InvNumber_two_isErased ('', Movement_Invoice.InvNumber, MovementString_ReceiptNumber_Invoice.ValueData, Movement_Invoice.OperDate, Movement_Invoice.StatusId) AS InvNumberFull_Invoice
             , CASE WHEN Movement_Invoice.Id IS NULL THEN NULL ELSE zfConvert_StringToNumber (Movement_Invoice.InvNumber)                     END :: Integer AS InvNumber_Invoice
             , CASE WHEN Movement_Invoice.Id IS NULL THEN NULL ELSE zfConvert_StringToNumber (MovementString_ReceiptNumber_Invoice.ValueData) END :: Integer AS ReceiptNumber_Invoice
             , MovementString_Comment_Invoice.ValueData        AS Comment_Invoice
             , Object_InvoiceKind.Id                           AS InvoiceKindId
             , Object_InvoiceKind.ValueData                    AS InvoiceKindName

             , tmpInvoicePay.Amount_Invoice :: TFloat      AS Amount_Invoice
             , tmpInvoicePay.Amount_pay     :: TFloat      AS Amount_Invoice_pay
             , tmpOrder_pay.Amount          :: TFloat      AS Amount_Order_pay

               -- Оплачен полностью счет (у лодки) - да/нет
             , CASE WHEN Movement_Invoice.Id > 0 AND tmpInvoicePay.Amount_Invoice_rem = 0 THEN TRUE ELSE FALSE END ::Boolean AS isPay
               -- Если Найден ДРУГОЙ счет для оплаты, не тот что у заказа
             , CASE WHEN Movement_Invoice_find.Id > 0 AND Movement_Invoice.Id <> Movement_Invoice_find.Id THEN TRUE ELSE FALSE END ::Boolean AS isInvoice_oth

               -- нашли
             , Movement_Invoice_find.Id  AS MovementId_Invoice_find
             , zfCalc_InvNumber_two_isErased ('', Movement_Invoice_find.InvNumber, MovementString_ReceiptNumber_Invoice_find.ValueData, Movement_Invoice_find.OperDate, Movement_Invoice_find.StatusId) AS InvNumberFull_Invoice_find

             , CASE -- если нашли
                    WHEN Movement_Invoice_find.Id > 0
                         THEN Object_InvoiceKind_find.Id

                    -- если Итого оплата = сумме за лодку
                    WHEN COALESCE (tmpOrder_pay.Amount, 0) + inSummDebet
                       -- ИТОГО с учетом всех скидок и Транспорта, Сумма продажи с НДС
                      >= -- Сумма с НДС
                         MovementFloat_TotalSummPVAT.ValueData
                         -- минус откорректированная скидка
                       - zfCalc_SummWVAT (MovementFloat_SummTax.ValueData, MovementFloat_VATPercent.ValueData)
                         -- плюс Транспорт
                       + zfCalc_SummWVAT (MovementFloat_TransportSumm_load.ValueData, MovementFloat_VATPercent.ValueData)

                          --  Счет
                         THEN zc_Enum_InvoiceKind_Pay()

                    -- иначе предоплата
                    ELSE zc_Enum_InvoiceKind_PrePay()

               END :: Integer AS InvoiceKindId_find

             , CASE -- если нашли
                    WHEN Movement_Invoice_find.Id > 0
                         THEN Object_InvoiceKind_find.ValueData

                    -- если Итого оплата = сумме за лодку
                    WHEN COALESCE (tmpOrder_pay.Amount, 0) + inSummDebet
                         -- ИТОГО с учетом всех скидок и Транспорта, Сумма продажи с НДС
                      >= MovementFloat_TotalSummPVAT.ValueData
                         -- минус откорректированная скидка
                       - zfCalc_SummWVAT (MovementFloat_SummTax.ValueData, MovementFloat_VATPercent.ValueData)
                         -- плюс Транспорт
                       + zfCalc_SummWVAT (MovementFloat_TransportSumm_load.ValueData, MovementFloat_VATPercent.ValueData)

                          --  Счет
                          THEN lfGet_Object_ValueData_sh (zc_Enum_InvoiceKind_Pay())

                    -- иначе предоплата
                    ELSE lfGet_Object_ValueData_sh (zc_Enum_InvoiceKind_PrePay())

               END :: TVarChar AS InvoiceKindName_find

             , tmpInvoicePay_rem.Amount_Invoice :: TFloat      AS Amount_Invoice_find
             , tmpInvoicePay_rem.Amount_pay     :: TFloat      AS Amount_Invoice_pay_find

             , COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) :: TFloat AS Value_TaxKind
             , Object_TaxKind.ValueData                     AS TaxKindName
             , ObjectString_TaxKind_Info.ValueData          AS TaxKindName_info

             , Object_InfoMoney_View.InfoMoneyId
             , Object_InfoMoney_View.InfoMoneyCode
             , Object_InfoMoney_View.InfoMoneyName
             , Object_InfoMoney_View.InfoMoneyName AS InfoMoneyName_all
           --, Object_InfoMoney_View.InfoMoneyName_all
             , Object_InfoMoney_View.InfoMoneyGroupName
             , Object_InfoMoney_View.InfoMoneyDestinationName

             , Object_Insert.ValueData                      AS InsertName
             , MovementDate_Insert.ValueData                AS InsertDate
             , Object_Update.ValueData                      AS UpdateName
             , MovementDate_Update.ValueData                AS UpdateDate

               -- Состояние
             , zfCalc_Order_State (CASE WHEN COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() THEN FALSE ELSE TRUE END
                                 , CASE WHEN Movement_OrderClient.StatusId = zc_Enum_Status_Complete()
                                             THEN Movement_OrderClient.NPP
                                        WHEN Movement_OrderClient.StatusId = zc_Enum_Status_UnComplete()
                                             THEN 0
                                        ELSE -1
                                   END :: Integer
                                 , COALESCE (tmpOrderInternal_1.MovementId, tmpOrderInternal_2.MovementId)
                                 , COALESCE (tmpProductionUnion_1.MovementId, tmpProductionUnion_2.MovementId)
                                 , COALESCE (tmpOrderInternal_1.ObjectDescId, tmpOrderInternal_2.ObjectDescId)
                                 , COALESCE (tmpProductionUnion_1.ObjectDescId, tmpProductionUnion_2.ObjectDescId)
                                  ) AS StateText
               -- все состояния подсветить
             , zfCalc_Order_State_color (CASE WHEN COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() THEN FALSE ELSE TRUE END
                                       , CASE WHEN Movement_OrderClient.StatusId = zc_Enum_Status_Complete()
                                                   THEN Movement_OrderClient.NPP
                                              WHEN Movement_OrderClient.StatusId = zc_Enum_Status_UnComplete()
                                                   THEN 0
                                              ELSE -1
                                         END :: Integer
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
             LEFT JOIN MovementString AS MovementString_ReceiptNumber_Invoice
                                      ON MovementString_ReceiptNumber_Invoice.MovementId = Movement_Invoice.Id
                                     AND MovementString_ReceiptNumber_Invoice.DescId     = zc_MovementString_ReceiptNumber()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                          ON MovementLinkObject_InvoiceKind.MovementId = Movement_Invoice.Id
                                         AND MovementLinkObject_InvoiceKind.DescId     = zc_MovementLinkObject_InvoiceKind()
             LEFT JOIN Object AS Object_InvoiceKind ON Object_InvoiceKind.Id = MovementLinkObject_InvoiceKind.ObjectId

             -- Итого оплаты за лодку
             LEFT JOIN (SELECT tmpMovement_Invoice.MovementId_OrderClient
                             , SUM (tmpMovement_BankAccount.Amount) AS Amount
                        FROM tmpMovement_Invoice
                             JOIN tmpMovement_BankAccount ON tmpMovement_BankAccount.MovementId_Invoice = tmpMovement_Invoice.MovementId_Invoice
                        GROUP BY tmpMovement_Invoice.MovementId_OrderClient
                       ) AS tmpOrder_pay
                         ON tmpOrder_pay.MovementId_OrderClient = Movement_OrderClient.Id

             -- Cчет (у заказа) + его Оплаты + Остаток к оплате
             LEFT JOIN tmpInvoicePay ON tmpInvoicePay.MovementId_Invoice = Movement_Invoice.Id
                                 -- AND 1=0
             -- Поиск неоплаченный счет
             LEFT JOIN (SELECT tmpInvoicePay.MovementId_OrderClient
                             , tmpInvoicePay.MovementId_Invoice
                             , tmpInvoicePay.Amount_Invoice
                             , tmpInvoicePay.Amount_pay
                             , tmpInvoicePay.Amount_Invoice_rem
                             , ROW_NUMBER() OVER (PARTITION BY tmpInvoicePay.MovementId_OrderClient ORDER BY tmpInvoicePay.OperDate ASC) AS Ord
                        FROM tmpInvoicePay
                        WHERE tmpInvoicePay.Amount_Invoice_rem > 0
                       ) AS tmpInvoicePay_rem
                         ON tmpInvoicePay_rem.MovementId_OrderClient = Movement_OrderClient.Id
                        -- первый
                        AND tmpInvoicePay_rem.Ord                    = 1
                        -- если Остаток по счету = 0
                        -- AND COALESCE (tmpInvoicePay.Amount_Invoice_rem, 0) = 0

             LEFT JOIN Movement AS Movement_Invoice_find ON Movement_Invoice_find.Id = tmpInvoicePay_rem.MovementId_Invoice
             LEFT JOIN MovementString AS MovementString_ReceiptNumber_Invoice_find
                                      ON MovementString_ReceiptNumber_Invoice_find.MovementId = Movement_Invoice_find.Id
                                     AND MovementString_ReceiptNumber_Invoice_find.DescId     = zc_MovementString_ReceiptNumber()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind_find
                                          ON MovementLinkObject_InvoiceKind_find.MovementId = Movement_Invoice_find.Id
                                         AND MovementLinkObject_InvoiceKind_find.DescId = zc_MovementLinkObject_InvoiceKind()
             LEFT JOIN Object AS Object_InvoiceKind_find ON Object_InvoiceKind_find.Id = MovementLinkObject_InvoiceKind_find.ObjectId


             -- Найдем статью: 1) неоплаченный счет 2) счет у заказа
             LEFT JOIN MovementLinkObject AS MovementLinkObject_InfoMoney
                                          ON MovementLinkObject_InfoMoney.MovementId = COALESCE (Movement_Invoice_find.Id, Movement_Invoice.Id)
                                         AND MovementLinkObject_InfoMoney.DescId     = zc_MovementLinkObject_InfoMoney()
             -- Найдем статью у клиента
             LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                                  ON ObjectLink_InfoMoney.ObjectId = Movement_OrderClient.FromId
                                 AND ObjectLink_InfoMoney.DescId   = zc_ObjectLink_Client_InfoMoney()
             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = COALESCE (MovementLinkObject_InfoMoney.ObjectId, ObjectLink_InfoMoney.ChildObjectId)

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

             LEFT JOIN MovementFloat AS MovementFloat_SummReal
                                     ON MovementFloat_SummReal.MovementId = Movement_OrderClient.Id
                                    AND MovementFloat_SummReal.DescId = zc_MovementFloat_SummReal()

             LEFT JOIN MovementFloat AS MovementFloat_SummTax
                                     ON MovementFloat_SummTax.MovementId = Movement_OrderClient.Id
                                    AND MovementFloat_SummTax.DescId = zc_MovementFloat_SummTax()

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

             LEFT JOIN ObjectLink AS ObjectLink_Model
                                  ON ObjectLink_Model.ObjectId = Object_Product.Id
                                 AND ObjectLink_Model.DescId = zc_ObjectLink_Product_Model()
             LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId

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

             LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                  ON ObjectLink_TaxKind.ObjectId = Object_From.Id
                                 AND ObjectLink_TaxKind.DescId = zc_ObjectLink_Client_TaxKind()
             LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_TaxKind.ChildObjectId

             LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                   ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_TaxKind.ChildObjectId
                                  AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
             LEFT JOIN ObjectString AS ObjectString_TaxKind_Info
                                    ON ObjectString_TaxKind_Info.ObjectId = ObjectLink_TaxKind.ChildObjectId
                                   AND ObjectString_TaxKind_Info.DescId = zc_ObjectString_TaxKind_Info()
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.07.23         *
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
-- SELECT * FROM gpSelect_Movement_OrderClient (inStartDate:= '01.10.2022', inEndDate:= '31.12.2023', inClientId:=0 , inSummDebet:= 0 , inIsErased := true, inSession:= zfCalc_UserAdmin())
