 -- Function: lpInsertUpdate_Object_DataExcel ()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_DataExcel (Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_DataExcel(
    IN inId             Integer   ,    -- ���� ������� <> 
    IN inCode           Integer   ,    -- ��� ������� 
    IN inName           TVarChar  ,    -- 
    IN inUserId         Integer -- ������ ������������
)
RETURNS VOID
AS
$BODY$
BEGIN
 
       -- ���������/�������� <������> �� ��
       inId := lpInsertUpdate_Object (inId, zc_Object_DataExcel(), inCode, inName);

       -- ��������� �������� <���� ��������>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), inId, CURRENT_TIMESTAMP);
       -- ��������� �������� <������������ (��������)>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), inId, inUserId);

       -- ��������� ��������
       PERFORM lpInsert_ObjectProtocol (inId, inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.
 30.10.17         *
*/

-- ����
--