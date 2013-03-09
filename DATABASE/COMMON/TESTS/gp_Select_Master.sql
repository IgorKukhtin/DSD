-- Function: gp_Select_Master()

-- DROP FUNCTION gp_Select_Master();

CREATE OR REPLACE FUNCTION gp_Select_Master(Session TVarChar)
  RETURNS TABLE(Amount TFloat, ValueData TVarChar) AS
$BODY$BEGIN

RETURN QUERY select MovementItemContainer.Amount, Object.ValueData from Movement  
join MovementItemContainer
on Movement.Id  =  MovementItemContainer.MovementId 
and MovementItemContainer.Descid = 1 
join ContainerLinkObject
  on ContainerLinkObject.ContainerId = MovementItemContainer.ContainerId
 AND ContainerLinkObject.DescId =  zc_containerlinkobject_goods()
 JOIN Object 
 ON Object.Id = ContainerLinkObject.ObjectId

where Movement.Id between 210000 and 212500;


END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 5000;
ALTER FUNCTION gp_Select_Master(TVarChar)
  OWNER TO postgres;

--SELECT * FROM gp_Select_Master('') 