-- Function: gpGet_CheckFarmacyName_byUser()

DROP FUNCTION IF EXISTS gpGet_CheckFarmacyName_byUser (BOOLEAN, TVarChar, TVarChar);



CREATE OR REPLACE FUNCTION gpGet_CheckFarmacyName_byUser(
    OUT    Enter              BOOLEAN,  -- ���������� �� ���� true - ��, false - ��� 
    IN     AFarmacyName       TVarChar, -- ��� ������ ��� ������� ������ ������������
    IN     inSession          TVarChar  -- ������ ������������
)
RETURNS BOOLEAN
AS
$BODY$
BEGIN
 Enter := FALSE;

 if AFarmacyName = '������ 18'
 THEN
      Enter := TRUE;
 ELSE
      Enter := TRUE;
 END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
 
/*
��� �������� ������� ��� �������� 

 AFarmacyName = '������ 18' �� ������ �������� ��� ������ ��������

                                                        
*/
