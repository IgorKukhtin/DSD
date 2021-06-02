

CREATE OR REPLACE FUNCTION zc_MovementBoolean_Offer() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_Offer'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_Offer', '�������� (��/���)'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_Offer');

CREATE OR REPLACE FUNCTION zc_MovementBoolean_DisableSMS() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_DisableSMS'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_DisableSMS', '��������� �������� SMS'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_DisableSMS');


/*-------------------------------------------------------------------------------
 !!!!!!!!!!!!!!!!!!! ������������ ����� �� �������� !!!!!!!!!!!!!!!!!!!
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 02.06.21         * zc_MovementBoolean_DisableSMS
 22.04.21         * zc_MovementBoolean_Offer
 25.05.17                                                          *
 25.02.17                                        * start
*/
