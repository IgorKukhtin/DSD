-- Function: lfSelect_Object_ProfitLossDirection ()

-- DROP FUNCTION lfSelect_Object_ProfitLossDirection ();

CREATE OR REPLACE FUNCTION lfSelect_Object_ProfitLossDirection()

RETURNS TABLE (ProfitLossGroupId Integer, ProfitLossGroupCode Integer, ProfitLossGroupName TVarChar, 
               ProfitLossDirectionId Integer, ProfitLossDirectionCode Integer, ProfitLossDirectionName TVarChar) AS
   
$BODY$BEGIN

     -- Выбираем и группируем данные из справочника 
     RETURN QUERY 
     
      SELECT 
		    lfObject_ProfitLoss.ProfitLossGroupId         AS ProfitLossGroupId
		  , lfObject_ProfitLoss.ProfitLossGroupCode       AS ProfitLossGroupCode
		  , lfObject_ProfitLoss.ProfitLossGroupName       AS ProfitLossGroupName
		  , lfObject_ProfitLoss.ProfitLossDirectionId     AS ProfitLossDirectionId
		  , lfObject_ProfitLoss.ProfitLossDirectionCode   AS ProfitLossDirectionCode
		  , lfObject_ProfitLoss.ProfitLossDirectionName   AS ProfitLossDirectionName
     
      FROM lfSelect_Object_ProfitLoss() AS lfObject_ProfitLoss              

      GROUP BY lfObject_ProfitLoss.ProfitLossGroupId, lfObject_ProfitLoss.ProfitLossGroupCode, lfObject_ProfitLoss.ProfitLossGroupName
             , lfObject_ProfitLoss.ProfitLossDirectionId, lfObject_ProfitLoss.ProfitLossDirectionCode, lfObject_ProfitLoss.ProfitLossDirectionName;

 
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfSelect_Object_ProfitLossDirection() OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.08.13                                        * 1251Cyr
 29.06.13          *

*/

-- тест
-- SELECT * FROM lfSelect_Object_ProfitLossDirection()
