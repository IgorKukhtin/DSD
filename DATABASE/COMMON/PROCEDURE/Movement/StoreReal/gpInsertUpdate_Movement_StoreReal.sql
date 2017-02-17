-- Function: gpInsertUpdate_Movement_StoreReal()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_StoreReal (Integer, TVarChar, TDateTime, Integer, Integer, Boolean, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_StoreReal(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
 INOUT ioPriceListId         Integer   , -- ����� ����
    IN inPartnerId           Integer   , -- ����������
   OUT outPriceWithVAT       Boolean   , -- ���� � ��� (��/���)
   OUT outVATPercent         TFloat    , -- % ���
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_StoreReal());

  -- 2. ��� ��������� ������ �� �����-�����
  IF COALESCE (ioPriceListId, 0) = 0
     OR 1=1 -- !!!������ ������!!!
  THEN
      -- !!!������!!!
      SELECT tmp.PriceListId, tmp.PriceListName, tmp.PriceWithVAT, tmp.VATPercent
             INTO ioPriceListId, outPriceListName, outPriceWithVAT, outVATPercent
      FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := inContractId
                                                , inPartnerId      := inFromId
                                                , inMovementDescId := zc_Movement_Sale() -- !!!�� ������!!!
                                                , inOperDate_order := inOperDate
                                                , inOperDatePartner:= NULL
                                                , inDayPrior_PriceReturn:= 0 -- !!!�������� ����� �� �����!!!
                                                , inIsPrior        := FALSE -- !!!�������� ����� �� �����!!!
                                                 ) AS tmp;
      -- !!!������!!!
      -- !!!�� ���� outOperDatePartner!!!
      -- SELECT tmp.PriceListId, tmp.PriceListName, tmp.PriceWithVAT, tmp.VATPercent
      --        INTO ioPriceListId, outPriceListName, outPriceWithVAT, outVATPercent
      -- FROM lfGet_Object_Partner_PriceList (inContractId:= inContractId, inPartnerId:= inFromId, inOperDate:= outOperDatePartner) AS tmp;
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


  -- ����������� ����������� �� ��� ������ ��� ��� �� �����
  ioPersonalId:= COALESCE ((SELECT ObjectLink_Partner_MemberTake.ChildObjectId
                            FROM ObjectLink AS ObjectLink_Partner_MemberTake
                            WHERE ObjectLink_Partner_MemberTake.ObjectId = inFromId
                              AND ObjectLink_Partner_MemberTake.DescId = CASE EXTRACT (DOW FROM inOperDate
                                                                                              + (((COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = inFromId AND ObjectFloat.DescId = zc_ObjectFloat_Partner_PrepareDayCount()),  0)
                                                                                                 + COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = inFromId AND ObjectFloat.DescId = zc_ObjectFloat_Partner_DocumentDayCount()), 0)
                                                                                                  ) :: TVarChar || ' DAY') :: INTERVAL)
                                                                                       )
                                                    WHEN 1 THEN zc_ObjectLink_Partner_MemberTake1()
                                                    WHEN 2 THEN zc_ObjectLink_Partner_MemberTake2()
                                                    WHEN 3 THEN zc_ObjectLink_Partner_MemberTake3()
                                                    WHEN 4 THEN zc_ObjectLink_Partner_MemberTake4()
                                                    WHEN 5 THEN zc_ObjectLink_Partner_MemberTake5()
                                                    WHEN 6 THEN zc_ObjectLink_Partner_MemberTake6()
                                                    WHEN 0 THEN zc_ObjectLink_Partner_MemberTake7()
                                                 END
                           ), ioPersonalId);
  -- �������� ������ �� ioPersonalId
  outPersonalName:= (SELECT Object.ValueData FROM Object WHERE Object.Id = ioPersonalId);


  -- ����������
  ioId:= lpInsertUpdate_Movement_StoreReal (ioId                  := ioId
                                              , inInvNumber           := inInvNumber
                                              , inInvNumberPartner    := inInvNumberPartner
                                              , inOperDate            := inOperDate
                                              , inOperDatePartner     := outOperDatePartner
                                              , inOperDateMark        := inOperDateMark
                                              , inPriceWithVAT        := outPriceWithVAT
                                              , inVATPercent          := outVATPercent
                                              , inChangePercent       := inChangePercent
                                              , inFromId              := inFromId
                                              , inToId                := inToId
                                              , inPaidKindId          := inPaidKindId
                                              , inContractId          := inContractId
                                              , inRouteId             := inRouteId
                                              , inRouteSortingId      := inRouteSortingId
                                              , inPersonalId          := ioPersonalId
                                              , inPriceListId         := ioPriceListId
                                              , inPartnerId           := inPartnerId
                                              , inUserId              := vbUserId
                                               );
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 16.02.17                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_StoreReal (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inSession:= '2')
