-- Function: gpInsertUpdate_Object_Client() - ����������

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Client (Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Client (Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);

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
    IN inCurrencyId               Integer   ,    -- ������
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbIsOutlet Boolean;
   DECLARE vbUnitId   Integer;

   DECLARE vbName_Sybase TVarChar;
   DECLARE vbName_Sybase2 TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Client());
   vbUserId:= lpGetUserBySession (inSession);


   -- !!!������!!!
   inName:= TRIM (inName);

   -- �������� - 
   vbUnitId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_User_Unit() AND OL.ObjectId = vbUserId);
   -- ��������
   IF zc_Enum_GlobalConst_isTerry() = TRUE AND COALESCE (vbUnitId, 0) =  0 THEN
      RAISE EXCEPTION '������.��� ���� ��������� ����������.';
   END IF;
   -- �������� - ���������� �� 
   vbIsOutlet := EXISTS (SELECT 1 FROM lfSelect_Object_Unit_isOutlet() AS lfSelect WHERE lfSelect.UnitId = vbUnitId);

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
      AND (inDiscountTax    <> COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = ioId AND ObjectFloat.DescId = zc_ObjectFloat_Client_DiscountTax()),    0)
        OR inDiscountTaxTwo <> COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = ioId AND ObjectFloat.DescId = zc_ObjectFloat_Client_DiscountTaxTwo()), 0)
          )
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
   IF vbIsOutlet = TRUE
   THEN
       IF EXISTS (WITH tmpUnit_isOutlet AS (SELECT * FROM lfSelect_Object_Unit_isOutlet())
                  SELECT 1
                  FROM Object AS Object_Client
                       LEFT JOIN ObjectBoolean AS ObjectBoolean_Client_Outlet
                                               ON ObjectBoolean_Client_Outlet.ObjectId = Object_Client.Id
                                              AND ObjectBoolean_Client_Outlet.DescId   = zc_ObjectBoolean_Client_Outlet()
                       LEFT JOIN ObjectLink AS ObjectLink_Client_InsertUnit
                                            ON ObjectLink_Client_InsertUnit.ObjectId = Object_Client.Id
                                           AND ObjectLink_Client_InsertUnit.DescId   = zc_ObjectLink_Client_InsertUnit()
                       LEFT JOIN tmpUnit_isOutlet ON tmpUnit_isOutlet.UnitId = ObjectLink_Client_InsertUnit.ChildObjectId
                  WHERE Object_Client.DescId = zc_Object_Client()
                    AND LOWER (TRIM (Object_Client.ValueData)) = LOWER (TRIM (inName))
                    AND Object_Client.Id <> COALESCE (ioId, 0)
                    AND (tmpUnit_isOutlet.UnitId > 0 OR ObjectBoolean_Client_Outlet.ValueData = TRUE)
                 )
       THEN
            RAISE EXCEPTION '������ ����������.�������� <%> ��� ����������.', inName;
       END IF;
   ELSE
       IF EXISTS (WITH tmpUnit_isOutlet AS (SELECT * FROM lfSelect_Object_Unit_isOutlet())
                  SELECT 1
                  FROM Object AS Object_Client
                       LEFT JOIN ObjectLink AS ObjectLink_Client_InsertUnit
                                            ON ObjectLink_Client_InsertUnit.ObjectId = Object_Client.Id
                                           AND ObjectLink_Client_InsertUnit.DescId   = zc_ObjectLink_Client_InsertUnit()
                       LEFT JOIN tmpUnit_isOutlet ON tmpUnit_isOutlet.UnitId = ObjectLink_Client_InsertUnit.ChildObjectId
                  WHERE Object_Client.DescId = zc_Object_Client()
                    AND LOWER (TRIM (Object_Client.ValueData)) = LOWER (TRIM (inName))
                    AND Object_Client.Id <> COALESCE (ioId, 0)
                    AND tmpUnit_isOutlet.UnitId IS NULL
                 )
       THEN
            RAISE EXCEPTION '������ ����������.�������� <%> ��� ����������.', inName;
       END IF;
   END IF;
   


   -- ������������ ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

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

   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Client_Currency(), ioId, inCurrencyId);

   -- ������������ ������� ��������/�������������
   IF vbIsInsert = TRUE
   THEN
       -- ��������� �������� - ������������� (��������)
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Client_InsertUnit(), ioId, vbUnitId);
       -- ��������� �������� - ������������ (��������)
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
       -- ��������� �������� - ���� ��������
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
   ELSEIF NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Protocol_Insert() AND OL.ObjectId = ioId AND OL.ChildObjectId > 0)
   THEN
       -- ��������� �������� - ������������� (��������) - ���� ����� ���� �������� "�����"
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Client_InsertUnit(), ioId, (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_User_Unit() AND OL.ObjectId = vbUserId));

   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
07.02.20          * add CurrencyName
13.05.17                                                           *
02.03.17                                                           *
01.03.17                                                           *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Client()
