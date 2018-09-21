-- Function: gpInsertUpdate_MI_PersonalService_Message()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Message (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_Message(
 INOUT ioId                  Integer   , -- 
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inComment             TVarChar  ,
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbIsInsert Boolean;
BEGIN
     
     -- 
     -- �������� ���� ������������ �� ����� ���������
     --lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService());
     vbUserId := inSession;
     
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;
 
     -- ��������� <������� ���������>
     ioId:= lpInsertUpdate_MovementItem (ioId, zc_MI_Message(), 0, inMovementId, 0, NULL);
   
       -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);
     
     -- ��������� 
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, vbUserId);
   
     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.  ���������� �.�.
 20.09.17         *
*/

-- ����