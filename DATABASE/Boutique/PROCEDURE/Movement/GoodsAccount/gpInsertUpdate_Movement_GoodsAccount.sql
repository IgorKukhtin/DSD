-- Function: gpInsertUpdate_Movement_GoodsAccount()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_GoodsAccount (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_GoodsAccount(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
 INOUT ioInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inFromId               Integer   , -- �� ���� (� ���������)
    IN inComment              TVarChar  , -- ����������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_GoodsAccount());

     IF COALESCE (ioId, 0) = 0 THEN
         ioInvNumber:= CAST (NEXTVAL ('movement_GoodsAccount_seq') AS TVarChar);  
     END IF;
     
     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_GoodsAccount (ioId                := ioId
                                                 , inInvNumber         := ioInvNumber
                                                 , inOperDate          := inOperDate
                                                 , inFromId            := inFromId
                                                 , inComment           := inComment
                                                 , inUserId            := vbUserId
                                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 18.05.17         *
 */

-- ����
-- select * from gpInsertUpdate_Movement_GoodsAccount(ioId := 7 , ioInvNumber := '4' , inOperDate := ('01.01.2017')::TDateTime , inFromId := 230 , inComment := 'df' ,  inSession := '2');