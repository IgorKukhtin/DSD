-- Function: gpInsertUpdate_Object_Maker (Integer,Integer,TVarChar, TFloat,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Maker (Integer,Integer,TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Maker (Integer,Integer,TVarChar, Integer, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Maker (Integer,Integer,TVarChar, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Maker (Integer,Integer,TVarChar, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Maker (Integer,Integer,TVarChar, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Maker (Integer,Integer,TVarChar, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Maker (Integer,Integer,TVarChar, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Maker (Integer,Integer,TVarChar, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Maker(
 INOUT ioId              Integer   ,    -- ���� ������� <�������������>
    IN inCode            Integer   ,    -- ��� ������� <>
    IN inName            TVarChar  ,    -- �������� ������� <>
    IN inCountryId       Integer   ,    -- ������
    IN inContactPersonId Integer   ,    -- ���������� ����
    IN inSendPlan        TDateTime,     -- ����� ��������� ���������(����/�����)
    IN inSendReal        TDateTime,     -- ����� ������� ������ �������� (����/�����)
    IN inDay             TFloat    ,    -- ������������� �������� � ���
    IN inMonth           TFloat    ,    -- ������������� �������� � �������
    IN inisReport1       Boolean,       -- ���������� "����� �� ��������"
    IN inisReport2       Boolean,       -- ���������� "����� �� ��������"
    IN inisReport3       Boolean,       -- ���������� "���������� �� ������ � ��������� �� ����� �������"
    IN inisReport4       Boolean,       -- ���������� "������ ������ �������"
    IN inisReport5       Boolean,       -- ���������� "����� �� ������"
    IN inisReport6       Boolean,       -- ���������� "����� �� ������ �� ����������� ������"
    IN inisReport7       Boolean,       -- ���������� "����� �� ������ ��������"
    IN inisQuarter       Boolean,       -- ���������� ������������� ����������� ������
    IN inis4Month        Boolean,       -- ���������� ������������� ������ �� 4 ������
    IN inSession         TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;    
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Maker());
   vbUserId := inSession; 

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Maker()); 
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Maker(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Maker(), vbCode_calc);
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Maker(), vbCode_calc, inName);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Maker_Country(), ioId, inCountryId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Maker_ContactPerson(), ioId, inContactPersonId);

   IF COALESCE (inDay, 0) <> 0 AND COALESCE (inMonth, 0) <> 0 
   THEN
        RAISE EXCEPTION '������.������ ���� ������ ������ ���� �������� ������������� <����> ��� <�������>.'; 
   END IF;
   
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Maker_Day(), ioId, inDay);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Maker_Month(), ioId, inMonth);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Maker_SendPlan(), ioId, inSendPlan);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Maker_SendReal(), ioId, inSendReal);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Maker_Report1(), ioId, inisReport1);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Maker_Report2(), ioId, inisReport2);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Maker_Report3(), ioId, inisReport3);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Maker_Report4(), ioId, inisReport4);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Maker_Report5(), ioId, inisReport5);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Maker_Report6(), ioId, inisReport6);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Maker_Report7(), ioId, inisReport7);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Maker_Quarter(), ioId, inisQuarter);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Maker_4Month(), ioId, inis4Month);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$ LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 14.01.20                                                       *
 07.08.19                                                       *
 05.04.19                                                       *
 03.04.19                                                       *
 18.01.19         *
 11.01.19         *
 11.02.14         *  
 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Maker()