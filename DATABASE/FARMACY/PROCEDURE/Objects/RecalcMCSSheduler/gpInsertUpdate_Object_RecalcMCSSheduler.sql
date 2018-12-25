-- Function: gpInsertUpdate_Object_RecalcMCSSheduler()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_RecalcMCSSheduler(Integer, Integer, Integer, Boolean,
                                                                Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                                Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                                Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RecalcMCSSheduler(
 INOUT ioId                      Integer   ,   	-- ���� ������� <������� �����������>
 INOUT ioCode                    Integer   ,    -- ��� ������� <������� �����������>
 INOUT ioUnitId                  Integer,

    IN inPharmacyItem            Boolean,

    IN inPeriod                  Integer,
    IN inPeriod1                 Integer,
    IN inPeriod2                 Integer,
    IN inPeriod3                 Integer,
    IN inPeriod4                 Integer,
    IN inPeriod5                 Integer,
    IN inPeriod6                 Integer,
    IN inPeriod7                 Integer,
    IN inDay                     Integer,
    IN inDay1                    Integer,
    IN inDay2                    Integer,
    IN inDay3                    Integer,
    IN inDay4                    Integer,
    IN inDay5                    Integer,
    IN inDay6                    Integer,
    IN inDay7                    Integer,

    IN inUserId                  Integer,
    IN inIsClose                 Boolean,
    IN inSession                 TVarChar       -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbName TVarChar;

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReasonDifferences());
   vbUserId:= inSession;

   IF COALESCE (ioId, 0) = 0
   THEN
     IF EXISTS (SELECT 1 FROM ObjectLink WHERE DescId = zc_ObjectLink_RecalcMCSSheduler_Unit()
                                           AND ChildObjectId = ioUnitId)
     THEN
       SELECT ObjectId
       INTO ioId
       FROM ObjectLink
       WHERE DescId = zc_ObjectLink_RecalcMCSSheduler_Unit()
         AND ChildObjectId = ioUnitId;
     END IF;
   END IF;

   IF EXISTS (SELECT 1 FROM ObjectLink WHERE DescId = zc_ObjectLink_RecalcMCSSheduler_Unit()
                                         AND ChildObjectId = ioUnitId
                                         AND ObjectId <> ioId)
   THEN
     RAISE EXCEPTION '������. ����� ������������� � �������������..';
   END IF;

   IF COALESCE(inPeriod, 0) <= 0 OR COALESCE(inPeriod1, 0) <= 0 OR COALESCE(inPeriod2, 0) <= 0 OR COALESCE(inPeriod3, 0) <= 0 OR
      COALESCE(inPeriod4, 0) <= 0 OR COALESCE(inPeriod5, 0) <= 0 OR COALESCE(inPeriod6, 0) <= 0 OR COALESCE(inPeriod7, 0) <= 0 OR
      COALESCE(inDay, 0) <= 0 OR COALESCE(inDay1, 0) <= 0 OR COALESCE(inDay2, 0) <= 0 OR COALESCE(inDay3, 0) <= 0 OR
      COALESCE(inDay4, 0) <= 0 OR COALESCE(inDay5, 0) <= 0 OR COALESCE(inDay6, 0) <= 0 OR COALESCE(inDay7, 0) <= 0
   THEN
     RAISE EXCEPTION '������. �� ��������� ��� ���������..';
   END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   ioCode:= lfGet_ObjectCode (ioCode, zc_Object_RecalcMCSSheduler());
   vbName := '����������� �������� ��� '||ioCode::TVarChar;

   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_RecalcMCSSheduler(), vbName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_RecalcMCSSheduler(), ioCode);

   -- ��������� ������
   ioId := lpInsertUpdate_Object (ioId, zc_Object_RecalcMCSSheduler(), ioCode, vbName, NULL);

   -- ��������� ����� � <���� ��. ����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RecalcMCSSheduler_Unit(), ioId, ioUnitId);

   --���������
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Unit_PharmacyItem(), ioUnitId, inPharmacyItem);

   -- ��������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period(), ioUnitId, inPeriod);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period1(), ioUnitId, inPeriod1);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period2(), ioUnitId, inPeriod2);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period3(), ioUnitId, inPeriod3);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period4(), ioUnitId, inPeriod4);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period5(), ioUnitId, inPeriod5);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period6(), ioUnitId, inPeriod6);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Period7(), ioUnitId, inPeriod7);

   -- ��������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day(), ioUnitId, inDay);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day1(), ioUnitId, inDay1);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day2(), ioUnitId, inDay2);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day3(), ioUnitId, inDay3);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day4(), ioUnitId, inDay4);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day5(), ioUnitId, inDay5);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day6(), ioUnitId, inDay6);
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Day7(), ioUnitId, inDay7);


   -- ��������� ����� � <�����������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RecalcMCSSheduler_User(), ioId, inUserId);

   -- ��������
   UPDATE Object SET isErased = inIsClose WHERE Id = ioId;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_RecalcMCSSheduler(Integer, Integer, Integer, Boolean,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                       Integer, Boolean, TVarChar) OWNER TO postgres;


------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.12.18                                                       *

*/