-- Function: gpUpdate_Unit_PercentSAUA()

DROP FUNCTION IF EXISTS gpUpdate_Unit_PercentSAUA(Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_PercentSAUA(
    IN inId                  Integer   ,    -- ���� ������� <�������������>
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
   
   IF NOT EXISTS(SELECT 1 FROM ObjectLink 
                 WHERE ObjectLink.ObjectId = inId
                   AND ObjectLink.DescId = zc_ObjectLink_Unit_UnitSAUA()
                   AND COALESCE (ObjectLink.ChildObjectId, 0) <> 0)
   THEN
     inPercentSAUA  := 0;   
   END IF;
   
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

-- select * from gpUpdate_Unit_PercentSAUA(inId := 183292 , inUnitSAUA := 183291 ,  inSession := '3');