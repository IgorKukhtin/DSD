-- Function: gpComplete_Movement_IncomeAdmin()

DROP FUNCTION IF EXISTS gpComplete_Movement_CheckAdmin (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_CheckAdmin (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_CheckAdmin (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_CheckAdmin(
    IN inMovementId        Integer              , -- ���� ���������
    IN inPaidType          Integer              , --��� ������ 0-������, 1-�����, 1-���������
    IN inCashRegisterId    Integer              , --� ��������� ��������
   OUT outMessageText      Text      ,
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS Text
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbPaidTypeId Integer;
  DECLARE vbOperDate    TDateTime;
  DECLARE vbUnit        Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Income());
    vbUserId:= inSession;
    
    IF NOT EXISTS(SELECT 1 
                  FROM 
                      Movement
                  WHERE
                      ID = inMovementId
                      AND
                      DescId = zc_Movement_Check()
                      AND
                      StatusId = zc_Enum_Status_Uncomplete()
                 )
    THEN
        RAISE EXCEPTION '������. �������� �� ��������, ���� �� ��������� � ��������� "�� ��������"!';
    END IF;
    
    -- ���������, ��� �� �� ���� ��������� ����� ���� ���������
    /*SELECT
        date_trunc('day', Movement.OperDate),
        Movement_Unit.ObjectId AS Unit
    INTO
        vbOperDate,
        vbUnit
    FROM Movement
        INNER JOIN MovementLinkObject AS Movement_Unit
                                      ON Movement_Unit.MovementId = Movement.Id
                                     AND Movement_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;

    IF EXISTS(SELECT 1
              FROM Movement AS Movement_Inventory
                  INNER JOIN MovementItem AS MI_Inventory
                                          ON MI_Inventory.MovementId = Movement_Inventory.Id
                                         AND MI_Inventory.DescId = zc_MI_Master()
                                         AND MI_Inventory.IsErased = FALSE
                  INNER JOIN MovementLinkObject AS Movement_Inventory_Unit
                                                ON Movement_Inventory_Unit.MovementId = Movement_Inventory.Id
                                               AND Movement_Inventory_Unit.DescId = zc_MovementLinkObject_Unit()
                                               AND Movement_Inventory_Unit.ObjectId = vbUnit
                  Inner Join MovementItem AS MI_Send
                                          ON MI_Inventory.ObjectId = MI_Send.ObjectId
                                         AND MI_Send.DescId = zc_MI_Master()
                                         AND MI_Send.IsErased = FALSE
                                         AND MI_Send.Amount > 0
                                         AND MI_Send.MovementId = inMovementId
                                         
              WHERE
                  Movement_Inventory.DescId = zc_Movement_Inventory()
                  AND
                  Movement_Inventory.OperDate >= vbOperDate
                  AND
                  Movement_Inventory.StatusId = zc_Enum_Status_Complete()
              )
    THEN
        RAISE EXCEPTION '������. �� ������ ��� ����� ������� ���� �������� ��������� ����� ���� ������� �������. ���������� ��������� ���������!';
    END IF; */   
    
    -- ��������� ����� � ��� ������
    if inPaidType = 0 THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType(),inMovementId,zc_Enum_PaidType_Cash());
    ELSEIF inPaidType = 1 THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType(),inMovementId,zc_Enum_PaidType_Card());
    ELSEIF inPaidType = 2 THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType() ,inMovementId, zc_Enum_PaidType_CardAdd());
    ELSE
        RAISE EXCEPTION '������.�� ��������� ��� ������ %', inPaidType;
    END IF;

    -- ��������� ����� � �������� ���������
    IF inCashRegisterId <> 0 THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CashRegister(),inMovementId,inCashRegisterId);
    END IF;

    -- ����������� �������� �����
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

    -- ����������� ��������
    outMessageText:= lpComplete_Movement_Check (inMovementId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpComplete_Movement_CheckAdmin (Integer,Integer, Integer, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������ �.�.
 22.11.14                                                                                    *
 07.08.15                                                                       *
 
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')
