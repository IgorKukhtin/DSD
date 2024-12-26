-- Function: gpUpdate_MI_WeighingPartner_diff()

DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_diff (Integer, Integer, TFloat, Boolean, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_diff (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_diff (Integer, Integer, TFloat, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_diff (Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_WeighingPartner_diff(
    IN inId                         Integer   , -- 1.����������� - ��� ����������
    IN inId_check                   Integer   , -- ������������� ������
    IN inMovementId_WeighingPartner Integer   , -- 2.����������� - ��� �����
    IN inGoodsId                    Integer   , -- �����
    IN inGoodsKindId                Integer   , -- ��� ������
    IN inChangePercentAmount        TFloat    , -- ��� 2. - % ������ ���-��
    IN inIsReason_1                 Boolean   , -- ��� 2. - ������� ������ � ���-�� �����������
    IN inIsReason_2                 Boolean   , -- ��� 2. - ������� ������ � ���-�� ��������

    IN inIsAmountPartnerSecond      Boolean   , -- ��� 1. - ������� "��� ������"
    IN inIsReturnOut                Boolean   , -- ��� 1. - 
    IN inComment                    TVarChar  , -- ��� 1. - 
    IN inSession                    TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);


     IF inMovementId_WeighingPartner <> 0
     THEN
         -- ��������� �������� <% ������ ��� ���-��>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercentAmount(), inMovementId_WeighingPartner, inChangePercentAmount);
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Reason1(), inMovementId_WeighingPartner, inIsReason_1);
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Reason2(), inMovementId_WeighingPartner, inIsReason_2);

         PERFORM lpInsert_MovementProtocol (inMovementId_WeighingPartner, vbUserId, FALSE);

     ELSE
         IF inChangePercentAmount <> 0 OR inIsReason_1 = TRUE OR inIsReason_2 = TRUE
         THEN
              RAISE EXCEPTION '������.��� ���� �������� ��������.';
         END IF;
     END IF;

     IF inId <> 0
     THEN
         -- ��������� �������� <������� "��� ������">
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPartnerSecond(), inId, inIsAmountPartnerSecond);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_ReturnOut(), inId, inIsReturnOut);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), inId, inComment);
    
         -- ��������� ��������
         PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

     ELSE
         IF inId_check > 0
         THEN
              RAISE EXCEPTION '������.��������� � ����� "�������� ���� ������".';
         END IF;

         IF inIsAmountPartnerSecond = TRUE
         THEN
              RAISE EXCEPTION '������.��� ���� �������� ������� "��� ������".';
         END IF;

         IF inIsReturnOut = TRUE
         THEN
              RAISE EXCEPTION '������.��� ���� �������� ������� "�������".';
         END IF;

         IF inComment <>''
         THEN
              RAISE EXCEPTION '������.��� ���� �������� <����������>.';
         END IF;

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.11.24         *
*/

-- ����
--