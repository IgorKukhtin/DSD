-- Function: gp_test_insert1(tvarchar)

-- DROP FUNCTION gp_test_insert1(tvarchar);

CREATE OR REPLACE FUNCTION gp_test_insert1(session tvarchar)
  RETURNS boolean AS
$BODY$DECLARE
  k INTEGER := 0;
  MovementId Integer;   
  MinUnitObjectId Integer;
  MaxUnitObjectId Integer;
  MinGoodObjectId Integer;
  MaxGoodObjectId Integer;
  UnitId Integer; 
  GoodId Integer;
  FContainerId Integer;
BEGIN
  SELECT MIN(Id) INTO MinUnitObjectId  FROM Object WHERE DescId = zc_Object_Unit();
  SELECT MAX(Id) INTO MaxUnitObjectId  FROM Object WHERE DescId = zc_Object_Unit();
  SELECT MIN(Id) INTO MinGoodObjectId  FROM Object WHERE DescId = zc_Object_Good();
  SELECT MAX(Id) INTO MaxGoodObjectId  FROM Object WHERE DescId = zc_Object_Good();
   
	WHILE (k < 5000) LOOP
         BEGIN
           GoodId := trunc(MinGoodObjectId + random() * (MaxGoodObjectId - MinGoodObjectId)); 

	   k := k + 1;
           MovementId := lpInsertUpdate_Movement(0, zc_Movement_Transfer(), k::varchar, current_date);

           UnitId := trunc(MinUnitObjectId + random() * (MaxUnitObjectId - MinUnitObjectId)); 
           FContainerId := lpGet_ContainerId(zc_Container_Money(), UnitId, zc_ContainerLinkObject_Unit(), GoodId, zc_ContainerLinkObject_Goods()); 

           PERFORM lpInsertUpdate_MovementItemContainer(0, zc_MovementItemContainer_Money(), MovementId, FContainerId, (random() * 1000)::TFloat);

           PERFORM lpInsertUpdate_MovementLinkObject(zc_Movement_Link_UnitTo(), MovementId, UnitId);

           UnitId := trunc(MinUnitObjectId + random() * (MaxUnitObjectId - MinUnitObjectId)); 
           FContainerId := lpGet_ContainerId(zc_Container_Money(), UnitId, zc_ContainerLinkObject_Unit(), GoodId, zc_ContainerLinkObject_Goods());

           PERFORM lpInsertUpdate_MovementLinkObject(zc_Movement_Link_UnitFrom(), MovementId, UnitId);
           PERFORM lpInsertUpdate_MovementItemContainer(0, zc_MovementItemContainer_Money(), MovementId, FContainerId, (random() * 1000)::TFloat);
         EXCEPTION  WHEN others THEN  END;
	END LOOP;

  return true;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gp_test_insert1(tvarchar)
  OWNER TO postgres;
