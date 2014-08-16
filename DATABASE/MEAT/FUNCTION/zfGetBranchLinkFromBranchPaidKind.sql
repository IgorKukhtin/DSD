-- Function: zfGetBranchFromUnitId

DROP FUNCTION IF EXISTS zfGetBranchLinkFromBranchPaidKind (INTEGER, Integer);

CREATE OR REPLACE FUNCTION zfGetBranchLinkFromBranchPaidKind(inBranchId Integer, inPaidKindId integer)
RETURNS Integer AS
$BODY$
BEGIN
  RETURN (SELECT Object_BranchLink_View.Id FROM Object_BranchLink_View
   WHERE Object_BranchLink_View.BranchId = inBranchId 
     AND ((Object_BranchLink_View.PaidKindId IS NULL) OR (Object_BranchLink_View.PaidKindId = inPaidKindId)));
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfGetBranchLinkFromBranchPaidKind (Integer, Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.08.14                        *  
 03.02.14                        *  
*/

-- тест
-- SELECT * FROM zfGetBranchFromUnitId (1)
