CREATE OR REPLACE FUNCTION zc_ObjectCost_Basis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ObjectCostDesc WHERE Code = 'zc_ObjectCost_Basis'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectCostDesc (Code, ItemName)
  SELECT 'zc_ObjectCost_Basis', '������� ������ �������������' WHERE NOT EXISTS (SELECT * FROM ObjectCostDesc WHERE Code = 'zc_ObjectCost_Basis');


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.07.13                                        *
*/
