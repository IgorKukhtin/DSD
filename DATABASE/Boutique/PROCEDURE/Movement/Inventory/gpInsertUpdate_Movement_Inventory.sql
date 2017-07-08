-- Function: gpInsertUpdate_Movement_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Inventory(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
 INOUT ioInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inFromId               Integer   , -- �������������
    IN inToId                 Integer   , -- �����
    IN inComment              TVarChar  , -- ����������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Inventory());
     
     IF COALESCE (ioId, 0) = 0 THEN
         ioInvNumber:= CAST (NEXTVAL ('movement_inventory_seq') AS TVarChar);  
     ELSEIF vbUserId = zc_User_Sybase() THEN
        ioInvNumber:= (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = ioId);
     END IF;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_Inventory (ioId                := ioId
                                              , inInvNumber         := ioInvNumber
                                              , inOperDate          := inOperDate
                                              , inFromId            := inFromId
                                              , inToId              := inToId
                                              , inComment           := inComment
                                              , inUserId            := vbUserId
                                              );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 02.05.17         *
 */

-- ����
-- select * from gpInsertUpdate_Movement_Inventory(ioId := 25 , ioInvNumber := '3' , inOperDate := ('01.01.2017')::TDateTime , inFromId := 311 , inToId := 0 , inComment := 'sdfgh' ,  inSession := '2');