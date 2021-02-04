

CREATE OR REPLACE FUNCTION zc_MovementLinkMovement_Invoice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Invoice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkMovementDesc (Code, ItemName)
  SELECT 'zc_MovementLinkMovement_Invoice', '�������� ����' WHERE NOT EXISTS (SELECT * FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Invoice');
      
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.02.21         * zc_MovementLinkMovement_Invoice
 24.08.20                                        *
*/
