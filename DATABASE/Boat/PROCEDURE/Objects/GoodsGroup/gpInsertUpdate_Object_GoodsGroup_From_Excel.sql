-- Function: gpInsertUpdate_Object_GoodsGroup_From_Excel (Integer,TVarChar,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroup_From_Excel (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsGroup_From_Excel(
    IN inCode                     Integer   ,    -- ��� ������� <������ ������>
    IN inName                     TVarChar  ,    -- �������� ������� <������ ������>
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsGroup());
   vbUserId:= lpGetUserBySession (inSession);

   --�������� ���� �� ��� ����� ������
   IF EXISTS (SELECT 1 FROM Object WHERE Object.DescId = zc_Object_GoodsGroup() AND TRIM (Object.ValueData) ILIKE TRIM(inName))
   THEN
     --RAISE EXCEPTION '������.��� ���������� <%>.', inName;
       RETURN;
   END IF;

   PERFORM gpInsertUpdate_Object_GoodsGroup (ioId              := 0         :: Integer
                                           , ioCode            := inCode    :: Integer
                                           , inName            := inName    :: TVarChar
                                           , inParentId        := 0         :: Integer
                                           , inInfoMoneyId     := 0         :: Integer
                                           , inModelEtiketenId := 0         :: Integer
                                           , inSession         := inSession :: TVarChar
                                            );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
09.11.20          *
*/

-- ����
--