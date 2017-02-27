-- Function: lpInsertUpdate_Movement_StoreReal()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_StoreReal (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Boolean, TFloat);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_StoreReal (
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inUserId              Integer   , -- ������������
    IN inPriceListId         Integer   , -- ����� ����
    IN inPartnerId           Integer   , -- ����������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat      -- % ���
)
RETURNS Integer 
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
      -- ��������
      IF inOperDate <> DATE_TRUNC('DAY', inOperDate)
      THEN
        RAISE EXCEPTION '������.�������� ������ ����.';
      END IF;

      -- ���������� ���� �������
      vbAccessKeyId := NULL; -- lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_StoreReal());

      -- ���������� ������� ��������/�������������
      vbIsInsert := COALESCE(ioId, 0) = 0;

      -- ��������� <��������>
      ioId := lpInsertUpdate_Movement(ioId, zc_Movement_StoreReal(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

      IF vbIsInsert 
      THEN
           -- ��������� ����� � <������������>
           PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_Insert(), ioId, inUserId);
           -- ��������� �������� <���� ��������>
           PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
      END IF;

      -- ��������� ����� � <����� ����>
      PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PriceList(), ioId, inPriceListId);

      -- ��������� ����� � <����������>
      PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_Partner(), ioId, inPartnerId);    

      -- ��������� �������� <���� � ��� (��/���)>
      PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
      -- ��������� �������� <% ���>
      PERFORM lpInsertUpdate_MovementFloat(zc_MovementFloat_VATPercent(), ioId, inVATPercent);

      -- ����������� �������� ����� �� ���������
      PERFORM lpInsertUpdate_MovementFloat_TotalSumm(ioId);

      -- ��������� ��������
      PERFORM lpInsert_MovementProtocol(ioId, inUserId, vbIsInsert);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 16.02.17                                                        *                                          
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_StoreReal (ioId := 0, inInvNumber := '-1', inOperDate := CURRENT_DATE, inUserId := 2, inPriceListId := 0, inPartnerId := 0, inPriceWithVAT := TRUE, inVATPercent := 20);
