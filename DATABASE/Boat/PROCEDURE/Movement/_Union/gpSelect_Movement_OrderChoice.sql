-- Function: gpSelect_Movement_OrderChoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderChoice (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderChoice (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderChoice(
    IN inStartDate                TDateTime , --
    IN inEndDate                  TDateTime , --
    IN inObjectId                 Integer,
    IN inIsErased                 Boolean ,
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumber_Full TVarChar, InvNumberPartner TVarChar, OperDate TDateTime, OperDatePartner TDateTime
             , StatusCode Integer, StatusName TVarChar
             , DescName TVarChar
             , PriceWithVAT Boolean
             , VATPercent TFloat, DiscountTax TFloat
             , TotalCount TFloat
             , TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat, TotalSummVAT TFloat
             , TotalSumm_debet TFloat, TotalSumm_credit TFloat 
             , BasisWVAT_summ_transport TFloat

             , ObjectId Integer, ObjectCode Integer, ObjectName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar

             , ProductId Integer
             , ProductCode Integer
             , ProductName TVarChar
             , ProductCIN TVarChar

             , Comment TVarChar
             , MovementId_Invoice Integer, InvNumberFull_Invoice TVarChar, InvNumber_Invoice Integer, ReceiptNumber_Invoice Integer, Comment_Invoice TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar

             , TaxKindId Integer, TaxKindName TVarChar, TaxKindName_info TVarChar, TaxKindName_Comment TVarChar

             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Временно замена!!!
     IF inEndDate < CURRENT_DATE THEN inEndDate:= CURRENT_DATE; END IF;


     -- Результат
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

         , tmpMovement AS (SELECT Movement.Id
                                , Movement.DescId
                                , Movement.InvNumber
                                , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
                                , Movement.OperDate                  AS OperDate
                                , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
                                , Movement.StatusId                  AS StatusId
                                , CASE WHEN Movement.DescId = zc_Movement_OrderClient()
                                            THEN MovementLinkObject_From.ObjectId
                                       WHEN Movement.DescId = zc_Movement_OrderPartner()
                                            THEN MovementLinkObject_To.ObjectId
                                  END AS ObjectId
                                , CASE WHEN Movement.DescId = zc_Movement_OrderClient()
                                            THEN MovementLinkObject_To.ObjectId
                                       WHEN Movement.DescId = zc_Movement_OrderPartner()
                                            THEN MovementLinkObject_From.ObjectId
                                  END AS UnitId
                                , MovementLinkObject_PaidKind.ObjectId      AS PaidKindId
                                , MovementLinkMovement_Invoice.MovementChildId AS MovementId_Invoice
                           FROM tmpStatus
                                INNER JOIN Movement ON Movement.StatusId = tmpStatus.StatusId
                                                   AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND Movement.DescId IN (zc_Movement_OrderPartner(), zc_Movement_OrderClient())

                                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                                LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                             ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                            AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

                                LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                         ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                                        AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
                                LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                       ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                      AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Invoice
                                                               ON MovementLinkMovement_Invoice.MovementId = Movement.Id
                                                              AND MovementLinkMovement_Invoice.DescId = zc_MovementLinkMovement_Invoice()
                          )
        , tmpSummProduct AS (SELECT  
                                   gpSelect.MovementId_OrderClient
                                 -- ИТОГО Без скидки, Цена продажи базовой модели лодки, без НДС
                                 , gpSelect.Basis_summ1_orig
                                   -- ИТОГО Без скидки, Сумма опций, без НДС
                                 , gpSelect.Basis_summ2_orig
                                   -- ИТОГО Без скидки, Цена продажи базовой модели лодки + Сумма всех опций, без НДС
                                 , gpSelect.Basis_summ_orig

                                   -- ИТОГО Сумма Скидки - без НДС
                                 , gpSelect.SummDiscount1
                                 , gpSelect.SummDiscount2
                                 , gpSelect.SummDiscount3
                                 , gpSelect.SummDiscount_total

                                   -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options)
                                 , gpSelect.Basis_summ
                                   -- Сумма транспорт с сайта
                                 , gpSelect.TransportSumm_load

                                   -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
                                 , gpSelect.Basis_summ_transport
                                   -- ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
                                 , gpSelect.BasisWVAT_summ_transport

                            FROM gpSelect_Object_Product (0, FALSE, FALSE, '') AS gpSelect
                            --WHERE gpSelect.MovementId_OrderClient = inMovementId
                           )

        -- Результат
        SELECT Movement.Id
             , zfConvert_StringToNumber (Movement.InvNumber) ::Integer AS InvNumber
             , zfCalc_InvNumber_isErased ('', Movement.InvNumber, Movement.OperDate, Movement.StatusId) AS InvNumber_Full
             , Movement.InvNumberPartner
             , Movement.OperDate
             , Movement.OperDatePartner
             , Object_Status.ObjectCode                   AS StatusCode
             , Object_Status.ValueData                    AS StatusName
             , MovementDesc.ItemName                      AS DescName

             , MovementBoolean_PriceWithVAT.ValueData     AS PriceWithVAT
             , COALESCE (MovementFloat_VATPercent.ValueData, 0) :: TFloat AS VATPercent
             , MovementFloat_DiscountTax.ValueData        AS DiscountTax
             , MovementFloat_TotalCount.ValueData         AS TotalCount
             , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
             , MovementFloat_TotalSummPVAT.ValueData      AS TotalSummPVAT
             , MovementFloat_TotalSumm.ValueData          AS TotalSumm
             , (COALESCE (MovementFloat_TotalSummPVAT.ValueData,0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData,0)) :: TFloat AS TotalSummVAT

             , tmpSummProduct.BasisWVAT_summ_transport AS TotalSumm_debet     --MovementFloat_TotalSumm.ValueData
             , 0                       :: TFloat AS TotalSumm_credit
              -- ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
             , tmpSummProduct.BasisWVAT_summ_transport ::TFloat
             

             , Object_Object.Id                             AS ObjectId
             , Object_Object.ObjectCode                     AS ObjectCode
             , Object_Object.ValueData                      AS ObjectName
             , Object_Unit.Id                               AS UnitId
             , Object_Unit.ObjectCode                       AS UnitCode
             , Object_Unit.ValueData                        AS UnitName
             , Object_PaidKind.Id                           AS PaidKindId
             , Object_PaidKind.ValueData                    AS PaidKindName

             , Object_Product.Id                            AS ProductId
             , Object_Product.ObjectCode                    AS ProductCode
             , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased)   AS ProductName
             , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData, Object_Product.isErased) AS ProductCIN
             , MovementString_Comment.ValueData :: TVarChar AS Comment

             , Movement_Invoice.Id                            AS MovementId_Invoice
             , zfCalc_InvNumber_two_isErased ('', Movement_Invoice.InvNumber, MovementString_ReceiptNumber_Invoice.ValueData, Movement_Invoice.OperDate, Movement_Invoice.StatusId) AS InvNumberFull_Invoice
             , zfConvert_StringToNumber (Movement_Invoice.InvNumber)                     AS InvNumber_Invoice
             , zfConvert_StringToNumber (MovementString_ReceiptNumber_Invoice.ValueData) AS ReceiptNumber_Invoice
             , MovementString_Comment_Invoice.ValueData       AS Comment_Invoice

             , Object_InfoMoney_View.InfoMoneyId
             , Object_InfoMoney_View.InfoMoneyCode
             , Object_InfoMoney_View.InfoMoneyName
             , Object_InfoMoney_View.InfoMoneyName_all
             , Object_InfoMoney_View.InfoMoneyGroupName
             , Object_InfoMoney_View.InfoMoneyDestinationName

             , Object_TaxKind.Id                      AS TaxKindId
             , Object_TaxKind.ValueData               AS TaxKindName
             , ObjectString_TaxKind_Info.ValueData    AS TaxKindName_info
             , ObjectString_TaxKind_Comment.ValueData AS TaxKindName_Comment

             , Object_Insert.ValueData              AS InsertName
             , MovementDate_Insert.ValueData        AS InsertDate
             , Object_Update.ValueData              AS UpdateName
             , MovementDate_Update.ValueData        AS UpdateDate

        FROM tmpMovement AS Movement

             LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

             LEFT JOIN Object AS Object_Status   ON Object_Status.Id   = Movement.StatusId
             LEFT JOIN Object AS Object_Object   ON Object_Object.Id   = Movement.ObjectId
             LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = Movement.UnitId
             LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Movement.PaidKindId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                          ON MovementLinkObject_Product.MovementId = Movement.Id
                                         AND MovementLinkObject_Product.DescId     = zc_MovementLinkObject_Product()
             LEFT JOIN Object AS Object_Product  ON Object_Product.Id  = MovementLinkObject_Product.ObjectId

             LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = Movement.MovementId_Invoice

             LEFT JOIN MovementString AS MovementString_ReceiptNumber_Invoice
                                      ON MovementString_ReceiptNumber_Invoice.MovementId = Movement.MovementId_Invoice
                                     AND MovementString_ReceiptNumber_Invoice.DescId     = zc_MovementString_ReceiptNumber()

             LEFT JOIN MovementString AS MovementString_Comment_Invoice
                                      ON MovementString_Comment_Invoice.MovementId = Movement_Invoice.Id
                                     AND MovementString_Comment_Invoice.DescId = zc_MovementString_Comment()

             LEFT JOIN ObjectLink AS ObjectLink_Client_InfoMoney
                                  ON ObjectLink_Client_InfoMoney.ObjectId = Object_Object.Id
                                 AND ObjectLink_Client_InfoMoney.DescId   = zc_ObjectLink_Client_InfoMoney()
             LEFT JOIN ObjectLink AS ObjectLink_Partner_InfoMoney
                                  ON ObjectLink_Partner_InfoMoney.ObjectId = Object_Object.Id
                                 AND ObjectLink_Partner_InfoMoney.DescId   = zc_ObjectLink_Partner_InfoMoney()

             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = COALESCE (ObjectLink_Client_InfoMoney.ChildObjectId, ObjectLink_Partner_InfoMoney.ChildObjectId)

             LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                     ON MovementFloat_TotalCount.MovementId = Movement.Id
                                    AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

             LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                     ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                    AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

             LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                     ON MovementFloat_VATPercent.MovementId = Movement.Id
                                    AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

             LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                     ON MovementFloat_DiscountTax.MovementId = Movement.Id
                                    AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()

             LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                     ON MovementFloat_TotalSummPVAT.MovementId = Movement.Id
                                    AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

             LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                     ON MovementFloat_TotalSummMVAT.MovementId = Movement.Id
                                    AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

             --
             /*LEFT JOIN MovementFloat AS MovementFloat_TransportSumm_load
                                     ON MovementFloat_TransportSumm_load.MovementId = Movement.Id
                                    AND MovementFloat_TransportSumm_load.DescId     = zc_MovementFloat_TransportSumm_load()
             LEFT JOIN MovementFloat AS MovementFloat_SummTax
                                     ON MovementFloat_SummTax.MovementId = Movement.Id
                                    AND MovementFloat_SummTax.DescId = zc_MovementFloat_SummTax()*/

             LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                       ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                      AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

             LEFT JOIN MovementString AS MovementString_Comment
                                      ON MovementString_Comment.MovementId = Movement.Id
                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()

             LEFT JOIN MovementDate AS MovementDate_Insert
                                    ON MovementDate_Insert.MovementId = Movement.Id
                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
             LEFT JOIN MovementLinkObject AS MLO_Insert
                                          ON MLO_Insert.MovementId = Movement.Id
                                         AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
             LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

             LEFT JOIN MovementDate AS MovementDate_Update
                                    ON MovementDate_Update.MovementId = Movement.Id
                                   AND MovementDate_Update.DescId = zc_MovementDate_Update()
             LEFT JOIN MovementLinkObject AS MLO_Update
                                          ON MLO_Update.MovementId = Movement.Id
                                         AND MLO_Update.DescId = zc_MovementLinkObject_Update()
             LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

             LEFT JOIN ObjectString AS ObjectString_CIN
                                    ON ObjectString_CIN.ObjectId = Object_Product.Id
                                   AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()

             LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                  ON ObjectLink_TaxKind.ObjectId = Movement.ObjectId
                                 AND ObjectLink_TaxKind.DescId IN (zc_ObjectLink_Client_TaxKind(), zc_ObjectLink_Partner_TaxKind())
             LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_TaxKind.ChildObjectId
             LEFT JOIN ObjectString AS ObjectString_TaxKind_Info
                                    ON ObjectString_TaxKind_Info.ObjectId = ObjectLink_TaxKind.ChildObjectId
                                   AND ObjectString_TaxKind_Info.DescId   = zc_ObjectString_TaxKind_Info()
             LEFT JOIN ObjectString AS ObjectString_TaxKind_Comment
                                    ON ObjectString_TaxKind_Comment.ObjectId = ObjectLink_TaxKind.ChildObjectId
                                   AND ObjectString_TaxKind_Comment.DescId   = zc_ObjectString_TaxKind_Comment()    
             
             LEFT JOIN tmpSummProduct ON tmpSummProduct.MovementId_OrderClient = Movement.Id

        WHERE Movement.ObjectId = inObjectId OR COALESCE (inObjectId, 0) = 0
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.10.23         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderChoice (inStartDate:= '01.01.2023', inEndDate:= '01.12.2023', inObjectId:=0, inIsErased := FALSE, inSession:= '2')
