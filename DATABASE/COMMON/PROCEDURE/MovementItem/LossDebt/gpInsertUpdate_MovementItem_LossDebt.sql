-- Function: gpInsertUpdate_MovementItem_LossDebt ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_LossDebt (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Boolean, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_LossDebt (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Integer, Integer, Integer, Integer, TVarChar);
/*DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_LossDebt (Integer, Integer, Integer, Integer, Integer
                                                            , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                            , Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar);
*/
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_LossDebt (Integer, Integer, Integer, Integer, Integer, Integer
                                                            , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                            , Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_LossDebt(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ���������
    IN inJuridicalId           Integer   , -- ��.����
    IN inJuridicalBasisId      Integer   , -- �� ��.����
    IN inPartnerId             Integer   , -- ����������
    IN inBranchId              Integer   , -- ������
    IN inContainerId           TFloat    , -- ContainerId
 INOUT ioAmountDebet           TFloat    , -- �����
 INOUT ioAmountKredit          TFloat    , -- �����
 INOUT ioSummDebet             TFloat    , -- ����� ������� (����)
 INOUT ioSummKredit            TFloat    , -- ����� ������� (����)
    IN inCurrencyPartnerValue  TFloat    , -- ���� ��� ������� ����� �������� � ���
    IN inParPartnerValue       TFloat    , -- ������� ��� ������� ����� �������� � ���
 INOUT ioAmountCurrencyDebet   TFloat    , -- ����� �������� (� ������)
 INOUT ioAmountCurrencyKredit  TFloat    , -- ����� �������� (� ������)
 INOUT ioIsCalculated          Boolean   , -- ����� �������������� �� ������� (��/���)
    IN inContractId            Integer   , -- �������
    IN inPaidKindId            Integer   , -- ��� ���� ������
    IN inInfoMoneyId           Integer   , -- ������ ����������
    IN inUnitId                Integer   , -- �������������
    IN inCurrencyId            Integer   , -- ������
    IN inSession               TVarChar    -- ������ ������������
)                              
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbSumm TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_LossDebt());

     -- ��������
     IF (COALESCE (ioAmountDebet, 0) <> 0) AND (COALESCE (ioAmountKredit, 0) <> 0) THEN
        RAISE EXCEPTION '������.������ ���� ������� ������ ���� �����: <�����> ��� <������>.';
     END IF;

     -- ��������
     IF (COALESCE (ioSummDebet, 0) <> 0) AND (COALESCE (ioSummKredit, 0) <> 0) THEN
        RAISE EXCEPTION '������.������ ���� ������� ������ ���� �����: <����� ���� �� ����> ��� <������ ���� �� ����>.';
     END IF;

     -- ��������
     IF (COALESCE (ioAmountCurrencyDebet, 0) <> 0) AND (COALESCE (ioAmountCurrencyKredit, 0) <> 0) THEN
        RAISE EXCEPTION '������.������ ���� ������� ������ ���� ����� � ������: <�����> ��� <������>.';
     END IF;
     
     -- ���� ������ �� �������
     IF COALESCE (inCurrencyId, 0) NOT IN (0, zc_Enum_Currency_Basis())
     THEN 
          -- ��������
          IF COALESCE (inCurrencyPartnerValue, 0) = 0 THEN
             RAISE EXCEPTION '������.������ ���� ������ ���� ��� ����� � ������.';
          END IF;
          -- ���� ������ ������� �� ioIsCalculated
          IF ioIsCalculated = TRUE
          THEN 
              ioSummDebet := CASE WHEN ioAmountCurrencyDebet <> 0 THEN ioAmountCurrencyDebet
                             ELSE 0
                             END
                             -- �� ����� � ���
                           * CASE WHEN inParPartnerValue > 0 THEN inCurrencyPartnerValue / inParPartnerValue
                                  ELSE inCurrencyPartnerValue
                             END;
              ioSummKredit:= CASE WHEN ioAmountCurrencyKredit <> 0 THEN ioAmountCurrencyKredit
                                  ELSE 0
                             END
                             -- �� ����� � ���
                           * CASE WHEN inParPartnerValue > 0 THEN inCurrencyPartnerValue / inParPartnerValue
                                  ELSE inCurrencyPartnerValue
                             END;
              -- ��������� - ��������
              ioAmountDebet  := 0;
              ioAmountKredit := 0;

          ELSE
              ioAmountDebet := CASE WHEN ioAmountCurrencyDebet <> 0 THEN ioAmountCurrencyDebet
                                    ELSE 0
                                    END
                                    -- �� ����� � ���
                                  * CASE WHEN inParPartnerValue > 0 THEN inCurrencyPartnerValue / inParPartnerValue
                                         ELSE inCurrencyPartnerValue
                                    END;
              ioAmountKredit := CASE WHEN ioAmountCurrencyKredit <> 0 THEN ioAmountCurrencyKredit
                                     ELSE 0
                                END
                                -- �� ����� � ���
                              * CASE WHEN inParPartnerValue > 0 THEN inCurrencyPartnerValue / inParPartnerValue
                                     ELSE inCurrencyPartnerValue
                                END;
              -- ��������� - ��������
              ioSummDebet  := 0;
              ioSummKredit := 0;
          END IF;
     END IF;
     
     -- ������
     IF ioAmountDebet <> 0 THEN
        vbAmount := ioAmountDebet;
     ELSE
        vbAmount := -1 * ioAmountKredit;
     END IF;
     -- ������
     IF ioSummDebet <> 0 THEN
        vbSumm := ioSummDebet;
     ELSE
        vbSumm := -1 * ioSummKredit;
     END IF;


     -- !!!�������� ��������!!!
     IF COALESCE (inCurrencyId, 0) IN (0, zc_Enum_Currency_Basis())
     THEN
         -- ������
         ioIsCalculated:= (vbSumm <> 0 OR vbAmount = 0);
     END IF;
         

     -- 
     IF vbSumm <> 0 THEN ioAmountDebet := 0; ioAmountKredit := 0; END IF;

     -- ��������� <������� ���������>
     ioId:= lpInsertUpdate_MovementItem_LossDebt (ioId                   := ioId
                                                , inMovementId           := inMovementId
                                                , inJuridicalId          := inJuridicalId
                                                , inJuridicalBasisId     := inJuridicalBasisId
                                                , inPartnerId            := inPartnerId
                                                , inBranchId             := inBranchId
                                                , inContainerId          := inContainerId
                                                , inAmount               := CASE WHEN ioAmountDebet  <> 0 THEN  1 * ioAmountDebet
                                                                                 WHEN ioAmountKredit <> 0 THEN -1 * ioAmountKredit
                                                                                 ELSE 0
                                                                            END
                                                , inSumm                 := vbSumm
                                                , inCurrencyPartnerValue := inCurrencyPartnerValue
                                                , inParPartnerValue      := inParPartnerValue
                                                , inAmountCurrency       := CASE WHEN ioAmountCurrencyDebet  <> 0 THEN  1 * ioAmountCurrencyDebet
                                                                                 WHEN ioAmountCurrencyKredit <> 0 THEN -1 * ioAmountCurrencyKredit
                                                                                 ELSE 0
                                                                            END
                                                , inIsCalculated         := ioIsCalculated
                                                , inContractId           := inContractId
                                                , inPaidKindId           := inPaidKindId
                                                , inInfoMoneyId          := inInfoMoneyId
                                                , inUnitId               := inUnitId
                                                , inCurrencyId           := inCurrencyId
                                                , inUserId               := vbUserId
                                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 19.10.22         * inJuridicalBasisId
 31.07.17         *
 07.09.14                                        * add inBranchId
 27.08.14                                        * add inPartnerId
 10.03.14                                        * add lpInsertUpdate_MovementItem_LossDebt
 14.01.14                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_LossDebt (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')

/*
SELECT MovementItem.ObjectId, MILinkObject_PaidKind.ObjectId, MILinkObject_InfoMoney.ObjectId, MILinkObject_Contract.ObjectId
                FROM MovementItem
                     JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                 ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                     JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                      ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                     JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                 ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
                WHERE MovementItem.MovementId = 12055 
                  AND MovementItem.DescId = zc_MI_Master()

group by MovementItem.ObjectId, MILinkObject_PaidKind.ObjectId, MILinkObject_InfoMoney.ObjectId, MILinkObject_Contract.ObjectId
having count (*) >1
*/
