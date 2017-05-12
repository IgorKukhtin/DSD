-- Function: gpInsertUpdate_Movement_ReturnOut()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnOut 
                (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnOut 
                (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ReturnOut(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
 INOUT ioInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inFromId               Integer   , -- �� ���� (� ���������)
    IN inToId                 Integer   , -- ���� (� ���������)
    IN inCurrencyDocumentId   Integer   , -- ������ (���������)
    IN inCurrencyPartnerId    Integer   , -- ������ (�����������)
   OUT outCurrencyValue       TFloat    , -- ���� ������
   OUT outParValue            TFloat    , -- ������� ��� �������� � ������ �������
    IN inCurrencyPartnerValue TFloat    , -- ���� ��� ������� ����� ��������
    IN inParPartnerValue      TFloat    , -- ������� ��� ������� ����� ��������
    IN inComment              TVarChar  , -- ����������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnOut());

     IF COALESCE (ioId, 0) = 0 THEN
         ioInvNumber:= CAST (NEXTVAL ('movement_returnout_seq') AS TVarChar);  
     END IF;

     -- ������ �� �����
     SELECT Movement.OperDate
    INTO vbOperDate
     FROM Movement 
     WHERE Movement.Id = ioId;

    IF inCurrencyDocumentId <> zc_Currency_Basis() THEN
        SELECT COALESCE (tmp.Amount,1), COALESCE (tmp.ParValue,0)
       INTO outCurrencyValue, outParValue
        FROM lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= inCurrencyDocumentId ) AS tmp;
    END IF;
     
     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_ReturnOut (ioId                := ioId
                                              , inInvNumber         := ioInvNumber
                                              , inOperDate          := inOperDate
                                              , inFromId            := inFromId
                                              , inToId              := inToId
                                              , inCurrencyDocumentId:= inCurrencyDocumentId
                                              , inCurrencyPartnerId := inCurrencyPartnerId
                                              , inCurrencyValue     := outCurrencyValue
                                              , inParValue          := outParValue
                                              , inCurrencyPartnerValue := inCurrencyPartnerValue
                                              , inParPartnerValue   := inParPartnerValue
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
 24.04.17         *
 */

-- ����
-- select * from gpInsertUpdate_Movement_ReturnOut(ioId := 7 , ioInvNumber := '4' , inOperDate := ('01.01.2017')::TDateTime , inFromId := 230 , inToId := 229 , inCurrencyDocumentId := 0 , inCurrencyPartnerId := 0 , inCurrencyPartnerValue := 1 , inParPartnerValue := 0 , inComment := 'df' ,  inSession := '2');