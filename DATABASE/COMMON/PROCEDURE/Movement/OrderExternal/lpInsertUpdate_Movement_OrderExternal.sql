-- Function: lpInsertUpdate_Movement_OrderExternal()

--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderExternal (Integer, TVarChar, TVarChar, TDateTime, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderExternal (Integer, TVarChar, TVarChar, TDateTime, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_OrderExternal(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ������ � �����������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inOperDatePartner     TDateTime , -- ���� �������� ������ �� �����������
    IN inOperDateMark        TDateTime , -- ���� ����������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
 INOUT ioChangePercent       TFloat    , -- (-)% ������ (+)% �������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPaidKindId          Integer   , -- ���� ���� ������
    IN inContractId          Integer   , -- ��������
    IN inRouteId             Integer   , -- �������
    IN inRouteSortingId      Integer   , -- ���������� ���������
    IN inPersonalId          Integer   , -- ��������� (����������)
    IN inPriceListId         Integer   , -- ����� ����
    IN inPartnerId           Integer   , -- ����������
    IN inIsPrintComment      Boolean   , -- �������� ���������� � ��������� ��������� (��/���)
    IN inUserId              Integer     -- ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate) OR inOperDatePartner <> DATE_TRUNC ('DAY', inOperDatePartner) OR inOperDateMark <> DATE_TRUNC ('DAY', inOperDateMark)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;


     -- ������, �.�. ������ �������
     ioChangePercent:= COALESCE ((SELECT Object_PercentView.ChangePercent FROM Object_ContractCondition_PercentView AS Object_PercentView WHERE Object_PercentView.ContractId = inContractId AND inOperDate BETWEEN Object_PercentView.StartDate AND Object_PercentView.EndDate), 0);


     -- ���������� ���� �������
   --vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());
     vbAccessKeyId:= CASE WHEN inFromId = 8411 -- ����� �� � ����
                               THEN zc_Enum_Process_AccessKey_DocumentKiev() 
                          WHEN inToId = 8411 -- ����� �� � ����
                               THEN zc_Enum_Process_AccessKey_DocumentKiev() 
                          WHEN inToId = 346093 -- ����� �� �.������
                               THEN zc_Enum_Process_AccessKey_DocumentOdessa() 
                          WHEN inToId = 8413 -- ����� �� �.������ ���
                               THEN zc_Enum_Process_AccessKey_DocumentKrRog() 
                          WHEN inToId = 8417 -- ����� �� �.�������� (������)
                               THEN zc_Enum_Process_AccessKey_DocumentNikolaev() 
                          WHEN inToId = 8425 -- ����� �� �.�������
                               THEN zc_Enum_Process_AccessKey_DocumentKharkov() 
                          WHEN inToId = 8415 -- ����� �� �.�������� (����������)
                               THEN zc_Enum_Process_AccessKey_DocumentCherkassi() 
                          WHEN inToId = 301309 -- ����� �� �.���������
                               THEN zc_Enum_Process_AccessKey_DocumentZaporozhye() 
                          WHEN inToId = 3080691 -- ����� �� �.�����
                               THEN zc_Enum_Process_AccessKey_DocumentLviv() 

                          WHEN inToId = 8020714 -- ����� ���� �� (����)
                               THEN zc_Enum_Process_AccessKey_DocumentIrna() 

                          ELSE lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_OrderExternal())
                     END;


     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderExternal(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� �������� <���� ����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateMark(), ioId, inOperDateMark);
     -- ��������� �������� <���� �������� �����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);

     -- ��������� �������� <����� ������ � �����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- ��������� �������� <�������� ���������� � ��������� ���������(��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PrintComment(), ioId, inIsPrintComment);

     -- ��������� �������� <% ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- ��������� �������� <(-)% ������ (+)% ������� >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, ioChangePercent);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- ��������� ����� � <���� ���� ������ >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Route(), ioId, inRouteId);
     -- ��������� ����� � <���������� ���������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_RouteSorting(), ioId, inRouteSortingId);

     -- ��������� ����� � <��������� (����������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Personal(), ioId, inPersonalId);

     -- ��������� ����� � <����� ����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), ioId, inPriceListId);

     -- ��������� ����� � <����������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), ioId, inPartnerId);    


     IF vbIsInsert = TRUE
     THEN
         -- ��������� �������� <���� ��������> - ��� �������� � ��� ����., ����� ���� ��������
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- ��������� ����� � <������������>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     END IF;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.05.21         * add inIsPrintComment
 26.05.15         * add inPartnerId
 19.02.15         * add OperDateStart, OperDateEnd
 25.08.14                                        *
*/
/*
-- update Movement set AccessKeyId = AccessKeyId_new from (
select Object_to.*, Movement.Id, Movement.OperDate, Movement.InvNumber, Movement.AccessKeyId AS AccessKeyId_old
                   , CASE WHEN MovementLinkObject .ObjectId = 8411 -- ����� �� � ����
                               THEN zc_Enum_Process_AccessKey_DocumentKiev() 
                          WHEN MovementLinkObject.ObjectId IN (346093 -- ����� �� �.������
                                                             , 346094 -- ����� ��������� �.������
                                                              )
                               THEN zc_Enum_Process_AccessKey_DocumentOdessa() 
                          WHEN MovementLinkObject.ObjectId IN (8413 -- ����� �� �.������ ���
                                                             , 428366 -- ����� ��������� �.������ ���
                                                              )
                               THEN zc_Enum_Process_AccessKey_DocumentKrRog() 
                          WHEN MovementLinkObject .ObjectId= 8417 -- ����� �� �.�������� (������)
                               THEN zc_Enum_Process_AccessKey_DocumentNikolaev() 
                          WHEN MovementLinkObject.ObjectId IN (8425   -- ����� �� �.�������
                                                             , 409007 -- ����� ��������� �.�������
                                                              )
                               THEN zc_Enum_Process_AccessKey_DocumentKharkov() 
                          WHEN MovementLinkObject .ObjectId= 8415 -- ����� �� �.�������� (����������)
                               THEN zc_Enum_Process_AccessKey_DocumentCherkassi() 
                          WHEN MovementLinkObject .ObjectId= 301309 -- ����� �� �.���������
                               THEN zc_Enum_Process_AccessKey_DocumentZaporozhye() 
                          WHEN MovementLinkObject .ObjectId = 3080691 -- ����� �� �.�����
                               THEN zc_Enum_Process_AccessKey_DocumentLviv() 
                          ELSE zc_Enum_Process_AccessKey_DocumentDnepr()
                     END as AccessKeyId_new
from Movement 
 left join     MovementLinkObject as mlo on mlo.DescId = zc_MovementLinkObject_from() 
            and mlo.MovementId = Movement .Id
 left join     MovementLinkObject on MovementLinkObject.DescId = zc_MovementLinkObject_To() 
            and MovementLinkObject .MovementId = Movement .Id
 left join     Object as Object_from on Object_from.Id = MLO.ObjectId 
 left join     Object as Object_to on Object_to.Id = MovementLinkObject.ObjectId 
 left join     Object as Object_a on Object_a.Id = Movement.AccessKeyId
where Movement.OperDate >= '01.12.2020'
and Movement.DescId = zc_Movement_OrderExternal()
and Object_from.DescId <> zc_Object_Unit()
-- and Movement.StatusId <> zc_Enum_Status_Erased()
and Movement.AccessKeyId <> CASE WHEN MovementLinkObject .ObjectId = 8411 -- ����� �� � ����
                               THEN zc_Enum_Process_AccessKey_DocumentKiev() 
                          WHEN MovementLinkObject.ObjectId IN (346093 -- ����� �� �.������
                                                             , 346094 -- ����� ��������� �.������
                                                              )
                               THEN zc_Enum_Process_AccessKey_DocumentOdessa() 
                          WHEN MovementLinkObject.ObjectId IN (8413 -- ����� �� �.������ ���
                                                             , 428366 -- ����� ��������� �.������ ���
                                                              )
                               THEN zc_Enum_Process_AccessKey_DocumentKrRog() 
                          WHEN MovementLinkObject .ObjectId= 8417 -- ����� �� �.�������� (������)
                               THEN zc_Enum_Process_AccessKey_DocumentNikolaev() 
                          WHEN MovementLinkObject.ObjectId IN (8425   -- ����� �� �.�������
                                                             , 409007 -- ����� ��������� �.�������
                                                              )
                               THEN zc_Enum_Process_AccessKey_DocumentKharkov() 
                          WHEN MovementLinkObject .ObjectId= 8415 -- ����� �� �.�������� (����������)
                               THEN zc_Enum_Process_AccessKey_DocumentCherkassi() 
                          WHEN MovementLinkObject .ObjectId= 301309 -- ����� �� �.���������
                               THEN zc_Enum_Process_AccessKey_DocumentZaporozhye() 
                          WHEN MovementLinkObject .ObjectId = 3080691 -- ����� �� �.�����
                               THEN zc_Enum_Process_AccessKey_DocumentLviv() 
                          ELSE zc_Enum_Process_AccessKey_DocumentDnepr()
                     END
limit 100 
--) as tmp 
--where Movement.Id = tmp.Id
*/
-- ����
-- SELECT * FROM lpInsertUpdate_Movement_OrderExternal (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
