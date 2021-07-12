-- Function: gpInsertUpdate_Object_MobileEmployee  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MobileEmployee2 (Integer,Integer,TVarChar,TFloat,TFloat,TFloat,TVarChar,Integer,Integer,TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MobileEmployee2 (Integer,Integer,TVarChar,TFloat,TFloat,TFloat,TVarChar,Integer,Integer,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MobileEmployee2 (Integer,Integer,TVarChar,TFloat,TFloat,TFloat,TVarChar,Integer,Integer,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MobileEmployee2(
 INOUT ioId                       Integer   ,    -- ���� ������� <> 
    IN inCode                     Integer   ,    -- ��� ������� <>
    IN inName                     TVarChar  ,    -- �������� ������� <>
    IN inLimit                    TFloat    ,    -- ����� 
    IN inDutyLimit                TFloat    ,    -- ��������� �����
    IN inNavigator                TFloat    ,    -- ������ ����������
    IN inComment                  TVarChar  ,    -- �����������
    IN inPersonalId               Integer   ,    -- ���������
    IN inMobileTariffId           Integer   ,    -- �����
    IN inRegionId                 Integer   ,    -- ������
    IN inMobilePackId             Integer   ,    -- �������� ������
    IN inSession                  TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer; 
   DECLARE vbObjectId Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_MobileEmployee());

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object_MobileEmployee2(ioId             :=  ioId
                                               , inCode           := inCode
                                               , inName           := inName
                                               , inLimit          := inLimit
                                               , inDutyLimit      := inDutyLimit
                                               , inNavigator      := inNavigator
                                               , inComment        := inComment
                                               , inPersonalId     := inPersonalId
                                               , inMobileTariffId := inMobileTariffId
                                               , inRegionId       := inRegionId
                                               , inMobilePackId   := inMobilePackId
                                               , inUserId         := vbUserId
                                                 );
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.07.21         *
 03.02.17         * add inRegionId
 05.10.16         * parce
 23.09.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_MobileEmployee2(ioId := 0 , inCode := 1 , inName := '�����' , inLimit := '4444' , DutyLimit := '���@kjjkj' , Comment := '' , inPartnerId := 258441 , inJuridicalId := 0 , inPersonalId := 0 , inMobileEmployeeKindId := 153272 ,  inSession := '5');
