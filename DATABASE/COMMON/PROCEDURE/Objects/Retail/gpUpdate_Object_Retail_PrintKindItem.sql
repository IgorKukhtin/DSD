-- Function: gpUpdate_Object_Retail_PrintKindItem()

DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_PrintKindItem (Integer, Boolean, boolean, boolean, boolean, boolean, boolean, boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_PrintKindItem (Integer, Boolean, boolean, boolean, boolean, boolean, boolean, boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Retail_PrintKindItem(
 INOUT ioId                  Integer   ,  -- ���� ������� <�������� ����> 
    INOUT ioisMovement          boolean   , 
    INOUT ioisAccount           boolean   ,
    INOUT ioisTransport         boolean   , 
    INOUT ioisQuality           boolean   , 
    INOUT ioisPack              boolean   , 
    INOUT ioisSpec              boolean   , 
    INOUT ioisTax               boolean   ,
    INOUT ioCountMovement       TFloat    ,  -- ���������
    INOUT ioCountAccount        TFloat    ,  -- ����
    INOUT ioCountTransport      TFloat    ,  -- ���
    INOUT ioCountQuality        TFloat    ,  -- ������������
    INOUT ioCountPack           TFloat    ,  -- �����������
    INOUT ioCountSpec           TFloat    ,  -- ������������
    INOUT ioCountTax            TFloat    ,  -- ���������
       IN inSession             TVarChar     -- ������ ������������
)
  RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Retail_PrintKindItem());

    -- ��������� <������>
   ioId := lpInsertUpdate_Object_Retail_PrintKindItem (ioId	         := ioId
                                                     , inisMovement      := ioisMovement
                                                     , inisAccount       := ioisAccount
                                                     , inisTransport     := ioisTransport
                                                     , inisQuality       := ioisQuality
                                                     , inisPack          := ioisPack
                                                     , inisSpec          := ioisSpec
                                                     , inisTax           := ioisTax
                                                     , inCountMovement   := ioCountMovement
                                                     , inCountAccount    := ioCountAccount
                                                     , inCountTransport  := ioCountTransport
                                                     , inCountQuality    := ioCountQuality
                                                     , inCountPack       := ioCountPack
                                                     , inCountSpec       := ioCountSpec
                                                     , inCountTax        := ioCountTax
                                                     , inUserId          := vbUserId
                                                      );

     -- ���������� ���������
     SELECT tmp.isMovement, tmp.isAccount, tmp.isTransport
          , tmp.isQuality, tmp.isPack, tmp.isSpec, tmp.isTax
          , tmp.CountMovement, tmp.CountAccount, tmp.CountTransport
          , tmp.CountQuality, tmp.CountPack, tmp.CountSpec, tmp.CountTax
    INTO ioisMovement, ioisAccount, ioisTransport, ioisQuality, ioisPack, ioisSpec, ioisTax
       , ioCountMovement,ioCountAccount, ioCountTransport, ioCountQuality, ioCountPack, ioCountSpec, ioCountTax 
    FROM ObjectLink
       INNER JOIN lpSelect_Object_PrintKindItem() AS tmp ON tmp.Id = ObjectLink.ChildObjectId
    WHERE ObjectLink.DescId = zc_ObjectLink_Retail_PrintKindItem()
    and ObjectLink.ObjectId = ioId;

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