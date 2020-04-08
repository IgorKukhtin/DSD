DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SeasonalityCoefficient(Integer, Integer, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_SeasonalityCoefficient(
 INOUT ioId                    Integer   ,     -- ���� ������� <�������� ����> 
    IN inCode                  Integer   ,     -- ��� �������  
    IN inName                  TVarChar  ,     -- �������� ������� 
    IN Koeff1                  TFloat    ,     --
    IN Koeff2                  TFloat    ,     --
    IN Koeff3                  TFloat    ,     --
    IN Koeff4                  TFloat    ,     --
    IN Koeff5                  TFloat    ,     --
    IN Koeff6                  TFloat    ,     --
    IN Koeff7                  TFloat    ,     --
    IN Koeff8                  TFloat    ,     --
    IN Koeff9                  TFloat    ,     --
    IN Koeff10                 TFloat    ,     --
    IN Koeff11                 TFloat    ,     --
    IN Koeff12                 TFloat    ,     --
    IN inSession               TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE(ioId, 0) = 0
   THEN
     IF EXISTS(SELECT 1 FROM Object WHERE Object.DescId = zc_Object_SeasonalityCoefficient())
     THEN
       ioId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_SeasonalityCoefficient());
     END IF;
   END IF;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_SeasonalityCoefficient());
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_SeasonalityCoefficient(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_SeasonalityCoefficient(), vbCode_calc);
  
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_SeasonalityCoefficient(), vbCode_calc, inName);
   
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_SeasonalityCoefficient_Koeff1(), ioId, Koeff1);
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_SeasonalityCoefficient_Koeff2(), ioId, Koeff2);
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_SeasonalityCoefficient_Koeff3(), ioId, Koeff3);
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_SeasonalityCoefficient_Koeff4(), ioId, Koeff4);
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_SeasonalityCoefficient_Koeff5(), ioId, Koeff5);
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_SeasonalityCoefficient_Koeff6(), ioId, Koeff6);
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_SeasonalityCoefficient_Koeff7(), ioId, Koeff7);
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_SeasonalityCoefficient_Koeff8(), ioId, Koeff8);
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_SeasonalityCoefficient_Koeff9(), ioId, Koeff9);
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_SeasonalityCoefficient_Koeff10(), ioId, Koeff10);
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_SeasonalityCoefficient_Koeff11(), ioId, Koeff11);
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_SeasonalityCoefficient_Koeff12(), ioId, Koeff12);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.04.20                                                       * add isGoodsReprice
*/

-- ����
--
