-- Function: lpInsertFind_Object_PartionModel (TVarChar, Integer)

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionModel (TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionModel(
    IN inPartionModelName TVarChar, -- ������ ������
    IN inUserId           Integer   -- ������������
)
RETURNS Integer
AS
$BODY$
  DECLARE vbPartionModelId Integer;
BEGIN

   -- ��������
   IF COALESCE (TRIM (inPartionModelName), '') = ''
   THEN
       vbPartionModelId:= 0;
   ELSE
       vbPartionModelId:= (SELECT Id  FROM Object WHERE DescId = zc_Object_PartionModel() AND ValueData ILIKE inPartionModelName);
       --
       IF COALESCE (vbPartionModelId, 0) = 0
       THEN
           -- ��������� <������>
           vbPartionModelId := lpInsertUpdate_Object (vbPartionModelId, zc_Object_PartionModel(), 0, inPartionModelName);

       END IF;

   END IF;
   
   -- ���������� ��������
   RETURN vbPartionModelId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.05.23                                        *
*/

-- ����
-- SELECT * FROM lpInsertFind_Object_PartionModel (inPartionModelName:= '�������', inUserId:= 5)
