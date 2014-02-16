-- Function: lfGet_Object_AccountForJuridical (Integer, boolean, Integer, Integer)

DROP FUNCTION IF EXISTS lfGet_Object_AccountForJuridical (Integer, boolean, Integer, Integer);
/*
CREATE OR REPLACE FUNCTION lfGet_Object_AccountForJuridical(IN inInfoMoneyDestinationId Integer, IN isDebet Boolean, OUT outAccountGroupId Integer, OUT outAccountDirectionId Integer)
AS
$BODY$
BEGIN
   IF isDebet 
   THEN
      -- �������� �� �������������� ������
      CASE inInfoMoneyDestinationId  
           WHEN zc_Enum_InfoMoneyDestination_10100(), zc_Enum_InfoMoneyDestination_10200(),
                zc_Enum_InfoMoneyDestination_20100(), zc_Enum_InfoMoneyDestination_20200(), zc_Enum_InfoMoneyDestination_20300(),
                zc_Enum_InfoMoneyDestination_20400(), zc_Enum_InfoMoneyDestination_20500(), zc_Enum_InfoMoneyDestination_20600(),
                zc_Enum_InfoMoneyDestination_20700()
           THEN
                outAccountGroupId := zc_Enum_AccountGroup_70000(); -- ���������;
                outAccountDirectionId := zc_Enum_AccountDirection_70100(); -- ����������;
           WHEN zc_Enum_InfoMoneyDestination_21400()
           THEN
                outAccountGroupId := zc_Enum_AccountGroup_70000(); -- ���������;
                outAccountDirectionId := zc_Enum_AccountDirection_70200();  -- "������ ����������"
           WHEN zc_Enum_InfoMoneyDestination_21500()
           THEN
                outAccountGroupId := zc_Enum_AccountGroup_70000(); -- ���������;
                outAccountDirectionId := zc_Enum_AccountDirection_70300();  -- "���������"
           WHEN zc_Enum_InfoMoneyDestination_21600() 
           THEN
                outAccountGroupId := zc_Enum_AccountGroup_70000(); -- ���������;
                outAccountDirectionId := zc_Enum_AccountDirection_70400();  -- "������������ ������"
           WHEN zc_Enum_InfoMoneyDestination_50100()
           THEN
                outAccountGroupId := zc_Enum_AccountGroup_90000(); -- ������� � ��������;
                outAccountDirectionId := zc_Enum_AccountDirection_90100();  -- "��������� �������"
           WHEN zc_Enum_InfoMoneyDestination_50200()
           THEN
                outAccountGroupId := zc_Enum_AccountGroup_90000(); -- ������� � ��������;
                outAccountDirectionId := zc_Enum_AccountDirection_90200();  -- "��������� ������� (������)"
           ELSE
                RAISE EXCEPTION '�� ��������� ���� �� �������������� ������ "%"', inInfoMoneyDestinationId;
      END CASE;
   ELSE
      -- �������� �� �������������� ������
      CASE inInfoMoneyDestinationId  
           WHEN zc_Enum_InfoMoneyDestination_10100(), zc_Enum_InfoMoneyDestination_10200(),
                zc_Enum_InfoMoneyDestination_20100(), zc_Enum_InfoMoneyDestination_20200(), zc_Enum_InfoMoneyDestination_20300(),
                zc_Enum_InfoMoneyDestination_20400(), zc_Enum_InfoMoneyDestination_20500(), zc_Enum_InfoMoneyDestination_20600(),
                zc_Enum_InfoMoneyDestination_20700()
           THEN
                outAccountGroupId := zc_Enum_AccountGroup_30000(); -- ��������;
                outAccountDirectionId := zc_Enum_AccountDirection_30100(); -- ����������;
           WHEN zc_Enum_InfoMoneyDestination_30400() -- ������ ���������������
           THEN
                outAccountGroupId := zc_Enum_AccountGroup_30000(); -- ��������;
                outAccountDirectionId := zc_Enum_AccountDirection_30300();  -- "������ ���������������"
           WHEN zc_Enum_InfoMoneyDestination_20800(), zc_Enum_InfoMoneyDestination_20900(), -- ���������� �����
                zc_Enum_InfoMoneyDestination_21000(), zc_Enum_InfoMoneyDestination_21100()
           THEN
                outAccountGroupId := zc_Enum_AccountGroup_30000(); -- ��������
                outAccountDirectionId := zc_Enum_AccountDirection_30200();  -- "���������� �����"
           WHEN zc_Enum_InfoMoneyDestination_30500(), -- ������ ������ 
                zc_Enum_InfoMoneyDestination_40500(), -- ����� 
                zc_Enum_InfoMoneyDestination_40600()  -- ��������
           THEN
                outAccountGroupId := zc_Enum_AccountGroup_30000(); -- ��������
                outAccountDirectionId := zc_Enum_AccountDirection_30200();  -- ������ ��������
           ELSE
                RAISE EXCEPTION '�� ��������� ���� �� �������������� ������ "%"', inInfoMoneyDestinationId;
      END CASE;
   END IF;
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lfGet_Object_AccountForJuridical (Integer, boolean) OWNER TO postgres;
*/

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.01.14                                        * delete
 13.08.13                        *
*/

-- ����
-- SELECT * FROM lfGet_Object_AccountForJuridical ()
