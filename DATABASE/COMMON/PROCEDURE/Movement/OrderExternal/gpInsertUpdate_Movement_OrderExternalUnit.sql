-- Function: gpInsertUpdate_Movement_OrderExternalUnit()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderExternalUnit (Integer, TVarChar, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderExternalUnit(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ������ � �����������
    IN inOperDate            TDateTime , -- ���� ��������� (�������� ������ �� �����������)
    IN inOperDatePartner     TDateTime , -- ���� ��������� (����������� �������� �� ������)
    IN inOperDateMark        TDateTime , -- ���� ����������
    IN inOperDateStart       TDateTime , -- ���� ������� (���.)
    IN inOperDateEnd         TDateTime , -- ���� ������� (������.)
   OUT outPriceWithVAT       Boolean   , -- ���� � ��� (��/���)
   OUT outVATPercent         TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������
   OUT outDayCount           TFloat    , -- ���������� ���� �������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPaidKindId          Integer   , -- ���� ���� ������
    IN inContractId          Integer   , -- ��������
    IN inRouteId             Integer   , -- �������
    IN inRouteSortingId      Integer   , -- ���������� ���������
    IN inPersonalId          Integer   , -- ��������� (����������)
 INOUT ioPriceListId         Integer   , -- ����� ����
   OUT outPriceListName      TVarChar  , -- ����� ����

    IN inRetailId            Integer   , -- �������� ����
    IN inPartnerId           Integer   , -- ����������
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternalUnit());

     -- ����� ��������� ����� ������ ���������� ����.
     vbOperDate_StartBegin:= CLOCK_TIMESTAMP();

     -- ��������
     IF COALESCE (inContractId, 0) = 0 AND NOT EXISTS (SELECT Id FROM Object WHERE Id = inFromId AND DescId = zc_Object_Unit())
     THEN
         RAISE EXCEPTION '������.�� ����������� �������� <�������>.';
     END IF;

     -- 0.
     outDayCount:= 1 + EXTRACT (DAY FROM (inOperDateEnd - inOperDateStart));
     -- 1. ��� ��������� ������ �� �����������
     -- inOperDatePartner:= inOperDate + (COALESCE ((SELECT ValueData FROM ObjectFloat WHERE ObjectId = inFromId AND DescId = zc_ObjectFloat_Partner_PrepareDayCount()), 0) :: TVarChar || ' DAY') :: INTERVAL;

     -- 2. ��� ��������� ������ �� �����-����� !!!�� ���� inOperDatePartner!!!
     IF COALESCE (ioPriceListId, 0) = 0
     THEN
         SELECT PriceListId, PriceListName, PriceWithVAT, VATPercent
                INTO ioPriceListId, outPriceListName, outPriceWithVAT, outVATPercent
         FROM lfGet_Object_Partner_PriceList (inContractId:= inContractId, inPartnerId:= inFromId, inOperDate:= inOperDatePartner);
     ELSE
         SELECT Object_PriceList.ValueData                             AS PriceListName
              , COALESCE (ObjectBoolean_PriceWithVAT.ValueData, FALSE) AS PriceWithVAT
              , ObjectFloat_VATPercent.ValueData                       AS VATPercent
                INTO outPriceListName, outPriceWithVAT, outVATPercent
         FROM Object AS Object_PriceList
              LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                      ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                                     AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
              LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                    ON ObjectFloat_VATPercent.ObjectId = Object_PriceList.Id
                                   AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
         WHERE Object_PriceList.Id = ioPriceListId;
     END IF;


     -- ����������
     ioId:= (SELECT tmp.ioId
             FROM lpInsertUpdate_Movement_OrderExternal (ioId                  := ioId
                                                       , inInvNumber           := inInvNumber
                                                       , inInvNumberPartner    := inInvNumberPartner
                                                       , inOperDate            := inOperDate
                                                       , inOperDatePartner     := inOperDatePartner
                                                       , inOperDateMark        := inOperDateMark
                                                       , inPriceWithVAT        := outPriceWithVAT
                                                       , inVATPercent          := outVATPercent
                                                       , ioChangePercent       := inChangePercent
                                                       , inFromId              := inFromId
                                                       , inToId                := inToId
                                                       , inPaidKindId          := inPaidKindId
                                                       , inContractId          := inContractId
                                                       , inRouteId             := inRouteId
                                                       , inRouteSortingId      := inRouteSortingId
                                                       , inPersonalId          := inPersonalId
                                                       , inPriceListId         := ioPriceListId
                                                       , inPartnerId           := inPartnerId
                                                       , inisPrintComment      := FALSE ::Boolean
                                                       , inUserId              := vbUserId
                                                        ) AS tmp);

     -- ��������� �������� <���� ������ �>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), ioId, inOperDateStart);
     -- ��������� �������� <���� ������ ��>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), ioId, inOperDateEnd);

     -- ��������� ����� � <�������� ����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Retail(), ioId, inRetailId);

     -- �����������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- �������� ��-�� <�������� ����/����� ������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartBegin(), ioId, vbOperDate_StartBegin);
     -- �������� ��-�� <�������� ����/����� ����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndBegin(), ioId, CLOCK_TIMESTAMP());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.05.21         * inisPrintComment
 21.05.15         * add inRetailId, inPartnerId
 11.02.15         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_OrderExternalUnit (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
