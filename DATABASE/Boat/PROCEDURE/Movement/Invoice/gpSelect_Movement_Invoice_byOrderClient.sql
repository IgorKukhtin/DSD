-- Function: gpSelect_Movement_Invoice_byOrderClient()

DROP FUNCTION IF EXISTS gpSelect_Movement_Invoice_byOrderClient (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Invoice_byOrderClient(
    IN inMovementId_OrderClient      Integer ,
    IN inIsErased                    Boolean ,
    IN inSession                     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id              Integer
             , InvNumber       Integer
             , InvNumber_Full  TVarChar
             , OperDate        TDateTime
             , PlanDate        TDateTime
             , StatusCode      Integer
             , StatusName      TVarChar
             , AmountIn         TFloat
             , AmountOut        TFloat
             , AmountIn_NotVAT  TFloat
             , AmountOut_NotVAT TFloat
             , AmountIn_VAT     TFloat
             , AmountOut_VAT    TFloat
             , VATPercent      TFloat             

             -- оплата
             , AmountIn_BankAccount  TFloat
             , AmountOut_BankAccount TFloat
             , Amount_BankAccount    TFloat --итого оплата
             -- остаток по счету
             , AmountIn_rem  TFloat
             , AmountOut_rem TFloat
             , Amount_rem    TFloat

             , ObjectId        Integer
             , ObjectName      TVarChar
             , DescName        TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , ProductId Integer, ProductCode Integer, ProductName TVarChar, ProductCIN TVarChar
             , PaidKindId      Integer
             , PaidKindName    TVarChar
             , UnitId          Integer
             , UnitName        TVarChar

             , InvNumberPartner TVarChar
             , ReceiptNumber    TVarChar
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             
             , MovementId_parent Integer
             , InvNumber_parent TVarChar
             , DescName_parent TVarChar
      
             , Color_Pay Integer
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime; 
   DECLARE vbClientId Integer;
BEGIN

     vbUserId:= lpGetUserBySession (inSession);

     ---
     CREATE TEMP TABLE tmpStatus (StatusId Integer) ON COMMIT DROP;
     INSERT INTO tmpStatus (StatusId)
          SELECT zc_Enum_Status_Complete()   AS StatusId
    UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
    UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE;
       
     -- выбираем все документы Счетов у которых PArentId = inMovementId_OrderClient
     CREATE TEMP TABLE tmpInvoice (Id Integer, OperDate TDateTime) ON COMMIT DROP;
     INSERT INTO tmpInvoice (Id, OperDate)
     SELECT Movement.Id
          , Movement.OperDate
     FROM Movement
         INNER JoIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
     WHERE Movement.ParentId = inMovementId_OrderClient
       AND Movement.DescId = zc_Movement_Invoice();

     --
     vbStartDate:= (SELECT MIN (tmpInvoice.OperDate) FROM tmpInvoice);
     vbEndDate  := (SELECT MAX (tmpInvoice.OperDate) FROM tmpInvoice);

     vbClientId:= (SELECT MovementLinkObject_From.ObjectId
                   FROM MovementLinkObject AS MovementLinkObject_From
                   WHERE MovementLinkObject_From.MovementId = inMovementId_OrderClient
                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                   );

     -- Результат
     RETURN QUERY
       WITH 
       tmpData AS (SELECT spSelect.*
                   FROM gpSelect_Movement_Invoice(inStartDate :=vbStartDate, inEndDate := vbEndDate, inClientId:= vbClientId, inIsErased := inIsErased,  inSession := inSession) AS spSelect
                        INNER JOIN tmpInvoice ON tmpInvoice.Id = spSelect.Id
                   )

    -- Результат
    SELECT     
        tmpData.Id
      , tmpData.InvNumber
      , tmpData.InvNumber_Full
      , tmpData.OperDate
      , tmpData.PlanDate
      , tmpData.StatusCode
      , tmpData.StatusName
        -- с НДС
      , tmpData.AmountIn
      , tmpData.AmountOut
        -- без НДС
      , tmpData.AmountIn_NotVAT
      , tmpData.AmountOut_NotVAT
        -- НДС
      , tmpData.AmountIn_VAT
      , tmpData.AmountOut_VAT

      , tmpData.VATPercent

      -- оплата
      , tmpData.AmountIn_BankAccount
      , tmpData.AmountOut_BankAccount
      , tmpData.Amount_BankAccount
      -- остаток по счету
      , tmpData.AmountIn_rem
      , tmpData.AmountOut_rem
      , tmpData.Amount_rem

      , tmpData.ObjectId
      , tmpData.ObjectName
      , tmpData.DescName
      , tmpData.InfoMoneyId
      , tmpData.InfoMoneyCode
      , tmpData.InfoMoneyName
      , tmpData.InfoMoneyName_all

      , tmpData.InfoMoneyGroupId
      , tmpData.InfoMoneyGroupCode
      , tmpData.InfoMoneyGroupName

      , tmpData.InfoMoneyDestinationId
      , tmpData.InfoMoneyDestinationCode
      , tmpData.InfoMoneyDestinationName
      , tmpData.ProductId
      , tmpData.ProductCode
      , tmpData.ProductName
      , tmpData.ProductCIN
      , tmpData.PaidKindId
      , tmpData.PaidKindName
      , tmpData.UnitId
      , tmpData.UnitName

      , tmpData.InvNumberPartner
      , tmpData.ReceiptNumber
      , tmpData.Comment

      , tmpData.InsertName
      , tmpData.InsertDate
      , tmpData.UpdateName
      , tmpData.UpdateDate

      , tmpData.MovementId_parent
      , tmpData.InvNumber_parent
      , tmpData.DescName_parent

      -- подсветить если счет не оплачен + подсветить красным - если оплата больше чем сумма счета + добавить кнопку - в новой форме показать все оплаты для этого счета
      , tmpData.Color_Pay
    FROM tmpData
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.05.21         *
*/

-- тест
--