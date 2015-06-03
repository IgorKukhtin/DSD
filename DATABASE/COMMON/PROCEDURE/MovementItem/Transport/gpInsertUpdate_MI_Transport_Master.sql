-- Function: gpInsertUpdate_MI_Transport_Master()
DROP FUNCTION IF EXISTS  gpInsertUpdate_MI_Transport_Master(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat,Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_MI_Transport_Master(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat,Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_MI_Transport_Master(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat,Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_MI_Transport_Master(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat,Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_MI_Transport_Master(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat,Integer, Integer, Integer, Integer, TVarChar, TVarChar);



CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Transport_Master(
 INOUT ioId                        Integer   , -- ���� ������� <������� ���������>
    IN inMovementId                Integer   , -- ���� ������� <��������>
    IN inRouteId                   Integer   , -- �������
    IN inAmount	                   TFloat    , -- ������, �� (�������� ��� �������)
    IN inDistanceFuelChild         TFloat    , -- ������, �� (�������������� ��� �������)
    IN inDistanceWeightTransport   TFloat    , -- ������, �� (� ������,����������)
    IN inWeight	                   TFloat    , -- ��� �����, �� (���������)
    IN inWeightTransport	       TFloat    , -- ��� �����, �� (����������)
    IN inStartOdometre             TFloat    , -- ��������� ��������� ���������, ��
    IN inEndOdometre               TFloat    , -- ��������� �������� ���������, ��
    IN inFreightId                 Integer   , -- �������� �����
    IN inRouteKindId_Freight       Integer   , -- ���� ���������(����)
    IN inRouteKindId               Integer   , -- ���� ���������
    IN inUnitId                    Integer   , -- �������������
    IN inComment                   TVarChar  , -- �����������	
    IN inSession                   TVarChar    -- ������ ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_TransportMaster());

   IF COALESCE (inStartOdometre, 0) <> 0 OR COALESCE (inEndOdometre, 0) <> 0
   THEN
       -- ��� ������������ ��������, ����������� inAmount - ������, ��
       inAmount := ABS (COALESCE (inEndOdometre, 0) - COALESCE (inStartOdometre, 0));
       -- ��������� inAmount �� ������, �� (�������������� ��� �������)
       inAmount := inAmount - COALESCE (inDistanceFuelChild, 0);
   ELSE
       -- ����� ��������� ��������� ��������
       inAmount := ABS (inAmount);
   END IF;

   -- ��������
   IF COALESCE (inMovementId, 0) = 0
   THEN
       RAISE EXCEPTION '������.<������� ����> �� ��������.';
   END IF;

   -- �������� 
   IF inAmount < 0
   THEN 
       RAISE EXCEPTION '������.�������� �������� <������, �� (�������� ��� �������)>.';
   END IF;

   -- ��������
   IF inDistanceFuelChild < 0
   THEN 
       RAISE EXCEPTION '������.�������� �������� <������, �� (�������������� ��� �������)>.';
   END IF;

   -- ��������
   IF inDistanceFuelChild > 0 AND NOT EXISTS (SELECT ObjectLink_Car_FuelChild.ChildObjectId
                                              FROM MovementLinkObject AS MovementLinkObject_Car
                                                   -- ������� � ���������� - ��� �������
                                                   JOIN ObjectLink AS ObjectLink_Car_FuelChild ON ObjectLink_Car_FuelChild.ObjectId = MovementLinkObject_Car.ObjectId
                                                                                              AND ObjectLink_Car_FuelChild.DescId = zc_ObjectLink_Car_FuelChild()
                                                                                              AND ObjectLink_Car_FuelChild.ChildObjectId IS NOT NULL
                                              WHERE MovementLinkObject_Car.MovementId = inMovementId
                                                AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car())
   THEN 
       RAISE EXCEPTION '������.�������� �������� <������, �� (�������������� ��� �������)>, �.�. � <����������> �� ���������� <�������������� ��� �������>.';
   END IF;

   -- ��������� <������� ���������>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inRouteId, inMovementId, inAmount, NULL);
  
   -- ��������� ����� � <�������� �����>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Freight(), ioId, inFreightId);
   
   -- ��������� ����� � <���� ���������(����)>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RouteKindFreight(), ioId, inRouteKindId_Freight);

   -- ��������� ����� � <���� ���������>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RouteKind(), ioId, inRouteKindId);

   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);

   -- ��������� �������� <������, �� (�������������� ��� �������)>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DistanceFuelChild(), ioId, inDistanceFuelChild);

   -- ��������� �������� <������, �� (� ������,����������)>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DistanceWeightTransport(), ioId, inDistanceWeightTransport);
   
   -- ��������� �������� <��� �����>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Weight(), ioId, inWeight);
   -- ��������� �������� <��� �����>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTransport(), ioId, inWeightTransport);

   -- ��������� �������� <��������� ��������� ���������, ��>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_StartOdometre(), ioId, inStartOdometre);

   -- ��������� �������� <��������� �������� ���������, ��>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_EndOdometre(), ioId, inEndOdometre);
   
   -- ��������� �������� <�����������>
   PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioId, inComment);

   -- !!!�����������!!! ����������� Child
   PERFORM lpInsertUpdate_MI_Transport_Child_byMaster (inMovementId := inMovementId, inParentId := ioId, inRouteKindId:= inRouteKindId, inUserId := vbUserId);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.06.15         * add UnitID
 10.12.13         * add DistanceWeightTransport
 09.12.13         * add WeightTransport
 02.12.13         * add Comment
 26.10.13                                        * add inRouteKindId_Freight
 13.10.13                                        * add lpInsertUpdate_MI_Transport_Child_byMaster
 13.10.13                                        * add lpInsertUpdate_MI_Transport_Child_byMaster
 12.10.13                                        * add zc_ObjectFloat_Fuel_Ratio
 12.10.13                                        * add lpInsertUpdate_MI_Transport_Child
 07.10.13                                        * add inDistanceFuelChild and inIsMasterFuel
 29.09.13                                        * 
 25.09.13         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_Transport_Master (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
