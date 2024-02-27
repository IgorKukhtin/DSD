-- Function: gpDelete_Movement_Invoice_FilesNotUploaded(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpDelete_Movement_Invoice_FilesNotUploaded(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Movement_Invoice_FilesNotUploaded(
    IN inId                        Integer   , -- ���� ������� <��������>
    IN inSession                   TVarChar    -- ������ ������������
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Product());
   vbUserId:= lpGetUserBySession (inSession);
   
    -- ��������
   IF COALESCE (inId, 0) = 0
   THEN
       --RAISE EXCEPTION '������! ������� �� ����������!';
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������! ������� ��������� �� ��������!'
                                              , inProcedureName := 'gpDelete_Movement_Invoice_FilesNotUploaded'
                                              , inUserId        := vbUserId
                                              );
   END IF;
   
   -- �������� 
   DELETE FROM MovementBoolean 
   WHERE MovementBoolean.MovementId = inId
     AND MovementBoolean.DescId = zc_MovementBoolean_FilesNotUploaded();
   
   -- ��������� ��������
   PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

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