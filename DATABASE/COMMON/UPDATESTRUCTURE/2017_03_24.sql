DROP FUNCTION IF EXISTS zc_MovementDate_InsertMobile();
CREATE OR REPLACE FUNCTION zc_MovementDate_InsertMobile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_InsertMobile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_InsertMobile', 'ƒата/врем€ создани€ на мобильном устройстве' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_InsertMobile');
