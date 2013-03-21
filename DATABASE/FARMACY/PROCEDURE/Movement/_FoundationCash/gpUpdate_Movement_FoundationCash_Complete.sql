-- Function: gpUpdate_Movement_FoundationCash_Complete(Integer, tvarchar)

-- DROP FUNCTION gpUpdate_Movement_FoundationCash_Complete(Integer, tvarchar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_FoundationCash_Complete(IN inMovementId Integer, Session tvarchar)
  RETURNS boolean AS
$BODY$
DECLARE
  ContainerId Integer;
  CashId Integer;
  Summ TFloat;
  MovementOperDate TDateTime;
BEGIN
  SELECT MovementFloat.Value, MovementLinkObject.ObjectId, Movement.OperDate INTO Summ, CashId, MovementOperDate
  FROM Movement
  JOIN MovementFloat 
    ON MovementFloat.MovementId = Movement.Id AND MovementFloat.DescId = zc_Movement_Float_Summ()
  JOIN MovementLinkObject 
    ON MovementLinkObject.MovementId = Movement.Id AND MovementLinkObject.DescId = zc_Movement_Link_Cash()
  WHERE Movement.Id = inMovementId;
  -- 
  ContainerId := lpGet_ContainerId(zc_Container_Money(), zc_Object_AccountPlan_Foundation(), zc_ContainerLinkObject_Account()); 
  PERFORM lpInsertUpdate_MovementItemContainer(0, zc_MovementItemContainer_Money(), inMovementId, ContainerId, Summ, MovementOperDate);

  ContainerId := lpGet_ContainerId(zc_Container_Money(), zc_Object_AccountPlan_Cash(), zc_ContainerLinkObject_Account(), CashId, zc_ContainerLinkObject_Cash()); 
  PERFORM lpInsertUpdate_MovementItemContainer(0, zc_MovementItemContainer_Money(), inMovementId, ContainerId, -Summ, MovementOperDate);

  -- Обязательно меняем статус документа
  UPDATE Movement SET StatusId = zc_Object_Status_Complete() WHERE Id = inMovementId;

  RETURN true;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpUpdate_Movement_FoundationCash_Complete(Integer, tvarchar)
  OWNER TO postgres;
