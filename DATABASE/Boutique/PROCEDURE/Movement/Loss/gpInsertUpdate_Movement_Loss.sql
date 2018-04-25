-- Function: gpInsertUpdate_Movement_Loss()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Loss (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Loss(
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
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Loss());


     -- ������������ ���������� � ���.
     IF vbUserId = zc_User_Sybase() THEN
        -- ioInvNumber:= ioInvNumber;
        UPDATE Movement SET InvNumber = ioInvNumber WHERE Movement.Id = ioId;
        -- ���� ����� ������� �� ��� ������
        IF NOT FOUND THEN
           -- ������
           RAISE EXCEPTION '������. NOT FOUND Movement <%>', ioId;
        END IF;

        -- !!!�����!!!
        RETURN;

     ELSEIF COALESCE (ioId, 0) = 0 THEN
        ioInvNumber:= CAST (NEXTVAL ('Movement_Loss_seq') AS TVarChar);
     ELSEIF vbUserId = zc_User_Sybase() THEN
        ioInvNumber:= (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = ioId);
     END IF;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_Loss (ioId       := ioId
                                         , inInvNumber:= ioInvNumber
                                         , inOperDate := inOperDate
                                         , inFromId   := inFromId
                                         , inToId     := inToId
                                         , inComment  := inComment
                                         , inUserId   := vbUserId
                                          );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 26.06.17         *
 08.05.17         *
 25.04.17         *
 */

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Loss(ioId := 17 , ioInvNumber := '4' , inOperDate := ('01.01.2017')::TDateTime , inFromId := 311 , inToId := 311 , inCurrencyDocumentId := 353 , inComment := 'rfff' ,  inSession := '2');
