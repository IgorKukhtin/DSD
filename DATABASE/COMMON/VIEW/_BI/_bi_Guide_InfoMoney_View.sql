-- View: _bi_Guide_InfoMoney_View

 DROP VIEW IF EXISTS _bi_Guide_InfoMoney_View;

-- ���������� �� ������ ����������
CREATE OR REPLACE VIEW _bi_Guide_InfoMoney_View
AS
       SELECT
             Object_InfoMoney.Id         AS Id
           , Object_InfoMoney.ObjectCode AS Code
           , Object_InfoMoney.ValueData  AS Name
             -- ������� "������ ��/���"
           , Object_InfoMoney.isErased   AS isErased
           --������ �������������� ����������
           , Object_InfoMoneyGroup.Id               AS InfoMoneyGroupId
           , Object_InfoMoneyGroup.ObjectCode       AS InfoMoneyGroupCode
           , Object_InfoMoneyGroup.ValueData        AS InfoMoneyGroupName
           --�������������� ����������
           , Object_InfoMoneyDestination.Id         AS InfoMoneyDestinationId
           , Object_InfoMoneyDestination.ObjectCode AS InfoMoneyDestinationCode
           , Object_InfoMoneyDestination.ValueData  AS InfoMoneyDestinationName
           --������ ������ ��� - ������
           , Object_CashFlow_in.Id                  AS CashFlowId_in
           , Object_CashFlow_in.ObjectCode          AS CashFlowCode_in
           , Object_CashFlow_in.ValueData           AS CashFlowName_in
           --������ ������ ��� - ������
           , Object_CashFlow_out.Id                 AS CashFlowId_out
           , Object_CashFlow_out.ObjectCode         AS CashFlowCode_out
           , Object_CashFlow_out.ValueData          AS CashFlowName_out
           --������� �� ������
           , COALESCE (ObjectBoolean_ProfitLoss.ValueData, False)  AS isProfitLoss

       FROM Object AS Object_InfoMoney
           --�������������� ����������
           LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                                ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId = Object_InfoMoney.Id
                               AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
           LEFT JOIN Object AS Object_InfoMoneyDestination ON Object_InfoMoneyDestination.Id = ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId
           --������ �������������� ����������
           LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyGroup
                                ON ObjectLink_InfoMoney_InfoMoneyGroup.ObjectId = Object_InfoMoney.Id
                               AND ObjectLink_InfoMoney_InfoMoneyGroup.DescId = zc_ObjectLink_InfoMoney_InfoMoneyGroup()
           LEFT JOIN Object AS Object_InfoMoneyGroup ON Object_InfoMoneyGroup.Id = ObjectLink_InfoMoney_InfoMoneyGroup.ChildObjectId
           --������ ������ ��� - ������
           LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_CashFlow_in
                                ON ObjectLink_InfoMoney_CashFlow_in.ObjectId = Object_InfoMoney.Id
                               AND ObjectLink_InfoMoney_CashFlow_in.DescId = zc_ObjectLink_InfoMoney_CashFlow_in()
           LEFT JOIN Object AS Object_CashFlow_in ON Object_CashFlow_in.Id = ObjectLink_InfoMoney_CashFlow_in.ChildObjectId
           --������ ������ ��� - ������
           LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_CashFlow_out
                                ON ObjectLink_InfoMoney_CashFlow_out.ObjectId = Object_InfoMoney.Id
                               AND ObjectLink_InfoMoney_CashFlow_out.DescId = zc_ObjectLink_InfoMoney_CashFlow_out()
           LEFT JOIN Object AS Object_CashFlow_out ON Object_CashFlow_out.Id = ObjectLink_InfoMoney_CashFlow_out.ChildObjectId
           --������� �� ������
           LEFT JOIN ObjectBoolean AS ObjectBoolean_ProfitLoss
                                   ON ObjectBoolean_ProfitLoss.ObjectId = Object_InfoMoney.Id
                                  AND ObjectBoolean_ProfitLoss.DescId = zc_ObjectBoolean_InfoMoney_ProfitLoss()
       WHERE Object_InfoMoney.DescId = zc_Object_InfoMoney()
      ;

ALTER TABLE _bi_Guide_InfoMoney_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.05.25         * all
 09.05.25                                        *
*/

-- ����
-- SELECT * FROM _bi_Guide_InfoMoney_View
