-- Function: gpUpdateObjectIsErased(integer, tvarchar)

-- DROP FUNCTION gpUpdateObjectIsErased(integer, tvarchar);

CREATE OR REPLACE FUNCTION gpUpdateObjectIsErased(
IN inObjectId integer, 
IN Session TVarChar)
  RETURNS void AS
$BODY$BEGIN

   UPDATE Object SET isErased = NOT isErased
    WHERE Id = inObjectId;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpUpdateObjectIsErased(integer, tvarchar)
  OWNER TO postgres;