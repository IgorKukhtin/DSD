-- Function: gpUpdate_MI_WeighingPartner_ActDiff_Edit()

DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_ActDiff_Edit (Integer, Integer, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_ActDiff_Edit (Integer, Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_WeighingPartner_ActDiff_Edit(
    IN inId                         Integer   , -- ������������� ������
    IN inMovementId                 Integer   , -- ������������� ��������� 
    IN inInvNumberPartner           TVarChar  , -- �����  �����������
    IN inOperDatePartner            TDateTime , -- ���� ���������  �����������
    IN inAmountPartnerSecond        TFloat    , -- ���������� ����������
    IN inPricePartner               TFloat    , -- ���� ����������
    IN inSummPartner                TFloat    , -- ����� ����������
    IN inisPriceWithVAT             Boolean   , -- ����/����� � ��� (��/���)
    IN inIsAmountPartnerSecond      Boolean   , -- ���������� ���������� 
    IN inIsReturnOut                Boolean   , -- ������� ��/���
    IN inComment                    TVarChar  , -- ����������
    IN inSession                    TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPricePartner TFloat;
   DECLARE vbSummPartner TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);

     --���������� ��������
     vbPricePartner := (SELECT MIF.ValueData FROM MovementItemFloat MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_PricePartner());
     vbSummPartner := (SELECT MIF.ValueData FROM MovementItemFloat MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_SummPartner());

     IF COALESCE (vbPricePartner,0) = COALESCE (inPricePartner,0) OR COALESCE (inPricePartner,0) = 0
     THEN
         IF (COALESCE(inSummPartner,0) <> 0 AND COALESCE(vbSummPartner,0) <> COALESCE(inSummPartner,0)) OR COALESCE (inPricePartner,0) = 0
         THEN
             -- ������������� ���� �� �����
             inPricePartner := CASE WHEN COALESCE (inAmountPartnerSecond,0) <> 0 THEN (inSummPartner / inAmountPartnerSecond) ELSE 0 END ::TFloat;
         END IF;
     ELSE
         inSummPartner := (inPricePartner * inAmountPartnerSecond);
     END IF;

     -- ��������� �������� <����� �����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), inMovementId, inInvNumberPartner);
     -- ��������� ����� � <���� �����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), inMovementId, inOperDatePartner);
     
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartnerSecond(), inId, inAmountPartnerSecond);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PricePartner(), inId, inPricePartner);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummPartner(), inId, inSummPartner);

     -- ��������� �������� <������� "��� ������">
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPartnerSecond(), inId, inIsAmountPartnerSecond);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_ReturnOut(), inId, inIsReturnOut);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PriceWithVAT(), inId, inisPriceWithVAT);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), inId, inComment);

     if vbUserId = 9457 then RAISE EXCEPTION 'Test.Ok. %   %', inPricePartner, inSummPartner; end if;

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

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