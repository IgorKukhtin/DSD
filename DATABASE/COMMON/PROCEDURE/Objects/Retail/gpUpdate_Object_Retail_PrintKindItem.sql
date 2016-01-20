-- Function: gpUpdate_Object_Retail_PrintKindItem()

DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_PrintKindItem (Integer, Boolean, boolean, boolean, boolean, boolean, boolean, boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_PrintKindItem (Integer, Boolean, boolean, boolean, boolean, boolean, boolean, boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Retail_PrintKindItem(
 INOUT ioId                  Integer   ,  -- ���� ������� <�������� ����> 
    IN inisMovement          boolean   , 
    IN inisAccount           boolean   ,
    IN inisTransport         boolean   , 
    IN inisQuality           boolean   , 
    IN inisPack              boolean   , 
    IN inisSpec              boolean   , 
    IN inisTax               boolean   ,
    IN inCountMovement       TFloat,   -- ���������
    IN inCountAccount        TFloat,   -- ����
    IN inCountTransport      TFloat,   -- ���
    IN inCountQuality        TFloat,   -- ������������
    IN inCountPack           TFloat,   -- �����������
    IN inCountSpec           TFloat,   -- ������������
    IN inCountTax            TFloat,   -- ���������
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
                                                     , inCountMovement   := inCountMovement
                                                     , inCountAccount    := inCountAccount
                                                     , inCountTransport  := inCountTransport
                                                     , inCountQuality    := inCountQuality
                                                     , inCountPack       := inCountPack
                                                     , inCountSpec       := inCountSpec
                                                     , inCountTax        := inCountTax
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
 19.01.16         *
 21.05.15         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Retail_PrintKindItem(ioId:=null, inCode:=null, inName:='�������� ���� 1', inSession:='2')