-- ����������

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Client (Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Client(
 INOUT ioId                       Integer   ,    -- ���� ������� <����������>
 INOUT ioCode                     Integer   ,    -- ��� ������� <����������>
    IN inName                     TVarChar  ,    -- �������� ������� <����������>
    IN inDiscountCard             TVarChar  ,    -- ����� �����
    IN inDiscountTax              TFloat    ,    -- ������� ������
    IN inDiscountTaxTwo           TFloat    ,    -- ������� ������ �������������
    IN inAddress                  TVarChar  ,    -- �����
    IN inHappyDate                TDateTime ,    -- ���� ��������
    IN inPhoneMobile              TVarChar  ,    -- ��������� �������
    IN inPhone                    TVarChar  ,    -- �������
    IN inMail                     TVarChar  ,    -- ����������� �����
    IN inComment                  TVarChar  ,    -- ����������
    IN inCityId                   Integer   ,    -- ���������� �����
    IN inDiscountKindId           Integer   ,    -- ��� ������������� ������
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbName_Sybase TVarChar;
   DECLARE vbName_Sybase2 TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Client());
   vbUserId:= lpGetUserBySession (inSession);


   -- !!!������!!!
   inName:= TRIM (inName);


   -- �������� - ��� Sybase ������ Id
   IF vbUserId = zc_User_Sybase()
   THEN
       -- !!!����� - �� �2 !!!
       vbName_Sybase2:= (SELECT gpGet_Object_Client_NEW2_SYBASE (inName));
       
       IF vbName_Sybase2 <> ''
       THEN
           vbName_Sybase:= vbName_Sybase2;
       ELSE
           -- !!!�����!!!
           vbName_Sybase:= (SELECT gpGet_Object_Client_NEW_SYBASE (inName));

           -- !!!����� - �� �2 + ��� vbName_Sybase!!!
           vbName_Sybase2:= (SELECT gpGet_Object_Client_NEW2_SYBASE (vbName_Sybase));
           --
           IF vbName_Sybase2 <> ''
           THEN
               vbName_Sybase:= vbName_Sybase2;
           END IF;

       END IF;
       
       -- !!!������!!!
       IF vbName_Sybase <> '' THEN inName:=  vbName_Sybase; END IF;

       -- !!!������!!!
       ioId:= (SELECT Object.Id
               FROM Object
               WHERE Object.DescId    = zc_Object_Client()
                 AND TRIM (LOWER (Object.ValueData)) = TRIM (LOWER (inName))
              );

       -- ��������� ���������� !!!�������!!!
       IF ioId > 0 AND TRIM (inComment) = ''
       THEN inComment:= COALESCE ((SELECT ObjectString.ValueData FROM ObjectString WHERE ObjectString.ObjectId = ioId AND ObjectString.DescId = zc_ObjectString_Client_Comment()), '');
       END IF;
       
       -- ��������� ���������� !!!DiscountTax!!!
       IF ioId > 0 AND COALESCE (inDiscountTax, 0) = 0
       THEN inDiscountTax:= COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = ioId AND ObjectFloat.DescId = zc_ObjectFloat_Client_DiscountTax()), 0);
       END IF;

       -- ��������� ���������� !!!DiscountTax!!!
       IF ioId > 0 AND inDiscountTax > 0 AND inDiscountTax > COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ValueData <> 0 AND ObjectFloat.ObjectId = ioId AND ObjectFloat.DescId = zc_ObjectFloat_Client_DiscountTax()), inDiscountTax)
       THEN inDiscountTax:= COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ValueData <> 0 AND ObjectFloat.ObjectId = ioId AND ObjectFloat.DescId = zc_ObjectFloat_Client_DiscountTax()), inDiscountTax);
       END IF;

   END IF;



   -- ����� ������- ��� ����� ����� � ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) <> 0 THEN ioCode := NEXTVAL ('Object_Client_seq');
   END IF;

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) = 0  THEN ioCode := NEXTVAL ('Object_Client_seq');
   ELSEIF ioCode = 0
       THEN ioCode:= (SELECT ObjectCode FROM Object WHERE Id = ioId);
   END IF;


   -- ��������
   IF TRIM (inName) = '' THEN
      RAISE EXCEPTION '������.���������� ������ ��������.';
   END IF;

   -- �������� - ������ > 30%
   IF vbUserId <> zc_User_Sybase()
      AND (inDiscountTax > 30 OR inDiscountTaxTwo > 30)
   THEN
       PERFORM lpCheckRight (inSession, zc_Enum_Process_Update_Object_Client_DiscountTax());
   END IF;
   -- �������� - ������ DiscountTaxTwo
   IF ((ioId > 0 AND inDiscountTaxTwo <> COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = ioId AND ObjectFloat.DescId = zc_ObjectFloat_Client_DiscountTaxTwo()), 0))
    OR (ioId = 0 AND inDiscountTaxTwo <> 0)
      )
      -- ���� ��� ������������ ��������
      AND lpGetUnit_byUser (vbUserId) > 0
      -- ���� � ���� �������� ��� ������ ������
      AND 0 = COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = lpGetUnit_byUser (vbUserId) AND OL.DescId = zc_ObjectLink_Unit_GoodsGroup()), 0)
      -- 
      AND vbUserId <> zc_User_Sybase()
   THEN
       PERFORM lpCheckRight (inSession, zc_Enum_Process_Update_Object_Client_DiscountTaxTwo());
   END IF;



   -- �������� ���� ������������ ��� �������� <��������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Client(), inName);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Client(), ioCode, inName);

   -- ��������� ����� �����
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Client_DiscountCard(), ioId, inDiscountCard);
   -- ��������� ������� ������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_DiscountTax(), ioId, inDiscountTax);
   -- ��������� ������� ������ �������������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_DiscountTaxTwo(), ioId, inDiscountTaxTwo);
   -- ��������� �����
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Client_Address(), ioId, inAddress);
   -- ��������� ���� ��������
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Client_HappyDate(), ioId, inHappyDate);
   -- ��������� ��������� �������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Client_PhoneMobile(), ioId, inPhoneMobile);
   -- ��������� �������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Client_Phone(), ioId, inPhone);
   -- ��������� ����������� �����
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Client_Mail(), ioId, inMail);
   -- ��������� ����������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Client_Comment(), ioId, inComment);

   -- ��������� ����� � <���������� �����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Client_City(), ioId, inCityId);
   -- ��������� ����� � <��� ������������� ������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Client_DiscountKind(), ioId, inDiscountKindId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
13.05.17                                                           *
02.03.17                                                           *
01.03.17                                                           *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Client()
