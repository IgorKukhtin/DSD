-- Function: gpUpdateObject_Goods_Param()

DROP FUNCTION IF EXISTS gpUpdateObject_Goods_Param (Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_Goods_Param(
    IN inId                  Integer   , -- ���� ������� <�����>
    IN inTaxImport           TVarChar  , -- ������� ���������������� ������
    IN inDKPP                TVarChar  , -- ������� ����� � ����
    IN inTaxAction           TVarChar  , -- ��� ���� �������� �����-�������� ��������������� 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectString_Goods_UKTZED());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������� ��������
     --PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_UKTZED(), inId, inUKTZED);
     -- ��������� ��������
     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_TaxImport(), inId, inTaxImport);
     -- ��������� ��������
     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_DKPP(), inId, inDKPP);
     -- ��������� ��������
     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_TaxAction(), inId, inTaxAction);

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.07.20         *
 10.03.17         *
 06.01.17         *
*/


-- ����
-- SELECT * FROM gpUpdateObject_Goods_Param (ioId:= 275079, inUKTZED:= '456/45', inSession:= '2')
