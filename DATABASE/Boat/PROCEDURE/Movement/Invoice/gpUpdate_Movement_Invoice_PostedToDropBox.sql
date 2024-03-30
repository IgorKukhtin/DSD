-- Function: gpUpdate_Movement_Invoice_PostedToDropBox(Integer, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Movement_Invoice_PostedToDropBox(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Invoice_PostedToDropBox(
    IN inMovementId                Integer   , -- ���� ������� <��������>
 INOUT ioIsPostedToDropBox         Boolean   , -- ���������� � DropBox (��/���)
   OUT outIsFilesNotUploaded       Boolean   , -- �������� �������� � DropBox (��/���)
    IN inSession                   TVarChar    -- ������ ������������
)
RETURNS RECORD
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
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.�������� �� ��������.'
                                              , inProcedureName := 'gpUpdate_Movement_Invoice_PostedToDropBox'
                                              , inUserId        := vbUserId
                                              );
   END IF;

   IF NOT EXISTS(SELECT ObjectFloat_InvoicePdf_MovmentId.ObjectId
                 FROM ObjectFloat AS ObjectFloat_InvoicePdf_MovmentId
                 WHERE ObjectFloat_InvoicePdf_MovmentId.ValueData = inMovementId
                   AND ObjectFloat_InvoicePdf_MovmentId.DescId = zc_ObjectFloat_InvoicePdf_MovementId())
   THEN
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.��������� �������� ����������.�� ������������ PDF �� �����.'
                                              , inProcedureName := 'gpUpdate_Movement_Invoice_PostedToDropBox'
                                              , inUserId        := vbUserId
                                              );
   END IF;

   IF NOT EXISTS(SELECT MovementFloat_Amount.MovementId
                 FROM MovementFloat AS MovementFloat_Amount
                 WHERE MovementFloat_Amount.MovementId = inMovementId
                   AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
                   AND COALESCE(MovementFloat_Amount.ValueData, 0) <> 0)
   THEN
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.��������� �������� ����������.�� ����������� ����� �����.'
                                              , inProcedureName := 'gpUpdate_Movement_Invoice_PostedToDropBox'
                                              , inUserId        := vbUserId
                                              );
   END IF;

   -- ����� �������� <���������� � DropBox (��/���)>
   -- ioIsPostedToDropBox := NOT ioIsPostedToDropBox;
   IF vbUserId = 262864 -- Import-Export"
   THEN
       ioIsPostedToDropBox := TRUE;
   ELSE
       ioIsPostedToDropBox := FALSE;
   END IF;

   -- ��������� �������� <���������� � DropBox (��/���)>
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PostedToDropBox(), inMovementId, ioIsPostedToDropBox);


   -- ����� �������� <�������� �������� � DropBox (��/���)>
   outIsFilesNotUploaded:= FALSE;

   -- ��� ��������� �������� <�������� �������� � DropBox (��/���)>
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_FilesNotUploaded(), inMovementId, outIsFilesNotUploaded);

   -- ��������� ��������
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.03.24                                                       *
*/

-- ����
--