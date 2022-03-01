-- Function: lfSelect_Object_Cash_byGroup (Integer)

-- DROP FUNCTION lfSelect_Object_Cash_byGroup (Integer);

CREATE OR REPLACE FUNCTION lfSelect_Object_Cash_byGroup (IN inCashId Integer)
RETURNS TABLE (CashId Integer)  
AS
$BODY$
BEGIN

     -- Выбираем данные
     RETURN QUERY
     
     WITH RECURSIVE RecurObjectLink (ObjectId) AS
       (SELECT inCashId
       UNION
        SELECT ObjectLink.ObjectId
        FROM ObjectLink
             INNER JOIN RecurObjectLink ON RecurObjectLink.ObjectId = ObjectLink.ChildObjectId
        WHERE ObjectLink.DescId = zc_ObjectLink_Cash_Parent()
       ) 
     SELECT ObjectId AS CashId FROM RecurObjectLink;
     
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfSelect_Object_Cash_byGroup (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.05.13                                        * вроде работает правильно)))             
*/

-- тест
-- SELECT * FROM lfSelect_Object_Cash_byGroup (8465) AS lfSelect_Object_Cash_byGroup JOIN Object_Cash_View ON Object_Cash_View.Id = lfSelect_Object_Cash_byGroup.CashId ORDER BY 4
-- SELECT * FROM lfSelect_Object_Cash_byGroup (8453) AS lfSelect_Object_Cash_byGroup JOIN Object_Cash_View ON Object_Cash_View.Id = lfSelect_Object_Cash_byGroup.CashId ORDER BY 4

