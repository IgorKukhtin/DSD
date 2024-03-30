-- Function: gpUpdate_Movement_Invoice_FilesNotUploaded(Integer, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Movement_Invoice_FilesNotUploaded(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Invoice_FilesNotUploaded(
    IN inMovementId                Integer   , -- ���� ������� <��������>
 INOUT ioIsFilesNotUploaded        Boolean   , -- �������� �������� � DropBox (��/���)
   OUT outisPostedToDropBox        Boolean   , -- ���������� � DropBox (��/���)
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
       --RAISE EXCEPTION '������! ������� �� ����������!';
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.�������� �� ��������.'
                                              , inProcedureName := 'gpUpdate_Movement_Invoice_FilesNotUploaded'
                                              , inUserId        := vbUserId
                                              );
   END IF;


   -- ����� �������� <�������� �������� � DropBox (��/���)>
   ioIsFilesNotUploaded := NOT ioIsFilesNotUploaded;

   -- ��������� �������� <�������� �������� � DropBox (��/���)>
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_FilesNotUploaded(), inMovementId, ioIsFilesNotUploaded);

   -- ���� ������ <�������� �������� � DropBox>
   IF ioIsFilesNotUploaded = FALSE
   THEN
       -- ��������� �������� �� <���������� � DropBox>
       PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PostedToDropBox(), inMovementId, FALSE);
   END IF;

   -- ��� ������� <���������� � DropBox (��/���)>
   outisPostedToDropBox := COALESCE((SELECT COALESCE (MovementBoolean_PostedToDropBox.ValueData, FALSE)
                                     FROM MovementBoolean AS MovementBoolean_PostedToDropBox
                                     WHERE MovementBoolean_PostedToDropBox.MovementId = inMovementId
                                       AND MovementBoolean_PostedToDropBox.DescId   = zc_MovementBoolean_PostedToDropBox()), FALSE);

   -- ��������� ��������
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.02.24                                                       *
*/

-- ����
--