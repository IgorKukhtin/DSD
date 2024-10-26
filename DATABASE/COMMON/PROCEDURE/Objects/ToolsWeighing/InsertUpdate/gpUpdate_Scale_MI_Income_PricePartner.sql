-- Function: gpUpdate_Scale_MI_Income_PricePartner()

DROP FUNCTION IF EXISTS gpUpdate_Scale_MI_Income_PricePartner (Integer, Integer, TFloat, TFloat, Boolean, Boolean, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_MI_Income_PricePartner(
    IN inMovementDescId        Integer   , -- ���� ������� <��������>
    IN inBranchCode            Integer   , --
    IN inMovementItemId        Integer   , -- ����
    IN inPricePartner          TFloat    , -- ���� ���������� - �� ��������� - ���� � ��������
    IN inAmountPartnerSecond   TFloat    , -- ���-�� ���������� - �� ���������
    IN inIsAmountPartnerSecond Boolean   , -- ��� ������ ��/��� - ���-�� ����������
    IN inIsPriceWithVAT        Boolean   , -- ���� � ��� ��/��� - ��� ���� ����������
    IN inOperDate_ReturnOut    TDateTime , -- ���� ��� ���� ������� ����������
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbContractId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Scale_Movement_check());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������
     IF COALESCE (inMovementItemId, 0) = 0
     THEN
         RAISE EXCEPTION '������.������� <�����������> �� �����������.';
     END IF;



     -- �����������
     IF inMovementDescId = zc_Movement_Income()
     THEN
         -- ���� ���������� ��� ����� - �� ���������
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PricePartner(), inMovementItemId, inPricePartner);
         -- ���������� � ���������� - �� ���������
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartnerSecond(), inMovementItemId, inAmountPartnerSecond);

         -- ��� ������ ��/��� - ���-�� ����������
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPartnerSecond(), inMovementItemId, inIsAmountPartnerSecond);

         -- ���� � ��� ��/��� - ��� ���� ����������
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PriceWithVAT(), inMovementItemId, inIsPriceWithVAT);

     ELSEIF inMovementDescId = zc_Movement_Income()
     THEN
         -- ���� ��� ���� ������� ����������
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PriceRetOut(), inMovementItemId, inOperDate_ReturnOut);

     ELSE

         RAISE EXCEPTION '������.gpUpdate_Scale_MI_Income_PricePartner.';

     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inMovementItemId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 25.10.24                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Scale_MI_Income_PricePartner (inMovementId:= 29547683, inBranchCode:= 201, inIsUpdate:= TRUE, inSession:= '5')
