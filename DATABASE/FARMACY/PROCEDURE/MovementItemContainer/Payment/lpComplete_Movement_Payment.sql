DROP FUNCTION IF EXISTS lpComplete_Movement_Payment (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Payment(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbAccountId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbPaymentDate TDateTime;
BEGIN
    
    --���������, ��� �� ��� ������ ��������������� ���, ��� � ���������
    PERFORM
        lpInsertUpdate_MovementItem_Payment_Child(inId     := MI_Payment.Id, -- ���� ������� <������� ���������>
                                                  inUserId := inUserId    -- ������ ������������
                                                  )
    FROM
        MovementItem_Payment_View AS MI_Payment
    WHERE
        MI_Payment.MovementId = inMovementId;



    -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
    PERFORM lpComplete_Movement_Finance_CreateTemp();
    --������� ��������� ��������� ����� �� ����������� ������ ������ �������������
    CREATE TEMP TABLE _tmp(OperDate TDateTime, JuridicalId Integer, Income_JuridicalId Integer, SummaCorrOther TFloat) ON COMMIT DROP;
    WITH 
    A AS
    (
        SELECT
            Movement_Payment.OperDate
           ,Movement_Payment.JuridicalId
           ,MI_Payment.Income_JuridicalId
           ,SUM(MI_Payment.SummaCorrOther) AS SummaCorrOther
        FROM  Movement_Payment_View AS Movement_Payment
            LEFT OUTER JOIN MovementItem_Payment_View AS MI_Payment
                                                      ON MI_Payment.MovementId = Movement_Payment.ID
                                                     AND MI_Payment.NeedPay = TRUE 
                                                     AND MI_Payment.isErased = FALSE
                                                     AND MI_Payment.SummaCorrOther <> 0
        WHERE
            Movement_Payment.Id = inMovementId
            AND
            MI_Payment.SummaCorrOther <> 0
        GROUP BY
            Movement_Payment.JuridicalId
           ,MI_Payment.Income_JuridicalId
           ,Movement_Payment.OperDate
        HAVING
            SUM(MI_Payment.SummaCorrOther) <> 0
    ),
    B AS
    (
        SELECT
            CLO_JuridicalBasis.ObjectId as JuridicalBasicId
           ,CLO_Juridical.ObjectId AS JuridicalId
           ,SUM(Container.Amount) as Amount
        FROM
            Container
            LEFT OUTER JOIN ContainerLinkObject AS CLO_Juridical
                                                ON CLO_Juridical.ContainerId = Container.Id
                                               AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
            LEFT OUTER JOIN ContainerLinkObject AS CLO_JuridicalBasis
                                                ON CLO_JuridicalBasis.ContainerId = Container.Id
                                               AND CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
        WHERE
            Container.DescId = zc_Container_SummIncomeMovementPayment() 
            AND 
            Container.ObjectId = zc_Enum_ChangeIncomePaymentKind_Other()
            AND
            Container.Amount <> 0
        GROUP BY
            CLO_JuridicalBasis.ObjectId
           ,CLO_Juridical.ObjectId
        HAVING
            SUM(Container.Amount) <> 0
    ),
    C AS
    (
        SELECT
            A.OperDate
           ,A.JuridicalId
           ,A.Income_JuridicalId
           ,(A.SummaCorrOther - COALESCE(B.Amount,0))::TFloat AS SummaCorrOther
        FROM
            A
            LEFT OUTER JOIN B ON A.JuridicalId = B.JuridicalBasicId
                             AND A.Income_JuridicalId = B.JuridicalId
        WHERE
            (
                A.SummaCorrOther > 0
                AND
                A.SummaCorrOther > COALESCE(B.Amount,0)
            )
            OR
            (
                A.SummaCorrOther < 0
                AND
                A.SummaCorrOther < COALESCE(B.Amount,0)
            )
            
    )
    Insert Into _Tmp Select * from C;
    PERFORM
        lpComplete_Movement_ChangeIncomePayment(inMovementId := lpInsertUpdate_Movement_ChangeIncomePayment(ioId                        :=0,
                                                                                                            inInvNumber                 :=NEXTVAL('movement_ChangeIncomePayment_seq')::TVarChar,
                                                                                                            inOperDate                  :=_Tmp.OperDate,
                                                                                                            inTotalSumm                 :=_Tmp.SummaCorrOther,
                                                                                                            inFromId                    :=_Tmp.Income_JuridicalId,
                                                                                                            inJuridicalId               :=_Tmp.JuridicalId,
                                                                                                            inChangeIncomePaymentKindId :=zc_Enum_ChangeIncomePaymentKind_Other(),
                                                                                                            inComment                   :=NULL::TVarChar,
                                                                                                            inUserId                    :=inUserId),
                                                inUserId := inUserId)
    FROM _Tmp;
    -- �������� ������
    PERFORM
        lpComplete_Movement_BankAccount (inMovementId := MI_Payment.MovementBankAccountId
                                       , inUserId     := inUserId)
    FROM
        MovementItem_Payment_View AS MI_Payment
    WHERE
        MI_Payment.MovementId = inMovementId
        AND
        MI_Payment.NeedPay = TRUE
        AND
        MI_Payment.SummaPay > 0
        AND
        COALESCE(MI_Payment.BankAccountId,0) > 0;
    -- ������� �������� ���������� ���� � ���������� ������������� ����� �� �������
    -- !!!�����������!!! �������� ������� ��������
    DELETE FROM _tmpMIContainer_insert;
    -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
    DELETE FROM _tmpItem;
    
    -- ������� ����� � ���������� �������������
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
    SELECT 
        zc_Container_SummIncomeMovementPayment()
      , zc_Movement_Payment()  
      , inMovementId
      , lpInsertFind_Container(inContainerDescId   := zc_Container_SummIncomeMovementPayment(), -- DescId �������
                               inParentId          := NULL               , -- ������� Container
                               inObjectId          := zc_Enum_ChangeIncomePaymentKind_Bonus(), -- ������ (���� ��� ����� ��� ...)
                               inJuridicalId_basis := Movement_Payment.JuridicalId, -- ������� ����������� ����
                               inBusinessId        := NULL, -- �������
                               inObjectCostDescId  := NULL, -- DescId ��� <������� �/�>
                               inObjectCostId      := NULL, -- <������� �/�> - ��������� ��������� �����
                               inDescId_1          := zc_ContainerLinkObject_Juridical(), -- DescId ��� 1-�� ���������
                               inObjectId_1        := MovementItem_Payment.Income_JuridicalId,
                               inDescId_2          := zc_ContainerLinkObject_JuridicalBasis(), -- DescId ��� 1-�� ���������
                               inObjectId_2        := Movement_Payment.JuridicalId) 
      , null
      , -MovementItem_Payment.SummaCorrBonus
      , Movement_Payment.OperDate
    FROM
        Movement_Payment_View AS Movement_Payment
        LEFT OUTER JOIN MovementItem_Payment_View AS MovementItem_Payment
                                                  ON MovementItem_Payment.MovementId = Movement_Payment.ID
                                                 AND MovementItem_Payment.isErased = FALSE
                                                 AND MovementItem_Payment.NeedPay = TRUE
                                                 AND MovementItem_Payment.SummaCorrBonus <> 0
    WHERE
        Movement_Payment.Id = inMovementId
        AND 
        COALESCE(MovementItem_Payment.SummaCorrBonus,0) <> 0;
        
    -- ������� ����� � ���������� ������ �� ���������
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
    SELECT 
        zc_Container_SummIncomeMovementPayment()
      , zc_Movement_Payment()  
      , inMovementId
      , lpInsertFind_Container(inContainerDescId   := zc_Container_SummIncomeMovementPayment(), -- DescId �������
                               inParentId          := NULL               , -- ������� Container
                               inObjectId          := lpInsertFind_Object_PartionMovement(MovementItem_Payment.IncomeId), -- ������ (���� ��� ����� ��� ...)
                               inJuridicalId_basis := Movement_Payment.JuridicalId, -- ������� ����������� ����
                               inBusinessId        := NULL, -- �������
                               inObjectCostDescId  := NULL, -- DescId ��� <������� �/�>
                               inObjectCostId      := NULL -- <������� �/�> - ��������� ��������� �����
                               ) 
      , null
      , -MovementItem_Payment.SummaCorrBonus
      , Movement_Payment.OperDate
    FROM
        Movement_Payment_View AS Movement_Payment
        LEFT OUTER JOIN MovementItem_Payment_View AS MovementItem_Payment
                                                  ON MovementItem_Payment.MovementId = Movement_Payment.ID
                                                 AND MovementItem_Payment.isErased = FALSE
                                                 AND MovementItem_Payment.NeedPay = TRUE
                                                 AND MovementItem_Payment.SummaCorrBonus <> 0
    WHERE
        Movement_Payment.Id = inMovementId
        AND 
        COALESCE(MovementItem_Payment.SummaCorrBonus,0) <> 0;
        
    -- ������� ����� � ���������� �������������
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
    SELECT 
        zc_Container_SummIncomeMovementPayment()
      , zc_Movement_Payment()  
      , inMovementId
      , lpInsertFind_Container(inContainerDescId   := zc_Container_SummIncomeMovementPayment(), -- DescId �������
                               inParentId          := NULL               , -- ������� Container
                               inObjectId          := zc_Enum_ChangeIncomePaymentKind_ReturnOut(), -- ������ (���� ��� ����� ��� ...)
                               inJuridicalId_basis := Movement_Payment.JuridicalId, -- ������� ����������� ����
                               inBusinessId        := NULL, -- �������
                               inObjectCostDescId  := NULL, -- DescId ��� <������� �/�>
                               inObjectCostId      := NULL, -- <������� �/�> - ��������� ��������� �����
                               inDescId_1          := zc_ContainerLinkObject_Juridical(), -- DescId ��� 1-�� ���������
                               inObjectId_1        := MovementItem_Payment.Income_JuridicalId,
                               inDescId_2          := zc_ContainerLinkObject_JuridicalBasis(), -- DescId ��� 1-�� ���������
                               inObjectId_2        := Movement_Payment.JuridicalId) 
      , null
      , -MovementItem_Payment.SummaCorrReturnOut
      , Movement_Payment.OperDate
    FROM
        Movement_Payment_View AS Movement_Payment
        LEFT OUTER JOIN MovementItem_Payment_View AS MovementItem_Payment
                                                  ON MovementItem_Payment.MovementId = Movement_Payment.ID
                                                 AND MovementItem_Payment.isErased = FALSE
                                                 AND MovementItem_Payment.NeedPay = TRUE
                                                 AND MovementItem_Payment.SummaCorrReturnOut <> 0
    WHERE
        Movement_Payment.Id = inMovementId
        AND 
        COALESCE(MovementItem_Payment.SummaCorrReturnOut,0) <> 0;
        
    -- ������� ����� � ���������� ������ �� ���������
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
    SELECT 
        zc_Container_SummIncomeMovementPayment()
      , zc_Movement_Payment()  
      , inMovementId
      , lpInsertFind_Container(inContainerDescId   := zc_Container_SummIncomeMovementPayment(), -- DescId �������
                               inParentId          := NULL               , -- ������� Container
                               inObjectId          := lpInsertFind_Object_PartionMovement(MovementItem_Payment.IncomeId), -- ������ (���� ��� ����� ��� ...)
                               inJuridicalId_basis := Movement_Payment.JuridicalId, -- ������� ����������� ����
                               inBusinessId        := NULL, -- �������
                               inObjectCostDescId  := NULL, -- DescId ��� <������� �/�>
                               inObjectCostId      := NULL -- <������� �/�> - ��������� ��������� �����
                               ) 
      , null
      , -MovementItem_Payment.SummaCorrReturnOut
      , Movement_Payment.OperDate
    FROM
        Movement_Payment_View AS Movement_Payment
        LEFT OUTER JOIN MovementItem_Payment_View AS MovementItem_Payment
                                                  ON MovementItem_Payment.MovementId = Movement_Payment.ID
                                                 AND MovementItem_Payment.isErased = FALSE
                                                 AND MovementItem_Payment.NeedPay = TRUE
                                                 AND MovementItem_Payment.SummaCorrReturnOut <> 0
    WHERE
        Movement_Payment.Id = inMovementId
        AND 
        COALESCE(MovementItem_Payment.SummaCorrReturnOut,0) <> 0;    
        
    -- ������� ����� � ���������� �������������
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
    SELECT 
        zc_Container_SummIncomeMovementPayment()
      , zc_Movement_Payment()  
      , inMovementId
      , lpInsertFind_Container(inContainerDescId   := zc_Container_SummIncomeMovementPayment(), -- DescId �������
                               inParentId          := NULL               , -- ������� Container
                               inObjectId          := zc_Enum_ChangeIncomePaymentKind_Other(), -- ������ (���� ��� ����� ��� ...)
                               inJuridicalId_basis := Movement_Payment.JuridicalId, -- ������� ����������� ����
                               inBusinessId        := NULL, -- �������
                               inObjectCostDescId  := NULL, -- DescId ��� <������� �/�>
                               inObjectCostId      := NULL, -- <������� �/�> - ��������� ��������� �����
                               inDescId_1          := zc_ContainerLinkObject_Juridical(), -- DescId ��� 1-�� ���������
                               inObjectId_1        := MovementItem_Payment.Income_JuridicalId,
                               inDescId_2          := zc_ContainerLinkObject_JuridicalBasis(), -- DescId ��� 1-�� ���������
                               inObjectId_2        := Movement_Payment.JuridicalId) 
      , null
      , -MovementItem_Payment.SummaCorrOther
      , Movement_Payment.OperDate
    FROM
        Movement_Payment_View AS Movement_Payment
        LEFT OUTER JOIN MovementItem_Payment_View AS MovementItem_Payment
                                                  ON MovementItem_Payment.MovementId = Movement_Payment.ID
                                                 AND MovementItem_Payment.isErased = FALSE
                                                 AND MovementItem_Payment.NeedPay = TRUE
                                                 AND MovementItem_Payment.SummaCorrOther <> 0
    WHERE
        Movement_Payment.Id = inMovementId
        AND 
        COALESCE(MovementItem_Payment.SummaCorrOther,0) <> 0;
        
    -- ������� ����� � ���������� ������ �� ���������
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
    SELECT 
        zc_Container_SummIncomeMovementPayment()
      , zc_Movement_Payment()  
      , inMovementId
      , lpInsertFind_Container(inContainerDescId   := zc_Container_SummIncomeMovementPayment(), -- DescId �������
                               inParentId          := NULL               , -- ������� Container
                               inObjectId          := lpInsertFind_Object_PartionMovement(MovementItem_Payment.IncomeId), -- ������ (���� ��� ����� ��� ...)
                               inJuridicalId_basis := Movement_Payment.JuridicalId, -- ������� ����������� ����
                               inBusinessId        := NULL, -- �������
                               inObjectCostDescId  := NULL, -- DescId ��� <������� �/�>
                               inObjectCostId      := NULL -- <������� �/�> - ��������� ��������� �����
                               ) 
      , null
      , -MovementItem_Payment.SummaCorrOther
      , Movement_Payment.OperDate
    FROM
        Movement_Payment_View AS Movement_Payment
        LEFT OUTER JOIN MovementItem_Payment_View AS MovementItem_Payment
                                                  ON MovementItem_Payment.MovementId = Movement_Payment.ID
                                                 AND MovementItem_Payment.isErased = FALSE
                                                 AND MovementItem_Payment.NeedPay = TRUE
                                                 AND MovementItem_Payment.SummaCorrOther <> 0
    WHERE
        Movement_Payment.Id = inMovementId
        AND 
        COALESCE(MovementItem_Payment.SummaCorrOther,0) <> 0;
    

    PERFORM lpInsertUpdate_MovementItemContainer_byTable();
    
    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_ChangeIncomePayment()
                               , inUserId     := inUserId
                                 );
                                 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 13.10.15                                                                     * 
*/