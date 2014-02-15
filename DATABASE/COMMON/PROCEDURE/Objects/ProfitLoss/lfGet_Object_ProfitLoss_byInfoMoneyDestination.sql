-- Function: lfGet_Object_ProfitLoss_byInfoMoneyDestination (Integer, Integer, Integer)

-- DROP FUNCTION lfGet_Object_ProfitLoss_byInfoMoneyDestination (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_ProfitLoss_byInfoMoneyDestination (IN inProfitLossGroupId Integer, IN inProfitLossDirectionId Integer, IN inInfoMoneyDestinationId Integer)

RETURNS Integer
AS
$BODY$
BEGIN

     -- �������� ������ ��� ����������� ������ (�� ����� ���� ��� ��� �����������)
     RETURN ( 
       SELECT 
            Object_ProfitLoss.Id           
       FROM Object AS Object_ProfitLoss
                 JOIN ObjectLink AS ObjectLink_ProfitLoss_ProfitLossGroup
                                 ON ObjectLink_ProfitLoss_ProfitLossGroup.ObjectId = Object_ProfitLoss.Id 
                                AND ObjectLink_ProfitLoss_ProfitLossGroup.DescId = zc_ObjectLink_ProfitLoss_ProfitLossGroup()

                 JOIN ObjectLink AS ObjectLink_ProfitLoss_ProfitLossDirection
                                 ON ObjectLink_ProfitLoss_ProfitLossDirection.ObjectId = Object_ProfitLoss.Id 
                                AND ObjectLink_ProfitLoss_ProfitLossDirection.DescId = zc_ObjectLink_ProfitLoss_ProfitLossDirection()

                 JOIN ObjectLink AS ObjectLink_ProfitLoss_InfoMoneyDestination
                                 ON ObjectLink_ProfitLoss_InfoMoneyDestination.ObjectId = Object_ProfitLoss.Id
                                AND ObjectLink_ProfitLoss_InfoMoneyDestination.DescId = zc_ObjectLink_ProfitLoss_InfoMoneyDestination()

       WHERE ObjectLink_ProfitLoss_ProfitLossGroup.ChildObjectId = inProfitLossGroupId AND ObjectLink_ProfitLoss_ProfitLossDirection.ChildObjectId = inProfitLossDirectionId 
         AND ObjectLink_ProfitLoss_InfoMoneyDestination.ChildObjectId = inInfoMoneyDestinationId AND Object_ProfitLoss.DescId = zc_Object_ProfitLoss());

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lfGet_Object_ProfitLoss_byInfoMoneyDestination (Integer, Integer, Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.08.13                                        * rename
*/

-- ����
-- SELECT * FROM lfGet_Object_ProfitLoss_byInfoMoneyDestination ()
