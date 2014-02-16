-- Function: lpInsertUpdate_MI_Transport_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_Transport_Child (integer, integer, integer, integer, boolean, boolean, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, integer, integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_Transport_Child_only (Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_Transport_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inParentId            Integer   , -- ������� ������� ���������
    IN inFuelId              Integer   , -- ��� �������
    IN inIsCalculated        Boolean   , -- ���������� �� ����� �������������� �� ����� ��� ��������� (��/���)
    IN inIsMasterFuel        Boolean   , -- �������� ��� ������� (��/���)
 INOUT ioAmount              TFloat    , -- ���������� �� �����
   OUT outAmount_calc               TFloat    , -- ���������� ��������� �� �����
   OUT outAmount_Distance_calc      TFloat    , -- ���������� ��������� �� �����
   OUT outAmount_ColdHour_calc      TFloat    , -- ���������� ��������� �� �����
   OUT outAmount_ColdDistance_calc  TFloat    , -- ���������� ��������� �� �����
    IN inColdHour            TFloat    , -- �����, ���-�� ���� ����� 
    IN inColdDistance        TFloat    , -- �����, ���-�� ���� �� 
    IN inAmountFuel          TFloat    , -- ���-�� ����� �� 100 �� 
    IN inAmountColdHour      TFloat    , -- �����, ���-�� ����� � ���  
    IN inAmountColdDistance  TFloat    , -- �����, ���-�� ����� �� 100 �� 
    IN inNumber              TFloat    , -- � �� �������
    IN inRateFuelKindTax     TFloat    , -- % ��������������� ������� � ����� � �������/������������
    IN inRateFuelKindId      Integer   , -- ���� ���� ��� �������
    IN inUserId              Integer     -- ������������
)                              
RETURNS RECORD AS
$BODY$
BEGIN

   -- ��������
   IF COALESCE (inParentId, 0) = 0
   THEN
       RAISE EXCEPTION '������.������� �� ����������.';
   END IF;

   -- ����������� �����
   SELECT zfCalc_RateFuelValue_Distance     (inDistance           := CASE WHEN inIsMasterFuel = TRUE  THEN MovementItem_Master.Amount          -- ���� "��������" ��� �������
                                                                          WHEN inIsMasterFuel = FALSE THEN MIFloat_DistanceFuelChild.ValueData -- ���� "��������������" ��� �������
                                                                          ELSE 0
                                                                     END
                                           , inAmountFuel         := inAmountFuel
                                           , inFuel_Ratio         := 1 -- !!!����������� �������� ����� ��� �����!!!
                                           , inRateFuelKindTax    := 0 -- !!!% ��������������� ������� � ����� � �������/������������ ��� �����!!!
                                        ) AS Amount_Distance_calc
        , zfCalc_RateFuelValue_ColdHour     (inColdHour           := inColdHour
                                           , inAmountColdHour     := inAmountColdHour
                                           , inFuel_Ratio         := 1 -- !!!����������� �������� ����� ��� �����!!!
                                           , inRateFuelKindTax    := 0 -- !!!% ��������������� ������� � ����� � �������/������������ ��� �����!!!
                                            ) AS Amount_ColdHour_calc
        , zfCalc_RateFuelValue_ColdDistance (inColdDistance       := inColdDistance
                                           , inAmountColdDistance := inAmountColdDistance
                                           , inFuel_Ratio         := 1 -- !!!����������� �������� ����� ��� �����!!!
                                           , inRateFuelKindTax    := 0 -- !!!% ��������������� ������� � ����� � �������/������������ ��� �����!!!
                                            ) AS Amount_ColdHour_calc

          INTO outAmount_Distance_calc, outAmount_ColdHour_calc, outAmount_ColdDistance_calc
   FROM MovementItem AS MovementItem_Master
        LEFT JOIN MovementItemFloat AS MIFloat_DistanceFuelChild
                                    ON MIFloat_DistanceFuelChild.MovementItemId = MovementItem_Master.Id
                                   AND MIFloat_DistanceFuelChild.DescId = zc_MIFloat_DistanceFuelChild()
   WHERE MovementItem_Master.Id = inParentId
     AND MovementItem_Master.MovementId = inMovementId;

   -- ����������� ����� �� ���
   outAmount_calc := outAmount_Distance_calc + outAmount_ColdHour_calc + outAmount_ColdDistance_calc;


   IF inIsCalculated = TRUE
   THEN
       -- ��� ������������ ��������, ���������� �� ����� ������ ���� ����� �����
       ioAmount := outAmount_calc;
   END IF;


   -- ��������� <������� ���������>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inFuelId, inMovementId, ioAmount, inParentId);

   -- ��������� �������� <���������� �� ����� �������������� �� ����� ��� ��������� (��/���)>
   PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Calculated(), ioId, inIsCalculated);
   -- ��������� �������� <�������� ��� ������� (��/���)>
   PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_MasterFuel(), ioId, inIsMasterFuel);
   
   -- ��������� �������� <�����, ���-�� ���� ����� >
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ColdHour(), ioId, inColdHour);
   -- ��������� �������� <�����, ���-�� ���� �� >
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ColdDistance(), ioId, inColdDistance);
   -- ��������� �������� <�����, ���-�� ����� � ���  >
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountColdHour(), ioId, inAmountColdHour);
   -- ��������� �������� <�����, ���-�� ����� �� 100 �� >
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountColdDistance(), ioId, inAmountColdDistance);
   -- ��������� �������� <���-�� ����� �� 100 ��>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountFuel(), ioId, inAmountFuel);
   -- ��������� �������� <� �� �������>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Number(), ioId, inNumber);
   -- ��������� �������� <% ��������������� ������� � ����� � �������/������������>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RateFuelKindTax(), ioId, inRateFuelKindTax);
   
   -- ��������� ����� � <���� ���� ��� �������>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_RateFuelKind(), ioId, inRateFuelKindId);

   -- ��������� ��������
   -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.10.13                                        * add outAmount_...
 24.10.13                                        * add zfCalc_RateFuelValue_...
 07.10.13                                        * add DistanceFuelChild and isMasterFuel
 04.10.13                                        * add inUserId
 01.10.13                                        * add inRateFuelKindTax and zfCalc_RateFuelValue
 29.09.13                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MI_Transport_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
