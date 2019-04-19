-- Function: gpInsertUpdate_MI_Transport_Master()

DROP FUNCTION IF EXISTS  gpInsertUpdate_MI_Transport_Master(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_MI_Transport_Master(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_MI_Transport_Master(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat,Integer, Integer, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Transport_Master(
 INOUT ioId                        Integer   , -- ���� ������� <������� ���������>
    IN inMovementId                Integer   , -- ���� ������� <��������>
    IN inRouteId                   Integer   , -- �������
    IN inAmount	                   TFloat    , -- ������, �� (�������� ��� �������)
    IN inDistanceFuelChild         TFloat    , -- ������, �� (�������������� ��� �������)
    IN inDistanceWeightTransport   TFloat    , -- ������, �� (� ������,����������)
    IN inWeight	                   TFloat    , -- ��� �����, �� (���������)
    IN inWeightTransport           TFloat    , -- ��� �����, �� (����������)
    IN inStartOdometre             TFloat    , -- ��������� ��������� ���������, ��
    IN inEndOdometre               TFloat    , -- ��������� �������� ���������, ��
 INOUT i�RateSumma                 TFloat    , -- ����� ����������������
    IN inRatePrice                 TFloat    , -- ������ ���/�� (������������)
    IN inTimePrice                 TFloat    , -- ������ ���/� ����������������
    IN inTaxi                      TFloat    , -- ����� �� �����
    IN inTaxiMore                  TFloat    , -- ����� �� �����(�������� ��������������)
 INOUT ioRateSummaAdd              TFloat    , -- ����� �������(������������)
    IN inRateSummaExp              TFloat    , -- ����� ��������������� �����������
   OUT outRatePrice_Calc           TFloat    , -- ����� ��� (������������)
    IN inFreightId                 Integer   , -- �������� �����
    IN inRouteKindId_Freight       Integer   , -- ���� ���������(����)
    IN inRouteKindId               Integer   , -- ���� ���������
 INOUT ioUnitId                    Integer   , -- �������������
   OUT outUnitName                 TVarChar  , -- �������������
    IN inComment                   TVarChar  , -- �����������
    IN inSession                   TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbHours TFloat;
   DECLARE vbOperDate TDateTime;
   DECLARE vbStartRunPlan TDateTime;
   DECLARE vbEndRunPlan TDateTime;
   DECLARE vbHoursWork TFloat;
   
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

   -- ���� ���������
   vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
   
   -- ���� ��� ���� ioId = 0 ������ ����� ������� ��� StartRunPlan + HoursPlan � ��������� � zc_MovementDate_StartRunPlan + zc_MovementDate_EndRunPlan + zc_MovementDate_StartRun + zc_MovementDate_EndRun + zc_MovementFloat_HoursWork 
   -- + ���� ��� ������ �� ��������� zc_MI_Master, �.�. ����� ��������� 2,3 ������� - ��� ��������� �� ������
   IF  COALESCE (ioId, 0) = 0 AND NOT EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE)
   THEN 
       SELECT (vbOperDate ::Date + ObjectDate_StartRunPlan.ValueData::Time) ::TDateTime AS StartRunPlan
            , ((vbOperDate ::Date + ObjectDate_StartRunPlan.ValueData ::Time) ::TDateTime + (ObjectDate_EndRunPlan.ValueData - ObjectDate_StartRunPlan.ValueData)) :: TDateTime AS EndRunPlan
            -- ��������� �������� <���-�� ������� �����>
            , EXTRACT (DAY FROM (ObjectDate_EndRunPlan.ValueData - ObjectDate_StartRunPlan.ValueData)) * 24 
            + EXTRACT (HOUR FROM (ObjectDate_EndRunPlan.ValueData - ObjectDate_StartRunPlan.ValueData)) 
            + CAST (EXTRACT (MIN FROM (ObjectDate_EndRunPlan.ValueData - ObjectDate_StartRunPlan.ValueData)) / 60 AS NUMERIC (16, 2)) AS HoursWork

              INTO vbStartRunPlan, vbEndRunPlan, vbHoursWork  

       FROM Object AS Object_Route
            LEFT JOIN ObjectDate AS ObjectDate_StartRunPlan
                                 ON ObjectDate_StartRunPlan.ObjectId = Object_Route.Id
                                AND ObjectDate_StartRunPlan.DescId = zc_ObjectDate_Route_StartRunPlan()
    
            LEFT JOIN ObjectDate AS ObjectDate_EndRunPlan
                                 ON ObjectDate_EndRunPlan.ObjectId = Object_Route.Id
                                AND ObjectDate_EndRunPlan.DescId = zc_ObjectDate_Route_EndRunPlan()
       WHERE Object_Route.Id = inRouteId;
       
       IF NOT (vbStartRunPlan IS NULL) AND NOT (vbEndRunPlan IS NULL)
       THEN
           -- ��������� ����� � <����/����� ������ ����>
           PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartRunPlan(), inMovementId, vbStartRunPlan);
           -- ��������� ����� � <����/����� ����������� ����>
           PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndRunPlan(), inMovementId, vbEndRunPlan);
           -- ��������� ����� � <����/����� ������ ����>
           PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartRun(), inMovementId, vbStartRunPlan);
           -- ��������� ����� � <����/����� ����������� ����>
           PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndRun(), inMovementId, vbEndRunPlan);
           -- ��������� �������� <���-�� ������� �����>
           PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_HoursWork(), inMovementId, vbHoursWork);
       END IF;

   END IF;
  
   -- ������������ ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- ��������� <������� ���������>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inRouteId, inMovementId, inAmount, NULL);

   -- ��������� ����� � <�������� �����>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Freight(), ioId, inFreightId);

   -- ��������� ����� � <���� ���������(����)>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RouteKindFreight(), ioId, inRouteKindId_Freight);

   -- ��������� ����� � <���� ���������>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RouteKind(), ioId, inRouteKindId);

   -- ������ ��� �������� - ������
   IF vbIsInsert
   THEN
        -- ����� ������������� ��� ������ (�.�. � Child ����������� ������ ��� ����������)
        ioUnitId:= (SELECT CASE WHEN ObjectLink_UnitRoute_Branch.ChildObjectId IS NULL
                                     THEN COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0) -- ���� ������ = "�����", ����� ������� �� �������������� �������� � �������������, �.�. ��� ����(�+��), ���������, �����, ������.
                                WHEN ObjectLink_UnitRoute_Branch.ChildObjectId  = COALESCE (ObjectLink_Route_Branch.ChildObjectId, 0)
                                     THEN COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0) -- ���� "�����������" �������, ����� ������� �� �������������� �������� � �������������, �.�. ��� �������
                                ELSE (SELECT MLO.ObjectId AS MLO FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_UnitForwarding()) -- ����� ������������� (����� ��������), �.�. ����� �� ������� �� ������� � ��� �� ������
                           END
                    FROM Object AS Object_Route
                         LEFT JOIN ObjectLink AS ObjectLink_Route_Branch
                                              ON ObjectLink_Route_Branch.ObjectId = Object_Route.Id
                                             AND ObjectLink_Route_Branch.DescId = zc_ObjectLink_Route_Branch()
                         LEFT JOIN ObjectLink AS ObjectLink_Route_Unit
                                              ON ObjectLink_Route_Unit.ObjectId = Object_Route.Id
                                             AND ObjectLink_Route_Unit.DescId = zc_ObjectLink_Route_Unit()
                         LEFT JOIN ObjectLink AS ObjectLink_UnitRoute_Branch
                                              ON ObjectLink_UnitRoute_Branch.ObjectId = ObjectLink_Route_Unit.ChildObjectId
                                             AND ObjectLink_UnitRoute_Branch.DescId = zc_ObjectLink_Unit_Branch()
                         LEFT JOIN ObjectLink AS ObjectLink_UnitRoute_Business
                                              ON ObjectLink_UnitRoute_Business.ObjectId = ObjectLink_Route_Unit.ChildObjectId
                                             AND ObjectLink_UnitRoute_Business.DescId = zc_ObjectLink_Unit_Business()
                    WHERE Object_Route.Id = inRouteId
                   );
   END IF;
   -- ��� ���������
   outUnitName:= (SELECT Object.ValueData FROM Object WHERE Object.Id = ioUnitId);
   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, ioUnitId);


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

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RateSumma(), ioId, i�RateSumma);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RatePrice(), ioId, inRatePrice);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Taxi(), ioId, inTaxi);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TaxiMore(), ioId, inTaxiMore);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TimePrice(), ioId, inTimePrice);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RateSummaAdd(), ioId, ioRateSummaAdd);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RateSummaExp(), ioId, inRateSummaExp);

   IF COALESCE (inTimePrice,0) <> 0 -- OR 1=1 -- !!!�������� - ��� � ������!!!
   THEN
       vbHours := (SELECT CAST (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) AS TFloat) AS Hours_All
                   FROM MovementFloat AS MovementFloat_HoursWork
                       LEFT JOIN MovementFloat AS MovementFloat_HoursAdd
                                               ON MovementFloat_HoursAdd.MovementId = MovementFloat_HoursWork.MovementId
                                              AND MovementFloat_HoursAdd.DescId = zc_MovementFloat_HoursAdd()
                   WHERE MovementFloat_HoursWork.DescId = zc_MovementFloat_HoursWork()
                     AND MovementFloat_HoursWork.MovementId = inMovementId);

       i�RateSumma:= COALESCE (vbHours,0) * inTimePrice;
       -- ������������� �������� <>
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RateSumma(), ioId, i�RateSumma);

   END IF;


   IF COALESCE (inRatePrice, 0) <> 0 -- OR 1=1 -- !!!�������� - ��� � ������!!!
   THEN
       outRatePrice_Calc:= COALESCE (inRatePrice, 0) * (COALESCE (inAmount, 0) + COALESCE (inDistanceFuelChild, 0));
       --
       ioRateSummaAdd:= 0;
       -- ������������� �������� <>
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RateSummaAdd(), ioId, ioRateSummaAdd);
   ELSE
       outRatePrice_Calc:= ioRateSummaAdd;
   END IF;


   -- ��������� �������� <�����������>
   PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioId, inComment);

   -- !!!�����������!!! ����������� Child
   PERFORM lpInsertUpdate_MI_Transport_Child_byMaster (inMovementId := inMovementId, inParentId := ioId, inRouteKindId:= inRouteKindId, inUserId := vbUserId);

   -- ��������� ��������
   PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.02.17         *
 17.04.16         *
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
