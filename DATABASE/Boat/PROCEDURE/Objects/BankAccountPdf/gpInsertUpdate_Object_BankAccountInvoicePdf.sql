-- Function: gpInsertUpdate_Object_BankAccountInvoicePdf(Integer, TVarChar, Integer, TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BankAccountInvoicePdf(Integer, TVarChar, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BankAccountInvoicePdf(
 INOUT ioId                        Integer   , -- ���� �������
    IN inPhotoName                 TVarChar  , --
    IN inMovmentItemId             Integer   , --  
    IN inBankAccountPdfData        TBlob     , -- ����
    IN inSession                   TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Product());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���� �����
   IF COALESCE (ioId, 0) = 0 AND COALESCE (TRIM (inPhotoName), '') = '' 
   THEN 
       RAISE EXCEPTION '������! �� �������� ��� �����!';
   END IF;

   -- ��������� �����
   IF COALESCE (ioId, 0) = 0 AND COALESCE (TRIM (inPhotoName), '') <> '' 
   THEN 
       ioId:= (SELECT OF_Id.ObjectId 
               FROM ObjectFloat AS OF_Id
                    INNER JOIN Object AS Object_BankAccountPdf 
                                      ON Object_BankAccountPdf.Id        = OF_Id.ObjectId 
                                     AND Object_BankAccountPdf.DescId    = zc_Object_BankAccountPdf()
                                     AND Object_BankAccountPdf.ValueData = inPhotoName
               WHERE OF_Id.ValueData ::Integer = inMovmentItemId 
                 AND OF_Id.DescId = zc_ObjectFloat_BankAccountPdf_MovmentItemId());
   END IF;

   ioId :=  gpInsertUpdate_Object_BankAccountPdf (ioId                 := ioId
                                                , inPhotoName          := inPhotoName
                                                , inMovmentItemId      := inMovmentItemId
                                                , inBankAccountPdfData := inBankAccountPdfData
                                                , inSession            := inSession);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.               
 12.02.24                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_BankAccountInvoicePdf (ioId:=0, inValue:=100, inProductId:=5, inProductConditionKindId:=6, inSession:='2')