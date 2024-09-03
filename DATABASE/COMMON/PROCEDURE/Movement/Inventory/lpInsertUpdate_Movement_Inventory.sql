-- Function: lpInsertUpdate_Movement_Inventory()

--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Boolean, Boolean, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Boolean, Boolean, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Inventory(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inGoodsGroupId        Integer   , -- ������ ������
    IN inPriceListId         Integer   , -- ����� ����
    IN inIsGoodsGroupIn      Boolean   , -- ������ ����. ������
    IN inIsGoodsGroupExc     Boolean   , -- ����� ����. ������
    IN inisList              Boolean   , -- �� ���� ������� ���������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- !!!�������� - �������������� - ������ �� ��������� (��������� ������ ����������)!!!
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = 11109744)
        AND inUserId > 0
     THEN
          RAISE EXCEPTION '������.��� ����.';
     END IF;
     
     -- !!!������ ����� ��������!!!
     IF inUserId < 0 THEN inUserId:= -1 * inUserId; END IF;


     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- ��������
     IF ioId <> 0 AND inOperDate < (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = ioId) - INTERVAL '1 YEAR'
     THEN
         RAISE EXCEPTION '������.���� ��������� ������ ���� ������ <%>.', zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = ioId) - INTERVAL '1 YEAR');
     END IF;


     -- ���������� ���� �������
     vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Inventory());

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Inventory(), inInvNumber, inOperDate, NULL, vbAccessKeyId, inUserId);

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- ��������� ����� � <������ ������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GoodsGroup(), ioId, inGoodsGroupId);

     -- ��������� ����� � <����� ����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), ioId, inPriceListId);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_GoodsGroupIn(), ioId, inIsGoodsGroupIn);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_GoodsGroupExc(), ioId, inIsGoodsGroupExc);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_List(), ioId, inIsList);

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
 25.05.22         *
 22.07.21         *
 18.09.17         *
 29.05.15                                        *
 13.11.14                                        * add vbAccessKeyId
 06.09.14                                        * add lpInsert_MovementProtocol
 18.07.13         * 
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Inventory (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
