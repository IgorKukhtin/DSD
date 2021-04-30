-- Function: gpUpdate_Object_PartnerCategory_Load()

DROP FUNCTION IF EXISTS gpUpdate_Object_PartnerCategory_Load (Integer, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_PartnerCategory_Load(
    IN inId              Integer   , --
    IN inCategory        TFloat    , -- ���������
    IN inSession         TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId         Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_Category());

     IF COALESCE (inId,0) = 0
     THEN
         RETURN;
     END IF;

     -- ��������
     IF COALESCE (inCategory,0) = 0
     THEN
         RETURN;
     END IF;

     -- ��������
     IF NOT EXISTS (SELECT 1 FROM Object WHERE Object.Id = inId AND Object.DescId = zc_Object_Partner())
     THEN
         RAISE EXCEPTION '������.���������� � <����-2> = <%> �� ������', inId;
     END IF;

     -- ��������� �������� <inCategory>
     PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Partner_Category(), inId, inCategory);
   
   
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.04.21         *
*/

-- ����
--