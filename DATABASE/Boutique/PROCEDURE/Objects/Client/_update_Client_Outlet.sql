-- SELECT  lpInsertUpdate_ObjectLink (zc_ObjectLink_Client_InsertUnit(), 238347, 1533) -- *
-- SELECT  lpInsertUpdate_ObjectLink (zc_ObjectLink_Client_InsertUnit(), ClientId2, minUnitId2) -- *
-- from (
-- SELECT ClientId2, min (UnitId2) as minUnitId2
-- from (
SELECT distinct Object_Client.*, Object_Unit_ins.*, Object_Unit.*
     , Object_Client.Id as ClientId2, Object_Unit.Id as UnitId2
     -- , lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Client_Outlet(), Object_Client.Id, true ) -- *
FROM Object AS Object_Client
            LEFT JOIN ObjectLink AS ObjectLink_Client_InsertUnit
                                 ON ObjectLink_Client_InsertUnit.ObjectId = Object_Client.Id
                                AND ObjectLink_Client_InsertUnit.DescId   = zc_ObjectLink_Client_InsertUnit()
            left join Object AS Object_Unit_ins on Object_Unit_ins.Id = ObjectLink_Client_InsertUnit.ChildObjectId

/*
                           INNER JOIN ContainerLinkObject AS CLO_Client
                                                          ON CLO_Client.ObjectId = Object_Client.Id
                                                         AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                           INNER JOIN Container on Container.Id = CLO_Client.ContainerId 
                                              and Container.Amount <> 0

                           INNER JOIN ContainerLinkObject AS CLO_Unit
                                                          ON CLO_Unit.ContainerId = Container.Id
                                                         AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
 left join Object AS Object_Unit on Object_Unit.Id = CLO_Unit.ObjectId
 left join lfSelect_Object_Unit_isOutlet() AS lfSelect2 on lfSelect2.UnitId = CLO_Unit.ObjectId
*/

-- join lfSelect_Object_Unit_isOutlet() AS lfSelect on lfSelect.UnitId = ObjectLink_Client_InsertUnit.ChildObjectId
 left join lfSelect_Object_Unit_isOutlet() AS lfSelect on lfSelect.UnitId = ObjectLink_Client_InsertUnit.ChildObjectId


 join MovementLinkObject AS MLO
                         ON MLO.ObjectId = Object_Client.Id
                        AND MLO.DescId   = zc_MovementLinkObject_To()
 join Movement ON Movement.Id = MLO.MovementId
              and Movement.StatusId = zc_Enum_Status_Complete()
              and Movement.OperDate >= '01.11.2017'
 join MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                    AND MLO_From.DescId     = zc_MovementLinkObject_From()
 left join Object AS Object_Unit on Object_Unit.Id = MLO_From.ObjectId
 left join lfSelect_Object_Unit_isOutlet() AS lfSelect2 on lfSelect2.UnitId = MLO_From.ObjectId

WHERE Object_Client.DescId = zc_Object_Client()
-- AND ObjectLink_Client_InsertUnit.ChildObjectId is null
 and lfSelect2.UnitId > 0
 and lfSelect.UnitId is null
order by 4

-- ) as a
-- group by ClientId2
-- ) as a