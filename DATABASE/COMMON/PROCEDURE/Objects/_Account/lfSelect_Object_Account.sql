-- Function: lfSelect_Object_Account ()

-- DROP FUNCTION lfSelect_Object_Account ();

CREATE OR REPLACE FUNCTION lfSelect_Object_Account()

RETURNS TABLE (AccountGroupId Integer, AccountGroupCode Integer, AccountGroupName TVarChar, 
               AccountDirectionId Integer, AccountDirectionCode Integer, AccountDirectionName TVarChar, 
               AccountId Integer, AccountCode Integer, AccountName TVarChar) AS
   
$BODY$BEGIN

     -- Выбираем данные для справочника счетов (на самом деле это три справочника)
     RETURN QUERY 
     SELECT 
           Object_AccountGroup.Id            AS AccountGroupId
          ,Object_AccountGroup.ObjectCode    AS AccountGroupCode
          ,Object_AccountGroup.ValueData     AS AccountGroupName
          
          ,Object_AccountDirection.Id           AS AccountDirectionId
          ,Object_AccountDirection.ObjectCode   AS AccountDirectionCode
          ,Object_AccountDirection.ValueData    AS AccountDirectionName
          
          ,Object_Account.Id           AS AccountId
          ,Object_Account.ObjectCode   AS AccountCode
          ,Object_Account.ValueData    AS AccountName
          
     FROM Object AS Object_Account
       
     LEFT JOIN ObjectLink AS ObjectLink_Account_AccountGroup
            ON ObjectLink_Account_AccountGroup.ObjectId = Object_Account.Id 
           AND ObjectLink_Account_AccountGroup.DescId = zc_ObjectLink_Account_AccountGroup()
     LEFT JOIN Object AS Object_AccountGroup ON Object_AccountGroup.Id = ObjectLink_Account_AccountGroup.ChildObjectId

     LEFT JOIN ObjectLink AS ObjectLink_Account_AccountDirection
            ON ObjectLink_Account_AccountDirection.ObjectId = Object_Account.Id 
           AND ObjectLink_Account_AccountDirection.DescId = zc_ObjectLink_Account_AccountDirection()
     LEFT JOIN Object AS Object_AccountDirection ON Object_AccountDirection.Id = ObjectLink_Account_AccountDirection.ChildObjectId

     WHERE Object_Account.DescId = zc_Object_Account();
          
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfSelect_Object_Account () OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.06.13          *                            
*/
-- тест
-- SELECT * FROM lfSelect_Object_Account()
