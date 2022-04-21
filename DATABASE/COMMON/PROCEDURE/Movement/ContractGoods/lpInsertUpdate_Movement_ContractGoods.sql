-- Function: lpInsertUpdate_Movement_ContractGoods()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ContractGoods(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
 INOUT ioInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ��������� / � ����� ���� ���������
   OUT outEndBeginDate       TDateTime , -- �� ����� ���� ���������
    IN inContractId          Integer   , --
    IN inComment             TVarChar  , -- ����������
    IN inUserId              Integer     -- ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbIsInsert Boolean;

   DECLARE vbMovementId_old  Integer;
   DECLARE vbMovementId_next Integer;
   DECLARE vbOperDate_next   TDateTime;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- ��������
     IF COALESCE (inContractId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� <�������>.';
     END IF;

     -- ������� ���������� ��������,��� ������������� ���� ��������� EndBeginDate  = inOperDate-1 ����
     vbMovementId_old:= (SELECT Movement.Id
                         FROM Movement
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                           AND MovementLinkObject_Contract.ObjectId = inContractId
                         WHERE Movement.DescId = zc_Movement_ContractGoods()
                            AND Movement.OperDate < inOperDate
                            AND Movement.StatusId <> zc_Enum_Status_Erased()  --zc_Enum_Status_Complete()
                         ORDER BY Movement.OperDate DESC
                         LIMIT 1
                        );
     
     -- ������� ����� ��������� ���.
     SELECT Movement.Id, Movement.OperDate
            INTO vbMovementId_next, vbOperDate_next
     FROM Movement
         INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                      AND MovementLinkObject_Contract.ObjectId = inContractId
     WHERE Movement.DescId = zc_Movement_ContractGoods()
        AND Movement.OperDate > inOperDate
        AND Movement.StatusId <> zc_Enum_Status_Erased()--zc_Enum_Status_Complete()
     ORDER BY Movement.OperDate ASC
     LIMIT 1;

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

     -- ��������� �������� <���� ���������> �������� ���������
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndBegin(), ioId, CASE WHEN vbMovementId_next > 0 THEN vbOperDate_next - INTERVAL '1 DAY' ELSE zc_DateEnd() END);

     -- �����������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);



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


     -- ��������� �������� <���� ���������> ����������� ���������
     IF vbMovementId_old > 0
     THEN
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndBegin(), vbMovementId_old, (inOperDate - INTERVAL '1 day')::TDateTime);
     END IF;

    
                          
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