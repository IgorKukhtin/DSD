-- Function: gpInsertUpdate_Movement_SendDebt()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendDebt (Integer, TVarChar, TDateTime, Integer, Integer, Tfloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendDebt (Integer, TVarChar, TDateTime, Integer, Integer, Tfloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendDebt (Integer, TVarChar, TDateTime, Integer, Integer, Tfloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendDebt (Integer, TVarChar, TDateTime, Integer, Integer, Tfloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendDebt (Integer, TVarChar, TDateTime, Integer, Integer, Tfloat, Tfloat, Tfloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SendDebt(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������

 INOUT ioMasterId            Integer   , -- ���� ������� <������� ���������>
 INOUT ioChildId             Integer   , -- ���� ������� <������� ���������>

    IN inAmount              TFloat    , -- �����  
    IN inCurrencyValue_From  TFloat    , -- ����  
    IN inParValue_From       TFloat    , -- ������� ������ ��� ������� �������� ����  
    IN inCurrencyValue_To    TFloat    , -- ����  
    IN inParValue_To         TFloat    , -- ������� ������ ��� ������� �������� ����  
        
    IN inJuridicalFromId     Integer   , -- ��.����
    IN inPartnerFromId       Integer   , -- ����������
    IN inContractFromId      Integer   , -- �������
    IN inPaidKindFromId      Integer   , -- ��� ���� ������
    IN inInfoMoneyFromId     Integer   , -- ������ ����������
    IN inBranchFromId        Integer   , -- 
    IN inCurrencyId_From     Integer   , -- ������
    
    IN inJuridicalToId       Integer   , -- ��.����
    IN inPartnerToId         Integer   , -- ����������
    IN inContractToId        Integer   , -- �������
    IN inPaidKindToId        Integer   , -- ��� ���� ������
    IN inInfoMoneyToId       Integer   , -- ������ ����������
    IN inBranchToId          Integer   , -- 
    IN inCurrencyId_To       Integer   , -- ������
    
    IN inComment             TVarChar  , -- ����������
    
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS record AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SendDebt());

     -- ��������
     IF (COALESCE (inJuridicalFromId, 0) = 0)
     THEN
         RAISE EXCEPTION '������. �� ����������� <����������� ���� (�����)>.';
     END IF;
     -- ��������
     IF (COALESCE (inInfoMoneyFromId, 0) = 0)
     THEN
         RAISE EXCEPTION '������. �� ����������� <�� ������ ���������� (�����)>.';
     END IF;
     -- ��������
     IF (COALESCE (inContractFromId, 0) = 0)
     THEN
         RAISE EXCEPTION '������. �� ����������� <������� (�����)>.';
     END IF;
     -- ��������
     IF inPaidKindFromId = zc_Enum_PaidKind_SecondForm() AND COALESCE (inPartnerFromId, 0) = 0
        AND NOT EXISTS (SELECT ChildObjectId FROM ObjectLink WHERE ChildObjectId = inJuridicalFromId AND DescId = zc_ObjectLink_Partner_Juridical() GROUP BY ChildObjectId HAVING COUNT(*) = 1)
     THEN
         RAISE EXCEPTION '������. ��� ����� ������ <%> ������ ���� ���������� <���������� (�����)>.', lfGet_Object_ValueData (inPaidKindFromId);
     ELSE IF inPaidKindFromId = zc_Enum_PaidKind_SecondForm() AND COALESCE (inPartnerFromId, 0) = 0
          THEN  inPartnerFromId:= (SELECT ObjectId FROM ObjectLink WHERE ChildObjectId = inJuridicalFromId AND DescId = zc_ObjectLink_Partner_Juridical());
          END IF;
     END IF;

     -- ��������
     IF (COALESCE (inJuridicalToId, 0) = 0)
     THEN
         RAISE EXCEPTION '������. �� ����������� <����������� ���� (������)>.';
     END IF;
     -- ��������
     IF (COALESCE (inInfoMoneyToId, 0) = 0)
     THEN
         RAISE EXCEPTION '������. �� ����������� <�� ������ ���������� (������)>.';
     END IF;
     -- ��������
     IF (COALESCE (inContractToId, 0) = 0)
     THEN
         RAISE EXCEPTION '������. �� ����������� <������� (������)>.';
     END IF;
     -- ��������
     IF inPaidKindToId = zc_Enum_PaidKind_SecondForm() AND COALESCE (inPartnerToId, 0) = 0
        AND NOT EXISTS (SELECT ChildObjectId FROM ObjectLink WHERE ChildObjectId = inJuridicalToId AND DescId = zc_ObjectLink_Partner_Juridical() GROUP BY ChildObjectId HAVING COUNT(*) = 1)
     THEN
         RAISE EXCEPTION '������. ��� ����� ������ <%> ������ ���� ���������� <���������� (������)>.', lfGet_Object_ValueData (inPaidKindToId);
     ELSE IF inPaidKindToId = zc_Enum_PaidKind_SecondForm() AND COALESCE (inPartnerToId, 0) = 0
          THEN  inPartnerToId:= (SELECT ObjectId FROM ObjectLink WHERE ChildObjectId = inJuridicalToId AND DescId = zc_ObjectLink_Partner_Juridical());
          END IF;
     END IF;


     -- 1. ����������� ��������
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_SendDebt())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;


     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_SendDebt(), inInvNumber, inOperDate, NULL);

   
     -- ��������� <������� ������� ���������>
     ioMasterId := lpInsertUpdate_MovementItem (ioMasterId, zc_MI_Master(), CASE WHEN inPartnerFromId <> 0 AND inPaidKindFromId = zc_Enum_PaidKind_SecondForm() THEN inPartnerFromId ELSE inJuridicalFromId END, ioId, inAmount, NULL);

     -- ��������� ����� � <������� �� >
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioMasterId, inContractFromId);

     -- ��������� ����� � <��� ���� ������ ��>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), ioMasterId, inPaidKindFromId);

     -- ��������� ����� � <������ ���������� ��>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioMasterId, inInfoMoneyFromId);

     -- ��������� ����� � <������ ��>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), ioMasterId, inBranchFromId);


     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Currency(), ioMasterId, inCurrencyId_From); 
     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(), ioMasterId, inCurrencyValue_From);
     -- ��������� �������� <�������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(), ioMasterId, inParValue_From);

     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Currency(), ioMasterId, inCurrencyId_From); 
     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(), ioMasterId, inCurrencyValue_From);
     -- ��������� �������� <�������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(), ioMasterId, inParValue_From);
     
     -- ��������� �������� <�����������>
     PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioMasterId, inComment);


     -- ��������� <������ ������� ���������>
     ioChildId := lpInsertUpdate_MovementItem (ioChildId, zc_MI_Child(), CASE WHEN inPartnerToId <> 0 AND inPaidKindToId = zc_Enum_PaidKind_SecondForm() THEN inPartnerToId ELSE inJuridicalToId END, ioId, inAmount, NULL);

     -- ��������� ����� � <������� ����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioChildId, inContractToId);

     -- ��������� ����� � <��� ���� ������ ����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), ioChildId, inPaidKindToId);

     -- ��������� ����� � <������ ���������� ����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioChildId, inInfoMoneyToId);

     -- ��������� ����� � <������ ����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), ioChildId, inBranchToId);

     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Currency(), ioChildId, inCurrencyId_To); 
     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(), ioChildId, inCurrencyValue_To);
     -- ��������� �������� <�������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(), ioChildId, inParValue_To);

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 5.3. �������� ��������
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_SendDebt())
     THEN
          PERFORM lpComplete_Movement_SendDebt (inMovementId := ioId
                                              , inUserId     := vbUserId);
     END IF;

     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 18.02.19         * add ������ �����/ ������
 24.01.19         * add inCurrencyId, inCurrencyValue, inParValue
 12.11.14                                        * add lpComplete_Movement_Finance_CreateTemp
 24.09.14                                        * add inPartner...
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 05.04.14                                        * add !!!��� �����������!!! : _tmp1___ and _tmp2___
 25.03.14                                        * ������� - !!!��� �����������!!!
 28.01.14                                        * add lpComplete_Movement_SendDebt
 24.01.14         *
*/

-- ����
-- 