-- Function: lpget_containerid(integer, integer, integer, integer, integer)

-- DROP FUNCTION lpget_containerid(integer, integer, integer, integer, integer);

CREATE OR REPLACE FUNCTION lpget_containerid(incontainerdescid integer, inobjectid1 integer, indescid1 integer, inobjectid2 integer, indescid2 integer)
  RETURNS integer AS
$BODY$DECLARE
  lContainerId Integer;
BEGIN
  SELECT ContainerLinkObject1.ContainerId INTO lContainerId
  FROM ContainerLinkObject ContainerLinkObject1
  JOIN ContainerLinkObject ContainerLinkObject2
    ON ContainerLinkObject2.ContainerId = ContainerLinkObject1.ContainerId
   AND ContainerLinkObject2.ObjectId = inObjectId2
   AND ContainerLinkObject2.DescId = inDescId2
 WHERE ContainerLinkObject1.ObjectId = inObjectId1
   AND ContainerLinkObject1.DescId = inDescId1;
 IF NOT FOUND THEN
    INSERT INTO Container (DescId, Amount)
            VALUES (inContainerDescId, 0) RETURNING Id INTO lContainerId;

    INSERT INTO ContainerLinkObject(DescId, ContainerId, ObjectId)
           VALUES (inDescId1, lContainerId, inObjectId1);
    INSERT INTO ContainerLinkObject(DescId, ContainerId, ObjectId)
           VALUES (inDescId2, lContainerId, inObjectId2);
 END IF;  
  return lContainerId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 10;
ALTER FUNCTION lpget_containerid(integer, integer, integer, integer, integer)
  OWNER TO postgres;
