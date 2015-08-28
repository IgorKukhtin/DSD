-- Function: gpInsertUpdate_MI_Transport_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Transport_Child (integer, integer, integer, integer, boolean, boolean, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, integer, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Transport_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inParentId            Integer   , -- ������� ������� ���������
    IN inFuelId              Integer   , -- ��� �������
    IN inIsCalculated        Boolean   , -- ���������� �� ����� �������������� �� ����� ��� ���������
    IN inIsMasterFuel        Boolean   , -- �������� ��� ������� (��/���)
 INOUT ioAmount              TFloat    , -- ���������� �� �����
   OUT outAmount_calc        TFloat    , -- ���������� ��������� �� �����
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
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_TransportChild());

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������> � ������� ���������
     SELECT tmp.ioId, tmp.ioAmount, tmp.outAmount_calc, tmp.outAmount_Distance_calc, tmp.outAmount_ColdHour_calc, tmp.outAmount_ColdDistance_calc
            INTO ioId, ioAmount, outAmount_calc, outAmount_Distance_calc, outAmount_ColdHour_calc, outAmount_ColdDistance_calc
     FROM lpInsertUpdate_MI_Transport_Child (ioId                 := ioId
                                           , inMovementId         := inMovementId
                                           , inParentId           := inParentId
                                           , inFuelId             := inFuelId
                                           , inIsCalculated       := inIsCalculated
                                           , inIsMasterFuel       := inIsMasterFuel
                                           , ioAmount             := ioAmount
                                           , inColdHour           := inColdHour
                                           , inColdDistance       := inColdDistance
                                           , inAmountFuel         := inAmountFuel
                                           , inAmountColdHour     := inAmountColdHour
                                           , inAmountColdDistance := inAmountColdDistance
                                           , inNumber             := inNumber
                                           , inRateFuelKindTax    := inRateFuelKindTax
                                           , inRateFuelKindId     := inRateFuelKindId
                                           , inUserId             := vbUserId
                                            ) AS tmp;

   -- ��������� ��������
   PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId,vbIsInsert);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.10.13                                        * add outAmount_...
 07.10.13                                        * add inIsMasterFuel
 04.10.13                                        * add inUserId
 01.10.13                                        * add inRateFuelKindTax
 29.09.13                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_Transport_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
