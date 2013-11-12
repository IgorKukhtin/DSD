DROP FUNCTION IF EXISTS lfGetParams(TVarChar, TVarChar);
DROP FUNCTION IF EXISTS lfGetParams(TVarChar);

CREATE OR REPLACE FUNCTION lfGetParams(IN inStoredProcName TVarChar, IN inSession TVarChar) 
RETURNS TABLE(Name TVarChar, Mode TVarChar, TypeName TVarChar)
AS $BODY$
BEGIN
  RETURN QUERY
    SELECT parameter_name::TVarChar, parameter_mode::TVarChar, parameters.udt_name::TVarChar
     FROM information_schema.routines
     JOIN information_schema.parameters ON routines.specific_name = parameters.specific_name
    WHERE routines.routine_name = lower(inStoredProcName)
 ORDER BY ordinal_position;

END;
$BODY$LANGUAGE plpgsql;