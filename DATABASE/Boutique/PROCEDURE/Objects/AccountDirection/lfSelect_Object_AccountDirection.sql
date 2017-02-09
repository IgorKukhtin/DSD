-- Function: lfSelect_Object_AccountDirection ()

-- DROP FUNCTION lfSelect_Object_AccountDirection ();

CREATE OR REPLACE FUNCTION lfSelect_Object_AccountDirection()

RETURNS TABLE (AccountGroupId Integer, AccountGroupCode Integer, AccountGroupName TVarChar, 
               AccountDirectionId Integer, AccountDirectionCode Integer, AccountDirectionName TVarChar) AS
   
$BODY$BEGIN

     -- Выбираем и группируем данные из справочника Аналитики счетов - направления (по двум справочникам)

     RETURN QUERY 
     
      SELECT 
		    lfObject_Account.AccountGroupId         AS AccountGroupId
		  , lfObject_Account.AccountGroupCode       AS AccountGroupCode
		  , lfObject_Account.AccountGroupName       AS AccountGroupName
		  , lfObject_Account.AccountDirectionId     AS AccountDirectionId
		  , lfObject_Account.AccountDirectionCode   AS AccountDirectionCode
		  , lfObject_Account.AccountDirectionName   AS AccountDirectionName
     
      FROM lfSelect_Object_Account() AS lfObject_Account              

      GROUP BY lfObject_Account.AccountGroupId, lfObject_Account.AccountGroupCode, lfObject_Account.AccountGroupName
             , lfObject_Account.AccountDirectionId, lfObject_Account.AccountDirectionCode, lfObject_Account.AccountDirectionName;

 
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfSelect_Object_AccountDirection() OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.06.13          *                            

*/

-- тест
-- SELECT * FROM lfSelect_Object_AccountDirection()
