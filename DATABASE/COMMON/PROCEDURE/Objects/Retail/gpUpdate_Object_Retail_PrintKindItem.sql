-- Function: gpUpdate_Object_Retail_PrintKindItem()

DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_PrintKindItem (Integer, Boolean, boolean, boolean, boolean, boolean, boolean, boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_PrintKindItem (Integer, Boolean, boolean,boolean, boolean, boolean, boolean, boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_PrintKindItem (Integer, Integer,Integer, Boolean, boolean,boolean, boolean, boolean, boolean, boolean, boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Retail_PrintKindItem(
    INOUT ioId                  Integer   ,  -- ���� ������� <> 
       IN inBranchId            Integer   ,  -- ���� ������� <������> 
      OUT outBranchName         TVarChar  ,  -- ������������ ������� <������>  
       IN inRetailId            Integer   ,  -- ���� ������� <�������� ����> 
    INOUT ioisMovement          boolean   , 
    INOUT ioisAccount           boolean   ,
    INOUT ioisTransport         boolean   , 
    INOUT ioisQuality           boolean   , 
    INOUT ioisPack              boolean   , 
    INOUT ioisSpec              boolean   , 
    INOUT ioisTax               boolean   ,
    INOUT ioisTransportBill     boolean   ,  -- ������������
    INOUT ioCountMovement       TFloat    ,  -- ���������
    INOUT ioCountAccount        TFloat    ,  -- ����
    INOUT ioCountTransport      TFloat    ,  -- ���
    INOUT ioCountQuality        TFloat    ,  -- ������������
    INOUT ioCountPack           TFloat    ,  -- �����������
    INOUT ioCountSpec           TFloat    ,  -- ������������
    INOUT ioCountTax            TFloat    ,  -- ���������
    INOUT ioCountTransportBill  TFloat    ,  -- ������������
       IN inSession             TVarChar     -- ������ ������������
)
  RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Retail_PrintKindItem());

    -- ��������, ���� �� ������ ������ ������ �� ����������
    IF COALESCE (inBranchId,0) = 0
    THEN
      RAISE EXCEPTION '�� ������ ������.';
     END IF;


    -- ��������� <������>
   ioId := lpInsertUpdate_Object_Retail_PrintKindItem (ioId	         := ioId
                                                     , inBranchId        := inBranchId
                                                     , inRetailId        := inRetailId
                                                     , inisMovement      := ioisMovement
                                                     , inisAccount       := ioisAccount
                                                     , inisTransport     := ioisTransport
                                                     , inisQuality       := ioisQuality
                                                     , inisPack          := ioisPack
                                                     , inisSpec          := ioisSpec
                                                     , inisTax           := ioisTax
                                                     , inisTransportBill := ioisTransportBill
                                                     , inCountMovement   := ioCountMovement
                                                     , inCountAccount    := ioCountAccount
                                                     , inCountTransport  := ioCountTransport
                                                     , inCountQuality    := ioCountQuality
                                                     , inCountPack       := ioCountPack
                                                     , inCountSpec       := ioCountSpec
                                                     , inCountTax        := ioCountTax
                                                     , inCountTransportBill := ioCountTransportBill
                                                     , inUserId          := vbUserId
                                                      );

     -- ���������� ���������
    SELECT tmp.isMovement, tmp.isAccount, tmp.isTransport
          , tmp.isQuality, tmp.isPack, tmp.isSpec, tmp.isTax, tmp.isTransportBill
          , tmp.CountMovement, tmp.CountAccount, tmp.CountTransport
          , tmp.CountQuality, tmp.CountPack, tmp.CountSpec, tmp.CountTax, tmp.CountTransportBill

          , Object_Branch.ValueData  AS BranchName

    INTO ioisMovement, ioisAccount, ioisTransport, ioisQuality, ioisPack, ioisSpec, ioisTax, ioisTransportBill
       , ioCountMovement,ioCountAccount, ioCountTransport, ioCountQuality, ioCountPack, ioCountSpec, ioCountTax, ioCountTransportBill
       , outBranchName  
    FROM ObjectLink AS ObjectLink_PrintKindItem
       INNER JOIN lpSelect_Object_PrintKindItem() AS tmp ON tmp.Id = ObjectLink_PrintKindItem.ChildObjectId

       LEFT JOIN ObjectLink AS ObjectLink_Branch
                            ON ObjectLink_Branch.ObjectId = ObjectLink_PrintKindItem.ObjectId
                           AND ObjectLink_Branch.DescId = zc_ObjectLink_BranchPrintKindItem_Branch()
       LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Branch.ChildObjectId
        
    WHERE ObjectLink_PrintKindItem.DescId = zc_ObjectLink_BranchPrintKindItem_PrintKindItem()  
    and ObjectLink_PrintKindItem.ObjectId = ioId;

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