-- Function: lpComplete_Movement_Transport (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Transport (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Transport(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementDescId Integer;

  DECLARE vbOperDate TDateTime;
  DECLARE vbMemberDriverId Integer;
  DECLARE vbCarId Integer;
  DECLARE vbUnitId_Forwarding Integer;

  DECLARE vbJuridicalId_Basis Integer;
  -- DECLARE vbBusinessId_Car Integer; !!!����� ��������!!!

  DECLARE vbStartSummCash TFloat;
  DECLARE vbStartAmountTicketFuel TFloat;
  DECLARE vbStartAmountFuel TFloat;

  DECLARE vbIsAccount_50000   Boolean;
  DECLARE vbPartionMovementId Integer;
BEGIN

     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;

     -- !!!�����������!!! �������� ������� - �������� ������ ��� ������������� ������ �� ���������
     DELETE FROM _tmpMI_Sale;
     -- !!!�����������!!! �������� ������� ������� (�������) ���������/���������
     DELETE FROM _tmpPropertyRemains;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem_Transport;
     -- !!!�����������!!! �������� ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem_TransportSumm_Transport;
     -- !!!�����������!!! �������� ������� - �������� �� ���������� (��) + ������� "���������������" + "������������" + "�����", �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem_SummPersonal;


     -- 1.0. !!!�����������!!! - ���� ��� ������� ������� ��������
     vbIsAccount_50000:= EXISTS (SELECT 1
                                 FROM MovementFloat
                                      INNER JOIN Movement ON Movement.Id       = MovementFloat.MovementId
                                                         AND Movement.DescId   = zc_Movement_IncomeCost()
                                                      -- AND Movement.StatusId = zc_Enum_Status_Complete()
                                                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 WHERE MovementFloat.ValueData = inMovementId
                                   AND MovementFloat.DescId    = zc_MovementFloat_MovementId()
                                );

     -- !!!�����������!!! ����������� Child - �����
     /*PERFORM lpInsertUpdate_MI_Transport_Child_byMaster (inMovementId := inMovementId, inParentId := MovementItem.Id, inRouteKindId:= MILinkObject_RouteKind.ObjectId, inUserId := inUserId)
     FROM MovementItem
          LEFT JOIN MovementItemLinkObject AS MILinkObject_RouteKind
                                           ON MILinkObject_RouteKind.MovementItemId = MovementItem.Id
                                          AND MILinkObject_RouteKind.DescId = zc_MILinkObject_RouteKind()
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Master();*/


     -- �������������
     PERFORM lpUpdate_Movement_Transport_PartnerCount (inMovementId_trasport:= inMovementId, inUserId:= inUserId);

     -- �������������
     IF 1=0
     THEN
                  -- ������������� �������� <������ ���/� ����������������>
          PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TimePrice(), MovementItem.Id, COALESCE (ObjectFloat_TimePrice.ValueData, 0))
                  -- ��������� �������� <������ ���/�� (������������)>
                , lpInsertUpdate_MovementItemFloat (zc_MIFloat_RatePrice(), MovementItem.Id, COALESCE (ObjectFloat_RatePrice.ValueData, 0))
                  -- ������������� �������� <����� ����������������>
                , lpInsertUpdate_MovementItemFloat (zc_MIFloat_RateSumma(), MovementItem.Id, CASE WHEN ObjectFloat_TimePrice.ValueData > 0
                                                                                                       THEN ObjectFloat_TimePrice.ValueData
                                                                                                          * CAST (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) AS TFloat)
                                                                                                  ELSE COALESCE (ObjectFloat_RateSumma.ValueData, 0)
                                                                                             END)
                  -- ������������� �������� <����� ������� (������������)>
                , lpInsertUpdate_MovementItemFloat (zc_MIFloat_RateSummaAdd(), MovementItem.Id, CASE WHEN ObjectFloat_RatePrice.ValueData > 0
                                                                                                          THEN 0
                                                                                                     ELSE COALESCE (ObjectFloat_RateSummaAdd.ValueData, 0)
                                                                                                END)
          FROM MovementItem
               LEFT JOIN MovementFloat AS MovementFloat_HoursWork
                                       ON MovementFloat_HoursWork.MovementId = inMovementId
                                      AND MovementFloat_HoursWork.DescId     = zc_MovementFloat_HoursWork()
               LEFT JOIN MovementFloat AS MovementFloat_HoursAdd
                                       ON MovementFloat_HoursAdd.MovementId = inMovementId
                                      AND MovementFloat_HoursAdd.DescId     = zc_MovementFloat_HoursAdd()
               LEFT JOIN ObjectFloat AS ObjectFloat_RateSumma
                                     ON ObjectFloat_RateSumma.ObjectId = MovementItem.ObjectId
                                    AND ObjectFloat_RateSumma.DescId   = zc_ObjectFloat_Route_RateSumma()
               LEFT JOIN ObjectFloat AS ObjectFloat_RatePrice
                                     ON ObjectFloat_RatePrice.ObjectId = MovementItem.ObjectId
                                    AND ObjectFloat_RatePrice.DescId   = zc_ObjectFloat_Route_RatePrice()
               LEFT JOIN ObjectFloat AS ObjectFloat_TimePrice
                                     ON ObjectFloat_TimePrice.ObjectId = MovementItem.ObjectId
                                    AND ObjectFloat_TimePrice.DescId   = zc_ObjectFloat_Route_TimePrice()
               LEFT JOIN ObjectFloat AS ObjectFloat_RateSummaAdd
                                     ON ObjectFloat_RateSummaAdd.ObjectId = MovementItem.ObjectId
                                    AND ObjectFloat_RateSummaAdd.DescId   = zc_ObjectFloat_Route_RateSummaAdd()
          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId     = zc_MI_Master()
            AND MovementItem.isErased   = FALSE;

     END IF;



     -- ��� ��������� ����� ��� ������������ �������� � ���������
     SELECT _tmp.MovementDescId
          , _tmp.OperDate
          , _tmp.MemberDriverId, _tmp.CarId, _tmp.UnitId_Forwarding
          , _tmp.JuridicalId_Basis
          -- , _tmp.BusinessId_Car
          , _tmp.PartionMovementId
            INTO vbMovementDescId, vbOperDate
               , vbMemberDriverId, vbCarId, vbUnitId_Forwarding
               , vbJuridicalId_Basis -- ��� ��������� ������� � ������������� (����� ��������) (� ������������ ������ ��� �������� �� �������)
               -- , vbBusinessId_Car -- !!!����� ��������!!! ��� ��������� ������� � ������������� �� ������� �������� ���������� (� ������������ ������ ��� �������� �� �������� ��������)
               , vbPartionMovementId
     FROM (SELECT Movement.DescId AS MovementDescId
                , Movement.OperDate
                , COALESCE (ObjectLink_PersonalDriver_Member.ChildObjectId, 0)     AS MemberDriverId
                , COALESCE (MovementLinkObject_Car.ObjectId, 0)                    AS CarId
                , COALESCE (MovementLinkObject_UnitForwarding.ObjectId, 0)         AS UnitId_Forwarding
                , COALESCE (ObjectLink_UnitForwarding_Juridical.ChildObjectId, 0)  AS JuridicalId_Basis
                -- , COALESCE (ObjectLink_UnitCar_Business.ChildObjectId, 0)          AS BusinessId_Car
                , CASE WHEN vbIsAccount_50000 = TRUE THEN lpInsertFind_Object_PartionMovement (inMovementId:= inMovementId, inPaymentDate:= Movement.OperDate) ELSE 0 END AS PartionMovementId
           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                             ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                            AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                             ON MovementLinkObject_Car.MovementId = Movement.Id
                                            AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitForwarding
                                             ON MovementLinkObject_UnitForwarding.MovementId = Movement.Id
                                            AND MovementLinkObject_UnitForwarding.DescId = zc_MovementLinkObject_UnitForwarding()
                LEFT JOIN ObjectLink AS ObjectLink_PersonalDriver_Member
                                     ON ObjectLink_PersonalDriver_Member.ObjectId = MovementLinkObject_PersonalDriver.ObjectId
                                    AND ObjectLink_PersonalDriver_Member.DescId = zc_ObjectLink_Personal_Member()
                /*LEFT JOIN ObjectLink AS ObjectLink_Car_Unit
                                     ON ObjectLink_Car_Unit.ObjectId = MovementLinkObject_Car.ObjectId
                                    AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
                LEFT JOIN ObjectLink AS ObjectLink_UnitCar_Business
                                     ON ObjectLink_UnitCar_Business.ObjectId = ObjectLink_Car_Unit.ChildObjectId
                                    AND ObjectLink_UnitCar_Business.DescId = zc_ObjectLink_Unit_Business()*/
                LEFT JOIN ObjectLink AS ObjectLink_UnitForwarding_Juridical
                                     ON ObjectLink_UnitForwarding_Juridical.ObjectId = MovementLinkObject_UnitForwarding.ObjectId
                                    AND ObjectLink_UnitForwarding_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
           WHERE Movement.Id = inMovementId
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             AND Movement.DescId = zc_Movement_Transport()
          ) AS _tmp;


     -- !!!��������!!!
     IF COALESCE (vbJuridicalId_Basis, 0) = 0
     THEN
        RAISE EXCEPTION '������. �� ���������� <������� ��.����> ��� <%>.', lfGet_Object_ValueData_sh (vbUnitId_Forwarding);
     END IF;


     -- ����������� ������ - �������� ������ ��� ������������� ������ �� ���������
     WITH -- ������ �������
          tmpReestr AS
                     (SELECT MovementItem.Id AS MI_Id
                      FROM MovementLinkMovement AS MLM_Transport
                           JOIN Movement ON Movement.Id       = MLM_Transport.MovementId
                                        AND Movement.DescId   = zc_Movement_Reestr()
                                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                           LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                 AND MovementItem.isErased   = FALSE
                      WHERE MLM_Transport.DescId          = zc_MovementLinkMovement_Transport()
                        AND MLM_Transport.MovementChildId = inMovementId
                        AND vbIsAccount_50000 = FALSE
                     )
          -- ��������� ������� - �������� ����� � ������� ���������
        , tmpMF_MovementItemId AS (SELECT MovementFloat_MovementItemId.MovementId AS MovementId_sale
                                   FROM MovementFloat AS MovementFloat_MovementItemId
                                   WHERE MovementFloat_MovementItemId.ValueData IN (SELECT DISTINCT tmpReestr.MI_Id FROM tmpReestr)
                                     AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                                  )
          -- ��������� ������� - ������
        , tmpMI_sale_all AS (SELECT tmpSale.MovementId_sale AS MovementId_sale
                                  , MovementItem.Id         AS MI_Id_sale
                                  , MovementItem.ObjectId   AS GoodsId
                             FROM (SELECT DISTINCT tmpMF_MovementItemId.MovementId_sale FROM tmpMF_MovementItemId) AS tmpSale
                                  INNER JOIN MovementItem ON MovementItem.MovementId = tmpSale.MovementId_Sale
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                         AND MovementItem.isErased   = FALSE
                            )
          --
        , tmpMLO_To AS (SELECT *
                        FROM MovementLinkObject AS MovementLinkObject_To
                        WHERE MovementLinkObject_To.MovementId IN (SELECT DISTINCT tmpMF_MovementItemId.MovementId_sale FROM tmpMF_MovementItemId)
                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                        )
         --
       , tmpMILO_GoodsKind AS (SELECT *
                               FROM MovementItemLinkObject
                               WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_sale_all.MI_Id_sale FROM tmpMI_sale_all)
                                 AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                              )
         --
       , tmpMIF_AmountPartner AS (SELECT *
                                  FROM MovementItemFloat AS MIFloat_AmountPartner
                                  WHERE MIFloat_AmountPartner.MovementItemId IN (SELECT DISTINCT tmpMI_sale_all.MI_Id_sale FROM tmpMI_sale_all)
                                    AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                  )
              -- ��������� ������� - ������
            , tmpMI_sale AS (SELECT tmpMI_sale_all.MI_Id_sale                           AS MI_Id_sale
                                  , MovementLinkObject_To.ObjectId                      AS PartnerId
                                  , tmpMI_sale_all.GoodsId                              AS GoodsId
                                  , MILinkObject_GoodsKind.ObjectId                     AS GoodsKindId
                                  , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS Amount
                                  , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                       * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0)
                                              WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN 1
                                              ELSE 0
                                         END) ::TFloat AS AmountWeight
                             FROM tmpMI_sale_all
                                  LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = tmpMI_sale_all.MI_Id_sale
                                  LEFT JOIN tmpMIF_AmountPartner AS MIFloat_AmountPartner
                                                                 ON MIFloat_AmountPartner.MovementItemId = tmpMI_sale_all.MI_Id_sale
                                  -- ����������
                                  LEFT JOIN tmpMLO_To AS MovementLinkObject_To
                                                      ON MovementLinkObject_To.MovementId = tmpMI_sale_all.MovementId_sale
                                  --
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                       ON ObjectLink_Goods_Measure.ObjectId = tmpMI_sale_all.GoodsId
                                                      AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                        ON ObjectFloat_Weight.ObjectId = tmpMI_sale_all.GoodsId
                                                       AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                             GROUP BY tmpMI_sale_all.MI_Id_sale
                                    , MovementLinkObject_To.ObjectId
                                    , tmpMI_sale_all.GoodsId
                                    , MILinkObject_GoodsKind.ObjectId
                            )
     -- ���������
     INSERT INTO _tmpMI_Sale (MI_Id_sale, PartnerId, GoodsId, GoodsKindId, Amount, AmountWeight)
        SELECT tmpMI_sale.MI_Id_sale, tmpMI_sale.PartnerId, tmpMI_sale.GoodsId, tmpMI_sale.GoodsKindId, tmpMI_sale.Amount, tmpMI_sale.AmountWeight
        FROM tmpMI_sale
        WHERE tmpMI_sale.AmountWeight > 0
       ;


     -- !!!������!!! ������/���������� ��������� ������� (�������) ���������/���������

     -- �������� ��� ������ ��� ��������������/�������� ���������� �� ������������ �������/������ !!!��� ����������� �� ������� � �������� ��.����!!!
     WITH tmpContainer AS  (SELECT Id, Amount, 0 AS FuelId, 1 AS Kind
                            FROM Container
                                               -- ���������� ������� ������: (30500) �������� + ���������� (����������� ����) + (20400) ������������� + ���
                            WHERE ObjectId IN (SELECT AccountId FROM Object_Account_View WHERE AccountDirectionId = zc_Enum_AccountDirection_30500() AND InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20400())
                                         -- ���������� �� ��������� <����������>
                              AND Id IN (SELECT ContainerId FROM ContainerLinkObject WHERE DescId = zc_ContainerLinkObject_Car() AND ObjectId = vbCarId)
                              AND DescId = zc_Container_Summ()
                           UNION
                            SELECT Id, Amount, 0 AS FuelId, 2 AS Kind
                            FROM Container
                                               -- ���������� ������� �������: (20400)���
                            WHERE ObjectId IN (SELECT GoodsId FROM Object_Goods_View WHERE InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20400())
                                          -- ���������� �� ��������� <���������>
                              AND Id IN (SELECT ContainerId FROM ContainerLinkObject WHERE DescId = zc_ContainerLinkObject_Member() AND ObjectId = vbMemberDriverId)
                              AND DescId = zc_Container_Count()
                           UNION
                            SELECT Id, Amount, Container.ObjectId AS FuelId, 3 AS Kind
                            FROM Container
                                              -- ���������� ������� ���� �������
                            WHERE ObjectId IN (SELECT Id FROM Object WHERE DescId = zc_Object_Fuel())
                                          -- ���������� �� ��������� <����������>
                              AND Id IN (SELECT ContainerId FROM ContainerLinkObject WHERE DescId =  zc_ContainerLinkObject_Car() AND ObjectId = vbCarId)
                              AND DescId = zc_Container_Count()
                           )
     -- ������
     INSERT INTO _tmpPropertyRemains (Kind, FuelId, Amount)
       SELECT tmpRemains.Kind
           , tmpRemains.FuelId
            , SUM (tmpRemains.AmountRemainsStart) AS Amount
       FROM (SELECT tmpContainer.Id, tmpContainer.FuelId, tmpContainer.Kind, tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS AmountRemainsStart
             FROM tmpContainer
                  LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = tmpContainer.Id
                                                                AND MIContainer.OperDate >= vbOperDate
             GROUP BY tmpContainer.Id, tmpContainer.FuelId, tmpContainer.Kind, tmpContainer.Amount
             HAVING tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
           ) AS tmpRemains
       GROUP BY tmpRemains.Kind
              , tmpRemains.FuelId;

     -- �������� ������� �� ������ Kind
     SELECT SUM (CASE WHEN Kind = 1 THEN Amount ELSE 0 END) AS StartSummCash         -- ��������� ������� ����� ����������(��������)
          , SUM (CASE WHEN Kind = 2 THEN Amount ELSE 0 END) AS StartAmountTicketFuel -- ��������� ������� ������� �� ������� ��������� (��������)
            INTO vbStartSummCash, vbStartAmountTicketFuel
     FROM _tmpPropertyRemains WHERE Kind IN (1, 2);

     -- ��������� �������� ��������� <��������� ������� ����� ����������(��������)>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_StartSummCash(), inMovementId, vbStartSummCash);
     -- ��������� �������� ��������� <��������� ������� ������� �� ������� ��������� (��������)>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_StartAmountTicketFuel(), inMovementId, vbStartAmountTicketFuel);

     -- !!!����� ���������!!! ������/���������� ��������� ������� (�������) ���������/���������


     -- ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem_Transport (MovementItemId, MovementItemId_parent, UnitId_ProfitLoss, BranchId_ProfitLoss, RouteId_ProfitLoss, UnitId_Route, BranchId_Route
                                   , ContainerId_Goods, GoodsId, AssetId
                                   , OperCount
                                   , ProfitLossGroupId, ProfitLossDirectionId, InfoMoneyDestinationId, InfoMoneyId
                                   , BusinessId_Car, BusinessId_Route
                                   , JuridicalId, ContractId, PaidKindId
                                    )
        SELECT
              _tmp.MovementItemId
            , _tmp.MovementItemId_parent
            , _tmp.UnitId_ProfitLoss
            , _tmp.BranchId_ProfitLoss
            , _tmp.RouteId_ProfitLoss
            , _tmp.UnitId_Route
            , _tmp.BranchId_Route
            , 0 AS ContainerId_Goods -- ���������� �����
            , _tmp.GoodsId
            , _tmp.AssetId
            , _tmp.OperCount
            , _tmp.ProfitLossGroupId      -- ������ ����
            , _tmp.ProfitLossDirectionId  -- ��������� ����  - �����������
            , _tmp.InfoMoneyDestinationId -- �������������� ����������
            , _tmp.InfoMoneyId            -- ������ ����������
              -- !!!����� ��������!!! ������ ��� �������� �� ����������, ��� ��������� ������� � ������������� �� ������� �������� ����������
            , 0 AS BusinessId_Car -- vbBusinessId_Car AS BusinessId_Car
              -- ������ ��� �������, ��� ��������� ������ ������� �� �������������� �������� � �������������
            , _tmp.BusinessId_Route

            , _tmp.JuridicalId
            , _tmp.ContractId
            , _tmp.PaidKindId

        FROM (SELECT
                     COALESCE (MovementItem.Id, 0) AS MovementItemId
                   , MovementItem_Parent.Id        AS MovementItemId_parent
--                   , COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0)       AS UnitId_ProfitLoss   -- ������ ������� �� �������������� �������� � �������������, ����� ���� �������� �� vbUnitId_Car, ����� ������� ����� �� �������������� ���� � �������������
--                   , COALESCE (ObjectLink_UnitRoute_Branch.ChildObjectId, 0) AS BranchId_ProfitLoss -- ������ ������� �� �������������� �������� � �������������, ����� ���� �������� �� vbBranchId_Car, ����� ������� ����� �� �������������� ���� � �������������

                     -- ������������� ����
                   , CASE -- ���� ������ = "�����", ����� ������� �� �������������� �������� � �������������, �.�. ��� ����(�+��), ���������, �����, ������.
                          WHEN ObjectLink_UnitRoute_Branch.ChildObjectId IS NULL
                               THEN COALESCE (MILinkObject_Unit_parent.ObjectId, ObjectLink_Route_Unit.ChildObjectId, 0)

                          -- ���� "�����������" �������, ����� ������� �� �������������� �������� � �������������, �.�. ��� ������� - ������������ ����� "���������� ��������"
                          WHEN ObjectLink_UnitRoute_Branch.ChildObjectId  = COALESCE (ObjectLink_Route_Branch.ChildObjectId, 0)
                               THEN COALESCE (MILinkObject_Unit_parent.ObjectId, ObjectLink_Route_Unit.ChildObjectId, 0)

                          -- ���� ������� "�� ������" � ��� ���� ������, ����� ������� ������ �� ������ - ������������ ����� "���������� ����������"
                          WHEN ObjectLink_UnitRoute_Branch.ChildObjectId  <> ObjectLink_Route_Branch.ChildObjectId AND ObjectLink_Route_Branch.ChildObjectId > 0
                               THEN COALESCE (MILinkObject_Unit_parent.ObjectId, ObjectLink_Route_Unit.ChildObjectId, 0)

                          ELSE vbUnitId_Forwarding -- ����� ������������� (����� ��������), �.�. ����� �� ������� �� ..... ?������� � ��� �� ������?

                     END AS UnitId_ProfitLoss

                     -- ������ ����
                   , CASE -- ���� "�����������" �������, ����� ������� �� �������������� �������� � ������������� � � ������� - ������������ ����� "���������� ��������"
                          WHEN ObjectLink_UnitRoute_Branch.ChildObjectId  = COALESCE (ObjectLink_Route_Branch.ChildObjectId, 0)
                               THEN COALESCE (ObjectLink_UnitRoute_Branch.ChildObjectId, 0)

                          -- ���� ������� "�� ������" � ��� ���� ������, ����� ������� ������ �� ������ - ������������ ����� "���������� ����������"
                          WHEN ObjectLink_UnitRoute_Branch.ChildObjectId  <> ObjectLink_Route_Branch.ChildObjectId AND ObjectLink_Route_Branch.ChildObjectId > 0
                               THEN COALESCE (ObjectLink_Route_Branch.ChildObjectId, 0)

                          -- ����� ������� ��� �������������� � �������
                          ELSE 0
                     END AS BranchId_ProfitLoss

                     -- ������ zc_MI_Master
                   , COALESCE (MovementItem_Parent.ObjectId, 0)                                                      AS RouteId_ProfitLoss
                     -- ������ � �������� ��� zc_MI_Master
                   , COALESCE (MILinkObject_Unit_parent.ObjectId, ObjectLink_Route_Unit.ChildObjectId, 0) AS UnitId_Route
                     -- ������ ������ � ������������� �� �������� ��� zc_MI_Master
                   , COALESCE (ObjectLink_UnitRoute_Branch.ChildObjectId, 0)                                         AS BranchId_Route

                     -- ��� ���������� ��� ��� �������
                   , COALESCE (MovementItem.ObjectId, 0) AS GoodsId
                   , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
                   , COALESCE (MovementItem.Amount, 0) AS OperCount
                     -- ������ ����
                   , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossGroupId, 0) AS ProfitLossGroupId
                     -- ��������� ���� - �����������
                   , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossDirectionId, 0) AS ProfitLossDirectionId
                     -- �������������� ����������
                   , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                     -- ������ ����������
                   , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId
                     -- ������ ��� �������, ��� ��������� ������ ������� �� �������������� �������� � �������������
                   , COALESCE (ObjectLink_UnitRoute_Business.ChildObjectId, 0) AS BusinessId_Route

                   , COALESCE (ObjectLink_Contract_Juridical.ObjectId, 0)      AS JuridicalId
                   , COALESCE (ObjectLink_UnitRoute_Contract.ChildObjectId, 0) AS ContractId
                   , COALESCE (ObjectLink_Contract_PaidKind.ChildObjectId, 0)  AS PaidKindId

              FROM Movement
                   INNER JOIN MovementItem AS MovementItem_Parent ON MovementItem_Parent.MovementId = Movement.Id AND MovementItem_Parent.DescId = zc_MI_Master() AND MovementItem_Parent.isErased = FALSE
                   LEFT JOIN MovementItem ON MovementItem.ParentId = MovementItem_Parent.Id AND MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Child() AND MovementItem.isErased = FALSE
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit_parent
                                                    ON MILinkObject_Unit_parent.MovementItemId = MovementItem_Parent.Id
                                                   AND MILinkObject_Unit_parent.DescId = zc_MILinkObject_Unit()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                    ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                   -- ������ � ��������
                   LEFT JOIN ObjectLink AS ObjectLink_Route_Branch
                                        ON ObjectLink_Route_Branch.ObjectId = MovementItem_Parent.ObjectId
                                       AND ObjectLink_Route_Branch.DescId = zc_ObjectLink_Route_Branch()
                   -- ������������� � ��������
                   LEFT JOIN ObjectLink AS ObjectLink_Route_Unit
                                        ON ObjectLink_Route_Unit.ObjectId = MovementItem_Parent.ObjectId
                                       AND ObjectLink_Route_Unit.DescId = zc_ObjectLink_Route_Unit()
                   -- ������ � ������������� �� ��������
                   LEFT JOIN ObjectLink AS ObjectLink_UnitRoute_Branch
                                        ON ObjectLink_UnitRoute_Branch.ObjectId = COALESCE (MILinkObject_Unit_parent.ObjectId, ObjectLink_Route_Unit.ChildObjectId)
                                       AND ObjectLink_UnitRoute_Branch.DescId = zc_ObjectLink_Unit_Branch()
                   -- ������ � ������������� �� ��������
                   LEFT JOIN ObjectLink AS ObjectLink_UnitRoute_Business
                                        ON ObjectLink_UnitRoute_Business.ObjectId = COALESCE (MILinkObject_Unit_parent.ObjectId, ObjectLink_Route_Unit.ChildObjectId)
                                       AND ObjectLink_UnitRoute_Business.DescId = zc_ObjectLink_Unit_Business()

                   -- ��� ������ - ������������� UnitId ����
                   LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId
                   =
                     CASE -- ���� �������-����.-������ = "�����", ����� ������� �� �������������� �������� � �������������, �.�. ��� ����(�+��), ���������, �����, ������.
                          WHEN ObjectLink_UnitRoute_Branch.ChildObjectId IS NULL
                               THEN COALESCE (MILinkObject_Unit_parent.ObjectId, ObjectLink_Route_Unit.ChildObjectId, 0)

                          -- ���� "�����������" �������, ����� ������� �� �������������� �������� � �������������, �.�. ��� ������� - ������������ ����� "���������� ��������"
                          WHEN ObjectLink_UnitRoute_Branch.ChildObjectId  = COALESCE (ObjectLink_Route_Branch.ChildObjectId, 0)
                               THEN COALESCE (MILinkObject_Unit_parent.ObjectId, ObjectLink_Route_Unit.ChildObjectId, 0)

                          -- ���� ������� "�� ������" � ��� ���� ������, ����� ������� ������ �� ������ - ������������ ����� "���������� ����������"
                          WHEN ObjectLink_UnitRoute_Branch.ChildObjectId  <> ObjectLink_Route_Branch.ChildObjectId AND ObjectLink_Route_Branch.ChildObjectId > 0
                               THEN COALESCE (MILinkObject_Unit_parent.ObjectId, ObjectLink_Route_Unit.ChildObjectId, 0)

                          -- ����� ������������� (����� ��������), �.�. ����� �� ������� �� ..... ?������� � ��� �� ������?
                          ELSE vbUnitId_Forwarding
                     END

                   -- ����� ����� ������ 20401; "���";
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_20401()

                   -- ���������������
                   LEFT JOIN ObjectLink AS ObjectLink_UnitRoute_Contract
                                        ON ObjectLink_UnitRoute_Contract.ObjectId = ObjectLink_Route_Unit.ChildObjectId
                                       AND ObjectLink_UnitRoute_Contract.DescId   = zc_ObjectLink_Unit_Contract()
                   LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_UnitRoute_Contract.ChildObjectId
                                                                        AND ObjectLink_Contract_Juridical.DescId   = zc_ObjectLink_Contract_Juridical()
                   LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind ON ObjectLink_Contract_PaidKind.ObjectId = ObjectLink_UnitRoute_Contract.ChildObjectId
                                                                       AND ObjectLink_Contract_PaidKind.DescId   = zc_ObjectLink_Contract_PaidKind()
                   /*LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = ObjectLink_UnitRoute_Contract.ChildObjectId
                                                                             AND ObjectLink_Contract_JuridicalBasis.DescId   = zc_ObjectLink_Contract_JuridicalBasis()*/

              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_Transport()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS _tmp
        ;


     -- ��������� ������� - �������� �� ���������� (��) + ������� "���������������" + "������������" + "�����", �� ����� ���������� ��� ������������ �������� � ���������, ����� �� !!!MovementItemId!!!
     INSERT INTO _tmpItem_SummPersonal (MovementItemId, OperSumm_Add, OperSumm_AddLong, OperSumm_Taxi
                                      , ContainerId, AccountId, InfoMoneyDestinationId, InfoMoneyId
                                      , PersonalId, BranchId, UnitId, PositionId, ServiceDateId, PersonalServiceListId
                                      , BusinessId_ProfitLoss, BranchId_ProfitLoss, UnitId_ProfitLoss
                                      , ContainerId_ProfitLoss, ContainerId_50000, AccountId_50000
                                       )
        SELECT _tmpItem.MovementItemId_parent            AS MovementItemId
             , CASE WHEN MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_Personal()
                         THEN COALESCE (MIFloat_RateSummaExp.ValueData, 0)
                    ELSE COALESCE (MIFloat_RateSumma.ValueData, 0)
               END AS OperSumm_Add

             , CASE WHEN MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_Personal()
                         THEN 0
                    ELSE COALESCE (MIFloat_RatePrice.ValueData, 0) * (COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_DistanceFuelChild.ValueData, 0))
                       + COALESCE (MIFloat_RateSummaAdd.ValueData, 0)
               END AS OperSumm_AddLong

             , CASE WHEN MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_Personal()
                         THEN 0
                    WHEN MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriverMore()
                         THEN COALESCE (MIFloat_TaxiMore.ValueData, 0)
                    ELSE COALESCE (MIFloat_Taxi.ValueData, 0)
               END AS OperSumm_Taxi

               -- ��� ���������� (��)
             , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                     , inParentId          := NULL
                                     , inObjectId          := lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_70000()          -- ���������
                                                                                         , inAccountDirectionId     := zc_Enum_AccountDirection_70500()      -- ��������� + ����������
                                                                                         , inInfoMoneyDestinationId := View_InfoMoney.InfoMoneyDestinationId
                                                                                         , inInfoMoneyId            := NULL
                                                                                         , inUserId                 := inUserId
                                                                                          )
                                     , inJuridicalId_basis := vbJuridicalId_Basis
                                     , inBusinessId        := NULL
                                     , inObjectCostDescId  := NULL
                                     , inObjectCostId      := NULL
                                     , inDescId_1          := zc_ContainerLinkObject_Personal()
                                     , inObjectId_1        := MovementLinkObject_PersonalDriver.ObjectId
                                     , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                     , inObjectId_2        := View_InfoMoney.InfoMoneyId
                                     , inDescId_3          := zc_ContainerLinkObject_Branch()
                                     , inObjectId_3        := COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())
                                     , inDescId_4          := zc_ContainerLinkObject_Unit()
                                     , inObjectId_4        := ObjectLink_Personal_Unit.ChildObjectId
                                     , inDescId_5          := zc_ContainerLinkObject_Position()
                                     , inObjectId_5        := ObjectLink_Personal_Position.ChildObjectId
                                     , inDescId_6          := zc_ContainerLinkObject_ServiceDate()
                                     , inObjectId_6        := lpInsertFind_Object_ServiceDate (inOperDate:= vbOperDate)
                                     , inDescId_7          := zc_ContainerLinkObject_PersonalServiceList()
                                     , inObjectId_7        := ObjectLink_Personal_PersonalServiceList.ChildObjectId
                                      ) AS ContainerId
               -- ��� ���������� (��)
             , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_70000()          -- ���������
                                          , inAccountDirectionId     := zc_Enum_AccountDirection_70500()      -- ��������� + ����������
                                          , inInfoMoneyDestinationId := View_InfoMoney.InfoMoneyDestinationId
                                          , inInfoMoneyId            := NULL
                                          , inUserId                 := inUserId
                                           ) AS AccountId

             , View_InfoMoney.InfoMoneyDestinationId
             , View_InfoMoney.InfoMoneyId
             , MovementLinkObject_PersonalDriver.ObjectId                         AS PersonalId
             , COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis()) AS BranchId
             , ObjectLink_Personal_Unit.ChildObjectId                             AS UnitId
             , ObjectLink_Personal_Position.ChildObjectId                         AS PositionId
             , lpInsertFind_Object_ServiceDate (inOperDate:= vbOperDate)          AS ServiceDateId
             , ObjectLink_Personal_PersonalServiceList.ChildObjectId              AS PersonalServiceListId

             , _tmpItem.BusinessId_Route    AS BusinessId_ProfitLoss -- !!!�.�. ������� �� ��������!!!
             , _tmpItem.BranchId_ProfitLoss AS BranchId_ProfitLoss   -- !!!�.�. ������� ����� �� ��������������� ���������� (��)!!!
             , _tmpItem.UnitId_ProfitLoss   AS UnitId_ProfitLoss     -- !!!�.�. ������� ����� �� ��������������� ���������� (��)!!!

             , CASE WHEN vbIsAccount_50000 = TRUE
                         THEN 0
                         ELSE
                             -- ��� ����
                             lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                   , inParentId          := NULL
                                                   , inObjectId          := zc_Enum_Account_100301()  -- ������� �������� �������
                                                   , inJuridicalId_basis := vbJuridicalId_Basis
                                                   , inBusinessId        := _tmpItem.BusinessId_Route -- !!!�.�. ������� �� ��������!!!
                                                   , inObjectCostDescId  := NULL
                                                   , inObjectCostId      := NULL
                                                   , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                                   , inObjectId_1        := lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem.ProfitLossGroupId
                                                                                                          , inProfitLossDirectionId  := _tmpItem.ProfitLossDirectionId
                                                                                                          , inInfoMoneyDestinationId := View_InfoMoney.InfoMoneyDestinationId -- ???���������� �����
                                                                                                          , inInfoMoneyId            := NULL
                                                                                                          , inUserId                 := inUserId
                                                                                                           )
                                                   , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                   , inObjectId_2        := _tmpItem.BranchId_ProfitLoss -- !!!�.�. ������� ����� �� ��������������� ���������� (��)!!!
                                                    )
               END AS ContainerId_ProfitLoss

             , CASE WHEN vbIsAccount_50000 = TRUE
                         THEN
                             -- ��� ������� ������� ��������
                             lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                   , inParentId          := NULL
                                                   , inObjectId          := lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_50000()     -- ������� ������� ��������
                                                                                                       , inAccountDirectionId     := zc_Enum_AccountDirection_50100() -- ����������
                                                                                                       , inInfoMoneyDestinationId := View_InfoMoney.InfoMoneyDestinationId
                                                                                                       , inInfoMoneyId            := NULL
                                                                                                       , inInsert                 := FALSE
                                                                                                       , inUserId                 := inUserId
                                                                                                        )
                                                   , inJuridicalId_basis := vbJuridicalId_Basis
                                                   , inBusinessId        := NULL
                                                   , inObjectCostDescId  := NULL
                                                   , inObjectCostId      := NULL
                                                   , inDescId_1          := zc_ContainerLinkObject_InfoMoney()
                                                   , inObjectId_1        := View_InfoMoney.InfoMoneyId
                                                   , inDescId_2          := zc_ContainerLinkObject_PartionMovement()
                                                   , inObjectId_2        := vbPartionMovementId
                                                    )
                         ELSE 0
               END AS ContainerId_50000

             , CASE WHEN vbIsAccount_50000 = TRUE
                         THEN lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_50000()     -- ������� ������� ��������
                                                         , inAccountDirectionId     := zc_Enum_AccountDirection_50100() -- ����������
                                                         , inInfoMoneyDestinationId := View_InfoMoney.InfoMoneyDestinationId
                                                         , inInfoMoneyId            := NULL
                                                         , inInsert                 := FALSE
                                                         , inUserId                 := inUserId
                                                          )
                         ELSE 0
               END AS AccountId_50000

        FROM (SELECT DISTINCT _tmpItem_Transport.MovementItemId_parent
                            , _tmpItem_Transport.BusinessId_Route
                            , _tmpItem_Transport.BranchId_ProfitLoss
                            , _tmpItem_Transport.UnitId_ProfitLoss
                            , _tmpItem_Transport.ProfitLossGroupId
                            , _tmpItem_Transport.ProfitLossDirectionId
              FROM _tmpItem_Transport
             ) AS _tmpItem
             LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver_check
                                          ON MovementLinkObject_PersonalDriver_check.MovementId = inMovementId
                                         AND MovementLinkObject_PersonalDriver_check.DescId     = zc_MovementLinkObject_PersonalDriver()
                                         AND MovementLinkObject_PersonalDriver_check.ObjectId   > 0
             LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                          ON MovementLinkObject_PersonalDriver.MovementId = inMovementId
                                         AND MovementLinkObject_PersonalDriver.DescId     IN (zc_MovementLinkObject_PersonalDriver()
                                                                                            , zc_MovementLinkObject_PersonalDriverMore()
                                                                                            , zc_MovementLinkObject_Personal()
                                                                                             )
                                         AND MovementLinkObject_PersonalDriver.ObjectId   > 0
                                         AND (MovementLinkObject_PersonalDriver.ObjectId   <> COALESCE (MovementLinkObject_PersonalDriver_check.ObjectId ,0)
                                           OR MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
                                             )
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_60101() -- ���������� �����

             LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                  ON ObjectLink_Personal_Unit.ObjectId = MovementLinkObject_PersonalDriver.ObjectId
                                 AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
             LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                  ON ObjectLink_Personal_Position.ObjectId = MovementLinkObject_PersonalDriver.ObjectId
                                 AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
             LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                  ON ObjectLink_Personal_PersonalServiceList.ObjectId = MovementLinkObject_PersonalDriver.ObjectId
                                 AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                  ON ObjectLink_Unit_Branch.ObjectId = ObjectLink_Personal_Unit.ChildObjectId
                                 AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()

             LEFT JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.Id         = _tmpItem.MovementItemId_parent

             LEFT JOIN MovementItemFloat AS MIFloat_DistanceFuelChild
                                         ON MIFloat_DistanceFuelChild.MovementItemId = _tmpItem.MovementItemId_parent
                                        AND MIFloat_DistanceFuelChild.DescId         = zc_MIFloat_DistanceFuelChild()
             LEFT JOIN MovementItemFloat AS MIFloat_RateSumma
                                         ON MIFloat_RateSumma.MovementItemId = _tmpItem.MovementItemId_parent
                                        AND MIFloat_RateSumma.DescId = zc_MIFloat_RateSumma()
             LEFT JOIN MovementItemFloat AS MIFloat_RatePrice
                                         ON MIFloat_RatePrice.MovementItemId = _tmpItem.MovementItemId_parent
                                        AND MIFloat_RatePrice.DescId = zc_MIFloat_RatePrice()
             LEFT JOIN MovementItemFloat AS MIFloat_RateSummaAdd
                                         ON MIFloat_RateSummaAdd.MovementItemId = _tmpItem.MovementItemId_parent
                                        AND MIFloat_RateSummaAdd.DescId = zc_MIFloat_RateSummaAdd()
             LEFT JOIN MovementItemFloat AS MIFloat_Taxi
                                         ON MIFloat_Taxi.MovementItemId = _tmpItem.MovementItemId_parent
                                        AND MIFloat_Taxi.DescId = zc_MIFloat_Taxi()
             LEFT JOIN MovementItemFloat AS MIFloat_TaxiMore
                                         ON MIFloat_TaxiMore.MovementItemId = _tmpItem.MovementItemId_parent
                                        AND MIFloat_TaxiMore.DescId = zc_MIFloat_TaxiMore()
             LEFT JOIN MovementItemFloat AS MIFloat_RateSummaExp
                                         ON MIFloat_RateSummaExp.MovementItemId = _tmpItem.MovementItemId_parent
                                        AND MIFloat_RateSummaExp.DescId         = zc_MIFloat_RateSummaExp()

        WHERE MIFloat_RatePrice.ValueData <> 0
           OR MIFloat_RateSummaAdd.ValueData <> 0
           OR CASE WHEN MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriverMore() THEN COALESCE (MIFloat_TaxiMore.ValueData, 0)     ELSE COALESCE (MIFloat_Taxi.ValueData, 0)      END <> 0
           OR CASE WHEN MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_Personal()           THEN COALESCE (MIFloat_RateSummaExp.ValueData, 0) ELSE COALESCE (MIFloat_RateSumma.ValueData, 0) END <> 0
       ;


     -- !!!����������� ����������� �������� � ���������� ��������� ���������!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_StartAmountFuel(), tmp.MovementItemId, tmp.StartAmountFuel)
     FROM (WITH tmpItem_Transport_all AS (SELECT * FROM MovementItem WHERE MovementId = inMovementId AND DescId = zc_MI_Master() AND isErased = FALSE)
              , tmpItem_Transport AS (SELECT MIN (tmpItem_Transport_all.Id) AS MovementItemId_parent FROM tmpItem_Transport_all)
           --
           SELECT _tmpItem_Transport.MovementItemId, COALESCE (_tmpPropertyRemains.Amount, 0) AS StartAmountFuel
           FROM (SELECT (MovementItemId) AS MovementItemId, GoodsId FROM _tmpItem_Transport WHERE _tmpItem_Transport.MovementItemId > 0
                ) AS _tmpItem_Transport
                LEFT JOIN (SELECT MAX (MovementItemId) AS MovementItemId, GoodsId FROM _tmpItem_Transport GROUP BY GoodsId
                          ) AS _tmpItem_Transport_max ON _tmpItem_Transport_max.GoodsId = _tmpItem_Transport.GoodsId
                LEFT JOIN _tmpPropertyRemains ON _tmpPropertyRemains.FuelId = _tmpItem_Transport.GoodsId
                                             AND _tmpPropertyRemains.Kind = 3
                                             AND _tmpItem_Transport_max.MovementItemId = _tmpItem_Transport.MovementItemId
          UNION ALL
           -- ��������� ������������ ��������, ���� � ��������� �� ���, � ������� �� ������� ����
           SELECT (SELECT ioId FROM lpInsertUpdate_MI_Transport_Child (ioId                 := 0
                                                                     , inMovementId         := inMovementId
                                                                     , inParentId           := tmpItem_Transport.MovementItemId_parent
                                                                     , inFuelId             := tmp.FuelId
                                                                     , inIsCalculated       := TRUE
                                                                     , inIsMasterFuel       := FALSE
                                                                     , ioAmount             := 0
                                                                     , inColdHour           := 0
                                                                     , inColdDistance       := 0
                                                                     , inAmountFuel         := 0
                                                                     , inAmountColdHour     := 0
                                                                     , inAmountColdDistance := 0
                                                                     , inNumber             := 4
                                                                     , inRateFuelKindTax    := 0
                                                                     , inRateFuelKindId     := 0
                                                                     , inUserId             := inUserId
                                                                      )
                 ) AS MovementItemId
               , tmp.StartAmountFuel
           FROM (SELECT _tmpPropertyRemains.FuelId, _tmpPropertyRemains.Amount AS StartAmountFuel
                 FROM _tmpPropertyRemains
                      LEFT JOIN (SELECT MAX (MovementItemId) AS MovementItemId, GoodsId FROM _tmpItem_Transport WHERE _tmpItem_Transport.MovementItemId > 0 GROUP BY GoodsId
                                ) AS _tmpItem_Transport ON _tmpItem_Transport.GoodsId = _tmpPropertyRemains.FuelId
                 WHERE _tmpPropertyRemains.Kind = 3
                   AND _tmpItem_Transport.GoodsId IS NULL
                ) AS tmp
                JOIN tmpItem_Transport ON 1=1
          ) AS tmp;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- 1.1.1. ������������ ContainerId_Goods ��� ��������������� �����
     UPDATE _tmpItem_Transport SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                          , inUnitId                 := NULL
                                                                                          , inCarId                  := vbCarId
                                                                                          , inMemberId               := NULL
                                                                                          , inInfoMoneyDestinationId := _tmpItem_Transport.InfoMoneyDestinationId
                                                                                          , inGoodsId                := _tmpItem_Transport.GoodsId
                                                                                          , inGoodsKindId            := 0
                                                                                          , inIsPartionCount         := FALSE
                                                                                          , inPartionGoodsId         := 0
                                                                                          , inAssetId                := _tmpItem_Transport.AssetId
                                                                                          , inBranchId               := 0
                                                                                          , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                           )
     WHERE _tmpItem_Transport.MovementItemId > 0;

     -- 1.2.1. ����� ����������: ��������� ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ��������� !!!(����� ����)!!!
     INSERT INTO _tmpItem_TransportSumm_Transport (MovementItemId, ContainerId_ProfitLoss, ContainerId_50000, ContainerId, AccountId, AccountId_50000, ContainerId_jur, AccountId_jur, OperSumm)
        SELECT
              _tmpItem_Transport.MovementItemId
            , 0                       AS ContainerId_ProfitLoss
            , 0                       AS ContainerId_50000
            , Container_Summ.Id       AS ContainerId
            , Container_Summ.ObjectId AS AccountId
            , 0                       AS AccountId_50000
            , 0                       AS ContainerId_jur
            , 0                       AS AccountId_jur
            , SUM (_tmpItem_Transport.OperCount * COALESCE (HistoryCost.Price, 0)) AS OperSumm -- ����� ABS
        FROM _tmpItem_Transport
             -- ��� ������� ��� ���������
             JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem_Transport.ContainerId_Goods
                                             AND Container_Summ.DescId = zc_Container_Summ()
             /*JOIN ContainerObjectCost AS ContainerObjectCost_Basis
                                      ON ContainerObjectCost_Basis.ContainerId = Container_Summ.Id
                                     AND ContainerObjectCost_Basis.ObjectCostDescId = zc_ObjectCost_Basis()*/
             LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id -- HistoryCost.ObjectCostId = ContainerObjectCost_Basis.ObjectCostId
                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
        WHERE zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
          AND _tmpItem_Transport.OperCount * COALESCE (HistoryCost.Price, 0) <> 0 -- ����� ���� !!!�� �����!!!
          AND InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20500() -- 20500; "��������� ����"
        GROUP BY _tmpItem_Transport.MovementItemId
               , Container_Summ.Id
               , Container_Summ.ObjectId;

     -- 1.2.2. ��������� - AccountId_50000 - ������� ������� ��������
     UPDATE _tmpItem_TransportSumm_Transport SET AccountId_50000 = lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_50000()     -- ������� ������� ��������
                                                                                              , inAccountDirectionId     := zc_Enum_AccountDirection_50200() -- ���
                                                                                              , inInfoMoneyDestinationId := _tmpItem_Transport.InfoMoneyDestinationId
                                                                                              , inInfoMoneyId            := NULL
                                                                                              , inInsert                 := FALSE
                                                                                              , inUserId                 := inUserId
                                                                                               )
     FROM _tmpItem_Transport
     WHERE _tmpItem_Transport.MovementItemId = _tmpItem_TransportSumm_Transport.MovementItemId
       AND vbIsAccount_50000 = TRUE
       -- !!!���� �� ���������������!!!
       AND COALESCE (_tmpItem_Transport.ContractId, 0) = 0
      ;

     -- 1.2.3. ��������� - AccountId_jur - !!!���� ���������������!!!
     UPDATE _tmpItem_TransportSumm_Transport SET AccountId_jur = CASE (SELECT ObjectLink.ChildObjectId AS InfoMoneyId
                                                                       FROM ObjectLink
                                                                       WHERE ObjectLink.ObjectId = _tmpItem_Transport.JuridicalId
                                                                         AND ObjectLink.DescId   = zc_ObjectLink_Juridical_InfoMoney()
                                                                      )
                                                                      WHEN zc_Enum_InfoMoney_20801()
                                                                           THEN zc_Enum_Account_30201() -- ����
                                                                      WHEN zc_Enum_InfoMoney_20901()
                                                                           THEN zc_Enum_Account_30202() -- ����
                                                                      WHEN zc_Enum_InfoMoney_21001()
                                                                           THEN zc_Enum_Account_30203() -- �����
                                                                      WHEN zc_Enum_InfoMoney_21101()
                                                                           THEN zc_Enum_Account_30204() -- �������
                                                                      WHEN zc_Enum_InfoMoney_21151()
                                                                           THEN zc_Enum_Account_30205() -- �������-���������
                                                                      -- !!!
                                                                      ELSE zc_Enum_Account_30205() -- �������-���������
                                                                 END
     FROM _tmpItem_Transport
     WHERE _tmpItem_Transport.MovementItemId = _tmpItem_TransportSumm_Transport.MovementItemId
       AND _tmpItem_Transport.ContractId > 0
      ;

                                                                            


     -- 2.1. ������������ ContainerId_ProfitLoss OR ContainerId_50000 ��� �������� ��������� �����
     UPDATE _tmpItem_TransportSumm_Transport SET ContainerId_ProfitLoss = _tmpItem_Transport_byContainer.ContainerId_ProfitLoss
                                               , ContainerId_50000      = _tmpItem_Transport_byContainer.ContainerId_50000
                                               , ContainerId_jur        = _tmpItem_Transport_byContainer.ContainerId_jur
     FROM _tmpItem_Transport
          JOIN
          (SELECT CASE WHEN _tmpItem_Transport_byProfitLoss.ContractId > 0
                         THEN 0
                       WHEN vbIsAccount_50000 = TRUE
                         THEN 0
                         ELSE
                             -- �� ����� �������
                             lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                   , inParentId          := NULL
                                                   , inObjectId          := zc_Enum_Account_100301 () -- 100301; "������� �������� �������"
                                                   , inJuridicalId_basis := vbJuridicalId_Basis
                                                   , inBusinessId        := _tmpItem_Transport_byProfitLoss.BusinessId_Route -- !!!����������� ������ ��� �������!!!
                                                   , inObjectCostDescId  := NULL
                                                   , inObjectCostId      := NULL
                                                   , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                                   , inObjectId_1        := _tmpItem_Transport_byProfitLoss.ProfitLossId
                                                   , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                   , inObjectId_2        := _tmpItem_Transport_byProfitLoss.BranchId_ProfitLoss -- !!!����������� ������ ��� �������!!!
                                                    )
                  END AS ContainerId_ProfitLoss
                , CASE WHEN _tmpItem_Transport_byProfitLoss.ContractId > 0
                         THEN 0
                       WHEN vbIsAccount_50000 = TRUE
                         THEN
                             -- �� ����� ������� ������� ��������
                             lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                   , inParentId          := NULL
                                                   , inObjectId          := _tmpItem_Transport_byProfitLoss.AccountId_50000
                                                   , inJuridicalId_basis := vbJuridicalId_Basis
                                                   , inBusinessId        := NULL
                                                   , inObjectCostDescId  := NULL
                                                   , inObjectCostId      := NULL
                                                   , inDescId_1          := zc_ContainerLinkObject_InfoMoney()
                                                   , inObjectId_1        := zc_Enum_InfoMoney_20401() -- ����� ����� ������ 20401; "���";
                                                   , inDescId_2          := zc_ContainerLinkObject_PartionMovement()
                                                   , inObjectId_2        := vbPartionMovementId
                                                    )
                         ELSE 0
                  END AS ContainerId_50000

                , CASE WHEN _tmpItem_Transport_byProfitLoss.ContractId > 0
                         THEN
                             -- !!!���� ���������������!!!
                             lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                   , inParentId          := NULL
                                                   , inObjectId          := _tmpItem_Transport_byProfitLoss.AccountId_jur
                                                   , inJuridicalId_basis := vbJuridicalId_Basis
                                                   , inBusinessId        := NULL
                                                   , inObjectCostDescId  := NULL
                                                   , inObjectCostId      := NULL
                                                   , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                   , inObjectId_1        := _tmpItem_Transport_byProfitLoss.JuridicalId

                                                   , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                   , inObjectId_2        := _tmpItem_Transport_byProfitLoss.ContractId
                                                   , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                   , inObjectId_3        := zc_Enum_InfoMoney_20401() -- ����� ����� ������ 20401; "���";
                                                   , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                   , inObjectId_4        := _tmpItem_Transport_byProfitLoss.PaidKindId
                                                   , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                   , inObjectId_5        := 0
                                                    )
                         ELSE 0
                  END AS ContainerId_jur

                , _tmpItem_Transport_byProfitLoss.ProfitLossDirectionId
                , _tmpItem_Transport_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_Transport_byProfitLoss.BusinessId_Route
                , _tmpItem_Transport_byProfitLoss.BranchId_ProfitLoss
                , _tmpItem_Transport_byProfitLoss.ContractId

           FROM (SELECT CASE WHEN _tmpItem_Transport_group.ContractId > 0 THEN 0
                             WHEN vbIsAccount_50000 = TRUE THEN 0
                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_Transport_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_Transport_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_Transport_group.InfoMoneyDestinationId
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId
                      , _tmpItem_Transport_group.ProfitLossDirectionId
                      , _tmpItem_Transport_group.InfoMoneyDestinationId
                      , _tmpItem_Transport_group.BusinessId_Route
                      , _tmpItem_Transport_group.BranchId_ProfitLoss
                      , _tmpItem_Transport_group.AccountId_50000

                      , _tmpItem_Transport_group.JuridicalId
                      , _tmpItem_Transport_group.ContractId
                      , _tmpItem_Transport_group.PaidKindId
                      , _tmpItem_Transport_group.AccountId_jur

                 FROM (SELECT DISTINCT
                              _tmpItem_Transport.ProfitLossGroupId
                            , _tmpItem_Transport.ProfitLossDirectionId
                            , _tmpItem_Transport.InfoMoneyDestinationId
                            , _tmpItem_Transport.BusinessId_Route
                            , _tmpItem_Transport.BranchId_ProfitLoss
                            , _tmpItem_TransportSumm_Transport.AccountId_50000

                            , _tmpItem_Transport.JuridicalId
                            , _tmpItem_Transport.ContractId
                            , _tmpItem_Transport.PaidKindId
                            , _tmpItem_TransportSumm_Transport.AccountId_jur

                       FROM _tmpItem_TransportSumm_Transport
                            JOIN _tmpItem_Transport ON _tmpItem_Transport.MovementItemId = _tmpItem_TransportSumm_Transport.MovementItemId
                      ) AS _tmpItem_Transport_group
                ) AS _tmpItem_Transport_byProfitLoss
          ) AS _tmpItem_Transport_byContainer ON _tmpItem_Transport_byContainer.ProfitLossDirectionId  = _tmpItem_Transport.ProfitLossDirectionId
                                             AND _tmpItem_Transport_byContainer.InfoMoneyDestinationId = _tmpItem_Transport.InfoMoneyDestinationId
                                             AND _tmpItem_Transport_byContainer.BusinessId_Route       = _tmpItem_Transport.BusinessId_Route
                                             AND _tmpItem_Transport_byContainer.BranchId_ProfitLoss    = _tmpItem_Transport.BranchId_ProfitLoss
                                             AND _tmpItem_Transport_byContainer.ContractId             = _tmpItem_Transport.ContractId
     WHERE _tmpItem_TransportSumm_Transport.MovementItemId = _tmpItem_Transport.MovementItemId;

     -- 2.2. ����������� ��������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ContainerIntId_analyzer, AccountId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive
                                        )
       WITH -- ����� ������
            tmpProfitLoss AS (SELECT _tmpItem_TransportSumm_Transport.MovementItemId
                                    , _tmpItem_TransportSumm_Transport.ContainerId_ProfitLoss
                                    , SUM (_tmpItem_TransportSumm_Transport.OperSumm) AS OperSumm
                               FROM _tmpItem_TransportSumm_Transport
                               GROUP BY _tmpItem_TransportSumm_Transport.MovementItemId, _tmpItem_TransportSumm_Transport.ContainerId_ProfitLoss
                              )
            -- ����� ���
          , tmpMI_Sale_total AS (SELECT SUM (_tmpMI_Sale.AmountWeight) AS AmountWeight FROM _tmpMI_Sale)
            -- ������������
          , tmpProfitLoss_goods AS (SELECT tmpProfitLoss.MovementItemId
                                         , tmpProfitLoss.ContainerId_ProfitLoss
                                         , _tmpMI_Sale.MI_Id_sale
                                         , _tmpMI_Sale.PartnerId
                                         , _tmpMI_Sale.GoodsId
                                         , _tmpMI_Sale.GoodsKindId
                                         , CAST (tmpProfitLoss.OperSumm * _tmpMI_Sale.AmountWeight / tmpMI_Sale_total.AmountWeight AS NUMERIC (16, 4)) AS OperSumm
                                           -- � �/�
                                         , ROW_NUMBER() OVER (PARTITION BY tmpProfitLoss.MovementItemId, tmpProfitLoss.ContainerId_ProfitLoss ORDER BY _tmpMI_Sale.AmountWeight DESC) AS Ord
                                    FROM tmpProfitLoss
                                         JOIN tmpMI_Sale_total ON tmpMI_Sale_total.AmountWeight > 0
                                         CROSS JOIN _tmpMI_Sale
                                    WHERE vbIsAccount_50000 = FALSE
                                   )
            -- ����� ������������
          , tmpProfitLoss_goods_sum AS (SELECT tmpProfitLoss_goods.MovementItemId
                                             , tmpProfitLoss_goods.ContainerId_ProfitLoss
                                             , SUM (tmpProfitLoss_goods.OperSumm) AS OperSumm
                                        FROM tmpProfitLoss_goods
                                        GROUP BY tmpProfitLoss_goods.MovementItemId
                                               , tmpProfitLoss_goods.ContainerId_ProfitLoss
                                       )
       -- �������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, tmpProfitLoss.MovementItemId
            , tmpProfitLoss.ContainerId_ProfitLoss
            , zc_Enum_Account_100301()                      AS AccountId              -- ������� �������� �������
            , 0                                             AS AnalyzerId             -- � ���� ��� ������� �� ������ ���������, �.�. ����������� ������� �������� �� AnalyzerId <> 0
            , _tmpItem_Transport.GoodsId                    AS ObjectId_Analyzer      -- �����
            , vbCarId                                       AS WhereObjectId_Analyzer -- ����������
            , 0                                             AS ContainerId_Analyzer   -- � ���� �� �����
            , COALESCE (tmpProfitLoss_goods.MI_Id_sale, 0)  AS ContainerIntId_analyzer-- MI_Id_sale � ��������� ��� � ���� �� �����
            , 0                                             AS AccountId_Analyzer     -- � ���� �� �����
            , _tmpItem_Transport.UnitId_ProfitLoss          AS ObjectIntId_Analyzer   -- ������������ (����), � ����� ���� UnitId_Route
            , _tmpItem_Transport.BranchId_ProfitLoss        AS ObjectExtId_Analyzer   -- ������ (����), � ����� ���� BranchId_Route
            , 0                                             AS ParentId
            , COALESCE (tmpProfitLoss_goods.OperSumm, tmpProfitLoss.OperSumm)
                -- ������������ �� ������� ����������
              - CASE WHEN tmpProfitLoss_goods.Ord = 1 THEN tmpProfitLoss_goods_sum.OperSumm - tmpProfitLoss.OperSumm ELSE 0 END AS OperSumm
            , vbOperDate
            , FALSE                                         AS isActive               -- !!!���� ������ �� �������!!!
       FROM tmpProfitLoss
            JOIN _tmpItem_Transport ON _tmpItem_Transport.MovementItemId = tmpProfitLoss.MovementItemId
            -- ���������� + �����
            LEFT JOIN tmpProfitLoss_goods ON tmpProfitLoss_goods.MovementItemId         = tmpProfitLoss.MovementItemId
                                         AND tmpProfitLoss_goods.ContainerId_ProfitLoss = tmpProfitLoss.ContainerId_ProfitLoss
            -- ����� ������������
            LEFT JOIN tmpProfitLoss_goods_sum ON tmpProfitLoss_goods_sum.MovementItemId         = tmpProfitLoss_goods.MovementItemId
                                             AND tmpProfitLoss_goods_sum.ContainerId_ProfitLoss = tmpProfitLoss_goods.ContainerId_ProfitLoss
       WHERE vbIsAccount_50000 = FALSE
         -- !!!���� �� ���������������!!!
         AND COALESCE (_tmpItem_Transport.ContractId, 0) = 0

      UNION ALL
       -- ��� ������� ������� ��������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, tmpProfitLoss.MovementItemId
            , tmpProfitLoss.ContainerId_50000
            , tmpProfitLoss.AccountId_50000           AS AccountId              -- ������� �������� �������
            , 0                                       AS AnalyzerId             -- � ���� ��� ������� �� ������ ���������, �.�. ����������� ������� �������� �� AnalyzerId <> 0
            , vbPartionMovementId                     AS ObjectId_Analyzer      -- !!!PartionMovementId!!!
            , vbCarId                                 AS WhereObjectId_Analyzer -- ����������
            , tmpProfitLoss.ContainerId               AS ContainerId_Analyzer   -- !!!��������!!!
            , 0                                       AS ContainerIntId_analyzer-- ����� �� �����
            , tmpProfitLoss.AccountId                 AS AccountId_Analyzer     -- !!!��������!!!
         -- , _tmpItem_Transport.UnitId_ProfitLoss    AS ObjectIntId_Analyzer   -- ������������ (����), � ����� ���� UnitId_Route
            , _tmpItem_Transport.GoodsId              AS ObjectIntId_Analyzer   -- �����
         -- , _tmpItem_Transport.BranchId_ProfitLoss  AS ObjectExtId_Analyzer   -- ������ (����), � ����� ���� BranchId_Route
            , _tmpItem_Transport.UnitId_ProfitLoss    AS ObjectExtId_Analyzer   -- ������������ (����), � ����� ���� UnitId_Route
            , 0                                       AS ParentId
            , tmpProfitLoss.OperSumm
            , vbOperDate
            , TRUE                                    AS isActive               -- !!!������ � ������� ������� ��������!!!
       FROM (SELECT _tmpItem_TransportSumm_Transport.MovementItemId
                  , _tmpItem_TransportSumm_Transport.ContainerId_50000
                  , _tmpItem_TransportSumm_Transport.ContainerId
                  , _tmpItem_TransportSumm_Transport.AccountId_50000
                  , _tmpItem_TransportSumm_Transport.AccountId
                  , SUM (_tmpItem_TransportSumm_Transport.OperSumm) AS OperSumm
             FROM _tmpItem_TransportSumm_Transport
             GROUP BY _tmpItem_TransportSumm_Transport.MovementItemId, _tmpItem_TransportSumm_Transport.ContainerId_50000, _tmpItem_TransportSumm_Transport.ContainerId, _tmpItem_TransportSumm_Transport.AccountId_50000, _tmpItem_TransportSumm_Transport.AccountId
            ) AS tmpProfitLoss
            JOIN _tmpItem_Transport ON _tmpItem_Transport.MovementItemId = tmpProfitLoss.MovementItemId
       WHERE vbIsAccount_50000 = TRUE
         -- !!!���� �� ���������������!!!
         AND COALESCE (_tmpItem_Transport.ContractId, 0) = 0

      UNION ALL
       -- ��� ���������������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, tmpProfitLoss.MovementItemId
            , tmpProfitLoss.ContainerId_jur
            , tmpProfitLoss.AccountId_jur             AS AccountId              -- ������� �������� �������
            , 0                                       AS AnalyzerId             -- � ���� ��� ������� �� ������ ���������, �.�. ����������� ������� �������� �� AnalyzerId <> 0
            , 0                                       AS ObjectId_Analyzer      -- !!!PartionMovementId!!!
            , vbCarId                                 AS WhereObjectId_Analyzer -- ����������
            , tmpProfitLoss.ContainerId               AS ContainerId_Analyzer   -- !!!��������!!!
            , 0                                       AS ContainerIntId_analyzer-- ����� �� �����
            , tmpProfitLoss.AccountId                 AS AccountId_Analyzer     -- !!!��������!!!
            , _tmpItem_Transport.GoodsId              AS ObjectIntId_Analyzer   -- �����
            , _tmpItem_Transport.UnitId_Route         AS ObjectExtId_Analyzer   -- UnitId_Route
            , 0                                       AS ParentId
            , tmpProfitLoss.OperSumm
            , vbOperDate
            , TRUE                                    AS isActive               -- !!!������!!!
       FROM (SELECT _tmpItem_TransportSumm_Transport.MovementItemId
                  , _tmpItem_TransportSumm_Transport.ContainerId_jur
                  , _tmpItem_TransportSumm_Transport.ContainerId
                  , _tmpItem_TransportSumm_Transport.AccountId_jur
                  , _tmpItem_TransportSumm_Transport.AccountId
                  , SUM (_tmpItem_TransportSumm_Transport.OperSumm) AS OperSumm
             FROM _tmpItem_TransportSumm_Transport
             GROUP BY _tmpItem_TransportSumm_Transport.MovementItemId
                    , _tmpItem_TransportSumm_Transport.ContainerId_jur, _tmpItem_TransportSumm_Transport.ContainerId
                    , _tmpItem_TransportSumm_Transport.AccountId_jur, _tmpItem_TransportSumm_Transport.AccountId
            ) AS tmpProfitLoss
            JOIN _tmpItem_Transport ON _tmpItem_Transport.MovementItemId = tmpProfitLoss.MovementItemId

       -- !!!���� ���������������!!!
       WHERE _tmpItem_Transport.ContractId > 0
       ;


     -- 1.1.2. ����������� �������� ��� ��������������� �����, !!!����� �������, �.�. ����� ContainerId_ProfitLoss!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, AccountId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive
                                        )
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, _tmpItem_Transport.MovementItemId
            , _tmpItem_Transport.ContainerId_Goods
            , 0                                       AS AccountId              -- ��� �����
            , zc_Enum_AnalyzerId_ProfitLoss()         AS AnalyzerId             -- ���� ���������, �.�. �� ��� ��������� � ����
            , _tmpItem_Transport.GoodsId              AS ObjectId_Analyzer      -- �����
            , vbCarId                                 AS WhereObjectId_Analyzer -- ����������
              -- ������ ���� ��� ������� ������� ��������
            , CASE WHEN _tmpItem_Transport.ContractId > 0 THEN tmpProfitLoss.ContainerId_jur WHEN vbIsAccount_50000 = TRUE THEN tmpProfitLoss.ContainerId_50000 ELSE tmpProfitLoss.ContainerId_ProfitLoss END AS ContainerId_Analyzer
              -- ���� - ���� (�������������) - ������� �������� �������
            , CASE WHEN _tmpItem_Transport.ContractId > 0 THEN tmpProfitLoss.AccountId_jur   WHEN vbIsAccount_50000 = TRUE THEN tmpProfitLoss.AccountId_50000   ELSE zc_Enum_Account_100301()             END AS AccountId_Analyzer
            , _tmpItem_Transport.UnitId_ProfitLoss    AS ObjectIntId_Analyzer   -- ������������ (����), � ����� ���� UnitId_Route
            , _tmpItem_Transport.BranchId_ProfitLoss  AS ObjectExtId_Analyzer   -- ������ (����), � ����� ���� BranchId_Route
            , 0                                       AS ParentId
            , -1 * OperCount
            , vbOperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_Transport
           LEFT JOIN (SELECT DISTINCT _tmpItem_TransportSumm_Transport.MovementItemId
                                    , _tmpItem_TransportSumm_Transport.ContainerId_ProfitLoss
                                    , _tmpItem_TransportSumm_Transport.ContainerId_50000
                                    , _tmpItem_TransportSumm_Transport.AccountId_50000
                                    , _tmpItem_TransportSumm_Transport.ContainerId_jur
                                    , _tmpItem_TransportSumm_Transport.AccountId_jur
                      FROM _tmpItem_TransportSumm_Transport
                     ) AS tmpProfitLoss ON tmpProfitLoss.MovementItemId = _tmpItem_Transport.MovementItemId
       WHERE _tmpItem_Transport.MovementItemId > 0
      ;

     -- 1.2.2. ����������� �������� ��� ��������� ����� !!!����� �������, �.�. ����� ContainerId_ProfitLoss!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, AccountId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive
                                        )
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_Summ.MovementItemId
            , _tmpItem_Summ.ContainerId
            , _tmpItem_Summ.AccountId                 AS AccountId              -- ���� ���� ������
            , zc_Enum_AnalyzerId_ProfitLoss()         AS AnalyzerId             -- ���� ���������, �.�. �� ��� ��������� � ����
            , _tmpItem_Transport.GoodsId              AS ObjectId_Analyzer      -- �����
            , vbCarId                                 AS WhereObjectId_Analyzer -- ����������
              -- ������ ���� ��� ������� ������� ��������
            , CASE WHEN vbIsAccount_50000 = TRUE THEN _tmpItem_Summ.ContainerId_50000 ELSE _tmpItem_Summ.ContainerId_ProfitLoss END AS ContainerId_Analyzer
              -- ���� - ���� (�������������) - ������� �������� �������
            , CASE WHEN vbIsAccount_50000 = TRUE THEN _tmpItem_Summ.AccountId_50000   ELSE zc_Enum_Account_100301()             END AS AccountId_Analyzer
            , _tmpItem_Transport.UnitId_ProfitLoss    AS ObjectIntId_Analyzer   -- ������������ (����), � ����� ���� UnitId_Route
            , _tmpItem_Transport.BranchId_ProfitLoss  AS ObjectExtId_Analyzer   -- ������ (����), � ����� ���� BranchId_Route
            , 0                                       AS ParentId
            , -1 * _tmpItem_Summ.OperSumm
            , vbOperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_TransportSumm_Transport AS _tmpItem_Summ
            JOIN _tmpItem_Transport ON _tmpItem_Transport.MovementItemId = _tmpItem_Summ.MovementItemId
       ;

     -- 2.4. ����������� �������� - ���� ���������� (��) AND ���� + !!!�������� MovementItemId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, AccountId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       WITH -- �����
            tmpItem AS (SELECT _tmpItem_SummPersonal.MovementItemId
                             , _tmpItem_SummPersonal.ContainerId
                             , zc_Enum_AnalyzerId_Transport_Add()     AS AnalyzerId -- ����� ���������������
                             , _tmpItem_SummPersonal.OperSumm_Add     AS OperSumm
                        FROM _tmpItem_SummPersonal
                        WHERE _tmpItem_SummPersonal.OperSumm_Add <> 0 -- !!!���� ������������!!!
                       UNION ALL
                        SELECT _tmpItem_SummPersonal.MovementItemId
                             , _tmpItem_SummPersonal.ContainerId
                             , zc_Enum_AnalyzerId_Transport_AddLong() AS AnalyzerId -- ����� ������������ (���� ���������������)
                             , _tmpItem_SummPersonal.OperSumm_AddLong AS OperSumm
                        FROM _tmpItem_SummPersonal
                        WHERE _tmpItem_SummPersonal.OperSumm_AddLong <> 0 -- !!!���� ������������!!!
                       UNION ALL
                        SELECT _tmpItem_SummPersonal.MovementItemId
                             , _tmpItem_SummPersonal.ContainerId
                             , zc_Enum_AnalyzerId_Transport_Taxi()    AS AnalyzerId -- ����� �� �����
                             , _tmpItem_SummPersonal.OperSumm_Taxi    AS OperSumm
                        FROM _tmpItem_SummPersonal
                        WHERE _tmpItem_SummPersonal.OperSumm_Taxi <> 0 -- !!!���� ������������!!!
                       )
            -- ����� ���
          , tmpMI_Sale_total AS (SELECT SUM (_tmpMI_Sale.AmountWeight) AS AmountWeight FROM _tmpMI_Sale)
            -- ������������
          , tmpItem_goods AS (SELECT tmpItem.MovementItemId
                                   , tmpItem.ContainerId
                                   , tmpItem.AnalyzerId
                                   , _tmpMI_Sale.MI_Id_sale
                                   , _tmpMI_Sale.PartnerId
                                   , _tmpMI_Sale.GoodsId
                                   , _tmpMI_Sale.GoodsKindId
                                   , CAST (tmpItem.OperSumm * _tmpMI_Sale.AmountWeight / tmpMI_Sale_total.AmountWeight AS NUMERIC (16, 4)) AS OperSumm
                                     -- � �/�
                                   , ROW_NUMBER() OVER (PARTITION BY tmpItem.MovementItemId, tmpItem.ContainerId, tmpItem.AnalyzerId ORDER BY _tmpMI_Sale.AmountWeight DESC) AS Ord
                              FROM tmpItem
                                   JOIN tmpMI_Sale_total ON tmpMI_Sale_total.AmountWeight > 0
                                   CROSS JOIN _tmpMI_Sale
                              WHERE vbIsAccount_50000 = FALSE
                             )
            -- ����� ������������
          , tmpItem_goods_sum AS (SELECT tmpItem_goods.MovementItemId
                                       , tmpItem_goods.ContainerId
                                       , tmpItem_goods.AnalyzerId
                                       , SUM (tmpItem_goods.OperSumm) AS OperSumm
                                  FROM tmpItem_goods
                                  GROUP BY tmpItem_goods.MovementItemId
                                       , tmpItem_goods.ContainerId
                                       , tmpItem_goods.AnalyzerId
                                 )
       -- ���� ���������� (��)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_SummPersonal.MovementItemId
            , _tmpItem_SummPersonal.ContainerId
            , _tmpItem_SummPersonal.AccountId         AS AccountId                -- ���� ���� ������
            , _tmpItem.AnalyzerId                     AS AnalyzerId               -- ���� ���������, �.�. ������� ...
            , _tmpItem_SummPersonal.PersonalId        AS ObjectId_Analyzer        -- ��������� (��)
            , vbCarId                                 AS WhereObjectId_Analyzer   -- ����������, � ���� ���.���� (��) - vbMemberDriverId
              -- ��������� - ���� (�������������)
            , CASE WHEN vbIsAccount_50000 = TRUE THEN _tmpItem_SummPersonal.ContainerId_50000 ELSE _tmpItem_SummPersonal.ContainerId_ProfitLoss END AS ContainerId_Analyzer
              -- ���� - ���� (�������������) - ������� �������� �������
            , CASE WHEN vbIsAccount_50000 = TRUE THEN _tmpItem_SummPersonal.AccountId_50000   ELSE zc_Enum_Account_100301()                     END AS AccountId_Analyzer
            , _tmpItem_SummPersonal.UnitId            AS ObjectIntId_Analyzer     -- !!!������� ������������� (��)!!!
            , _tmpItem_SummPersonal.BranchId          AS ObjectExtId_Analyzer     -- ������ (��)
            , 0                                       AS ContainerIntId_Analyzer  -- ����� �� �����
            , 0                                       AS ParentId
            , -1 * (_tmpItem.OperSumm)
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM tmpItem AS _tmpItem
            INNER JOIN _tmpItem_SummPersonal ON _tmpItem_SummPersonal.MovementItemId = _tmpItem.MovementItemId
                                            AND _tmpItem_SummPersonal.ContainerId    = _tmpItem.ContainerId
      UNION ALL
       -- �������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_SummPersonal.MovementItemId
            , _tmpItem_SummPersonal.ContainerId_ProfitLoss
            , zc_Enum_Account_100301()                             AS AccountId                -- ������� �������� �������
            , _tmpItem.AnalyzerId                                  AS AnalyzerId               -- ���� ���������, �.�. ������� ... !!!���� � ������ ��������� ���� ����� �� ��������!!!
            , _tmpItem_SummPersonal.PersonalId                     AS ObjectId_Analyzer        -- ��������� (��)
            , vbCarId                                              AS WhereObjectId_Analyzer   -- ����������, � ���� ���.���� (��) - vbMemberDriverId
            , _tmpItem_SummPersonal.ContainerId                    AS ContainerId_Analyzer     -- ��������� - �������������
            , _tmpItem_SummPersonal.AccountId                      AS AccountId_Analyzer       -- ���� - �������������
            , _tmpItem_SummPersonal.UnitId_ProfitLoss              AS ObjectIntId_Analyzer     -- ������������� (����)
            , _tmpItem_SummPersonal.BranchId_ProfitLoss            AS ObjectExtId_Analyzer     -- ������ (����), � ����� ���� � ����� BusinessId_ProfitLoss
            , COALESCE (tmpItem_goods.MI_Id_sale, 0)               AS ContainerIntId_Analyzer  -- MI_Id_sale � ��������� ��� ����� �� �����
            , 0                                                    AS ParentId
            , 1 * COALESCE (tmpItem_goods.OperSumm, _tmpItem.OperSumm)
                -- ������������ �� ������� ����������
              - CASE WHEN tmpItem_goods.Ord = 1 THEN tmpItem_goods_sum.OperSumm - _tmpItem.OperSumm ELSE 0 END AS OperSumm
              --
            , vbOperDate                                                          AS OperDate
            , FALSE                                                               AS isActive               -- !!!���� ������ �� �������!!!
       FROM tmpItem AS _tmpItem
            INNER JOIN _tmpItem_SummPersonal ON _tmpItem_SummPersonal.MovementItemId = _tmpItem.MovementItemId
                                            AND _tmpItem_SummPersonal.ContainerId    = _tmpItem.ContainerId
            -- ���������� + �����
            LEFT JOIN tmpItem_goods ON tmpItem_goods.MovementItemId = _tmpItem.MovementItemId
                                   AND tmpItem_goods.ContainerId    = _tmpItem.ContainerId
                                   AND tmpItem_goods.AnalyzerId     = _tmpItem.AnalyzerId
            -- ����� ������������
            LEFT JOIN tmpItem_goods_sum ON tmpItem_goods_sum.MovementItemId = _tmpItem.MovementItemId
                                       AND tmpItem_goods_sum.ContainerId    = _tmpItem.ContainerId
                                       AND tmpItem_goods_sum.AnalyzerId     = _tmpItem.AnalyzerId
       WHERE vbIsAccount_50000 = FALSE
      UNION ALL
       -- ��� ������� ������� ��������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_SummPersonal.MovementItemId
            , _tmpItem_SummPersonal.ContainerId_50000
            , _tmpItem_SummPersonal.AccountId_50000   AS AccountId                -- ������� ������� ��������
            , _tmpItem.AnalyzerId                     AS AnalyzerId               -- ���� ���������, �.�. ������� ...
            , vbPartionMovementId                     AS ObjectId_Analyzer        -- !!!PartionMovementId!!!
            , vbCarId                                 AS WhereObjectId_Analyzer   -- ����������, � ���� ���.���� (��) - vbMemberDriverId
            , _tmpItem_SummPersonal.ContainerId       AS ContainerId_Analyzer     -- ��������� - �������������
            , _tmpItem_SummPersonal.AccountId         AS AccountId_Analyzer       -- ���� - �������������
         -- , _tmpItem_SummPersonal.UnitId_ProfitLoss AS ObjectIntId_Analyzer     -- ������������� (����)
            , _tmpItem_SummPersonal.PersonalId        AS ObjectIntId_Analyzer        -- ��������� (��)
         -- , _tmpItem_SummPersonal.BranchId_ProfitLoss AS ObjectExtId_Analyzer   -- ������ (����), � ����� ���� � ����� BusinessId_ProfitLoss
            , _tmpItem_SummPersonal.UnitId_ProfitLoss AS ObjectExtId_Analyzer     -- ������������� (����)
            , 0                                       AS ContainerIntId_Analyzer  -- ����� �� �����
            , 0                                       AS ParentId
            , 1 * (_tmpItem.OperSumm)
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive               -- !!!���� ������ �� �������!!!
       FROM tmpItem AS _tmpItem
            INNER JOIN _tmpItem_SummPersonal ON _tmpItem_SummPersonal.MovementItemId = _tmpItem.MovementItemId
                                            AND _tmpItem_SummPersonal.ContainerId    = _tmpItem.ContainerId
       WHERE vbIsAccount_50000 = TRUE
      ;


     -- !!!4.1. ����������� �������� � ��������� �� ������ ��� ��������!!!
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Branch(), inMovementId, tmp.BranchId_ProfitLoss)
     FROM (SELECT DISTINCT _tmpItem_Transport.BranchId_ProfitLoss
           FROM _tmpItem_Transport
           WHERE _tmpItem_Transport.MovementItemId > 0 AND _tmpItem_Transport.BranchId_ProfitLoss > 0
           ORDER BY 1 DESC
          ) AS tmp;

     -- !!!4.2. ����������� �������� � ��������� ��������� �� ������ ��� ��������!!!
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(),        tmp.MovementItemId, tmp.UnitId_ProfitLoss)
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(),      tmp.MovementItemId, tmp.BranchId_ProfitLoss)
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Route(),       tmp.MovementItemId, tmp.RouteId_ProfitLoss)
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_UnitRoute(),   tmp.MovementItemId, tmp.UnitId_ProfitLoss)   -- � ���� UnitId_Route
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BranchRoute(), tmp.MovementItemId, tmp.BranchId_ProfitLoss) -- � ���� BranchId_Route
     FROM (SELECT DISTINCT _tmpItem_Transport.MovementItemId, _tmpItem_Transport.UnitId_ProfitLoss, _tmpItem_Transport.BranchId_ProfitLoss, _tmpItem_Transport.RouteId_ProfitLoss, _tmpItem_Transport.UnitId_Route, _tmpItem_Transport.BranchId_Route
           FROM _tmpItem_Transport
           WHERE _tmpItem_Transport.MovementItemId > 0
          ) AS tmp;


     -- 5.0. ���������  "����� ������" - ������ ��� �������� ����������� � ��������
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountCost(), inMovementId, tmp.AmountCost)
           , lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountMemberCost(), inMovementId, tmp.AmountMemberCost)
     FROM (SELECT (SELECT SUM (_tmpItem_TransportSumm_Transport.OperSumm) FROM _tmpItem_TransportSumm_Transport) AS AmountCost
                , (SELECT SUM (tmpItem.OperSumm_Add + tmpItem.OperSumm_AddLong + tmpItem.OperSumm_Taxi) FROM _tmpItem_SummPersonal AS tmpItem) AS AmountMemberCost
          ) AS tmp
     ;

     -- 5.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Transport()
                                , inUserId     := inUserId
                                 );

-- if inUserId = 5
-- then
--     RAISE EXCEPTION '������.1';
-- end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 17.08.14                                        * add MovementDescId
 12.08.14                                        * add inBranchId :=
 25.05.14                                        * add lpComplete_Movement
 10.05.14                                        * add lpInsert_MovementProtocol
 11.03.14                                        * err on zc_MIFloat_StartAmountFuel
 26.01.14                                        * ���������� �������� �� �������
 21.12.13                                        * Personal -> Member
 11.12.13                                        * ����� ����������� Child - �����
 03.11.13                                        * add zc_MILinkObject_Route
 02.11.13                                        * add zc_MILinkObject_Branch, zc_MILinkObject_UnitRoute, zc_MILinkObject_BranchRoute
 02.11.13                                        * group AS _tmpItem_Transport
 27.10.13                                        * err zc_MovementFloat_StartAmountTicketFuel
 26.10.13                                        * add !!!�����������!!! �������� �������...
 26.10.13                                        * err
 25.10.13                                        * add lpInsertUpdate_MI_Transport_Child_byMaster
 21.10.13                                        * err ObjectId IN (SELECT GoodsId...
 14.10.13                                        * add lpInsertUpdate_MovementItemLinkObject
 06.10.13                                        * add inUserId
 02.10.13                                        * add BusinessId_Route
 02.10.13                                        *
*/

/*
select lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Branch(), tmp.MovementId, tmp.ObjectExtId_Analyzer)
from (select distinct MovementId, ObjectExtId_Analyzer
      from MovementItemContainer
           join Object ON Object.Id = ObjectExtId_Analyzer AND Object.DescId = zc_Object_Branch()
      where MovementDescId = zc_Movement_Transport()
        AND OperDate between '01.11.2020' AND '30.11.2020'
        AND AccountId = zc_Enum_Account_100301()
      ) as tmp

*/
-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM lpComplete_Movement_Transport (inMovementId:= 15465178, inUserId:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- select * from gpReComplete_Movement_Transport(inMovementId := 26328494 , inislastcomplete := 'False' ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');
