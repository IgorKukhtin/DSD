-- Function: gpInsertUpdate_Movement_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income 
                       (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income
                       (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Income(
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
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());

     IF COALESCE (ioId, 0) = 0 THEN
         ioInvNumber:= CAST (NEXTVAL ('movement_income_seq') AS TVarChar);  
     END IF;

     outCurrencyValue := 1;
     outParValue := 0;
     
     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_Income (ioId                := ioId
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
 10.04.17         *
 */

-- ����
-- select * from gpInsertUpdate_Movement_Income(ioId := 22 , ioInvNumber := '3' , inOperDate := ('04.02.2018')::TDateTime , inFromId := 229 , inToId := 311 , inCurrencyDocumentId := 0 , inCurrencyPartnerId := 0 , inCurrencyPartnerValue := 1 , inParPartnerValue := 0 , inComment := 'vbn' ,  inSession := '2');