-- Function: gpInsertUpdate_Movement_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Income(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
 INOUT ioInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inFromId               Integer   , -- �� ���� (� ���������)
    IN inToId                 Integer   , -- ���� (� ���������)
    IN inCurrencyDocumentId   Integer   , -- ������ (���������)
   OUT outCurrencyValue       TFloat    , -- ���� ������
   OUT outParValue            TFloat    , -- ������� ��� �������� � ������ �������
    IN inComment              TVarChar  , -- ����������
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());


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
        ioInvNumber:= CAST (NEXTVAL ('Movement_Income_seq') AS TVarChar);
     ELSEIF vbUserId = zc_User_Sybase() THEN
        ioInvNumber:= (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = ioId);
     END IF;

     -- ���� �� ������� ������
     IF inCurrencyDocumentId <> zc_Currency_Basis()
     THEN
         -- ���������� ���� �� ���� ���������
         SELECT COALESCE (tmp.Amount, 1), COALESCE (tmp.ParValue,0)
                INTO outCurrencyValue, outParValue
         FROM lfSelect_Movement_Currency_byDate (inOperDate      := inOperDate -- (SELECT Movement.OperDate FROM Movement  WHERE Movement.Id = ioId)
                                               , inCurrencyFromId:= zc_Currency_Basis()
                                               , inCurrencyToId  := inCurrencyDocumentId
                                                ) AS tmp;
     ELSE
         -- ���� �� �����
         outCurrencyValue:= 0;
         outParValue     := 0;

     END IF;


     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_Income (ioId                := ioId
                                           , inInvNumber         := ioInvNumber
                                           , inOperDate          := inOperDate
                                           , inFromId            := inFromId
                                           , inToId              := inToId
                                           , inCurrencyDocumentId:= inCurrencyDocumentId
                                           , inCurrencyValue     := outCurrencyValue
                                           , inParValue          := outParValue
                                           , inComment           := inComment
                                           , inUserId            := vbUserId
                                            );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 08.05.17         *
 10.04.17         *
 */

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Income (ioId:= 22, ioInvNumber:= '3', inOperDate:= '04.02.2018', inFromId:= 229, inToId:= 311, inCurrencyDocumentId:= zc_Currency_USD(), inComment:= 'vbn', inSession:= zfCalc_UserAdmin()));
