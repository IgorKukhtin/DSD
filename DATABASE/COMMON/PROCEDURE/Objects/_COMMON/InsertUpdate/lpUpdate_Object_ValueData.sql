-- Function: lpUpdate_Object_ValueData()

DROP FUNCTION IF EXISTS lpUpdate_Object_ValueData (Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_ValueData(
    IN inId                  Integer   ,    -- ���� ������� <����������> 
    IN inValueData           TVarChar  ,    --
    IN inUserId              Integer        -- ������������
)
  RETURNS VOID
AS
$BODY$
BEGIN
   -- !!!������ �������� �������!!!
   PERFORM lpCheckPeriodClose_auditor (NULL, NULL, NULL, NULL, inId, inUserId);

   -- �������� ������� ����������� �� �������� <���� �������>
   UPDATE Object SET ValueData = inValueData WHERE Id = inId;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.12.14                                        *
*/

-- ����
-- SELECT * FROM lpUpdate_Object_ValueData()
