-- Function: gpInsertUpdate_Object_Unit()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_OverSettings(Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_OverSettings(
 INOUT ioId                      Integer   ,   	-- ���� ������� 
    IN inUnitId                  Integer   ,    -- �������������
    IN inMinPrice                TFloat    ,    -- ����������� ����
    IN inMinimumLot              TFloat    ,    -- ����������
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= inSession;
   
   -- ��������� ������
   ioId := lpInsertUpdate_Object (ioId, zc_Object_OverSettings(), Null, Null);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_OverSettings_Unit(), ioId, inUnitId);
   -- ����������� ����
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OverSettings_MinPrice(), ioId, inMinPrice);
   -- ����������
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OverSettings_MinimumLot(), ioId, inMinimumLot);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.07.16         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_OverSettings ()                            
