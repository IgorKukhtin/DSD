-- Function: gpInsertUpdate_Object_OrderShedule()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_OrderShedule (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_OrderShedule(
 INOUT ioId                       Integer ,   	-- ���� ������� <�������>
    IN inCode                     Integer ,    -- ��� ������� <>
    IN inValue1                   TVarChar  ,
    IN inValue2                   TVarChar  ,
    IN inValue3                   TVarChar  ,
    IN inValue4                   TVarChar  ,
    IN inValue5                   TVarChar  ,
    IN inValue6                   TVarChar  ,
    IN inValue7                   TVarChar  ,
    IN inUnitId                   Integer ,    -- ������ �������������
    IN inContractId               Integer ,    -- ������ �� �������
    IN inSession                  TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  
   DECLARE vbName TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_OrderShedule());
   vbUserId:= inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1 
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_OrderShedule());
    
    -- �������� ������������  �� ������� � �������������
    IF COALESCE(ioId,0) = 0 THEN
       IF EXISTS (SELECT ObjectLink_OrderShedule_Contract.ObjectId
                  FROM ObjectLink AS ObjectLink_OrderShedule_Contract
                     INNER JOIN ObjectLink AS ObjectLink_OrderShedule_Unit
                             ON ObjectLink_OrderShedule_Unit.ObjectId = ObjectLink_OrderShedule_Contract.ObjectId
                            AND ObjectLink_OrderShedule_Unit.DescId = zc_ObjectLink_OrderShedule_Unit()
                            AND ObjectLink_OrderShedule_Unit.ChildObjectId = inUnitId
                  WHERE ObjectLink_OrderShedule_Contract.DescId = zc_ObjectLink_OrderShedule_Contract()
                    AND ObjectLink_OrderShedule_Contract.ChildObjectId = inContractId
                  ) 
       THEN
          RAISE EXCEPTION '������ �� ��������� - ������ = "%" ������� "%" .', inUnitId, inContractId;
       END IF;
    END IF;

   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_OrderShedule(), vbCode_calc);

   vbName:= (inValue1||';'||inValue2||';'||inValue3||';'||inValue4||';'||inValue5||';'||inValue6||';'||inValue7) :: TVarChar;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_OrderShedule(), vbCode_calc, vbName);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_OrderShedule_Contract(), ioId, inContractId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_OrderShedule_Unit(), ioId, inUnitId);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.09.16         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_OrderShedule ()                            
