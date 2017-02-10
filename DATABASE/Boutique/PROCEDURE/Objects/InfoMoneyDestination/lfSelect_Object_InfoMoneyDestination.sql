-- Function: lfSelect_Object_InfoMoneyDestination ()

-- DROP FUNCTION IF EXISTS lfSelect_Object_InfoMoneyDestination ();

CREATE OR REPLACE FUNCTION lfSelect_Object_InfoMoneyDestination()

RETURNS TABLE (InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar, 
               InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar) AS
   
$BODY$BEGIN

     -- Выбираем и группируем данные из справочника уп-назначения (по двум справочникам)

     RETURN QUERY 
     
      SELECT 
		    lfObject_InfoMoney.InfoMoneyGroupId           AS InfoMoneyGroupId
		  , lfObject_InfoMoney.InfoMoneyGroupCode         AS InfoMoneyGroupCode
		  , lfObject_InfoMoney.InfoMoneyGroupName         AS InfoMoneyGroupName
		  , lfObject_InfoMoney.InfoMoneyDestinationId     AS InfoMoneyDestinationId
		  , lfObject_InfoMoney.InfoMoneyDestinationCode   AS InfoMoneyDestinationCode
		  , lfObject_InfoMoney.InfoMoneyDestinationName   AS InfoMoneyDestinationName
     
      FROM lfSelect_Object_InfoMoney() AS lfObject_InfoMoney              

      GROUP BY lfObject_InfoMoney.InfoMoneyGroupId, lfObject_InfoMoney.InfoMoneyGroupCode, lfObject_InfoMoney.InfoMoneyGroupName
             , lfObject_InfoMoney.InfoMoneyDestinationId, lfObject_InfoMoney.InfoMoneyDestinationCode, lfObject_InfoMoney.InfoMoneyDestinationName;

 
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfSelect_Object_InfoMoneyDestination() OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.06.13          *                            

*/

-- тест
-- SELECT * FROM lfSelect_Object_InfoMoneyDestination()
