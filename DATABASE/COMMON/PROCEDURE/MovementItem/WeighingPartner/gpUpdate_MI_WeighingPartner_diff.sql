-- Function: gpUpdate_MI_WeighingPartner_diff()

DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_diff (Integer, Integer, TFloat, Boolean, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_diff (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_WeighingPartner_diff(
    IN inId                     Integer   , -- ���� ������� <������� ���������>
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inChangePercentAmount    TFloat    , -- % ������ ��� ���-�� 
    IN inAmountPartnerSecond    TFloat    , 
    IN inAmountPartner_income   TFloat    ,
    IN inPricePartnerWVAT       TFloat    ,
    IN inPricePartnerNoVAT      TFloat    , 
   OUT outAmountPartner_calc    TFloat    , 
   OUT outSummPartnerWVAT       TFloat    ,
   OUT outSummPartnerNoVAT      TFloat    ,
   OUT outAmount_diff           TFloat    ,
   OUT outPrice_diff            TFloat    ,
    IN inisAmountPartnerSecond  Boolean   ,
    IN inisReturnOut            Boolean   , --   
    IN inComment                TVarChar  , -- 
    IN inSession                TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������� �������� <% ������ ��� ���-��>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercentAmount(), inId, inChangePercentAmount);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPartnerSecond(), inId, inisAmountPartnerSecond);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_ReturnOut(), inId, inisReturnOut);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), inId, inComment);

     outAmountPartner_calc := (inAmountPartnerSecond * (1 - inChangePercentAmount / 100))::TFloat;
     outSummPartnerNoVAT   := (outAmountPartner_calc * inPricePartnerNoVAT);
     outSummPartnerWVAT    := (outAmountPartner_calc * inPricePartnerWVAT); 
     outAmount_diff        := (COALESCE (outAmountPartner_calc, 0) - COALESCE (inAmountPartner_income, 0));
     
     --RAISE EXCEPTION '������.<%>   <%>   <%>  <%>  .', outAmountPartner_calc, outSummPartnerNoVAT, outSummPartnerWVAT, outAmount_diff;

     IF vbUserId = 9457
     THEN
          RAISE EXCEPTION '������.���� ��.';
     END IF;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

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