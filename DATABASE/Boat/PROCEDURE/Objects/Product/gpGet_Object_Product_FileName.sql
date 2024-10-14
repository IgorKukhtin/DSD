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
     vbPDF_FileName := 'Confirmation_'||(SELECT Object.ValueData
                                      --||'_'|| zfConvert_DateShortToString (CURRENT_DATE)
                                         FROM Object
                                         WHERE Object.Id = inProductId);
     END IF;
     
     IF inParam = 2
     THEN 
     vbPDF_FileName := 'Confirmation_Discount_'||(SELECT Object.ValueData
                                           --    ||'_'|| zfConvert_DateShortToString (CURRENT_DATE)
                                                  FROM Object
                                                  WHERE Object.Id = inProductId);
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
-- SELECT * FROM gpGet_Object_Product_FileName (inProductId := 1808 , inParam := 2 ,  inSession := zfCalc_UserAdmin());
-- select * from gpGet_Object_Product_FileName(inProductId := 254856 , inParam := 1 ,  inSession := '5');
