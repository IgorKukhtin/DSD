-- Function: lpInsertUpdate_Movement_ContractGoods()

--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, Integer, TVarChar, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, Integer, Integer, TFloat, TFloat, TVarChar, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, Integer, Integer, TFloat, TFloat, Boolean, TVarChar, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, Integer, Integer, TFloat, TFloat, Boolean, Boolean, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, TFloat, Boolean, Boolean, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ContractGoods(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
 INOUT ioInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ��������� / � ����� ���� ���������
   OUT outEndBeginDate       TDateTime , -- �� ����� ���� ���������
    IN inContractId          Integer   , --
    IN inCurrencyId          Integer   , -- ������
    IN inSiteTagId           Integer   , -- ��������� ���� 
    IN inDiffPrice           TFloat    ,  -- ����������� % ���������� ��� ����
    IN inRoundPrice          TFloat    ,  -- ���-�� ������ ��� ����������   
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���) 
    IN inisMultWithVAT       Boolean   , -- ���� ������� ���
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
     vbMovementId_old:= (SELECT tmp.Id
                         FROM (SELECT Movement.Id
                                      -- �� ��������, ����� ������ ����������
                                    , ROW_NUMBER() OVER (ORDER BY Movement.OperDate DESC) AS Ord
                               FROM Movement
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                                 AND MovementLinkObject_Contract.ObjectId = inContractId
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Currency
                                                                  ON MovementLinkObject_Currency.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Currency.DescId = zc_MovementLinkObject_Currency()
                                                                 AND MovementLinkObject_Currency.ObjectId = inCurrencyId
                               WHERE Movement.DescId = zc_Movement_ContractGoods()
                                  AND Movement.OperDate < inOperDate
                                  AND Movement.StatusId <> zc_Enum_Status_Erased()  --zc_Enum_Status_Complete() 
                                  AND Movement.Id <> ioId 
                               ) AS tmp
                         WHERE tmp.Ord = 1
                         LIMIT 1
                        );
     
     -- ������� ����� ��������� ���.
     SELECT tmp.Id, tmp.OperDate
            INTO vbMovementId_next, vbOperDate_next
     FROM (SELECT Movement.Id, Movement.OperDate
                  -- �� �����������, ����� ������ ���������
                , ROW_NUMBER() OVER (ORDER BY Movement.OperDate ASC) AS Ord
           FROM Movement
               INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                             ON MovementLinkObject_Contract.MovementId = Movement.Id
                                            AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                            AND MovementLinkObject_Contract.ObjectId = inContractId
               INNER JOIN MovementLinkObject AS MovementLinkObject_Currency
                                             ON MovementLinkObject_Currency.MovementId = Movement.Id
                                            AND MovementLinkObject_Currency.DescId = zc_MovementLinkObject_Currency()
                                            AND MovementLinkObject_Currency.ObjectId = inCurrencyId
           WHERE Movement.DescId = zc_Movement_ContractGoods()
              AND Movement.OperDate > inOperDate
              AND Movement.StatusId <> zc_Enum_Status_Erased()--zc_Enum_Status_Complete()
              AND Movement.Id <> ioId 
          ) AS tmp
     WHERE tmp.Ord = 1
     LIMIT 1;

     -- �������� ���� � �������� ���������
     outEndBeginDate := (CASE WHEN vbMovementId_next > 0 THEN vbOperDate_next - INTERVAL '1 DAY' ELSE zc_DateEnd() END);

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
     -- ��������� ����� � <������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Currency(), ioId, inCurrencyId);
     -- ��������� ����� � <��������� �����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SiteTag(), ioId, inSiteTagId);
     
     -- ��������� �������� <���� ���������> �������� ���������
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndBegin(), ioId, outEndBeginDate);

     -- ����������� % ���������� ��� ����
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiffPrice(), ioId, inDiffPrice);
     -- ���-�� ������ ��� ����������
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_RoundPrice(), ioId, inRoundPrice);

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_MultWithVAT(), ioId, inisMultWithVAT);
     
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
     IF COALESCE (vbMovementId_old,0) > 0
     THEN
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndBegin(), vbMovementId_old, (inOperDate - INTERVAL '1 day')::TDateTime);
     END IF;

    
                          
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.02.25         *
 02.12.24         *
 15.11.24         *
 29.11.23         *
 08.11.23         *
 15.09.22         *
 14.09.22         *
 05.07.21         *
*/

-- ����
-- 