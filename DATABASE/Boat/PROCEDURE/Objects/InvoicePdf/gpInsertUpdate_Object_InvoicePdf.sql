-- Function: gpInsertUpdate_Object_InvoicePdf(Integer, TVarChar, Integer, TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InvoicePdf(Integer, TVarChar, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InvoicePdf(
 INOUT ioId                        Integer   , -- ���� �������
    IN inPhotoName                 TVarChar  , --
    IN inMovementId                 Integer   , --  
    IN inInvoicePdfData            TBlob     , -- ����
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
   IF COALESCE (inMovementId, 0) = 0
   THEN
       --RAISE EXCEPTION '������! �������� �� ������!';
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.�������� �� ������.'           :: TVarChar
                                             , inProcedureName := 'gpInsertUpdate_Object_InvoicePdf' :: TVarChar
                                             , inUserId        := vbUserId
                                             );
   END IF;


   -- ���� �����
   IF COALESCE (ioId, 0) = 0 AND COALESCE (TRIM (inPhotoName), '') = '' 
   THEN 
       RETURN;
       -- ��������� �����
       --ioId:= (SELECT OL.ObjectId FROM ObjectFloat AS OL WHERE OL.ValueData ::Integer = inMovementItemId AND OL.DescId = zc_ObjectFloat_InvoicePdf_MovementItemId());
   END IF;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_InvoicePdf(), 0, inPhotoName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_InvoicePdf_Data(), ioId, inInvoicePdfData);

   -- ��������� ����� � <>
   --PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_InvoicePdf_PhotoTag(), ioId, inPhotoTagId);  
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_InvoicePdf_MovementId(), ioId, inMovementId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.02.24         *
*/

-- ����
--