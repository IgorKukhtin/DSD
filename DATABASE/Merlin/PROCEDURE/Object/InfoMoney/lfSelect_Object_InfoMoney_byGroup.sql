-- Function: lfSelect_Object_InfoMoney_byGroup (Integer)

-- DROP FUNCTION lfSelect_Object_InfoMoney_byGroup (Integer);

CREATE OR REPLACE FUNCTION lfSelect_Object_InfoMoney_byGroup (IN inInfoMoneyId Integer)
RETURNS TABLE (InfoMoneyId Integer)  
AS
$BODY$
BEGIN

     -- Выбираем данные
     RETURN QUERY
     
     WITH RECURSIVE RecurObjectLink (ObjectId) AS
       (SELECT inInfoMoneyId
       UNION
        SELECT ObjectLink.ObjectId
        FROM ObjectLink
             INNER JOIN RecurObjectLink ON RecurObjectLink.ObjectId = ObjectLink.ChildObjectId
        WHERE ObjectLink.DescId = zc_ObjectLink_InfoMoney_Parent()
       ) 
     SELECT ObjectId AS InfoMoneyId FROM RecurObjectLink;
     
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfSelect_Object_InfoMoney_byGroup (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 31.05.22         *
*/

-- тест
-- SELECT * FROM lfSelect_Object_InfoMoney_byGroup (8465) AS lfSelect_Object_InfoMoney_byGroup JOIN Object_InfoMoney_View ON Object_InfoMoney_View.Id = lfSelect_Object_InfoMoney_byGroup.InfoMoneyId ORDER BY 4
