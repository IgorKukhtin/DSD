-- Function: gpInsertUpdate_Object_MedicForSale()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MedicForSale(Integer, TVarChar TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MedicForSale(
 INOUT ioId             Integer   ,     -- ���� ������� <����������> 
    IN inName           TVarChar  ,     -- ������� ��� ��������
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_MedicForSale());

   -- ���� ���������� �� �����
   IF EXISTS (SELECT ValueData FROM Object WHERE DescId = zc_Object_MedicForSale() AND TRIM(UPPER(ValueData)) = TRIM(UPPER(inName))) 
   THEN
      SELECT ID INTO ioId FROM Object WHERE DescId = zc_Object_MedicForSale() AND TRIM(UPPER(ValueData)) = TRIM(UPPER(inName));
      RETURN;
   ELSE
     ioId := 0;
   END IF; 


   -- �������� ����� ���
   IF ioId <> 0 THEN vbCode_calc := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (vbCode_calc, zc_Object_MedicForSale());
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MedicForSale(), vbCode_calc, inName);
      
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.12.19                                                       *
*/

-- ���� select gpInsertUpdate_Object_MedicForSale(0, '������� �.�.', '3');


