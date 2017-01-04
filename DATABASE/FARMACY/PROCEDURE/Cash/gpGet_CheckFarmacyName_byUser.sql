-- Function: gpGet_CheckFarmacyName_byUser()

DROP FUNCTION IF EXISTS gpGet_CheckFarmacyName_byUser (TVarChar,TVarChar);



CREATE OR REPLACE FUNCTION gpGet_CheckFarmacyName_byUser(
    INOUT AFarmacyName       TVarChar, -- Имя Аптеки
    IN inSession             TVarChar  -- Сессия пользователя
)
RETURNS tvarchar
LANGUAGE plpgsql
$BODY$
BEGIN
    if AFarmacyName='Аптека 18' THEN
      AFarmacyName :='ok';
     END IF;
END;
$BODY$
 
/*
Это тестовая функция для проверки 

 AFarmacyName должен возврящать 'ok'  or 'no'

                                                        
*/
