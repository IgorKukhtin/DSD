-- Function: gpUpdate_Object_Retail_PrintKindItem()

DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_PrintKindItem (Integer, Boolean, boolean, boolean, boolean, boolean, boolean, boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Retail_PrintKindItem(
 INOUT ioId                  Integer   ,  -- ���� ������� <�������� ����> 
    IN inisMovement          boolean   , 
    IN inisAccount           boolean   ,
    IN inisTransport         boolean   , 
    IN inisQuality           boolean   , 
    IN inisPack              boolean   , 
    IN inisSpec              boolean   , 
    IN inisTax               boolean   ,
    IN inSession             TVarChar     -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Retail_PrintKindItem());

    -- ��������� <������>
   ioId := lpInsertUpdate_Object_Retail_PrintKindItem (ioId	      := ioId
                                                     , inisMovement   := inisMovement
                                                     , inisAccount    := inisAccount
                                                     , inisTransport  := inisTransport
                                                     , inisQuality    := inisQuality
                                                     , inisPack       := inisPack
                                                     , inisSpec       := inisSpec
                                                     , inisTax        := inisTax
                                                     , inUserId       := vbUserId
                                                      );

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.05.15         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Retail_PrintKindItem(ioId:=null, inCode:=null, inName:='�������� ���� 1', inSession:='2')