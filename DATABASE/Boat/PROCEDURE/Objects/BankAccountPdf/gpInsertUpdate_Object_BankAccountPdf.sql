-- Function: gpInsertUpdate_Object_BankAccountPdf(Integer, TVarChar, Integer, TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BankAccountPdf(Integer, TVarChar, Integer, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BankAccountPdf(
 INOUT ioId                        Integer   , -- ���� �������
    IN inPhotoName                 TVarChar  , --
    IN inMovmentItemId             Integer   , --  
    IN inPhotoTagId                Integer   ,
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
       --RAISE EXCEPTION '������! �������� �� ������!';
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.�������� �� ������.'           :: TVarChar
                                             , inProcedureName := 'gpInsertUpdate_Object_BankAccountPdf' :: TVarChar
                                             , inUserId        := vbUserId
                                             );
   END IF;


   -- ���� �����
   IF COALESCE (ioId, 0) = 0 AND COALESCE (TRIM (inPhotoName), '') = '' 
   THEN 
       RETURN;
       -- ��������� �����
       --ioId:= (SELECT OL.ObjectId FROM ObjectFloat AS OL WHERE OL.ValueData ::Integer = inMovmentItemId AND OL.DescId = zc_ObjectFloat_BankAccountPdf_MovmentItemId());
   END IF;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_BankAccountPdf(), 0, inPhotoName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_BankAccountPdf_Data(), ioId, inBankAccountPdfData);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_BankAccountPdf_PhotoTag(), ioId, inPhotoTagId);  
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_BankAccountPdf_MovmentItemId(), ioId, inMovmentItemId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.01.24         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_BankAccountPdf (ioId:=0, inValue:=100, inProductId:=5, inProductConditionKindId:=6, inSession:='2')

