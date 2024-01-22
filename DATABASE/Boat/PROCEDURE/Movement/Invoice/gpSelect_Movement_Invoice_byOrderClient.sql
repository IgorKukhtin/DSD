-- Function: gpSelect_Movement_Invoice_byOrderClient() - �������� �� ����� - ������ <��������� ����, ������/������>

DROP FUNCTION IF EXISTS gpSelect_Movement_Invoice_byOrderClient (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Invoice_byOrderClient(
    IN inMovementId_OrderClient      Integer ,
    IN inIsErased                    Boolean ,
    IN inSession                     TVarChar    -- ������ ������������
)
RETURNS TABLE (Id              Integer
             , InvNumber       Integer
             , InvNumber_Full  TVarChar
             , OperDate        TDateTime
             , PlanDate        TDateTime
             , StatusCode      Integer
             , StatusName      TVarChar
             , InvoiceKindId   Integer
             , InvoiceKindName TVarChar
             , isAuto          Boolean
               -- � ���
             , AmountIn         TFloat
             , AmountOut        TFloat
               -- ��� ���
             , AmountIn_NotVAT  TFloat
             , AmountOut_NotVAT TFloat
               -- ���
             , AmountIn_VAT     TFloat
             , AmountOut_VAT    TFloat

             , VATPercent      TFloat

               -- ������
             , AmountIn_BankAccount  TFloat
             , AmountOut_BankAccount TFloat
               --����� ������
             , Amount_BankAccount    TFloat
               -- ������� �� �����
             , AmountIn_rem  TFloat
             , AmountOut_rem TFloat
             , Amount_rem    TFloat

             , ObjectId        Integer
             , ObjectName      TVarChar
             , ObjectDescName  TVarChar

             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , ProductId Integer, ProductCode Integer, ProductName TVarChar, ProductCIN TVarChar
             , PaidKindId      Integer
             , PaidKindName    TVarChar
             , UnitId          Integer
             , UnitName        TVarChar

               -- ����� ��������� - External Nr
             , InvNumberPartner TVarChar
               -- ����������� ����� ��������� - Quittung Nr
             , ReceiptNumber    Integer
               --
             , Comment TVarChar

             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime

             , MovementId_parent       Integer
             , InvNumber_parent        TVarChar
             , MovementDescName_parent TVarChar

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

     -- �������� ��� ��������� ������ � ������� PArentId = inMovementId_OrderClient
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

     -- ���������
     RETURN QUERY
       WITH
       tmpData AS (SELECT gpSelect.*
                   FROM gpSelect_Movement_Invoice(inStartDate :=vbStartDate, inEndDate := vbEndDate, inClientId:= vbClientId, inIsErased := inIsErased,  inSession := inSession) AS gpSelect
                        INNER JOIN tmpInvoice ON tmpInvoice.Id = gpSelect.Id
                  )
    -- ���������
    SELECT
        tmpData.Id
      , tmpData.InvNumber
      , tmpData.InvNumber_Full
      , tmpData.OperDate
      , tmpData.PlanDate
      , tmpData.StatusCode
      , tmpData.StatusName
      , tmpData.InvoiceKindId
      , tmpData.InvoiceKindName
      , tmpData.isAuto
        -- � ���
      , tmpData.AmountIn
      , tmpData.AmountOut
        -- ��� ���
      , tmpData.AmountIn_NotVAT
      , tmpData.AmountOut_NotVAT
        -- ���
      , tmpData.AmountIn_VAT
      , tmpData.AmountOut_VAT

      , tmpData.VATPercent

        -- ������
      , tmpData.AmountIn_BankAccount
      , tmpData.AmountOut_BankAccount
      , tmpData.Amount_BankAccount
        -- ������� �� �����
      , tmpData.AmountIn_rem
      , tmpData.AmountOut_rem
      , tmpData.Amount_rem

      , tmpData.ObjectId
      , tmpData.ObjectName
      , tmpData.ObjectDescName

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
      , tmpData.MovementDescName_parent

        -- ���������� ���� ���� �� ������� + ���������� ������� - ���� ������ ������ ��� ����� ����� + �������� ������ - � ����� ����� �������� ��� ������ ��� ����� �����
      , tmpData.Color_Pay

    FROM tmpData
   ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.12.23         *
 12.05.21         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_Invoice_byOrderClient (inMovementId_OrderClient:= 0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
