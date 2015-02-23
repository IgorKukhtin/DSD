-- Function: lpInsertUpdate_MI_ProfitLossService_AmountPartner()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProfitLossService_AmountPartner (Integer, Integer, TFloat);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ProfitLossService_AmountPartner(
    IN inMovementId               Integer   , -- ���� ������� <��������>
    IN inAmount                   TFloat    , -- ����� ����������
    IN inUserId                   Integer     -- ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbOperDate  TDateTime;
  DECLARE vbStartDate TDateTime;
  DECLARE vbEndDate   TDateTime;

  DECLARE vbMovementItemId Integer;
  DECLARE vbContractConditionKindId Integer;
  DECLARE vbJuridicalId Integer;
  DECLARE vbContractId_child Integer;
  DECLARE vbInfoMoneyId Integer;
  DECLARE vbPaidKindId Integer;

  DECLARE vbSumm_Baza TFloat;
  DECLARE vbSumm_Sale TFloat;
  DECLARE vbSumm_Baza_recalc TFloat;
  DECLARE vbAmount_recalc TFloat;
BEGIN

     -- ��� ��������� ����� ��� 
     SELECT Movement.OperDate
          , MovementItem.Id                              AS MovementItemId
          , MovementItem.ObjectId                        AS JuridicalId
          , MILinkObject_ContractConditionKind.ObjectId  AS ContractConditionKindId
          , MILinkObject_ContractChild.ObjectId          AS ContractId
          , ObjectLink_Contract_InfoMoney.ChildObjectId  AS InfoMoneyId
          , ObjectLink_Contract_PaidKind.ChildObjectId   AS PaidKindId
            INTO vbOperDate, vbMovementItemId, vbJuridicalId, vbContractConditionKindId
               , vbContractId_child, vbInfoMoneyId, vbPaidKindId
     FROM MovementItem
          INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
          INNER JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                            ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id
                                           AND MILinkObject_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()
          INNER JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                            ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                           AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()
          INNER JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                ON ObjectLink_Contract_InfoMoney.ObjectId = MILinkObject_ContractChild.ObjectId
                               AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
          INNER JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                ON ObjectLink_Contract_PaidKind.ObjectId = MILinkObject_ContractChild.ObjectId
                               AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Master()
       AND MovementItem.isErased = FALSE
    ;

     -- ��� ��������� ����� ��� 
     vbStartDate:= DATE_TRUNC ('MONTH', vbOperDate);
     vbEndDate:= DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';

     -- ������� - �������� ���������
     CREATE TEMP TABLE _tmpMIChild (MovementId Integer, MovementItemId Integer, OperDate TDateTime, JuridicalId Integer, UnitId Integer, GoodsId Integer, GoodsKindId Integer, Summ_Sale TFloat, Summ_Baza TFloat, Summ_Baza_recalc TFloat, Amount_recalc TFloat) ON COMMIT DROP;

     -- 
     INSERT INTO _tmpMIChild (MovementId, MovementItemId, OperDate, JuridicalId, UnitId, GoodsId, GoodsKindId, Summ_Sale, Summ_Baza, Summ_Baza_recalc, Amount_recalc)
      WITH 
      tmpContainer AS (SELECT Container.Id                   AS ContainerId
                            , ContainerLO_Juridical.ObjectId AS JuridicalId
                       FROM ContainerLinkObject AS ContainerLO_Contract
                            INNER JOIN ContainerLinkObject AS ContainerLO_Juridical ON ContainerLO_Juridical.ContainerId = ContainerLO_Contract.ContainerId
                                                                                   AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                            INNER JOIN ContainerLinkObject AS ContainerLO_InfoMoney ON ContainerLO_InfoMoney.ContainerId = ContainerLO_Contract.ContainerId
                                                                                   AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                                                   AND ContainerLO_InfoMoney.ObjectId = vbInfoMoneyId
                            INNER JOIN ContainerLinkObject AS ContainerLO_PaidKind ON ContainerLO_PaidKind.ContainerId = ContainerLO_Contract.ContainerId
                                                                                  AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                                                  AND ContainerLO_PaidKind.ObjectId = vbPaidKindId
                            INNER JOIN Container ON Container.Id = ContainerLO_Contract.ContainerId
                                                AND Container.ObjectId NOT IN (SELECT AccountId FROM Object_Account_View WHERE AccountGroupId = zc_Enum_AccountGroup_110000()) -- �������
                                                AND Container.DescId = zc_Container_Summ()
                       WHERE ContainerLO_Contract.ObjectId = vbContractId_child
                         AND ContainerLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                      )
, tmpContainerDesc AS (SELECT tmpContainer.ContainerId
                            , tmpContainer.JuridicalId
                            , tmpDesc.DescId AS MovementDescId
                       FROM (SELECT zc_Movement_BankAccount() AS DescId, zc_Enum_ContractConditionKind_BonusPercentAccount()    AS ContractConditionKindId -- % ������ �� ������
                            UNION
                             SELECT zc_Movement_Cash()        AS DescId, zc_Enum_ContractConditionKind_BonusPercentAccount()    AS ContractConditionKindId -- % ������ �� ������
                            UNION
                             SELECT zc_Movement_SendDebt()    AS DescId, zc_Enum_ContractConditionKind_BonusPercentAccount()    AS ContractConditionKindId -- % ������ �� ������
                            UNION
                             SELECT zc_Movement_Sale()        AS DescId, zc_Enum_ContractConditionKind_BonusPercentSaleReturn() AS ContractConditionKindId -- % ������ �� ��������-�������
                            UNION
                             SELECT zc_Movement_ReturnIn()    AS DescId, zc_Enum_ContractConditionKind_BonusPercentSaleReturn() AS ContractConditionKindId -- % ������ �� ��������-�������
                            UNION
                             SELECT zc_Movement_Sale()        AS DescId, zc_Enum_ContractConditionKind_BonusPercentSale()       AS ContractConditionKindId -- % ������ �� ��������
                            ) AS tmpDesc
                            INNER JOIN tmpContainer ON vbContractConditionKindId = tmpDesc.ContractConditionKindId
                      )
          , tmpBaza AS (SELECT tmpContainerDesc.JuridicalId
                             , CASE WHEN tmpContainerDesc.MovementDescId = zc_Movement_Sale()
                                         THEN MIContainer.MovementId
                                    ELSE 0
                               END AS MovementId
                             , CASE WHEN tmpContainerDesc.MovementDescId = zc_Movement_Sale()
                                         THEN MIContainer.MovementItemId
                                    ELSE 0
                               END AS MovementItemId
                             , CASE WHEN tmpContainerDesc.MovementDescId = zc_Movement_Sale()
                                         THEN MIContainer.OperDate
                                    ELSE vbOperDate
                               END AS OperDate
                             , CASE WHEN tmpContainerDesc.MovementDescId = zc_Movement_Sale()
                                         THEN MIContainer.ObjectId_Analyzer
                                    ELSE 0
                               END AS GoodsId
                             , CASE WHEN tmpContainerDesc.MovementDescId = zc_Movement_Sale()
                                         THEN MIContainer.WhereObjectId_Analyzer
                                    ELSE 0
                               END AS UnitId
                             , SUM (CASE WHEN tmpContainerDesc.MovementDescId = zc_Movement_Sale()
                                              THEN MIContainer.Amount
                                         ELSE 0
                                    END) AS Summ_Sale
                             , SUM (CASE WHEN tmpContainerDesc.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_SendDebt())
                                              THEN -1 * MIContainer.Amount
                                         ELSE MIContainer.Amount
                                    END) AS Summ_Baza
                        FROM tmpContainerDesc
                             JOIN MovementItemContainer AS MIContainer
                                                        ON MIContainer.ContainerId = tmpContainerDesc.ContainerId
                                                       AND MIContainer.DescId = zc_MIContainer_Summ()
                                                       AND MIContainer.OperDate BETWEEN vbStartDate AND vbEndDate
                                                       AND MIContainer.MovementDescId = tmpContainerDesc.MovementDescId
                        GROUP BY tmpContainerDesc.JuridicalId
                               , CASE WHEN tmpContainerDesc.MovementDescId = zc_Movement_Sale()
                                           THEN MIContainer.MovementId
                                      ELSE 0
                                 END
                               , CASE WHEN tmpContainerDesc.MovementDescId = zc_Movement_Sale()
                                           THEN MIContainer.MovementItemId
                                      ELSE 0
                                 END
                               , CASE WHEN tmpContainerDesc.MovementDescId = zc_Movement_Sale()
                                           THEN MIContainer.OperDate
                                      ELSE vbOperDate
                                 END
                               , CASE WHEN tmpContainerDesc.MovementDescId = zc_Movement_Sale()
                                           THEN MIContainer.ObjectId_Analyzer
                                      ELSE 0
                                 END
                               , CASE WHEN tmpContainerDesc.MovementDescId = zc_Movement_Sale()
                                           THEN MIContainer.WhereObjectId_Analyzer
                                      ELSE 0
                                 END
                       )
, tmpContainer_Sale AS (SELECT * FROM tmpContainer WHERE vbContractConditionKindId = zc_Enum_ContractConditionKind_BonusPercentAccount()
                       )
          , tmpSale AS (SELECT tmpContainer_Sale.JuridicalId
                             , MIContainer.MovementId
                             , MIContainer.MovementItemId
                             , MIContainer.OperDate
                             , MIContainer.ObjectId_Analyzer      AS GoodsId
                             , MIContainer.WhereObjectId_Analyzer AS UnitId
                             , SUM (MIContainer.Amount)           AS Summ_Sale
                        FROM tmpContainer_Sale
                             JOIN MovementItemContainer AS MIContainer
                                                        ON MIContainer.ContainerId = tmpContainer_Sale.ContainerId
                                                       AND MIContainer.DescId = zc_MIContainer_Summ()
                                                       AND MIContainer.OperDate BETWEEN vbStartDate AND vbEndDate
                                                       AND MIContainer.MovementDescId = zc_Movement_Sale()
                        GROUP BY tmpContainer_Sale.JuridicalId
                               , MIContainer.MovementId
                               , MIContainer.MovementItemId
                               , MIContainer.OperDate
                               , MIContainer.ObjectId_Analyzer
                               , MIContainer.WhereObjectId_Analyzer
                       )
        -- ������ �� ���� ��� ������������� (!!!����� ��� ����� ���� �������!!!)
        SELECT tmpBaza.MovementId
             , MAX (tmpBaza.MovementItemId) AS MovementItemId
             , tmpBaza.OperDate
             , tmpBaza.JuridicalId
             , tmpBaza.UnitId
             , tmpBaza.GoodsId
             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
             , SUM (tmpBaza.Summ_Sale)
             , SUM (tmpBaza.Summ_Baza)
             , 0 AS Summ_Baza_recalc
             , 0 AS Amount_recalc
        FROM tmpBaza
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = tmpBaza.MovementItemId
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
        GROUP BY tmpBaza.MovementId
               , tmpBaza.OperDate
               , tmpBaza.JuridicalId
               , tmpBaza.UnitId
               , tmpBaza.GoodsId
               , MILinkObject_GoodsKind.ObjectId
       UNION ALL
        -- ������ �� �������� (!!!���� � ���� �� ���, �.�. BonusPercentAccount!!!)
        SELECT tmpSale.MovementId
             , MAX (tmpSale.MovementItemId) AS MovementItemId
             , tmpSale.OperDate
             , tmpSale.JuridicalId
             , tmpSale.UnitId
             , tmpSale.GoodsId
             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
             , SUM (tmpSale.Summ_Sale)
             , 0 AS Summ_Baza
             , 0 AS Summ_Baza_recalc
             , 0 AS Amount_recalc
        FROM tmpSale
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = tmpSale.MovementItemId
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
        GROUP BY tmpSale.MovementId
               , tmpSale.OperDate
               , tmpSale.JuridicalId
               , tmpSale.UnitId
               , tmpSale.GoodsId
               , MILinkObject_GoodsKind.ObjectId
       ;

     -- ������������� ����� - ���� ��� ���������� (��� ����� �����, ��� ����� ������, ��� ����� ������� ����� �������)
     vbSumm_Baza:= (SELECT SUM (Summ_Baza) FROM _tmpMIChild);
     -- ������������� ����� - �������
     vbSumm_Sale:= (SELECT SUM (Summ_Sale) FROM _tmpMIChild WHERE _tmpMIChild.Summ_Sale > 0); -- ������������ ����� ���� ������� � "�������"


     IF vbContractConditionKindId = zc_Enum_ContractConditionKind_BonusPercentSale()
        AND NOT EXISTS (SELECT Summ_Sale FROM _tmpMIChild WHERE Summ_Sale < 0) -- !!!�.�. ��� ������ � "�������"!!!
     THEN
         -- "���� ��� ����������" ����� "��������", ������������ �� ����
         UPDATE _tmpMIChild SET Summ_Baza_recalc = _tmpMIChild.Summ_Sale WHERE _tmpMIChild.Summ_Sale = _tmpMIChild.Summ_Baza; -- ������� - �.�. ��� ������ ���� ����� ����� ������

         -- �������������� "����� ����������" ��������������� "��������"
         UPDATE _tmpMIChild SET Amount_recalc = inAmount * _tmpMIChild.Summ_Sale / vbSumm_Sale WHERE _tmpMIChild.Summ_Sale > 0; -- ������������ ����� ���� ������� � "�������"

     ELSE
     IF vbSumm_Sale > 0
     THEN
         -- �������������� "���� ��� ����������" ��������������� "��������"
         UPDATE _tmpMIChild SET Summ_Baza_recalc = vbSumm_Baza * _tmpMIChild.Summ_Sale / vbSumm_Sale WHERE _tmpMIChild.Summ_Sale > 0; -- ������������ ����� ���� ������� � "�������"

         -- �������������� "����� ����������" ��������������� "��������"
         UPDATE _tmpMIChild SET Amount_recalc = inAmount * _tmpMIChild.Summ_Sale / vbSumm_Sale WHERE _tmpMIChild.Summ_Sale > 0; -- ������������ ����� ���� ������� � "�������"

         -- ������ �������� ���� �� �� ���������
          SELECT SUM (_tmpMIChild.Summ_Baza_recalc), SUM (_tmpMIChild.Amount_recalc) INTO vbSumm_Baza_recalc, vbAmount_recalc FROM _tmpMIChild;
         --
         -- ���� �� ����� ��� �������� ����� "���� ��� ����������"
         IF COALESCE (vbSumm_Baza, 0) <> COALESCE (vbSumm_Baza_recalc, 0)
         THEN
             -- �� ������� ������������ ����� ������� ����� (������������ ����� ���������� �������� < 0, �� ��� ������ �� ������������)
             UPDATE _tmpMIChild SET Summ_Baza_recalc = _tmpMIChild.Summ_Baza_recalc - (vbSumm_Baza_recalc - vbSumm_Baza)
             WHERE _tmpMIChild.MovementItemId IN (SELECT _tmpMIChild.MovementItemId FROM _tmpMIChild ORDER BY _tmpMIChild.Summ_Baza_recalc DESC LIMIT 1
                                                 );
         END IF;
         -- ���� �� ����� ��� �������� ����� "����� ����������"
         IF COALESCE (inAmount, 0) <> COALESCE (vbAmount_recalc, 0)
         THEN
             -- �� ������� ������������ ����� ������� ����� (������������ ����� ���������� �������� < 0, �� ��� ������ �� ������������)
             UPDATE _tmpMIChild SET Amount_recalc = _tmpMIChild.Amount_recalc - (vbAmount_recalc - inAmount)
             WHERE _tmpMIChild.MovementItemId IN (SELECT _tmpMIChild.MovementItemId FROM _tmpMIChild ORDER BY _tmpMIChild.Amount_recalc DESC LIMIT 1
                                                 );
         END IF;

     ELSE
         -- ������������ � !!!����!!! ������ - "���� ��� ����������" � "����� ����������"
         UPDATE _tmpMIChild SET Summ_Baza_recalc = vbSumm_Baza
                              , Amount_recalc = inAmount
         WHERE _tmpMIChild.Summ_Baza <> 0;
     END IF;
     END IF;

     -- !!!��������!!!
     IF vbSumm_Baza < 0 OR vbSumm_Baza <> COALESCE ((SELECT SUM (Summ_Baza_recalc) FROM _tmpMIChild), 0)
     THEN  
         RAISE EXCEPTION '������ ������������� ��� <����>. Real = <%>   Calc = <%>', vbSumm_Baza, (SELECT SUM (Summ_Baza_recalc) FROM _tmpMIChild);
     END IF;
     -- !!!��������!!!
     IF inAmount < 0 OR inAmount <> COALESCE ((SELECT SUM (Amount_recalc) FROM _tmpMIChild), 0)
     THEN  
         RAISE EXCEPTION '������ ������������� ��� <�����>. Real = <%>   Calc = <%>', inAmount, (SELECT SUM (Amount_recalc) FROM _tmpMIChild);
     END IF;


     -- ��������� ���������� ������
     PERFORM lpSetErased_MovementItem (MovementItem.Id, inUserId)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.isErased = FALSE
       AND MovementItem.DescId = zc_MI_Child();

     -- ����������� ������ - Child
     PERFORM lpInsertUpdate_MI_ProfitLossService_Child (ioId               := 0
                                                      , inParentId         := vbMovementItemId
                                                      , inMovementId       := inMovementId
                                                      , inJuridicalId      := vbJuridicalId
                                                      , inJuridicalId_Child:= _tmpMIChild.JuridicalId
                                                      , inPartnerId        := MovementLinkObject_From.ObjectId
                                                      , inBranchId         := CASE WHEN vbContractId_child <> 0 THEN COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis()) END
                                                      , inGoodsId          := _tmpMIChild.GoodsId
                                                      , inGoodsKindId      := _tmpMIChild.GoodsKindId
                                                      , inAmount           := _tmpMIChild.Amount_recalc
                                                      , inAmountPartner    := _tmpMIChild.Summ_Sale
                                                      , inSumm             := _tmpMIChild.Summ_Baza_recalc
                                                      , inMovementId_child := _tmpMIChild.MovementId
                                                      , inOperDate         := _tmpMIChild.OperDate
                                                      , inUserId           := inUserId
                                                       )
     FROM _tmpMIChild
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = _tmpMIChild.MovementId
                                      AND MovementLinkObject_From.DescId = zc_MILinkObject_ContractConditionKind()
          LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                               ON ObjectLink_Unit_Branch.ObjectId = _tmpMIChild.UnitId
                              AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
     WHERE _tmpMIChild.Summ_Baza_recalc <> 0 OR _tmpMIChild.Amount_recalc <> 0;


     -- ����������� ������ - Master
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), vbMovementItemId, vbSumm_Sale);
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), vbMovementItemId, vbSumm_Baza);
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Juridical(), vbMovementItemId, (SELECT _tmpMIChild.JuridicalId FROM _tmpMIChild WHERE _tmpMIChild.Summ_Baza_recalc <> 0 OR _tmpMIChild.Amount_recalc <> 0 GROUP BY _tmpMIChild.JuridicalId));


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.02.15                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MI_ProfitLossService_AmountPartner (inMovementId := 827585 , inAmount := 8563.5816, inUserId:= zfCalc_UserAdmin() :: Integer); -- ������-� ���
