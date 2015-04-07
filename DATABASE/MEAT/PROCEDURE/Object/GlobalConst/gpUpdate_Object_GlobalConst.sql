-- Function: gpInsertUpdate_Object_Car(Integer,Integer,TVarChar,TVarChar,TDateTime,TDateTime,Integer,Integer,Integer,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_GlobalConst (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GlobalConst(
 INOUT ioId                       Integer   ,    -- ���� �������  
    IN inActualBankStatementDate  TDateTime ,    -- ����
    IN inSession                  TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������

   -- ��������� <���� ���������� �������>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_GlobalConst_ActualBankStatement(), ioId, inActualBankStatementDate);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_GlobalConst (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.06.15                         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Car()
