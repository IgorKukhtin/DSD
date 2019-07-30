-- Function: gpUpdate_Object_Juridical_OrderFinance()

DROP FUNCTION IF EXISTS gpUpdate_Object_Juridical_OrderFinance (Integer, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Juridical_OrderFinance(
    IN inId                  Integer   ,    -- ���� ������� <����������� ����>
    IN inSummOrderFinance    TFloat    ,    --
    IN inSession             TVarChar       -- ������� ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Juridical());

   -- ��������
   IF COALESCE (inId, 0) = 0
   THEN
      RAISE EXCEPTION '������.������� �� ��������.';
   END IF;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Juridical_SummOrderFinance(), inId, inSummOrderFinance);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.07.19         *
*/

-- ����
--