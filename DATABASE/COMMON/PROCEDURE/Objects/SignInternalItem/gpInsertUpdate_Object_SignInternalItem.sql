-- Function: gpInsertUpdate_Object_SignInternalItem(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SignInternalItem (Integer, Integer, TVarChar, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_SignInternalItem(
 INOUT ioId              Integer   , -- ���� ������� 
 INOUT ioCode            Integer   , -- �������� <���>
    IN inName            TVarChar  , -- �������� <������������>
    IN inSignInternalId  Integer   , -- ������ 
    IN inUserId          Integer   , -- ������ 
    IN inSession         TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_SignInternalItem());

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (ioCode, 0) = 0 THEN ioCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ��������� (�� ������) +1
   --vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_SignInternalItem());
   IF COALESCE (ioCode, 0) = 0 THEN
       vbCode_calc:= COALESCE((SELECT max(Object_SignInternalItem.ObjectCode) AS Code
                               FROM Object AS Object_SignInternalItem
                                  INNER JOIN ObjectLink AS ObjectLink_SignInternalItem_SignInternal 
                                     ON ObjectLink_SignInternalItem_SignInternal.ObjectId = Object_SignInternalItem.Id
                                    AND ObjectLink_SignInternalItem_SignInternal.DescId = zc_ObjectLink_SignInternalItem_SignInternal()
                                    AND ObjectLink_SignInternalItem_SignInternal.ChildObjectId = inSignInternalId) ,0 ) +1 ;
    ELSE
       vbCode_calc:= ioCode;
    END IF;

   ioCode:= vbCode_calc;
   
   -- �������� ������������ ��� �������� <������������>
   --PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_SignInternalItem(), inName);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId:= ioId, inDescId:= zc_Object_SignInternalItem(), inObjectCode:= vbCode_calc, inValueData:= inName);

   -- ��������� ����� � <��������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_SignInternalItem_SignInternal(), ioId, inSignInternalId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_SignInternalItem_User(), ioId, inUserId);

   

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.08.16         *
 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_SignInternalItem()
