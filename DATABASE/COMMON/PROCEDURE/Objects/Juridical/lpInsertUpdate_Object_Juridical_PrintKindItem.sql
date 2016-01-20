-- Function: lpInsertUpdate_Object_Juridicall_PrintKindItem()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Juridical_PrintKindItem(Integer, Boolean, boolean, boolean, boolean, boolean, boolean, boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Juridical_PrintKindItem(Integer, Boolean, boolean, boolean, boolean, boolean, boolean, boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Juridical_PrintKindItem(
 INOUT ioId                  Integer   ,     -- ���� ������� <�������� ����> 
    IN inisMovement          boolean   , 
    IN inisAccount           boolean   ,
    IN inisTransport         boolean   , 
    IN inisQuality           boolean   , 
    IN inisPack              boolean   , 
    IN inisSpec              boolean   , 
    IN inisTax               boolean   ,
    IN inCountMovement       TFloat,   -- ���������
    IN inCountAccount        TFloat,   -- ����
    IN inCountTransport      TFloat,   -- ���
    IN inCountQuality        TFloat,   -- ������������
    IN inCountPack           TFloat,   -- �����������
    IN inCountSpec           TFloat,   -- ������������
    IN inCountTax            TFloat,   -- ���������
    IN inUserId              Integer       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbId_calc Integer;   
BEGIN
   -- !!!������!!!
   IF inCountMovement  > 0 THEN inIsMovement:= TRUE;  ELSE inIsMovement:= FALSE; END IF;
   IF inCountAccount   > 0 THEN inIsAccount:= TRUE;   ELSE inIsAccount:= FALSE; END IF;
   IF inCountTransport > 0 THEN inIsTransport:= TRUE; ELSE inIsTransport:= FALSE; END IF; 
   IF inCountQuality   > 0 THEN inIsQuality:= TRUE;   ELSE inIsQuality:= FALSE; END IF;
   IF inCountPack      > 0 THEN inIsPack:= TRUE;      ELSE inIsPack:= FALSE; END IF;
   IF inCountSpec      > 0 THEN inIsSpec:= TRUE;      ELSE inIsSpec:= FALSE; END IF;
   IF inCountTax       > 0 THEN inIsTax:= TRUE;       ELSE inIsTax:= FALSE; END IF;
   
   -- !!!����� ��� ��������!!!
   vbId_calc := lpInsertFind_Object_PrintKindItem(inisMovement, inisAccount, inisTransport, inisQuality, inisPack, inisSpec, inisTax , inCountMovement, inCountAccount, inCountTransport, inCountQuality, inCountPack, inCountSpec, inCountTax);
   
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
 19.01.16         * 
 21.05.15         * 
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Object_Juridical_PrintKindItem(ioId:=null, inCode:=null, inName:='�������� ���� 1', inSession:='2')