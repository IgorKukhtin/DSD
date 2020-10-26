-- Function: gpUpdate_Unit_UnitSAUA()

DROP FUNCTION IF EXISTS gpUpdate_Unit_UnitSAUA(Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_UnitSAUA(
    IN inId                  Integer   ,    -- ���� ������� <�������������>
    IN inUnitSAUA            Integer   ,    -- ����� � ������ � ������� ��������������� ���������� ������������� ����
    IN inPercentSAUA         TFloat    ,    -- ������� ���������� ����� � ����� ��� ����
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   
   IF COALESCE(inId, 0) = COALESCE(inUnitSAUA, 0)
   THEN
     RAISE EXCEPTION '������.������ �� ����� ��������� �� ������ ����';   
   END IF;
   
   IF EXISTS(SELECT 1 FROM ObjectLink 
             WHERE ObjectLink.ChildObjectId = inId
               AND ObjectLink.DescId = zc_ObjectLink_Unit_UnitSAUA())
     AND COALESCE (inUnitSAUA, 0) <> 0
   THEN
     RAISE EXCEPTION '������.������������� <%> ������������� ��� Master', (SELECT Object.ValueData FROM Object WHERE Object.Id = inId);   
   END IF;

   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_UnitSAUA(), inId, inUnitSAUA);
   
      -- ��������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_PercentSAUA(), inId, inPercentSAUA);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.10.20                                                       *
*/

-- select * from gpUpdate_Unit_UnitSAUA(inId := 183292 , inUnitSAUA := 183291 ,  inSession := '3');