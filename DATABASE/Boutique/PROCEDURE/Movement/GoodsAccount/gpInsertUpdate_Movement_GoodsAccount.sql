-- Function: gpInsertUpdate_Movement_GoodsAccount()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_GoodsAccount (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_GoodsAccount (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_GoodsAccount(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
 INOUT ioInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inFromId               Integer   , -- �� ���� (� ���������)
    IN inToId                 Integer   , -- ���� (� ���������)
    IN inComment              TVarChar  , -- ����������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_GoodsAccount());

     -- ���������� ������� �� �������������� ������������ � ����������
     vbUnitId:= lpGetUnitBySession (inSession);
     
     -- ���� � ������������ = 0, ����� ����� �������� ����� �������, ����� ������ ����
     IF COALESCE (vbUnitId, 0 ) <> 0 AND (COALESCE (vbUnitId) <> inFromId OR COALESCE (vbUnitId) <> inToId)
     THEN
         RAISE EXCEPTION '������.� ������������ <%> ��� ���� �� ������������� <%> .', lfGet_Object_ValueData (vbUserId), lfGet_Object_ValueData (inUnitId);
     END IF;
     
     
     IF COALESCE (ioId, 0) = 0 THEN
         ioInvNumber:= CAST (NEXTVAL ('movement_GoodsAccount_seq') AS TVarChar);  
     ELSEIF vbUserId = zc_User_Sybase() THEN
        ioInvNumber:= (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = ioId);
     END IF;
     
     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_GoodsAccount (ioId                := ioId
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
 14.07.17         *
 18.05.17         *
 */

-- ����
-- select * from gpInsertUpdate_Movement_GoodsAccount(ioId := 7 , ioInvNumber := '4' , inOperDate := ('01.01.2017')::TDateTime , inFromId := 230 , inComment := 'df' ,  inSession := '2');