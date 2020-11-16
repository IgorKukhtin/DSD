-- Function: gpInsertUpdate_Object_ContractTradeMark  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractTradeMark (Integer,Integer,Integer,Integer,TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractTradeMark(
 INOUT ioId                Integer   ,    -- ���� ������� <> 
    IN inCode              Integer   ,    -- ��� ������� <>
    IN inContractId        Integer   ,    --   
    IN inTradeMarkId       Integer   ,    -- 
    IN inSession           TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ContractTradeMark());
   vbUserId:= lpGetUserBySession (inSession);
   
   -- ��������
   IF COALESCE (inContractId,0) = 0
   THEN
       RAISE EXCEPTION '������.������� �� ������.';
   END IF;
   IF COALESCE (inTradeMarkId,0) = 0
   THEN
       RAISE EXCEPTION '������.�������� ����� �� �������.';
   END IF;
   
      
   ioId := lpInsertUpdate_Object_ContractTradeMark(ioId          := ioId          :: Integer
                                                 , inCode        := inCode        ::Integer
                                                 , inContractId  := inContractId
                                                 , inTradeMarkId := inTradeMarkId
                                                 , inUserId      := vbUserId
                                                  );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.11.20         *
*/

-- ����
--