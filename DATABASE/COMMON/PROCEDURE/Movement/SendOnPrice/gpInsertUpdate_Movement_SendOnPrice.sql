-- Function: gpInsertUpdate_Movement_SendOnPrice()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendOnPrice (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendOnPrice (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendOnPrice (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendOnPrice (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SendOnPrice(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inOperDatePartner     TDateTime , -- ���� ��������� � �����������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inRouteSortingId      Integer   , -- ���������� ���������
    IN inSubjectDocId        Integer   , -- ��������� ��� �����������
 INOUT ioPriceListId         Integer   , -- ����� ����
   OUT outPriceListName      TVarChar  , -- ����� ����
    IN inMovementId_Order    Integer    , -- ���� ���������
    IN inComment             TVarChar   , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SendOnPrice());

     -- ��������� <��������>
     SELECT tmp.ioId, tmp.ioPriceListId, tmp.outPriceListName
            INTO ioId, ioPriceListId, outPriceListName
     FROM lpInsertUpdate_Movement_SendOnPrice
                                       (ioId               := ioId
                                      , inInvNumber        := inInvNumber
                                      , inOperDate         := inOperDate
                                      , inOperDatePartner  := inOperDatePartner
                                      , inPriceWithVAT     := inPriceWithVAT
                                      , inVATPercent       := inVATPercent
                                      , inChangePercent    := inChangePercent
                                      , inFromId           := inFromId
                                      , inToId             := inToId
                                      , inRouteSortingId   := inRouteSortingId
                                      , inSubjectDocId     := inSubjectDocId
                                      , inMovementId_Order := inMovementId_Order
                                      , ioPriceListId      := ioPriceListId
                                      , inProcessId        := zc_Enum_Process_InsertUpdate_Movement_SendOnPrice()
                                      , inUserId           := vbUserId
                                       ) AS tmp;


    -- �����������
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.02.20         *
 08.06.15         * 
 05.05.14                                                        *   ��������� ��� �� ����� �� ���� ���� �������.
 16.07.13                                        * zc_Movement_SendOnPrice
 12.07.13         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_SendOnPrice (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
