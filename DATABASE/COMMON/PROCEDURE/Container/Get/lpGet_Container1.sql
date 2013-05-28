-- Function: lpget_containerid(integer, integer)

-- DROP FUNCTION lpget_containerid(integer, integer);

CREATE OR REPLACE FUNCTION lpget_containerid(inContainerDescId integer, inAccountId integer)
  RETURNS integer AS
$BODY$DECLARE
  ContainerId Integer;
BEGIN
 SELECT Container.Id INTO ContainerId
   FROM Container
  WHERE Container.ObjectId = inAccountId
    AND Container.DescId = inContainerDescId;
  IF NOT FOUND THEN
     INSERT INTO Container (DescId, Amount, AccountId)
            VALUES (inContainerDescId, 0, inAccountId) RETURNING Id INTO ContainerId;
  END IF;  
  return ContainerId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 10;
ALTER FUNCTION lpget_containerid(integer, integer)
  OWNER TO postgres;
