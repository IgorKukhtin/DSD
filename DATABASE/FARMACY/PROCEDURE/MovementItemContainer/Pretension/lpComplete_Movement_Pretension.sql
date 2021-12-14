 -- Function: lpComplete_Movement_Pretension (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Pretension (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Pretension(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbAccountId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbMovementIncome Integer;
BEGIN

    -- ����������
    SELECT Movement.OperDate,  MovementLinkObject_From.ObjectId, MLMovement_Income.MovementChildId
    INTO vbOperDate, vbUnitId, vbMovementIncome
    FROM Movement

         LEFT JOIN MovementLinkMovement AS MLMovement_Income
                                        ON MLMovement_Income.MovementId = Movement.Id
                                       AND MLMovement_Income.DescId = zc_MovementLinkMovement_Income()

         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

    WHERE Movement.Id = inMovementId;


    IF NOT EXISTS(SELECT 1
                  FROM MovementItem AS MI
                   
                       INNER JOIN MovementItemBoolean AS MIBoolean_Checked
                                                      ON MIBoolean_Checked.MovementItemId = MI.Id
                                                     AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                                                     AND MIBoolean_Checked.ValueData = True

                       INNER JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                    ON MIFloat_MovementItemId.MovementItemId = MI.Id
                                                   AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()
                                                    
                       LEFT JOIN MovementItemContainer AS MIContainer_Income
                                                       ON MIContainer_Income.MovementItemId = MIFloat_MovementItemId.ValueData::Integer
                                                      AND MIContainer_Income.MovementID = vbMovementIncome
                                                      AND MIContainer_Income.DescId = zc_MIContainer_Count()

                   WHERE MI.MovementId = inMovementId
                     AND MI.DescId = zc_MI_Master()
                     AND MI.Amount < 0
                     AND MI.isErased = FALSE)
    THEN
      RAISE EXCEPTION '��� ������ ��� ������� ���������';    
    END IF;
     
    IF EXISTS(SELECT 1
              FROM MovementItem AS MI
                   
                   INNER JOIN MovementItemBoolean AS MIBoolean_Checked
                                                  ON MIBoolean_Checked.MovementItemId = MI.Id
                                                 AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                                                 AND MIBoolean_Checked.ValueData = True

                   INNER JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                ON MIFloat_MovementItemId.MovementItemId = MI.Id
                                               AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()
                                                    
                   LEFT JOIN MovementItemContainer AS MIContainer_Income
                                                   ON MIContainer_Income.MovementItemId = MIFloat_MovementItemId.ValueData::Integer
                                                  AND MIContainer_Income.MovementID = vbMovementIncome
                                                  AND MIContainer_Income.DescId = zc_MIContainer_Count()

               WHERE MI.MovementId = inMovementId
                 AND MI.DescId = zc_MI_Master()
                 AND MI.Amount < 0
                 AND MI.isErased = FALSE
                 AND COALESCE (MIContainer_Income.Id, 0) = 0)
    THEN
      RAISE EXCEPTION '�� �� ���� �������� ���������� ������.';    
    END IF;

     -- �������� �������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;

    -- ����������
    vbAccountId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000()         -- ������
                                             , inAccountDirectionId     := zc_Enum_AccountDirection_20100()     -- C����
                                             , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200() -- �����������
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId);

    INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                      , ObjectId_analyzer, WhereObjectId_analyzer
                                       )
       -- ���������
       SELECT zc_MIContainer_Count()
            , zc_Movement_Pretension()
            , inMovementId
            , MI.Id
            , MIContainer_Income.ContainerId
            , vbAccountId
            , MI.Amount
            , vbOperDate
            , MI.ObjectId                    AS ObjectId_analyzer
            , vbUnitId                       AS WhereObjectId_analyzer
       FROM MovementItem AS MI
       
            INNER JOIN MovementItemBoolean AS MIBoolean_Checked
                                           ON MIBoolean_Checked.MovementItemId = MI.Id
                                          AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                                          AND MIBoolean_Checked.ValueData = True

            INNER JOIN MovementItemFloat AS MIFloat_MovementItemId
                                         ON MIFloat_MovementItemId.MovementItemId = MI.Id
                                        AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()
                                        
            LEFT JOIN MovementItemContainer AS MIContainer_Income
                                            ON MIContainer_Income.MovementItemId = MIFloat_MovementItemId.ValueData::Integer
                                           AND MIContainer_Income.MovementID = vbMovementIncome
                                           AND MIContainer_Income.DescId = zc_MIContainer_Count()
                                        
                                        
                                        


       WHERE MI.MovementId = inMovementId
         AND MI.DescId = zc_MI_Master()
         AND MI.Amount < 0
         AND MI.isErased = FALSE;

       -- �������� ���� ��������� ���������� ������
     IF EXISTS(SELECT 1 FROM Container WHERE Container.WhereObjectId = vbUnitId
                                         AND Container.DescId = zc_Container_CountPartionDate()
                                         AND Container.ParentId in (SELECT _tmpMIContainer_insert.ContainerId FROM _tmpMIContainer_insert))
     THEN

       WITH DD AS (
          SELECT
             _tmpMIContainer_insert.MovementItemId
           , Sum(_tmpMIContainer_insert.Amount) AS Amount
           , vbOperDate                         AS OperDate
           , Max(Container.Id)                  AS ContainerId
           FROM _tmpMIContainer_insert
                JOIN Container ON _tmpMIContainer_insert.ContainerId = Container.ParentId
           WHERE Container.DescId = zc_Container_CountPartionDate()
             AND Container.WhereObjectId = vbUnitId
           GROUP BY _tmpMIContainer_insert.MovementItemId
          )

         INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
           SELECT
                  zc_Container_CountPartionDate()
                , zc_Movement_Pretension()
                , inMovementId
                , tmpItem.MovementItemId
                , tmpItem.ContainerId
                , Null
                , tmpItem.Amount
                , OperDate
             FROM DD AS tmpItem;

     END IF;


     -- 5.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 14.12.21                                                       *
*/

-- ����
-- 