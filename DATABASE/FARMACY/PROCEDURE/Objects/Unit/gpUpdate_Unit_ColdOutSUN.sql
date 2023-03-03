-- Function: gpUpdate_Unit_ColdOutSUN()

DROP FUNCTION IF EXISTS gpUpdate_Unit_ColdOutSUN(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_ColdOutSUN(
    IN inId                     Integer   ,    -- ���� ������� <�������������>
    IN inisColdOutSUN Boolean   ,    -- ���������� ������ �������� ����� � �������� ���
    IN inSession                TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 OR 
      COALESCE((SELECT ObjectBoolean_ColdOutSUN.ValueData 
                FROM ObjectBoolean AS ObjectBoolean_ColdOutSUN
                WHERE ObjectBoolean_ColdOutSUN.ObjectId = COALESCE(inId, 0)
                  AND ObjectBoolean_ColdOutSUN.DescId = zc_ObjectBoolean_Unit_ColdOutSUN()), False) <>
      inisColdOutSUN
   THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_ColdOutSUN(), inId, not inisColdOutSUN);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.06.22                                                       *
*/

-- select * from gpUpdate_Unit_ColdOutSUN(inId := 13338606 , inisColdOutSUN := 'False' ,  inSession := '3');