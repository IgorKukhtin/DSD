-- Function: gpInsertUpdate_Object_Retail()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, TFloat, TFloat, TFloat, TFloat, Boolean, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Retail(
 INOUT ioId                    Integer   ,     -- ���� ������� <�������� ����> 
    IN inCode                  Integer   ,     -- ��� �������  
    IN inName                  TVarChar  ,     -- �������� ������� 
    IN inMarginPercent         TFloat    ,     --
    IN inSummSUN               TFloat    ,     --
    IN inLimitSUN              TFloat    ,     --
    IN inShareFromPrice        TFloat    ,     --
    IN inisGoodsReprice        Boolean   ,     --��������� � ������ "���������� � �����"
    IN inOccupancySUN          TFloat    ,     --������������� ��������� �� ��� 
    IN inSession               TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Retail());

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Retail());
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Retail(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Retail(), vbCode_calc);
  
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Retail(), vbCode_calc, inName);
   
   -- ��������� ��-�� <��� GLN - ����������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Retail_MarginPercent(), ioId, inMarginPercent);

   -- ��������� ��-�� <�����, ��� ������� ���������� ���>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Retail_SummSUN(), ioId, inSummSUN);
   
   -- ��������� ��-�� <����� ��� ������� (����������� ���)>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Retail_LimitSUN(), ioId, inLimitSUN);

   -- ��������� ��-�� <������ ���������� �� ����>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Retail_ShareFromPrice(), ioId, inShareFromPrice);

   -- ��������� ��-�� <��������� � ������ "���������� � �����">
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Retail_GoodsReprice(), ioId, inisGoodsReprice);

   -- ��������� ��-�� <������������� ��������� �� ���>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Retail_OccupancySUN(), ioId, inOccupancySUN);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.04.20                                                       * add OccupancySUN
 17.12.19         * add inisGoodsReprice
 11.12.19                                                       * LimitSUN
 23.07.19         * inSummSUN
 23.03.19         *
*/

-- ����
--