-- View: Object_Account_View

DROP VIEW IF EXISTS Object_Account_View CASCADE;

CREATE OR REPLACE VIEW Object_Account_View AS
         SELECT 
             Object_AccountGroup.Id            AS AccountGroupId
           , Object_AccountGroup.ObjectCode    AS AccountGroupCode
           , Object_AccountGroup.ValueData     AS AccountGroupName
          
           , Object_AccountDirection.Id           AS AccountDirectionId
           , Object_AccountDirection.ObjectCode   AS AccountDirectionCode
           , Object_AccountDirection.ValueData    AS AccountDirectionName
          
           , Object_Account.Id           AS AccountId
           , Object_Account.ObjectCode   AS AccountCode
           , Object_Account.ValueData    AS AccountName
          
           , COALESCE (View_InfoMoneyDestination.InfoMoneyGroupId, Object_InfoMoney_View.InfoMoneyGroupId)     AS InfoMoneyGroupId
           , COALESCE (View_InfoMoneyDestination.InfoMoneyGroupCode, Object_InfoMoney_View.InfoMoneyGroupCode) AS InfoMoneyGroupCode
           , COALESCE (View_InfoMoneyDestination.InfoMoneyGroupName, Object_InfoMoney_View.InfoMoneyGroupName) AS InfoMoneyGroupName

           , COALESCE (View_InfoMoneyDestination.InfoMoneyDestinationId, Object_InfoMoney_View.InfoMoneyDestinationId)     AS InfoMoneyDestinationId
           , COALESCE (View_InfoMoneyDestination.InfoMoneyDestinationCode, Object_InfoMoney_View.InfoMoneyDestinationCode) AS InfoMoneyDestinationCode
           , COALESCE (View_InfoMoneyDestination.InfoMoneyDestinationName, Object_InfoMoney_View.InfoMoneyDestinationName) AS InfoMoneyDestinationName

           , Object_InfoMoney_View.InfoMoneyId     AS InfoMoneyId
           , Object_InfoMoney_View.InfoMoneyCode   AS InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName   AS InfoMoneyName

           , Object_AccountKind.Id          AS AccountKindId
           , Object_AccountKind.ObjectCode  AS AccountKindCode
           , Object_AccountKind.ValueData   AS AccountKindName
           
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

           , COALESCE (ObjectBoolean_onComplete.ValueData, FALSE)  AS onComplete
           
       FROM Object AS Object_Account
            LEFT JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                                 ON ObjectLink_Account_AccountGroup.ObjectId = Object_Account.Id 
                                AND ObjectLink_Account_AccountGroup.DescId = zc_ObjectLink_Account_AccountGroup()
            LEFT JOIN Object AS Object_AccountGroup ON Object_AccountGroup.Id = ObjectLink_Account_AccountGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Account_AccountDirection
                                 ON ObjectLink_Account_AccountDirection.ObjectId = Object_Account.Id 
                                AND ObjectLink_Account_AccountDirection.DescId = zc_ObjectLink_Account_AccountDirection()
            LEFT JOIN Object AS Object_AccountDirection ON Object_AccountDirection.Id = ObjectLink_Account_AccountDirection.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Account_InfoMoneyDestination
                                 ON ObjectLink_Account_InfoMoneyDestination.ObjectId = Object_Account.Id
                                AND ObjectLink_Account_InfoMoneyDestination.DescId = zc_ObjectLink_Account_InfoMoneyDestination()
            LEFT JOIN ObjectLink AS ObjectLink_Account_InfoMoney
                                 ON ObjectLink_Account_InfoMoney.ObjectId = Object_Account.Id
                                AND ObjectLink_Account_InfoMoney.DescId = zc_ObjectLink_Account_InfoMoney()

            LEFT JOIN Object_InfoMoneyDestination_View AS View_InfoMoneyDestination ON View_InfoMoneyDestination.InfoMoneyDestinationId = ObjectLink_Account_InfoMoneyDestination.ChildObjectId
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Account_InfoMoneyDestination.ChildObjectId
            
            LEFT JOIN ObjectBoolean AS ObjectBoolean_onComplete
                                    ON ObjectBoolean_onComplete.ObjectId = Object_Account.Id 
                                   AND ObjectBoolean_onComplete.DescId = zc_ObjectBoolean_Account_onComplete()
                                   
            LEFT JOIN ObjectLink AS ObjectLink_Account_AccountKind
                                 ON ObjectLink_Account_AccountKind.ObjectId = Object_Account.Id
                                AND ObjectLink_Account_AccountKind.DescId = zc_ObjectLink_Account_AccountKind()
            LEFT JOIN Object AS Object_AccountKind ON Object_AccountKind.Id = ObjectLink_Account_AccountKind.ChildObjectId
                                   
       WHERE Object_Account.DescId = zc_Object_Account();
;


ALTER TABLE Object_Account_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.11.13                        * add Object_InfoMoneyDestination_View
 08.10.13                        *
*/

-- ����
-- SELECT * FROM Object_Account_View