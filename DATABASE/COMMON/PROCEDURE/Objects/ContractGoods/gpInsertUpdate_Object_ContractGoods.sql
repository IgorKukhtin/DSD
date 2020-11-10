-- Function: gpInsertUpdate_Object_ContractGoods  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractGoods (Integer,Integer,Integer,Integer,Integer, Tfloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractGoods (Integer,Integer,Integer,Integer,Integer, TDateTime, TDateTime, Tfloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractGoods(
 INOUT ioId                Integer   ,    -- ���� ������� < �����/��������> 
    IN inCode              Integer   ,    -- ��� ������� <>
    IN inContractId        Integer   ,    --   
    IN inGoodsId           Integer   ,    -- 
    IN inGoodsKindId       Integer   ,    --
    IN inStartDate         TDateTime ,    --
    IN inEndDate           TDateTime ,    --   
    IN inPrice             Tfloat    ,
    IN inSession           TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ContractGoods());
   
   ioId := lpInsertUpdate_Object_ContractGoods(ioId          := ioId          :: Integer
                                             , inCode        := inCode        ::Integer
                                             , inContractId  := inContractId
                                             , inGoodsId     := inGoodsId
                                             , inGoodsKindId := inGoodsKindId ::Integer
                                             , inStartDate   := inStartDate   ::TDateTime    --
                                             , inEndDate     := inEndDate     ::TDateTime    --
                                             , inPrice       := inPrice       ::Tfloat    
                                             , inUserId      := vbUserId
                                              );

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.02.15         *

*/

-- ����
--