-- � �������� �� ������ ������������ � gpSelect_Movement_Income_PrintSticker 
CREATE OR REPLACE FUNCTION zc_MIBoolean_Print() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Print'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemBooleanDesc (Code, ItemName)
  SELECT 'zc_MIBoolean_Print', '�������� ������' WHERE NOT EXISTS (SELECT * FROM MovementItemBooleanDesc WHERE Code = 'zc_MIBoolean_Print'); 

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 25.05.17                                                         *
 27.01.17         * add zc_MIBoolean_Print
*/
