-- Function: gpUpdate_Object_InvoicePdf_DateUnloading(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_InvoicePdf_DateUnloading(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_InvoicePdf_DateUnloading(
    IN inId                        Integer   , -- ���� ������� <��������>
    IN inSession                   TVarChar    -- ������ ������������
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Product());
   vbUserId:= lpGetUserBySession (inSession);

    -- ��������
   IF COALESCE (inId, 0) = 0
   THEN
      --RAISE EXCEPTION '������! ������� �� ����������!';
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������! ������� ��������� �� ��������!'
                                              , inProcedureName := 'gpUpdate_Object_InvoicePdf_DateUnloading'
                                              , inUserId        := vbUserId
                                              );
   END IF;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_InvoicePdf_DateUnloading(), inId, CURRENT_TIMESTAMP);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);


   -- ��������� �������� <���������� � DropBox (��/���)>
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PostedToDropBox(), (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = inId AND OFl.DescId = zc_ObjectFloat_InvoicePdf_MovementId()) :: Integer, TRUE);

   -- ��������� ��������
   PERFORM lpInsert_MovementProtocol ((SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = inId AND OFl.DescId = zc_ObjectFloat_InvoicePdf_MovementId()) :: Integer, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.02.24                                                       *
*/

-- ����
--