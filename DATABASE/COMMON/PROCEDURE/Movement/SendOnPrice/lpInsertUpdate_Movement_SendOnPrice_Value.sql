-- Function: lpInsertUpdate_Movement_SendOnPrice_Value()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_SendOnPrice_Value (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_SendOnPrice_Value (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_SendOnPrice_Value(
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
    IN inMovementId_Order    Integer    , -- ���� ���������
    IN ioPriceListId         Integer   , -- ����� ����
    IN inProcessId           Integer   , -- 
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
BEGIN
     -- ��������� <��������>
     ioId:=
    (SELECT tmp.ioId
     FROM lpInsertUpdate_Movement_SendOnPrice (ioId               := ioId
                                             , inInvNumber        := inInvNumber
                                             , inOperDate         := inOperDate
                                             , inOperDatePartner  := inOperDatePartner
                                             , inPriceWithVAT     := inPriceWithVAT
                                             , inVATPercent       := inVATPercent
                                             , inChangePercent    := inChangePercent
                                             , inFromId           := inFromId
                                             , inToId             := inToId
                                             , inRouteSortingId   := inRouteSortingId
                                             , inSubjectDocId     := 0--inSubjectDocId
                                             , inMovementId_Order := inMovementId_Order
                                             , ioPriceListId      := ioPriceListId
                                             , inProcessId        := inProcessId
                                             , inUserId           := inUserId
                                              ) AS tmp);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 04.02.15                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_SendOnPrice_Value (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
