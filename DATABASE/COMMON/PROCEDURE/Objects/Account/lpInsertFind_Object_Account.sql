-- Function: lpInsertFind_Object_Account (Integer, Integer, Integer, Integer, Boolean, Integer)

DROP FUNCTION IF EXISTS lpInsertFind_Object_Account (Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertFind_Object_Account (Integer, Integer, Integer, Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_Account(
    IN inAccountGroupId         Integer               , -- ������ ������
    IN inAccountDirectionId     Integer               , -- ��������� ������ - �����������
    IN inInfoMoneyDestinationId Integer               , -- �������������� ����������
    IN inInfoMoneyId            Integer               , -- ������ ����������
    IN inInsert                 Boolean  DEFAULT FALSE , -- 
    IN inUserId                 Integer  DEFAULT NULL   -- ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbAccountDirectionId Integer;
   DECLARE vbAccountDirectionCode Integer;
   DECLARE vbAccountDirectionName TVarChar;
   DECLARE vbAccountId Integer;
   DECLARE vbAccountCode Integer;
   DECLARE vbAccountName TVarChar;
   DECLARE vbAccountKindId Integer;
BEGIN

   -- ��������
   IF COALESCE (inUserId, 0) = 0
   THEN
       RAISE EXCEPTION '������.���������� ���������� ������������ : <%>, <%>, <%>, <%>', inAccountGroupId, inAccountDirectionId, inInfoMoneyDestinationId, inInfoMoneyId;
   END IF;

   IF COALESCE (inAccountGroupId, 0) = 0
   THEN
       RAISE EXCEPTION '������.���������� ���������� ���� �� �.�. �� ����������� <������ ����� ��> : <%>, <%>, <%>, <%>', inAccountGroupId, inAccountDirectionId, inInfoMoneyDestinationId, inInfoMoneyId;
   END IF;

   IF COALESCE (inAccountDirectionId, 0) = 0
   THEN
       RAISE EXCEPTION '������.���������� ���������� ���� �� �.�. �� ����������� <��������� ����� - �����������> : <%>, <%>, <%>, <%>', inAccountGroupId, inAccountDirectionId, inInfoMoneyDestinationId, inInfoMoneyId;
   END IF;

   IF COALESCE (inInfoMoneyDestinationId, 0) = 0 AND COALESCE (inInfoMoneyId, 0) = 0
   THEN
       RAISE EXCEPTION '������.���������� ���������� ���� �� �.�. �� ����������� <�������������� ����������> : <%>, <%>, <%>, <%>', inAccountGroupId, inAccountDirectionId, inInfoMoneyDestinationId, inInfoMoneyId;
   END IF;

   IF COALESCE (inInfoMoneyDestinationId, 0) = 0
   THEN
       RAISE EXCEPTION '������.���������� ���������� ���� �� �.�. �� ����������� <�������������� ����������> : <%>, <%>, <%>, <%>', inAccountGroupId, inAccountDirectionId, inInfoMoneyDestinationId, inInfoMoneyId;
   END IF;


   -- ������� �������������� ���� �� <�������������� ����������> ��� <������ ����������>
   IF inInfoMoneyDestinationId <> 0 THEN vbAccountId := lfGet_Object_Account_byInfoMoneyDestination (inAccountGroupId, inAccountDirectionId, inInfoMoneyDestinationId);
                                    ELSE vbAccountId := lfGet_Object_Account_byInfoMoney(inAccountGroupId, inAccountDirectionId, inInfoMoneyId);
   END IF;


   -- �������� - ������ �� ������ ���� �������
   IF EXISTS (SELECT Id FROM Object WHERE Id = vbAccountId AND isErased = TRUE)
   THEN
       RAISE EXCEPTION '������.���������� ������������ ��������� ���� ��: <%>, <%>, <%>, <%>', lfGet_Object_ValueData (inAccountGroupId), lfGet_Object_ValueData (inAccountDirectionId), lfGet_Object_ValueData (inInfoMoneyDestinationId), lfGet_Object_ValueData (inInfoMoneyId);
   END IF;


   -- ������� ����� ����
   IF COALESCE (vbAccountId, 0) = 0 
   THEN
       -- ��� ��������� ������� ��������� �������� �����
       IF inInsert = FALSE
       THEN
           RAISE EXCEPTION '������.� ������ ��������� ���������� ������� ����� ���� �� � �����������: <%>, <%>, <%>, <%>, (%)', lfGet_Object_ValueData (inAccountGroupId), lfGet_Object_ValueData (inAccountDirectionId), lfGet_Object_ValueData (inInfoMoneyDestinationId), lfGet_Object_ValueData (inInfoMoneyId), inInfoMoneyDestinationId;
       END IF;

       -- ���������� Id 2-�� ������� �� <������ ������> � <��������� ������ - �����������>
       SELECT AccountDirectionId INTO vbAccountDirectionId FROM lfSelect_Object_AccountDirection() WHERE AccountGroupId = inAccountGroupId AND AccountDirectionId = inAccountDirectionId;

       IF COALESCE (vbAccountDirectionId, 0) = 0
       THEN
            -- ���������� �������� 2-�� ������� �� <��������� ������ - �����������>
           SELECT AccountDirectionName INTO vbAccountDirectionName FROM lfSelect_Object_AccountDirection() WHERE AccountDirectionId = inAccountDirectionId;

           -- ���������� Id 2-�� ������� �� <������ ������> � vbAccountDirectionName
           SELECT AccountDirectionId INTO vbAccountDirectionId FROM lfSelect_Object_AccountDirection() WHERE AccountGroupId = inAccountGroupId AND AccountDirectionName = vbAccountDirectionName;

           -- ���� Id �� �����, ������ 2-�� �������
           IF COALESCE (vbAccountDirectionId, 0) = 0
           THEN
               -- ���������� ������� ���
               SELECT COALESCE (MAX (AccountDirectionCode), 0) + 100 INTO vbAccountDirectionCode FROM lfSelect_Object_AccountDirection() WHERE AccountGroupId = inAccountGroupId;
               -- ������� 2-�� �������
               vbAccountDirectionId := lpInsertUpdate_Object (vbAccountDirectionId, zc_Object_AccountDirection(), vbAccountDirectionCode, vbAccountDirectionName);
               -- ��������� ��������
               PERFORM lpInsert_ObjectProtocol (vbAccountDirectionId, inUserId);
           END IF;

       END IF;


       -- ��� ��� ������� �������������� ���� �� <�������������� ����������> ��� <������ ����������> (�� ����� ������ vbAccountDirectionId)
       IF inInfoMoneyDestinationId <> 0 
          THEN vbAccountId := lfGet_Object_Account_byInfoMoneyDestination (inAccountGroupId, vbAccountDirectionId, inInfoMoneyDestinationId);
          ELSE vbAccountId := lfGet_Object_Account_byInfoMoney (inAccountGroupId, vbAccountDirectionId, inInfoMoneyId);
       END IF;

       -- ������� ����� ����
       IF COALESCE (vbAccountId, 0) = 0 
       THEN
           -- ���������� �������� 3-�� ������� �� <�������������� ����������> ��� <������ ����������>
           IF inInfoMoneyDestinationId <> 0 THEN SELECT InfoMoneyDestinationName INTO vbAccountName FROM lfSelect_Object_InfoMoneyDestination() WHERE InfoMoneyDestinationId = inInfoMoneyDestinationId;
                                            ELSE SELECT InfoMoneyName INTO vbAccountName FROM lfSelect_Object_InfoMoney() WHERE InfoMoneyId = inInfoMoneyId;
           END IF;

           -- ���������� �������� <���� ������>
           IF EXISTS (SELECT Object_AccountGroup.Id
                      FROM Object AS Object_AccountGroup
                           LEFT JOIN Object AS Object_AccountGroup_70000 ON Object_AccountGroup_70000.Id = zc_Enum_AccountGroup_70000()
                      WHERE Object_AccountGroup.Id = inAccountGroupId
                        AND Object_AccountGroup.ObjectCode < Object_AccountGroup_70000.ObjectCode)
           THEN
               vbAccountKindId:= zc_Enum_AccountKind_Active();
           ELSE
               vbAccountKindId:= zc_Enum_AccountKind_Passive();
           END IF ;

           -- ���������� ������� ���
           SELECT COALESCE (MAX (AccountCode), 0) + 1 INTO vbAccountCode FROM lfSelect_Object_Account() WHERE AccountGroupId = inAccountGroupId AND AccountDirectionId = vbAccountDirectionId;

           IF vbAccountCode = 1 THEN
             -- ���������� ������� ���
             vbAccountCode:= vbAccountDirectionCode + 1;
           END IF;

           -- ������ 3-�� �������
           vbAccountId := lpInsertUpdate_Object (vbAccountId, zc_Object_Account(), vbAccountCode, vbAccountName);
           -- ��� �������� ��� 3-�� �������
           PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Account_onComplete(), vbAccountId, TRUE);
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_AccountGroup(), vbAccountId, inAccountGroupId);
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_AccountDirection(), vbAccountId, vbAccountDirectionId);
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_InfoMoneyDestination(), vbAccountId, inInfoMoneyDestinationId);
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_InfoMoney(), vbAccountId, inInfoMoneyId);
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Account_AccountKind(), vbAccountId, vbAccountKindId);
       
           -- ��������� ��������
           PERFORM lpInsert_ObjectProtocol (vbAccountId, inUserId);
       END IF;

   END IF;

   IF COALESCE (vbAccountId, 0) = 0 
   THEN
         RAISE EXCEPTION '������.���� �� ���������.���������: <%> <%> <%> <%> <%> <%>', inAccountGroupId, inAccountDirectionId, inInfoMoneyDestinationId, inInfoMoneyId, inInsert, inUserId;
   END IF;

   -- ���������� ��������
   RETURN (vbAccountId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_Object_Account (Integer, Integer, Integer, Integer, Boolean, Integer)  OWNER TO postgres;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 31.01.14                                        * add �������� - ������ �� ������ ���� �������
 25.01.14                                        * add !!!������ ������� �����!!!, �.�. inInsert = FALSE
 22.12.13                                        * add inInsert
 26.08.13                                        * error - vbAccountDirectionId
 08.07.13                                        * add vbAccountKindId and zc_ObjectBoolean_Account_onComplete
 02.07.13                                        *
*/

-- ����
-- SELECT * FROM lpInsertFind_Object_Account (inAccountGroupId:= zc_Enum_AccountGroup_100000(), inAccountDirectionId:= 23581, inInfoMoneyDestinationId:= zc_Enum_InfoMoneyDestination_10100(), inInfoMoneyId:= 0, inUserId:= 2)
--
-- SELECT * FROM lfSelect_Object_Account () order by 8
