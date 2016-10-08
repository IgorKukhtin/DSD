-- Function: gpInsertUpdate_Object_Unit()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceGroupSettingsTOP(Integer, TVarChar, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PriceGroupSettingsTOP(
 INOUT ioId                      Integer   ,   	-- ���� ������� <��������� ��� ������� ����� ���>
    IN inName                    TVarChar  ,    -- �������� ������
    IN inMinPrice                TFloat    ,    -- ����������� ����
    IN inPercent                 TFloat    ,    -- �������
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_PriceGroupSettingsTOP());
   vbUserId:= inSession;
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   -- ��������� ������
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PriceGroupSettingsTOP(), 0, inName);

   -- ��������� ����� � <�������� �����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceGroupSettingsTOP_Retail(), ioId, vbObjectId);

   -- ����������� ����
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_PriceGroupSettingsTOP_MinPrice(), ioId, inMinPrice);
   -- %
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_PriceGroupSettingsTOP_Percent(), ioId, inPercent);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_PriceGroupSettingsTOP(Integer, TVarChar, TFloat, TFloat, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.10.16         * parce
 26.08.16         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_PriceGroupSettingsTOP ()                            
