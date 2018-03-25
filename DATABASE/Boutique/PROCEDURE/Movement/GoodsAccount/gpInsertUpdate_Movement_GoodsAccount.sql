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
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_GoodsAccount());
     vbUserId := lpGetUserBySession (inSession);


     -- �������� ����� �� �������� ����� �������, ��� ������ ����
     PERFORM lpCheckUnit_byUser (inUnitId_by:= inToId, inUserId:= vbUserId);

     
     -- ������������ ���������� � ���.
     IF COALESCE (ioId, 0) = 0 THEN
         ioInvNumber:= CAST (NEXTVAL ('Movement_GoodsAccount_seq') AS TVarChar);  
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
-- SELECT * FROM gpInsertUpdate_Movement_GoodsAccount(ioId := 7 , ioInvNumber := '4' , inOperDate := ('01.01.2017')::TDateTime , inFromId := 230 , inComment := 'df' ,  inSession := '2');
