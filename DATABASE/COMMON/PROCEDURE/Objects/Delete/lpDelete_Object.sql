-- Function: lpDelete_Object(integer, tvarchar)

-- DROP FUNCTION lpDelete_Object(integer, tvarchar);

CREATE OR REPLACE FUNCTION lpDelete_Object(
IN inId integer, 
IN Session tvarchar)
  RETURNS void AS
$BODY$BEGIN

  DELETE FROM ObjectLink WHERE ObjectId = inId;
  DELETE FROM ObjectLink WHERE ChildObjectId = inId;
  DELETE FROM ObjectString WHERE ObjectId = inId;
  DELETE FROM Object WHERE Id = inId;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpDelete_Object(integer, tvarchar)
  OWNER TO postgres;