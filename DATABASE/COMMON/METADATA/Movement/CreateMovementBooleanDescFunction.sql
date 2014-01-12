--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! ����� ����� !!!
--------------------------- !!!!!!!!!!!!!!!!!!!
CREATE OR REPLACE FUNCTION zc_MovementBoolean_PriceWithVAT() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_PriceWithVAT'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_PriceWithVAT','���� � ��� (��/���)'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_PriceWithVAT');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_Checked() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_Checked'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_Checked','��������'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_Checked');

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.01.14                                        * add 
 07.07.13         * ����� �����
*/

