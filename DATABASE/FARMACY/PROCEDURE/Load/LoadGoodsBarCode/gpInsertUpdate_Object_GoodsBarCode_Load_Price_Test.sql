-- Function: gpInsertUpdate_Object_GoodsBarCode_Load_Price_Test

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsBarCode_Load_Price_Test (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsBarCode_Load_Price_Test (
    IN inJuridicalId      Integer,   -- ���������
    IN inSession          TVarChar   -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      vbUserId:= lpGetUserBySession (inSession);
      
      
      IF COALESCE (inJuridicalId, 0) = 0
      THEN
          RAISE EXCEPTION '������. �� ������� ��.����';
      END IF;
            
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 11.07.17         *
*/
