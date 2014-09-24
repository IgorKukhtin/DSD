--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! ����� ����� !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_MovementLinkMovement_Child() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Child'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkMovementDesc (Code, ItemName)
  SELECT 'zc_MovementLinkMovement_Child', '����������� ��������' WHERE NOT EXISTS (SELECT * FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Child');

CREATE OR REPLACE FUNCTION zc_MovementLinkMovement_ChildEDI() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_ChildEDI'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkMovementDesc (Code, ItemName)
  SELECT 'zc_MovementLinkMovement_ChildEDI', '����������� ��������(EDI)' WHERE NOT EXISTS (SELECT * FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_ChildEDI');

CREATE OR REPLACE FUNCTION zc_MovementLinkMovement_Master() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Master'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkMovementDesc (Code, ItemName)
  SELECT 'zc_MovementLinkMovement_Master', '������� ��������' WHERE NOT EXISTS (SELECT * FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Master');

CREATE OR REPLACE FUNCTION zc_MovementLinkMovement_MasterEDI() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_MasterEDI'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkMovementDesc (Code, ItemName)
  SELECT 'zc_MovementLinkMovement_MasterEDI', '������� ��������(EDI)' WHERE NOT EXISTS (SELECT * FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_MasterEDI');

CREATE OR REPLACE FUNCTION zc_MovementLinkMovement_Order() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Order'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkMovementDesc (Code, ItemName)
  SELECT 'zc_MovementLinkMovement_Order', '�����' WHERE NOT EXISTS (SELECT * FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Order');

CREATE OR REPLACE FUNCTION zc_MovementLinkMovement_Sale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Sale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkMovementDesc (Code, ItemName)
  SELECT 'zc_MovementLinkMovement_Sale', '����������' WHERE NOT EXISTS (SELECT * FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Sale');

CREATE OR REPLACE FUNCTION zc_MovementLinkMovement_Tax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Tax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkMovementDesc (Code, ItemName)
  SELECT 'zc_MovementLinkMovement_Tax', '���������' WHERE NOT EXISTS (SELECT * FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Tax');

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 31.07.14                      	                 * add zc_MovementLinkMovement_MasterEDI and zc_MovementLinkMovement_ChildEDI
 12.02.14                      	                                  *
*/

-- INSERT INTO MovementLinkMovement( DescId, MovementId ,  MovementChildId )
-- select zc_MovementLinkMovement_Child() , 19736,  122207