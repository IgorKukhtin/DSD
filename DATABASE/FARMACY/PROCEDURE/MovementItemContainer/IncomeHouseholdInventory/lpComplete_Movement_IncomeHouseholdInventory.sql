-- Function: lpComplete_Movement_IncomeHouseholdInventory (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_IncomeHouseholdInventory (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_IncomeHouseholdInventory(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbAccountId Integer;
   DECLARE vbOperSumm_Partner TFloat;
   DECLARE vbOperSumm_Partner_byItem TFloat;
   DECLARE vbPriceWithVAT Boolean;
   DECLARE vbNDS TFloat;
   DECLARE vbOperDate TDateTime;
   DECLARE vbUnitId Integer;
   DECLARE vbContainerId_Partner Integer;
BEGIN

     -- !!!�������� ��� � ������ ��� �� ������� ��������� � �������� �� ����������!!!
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         RAISE EXCEPTION '������.�������� ��� ��������.';
     END IF;

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     -- DELETE FROM _tmpMIReport_insert;

     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;

    -- ����������
    vbOperDate:= (SELECT OperDate FROM Movement WHERE Id = inMovementId);
    -- ����������
    vbUnitId:= (SELECT MovementLinkObject.ObjectId
                FROM MovementLinkObject
                WHERE MovementLinkObject.MovementId = inMovementId
                  AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit());

   -- ������ �� "������ ���-��" - !!!���� ������!!!
   INSERT INTO _tmpItem (MovementDescId, MovementItemId, ObjectId, OperSumm, AccountId, JuridicalId_Basis, OperDate, UnitId, Price, AnalyzerId)
      WITH -- ������ ������
           tmpMI AS (SELECT MovementItem.Id                           AS MovementItemId
                          , MovementItem.ObjectId                     AS HouseholdInventoryId
                          , MovementItem.Amount
                          , MIFloat_InvNumber.ValueData::Integer      AS InvNumber
                          , MIFloat_CountForPrice.ValueData           AS CountForPrice
                     FROM MovementItem
                          LEFT JOIN MovementItemFloat AS MIFloat_InvNumber
                                                      ON MIFloat_InvNumber.MovementItemId = MovementItem.Id
                                                     AND MIFloat_InvNumber.DescId = zc_MIFloat_InvNumber()

                          LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                      ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                     AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.DescId     = zc_MI_Master()
                       AND MovementItem.Amount     > 0
                       AND MovementItem.IsErased   = FALSE
                    )

      -- ���������
      SELECT zc_Movement_IncomeHouseholdInventory()
           , tmpMI.MovementItemId
           , tmpMI.HouseholdInventoryId AS ObjectId
           , tmpMI.Amount
           , Null
           , Null
           , vbOperDate
           , vbUnitId AS UnitId
           , tmpMI.CountForPrice
           , tmpMI.InvNumber     AS AnalyzerId
       FROM tmpMI
      ;

    -- ��������� - �������� �� ���-�� "�������"
    INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                      , ObjectId_analyzer, WhereObjectId_analyzer
                                       )
         SELECT zc_MIContainer_CountHouseholdInventory()
              , zc_Movement_IncomeHouseholdInventory()
              , inMovementId
              , _tmpItem.MovementItemId
              , lpInsertFind_Container(
                          inContainerDescId   := zc_Container_CountHouseholdInventory(), -- DescId �������
                          inParentId          := NULL               , -- ������� Container
                          inObjectId          := ObjectId, -- ������ (���� ��� ����� ��� ...)
                          inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- ������� ����������� ����
                          inBusinessId        := NULL, -- �������
                          inObjectCostDescId  := NULL, -- DescId ��� <������� �/�>
                          inObjectCostId      := NULL,
                          inDescId_1          := zc_ContainerLinkObject_Unit(), -- DescId ��� 1-�� ���������
                          inObjectId_1        := _tmpItem.UnitId,
                          inDescId_2          := zc_ContainerLinkObject_PartionHouseholdInventory(), -- DescId ��� 2-�� ���������
                          inObjectId_2        := lpInsertUpdate_Object_PartionHouseholdInventory(ioId               := 0,                    -- ���� ������� <>
                                                                                                 inInvNumber        := _tmpItem.AnalyzerId,  -- ����������� �����
                                                                                                 inUnitId           := _tmpItem.UnitId,      -- �������������
                                                                                                 inMovementItemId   := _tmpItem.MovementItemId,                          -- ���� �������� ������� �������������� ���������
                                                                                                 inUserId           := inUserId)
                          )
              , AccountId
              , OperSumm
              , OperDate
              , ObjectId AS ObjectId_analyzer
              , vbUnitId AS WhereObjectId_analyzer
           FROM _tmpItem;

    -- ����������� �������� �����
    PERFORM lpInsertUpdate_IncomeHouseholdInventory_TotalSumm (inMovementId);


     -- 5.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_IncomeHouseholdInventory()
                                , inUserId     := inUserId
                                 );

     -- ��������� �������� <���� �������������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), inMovementId, CURRENT_TIMESTAMP);
     -- ��������� �������� <������������ (�������������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), inMovementId, inUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 30.07.20                                                      *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_IncomeHouseholdInventory (inMovementId:= 103, inUserId:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
