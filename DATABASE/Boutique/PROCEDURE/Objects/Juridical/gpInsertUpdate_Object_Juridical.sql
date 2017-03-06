-- Function: gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Juridical(
 INOUT ioId                       Integer   ,    -- ���� ������� <����������� ����> 
    IN inCode                     Integer   ,    -- ��� ������� <����������� ����>  
    IN inName                     TVarChar  ,    -- �������� ������� <����������� ����>
    IN inIsCorporate              Boolean   ,    -- ������� ������� ����������� ���� (���� �� ������������� ��� ��.����)
    IN inFullName                 TVarChar  ,    -- ��. ���� ������ ��������
    IN inAddress                  TVarChar  ,    -- ����������� �����
    IN inOKPO                     TVarChar  ,    -- ����
    IN inINN                      TVarChar  ,    -- ���
    IN inJuridicalGroupId         Integer   ,    -- ���� ������� <������ ����������� ���> 
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Juridical());
   vbUserId:= lpGetUserBySession (inSession);

    -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF inCode = 0 THEN  inCode := NEXTVAL ('Object_Juridical_seq'); END IF; 
  
   -- �������� ���� ������������ ��� �������� <������������ >
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Juridical(), inName);

   -- �������� ������������ <������������> ��� !!!�����!! <������ ����������� ���>
   IF TRIM (inName) <> '' AND COALESCE (inJuridicalGroupId, 0) <> 0 
   THEN
       IF EXISTS (SELECT Object.Id
                  FROM Object
                       JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                       ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object.Id
                                      AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
                                      AND ObjectLink_Juridical_JuridicalGroup.ChildObjectId = inJuridicalGroupId
                                   
                  WHERE TRIM (Object.ValueData) = TRIM (inName)
                   AND Object.Id <> COALESCE (ioId, 0))
       THEN
           RAISE EXCEPTION '������. ������ ����������� ��� <%> ��� ����������� � <%>.', TRIM (inName), lfGet_Object_ValueData (inJuridicalGroupId);
       END IF;
   END IF;


   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Juridical(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Juridical(), inCode, inName);

   -- ��������� ������� ������� ����������� ���� (���� �� ������������� ��� ��.����)
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Juridical_isCorporate(), ioId, inisCorporate);
   -- ��������� ��. ���� ������ ��������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Juridical_FullName(), ioId, inFullName);
   -- ��������� ����������� �����
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Juridical_Address(), ioId, inAddress);
   -- ��������� ����
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Juridical_OKPO(), ioId, inOKPO);
   -- ��������� ���
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Juridical_INN(), ioId, inINN);


   -- ��������� ����� � <������ ����������� ���>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_JuridicalGroup(), ioId, inJuridicalGroupId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
06.03.17                                                           *
20.02.17                                                           *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Juridical()
