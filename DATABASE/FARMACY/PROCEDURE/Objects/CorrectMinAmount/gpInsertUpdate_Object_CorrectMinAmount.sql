-- Function: gpInsertUpdate_Object_CorrectMinAmount()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CorrectMinAmount (Integer, Integer, TDateTime, TFloat, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CorrectMinAmount(
 INOUT ioId                      Integer   ,   	-- ���� ������� <>
    IN inPayrollTypeId           Integer   ,    -- ��� ������� ���������� �����
    IN inDateStart               TDateTime ,    -- ���� ������ ��������
    IN inAmount                  TFloat    ,    -- ����� �������������
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CorrectMinAmount());
   vbUserId := lpGetUserBySession (inSession); 
   inDateStart := DATE_TRUNC ('DAY', inDateStart);
   
   IF COALESCE(inPayrollTypeId, 0) = 0
   THEN
     RAISE EXCEPTION '�� ��������� <��� ������� ���������� �����>';
   END IF;

   IF inDateStart IS NULL OR inDateStart < DATE_TRUNC ('MONTH', CURRENT_DATE)
   THEN
     RAISE EXCEPTION '�� ��������� <���� ������ ��������> ��� ������ �������� ������';
   END IF;

   IF EXISTS(SELECT * FROM gpSelect_Object_CorrectMinAmount (inPayrollTypeId, TRUE, inSession) AS CMA 
             WHERE CMA.ID <> COALESCE(ioId, 0) AND CMA.DateStart = inDateStart)
   THEN
     RAISE EXCEPTION '���� ������ �������� ������ ���� ����������.';
   END IF;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_CorrectMinAmount(), 0, '');

   -- ��������� ����� � <��� ������� ���������� �����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CorrectMinAmount_PayrollType(), ioId, inPayrollTypeId);

   -- ��������� �������� <���� ������ ��������>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_CorrectMinAmount_Date(), ioId, inDateStart);

   -- ��������� �������� <����� �������������>
   PERFORM lpInsertUpdate_ObjecTFloat(zc_ObjectFloat_CorrectMinAmount_Amount(), ioId, inAmount);

   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.06.21                                                       *
*/

-- ����
-- select * from gpInsertUpdate_Object_CorrectMinAmount(ioId := 0 , inPayrollTypeId := 11936842 , inDateStart := ('01.07.2021')::TDateTime , inAmount := 20 ,  inSession := '3');