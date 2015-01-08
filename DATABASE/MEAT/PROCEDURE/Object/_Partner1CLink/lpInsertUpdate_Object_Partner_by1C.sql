-- Function: lpInsertUpdate_Object_Partner_by1C (Integer, Integer, TVarChar, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Partner_by1C (Integer, Integer, TVarChar, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Partner_by1C(
 INOUT ioId                     Integer,    -- ���� �������
    IN inCode                   Integer,    -- ��� �������
    IN inName                   TVarChar,   -- �������� �������
    IN inJuridicalId            Integer ,   -- ����������� ����
    IN inUserId                 Integer     -- ������������
)
  RETURNS Integer
AS
$BODY$
BEGIN
   -- ��������
   IF COALESCE (inName, '') = '' THEN
       RAISE EXCEPTION '������.�� ����������� <��������>.';
   END IF;

   -- �������� ������������ <��������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Partner(), inName);


   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Partner(), inCode, inName);

   -- ��������� ����� � <����������� ����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_Juridical(), ioId, inJuridicalId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.01.15                                        *
*/
