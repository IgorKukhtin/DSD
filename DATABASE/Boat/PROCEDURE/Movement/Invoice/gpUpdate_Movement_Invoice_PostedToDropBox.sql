-- Function: gpUpdate_Movement_Invoice_PostedToDropBox(Integer, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Movement_Invoice_PostedToDropBox(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Invoice_PostedToDropBox(
    IN inMovementId                Integer   , -- ���� ������� <��������>
 INOUT ioisPostedToDropBox         Boolean   , -- ���������� � DropBox   
    IN inSession                   TVarChar    -- ������ ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Product());
   vbUserId:= lpGetUserBySession (inSession);
   
    -- ��������
   IF COALESCE (inMovementId, 0) = 0
   THEN
       --RAISE EXCEPTION '������! ������� �� ����������!';
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������! ������� ��������� �� ��������!'
                                              , inProcedureName := 'gpUpdate_Movement_Invoice_PostedToDropBox'
                                              , inUserId        := vbUserId
                                              );
   END IF;
   
   IF NOT EXISTS(SELECT ObjectFloat_InvoicePdf_MovmentId.ObjectId
                 FROM ObjectFloat AS ObjectFloat_InvoicePdf_MovmentId
                 WHERE ObjectFloat_InvoicePdf_MovmentId.ValueData = inMovementId                                            
                   AND ObjectFloat_InvoicePdf_MovmentId.DescId = zc_ObjectFloat_InvoicePdf_MovementId())
   THEN
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������! ��������� �������� ����������. ��� ������ � �����!'
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
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������! ��������� �������� ����������. �� ����������� ����� �����!'
                                              , inProcedureName := 'gpUpdate_Movement_Invoice_PostedToDropBox'
                                              , inUserId        := vbUserId
                                              );   
   END IF;

   ioisPostedToDropBox := NOT ioisPostedToDropBox;
   
   -- ��������� �������� <�������� �� ��������� ����� � DropBox  >
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PostedToDropBox(), inMovementId, ioisPostedToDropBox);
   
   -- ��������� ��������
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

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