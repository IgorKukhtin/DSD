-- Function: gpGet_Object_Product_FileName()

DROP FUNCTION IF EXISTS gpGet_Object_Product_FileName (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Object_Product_FileName (
    IN inProductId          Integer  , -- ���� �������
    IN inParam              Integer  , -- ���. ������� ����� ���������
                                        --  1 - PrintProduct_OrderConfirmation
                                        --  2 - PrintProduct_OrderConfirmation_Discount
    IN inSession            TVarChar   -- ������ ������������
)
RETURNS TABLE (PDF_FileName TVarChar)
AS
$BODY$
     DECLARE vbPDF_FileName TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Invoice());


     -- �������� ����� - ��� ���������� PDF
     IF inParam = 1
     THEN
         vbPDF_FileName := 'Confirmation_' || (SELECT Movement.InvNumber
                                               FROM MovementLinkObject AS MovementLinkObject_Product
                                                    INNER JOIN Movement ON Movement.Id = MovementLinkObject_Product.MovementId
                                                                       AND Movement.DescId = zc_Movement_OrderClient()
                                                                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                                               WHERE MovementLinkObject_Product.ObjectId = inProductId
                                                 AND MovementLinkObject_Product.DescId   = zc_MovementLinkObject_Product()
                                         --|| (SELECT Object.ValueData FROM Object WHERE Object.Id = inProductId)
                                              )
                                             ;
     END IF;

     IF inParam = 2
     THEN
         vbPDF_FileName := 'Confirmation_Discount_'
                                           || (SELECT Movement.InvNumber
                                               FROM MovementLinkObject AS MovementLinkObject_Product
                                                    INNER JOIN Movement ON Movement.Id = MovementLinkObject_Product.MovementId
                                                                       AND Movement.DescId = zc_Movement_OrderClient()
                                                                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                                               WHERE MovementLinkObject_Product.ObjectId = inProductId
                                                 AND MovementLinkObject_Product.DescId   = zc_MovementLinkObject_Product()
                                         --|| (SELECT Object.ValueData FROM Object WHERE Object.Id = inProductId)
                                              )
                                             ;
     END IF;


     -- ���������
     RETURN QUERY
        SELECT vbPDF_FileName  -- �������� ����� - ��� ���������� PDF
        ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.10.24         *
*/

-- ����
-- SELECT * FROM gpGet_Object_Product_FileName(inProductId := 254856 , inParam := 1 ,  inSession := '5');
