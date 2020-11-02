-- Function: gpInsertUpdate_Object_BuyerForSale()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BuyerForSale(Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BuyerForSale(Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BuyerForSale(
 INOUT ioId             Integer   ,     -- ���� ������� <����������> 
    IN inName           TVarChar  ,     -- ������� ��� ��������
    IN inPhone          TVarChar  ,     -- �������
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_BuyerForSale());

   -- ���� ���������� �� �����
   IF EXISTS (SELECT ValueData FROM Object WHERE DescId = zc_Object_BuyerForSale() AND TRIM(UPPER(ValueData)) = TRIM(UPPER(inName))) 
   THEN
      SELECT ID INTO ioId FROM Object WHERE DescId = zc_Object_BuyerForSale() AND TRIM(UPPER(ValueData)) = TRIM(UPPER(inName));
      RETURN;
   ELSE
     ioId := 0;
   END IF; 


   -- �������� ����� ���
   IF ioId <> 0 THEN vbCode_calc := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (vbCode_calc, zc_Object_BuyerForSale());
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_BuyerForSale(), vbCode_calc, inName);
      
   -- ��������� �������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_BuyerForSale_Phone(), ioId, inPhone);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.12.19                                                       *
*/

-- ���� select gpInsertUpdate_Object_BuyerForSale(0, '������� �.�.', '3');


