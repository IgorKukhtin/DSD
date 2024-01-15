-- Function: gpUpdate_Object_BankAccountPdf(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_BankAccountPdf(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_BankAccountPdf(
    IN inId                        Integer   , -- ���� ������� <��������>
    IN inDocTagId                  Integer   , -- 
    IN inComment                   TVarChar  , -- 
    IN inSession                   TVarChar    -- ������ ������������
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Product());
   vbUserId:= lpGetUserBySession (inSession);
   
    -- ��������
   IF COALESCE (inId, 0) = 0
   THEN
       --RAISE EXCEPTION '������! ������� �� ����������!';
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������! ������� ��������� �� ��������!'
                                              , inProcedureName := 'gpUpdate_Object_BankAccountPdf'
                                              , inUserId        := vbUserId
                                              );
   END IF;
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_BankAccountPdf_Comment(), inId, inComment);
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_BankAccountPdf_DocTag(), inId, inDocTagId);   

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.01.24         *
*/

-- ����
--
