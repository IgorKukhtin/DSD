-- View: _bi_Guide_Account_View

 DROP VIEW IF EXISTS _bi_Guide_Account_View;

-- Справочник Счета
CREATE OR REPLACE VIEW _bi_Guide_Account_View
AS
       SELECT
             Object_Account.Id         AS Id
           , Object_Account.ObjectCode AS Code
           , Object_Account.ValueData  AS Name
           --
           , CAST ((CASE WHEN Object_Account.ObjectCode < 100000 THEN '' ELSE '' END || Object_Account.ObjectCode || ' ' || Object_Account.ValueData) AS TVarChar) AS AccountName
           --полное наименование
           , CAST (CASE WHEN Object_Account.ObjectCode < 100000
                             THEN '0'
                        ELSE ''
                   END
                || Object_Account.ObjectCode || ' '
                || Object_AccountGroup.ValueData
                || CASE WHEN Object_AccountDirection.ValueData <> Object_AccountGroup.ValueData
                             THEN ' ' || Object_AccountDirection.ValueData
                        ELSE ''
                   END
                || CASE WHEN Object_Account.ValueData <> Object_AccountDirection.ValueData
                             THEN ' ' || Object_Account.ValueData
                        ELSE ''
                   END
                   AS TVarChar) AS AccountName_all
           -- Признак "Удален да/нет"
           , Object_Account.isErased   AS isErased
           --Группа счетов
           , Object_AccountGroup.Id            AS AccountGroupId
           , Object_AccountGroup.ObjectCode    AS AccountGroupCode
           , CAST ((CASE WHEN Object_AccountGroup.ObjectCode < 100000 THEN '0' ELSE '' END || Object_AccountGroup.ObjectCode || ' ' || Object_AccountGroup.ValueData) AS TVarChar) AS AccountGroupName
           , Object_AccountGroup.ValueData     AS AccountGroupName_original
           --Аналитики счетов - направления
           , Object_AccountDirection.Id           AS AccountDirectionId
           , Object_AccountDirection.ObjectCode   AS AccountDirectionCode
           , CAST ((CASE WHEN Object_AccountDirection.ObjectCode < 100000 THEN '' ELSE '' END || Object_AccountDirection.ObjectCode || ' ' || Object_AccountDirection.ValueData) AS TVarChar) AS AccountDirectionName
           , Object_AccountDirection.ValueData    AS AccountDirectionName_original
           --Статьи назначения - группа
           , COALESCE (View_InfoMoneyDestination.InfoMoneyGroupId, Object_InfoMoney_View.InfoMoneyGroupId)     AS InfoMoneyGroupId
           , COALESCE (View_InfoMoneyDestination.InfoMoneyGroupCode, Object_InfoMoney_View.InfoMoneyGroupCode) AS InfoMoneyGroupCode
           , COALESCE (View_InfoMoneyDestination.InfoMoneyGroupName, Object_InfoMoney_View.InfoMoneyGroupName) AS InfoMoneyGroupName
           --Управленческие назначения
           , COALESCE (View_InfoMoneyDestination.InfoMoneyDestinationId, Object_InfoMoney_View.InfoMoneyDestinationId)     AS InfoMoneyDestinationId
           , COALESCE (View_InfoMoneyDestination.InfoMoneyDestinationCode, Object_InfoMoney_View.InfoMoneyDestinationCode) AS InfoMoneyDestinationCode
           , COALESCE (View_InfoMoneyDestination.InfoMoneyDestinationName, Object_InfoMoney_View.InfoMoneyDestinationName) AS InfoMoneyDestinationName
           --Статьи назначения
           , Object_InfoMoney_View.InfoMoneyId     AS InfoMoneyId
           , Object_InfoMoney_View.InfoMoneyCode   AS InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName   AS InfoMoneyName
           --Типы Счетов
           , Object_AccountKind.Id          AS AccountKindId
           , Object_AccountKind.ObjectCode  AS AccountKindCode
           , Object_AccountKind.ValueData   AS AccountKindName
           --Создан при проведении
           , ObjectBoolean_onComplete.ValueData AS onComplete
           --Показать развернутым при печати
           , COALESCE (ObjectBoolean_PrintDetail.ValueData, FALSE) :: Boolean AS isPrintDetail

       FROM Object AS Object_Account
            --Группа счетов
            LEFT JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                                 ON ObjectLink_Account_AccountGroup.ObjectId = Object_Account.Id 
                                AND ObjectLink_Account_AccountGroup.DescId = zc_ObjectLink_Account_AccountGroup()
            LEFT JOIN Object AS Object_AccountGroup ON Object_AccountGroup.Id = ObjectLink_Account_AccountGroup.ChildObjectId
            --Аналитики счетов - направления
            LEFT JOIN ObjectLink AS ObjectLink_Account_AccountDirection
                                 ON ObjectLink_Account_AccountDirection.ObjectId = Object_Account.Id 
                                AND ObjectLink_Account_AccountDirection.DescId = zc_ObjectLink_Account_AccountDirection()
            LEFT JOIN Object AS Object_AccountDirection ON Object_AccountDirection.Id = ObjectLink_Account_AccountDirection.ChildObjectId
            --Управленческие назначения
            LEFT JOIN ObjectLink AS ObjectLink_Account_InfoMoneyDestination
                                 ON ObjectLink_Account_InfoMoneyDestination.ObjectId = Object_Account.Id
                                AND ObjectLink_Account_InfoMoneyDestination.DescId = zc_ObjectLink_Account_InfoMoneyDestination()
            --Статьи назначения
            LEFT JOIN ObjectLink AS ObjectLink_Account_InfoMoney
                                 ON ObjectLink_Account_InfoMoney.ObjectId = Object_Account.Id
                                AND ObjectLink_Account_InfoMoney.DescId = zc_ObjectLink_Account_InfoMoney()

            LEFT JOIN Object_InfoMoneyDestination_View AS View_InfoMoneyDestination ON View_InfoMoneyDestination.InfoMoneyDestinationId = ObjectLink_Account_InfoMoneyDestination.ChildObjectId
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Account_InfoMoneyDestination.ChildObjectId
            --Создан при проведении
            LEFT JOIN ObjectBoolean AS ObjectBoolean_onComplete
                                    ON ObjectBoolean_onComplete.ObjectId = Object_Account.Id 
                                   AND ObjectBoolean_onComplete.DescId = zc_ObjectBoolean_Account_onComplete()
            --Показать развернутым при печати
            LEFT JOIN ObjectBoolean AS ObjectBoolean_PrintDetail
                                    ON ObjectBoolean_PrintDetail.ObjectId = Object_Account.Id 
                                   AND ObjectBoolean_PrintDetail.DescId = zc_ObjectBoolean_Account_PrintDetail()
            --Типы Счетов
            LEFT JOIN ObjectLink AS ObjectLink_Account_AccountKind
                                 ON ObjectLink_Account_AccountKind.ObjectId = Object_Account.Id
                                AND ObjectLink_Account_AccountKind.DescId = zc_ObjectLink_Account_AccountKind()
            LEFT JOIN Object AS Object_AccountKind ON Object_AccountKind.Id = ObjectLink_Account_AccountKind.ChildObjectId

       WHERE Object_Account.DescId = zc_Object_Account()
      ;

ALTER TABLE _bi_Guide_Account_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.05.25         * all
 09.05.25                                        *
*/

-- тест
-- SELECT * FROM _bi_Guide_Account_View
