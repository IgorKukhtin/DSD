-- Function: lfGet_Object_Account_byInfoMoneyDestination (Integer, Integer, Integer)

-- DROP FUNCTION lfGet_Object_Account_byInfoMoneyDestination (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_Account_byInfoMoneyDestination (IN inAccountGroupId Integer, IN inAccountDirectionId Integer, IN inInfoMoneyDestinationId Integer)

RETURNS Integer
AS
$BODY$
BEGIN

     -- �������� ������ ��� ����������� ������ (�� ����� ���� ��� ��� �����������)
     RETURN ( 
       SELECT 
            ObjectLink_Account_InfoMoneyDestination.ObjectId           
       FROM ObjectLink AS ObjectLink_Account_InfoMoneyDestination
                 JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                                 ON ObjectLink_Account_AccountGroup.ObjectId = ObjectLink_Account_InfoMoneyDestination.ObjectId 
                                AND ObjectLink_Account_AccountGroup.DescId = zc_ObjectLink_Account_AccountGroup()
                                AND ObjectLink_Account_AccountGroup.ChildObjectId = inAccountGroupId 
                 JOIN ObjectLink AS ObjectLink_Account_AccountDirection
                                 ON ObjectLink_Account_AccountDirection.ObjectId = ObjectLink_Account_InfoMoneyDestination.ObjectId 
                                AND ObjectLink_Account_AccountDirection.DescId = zc_ObjectLink_Account_AccountDirection()
                                AND ObjectLink_Account_AccountDirection.ChildObjectId = inAccountDirectionId 

       WHERE ObjectLink_Account_InfoMoneyDestination.DescId = zc_ObjectLink_Account_InfoMoneyDestination()
         AND ObjectLink_Account_InfoMoneyDestination.ChildObjectId = inInfoMoneyDestinationId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lfGet_Object_Account_byInfoMoneyDestination (Integer, Integer, Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.09.13                                        * ������������� 100%
 26.08.13                                        * rename
 13.08.13                        *
*/

-- ����
-- SELECT * FROM lfGet_Object_Account_byInfoMoneyDestination ()
