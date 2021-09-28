-- Function: gpUpdate_Object_Member_Transport(Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Member_Transport (Integer, TVarChar, TDateTime, TDateTime, Tfloat, Tfloat, Tfloat, Tfloat, Tfloat, TVarChar);



CREATE OR REPLACE FUNCTION gpUpdate_Object_Member_Transport(
    IN inId	             Integer   ,    -- ���� ������� <���������� ����> 
    IN inDriverCertificate   TVarChar  ,    -- ������������ ������������� 
    IN inStartSummerDate     TDateTime ,    -- ��������� ���� ��� ����� ���� ����
    IN inEndSummerDate       TDateTime ,    -- �������� ���� ��� ����� ���� ����
    IN inSummerFuel          Tfloat    ,    -- ����� ���� ����� ����
    IN inWinterFuel          Tfloat    ,    -- ����� ���� ����� ����
    IN inReparation          Tfloat    ,    -- ����������� �� 1 ��., ���.
    IN inLimit               Tfloat    ,    -- ����� ���
    IN inLimitDistance       Tfloat    ,    -- ����� �����
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- !!! ��� �������� !!!
   -- IF COALESCE(ioId, 0) = 0
   -- THEN ioId := (SELECT Id FROM Object WHERE ValueData = inName AND DescId = zc_Object_Member());
   -- END IF;

   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Member_Transport());
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_DriverCertificate(), inId, inDriverCertificate);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_StartSummer(), inId, inStartSummerDate);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_EndSummer(), inId, inEndSummerDate);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Member_Summer(), inId, inSummerFuel);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Member_Winter(), inId, inWinterFuel);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Member_Reparation(), inId, inReparation);


   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Member_Limit(), inId, inLimit);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Member_LimitDistance(), inId, inLimitDistance);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.01.16         * 
*/