-- Function: lpInsertUpdate_MI_Transport_Child_byMaster (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_Transport_Child_byMaster (Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_Transport_Child_byMaster(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inParentId            Integer   , -- ���� ������� <������� ���������>
    IN inRouteKindId         Integer   , -- ���� ���������
    IN inUserId              Integer     -- ������������
)                              
RETURNS void
AS
$BODY$
   DECLARE vbBranchId Integer;
BEGIN
   -- !!!��� �������� �� ����� ��������� % ��������������� ������� � ����� � �������/������������!!!
   vbBranchId:= (SELECT COALESCE (ObjectLink_UnitRoute_Branch.ChildObjectId, zc_Branch_Basis())
                 FROM MovementLinkObject
                      LEFT JOIN ObjectLink AS ObjectLink_UnitRoute_Branch
                                           ON ObjectLink_UnitRoute_Branch.ObjectId = MovementLinkObject.ObjectId
                                          AND ObjectLink_UnitRoute_Branch.DescId = zc_ObjectLink_Unit_Branch()
                 WHERE MovementLinkObject.MovementId = inMovementId
                   AND MovementLinkObject.DescId = zc_MovementLinkObject_UnitForwarding()
                );

   -- ����������� Child ��� ������������
   PERFORM lpInsertUpdate_MI_Transport_Child (ioId                 := MovementItem.Id
                                            , inMovementId         := inMovementId
                                            , inParentId           := inParentId
                                            , inFuelId             := MovementItem.ObjectId
                                            , inIsCalculated       := MIBoolean_Calculated.ValueData
                                            , inIsMasterFuel       := CASE WHEN COALESCE (ObjectLink_Car_FuelAll.DescId, 0) = zc_ObjectLink_Car_FuelMaster() THEN TRUE ELSE FALSE END
                                            , ioAmount             := MovementItem.Amount
                                            , inColdHour           := COALESCE (MIFloat_ColdHour.ValueData, 0)
                                            , inColdDistance       := COALESCE (MIFloat_ColdDistance.ValueData, 0)
                                              -- ���-�� ����� �� 100 ��, � ������ ������������ � % ��������������� �������
                                            , inAmountFuel         := zfCalc_RateFuelValue_Distance (inDistance           := 100
                                                                                                   , inAmountFuel         := tmpRateFuel.AmountFuel
                                                                                                   , inFuel_Ratio         := ObjectFloat_Fuel_Ratio.ValueData
                                                                                                   , inRateFuelKindTax    := COALESCE (MIFloat_RateFuelKindTax.ValueData, COALESCE (ObjectFloat_RateFuelKind_Tax.ValueData, 0)) -- COALESCE (ObjectFloat_RateFuelKind_Tax.ValueData, MIFloat_RateFuelKindTax.ValueData)
                                                                                                    )
                                              -- �����, ���-�� ����� � ���, � ������ ������������ � % ��������������� �������
                                            , inAmountColdHour     := zfCalc_RateFuelValue_ColdHour (inColdHour           := 1
                                                                                                   , inAmountColdHour     := tmpRateFuel.AmountColdHour
                                                                                                   , inFuel_Ratio         := ObjectFloat_Fuel_Ratio.ValueData
                                                                                                   , inRateFuelKindTax    := COALESCE (MIFloat_RateFuelKindTax.ValueData, COALESCE (ObjectFloat_RateFuelKind_Tax.ValueData, 0)) -- COALESCE (ObjectFloat_RateFuelKind_Tax.ValueData, MIFloat_RateFuelKindTax.ValueData)
                                                                                                    )
                                              -- �����, ���-�� ����� �� 100 ��, � ������ ������������ � % ��������������� �������
                                            , inAmountColdDistance := zfCalc_RateFuelValue_ColdDistance (inColdDistance       := 100
                                                                                                       , inAmountColdDistance := tmpRateFuel.AmountColdDistance
                                                                                                       , inFuel_Ratio         := ObjectFloat_Fuel_Ratio.ValueData
                                                                                                       , inRateFuelKindTax    := COALESCE (MIFloat_RateFuelKindTax.ValueData, COALESCE (ObjectFloat_RateFuelKind_Tax.ValueData, 0)) -- COALESCE (ObjectFloat_RateFuelKind_Tax.ValueData, MIFloat_RateFuelKindTax.ValueData)
                                                                                                        )
                                            , inNumber             := CASE WHEN COALESCE (ObjectLink_Car_FuelAll.DescId, 0) = zc_ObjectLink_Car_FuelMaster() THEN 1
                                                                           WHEN COALESCE (ObjectLink_Car_FuelAll.DescId, 0) = zc_ObjectLink_Car_FuelChild() THEN 2
                                                                           ELSE 3
                                                                      END
                                            , inRateFuelKindTax    := COALESCE (MIFloat_RateFuelKindTax.ValueData, COALESCE (ObjectFloat_RateFuelKind_Tax.ValueData, 0)) -- COALESCE (ObjectFloat_RateFuelKind_Tax.ValueData, MIFloat_RateFuelKindTax.ValueData)
                                            , inRateFuelKindId     := COALESCE (MILinkObject_RateFuelKind.ObjectId, ObjectLink_Fuel_RateFuelKind.ChildObjectId) -- COALESCE (ObjectLink_Fuel_RateFuelKind.ChildObjectId, MILinkObject_RateFuelKind.ObjectId)
                                            , inUserId             := inUserId
                                             )
   FROM MovementItem

             -- ������� ���������� (�� ����)
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                          ON MovementLinkObject_Car.MovementId = inMovementId
                                         AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()

             -- ������� � ���������� - ��� �������
             LEFT JOIN ObjectLink AS ObjectLink_Car_FuelAll ON ObjectLink_Car_FuelAll.ObjectId = MovementLinkObject_Car.ObjectId
                                                           AND ObjectLink_Car_FuelAll.ChildObjectId = MovementItem.ObjectId
                                                           AND ObjectLink_Car_FuelAll.DescId IN (zc_ObjectLink_Car_FuelMaster(), zc_ObjectLink_Car_FuelChild())

             -- ������� � ���� ������� - ����������� �������� ����� 
             LEFT JOIN ObjectFloat AS ObjectFloat_Fuel_Ratio ON ObjectFloat_Fuel_Ratio.ObjectId = ObjectLink_Car_FuelAll.ChildObjectId
                                                            AND ObjectFloat_Fuel_Ratio.DescId = zc_ObjectFloat_Fuel_Ratio()
                                                            AND ObjectFloat_Fuel_Ratio.ValueData <> 0

             -- ������� � ���� ������� - ��� ���� ��� �������
             LEFT JOIN ObjectLink AS ObjectLink_Fuel_RateFuelKind ON ObjectLink_Fuel_RateFuelKind.ObjectId = ObjectLink_Car_FuelAll.ChildObjectId
                                                                 AND ObjectLink_Fuel_RateFuelKind.DescId = zc_ObjectLink_Fuel_RateFuelKind()
             -- ������� � ����� ��� ������� - % ��������������� ������� � ����� � �������/������������
             LEFT JOIN ObjectFloat AS ObjectFloat_RateFuelKind_Tax ON ObjectFloat_RateFuelKind_Tax.ObjectId = ObjectLink_Fuel_RateFuelKind.ChildObjectId
                                                                  AND ObjectFloat_RateFuelKind_Tax.DescId = zc_ObjectFloat_RateFuelKind_Tax()
                                                                  -- AND vbBranchId = zc_Branch_Basis()

             -- ������� ����� ��� ���������� + ��� ��������
             LEFT JOIN (SELECT ObjectLink_RateFuel_Car.ChildObjectId       AS CarId
                             , ObjectLink_RateFuel_RouteKind.ChildObjectId AS RouteKindId
                             , ObjectFloat_Amount.ValueData                AS AmountFuel
                             , ObjectFloat_AmountColdHour.ValueData        AS AmountColdHour
                             , ObjectFloat_AmountColdDistance.ValueData    AS AmountColdDistance
                        FROM ObjectLink AS ObjectLink_RateFuel_Car
                             LEFT JOIN ObjectLink AS ObjectLink_RateFuel_RouteKind
                                                  ON ObjectLink_RateFuel_RouteKind.ObjectId = ObjectLink_RateFuel_Car.ObjectId
                                                 AND ObjectLink_RateFuel_RouteKind.DescId = zc_ObjectLink_RateFuel_RouteKind()
                             LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                                   ON ObjectFloat_Amount.ObjectId = ObjectLink_RateFuel_Car.ObjectId
                                                  AND ObjectFloat_Amount.DescId = zc_ObjectFloat_RateFuel_Amount()
                             LEFT JOIN ObjectFloat AS ObjectFloat_AmountColdHour
                                                   ON ObjectFloat_AmountColdHour.ObjectId = ObjectLink_RateFuel_Car.ObjectId
                                                  AND ObjectFloat_AmountColdHour.DescId = zc_ObjectFloat_RateFuel_AmountColdHour()
                             LEFT JOIN ObjectFloat AS ObjectFloat_AmountColdDistance
                                                   ON ObjectFloat_AmountColdDistance.ObjectId = ObjectLink_RateFuel_Car.ObjectId
                                                  AND ObjectFloat_AmountColdDistance.DescId = zc_ObjectFloat_RateFuel_AmountColdDistance()
                        WHERE ObjectLink_RateFuel_Car.DescId = zc_ObjectLink_RateFuel_Car()
                       ) AS tmpRateFuel ON tmpRateFuel.CarId       = MovementLinkObject_Car.ObjectId
                                       AND tmpRateFuel.RouteKindId = inRouteKindId
                                       AND ObjectLink_Car_FuelAll.ChildObjectId IS NOT NULL -- !!!�����������, ��� � ��������� �������� ���� �������!!!

             LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                           ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                          AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()

             LEFT JOIN MovementItemFloat AS MIFloat_ColdHour
                                         ON MIFloat_ColdHour.MovementItemId = MovementItem.Id
                                        AND MIFloat_ColdHour.DescId = zc_MIFloat_ColdHour()
             LEFT JOIN MovementItemFloat AS MIFloat_ColdDistance
                                         ON MIFloat_ColdDistance.MovementItemId = MovementItem.Id
                                        AND MIFloat_ColdDistance.DescId = zc_MIFloat_ColdDistance()
             LEFT JOIN MovementItemFloat AS MIFloat_RateFuelKindTax
                                         ON MIFloat_RateFuelKindTax.MovementItemId = MovementItem.Id
                                        AND MIFloat_RateFuelKindTax.DescId = zc_MIFloat_RateFuelKindTax()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_RateFuelKind
                                              ON MILinkObject_RateFuelKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_RateFuelKind.DescId = zc_MILinkObject_RateFuelKind()

   WHERE MovementItem.MovementId = inMovementId
     AND MovementItem.DescId = zc_MI_Child()
     AND MovementItem.ParentId = inParentId;

   -- ������������ Child ��� ����� (!!!���� ���� �����!!!)
   PERFORM lpInsertUpdate_MI_Transport_Child (ioId                 := 0
                                            , inMovementId         := inMovementId
                                            , inParentId           := inParentId
                                            , inFuelId             := ObjectLink_Car_FuelAll.ChildObjectId
                                            , inIsCalculated       := TRUE
                                            , inIsMasterFuel       := CASE WHEN ObjectLink_Car_FuelAll.DescId = zc_ObjectLink_Car_FuelMaster() THEN TRUE ELSE FALSE END
                                            , ioAmount             := 0
                                            , inColdHour           := 0
                                            , inColdDistance       := 0
                                              -- ���-�� ����� �� 100 ��, � ������ ������������ � % ��������������� �������
                                            , inAmountFuel         := zfCalc_RateFuelValue_Distance (inDistance           := 100
                                                                                                   , inAmountFuel         := tmpRateFuel.AmountFuel
                                                                                                   , inFuel_Ratio         := ObjectFloat_Fuel_Ratio.ValueData
                                                                                                   , inRateFuelKindTax    := COALESCE (ObjectFloat_RateFuelKind_Tax.ValueData, 0)
                                                                                                    )
                                              -- �����, ���-�� ����� � ���, � ������ ������������ � % ��������������� �������
                                            , inAmountColdHour     := zfCalc_RateFuelValue_ColdHour (inColdHour           := 1
                                                                                                   , inAmountColdHour     := tmpRateFuel.AmountColdHour
                                                                                                   , inFuel_Ratio         := ObjectFloat_Fuel_Ratio.ValueData
                                                                                                   , inRateFuelKindTax    := COALESCE (ObjectFloat_RateFuelKind_Tax.ValueData, 0)
                                                                                                    )
                                              -- �����, ���-�� ����� �� 100 ��, � ������ ������������ � % ��������������� �������
                                            , inAmountColdDistance := zfCalc_RateFuelValue_ColdDistance (inColdDistance       := 100
                                                                                                       , inAmountColdDistance := tmpRateFuel.AmountColdDistance
                                                                                                       , inFuel_Ratio         := ObjectFloat_Fuel_Ratio.ValueData
                                                                                                       , inRateFuelKindTax    := COALESCE (ObjectFloat_RateFuelKind_Tax.ValueData, 0)
                                                                                                        )
                                            , inNumber             := CASE WHEN ObjectLink_Car_FuelAll.DescId = zc_ObjectLink_Car_FuelMaster() THEN 1 ELSE 2 END
                                            , inRateFuelKindTax    := COALESCE (ObjectFloat_RateFuelKind_Tax.ValueData, 0)
                                            , inRateFuelKindId     := ObjectLink_Fuel_RateFuelKind.ChildObjectId
                                            , inUserId             := inUserId
                                             )
        -- !!!��� ������ �� gpSelect_MI_Transport!!!
        FROM (SELECT zc_ObjectLink_Car_FuelMaster() AS DescId UNION ALL SELECT zc_ObjectLink_Car_FuelChild() AS DescId) AS tmpDesc
             -- ������� ���������� (�� ����)
             JOIN MovementLinkObject AS MovementLinkObject_Car
                                     ON MovementLinkObject_Car.MovementId = inMovementId
                                    AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
             -- ������� � ���������� - ��� ���� �������
             JOIN ObjectLink AS ObjectLink_Car_FuelAll ON ObjectLink_Car_FuelAll.ObjectId = MovementLinkObject_Car.ObjectId
                                                      AND ObjectLink_Car_FuelAll.DescId = tmpDesc.DescId
                                                      AND ObjectLink_Car_FuelAll.ChildObjectId IS NOT NULL

             -- ������� � ���� ������� - ����������� �������� ����� 
             LEFT JOIN ObjectFloat AS ObjectFloat_Fuel_Ratio ON ObjectFloat_Fuel_Ratio.ObjectId = ObjectLink_Car_FuelAll.ChildObjectId
                                                            AND ObjectFloat_Fuel_Ratio.DescId = zc_ObjectFloat_Fuel_Ratio()
                                                            AND ObjectFloat_Fuel_Ratio.ValueData <> 0

             -- ������� � ���� ������� - ��� ���� ��� �������
             LEFT JOIN ObjectLink AS ObjectLink_Fuel_RateFuelKind ON ObjectLink_Fuel_RateFuelKind.ObjectId = ObjectLink_Car_FuelAll.ChildObjectId
                                                                 AND ObjectLink_Fuel_RateFuelKind.DescId = zc_ObjectLink_Fuel_RateFuelKind()
             -- ������� � ����� ��� ������� - % ��������������� ������� � ����� � �������/������������
             LEFT JOIN ObjectFloat AS ObjectFloat_RateFuelKind_Tax ON ObjectFloat_RateFuelKind_Tax.ObjectId = ObjectLink_Fuel_RateFuelKind.ChildObjectId
                                                                  AND ObjectFloat_RateFuelKind_Tax.DescId = zc_ObjectFloat_RateFuelKind_Tax()
                                                                  -- AND vbBranchId = zc_Branch_Basis()
            -- ���� ����� ��� � ��������� ��� ��������� ��� ������� (���� ������/�� ������)
             LEFT JOIN MovementItem AS MovementItem_Find ON MovementItem_Find.MovementId = inMovementId
                                                        AND MovementItem_Find.ParentId   = inParentId
                                                        AND MovementItem_Find.ObjectId   = ObjectLink_Car_FuelAll.ChildObjectId
                                                        AND MovementItem_Find.DescId     = zc_MI_Child()
                                                        -- AND MovementItem_Find.isErased = FALSE

             -- ������� ����� ��� ���������� + ��� ��������
             LEFT JOIN (SELECT ObjectLink_RateFuel_Car.ChildObjectId       AS CarId
                             , ObjectLink_RateFuel_RouteKind.ChildObjectId AS RouteKindId
                             , ObjectFloat_Amount.ValueData                AS AmountFuel
                             , ObjectFloat_AmountColdHour.ValueData        AS AmountColdHour
                             , ObjectFloat_AmountColdDistance.ValueData    AS AmountColdDistance
                        FROM ObjectLink AS ObjectLink_RateFuel_Car
                             LEFT JOIN ObjectLink AS ObjectLink_RateFuel_RouteKind
                                                  ON ObjectLink_RateFuel_RouteKind.ObjectId = ObjectLink_RateFuel_Car.ObjectId
                                                 AND ObjectLink_RateFuel_RouteKind.DescId = zc_ObjectLink_RateFuel_RouteKind()
                             LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                                   ON ObjectFloat_Amount.ObjectId = ObjectLink_RateFuel_Car.ObjectId
                                                  AND ObjectFloat_Amount.DescId = zc_ObjectFloat_RateFuel_Amount()
                             LEFT JOIN ObjectFloat AS ObjectFloat_AmountColdHour
                                                   ON ObjectFloat_AmountColdHour.ObjectId = ObjectLink_RateFuel_Car.ObjectId
                                                  AND ObjectFloat_AmountColdHour.DescId = zc_ObjectFloat_RateFuel_AmountColdHour()
                             LEFT JOIN ObjectFloat AS ObjectFloat_AmountColdDistance
                                                   ON ObjectFloat_AmountColdDistance.ObjectId = ObjectLink_RateFuel_Car.ObjectId
                                                  AND ObjectFloat_AmountColdDistance.DescId = zc_ObjectFloat_RateFuel_AmountColdDistance()
                        WHERE ObjectLink_RateFuel_Car.DescId = zc_ObjectLink_RateFuel_Car()
                       ) AS tmpRateFuel ON tmpRateFuel.CarId       = MovementLinkObject_Car.ObjectId
                                       AND tmpRateFuel.RouteKindId = inRouteKindId

             -- ��� ��� �������
             LEFT JOIN MovementItem AS MovementItem_Master ON MovementItem_Master.Id = inParentId
                                                          AND MovementItem_Master.MovementId = inMovementId
             LEFT JOIN MovementItemFloat AS MIFloat_DistanceFuelChild
                                         ON MIFloat_DistanceFuelChild.MovementItemId = MovementItem_Master.Id
                                        AND MIFloat_DistanceFuelChild.DescId = zc_MIFloat_DistanceFuelChild()

        WHERE MovementItem_Find.ObjectId IS NULL
              -- ���� ������ �� ������, ����� ����������� �������� �� ����
         AND (COALESCE (MovementItem_Master.Amount, 0) <> 0 OR COALESCE (MIFloat_DistanceFuelChild.ValueData, 0) <> 0)
              -- ���� ����� ���, ����� ����������� �������� �� ����
         AND (tmpRateFuel.AmountFuel <> 0 OR tmpRateFuel.AmountColdHour <> 0 OR tmpRateFuel.AmountColdDistance <> 0);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 20.05.14                                        * add COALESCE (ObjectFloat_RateFuelKind_Tax.ValueData, 0)
 14.02.13                                        * !!!��� �������� �� ����� ��������� % ��������������� ������� � ����� � �������/������������!!!
 11.12.13                                        * ������� ��������� � ����������� Child - ����� ��� ������������
 24.10.13                                        * add zfCalc_RateFuelValue_...
 13.10.13                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MI_Transport_Child_byMaster (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
