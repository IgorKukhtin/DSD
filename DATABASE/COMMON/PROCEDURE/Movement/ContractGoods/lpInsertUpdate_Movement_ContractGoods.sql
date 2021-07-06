-- Function: lpInsertUpdate_Movement_ContractGoods()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, TDateTime, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ContractGoods(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
 INOUT ioInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ��������� / � ����� ���� ���������
    IN inEndBeginDate        TDateTime , -- �� ����� ���� ���������
    IN inContractId          Integer   , --
    IN inComment             TVarChar  , -- ����������
    IN inUserId              Integer     -- ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     IF vbIsInsert = TRUE
     THEN
         ioInvNumber := CAST (NEXTVAL ('Movement_ContractGoods_seq') AS TVarChar);
     END IF;
     
     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ContractGoods(), ioInvNumber, inOperDate, NULL, NULL);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);

     -- �����������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- ��������� �������� <���� ��������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndBegin(), ioId, inEndBeginDate);

     IF vbIsInsert = TRUE
     THEN
         -- ��������� �������� <���� ��������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (��������)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     ELSE
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.07.21         *
*/

-- ����
-- 