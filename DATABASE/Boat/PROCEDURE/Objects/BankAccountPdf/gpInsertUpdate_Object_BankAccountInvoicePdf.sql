-- Function: gpInsertUpdate_Object_BankAccountInvoicePdf(Integer, TVarChar, Integer, TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BankAccountInvoicePdf(Integer, TVarChar, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BankAccountInvoicePdf(
 INOUT ioId                        Integer   , -- ���� �������
    IN inPhotoName                 TVarChar  , -- �������� PDF
    IN inMovmentItemId             Integer   , -- ������� BankAccount
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


   -- ��������
   IF COALESCE (inMovmentItemId, 0) = 0
   THEN 
       RAISE EXCEPTION '������.�� ����������� �������� <������� BankAccount>.';
   END IF;

   -- ��������
   IF COALESCE (TRIM (inPhotoName), '') = '' 
   THEN 
       RAISE EXCEPTION '������.�� �������� ��� �����.';
   END IF;


   -- ������ ��������� �����
   ioId:= (SELECT OF_Id.ObjectId 
           FROM ObjectFloat AS OF_Id
                INNER JOIN Object AS Object_BankAccountPdf 
                                  ON Object_BankAccountPdf.Id        = OF_Id.ObjectId 
                                 AND Object_BankAccountPdf.DescId    = zc_Object_BankAccountPdf()
                                 --  � ����� ��������� PDF
                                 AND Object_BankAccountPdf.ValueData = inPhotoName
           -- ������� BankAccount
           WHERE OF_Id.ValueData = inMovmentItemId :: TFloat
             AND OF_Id.DescId    = zc_ObjectFloat_BankAccountPdf_MovmentItemId()
          );

   -- ���������
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