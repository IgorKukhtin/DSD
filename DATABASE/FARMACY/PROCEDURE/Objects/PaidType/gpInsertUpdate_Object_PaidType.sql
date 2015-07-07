-- Function: gpInsertUpdate_Object_PaidType (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PaidType (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PaidType(
 INOUT ioId                       Integer   ,    -- ���� ������� < ��� ������ >
    IN inPaidTypeCode             Integer   ,    -- ��� ������ (0 ���, 1 �����)
    IN inPaidTypeName             TVarChar  ,    -- �������� ���� ������
    IN inSession                  TVarChar       -- ������ ������������
)
AS
$BODY$
   DECLARE
     vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_PaidType());
  vbUserId := inSession;

  -- ��������� ������������ ���� ���� ������
  IF not (inPaidTypeCode in (-10,0,1))
  THEN
    RAISE EXCEPTION '������.��� ���� ������ <%> ������ ���� ���� 0 ���� 1.', inPaidType;
  END IF;
   
  -- ���� ����� ������ ���� - ������� � ����� ��� ���� ������
  SELECT Object_PaidType_View.Id
    INTO ioId
  from Object_PaidType_View
  Where
    Object_PaidType_View.PaidTypeCode = inPaidTypeCode;
  -- ���������/�������� <������> �� ��
  ioId := lpInsertUpdate_Object (ioId, zc_Object_PaidType(), inPaidTypeCode, inPaidTypeName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_PaidType (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.06.15                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_PaidType(0,-10,'����','3')
-- SELECT * FROM lpdelete_object(402721,'3')
