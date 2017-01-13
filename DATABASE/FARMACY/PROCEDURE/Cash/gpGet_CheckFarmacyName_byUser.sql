-- Function: gpGet_CheckFarmacyName_byUser()

DROP FUNCTION IF EXISTS gpGet_CheckFarmacyName_byUser (BOOLEAN, TVarChar, TVarChar);



CREATE OR REPLACE FUNCTION gpGet_CheckFarmacyName_byUser(
    OUT    Enter              BOOLEAN,  -- Разрешение на вход true - да, false - нет 
    IN     AFarmacyName       TVarChar, -- Имя Аптеки под которой входит пользователь
    IN     inSession          TVarChar  -- Сессия пользователя
)
RETURNS BOOLEAN
AS
$BODY$
BEGIN
 Enter := FALSE;

 if AFarmacyName = 'Аптека 18'
 THEN
      Enter := TRUE;
 ELSE
      Enter := TRUE;
 END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
 
/*
Это тестовая функция для проверки 

 AFarmacyName = 'Аптека 18' то доступ разрешен для других заперщен

                                                        
*/
