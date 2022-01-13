
CREATE OR REPLACE FUNCTION zc_ObjectBoolean_InfoMoney_Service() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_InfoMoney_Service'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_InfoMoney(), 'zc_ObjectBoolean_InfoMoney_Service', '�� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_InfoMoney_Service');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_InfoMoney_UserAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_InfoMoney_UserAll'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_InfoMoney(), 'zc_ObjectBoolean_InfoMoney_UserAll', '������ ����' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_InfoMoney_UserAll');

CREATE OR REPLACE FUNCTION zc_ObjectBoolean_User_Sign() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_User_Sign'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectBooleanDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectBoolean_User_Sign', '���������� �������������' WHERE NOT EXISTS (SELECT * FROM ObjectBooleanDesc WHERE Code = 'zc_ObjectBoolean_User_Sign');


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.01.22         * zc_ObjectBoolean_InfoMoney_Service
                    zc_ObjectBoolean_InfoMoney_UserAll
                    zc_ObjectBoolean_User_Sign
 10.01.22                                        * 
*/
