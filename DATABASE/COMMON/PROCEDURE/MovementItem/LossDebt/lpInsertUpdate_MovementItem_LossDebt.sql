-- Function: lpInsertUpdate_MovementItem_LossDebt ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_LossDebt (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Boolean, Integer, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_LossDebt (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_LossDebt (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean, Integer, Integer, Integer, Integer, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_LossDebt(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ���������
    IN inJuridicalId           Integer   , -- ��.����  
    IN inJuridicalBasisId      Integer   , -- �� ��.����
    IN inPartnerId             Integer   , -- ����������
    IN inBranchId              Integer   , -- ������
    IN inContainerId           TFloat    , -- ContainerId
    IN inAmount                TFloat    , -- �����
    IN inSumm                  TFloat    , -- ����� ������� (����)
    IN inCurrencyPartnerValue  TFloat    , -- ���� ��� ������� ����� �������� � ���
    IN inParPartnerValue       TFloat    , -- ������� ��� ������� ����� �������� � ���
    IN inAmountCurrency        TFloat    , -- ����� �������� (� ������)
    IN inIsCalculated          Boolean   , -- ����� �������������� �� ������� (��/���)
    IN inContractId            Integer   , -- �������
    IN inPaidKindId            Integer   , -- ��� ���� ������
    IN inInfoMoneyId           Integer   , -- ������ ����������
    IN inUnitId                Integer   , -- �������������
    IN inCurrencyId            Integer   , -- ������
    IN inUserId                Integer     -- ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ��������
     IF COALESCE (inJuridicalId, 0) = 0 AND inPaidKindId <> zc_Enum_PaidKind_SecondForm()
     THEN
         RAISE EXCEPTION '������.�� ����������� <����������� ����>.';
     END IF;
     IF COALESCE (inContractId, 0) = 0 AND COALESCE (inPartnerId, 0) <> 297029 -- ������ �����.������. -- AND inPaidKindId <> zc_Enum_PaidKind_SecondForm()
     THEN
         RAISE EXCEPTION '������.�� ���������� <� ���.>.';
     END IF;
     IF COALESCE (inPaidKindId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ����������� <����� ������>.';
     END IF;
     IF COALESCE (inInfoMoneyId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ����������� <�� ������ ����������>.';
     END IF;

     -- ��������
     IF EXISTS (SELECT MovementItem.Id
                FROM MovementItem
                     JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                 ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                                AND MILinkObject_InfoMoney.ObjectId = inInfoMoneyId
                     JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                 ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                                AND MILinkObject_Contract.ObjectId = inContractId
                     JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                 ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
                                                AND MILinkObject_PaidKind.ObjectId = inPaidKindId
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_JuridicalBasis
                                                      ON MILinkObject_JuridicalBasis.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_JuridicalBasis.DescId = zc_MILinkObject_PaidKind()
                                                
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                      ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                      ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
                     LEFT JOIN MovementItemFloat AS MIFloat_ContainerId 
                                                 ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.ObjectId = inJuridicalId
                  AND MovementItem.DescId = zc_MI_Master()
                  AND (COALESCE (MILinkObject_Partner.ObjectId, 0) = COALESCE (inPartnerId, 0) OR inPaidKindId <> zc_Enum_PaidKind_SecondForm()) -- AND inPartnerId <> 0
                  AND (COALESCE (MILinkObject_Branch.ObjectId, 0) = COALESCE (inBranchId, 0) OR inPaidKindId <> zc_Enum_PaidKind_SecondForm()) -- AND inBranchId <> 0
                  AND COALESCE (MIFloat_ContainerId.ValueData,0) = COALESCE (inContainerId,0)
                  AND MovementItem.Id <> COALESCE (ioId, 0)
                  AND MovementItem.isErased = FALSE
                  AND COALESCE (MILinkObject_JuridicalBasis.ObjectId, zc_Juridical_Basis()) = CASE WHEN inJuridicalBasisId > 0 THEN inJuridicalBasisId ELSE zc_Juridical_Basis() END
                )
     THEN
         RAISE EXCEPTION '������.� ��������� ��� ���������� <%>% <%> <%> <%>% <%> <%> <%> <%> <%>.������������ ���������.'
                      , lfGet_Object_ValueData (inJuridicalId)
                      , CASE WHEN inPartnerId <> 0 THEN ' <' || lfGet_Object_ValueData (inPartnerId) || '>' ELSE '' END
                      , lfGet_Object_ValueData (inPaidKindId)
                      , lfGet_Object_ValueData (inInfoMoneyId)
                      , lfGet_Object_ValueData (inContractId)
                      , CASE WHEN inBranchId <> 0 THEN ' <' || lfGet_Object_ValueData (inBranchId) || '>' ELSE '' END
                      , lfGet_Object_ValueData (inJuridicalBasisId)
                      , inJuridicalId, inPartnerId, inBranchId, inJuridicalBasisId
                       ;
     END IF;

     -- ��������
     IF inContainerId <> 0
     THEN
         IF NOT EXISTS (SELECT 1
                        FROM Container
                             INNER JOIN ContainerLinkObject AS CLO_Juridical
                                                            ON CLO_Juridical.ContainerId = Container.Id
                                                           AND CLO_Juridical.DescId      = zc_ContainerLinkObject_Juridical()
                                                           AND CLO_Juridical.ObjectId    = inJuridicalId
                             INNER JOIN ContainerLinkObject AS CLO_InfoMoney 
                                                            ON CLO_InfoMoney.ContainerId = Container.Id
                                                           AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                                                           AND CLO_InfoMoney.ObjectId    = inInfoMoneyId
                             INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                            ON CLO_PaidKind.ContainerId = Container.Id
                                                           AND CLO_PaidKind.DescId      = zc_ContainerLinkObject_PaidKind()
                                                           AND CLO_PaidKind.ObjectId    = inPaidKindId
                             LEFT JOIN ContainerLinkObject AS CLO_Contract
                                                           ON CLO_Contract.ContainerId = Container.Id
                                                          AND CLO_Contract.DescId      = zc_ContainerLinkObject_Contract()
                             LEFT JOIN ContainerLinkObject AS CLO_Partner
                                                           ON CLO_Partner.ContainerId = Container.Id
                                                          AND CLO_Partner.DescId      = zc_ContainerLinkObject_Partner()
                             LEFT JOIN ContainerLinkObject AS CLO_Branch
                                                           ON CLO_Branch.ContainerId = Container.Id
                                                          AND CLO_Branch.DescId      = zc_ContainerLinkObject_Branch()
                        WHERE Container.Id = inContainerId :: Integer
                          AND COALESCE (CLO_Partner.ObjectId, 0)         = COALESCE (inPartnerId, 0)
                          AND COALESCE (CLO_Branch.ObjectId, 0)          = COALESCE (inBranchId, 0)
                          AND COALESCE (CLO_Contract.ObjectId, 0)        = COALESCE (inContractId, 0)
                       )
         THEN
             RAISE EXCEPTION '������.��������� <%> + <%> + <%> + <%> + <%> + <%> �� ������������� ������ � <%>', lfGet_Object_ValueData (inJuridicalId)
                                                                                                               , lfGet_Object_ValueData (inPartnerId)
                                                                                                               , lfGet_Object_ValueData (inInfoMoneyId)
                                                                                                               , lfGet_Object_ValueData (inPaidKindId)
                                                                                                               , lfGet_Object_ValueData (inContractId)
                                                                                                               , lfGet_Object_ValueData (inBranchId)
                                                                                                               , inContainerId :: Integer
                                                                                                                ;
         END IF;
     END IF;


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inJuridicalId, inMovementId, inAmount, NULL);

     -- ��������� �������� <����� �������������� �� ������� (��/���)>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Calculated(), ioId, inIsCalculated);

     -- ��������� �������� <ContainerId)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), ioId, inContainerId);

     -- ��������� �������� <����� ������� (����)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, inSumm);

     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyPartnerValue(), ioId, inCurrencyPartnerValue);
     -- ��������� �������� <�������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParPartnerValue(), ioId, inParPartnerValue);
     -- ��������� �������� <����� � ������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountCurrency(), ioId, inAmountCurrency);
     
     -- ��������� ����� � <�����������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Partner(), ioId, inPartnerId);

     -- ��������� ����� � <������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), ioId, inBranchId);

     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioId, inContractId);

     -- ��������� ����� � <��� ���� ������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), ioId, inPaidKindId);

     -- ��������� ����� � <������ ����������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);

     -- ��������� ����� � <�������������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);

     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Currency(), ioId, inCurrencyId);     

     -- ��������� ����� � <�� �� ����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_JuridicalBasis(), ioId, inJuridicalBasisId);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 19.10.22         * inJuridicalBasisId
 19.04.16         *
 07.09.14                                        * add inBranchId
 27.08.14                                        * add inPartnerId
 16.05.14                                        * add lpInsert_MovementItemProtocol
 10.03.14                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_LossDebt (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
