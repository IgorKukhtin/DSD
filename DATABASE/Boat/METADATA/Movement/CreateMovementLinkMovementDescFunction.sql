

CREATE OR REPLACE FUNCTION zc_MovementLinkMovement_Invoice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Invoice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkMovementDesc (Code, ItemName)
  SELECT 'zc_MovementLinkMovement_Invoice', 'Документ счет' WHERE NOT EXISTS (SELECT * FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Invoice');
      
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.02.21         * zc_MovementLinkMovement_Invoice
 24.08.20                                        *
*/
