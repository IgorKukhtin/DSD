-- Function: gpUpdate_Object_Member_Banks ()

DROP FUNCTION IF EXISTS gpUpdate_Object_Member_Banks (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Member_Banks(
    IN inId                Integer   , -- ���� �������
    IN inBankId            Integer  , -- 
    IN inDescName          TVarChar  , -- 
   OUT outBankName         TVarChar  , -- 
    IN inSession           TVarChar    -- ������ ������������
)
  RETURNS TVarChar AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Member());

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink(ObjectLinkDesc.Id, inId, inBankId)
   FROM ObjectLinkDesc
   WHERE LOWER (ObjectLinkDesc.Code) = LOWER (inDescName);

   outBankName:= (SELECT Object.ValueData  FROM Object WHERE Object.Id = inBankId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.
 03.03.17         *
*/

