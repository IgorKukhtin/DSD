-- Function: gpInsertUpdate_Object_ImportTypeItems()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalSettingsItem (Integer, Integer, TFloat, TFloat, TVarchar);
                        gpinsertupdate_object_juridicalsettingstem
CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_JuridicalSettingsItem(
 INOUT ioId                      Integer ,   -- ���� ������� <>
    IN inJuridicalSettingsId     Integer ,
    IN inBonus                   TFloat  ,
    IN inPriceLimit              TFloat  ,
    IN inSession                 TVarChar    -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ImportTypeItems());
   vbUserId := lpGetUserBySession (inSession); 

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_JuridicalSettingsItem(), 0, '');
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalSettingsItem_JuridicalSettings(), ioId, inJuridicalSettingsId);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_JuridicalSettingsItem_Bonus(), ioId, inBonus);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_JuridicalSettingsItem_PriceLimit(), ioId, inPriceLimit);
     
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.01.19         * 
*/

-- ����                          
