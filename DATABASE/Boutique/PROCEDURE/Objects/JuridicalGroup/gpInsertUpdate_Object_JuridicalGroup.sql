-- Function: gpInsertUpdate_Object_JuridicalGroup (Integer,Integer,TVarChar,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalGroup (Integer,Integer,TVarChar,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_JuridicalGroup(
 INOUT ioId                       Integer   ,    -- ���� ������� <������ ����������� ���> 
 INOUT ioCode                     Integer   ,    -- ��� ������� <������ ����������� ���>
    IN inName                     TVarChar  ,    -- �������� ������� <������ ����������� ���>
    IN inParentId                 Integer   ,    -- ���� ������� <������ ����������� ���> 
    IN inSession                  TVarChar       -- ������ ������������  
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer; 
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_JuridicalGroup());
   vbUserId:= lpGetUserBySession (inSession);

   -- ����� ������- ��� ����� ����� � ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) <> 0 THEN ioCode := NEXTVAL ('Object_JuridicalGroup_seq'); 
   END IF; 

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) = 0  THEN ioCode := NEXTVAL ('Object_JuridicalGroup_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);
   END IF; 
 
   -- �������� ���� ������������ ��� �������� <������������ >
   --PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_JuridicalGroup(), inName);

   -- �������� ������������ <������������> ��� !!!�����!! <������ ����������� ���>
   IF TRIM (inName) <> '' AND COALESCE (inParentId, 0) <> 0 
   THEN
       IF EXISTS (SELECT Object.Id
                  FROM Object
                       JOIN ObjectLink AS ObjectLink_JuridicalGroup_Parent
                                       ON ObjectLink_JuridicalGroup_Parent.ObjectId = Object.Id
                                      AND ObjectLink_JuridicalGroup_Parent.DescId = zc_ObjectLink_JuridicalGroup_Parent()
                                      AND ObjectLink_JuridicalGroup_Parent.ChildObjectId = inParentId
                                   
                  WHERE TRIM (Object.ValueData) = TRIM (inName)
                   AND Object.Id <> COALESCE (ioId, 0))
       THEN
           RAISE EXCEPTION '������. ������ ����������� ��� <%> ��� ����������� � <%>.', TRIM (inName), lfGet_Object_ValueData (inParentId);
       END IF;
   END IF;


   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_JuridicalGroup(), ioCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_JuridicalGroup(), ioCode, inName);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_JuridicalGroup_Parent(), ioId, inParentId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
13.05.17                                                           *
06.03.17                                                           *
27.02.17                                                           *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_JuridicalGroup()
