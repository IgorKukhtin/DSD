-- Function: gpGet_Movement_Invoice_Prepay()

DROP FUNCTION IF EXISTS gpGet_Movement_Invoice_Prepay(Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Invoice_Prepay(Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Invoice_Prepay(
    IN inMovementId_order      Integer ,
    IN inTotalSumm_debet       TFloat  ,
   OUT outAmountIn             TFloat ,
    IN inSession               TVarChar       -- ������ ������������
)
RETURNS TFloat
AS
$BODY$
  DECLARE vbDayCalendar TFloat;
BEGIN
    
   --
   outAmountIn := (-- ����� ������
                   COALESCE (inTotalSumm_debet,0) 
                 - (SELECT SUM (CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * MovementFloat_Amount.ValueData ELSE 0 END) ::TFloat AS Total_PrePay
                    FROM Movement
                         INNER JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                                       ON MovementLinkObject_InvoiceKind.MovementId = Movement.Id
                                                      AND MovementLinkObject_InvoiceKind.DescId     = zc_MovementLinkObject_InvoiceKind()
                                                      -- ������ ����������
                                                      AND MovementLinkObject_InvoiceKind.ObjectId   = zc_Enum_InvoiceKind_PrePay()
                         -- ����� �� �����
                         LEFT JOIN MovementFloat AS MovementFloat_Amount
                                                 ON MovementFloat_Amount.MovementId = Movement.Id
                                                AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount() 
                    WHERE Movement.DescId = zc_Movement_Invoice()
                      AND Movement.ParentId = inMovementId_order
                      AND Movement.StatusId = zc_Enum_Status_Complete()
                   )
                   ) ::TFloat;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.12.23         *
*/

-- ����
-- SELECT * FROM gpGet_Movement_Invoice_Prepay(890 , 46060, '5'::TVarChar)