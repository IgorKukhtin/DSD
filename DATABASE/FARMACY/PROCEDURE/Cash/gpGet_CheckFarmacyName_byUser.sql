-- Function: gpGet_CheckFarmacyName_byUser()

DROP FUNCTION IF EXISTS gpGet_CheckFarmacyName_byUser (TVarChar,TVarChar);



CREATE OR REPLACE FUNCTION gpGet_CheckFarmacyName_byUser(
    INOUT AFarmacyName       TVarChar, -- ��� ������
    IN inSession             TVarChar  -- ������ ������������
)
RETURNS tvarchar
LANGUAGE plpgsql
$BODY$
BEGIN
    if AFarmacyName='������ 18' THEN
      AFarmacyName :='ok';
     END IF;
END;
$BODY$
 
/*
��� �������� ������� ��� �������� 

 AFarmacyName ������ ���������� 'ok'  or 'no'

                                                        
*/
