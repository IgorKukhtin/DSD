-- Function: lpInsertUpdate_Object_Juridicall_PrintKindItem()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Juridical_PrintKindItem(Integer, Boolean, boolean, boolean, boolean, boolean, boolean, boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Juridical_PrintKindItem(
 INOUT ioId                  Integer   ,     -- ���� ������� <�������� ����> 
    IN inisMovement          boolean   , 
    IN inisAccount           boolean   ,
    IN inisTransport         boolean   , 
    IN inisQuality           boolean   , 
    IN inisPack              boolean   , 
    IN inisSpec              boolean   , 
    IN inisTax               boolean   ,
    IN inUserId              Integer       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbId_calc Integer;   
BEGIN
   
   vbId_calc := lpInsertFind_Object_PrintKindItem(inisMovement, inisAccount, inisTransport, inisQuality, inisPack, inisSpec, inisTax );
   
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Juridical_PrintKindItem(), ioId, vbId_calc);
 
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.05.15         * 
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Object_Juridical_PrintKindItem(ioId:=null, inCode:=null, inName:='�������� ���� 1', inSession:='2')