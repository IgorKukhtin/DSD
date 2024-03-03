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
   
   ioisPostedToDropBox := NOT ioisPostedToDropBox;
   
   -- ��������� �������� <���������� � DropBox>
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