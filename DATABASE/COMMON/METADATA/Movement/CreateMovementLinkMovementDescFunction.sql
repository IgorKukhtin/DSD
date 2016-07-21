--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_MovementLinkMovement_Child() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Child'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkMovementDesc (Code, ItemName)
  SELECT 'zc_MovementLinkMovement_Child', 'Документ Подчиненный' WHERE NOT EXISTS (SELECT * FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Child');

CREATE OR REPLACE FUNCTION zc_MovementLinkMovement_ChildEDI() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_ChildEDI'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkMovementDesc (Code, ItemName)
  SELECT 'zc_MovementLinkMovement_ChildEDI', 'Документ Подчиненный(EDI)' WHERE NOT EXISTS (SELECT * FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_ChildEDI');

CREATE OR REPLACE FUNCTION zc_MovementLinkMovement_Master() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Master'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkMovementDesc (Code, ItemName)
  SELECT 'zc_MovementLinkMovement_Master', 'Документ Мастер' WHERE NOT EXISTS (SELECT * FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Master');

CREATE OR REPLACE FUNCTION zc_MovementLinkMovement_MasterEDI() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_MasterEDI'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkMovementDesc (Code, ItemName)
  SELECT 'zc_MovementLinkMovement_MasterEDI', 'Документ Мастер(EDI)' WHERE NOT EXISTS (SELECT * FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_MasterEDI');

CREATE OR REPLACE FUNCTION zc_MovementLinkMovement_Order() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Order'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkMovementDesc (Code, ItemName)
  SELECT 'zc_MovementLinkMovement_Order', 'Заказ' WHERE NOT EXISTS (SELECT * FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Order');

CREATE OR REPLACE FUNCTION zc_MovementLinkMovement_Promo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Promo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkMovementDesc (Code, ItemName)
  SELECT 'zc_MovementLinkMovement_Promo', 'Акция' WHERE NOT EXISTS (SELECT * FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Promo');

CREATE OR REPLACE FUNCTION zc_MovementLinkMovement_Sale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Sale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkMovementDesc (Code, ItemName)
  SELECT 'zc_MovementLinkMovement_Sale', 'Реализация' WHERE NOT EXISTS (SELECT * FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Sale');

CREATE OR REPLACE FUNCTION zc_MovementLinkMovement_Tax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Tax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkMovementDesc (Code, ItemName)
  SELECT 'zc_MovementLinkMovement_Tax', 'Налоговая' WHERE NOT EXISTS (SELECT * FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Tax');

CREATE OR REPLACE FUNCTION zc_MovementLinkMovement_TransportGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_TransportGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkMovementDesc (Code, ItemName)
  SELECT 'zc_MovementLinkMovement_TransportGoods', 'Товаро-транспортная накладная' WHERE NOT EXISTS (SELECT * FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_TransportGoods');

CREATE OR REPLACE FUNCTION zc_MovementLinkMovement_Transport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Transport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkMovementDesc (Code, ItemName)
  SELECT 'zc_MovementLinkMovement_Transport', 'Путевой лист' WHERE NOT EXISTS (SELECT * FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Transport');
  
CREATE OR REPLACE FUNCTION zc_MovementLinkMovement_ChangeIncomePayment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_ChangeIncomePayment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkMovementDesc (Code, ItemName)
  SELECT 'zc_MovementLinkMovement_ChangeIncomePayment', 'Документ изменения долга по приходам' WHERE NOT EXISTS (SELECT * FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_ChangeIncomePayment');

CREATE OR REPLACE FUNCTION zc_MovementLinkMovement_Invoice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Invoice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkMovementDesc (Code, ItemName)
  SELECT 'zc_MovementLinkMovement_Invoice', 'Документ счет' WHERE NOT EXISTS (SELECT * FROM MovementLinkMovementDesc WHERE Code = 'zc_MovementLinkMovement_Invoice');
    
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.07.16         * zc_MovementLinkMovement_Invoice
 30.03.15                      	                 * add zc_MovementLinkMovement_TransportGoods
 31.07.14                      	                 * add zc_MovementLinkMovement_MasterEDI and zc_MovementLinkMovement_ChildEDI
 12.02.14                      	                                  *
*/

-- INSERT INTO MovementLinkMovement( DescId, MovementId ,  MovementChildId )
-- select zc_MovementLinkMovement_Child() , 19736,  122207