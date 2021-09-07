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
RETURNS RECORD AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementId_last Integer;
   DECLARE vbMovementId_next Integer;
   DECLARE vbOperDate_next TDateTime;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     --������� ���������� ��������,��� ������������� ���� ��������� EndBeginDate  = inOperDate-1 ����
     vbMovementId_last:= (SELECT tmp.Id
                          FROM (SELECT Movement.Id
                                     , Movement.OperDate
                                     , MAX (Movement.OperDate) OVER () AS OperDate_last
                                FROM Movement
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                                 AND MovementLinkObject_Contract.ObjectId = inContractId
                                WHERE Movement.DescId = zc_Movement_ContractGoods()
                                   AND Movement.OperDate < inOperDate
                                   AND Movement.StatusId <> zc_Enum_Status_Erased()  --zc_Enum_Status_Complete()
                                   AND Movement.Id <> ioId
                                ) AS tmp
                          WHERE tmp.OperDate = tmp.OperDate_last
                          );
     
     --������� ����� ��������� ���.
     SELECT tmp.Id
          , tmp.OperDate
   INTO vbMovementId_next, vbOperDate_next
     FROM (SELECT Movement.Id
                , Movement.OperDate
                , MIN (Movement.OperDate) OVER () AS OperDate_last
           FROM Movement
               INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                             ON MovementLinkObject_Contract.MovementId = Movement.Id
                                            AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                            AND MovementLinkObject_Contract.ObjectId = inContractId
           WHERE Movement.DescId = zc_Movement_ContractGoods()
              AND Movement.OperDate > inOperDate
              AND Movement.StatusId <> zc_Enum_Status_Erased()--zc_Enum_Status_Complete()
              AND Movement.Id <> ioId
           ) AS tmp
     WHERE tmp.OperDate = tmp.OperDate_last;

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



     -- ��������� �������� <���� ���������> ����������� ���������
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndBegin(), vbMovementId_last, (inOperDate - interval '1 day')::TDateTime);

     -- ��������� �������� <���� ���������> �������� ���������
     --���� �� ����� ������ ���� zc_DateEnd()
     outEndBeginDate := (CASE WHEN COALESCCE (vbMovementId_next,0) <> 0 THEN (vbOperDate_next - interval '1 day') ELSE zc_DateEnd() END) ::TDateTime;
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndBegin(), ioId, outEndBeginDate);


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