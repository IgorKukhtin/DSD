-- Function: gp_test_insert3(tvarchar)

-- DROP FUNCTION gp_test_insert3(tvarchar);

CREATE OR REPLACE FUNCTION gp_test_insert3(inDocNumber TVarChar, inUnitTo integer, inUnitFrom Integer, inGoodId integer, inAmount TFloat, session tvarchar)
  RETURNS void AS
$BODY$DECLARE
  MovementId Integer;   
  FContainerId Integer;
BEGIN
           MovementId := lpInsertUpdate_Movement(0, zc_Movement_Transfer(), inDocNumber, current_date);

           FContainerId := lpGet_ContainerId(zc_Container_Money(), inUnitFrom, zc_ContainerLinkObject_Unit(), inGoodId, zc_ContainerLinkObject_Goods()); 

           PERFORM lpInsertUpdate_MovementItemContainer(0, zc_MovementItemContainer_Money(), MovementId, FContainerId, inAmount);

           PERFORM lpInsertUpdate_MovementLinkObject(zc_Movement_Link_UnitTo(), MovementId, inUnitTo);

            FContainerId := lpGet_ContainerId(zc_Container_Money(), inUnitTo, zc_ContainerLinkObject_Unit(), inGoodId, zc_ContainerLinkObject_Goods());

           PERFORM lpInsertUpdate_MovementLinkObject(zc_Movement_Link_UnitFrom(), MovementId, inUnitFrom);
           PERFORM lpInsertUpdate_MovementItemContainer(0, zc_MovementItemContainer_Money(), MovementId, FContainerId, inAmount);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gp_test_insert3(TVarChar, integer, Integer, integer, TFloat, tvarchar)
  OWNER TO postgres;
