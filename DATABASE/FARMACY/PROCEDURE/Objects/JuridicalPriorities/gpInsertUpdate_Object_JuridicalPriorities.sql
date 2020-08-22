-- Function: gpInsertUpdate_Object_JuridicalPriorities()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalPriorities(Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_JuridicalPriorities(
 INOUT ioId             Integer   ,     -- ���� ������� <> 
    IN inCode           Integer   ,     -- ��� �������  
    IN inJuridicalId    Integer   ,     -- ���������
    IN inGoodsId        Integer   ,     -- ������� �����
    IN inPriorities     TFloat    ,     -- % ���������� 
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_JuridicalPriorities());

   IF COALESCE(inJuridicalId, 0) = 0 OR COALESCE(inGoodsId, 0) = 0
   THEN
     RAISE EXCEPTION '������. �� �������� ��������� ��� �����!';
   END IF;
 
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;
   
   IF EXISTS(SELECT * FROM gpSelect_Object_JuridicalPriorities ('3') AS JuridicalPriorities
             WHERE JuridicalPriorities.ID <> COALESCE (ioId, 0)
               AND JuridicalPriorities.JuridicalId = inJuridicalId
               AND JuridicalPriorities.GoodsId = inGoodsId)
   THEN
     RAISE EXCEPTION '������. �� ������ � ���������� ��� ���� ���������!';   
   END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_JuridicalPriorities());
   
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_JuridicalPriorities(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_JuridicalPriorities(), vbCode_calc, '');

   -- ��������� ����� � <���������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_JuridicalPriorities_Juridical(), ioId, inJuridicalId);
   -- ��������� ����� � <������� �����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_JuridicalPriorities_Goods(), ioId, inGoodsId);
   
   -- ��������� % ���������� 
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_JuridicalPriorities_Priorities(), ioId, inPriorities);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.08.20                                                       *
*/

-- ����
-- 
