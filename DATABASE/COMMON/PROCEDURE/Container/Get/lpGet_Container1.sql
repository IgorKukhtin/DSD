-- Function: lpget_containerid(integer, integer, integer)

-- DROP FUNCTION lpget_containerid(integer, integer, integer);

CREATE OR REPLACE FUNCTION lpget_containerid(incontainerdescid integer, inobjectid1 integer, indescid1 integer)
  RETURNS integer AS
$BODY$DECLARE
  lContainerId Integer;
BEGIN
  SELECT ContainerLinkObject1.ContainerId INTO lContainerId
  FROM ContainerLinkObject ContainerLinkObject1
 WHERE ContainerLinkObject1.ObjectId = inObjectId1
   AND ContainerLinkObject1.DescId = inDescId1;
 IF NOT FOUND THEN
    INSERT INTO Container (DescId, Amount)
            VALUES (inContainerDescId, 0) RETURNING Id INTO lContainerId;

    INSERT INTO ContainerLinkObject(DescId, ContainerId, ObjectId)
           VALUES (inDescId1, lContainerId, inObjectId1);
 END IF;  
  return lContainerId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 10;
ALTER FUNCTION lpget_containerid(integer, integer, integer)
  OWNER TO postgres;
