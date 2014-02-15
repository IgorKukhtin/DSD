-- Function: gpInsertUpdate_Object_CardFuel(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_CardFuel (Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CardFuel(
 INOUT ioId                Integer   , -- ���� ������� <��������� �����>
    IN inCode              Integer   , -- �������� <��� >
    IN inName              TVarChar  , -- �������� <������������>
    IN inLimit             TFloat    , -- �����
    IN inPersonalDriverId  Integer   , -- ������ �� ����������
    IN inCarId             Integer   , -- ������ �� ����
    IN inPaidKindId        Integer   , -- ������ �� ���� ���� ������
    IN inJuridicalId       Integer   , -- ������ �� ��.����
    IN inGoodsId           Integer   , -- ������ �� ������
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CardFuel());

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_CardFuel());

   -- �������� ������������ ��� �������� <������������ >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_CardFuel(), inName);
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CardFuel(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_CardFuel(), vbCode_calc, inName
                                , inAccessKeyId:= COALESCE ((SELECT Object_Branch.AccessKeyId FROM ObjectLink LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch ON ObjectLink_Unit_Branch.ObjectId = ObjectLink.ChildObjectId AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch() LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId WHERE ObjectLink.ObjectId = inCarId AND ObjectLink.DescId = zc_ObjectLink_Car_Unit()), zc_Enum_Process_AccessKey_TrasportDnepr()));

   -- ��������� �������� <�����>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CardFuel_Limit(), ioId, inLimit);

   -- ��������� ����� � <�����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CardFuel_PersonalDriver(), ioId, inPersonalDriverId);
   
   -- ��������� ����� � <����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CardFuel_Car(), ioId, inCarId);

   -- ��������� ����� � <���� ���� ������ >
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CardFuel_PaidKind(), ioId, inPaidKindId);

   -- ��������� ����� � <����������� ����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CardFuel_Juridical(), ioId, inJuridicalId);

   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CardFuel_Goods(), ioId, inGoodsId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_CardFuel (Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer,TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.12.13                                        * add inAccessKeyId
 16.10.13                                        * add inLimit
 14.10.13         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_CardFuel (ioId:=148, inCode:=1, inName:='����� 45 ', inPersonalDriverId :=19490, inCarId:= 65594  , inPaidKindId:=  80 , inJuridicalId :=12454 , inGoodsId :=2447 , inSession:= '2')
